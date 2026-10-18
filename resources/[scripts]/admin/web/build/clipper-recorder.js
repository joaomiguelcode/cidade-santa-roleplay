(function () {
    'use strict';

    // O recorder vive dentro da pagina do admin, entao os callbacks da NUI sao os
    // dele. O fallback so cobre o caso de a native nao existir.
    var RESOURCE = (typeof GetParentResourceName === 'function') ? GetParentResourceName() : 'admin';

    // Sem inverter o V. O screenshot-basic inverte porque renderiza para um
    // WebGLRenderTarget e le com readRenderTargetPixels, que devolve a imagem de baixo
    // para cima antes do putImageData; aqui o desenho vai direto para o canvas, entao
    // repetir aquele flip deixava o clipe de cabeca para baixo.
    var VERTEX_SHADER = [
        'attribute vec2 aPosition;',
        'varying vec2 vUv;',
        'void main() {',
        '    vUv = vec2( (aPosition.x + 1.0) * 0.5, (aPosition.y + 1.0) * 0.5 );',
        '    gl_Position = vec4( aPosition, 0.0, 1.0 );',
        '}'
    ].join('\n');

    var FRAGMENT_SHADER = [
        'precision mediump float;',
        'varying vec2 vUv;',
        'uniform sampler2D uGame;',
        'void main() {',
        '    gl_FragColor = texture2D( uGame, vUv );',
        '}'
    ].join('\n');

    var MIME_BY_CODEC = {
        vp8: [
            'video/webm;codecs=vp8,opus',
            'video/webm;codecs=vp8',
            'video/webm;codecs=vp9,opus',
            'video/webm'
        ],
        vp9: [
            'video/webm;codecs=vp9,opus',
            'video/webm;codecs=vp8,opus',
            'video/webm;codecs=vp8',
            'video/webm'
        ]
    };

    // Duas camadas: o WebGL recebe a textura do jogo e o canvas 2D e o que vai para o
    // `captureStream`. A copia intermediaria e o preco de poder desenhar por cima do
    // video (a tarja de evidencia); `burnInOverlay` desliga a tarja, nao a copia.
    // A pagina e compartilhada com o app React do admin (Ban Window), entao nada de
    // procurar elementos dela: o recorder cria e estiliza os proprios, fora do fluxo
    // de layout e sem receber clique.
    var outCanvas = document.createElement('canvas');
    var glCanvas = document.createElement('canvas');

    outCanvas.id = 'clipper-stage';
    outCanvas.setAttribute('style', [
        'position:fixed', 'top:0', 'left:0', 'width:1px', 'height:1px',
        'opacity:0', 'pointer-events:none', 'z-index:-1'
    ].join(';'));

    (document.body || document.documentElement).appendChild(outCanvas);

    var ctx = null;
    var gl = null;
    var rafId = null;

    var overlay = {
        text: '',
        nextRefreshAt: 0
    };

    // Buffer retroativo: N gravadores defasados, cada um produzindo segmentos WebM
    // completos e autonomos. O mais antigo em execucao sempre tem entre `durationMs`
    // e `segmentMs` de video acumulado, entao fecha-lo no `/clipe` devolve os ultimos
    // segundos ja gravados, sem precisar remendar containers pela metade.
    var state = {
        config: null,
        armed: false,
        live: false,
        capturing: false,
        micStream: null,
        slots: []
    };

    // Contadores do HUD. Somar bytes e frames e barato o bastante para ficar sempre
    // ligado; o que custa (montar o texto, tocar no DOM) so roda com o HUD aberto.
    var metrics = {
        drawnFrames: 0,
        windowFrames: 0,
        windowStart: 0,
        drawFps: 0,
        encodedBytes: 0,
        windowBytes: 0,
        encodeKbps: 0,
        bufferBytes: 0,
        gameFps: 0,
        gameFrameMs: 0,
        armedAt: 0,
        lastCapture: null,
        lastError: '',
        micStatus: 'nao solicitado',
        transport: '-',
        uploadProgress: '-',
        uploadRate: '-',
        overlay: null,
        timer: null
    };

    function post(callback, body) {
        return fetch('https://' + RESOURCE + '/' + callback, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json; charset=UTF-8' },
            body: JSON.stringify(body || {})
        }).catch(function () { /* a NUI pode ter sido descarregada */ });
    }

    function fail(sessionId, reason) {
        metrics.lastError = String(reason);

        post('clipper:failed', { sessionId: sessionId || null, reason: metrics.lastError });
    }

    function compile(type, source) {
        var shader = gl.createShader(type);

        gl.shaderSource(shader, source);
        gl.compileShader(shader);

        if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS)) {
            throw new Error('shader: ' + gl.getShaderInfoLog(shader));
        }

        return shader;
    }

    // O contexto e o quad sao criados uma unica vez e reaproveitados entre armadas.
    function ensureContext() {
        if (gl) {
            return;
        }

        gl = glCanvas.getContext('webgl', {
            alpha: false,
            antialias: false,
            depth: false,
            stencil: false,
            preserveDrawingBuffer: !!state.config.preserveDrawingBuffer,
            powerPreference: 'low-power'
        });

        if (!gl) {
            throw new Error('webgl unavailable');
        }

        var program = gl.createProgram();

        gl.attachShader(program, compile(gl.VERTEX_SHADER, VERTEX_SHADER));
        gl.attachShader(program, compile(gl.FRAGMENT_SHADER, FRAGMENT_SHADER));
        gl.linkProgram(program);

        if (!gl.getProgramParameter(program, gl.LINK_STATUS)) {
            throw new Error('program: ' + gl.getProgramInfoLog(program));
        }

        gl.useProgram(program);

        var buffer = gl.createBuffer();

        gl.bindBuffer(gl.ARRAY_BUFFER, buffer);
        gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([-1, -1, 3, -1, -1, 3]), gl.STATIC_DRAW);

        var location = gl.getAttribLocation(program, 'aPosition');

        gl.enableVertexAttribArray(location);
        gl.vertexAttribPointer(location, 2, gl.FLOAT, false, 0, 0);

        // Handshake do CEF do FiveM, replicado na ordem exata do CfxTexture do
        // @citizenfx/three (ver `isCfxTexture` no bundle do screenshot-basic):
        // parametros -> textura RGB 1x1 com unpackAlignment 1 -> e entao a sequencia
        // de tres TEXTURE_WRAP_T abaixo, que e o sinal que faz o CEF trocar o
        // conteudo dessa textura pelo backbuffer do jogo. Sem os tres, a textura
        // continua sendo o pixel 1x1 e o clipe sai preto.
        var texture = gl.createTexture();

        gl.activeTexture(gl.TEXTURE0);
        gl.bindTexture(gl.TEXTURE_2D, texture);
        gl.pixelStorei(gl.UNPACK_FLIP_Y_WEBGL, false);
        gl.pixelStorei(gl.UNPACK_PREMULTIPLY_ALPHA_WEBGL, false);
        gl.pixelStorei(gl.UNPACK_ALIGNMENT, 1);

        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);

        gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGB, 1, 1, 0, gl.RGB, gl.UNSIGNED_BYTE, new Uint8Array(3));

        gl.texParameterf(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
        gl.texParameterf(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.MIRRORED_REPEAT);
        gl.texParameterf(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.REPEAT);

        gl.uniform1i(gl.getUniformLocation(program, 'uGame'), 0);
    }

    // Tarja de evidencia queimada no video. A NUI dos outros resources nao e alcancavel
    // de dentro desta pagina (cada uma e um browser CEF isolado), entao o clipe nao tem
    // o HUD do admin; ao menos ele passa a se identificar sozinho.
    function drawOverlay(now) {
        if (now >= overlay.nextRefreshAt) {
            var stamp = new Date().toLocaleString('pt-BR');

            overlay.text = state.config.overlayLabel
                ? (state.config.overlayLabel + '  ' + stamp)
                : stamp;

            overlay.nextRefreshAt = now + 1000;
        }

        var height = Math.max(18, Math.round(state.config.height * 0.033));
        var top = state.config.height - height;

        ctx.fillStyle = 'rgba(0, 0, 0, 0.55)';
        ctx.fillRect(0, top, state.config.width, height);

        ctx.font = Math.round(height * 0.62) + 'px Consolas, monospace';
        ctx.fillStyle = '#ffffff';
        ctx.textBaseline = 'middle';
        ctx.fillText(overlay.text, Math.round(height * 0.4), top + (height / 2));
    }

    function startRenderLoop(fps) {
        if (rafId !== null) {
            return;
        }

        var minDelta = 1000 / fps;
        var tolerance = minDelta / 2;
        var last = 0;

        function frame(now) {
            rafId = window.requestAnimationFrame(frame);

            // O rAF acorda em passos discretos, entao exigir o intervalo inteiro faz
            // cada quadro esperar o passo seguinte e o ritmo real ficar sempre abaixo
            // do alvo (a 24 fps, ~20). A tolerancia de meio passo corrige isso, e a
            // referencia avanca pelo intervalo nominal para o erro nao acumular.
            var delta = now - last;

            if (delta < minDelta - tolerance) {
                return;
            }

            last = delta < minDelta * 2 ? last + minDelta : now;

            gl.drawArrays(gl.TRIANGLES, 0, 3);

            ctx.drawImage(glCanvas, 0, 0, state.config.width, state.config.height);

            if (state.config.burnInOverlay) {
                drawOverlay(now);
            }

            metrics.drawnFrames += 1;
            metrics.windowFrames += 1;
        }

        rafId = window.requestAnimationFrame(frame);
    }

    function stopRenderLoop() {
        if (rafId !== null) {
            window.cancelAnimationFrame(rafId);
            rafId = null;
        }
    }

    function pickMime() {
        var preferred = (state.config && state.config.preferredCodec) || 'vp8';
        var candidates = MIME_BY_CODEC[preferred] || MIME_BY_CODEC.vp8;

        for (var index = 0; index < candidates.length; index += 1) {
            if (MediaRecorder.isTypeSupported(candidates[index])) {
                return candidates[index];
            }
        }

        return '';
    }

    // Tenta direto: no CEF do FiveM `navigator.permissions` responde `prompt` mesmo com
    // a permissao ja concedida, e usa-la como portao barrava a chamada que funcionaria.
    function microphoneIfAllowed() {
        return requestMicrophone().then(function (stream) {
            if (!stream) {
                post('clipper:micPending', {});
                scheduleMicRetry();
            }

            return stream;
        });
    }

    // Cobre a permissao concedida depois do arm: sem isto o clipe gravaria sem audio
    // ate o proximo restart do resource.
    function scheduleMicRetry() {
        if (state.micRetry) {
            return;
        }

        state.micRetry = window.setInterval(function () {
            if (!state.armed || state.micStream || !state.config || !state.config.captureMicrophone) {
                window.clearInterval(state.micRetry);
                state.micRetry = 0;

                return;
            }

            requestMicrophone().then(function (stream) {
                if (!stream || !state.armed || state.micStream) {
                    if (stream) {
                        stream.getTracks().forEach(function (track) { track.stop(); });
                    }

                    return;
                }

                window.clearInterval(state.micRetry);
                state.micRetry = 0;

                // Refazer o buffer e o que injeta a trilha nos gravadores.
                stream.getTracks().forEach(function (track) { track.stop(); });

                var config = state.config;

                disarm();
                arm(config).catch(function (error) {
                    disarm();
                    fail(null, 'rearm_failed: ' + ((error && error.message) || error));
                });
            });
        }, (state.config && state.config.micRetryMs) || 30000);
    }

    var RAW_AUDIO = { echoCancellation: false, noiseSuppression: false, autoGainControl: false };

    // Um dispositivo de loopback ("Mixagem estereo", "Stereo Mix", "What U Hear") e a
    // saida da placa de som virada em entrada: capturando por ele, o clipe leva tudo
    // que o admin OUVE - Mumble, jogo, tudo ja mixado e em sincronia nativa. O mic
    // comum so traz a voz do proprio admin, porque a voz dos outros sai pelo fone e
    // nunca entra no microfone.
    //
    // Nem toda placa expoe isso, e no Windows costuma vir desativado, entao e sempre
    // melhor-esforco: sem loopback, cai no dispositivo padrao.
    function findLoopbackDevice(patterns) {
        if (!navigator.mediaDevices || !navigator.mediaDevices.enumerateDevices) {
            return Promise.resolve(null);
        }

        return navigator.mediaDevices.enumerateDevices().then(function (devices) {
            var found = null;

            devices.forEach(function (device) {
                if (found || device.kind !== 'audioinput') {
                    return;
                }

                var label = (device.label || '').toLowerCase();

                patterns.forEach(function (pattern) {
                    if (!found && label.indexOf(pattern) !== -1) {
                        found = device;
                    }
                });
            });

            return found;
        }, function () { return null; });
    }

    // Os rotulos so existem depois da permissao concedida.
    function listAudioInputs() {
        if (!navigator.mediaDevices || !navigator.mediaDevices.enumerateDevices) {
            return Promise.resolve([]);
        }

        return navigator.mediaDevices.enumerateDevices().then(function (devices) {
            return devices
                .filter(function (device) { return device.kind === 'audioinput'; })
                .map(function (device) { return device.label || '(sem rotulo)'; });
        }, function () { return []; });
    }

    function requestMicrophone() {
        if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
            metrics.micStatus = 'indisponivel no CEF';

            return Promise.resolve(null);
        }

        var patterns = (state.config && state.config.loopbackDevicePatterns) || [];

        return navigator.mediaDevices
            .getUserMedia({ audio: RAW_AUDIO, video: false })
            .then(function (stream) {
                metrics.micStatus = 'concedido (microfone)';

                if (!patterns.length) {
                    return stream;
                }

                // Os labels dos dispositivos so aparecem depois da permissao, por isso
                // a busca acontece aqui e nao antes.
                return findLoopbackDevice(patterns).then(function (device) {
                    if (!device) {
                        return stream;
                    }

                    var constraints = { audio: { deviceId: { exact: device.deviceId } }, video: false };

                    Object.keys(RAW_AUDIO).forEach(function (key) {
                        constraints.audio[key] = RAW_AUDIO[key];
                    });

                    return navigator.mediaDevices.getUserMedia(constraints).then(function (loopback) {
                        stream.getTracks().forEach(function (track) { track.stop(); });

                        metrics.micStatus = 'loopback: ' + device.label;

                        return loopback;
                    }, function () {
                        return stream;
                    });
                });
            }, function (error) {
                // NotAllowedError aqui quase sempre significa que o prompt nativo do
                // FiveM nao pode ser aceito: a pagina roda sem foco de NUI.
                metrics.micStatus = 'negado (' + ((error && error.name) || error) + ') - use /clipe-mic';

                return null;
            });
    }

    // Cada gravador recebe o proprio stream: o video sai do mesmo canvas e as trilhas
    // de microfone sao clones, para que parar um segmento nao derrube os outros.
    function buildStream() {
        var stream = outCanvas.captureStream(state.config.fps);

        if (state.micStream) {
            state.micStream.getAudioTracks().forEach(function (track) {
                stream.addTrack(track.clone());
            });
        }

        return stream;
    }

    function finishSegment(slot, recorder, parts, stream) {
        stream.getTracks().forEach(function (track) { track.stop(); });

        var blob = new Blob(parts, { type: 'video/webm' });

        // O segmento sai do buffer retroativo assim que o container fecha.
        metrics.bufferBytes -= slot.bytes;
        slot.bytes = 0;

        if (slot.captureRecorder === recorder) {
            var resolve = slot.captureResolve;

            slot.captureRecorder = null;
            slot.captureResolve = null;
            slot.recorder = null;

            resolve(blob);

            return;
        }

        // Segmento descartado: ou rotacionou normalmente, ou o buffer foi desarmado.
        if (slot.recorder !== recorder) {
            return;
        }

        slot.recorder = null;

        if (state.armed) {
            scheduleSlot(slot, 0);
        }
    }

    function openSlot(slot) {
        var config = state.config;
        var stream = buildStream();
        var parts = [];

        var options = {
            videoBitsPerSecond: config.videoBitrate,
            audioBitsPerSecond: config.audioBitrate
        };

        var mime = pickMime();

        if (mime) {
            options.mimeType = mime;
        }

        var recorder = new MediaRecorder(stream, options);

        recorder.ondataavailable = function (event) {
            if (!event.data || event.data.size <= 0) {
                return;
            }

            parts.push(event.data);

            slot.bytes += event.data.size;

            metrics.encodedBytes += event.data.size;
            metrics.windowBytes += event.data.size;
            metrics.bufferBytes += event.data.size;
        };

        recorder.onstop = function () {
            finishSegment(slot, recorder, parts, stream);
        };

        recorder.onerror = function () {
            finishSegment(slot, recorder, parts, stream);
        };

        slot.recorder = recorder;
        slot.startedAt = window.performance.now();

        recorder.start(1000);

        slot.timer = window.setTimeout(function () {
            rotateSlot(slot);
        }, config.segmentMs);
    }

    function scheduleSlot(slot, delay) {
        window.clearTimeout(slot.timer);

        slot.timer = window.setTimeout(function () {
            if (state.armed) {
                openSlot(slot);
            }
        }, delay);
    }

    function rotateSlot(slot) {
        if (!slot.recorder || slot.captureRecorder) {
            return;
        }

        // `finishSegment` reabre o slot assim que o container for fechado.
        slot.recorder.stop();
    }

    function closeAllSlots() {
        state.slots.forEach(function (slot) {
            window.clearTimeout(slot.timer);

            if (slot.recorder && slot.recorder.state !== 'inactive') {
                slot.recorder.stop();
            }

            slot.recorder = null;
        });
    }

    // Depois de um clipe a defasagem entre os gravadores fica quebrada, entao o buffer
    // e reconstruido do zero. O cooldown do comando cobre o tempo de reaquecimento.
    function restage() {
        state.armed = false;

        closeAllSlots();

        state.armed = true;

        var stagger = state.config.segmentMs / state.slots.length;

        state.slots.forEach(function (slot, index) {
            scheduleSlot(slot, Math.round(index * stagger));
        });
    }

    function disarm() {
        state.armed = false;

        if (state.micRetry) {
            window.clearInterval(state.micRetry);
            state.micRetry = 0;
        }

        closeAllSlots();
        if (!state.live) stopRenderLoop();

        if (state.micStream) {
            state.micStream.getTracks().forEach(function (track) { track.stop(); });
            state.micStream = null;
        }

        metrics.bufferBytes = 0;
        metrics.armedAt = 0;
    }

    function arm(config) {
        if (state.armed) {
            return Promise.resolve();
        }

        if (state.live) stopRenderLoop();

        state.config = config;
        state.slots = [];

        glCanvas.width = config.width;
        glCanvas.height = config.height;

        outCanvas.width = config.width;
        outCanvas.height = config.height;

        ensureContext();

        ctx = outCanvas.getContext('2d', { alpha: false });

        if (!ctx) {
            return Promise.reject(new Error('canvas 2d indisponivel'));
        }

        gl.viewport(0, 0, config.width, config.height);

        overlay.nextRefreshAt = 0;

        var total = Math.max(2, config.recorders);

        for (var index = 0; index < total; index += 1) {
            state.slots.push({
                timer: null,
                recorder: null,
                startedAt: 0,
                bytes: 0,
                captureRecorder: null,
                captureResolve: null
            });
        }

        startRenderLoop(state.live ? Math.max(config.fps, 24) : config.fps);

        return (config.captureMicrophone ? microphoneIfAllowed() : Promise.resolve(null)).then(function (audio) {
            state.micStream = audio;
            state.armed = true;

            metrics.armedAt = window.performance.now();
            metrics.windowStart = metrics.armedAt;

            var stagger = config.segmentMs / total;

            state.slots.forEach(function (slot, index) {
                scheduleSlot(slot, Math.round(index * stagger));
            });
        });
    }

    // Captura sob demanda para WebRTC: reusa o buffer visual do CEF, sem
    // gravadores retroativos nem audio. O clipper normal conserva sua autoridade.
    window.ClipperLiveCapture = {
        acquire: function () {
            if (state.live) throw new Error('live capture busy');
            state.live = true;
            if (!state.armed) {
                state.config = { width: 960, height: 540, fps: 24, preserveDrawingBuffer: false, burnInOverlay: false };
                glCanvas.width = outCanvas.width = 960;
                glCanvas.height = outCanvas.height = 540;
                ensureContext();
                ctx = outCanvas.getContext('2d', { alpha: false });
                if (!ctx) throw new Error('canvas unavailable');
                gl.viewport(0, 0, 960, 540);
                startRenderLoop(24);
            } else {
                // O buffer de suspeitos grava a 15 FPS; a telagem precisa de 24.
                // Os MediaRecorders conservam suas tracks e o FPS configurado.
                stopRenderLoop();
                startRenderLoop(Math.max(state.config.fps, 24));
            }
            return outCanvas.captureStream(24);
        },
        release: function () {
            if (!state.live) return;
            state.live = false;
            stopRenderLoop();
            if (state.armed) startRenderLoop(state.config.fps);
        }
    };

    function oldestRunningSlot() {
        var oldest = null;

        state.slots.forEach(function (slot) {
            if (!slot.recorder || slot.recorder.state !== 'recording') {
                return;
            }

            if (!oldest || slot.startedAt < oldest.startedAt) {
                oldest = slot;
            }
        });

        return oldest;
    }


    // Envio direto da NUI para a API, sem passar pelo servidor da cidade.
    //
    // Existe porque o caminho por evento cobra caro do servidor: ele recebe o clipe
    // inteiro em pedacos, segura alguns MB em memoria e ainda monta o multipart na
    // propria thread - com varios bans juntos isso pesa na cidade. Aqui o arquivo sai
    // direto da maquina do admin e o servidor so recebe o resultado.
    //
    // NAO funciona enquanto a API nao devolver CORS: verificado que hoje ela responde
    // 204 ao preflight sem `Access-Control-Allow-Origin`, entao o Chromium bloqueia a
    // leitura da resposta. Ver `Clipper.uploadFrom`.
    // O caminho de uma requisicao so continua valendo para clipe pequeno: menos ida e
    // volta, e e o caminho ja rodado em producao. Fatiar so entra quando o arquivo se
    // aproxima do corte do CEF, ou quando falta o que o envio em partes exige.
    function uploadClip(config, session, blob) {
        var threshold = config.chunkThresholdBytes || 0;
        var chunked = threshold > 0
            && blob.size > threshold
            && session.uploadsUrl
            && window.crypto
            && window.crypto.subtle;

        var startedAt = window.performance.now();

        if (!chunked) {
            return uploadDirect(config, session, blob);
        }

        return uploadChunked(config, session, blob).then(function (result) {
            var seconds = (window.performance.now() - startedAt) / 1000;

            metrics.uploadProgress = result.status + ' em ' + seconds.toFixed(1) + 's';

            post('clipper:uploaded', {
                sessionId: session.sessionId,
                token: session.token,
                status: result.status,
                bytes: blob.size,
                seconds: seconds,
                body: (result.body || '').slice(0, 4096)
            });

            if (result.status < 200 || result.status >= 300) {
                throw apiError(result.status, result.body);
            }
        }, function (error) {
            var reason = (error && error.message) || String(error);

            metrics.uploadProgress = 'falhou: ' + reason;

            post('clipper:uploaded', {
                sessionId: session.sessionId,
                token: session.token,
                status: 0,
                bytes: blob.size,
                seconds: (window.performance.now() - startedAt) / 1000,
                body: 'envio em partes: ' + reason
            });

            throw error;
        });
    }

    function sha256Hex(blob) {
        return blob.arrayBuffer().then(function (buffer) {
            return window.crypto.subtle.digest('SHA-256', buffer);
        }).then(function (digest) {
            return Array.prototype.map.call(new Uint8Array(digest), function (byte) {
                return ('0' + byte.toString(16)).slice(-2);
            }).join('');
        });
    }

    function apiError(status, text) {
        var code = '';

        try {
            code = (JSON.parse(text) || {}).code || '';
        } catch (error) {
            code = '';
        }

        return new Error('api ' + status + (code ? ' ' + code : '') + ': ' + (text || '').slice(0, 120));
    }

    // Envio em partes (API v3.2). Existe porque o `fetch` do CEF corta corpos grandes:
    // fatiado, nenhuma requisicao chega perto do limite. So a abertura leva a api-key;
    // nas outras rotas o `uploadId` e a credencial, entao ele nao vai para log.
    function uploadChunked(config, session, blob) {
        var partBytes = config.chunkBytes || 4 * 1024 * 1024;
        var partCount = Math.ceil(blob.size / partBytes);
        var upload = null;

        metrics.transport = 'partes';
        metrics.uploadProgress = 'hash de ' + mb(blob.size);

        return sha256Hex(blob).then(function (sha256) {
            var payload = JSON.parse(session.payload);

            payload.totalBytes = blob.size;
            payload.partCount = partCount;
            payload.sha256 = sha256;

            return fetch(session.uploadsUrl, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'x-api-key': session.apiKey
                },
                body: JSON.stringify(payload)
            });
        }).then(function (response) {
            return response.text().then(function (text) {
                if (response.status < 200 || response.status >= 300) {
                    throw apiError(response.status, text);
                }

                upload = JSON.parse(text);

                if (upload.maxPartBytes && partBytes > upload.maxPartBytes) {
                    throw new Error('parte de ' + partBytes + 'B acima do maximo ' + upload.maxPartBytes);
                }

                return sendParts(session, blob, upload, partBytes, partCount);
            });
        }).then(function () {
            return completeUpload(session, upload);
        }).then(function (result) {
            // `MISSING_PARTS` nomeia o que faltou, entao reenvia so aquilo. Uma rodada:
            // se faltar de novo, o problema nao e perda pontual.
            if (result.status !== 409 || result.body.indexOf('MISSING_PARTS') === -1) {
                return result;
            }

            var missing = (JSON.parse(result.body) || {}).missingParts || [];

            if (!missing.length) {
                return result;
            }

            return sendParts(session, blob, upload, partBytes, partCount, missing).then(function () {
                return completeUpload(session, upload);
            });
        });
    }

    function sendPart(session, blob, upload, index, partBytes) {
        var slice = blob.slice((index - 1) * partBytes, index * partBytes);

        metrics.uploadProgress = 'parte ' + index + ' (' + mb(slice.size) + ')';

        return sha256Hex(slice).then(function (hex) {
            return fetch(session.uploadsUrl + '/' + upload.uploadId + '/parts/' + index, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/octet-stream',
                    'x-part-sha256': hex
                },
                body: slice
            });
        }).then(function (response) {
            if (response.status < 200 || response.status >= 300) {
                return response.text().then(function (text) {
                    throw apiError(response.status, text);
                });
            }
        });
    }

    // Sequencial, nao em paralelo: o gargalo e o upstream do admin, e varias partes
    // disputando a mesma banda so atrasam a primeira sem adiantar a ultima.
    function sendParts(session, blob, upload, partBytes, partCount, only) {
        var pending = only || [];

        if (!only) {
            for (var index = 1; index <= partCount; index += 1) {
                pending.push(index);
            }
        }

        return pending.reduce(function (chain, index) {
            return chain.then(function () {
                return sendPart(session, blob, upload, index, partBytes);
            });
        }, Promise.resolve());
    }

    function completeUpload(session, upload) {
        metrics.uploadProgress = 'fechando';

        return fetch(session.uploadsUrl + '/' + upload.uploadId + '/complete', {
            method: 'POST'
        }).then(function (response) {
            return response.text().then(function (text) {
                return { status: response.status, body: text };
            });
        });
    }

    function uploadDirect(config, session, blob) {
        var startedAt = window.performance.now();

        metrics.transport = 'direto';
        metrics.uploadProgress = 'enviando ' + mb(blob.size);

        var form = new FormData();

        form.append('file', blob, session.fileName);
        form.append('payload', session.payload);

        return fetch(session.apiUrl, {
            method: 'POST',
            headers: { 'x-api-key': session.apiKey },
            body: form
        }).then(function (response) {
            return response.text().then(function (text) {
                return { status: response.status, body: text };
            });
        }).then(function (result) {
            var seconds = (window.performance.now() - startedAt) / 1000;

            metrics.uploadProgress = result.status + ' em ' + seconds.toFixed(1) + 's';

            // O servidor nao viu o arquivo passar: sem este aviso ele nao teria como
            // saber se o clipe daquele ban chegou.
            post('clipper:uploaded', {
                sessionId: session.sessionId,
                token: session.token,
                status: result.status,
                bytes: blob.size,
                seconds: seconds,
                body: (result.body || '').slice(0, 4096)
            });

            if (result.status < 200 || result.status >= 300) {
                throw new Error('api ' + result.status + ': ' + (result.body || '').slice(0, 120));
            }
        }, function (error) {
            // O `fetch` so rejeita antes de haver resposta: CORS, DNS, TLS, rede. Sem
            // este ramo o servidor veria um "Failed to fetch" solto e nao saberia
            // sequer que houve tentativa de envio.
            var reason = (error && error.message) || String(error);

            metrics.uploadProgress = 'falhou: ' + reason;

            post('clipper:uploaded', {
                sessionId: session.sessionId,
                token: session.token,
                status: 0,
                bytes: blob.size,
                seconds: (window.performance.now() - startedAt) / 1000,
                body: 'fetch rejeitado: ' + reason
            });

            throw error;
        });
    }

    // Escada de tamanhos pelo MESMO `fetch` que o clipe usa.
    //
    // Existe por causa de um limite real: clipes de ate ~4,9 MB sobem e voltam 201,
    // acima disso a API responde "nao e multipart/form-data valido". O corpo nao e o
    // culpado - o mesmo tamanho por `curl`, inclusive chunked, passa sem erro. Entao a
    // medida tem de sair daqui, do proprio caminho que falha.
    //
    // O `payload` vai invalido de proposito: a API valida o multipart ANTES do payload,
    // entao as respostas se distinguem e nada e gravado.
    //
    //   "Payload invalido"                   -> chegou inteiro neste tamanho
    //   "nao e multipart/form-data valido"   -> chegou cortado
    function netLadder(session) {
        var sizes = session.sizes || [];

        function step(index) {
            if (index >= sizes.length) {
                return Promise.resolve();
            }

            var size = sizes[index];
            var form = new FormData();

            form.append('file', new Blob([new Uint8Array(size)], { type: 'video/webm' }), 'probe.webm');
            form.append('payload', session.payload);

            var startedAt = window.performance.now();

            return fetch(session.apiUrl, {
                method: 'POST',
                headers: { 'x-api-key': session.apiKey },
                body: form
            }).then(function (response) {
                return response.text().then(function (text) {
                    return { status: response.status, body: text };
                });
            }).catch(function (error) {
                return { status: 0, body: 'fetch rejeitado: ' + ((error && error.message) || error) };
            }).then(function (result) {
                post('clipper:netladder', {
                    size: size,
                    status: result.status,
                    seconds: (window.performance.now() - startedAt) / 1000,
                    cut: (result.body || '').indexOf('multipart') !== -1,
                    body: (result.body || '').slice(0, 120)
                });

                return step(index + 1);
            });
        }

        return step(0);
    }

    // Decide o que fazer com um buffer que talvez nao esteja cheio.
    //
    // O buffer so cobre a janela inteira `durationMs` depois de armar. Um ban aplicado
    // antes disso - admin que acabou de entrar, ou logo apos um `restart admin` - era
    // descartado inteiro, perdendo os segundos que ja existiam. Agora entregamos o que
    // ha, desde que passe de `minClipMs`; abaixo disso sao frames demais de nada.
    //
    // Pura de proposito: e a regra que decide se um ban fica sem prova nenhuma.
    function classifyAge(age, config) {
        if (age >= config.durationMs) {
            return { ok: true, partial: false };
        }

        var floor = config.minClipMs || 0;

        if (!floor || age < floor) {
            return { ok: false, reason: 'buffer_warming', partial: false };
        }

        return { ok: true, partial: true };
    }

    function capture(session) {
        if (!state.armed) {
            return Promise.reject(new Error('not_armed'));
        }

        var slot = oldestRunningSlot();
        var partial = false;

        if (!slot) {
            return Promise.reject(new Error('buffer_warming'));
        }

        var age = window.performance.now() - slot.startedAt;
        var verdict = classifyAge(age, state.config);

        if (!verdict.ok) {
            return Promise.reject(new Error(verdict.reason));
        }

        partial = verdict.partial;

        window.clearTimeout(slot.timer);

        var recorder = slot.recorder;
        var requestedAt = window.performance.now();

        return new Promise(function (resolve) {
            slot.captureRecorder = recorder;
            slot.captureResolve = resolve;

            recorder.stop();
        }).then(function (blob) {
            var flushedAt = window.performance.now();

            restage();

            if (!blob.size) {
                throw new Error('empty clip');
            }

            var config = state.config;

            metrics.lastCapture = {
                clipSeconds: age / 1000,
                bytes: blob.size,
                flushMs: flushedAt - requestedAt,
                uploadMs: 0
            };

            // Duracao real e falantes da janela seguem antes dos bytes: se o envio
            // cair no meio, o servidor ao menos sabe o que aquele clipe deveria ser.
            post('clipper:meta', {
                sessionId: session.sessionId,
                token: session.token,
                clipSeconds: age / 1000,
                // Clipe curto porque o buffer ainda aquecia quando o ban saiu.
                partial: partial,
                // Sem isto, decidir se um clipe ruim foi cena parada ou encode afogado
                // depende de alguem estar com o HUD aberto na hora do ban.
                drawFps: metrics.drawFps,
                gameFps: metrics.gameFps
            });

            return uploadClip(config, session, blob).then(function () {
                metrics.lastCapture.uploadMs = window.performance.now() - flushedAt;
            });
        });
    }

    // O envio em partes da API exige SHA-256 do arquivo e de cada parte. Nenhum resource
    // da base usa `crypto.subtle` hoje, entao a disponibilidade dele no CEF do FiveM e
    // desconhecida. Mede uma vez, no primeiro arm, e manda o resultado para o log.
    var sha256Probed = false;

    function probeSha256() {
        if (sha256Probed) {
            return;
        }

        sha256Probed = true;

        if (!window.crypto || !window.crypto.subtle || !window.crypto.subtle.digest) {
            post('clipper:sha256Probe', { ok: false, reason: 'crypto.subtle ausente' });

            return;
        }

        var startedAt = window.performance.now();

        window.crypto.subtle.digest('SHA-256', new Uint8Array([1, 2, 3])).then(function (digest) {
            var hex = Array.prototype.map.call(new Uint8Array(digest), function (byte) {
                return ('0' + byte.toString(16)).slice(-2);
            }).join('');

            post('clipper:sha256Probe', {
                ok: hex === '039058c6f2c0cb492c533b0a4d14ef77cc0f78abccced5287d84a1a2011cfb81',
                hex: hex.slice(0, 16),
                ms: window.performance.now() - startedAt
            });
        }, function (error) {
            post('clipper:sha256Probe', { ok: false, reason: (error && error.message) || String(error) });
        });
    }

    function escapeHtml(text) {
        return text.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
    }

    function mb(bytes) {
        return (bytes / (1024 * 1024)).toFixed(2) + ' MB';
    }

    function renderOverlay() {
        var now = window.performance.now();
        var elapsed = now - metrics.windowStart;

        if (elapsed >= 500) {
            metrics.drawFps = (metrics.windowFrames * 1000) / elapsed;
            metrics.encodeKbps = (metrics.windowBytes * 8) / elapsed;

            metrics.windowFrames = 0;
            metrics.windowBytes = 0;
            metrics.windowStart = now;
        }

        var config = state.config || {};
        var lines = [];

        lines.push('<b>clipper</b>  ' + (state.armed ? '<b style="color:#7ee081">ARMADO</b>' : '<u style="color:#ff6b6b;text-decoration:none">DESARMADO</u>'));

        if (state.armed) {
            lines.push('buffer ligado ha ' + ((now - metrics.armedAt) / 1000).toFixed(0) + 's');
        }

        lines.push('');
        lines.push('<i style="color:#f2b84b;font-style:normal">jogo</i>');
        lines.push('  fps          ' + metrics.gameFps.toFixed(0) + '  (' + metrics.gameFrameMs.toFixed(2) + ' ms/frame)');
        lines.push('');
        lines.push('<i style="color:#f2b84b;font-style:normal">captura</i>');
        lines.push('  resolucao    ' + (config.width || 0) + 'x' + (config.height || 0) + ' @ ' + (config.fps || 0) + ' fps');
        lines.push('  draw real    ' + metrics.drawFps.toFixed(1) + ' fps');
        lines.push('  frames       ' + metrics.drawnFrames);
        lines.push('  microfone    ' + (state.micStream ? 'ligado' : 'desligado') + '  [' + metrics.micStatus + ']');
        lines.push('  codec        ' + (pickMime() || 'default'));
        lines.push('  copy buffer  ' + (config.preserveDrawingBuffer ? 'on' : 'off'));
        lines.push('');
        lines.push('<i style="color:#f2b84b;font-style:normal">encode</i>');
        lines.push('  gravadores   ' + state.slots.length + ' x ' + ((config.segmentMs || 0) / 1000).toFixed(1) + 's sobrepostos');
        lines.push('  bitrate real ' + metrics.encodeKbps.toFixed(0) + ' kbps  (alvo ' + (((config.videoBitrate || 0) + (config.audioBitrate || 0)) / 1000).toFixed(0) + ')');
        lines.push('  em memoria   ' + mb(metrics.bufferBytes));
        lines.push('  total gerado ' + mb(metrics.encodedBytes));

        state.slots.forEach(function (slot, index) {
            var age = (slot.recorder && slot.recorder.state === 'recording') ? ((now - slot.startedAt) / 1000) : 0;
            var ready = age >= ((config.durationMs || 0) / 1000);

            lines.push('  slot ' + index + '       ' + age.toFixed(1) + 's ' + (ready ? '<b>[pronto]</b>' : '[aquecendo]') + '  ' + mb(slot.bytes));
        });

        lines.push('');
        lines.push('<i style="color:#f2b84b;font-style:normal">ultimo clipe</i>');

        if (metrics.lastCapture) {
            var perSecond = metrics.lastCapture.bytes / Math.max(1, metrics.lastCapture.clipSeconds);

            lines.push('  duracao      ' + metrics.lastCapture.clipSeconds.toFixed(1) + 's');
            lines.push('  tamanho      ' + mb(metrics.lastCapture.bytes));
            lines.push('  fechar webm  ' + metrics.lastCapture.flushMs.toFixed(0) + ' ms');
            lines.push('  upload       ' + (metrics.lastCapture.uploadMs > 0 ? metrics.lastCapture.uploadMs.toFixed(0) + ' ms' : '<u style="color:#ff6b6b;text-decoration:none">nao concluido</u>'));
            lines.push('  envio        ' + metrics.transport + '  ' + metrics.uploadProgress);
            lines.push('  vazao        ' + metrics.uploadRate);


            // Video preto comprime para quase nada: e o sintoma de a textura do jogo
            // nao ter sido trocada pelo CEF.
            if (perSecond < 20000) {
                lines.push('  <u style="color:#ff6b6b;text-decoration:none">suspeito: video quase vazio, textura do jogo provavelmente preta</u>');
            }
        } else {
            lines.push('  nenhum ainda');
        }


        if (metrics.lastError) {
            lines.push('');
            lines.push('<i style="color:#f2b84b;font-style:normal">ultimo erro</i>');
            lines.push('  ' + escapeHtml(metrics.lastError).replace(/(.{58})/g, '$1\n  '));
        }

        metrics.overlay.innerHTML = lines.join('\n');
    }

    function setDebug(enabled) {
        if (!enabled) {
            if (metrics.timer) {
                window.clearInterval(metrics.timer);
                metrics.timer = null;
            }

            if (metrics.overlay) {
                metrics.overlay.parentNode.removeChild(metrics.overlay);
                metrics.overlay = null;
            }

            return;
        }

        if (metrics.overlay) {
            return;
        }

        metrics.overlay = document.createElement('div');
        metrics.overlay.id = 'clipper-metrics';
        metrics.overlay.setAttribute('style', [
            'position:fixed', 'top:12px', 'left:12px', 'min-width:300px',
            'padding:10px 12px', 'border-radius:6px',
            'border:1px solid rgba(255,255,255,0.12)',
            'background:rgba(10,12,16,0.82)', 'color:#e6e6e6',
            'font:12px/1.45 Consolas,monospace', 'white-space:pre',
            'pointer-events:none', 'z-index:2147483647',
            'text-shadow:0 1px 2px rgba(0,0,0,0.9)'
        ].join(';'));

        document.body.appendChild(metrics.overlay);

        renderOverlay();

        metrics.timer = window.setInterval(renderOverlay, 500);
    }

    window.addEventListener('message', function (event) {
        var data = event.data;

        // A Ban Window troca mensagens nesta mesma janela: so responder ao que e nosso.
        if (!data || data.clipper !== true || !data.action) {
            return;
        }

        if (data.action === 'arm') {
            arm(data).catch(function (error) {
                disarm();
                fail(null, 'arm_failed: ' + ((error && error.message) || error));
            });

            probeSha256();

            return;
        }

        if (data.action === 'disarm') {
            disarm();
            setDebug(false);

            return;
        }

        if (data.action === 'debug') {
            setDebug(!!data.enabled);

            return;
        }

        if (data.action === 'requestMic') {
            // Chamada com o foco de NUI ligado, para o admin conseguir aceitar o
            // prompt nativo do FiveM. O stream e descartado: o que interessa e a
            // permissao ficar concedida para as proximas armadas do buffer.
            requestMicrophone().then(function (stream) {
                if (stream) {
                    stream.getTracks().forEach(function (track) { track.stop(); });
                }

                listAudioInputs().then(function (devices) {
                    post('clipper:micResult', {
                        granted: !!stream,
                        reason: metrics.micStatus,
                        loopback: metrics.micStatus.indexOf('loopback') === 0,
                        devices: devices
                    });
                });

                // O microfone so entra nas trilhas dentro do `arm`.
                if (!stream || !state.armed || state.micStream || !state.config) {
                    return;
                }

                var config = state.config;

                disarm();
                arm(config).catch(function (error) {
                    disarm();
                    fail(null, 'rearm_failed: ' + ((error && error.message) || error));
                });
            });

            return;
        }


        if (data.action === 'sample') {
            metrics.gameFps = data.fps || 0;
            metrics.gameFrameMs = data.frameTimeMs || 0;

            return;
        }

        if (data.action === 'netladder') {
            netLadder(data);

            return;
        }

        if (data.action !== 'capture' || state.capturing) {
            return;
        }

        state.capturing = true;

        capture(data)
            .then(function () {
                state.capturing = false;

                post('clipper:finished', { sessionId: data.sessionId });
            })
            .catch(function (error) {
                state.capturing = false;

                fail(data.sessionId, (error && error.message) || error);
            });
    });
}());
