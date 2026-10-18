/**
 * NUI Bridge - Frontend <-> Backend event/callback hub
 * Works with FiveM NUI (postMessage + https POST to resource exports)
 */
(function() {
    const DEFAULT_RESOURCE = 'register';

    class NuiBridge {
        constructor() {
            this.resourceName = DEFAULT_RESOURCE;
            this.eventHandlers = new Map();
            this.pending = new Map();
            this.requestSeq = 0;
            this.isInitialized = false;
        }

        init(resourceName) {
            if (this.isInitialized) return;
            if (typeof resourceName === 'string' && resourceName.trim().length > 0) {
                this.resourceName = resourceName.trim();
            }

            window.addEventListener('message', (event) => {
                const data = event?.data;
                if (!data) return;

                // Supported shapes:
                // 1) { type: 'nui-event', event: 'evt', payload: {...} }
                // 2) { action: 'evt', data: {...} }
                // 3) { type: 'nui-response', requestId, payload }
                if (data.type === 'nui-response' && data.requestId) {
                    const resolver = this.pending.get(data.requestId);
                    if (resolver) {
                        this.pending.delete(data.requestId);
                        resolver.resolve(data.payload);
                    }
                    return;
                }

                const evtName = data.event || data.action;
                const payload = data.payload ?? data.data ?? data;
                if (!evtName) return;

                this.#emitLocal(evtName, payload);
            });

            this.isInitialized = true;
        }

        on(eventName, handler) {
            if (!eventName || typeof handler !== 'function') return () => {};
            if (!this.eventHandlers.has(eventName)) this.eventHandlers.set(eventName, new Set());
            this.eventHandlers.get(eventName).add(handler);
            return () => this.off(eventName, handler);
        }

        once(eventName, handler) {
            const off = this.on(eventName, (payload) => {
                off();
                handler(payload);
            });
            return off;
        }

        off(eventName, handler) {
            const set = this.eventHandlers.get(eventName);
            if (!set) return;
            if (handler) set.delete(handler);
            else this.eventHandlers.delete(eventName);
        }

        emitToBackend(eventName, payload = {}) {
            // Fire-and-forget
            return this.#post(eventName, payload).catch(() => {});
        }

        request(eventName, payload = {}) {
            // Request/response with requestId correlation
            const requestId = `nui_${Date.now()}_${++this.requestSeq}`;
            return new Promise((resolve, reject) => {
                this.pending.set(requestId, { resolve, reject });
                this.#post(eventName, { ...payload, requestId }).catch((err) => {
                    this.pending.delete(requestId);
                    reject(err);
                });
            });
        }

        reply(requestId, payload) {
            // For symmetry if the UI needs to reply to the backend via postMessage
            window.postMessage({ type: 'nui-response', requestId, payload }, '*');
        }

        #emitLocal(eventName, payload) {
            const handlers = this.eventHandlers.get(eventName);
            if (!handlers) return;
            handlers.forEach((fn) => {
                try { fn(payload); } catch (e) { console.error('[NuiBridge] handler error:', e); }
            });
        }

        async #post(eventName, payload) {
            const url = `https://${this.resourceName}/${eventName}`;
            await fetch(url, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json; charset=utf-8' },
                body: JSON.stringify(payload ?? {})
            });
        }
    }

    // Singleton
    if (!window.NuiBridge) {
        window.NuiBridge = new NuiBridge();
        // Attempt to infer resourceName from NUI env if provided
        const inferred = window.nuiResourceName || window.NUI_RES_NAME || undefined;
        window.NuiBridge.init(inferred);
    }
})();

// Suggested backend contract (to share with backend team):
// UI -> Backend (emit/request):
//   - loading:ready                { cityName }
//   - music:play                   { }
//   - music:pause                  { }
//   - music:setVolume              { volume: number 0..1 }
//   - ui:showKeyboard              { }
//   - ui:hideKeyboard              { }
//   - city:get                     { } -> response { cityName }
//
// Backend -> UI (postMessage):
//   window.postMessage({ type: 'nui-event', event: 'city:set', payload: { cityName } })
//   window.postMessage({ type: 'nui-event', event: 'music:seek', payload: { seconds: number } })
//   window.postMessage({ type: 'nui-event', event: 'progress:set', payload: { value: number 0..100 } })

