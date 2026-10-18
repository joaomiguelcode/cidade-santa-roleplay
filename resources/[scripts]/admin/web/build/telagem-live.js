(function () {
    'use strict';
    var active = null;
    var resource = typeof GetParentResourceName === 'function' ? GetParentResourceName() : 'admin';

    function report(sessionId, answer, error) {
        return fetch('https://' + resource + '/telagemLiveAnswer', {
            method: 'POST', headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ sessionId: sessionId, answer: answer, error: error })
        }).catch(function () {});
    }

    function stop() {
        if (!active) return;
        var old = active;
        active = null;
        clearTimeout(old.deadline);
        clearInterval(old.watchdog);
        if (old.peer) old.peer.close();
        if (old.stream) old.stream.getTracks().forEach(function (track) { track.stop(); });
        if (window.ClipperLiveCapture) window.ClipperLiveCapture.release();
    }

    function gather(peer) {
        return new Promise(function (resolve, reject) {
            var settle;
            var servers = peer.getConfiguration ? peer.getConfiguration().iceServers || [] : [];
            var wantsRelay = servers.some(function (server) {
                return (Array.isArray(server.urls) ? server.urls : [server.urls]).some(function (url) { return /^turns?:/i.test(url); });
            });
            var timer = setTimeout(function () {
                cleanup();
                if (/^a=candidate:/m.test(peer.localDescription && peer.localDescription.sdp || '')) resolve();
                else reject(new Error('ice timeout'));
            }, 10000);
            function cleanup() {
                clearTimeout(timer); clearTimeout(settle);
                peer.removeEventListener('icegatheringstatechange', changed);
                peer.removeEventListener('icecandidate', candidate);
            }
            function candidate(event) {
                if (event.candidate && (event.candidate.type === 'relay' || (!wantsRelay && event.candidate.type === 'srflx'))) {
                    clearTimeout(settle); settle = setTimeout(function () { cleanup(); resolve(); }, 750);
                }
            }
            function changed() { if (peer.iceGatheringState === 'complete') { cleanup(); resolve(); } }
            peer.addEventListener('icegatheringstatechange', changed);
            peer.addEventListener('icecandidate', candidate);
            changed();
        });
    }

    async function start(payload) {
        stop();
        var current = { id: payload.sessionId, peer: null, stream: null, lastAlive: Date.now() };
        active = current;
        current.deadline = setTimeout(stop, 300000);
        current.watchdog = setInterval(function () {
            if (active === current && Date.now() - current.lastAlive > 30000) stop();
        }, 5000);
        try {
            if (!window.RTCPeerConnection || !window.ClipperLiveCapture) throw new Error('capture unavailable');
            current.stream = window.ClipperLiveCapture.acquire();
            // Empty Lua tables can arrive as objects after the server/client hop.
            // RTCConfiguration requires a sequence, even when no relay is configured.
            current.peer = new RTCPeerConnection({ iceServers: Array.isArray(payload.iceServers) ? payload.iceServers : [] });
            current.peer.ondatachannel = function (event) {
                event.channel.onmessage = function () { current.lastAlive = Date.now(); };
                event.channel.onclose = function () { if (active === current) stop(); };
            };
            current.peer.onconnectionstatechange = function () {
                if (active === current && ['failed', 'closed'].indexOf(current.peer.connectionState) >= 0) stop();
            };
            current.stream.getVideoTracks().forEach(function (track) { current.peer.addTrack(track, current.stream); });
            await current.peer.setRemoteDescription({ type: 'offer', sdp: payload.offer });
            if (active !== current) return;
            await current.peer.setLocalDescription(await current.peer.createAnswer());
            await gather(current.peer);
            if (active !== current) return;
            var sender = current.peer.getSenders().filter(function (item) { return item.track && item.track.kind === 'video'; })[0];
            if (sender && sender.setParameters) {
                var params = sender.getParameters();
                params.encodings = params.encodings && params.encodings.length ? params.encodings : [{}];
                params.encodings[0].maxBitrate = 1500000;
                params.encodings[0].maxFramerate = 24;
                // Um buffer ja armado pode ter resolucao maior; nao redimensionar o clipe.
                params.encodings[0].scaleResolutionDownBy = Math.max(1, current.stream.getVideoTracks()[0].getSettings().width / 960 || 1);
                try {
                    await sender.setParameters(params);
                } catch (error) {
                    // Older CEF builds reject optional frame-rate/scaling controls.
                    // Keep the bandwidth cap; the capture loop already limits FPS.
                    delete params.encodings[0].maxFramerate;
                    delete params.encodings[0].scaleResolutionDownBy;
                    await sender.setParameters(params);
                }
            }
            if (active === current) {
                current.lastAlive = Date.now();
                await report(current.id, current.peer.localDescription.sdp);
            }
        } catch (error) {
            if (active === current) {
                await report(current.id, null, current.stream ? 'SIGNALING_FAILED' : 'CAPTURE_UNAVAILABLE');
                stop();
            }
        }
    }

    window.addEventListener('message', function (event) {
        var data = event.data;
        if (!data || data.telagemLive !== true) return;
        if (data.action === 'start' && data.payload) start(data.payload);
        if (data.action === 'stop' && active && data.sessionId === active.id) stop();
    });
    window.addEventListener('pagehide', stop);
}());
