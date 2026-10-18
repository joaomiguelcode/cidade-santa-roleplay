/**
 * ENG-2981 — vínculo do Santa App na loading da Cidade Grande.
 *
 * Regras que vieram da issue e ficam explícitas aqui:
 *  - Só a Grande recebe o bloco; qualquer outra cidade mantém a loading atual.
 *  - Nada aqui pode segurar o carregamento do FiveM: toda falha é fail-open,
 *    o bloco some ou mostra "tentar novamente" e a loading segue igual.
 *  - Estados obrigatórios: preparando sessão, QR disponível, QR expirado/falha
 *    (com ação de tentar de novo) e vínculo detectado.
 *
 * O layout segue o frame "01 · Loadscreen" do Figma (UIX-231), bloco
 * "Bloco - vínculo QR". O visual mora no style.css (`.santa-link*`).
 */
(function () {
    'use strict';

    /** Cidade única onde o passo existe (critério de aceite da issue). */
    var TARGET_CITY = 'grande';

    var STATE = {
        PREPARING: 'PREPARING',
        WAITING: 'WAITING',
        EXPIRED: 'EXPIRED',
        ERROR: 'ERROR',
        LINKED: 'LINKED'
    };

    /**
     * Eventos vindos do jogo (window.postMessage → NuiBridge).
     * Os nomes com prefixo são os desta loading; os alias existem porque o
     * register (ENG-2982) escuta as versões camelCase — assim o jogo pode
     * emitir um nome só para as duas NUIs.
     */
    var EVENTS_IN = {
        session: ['santaApp:session', 'santaAppSession', 'openSantaApp'],
        success: ['santaApp:success', 'santaAppSuccess'],
        error: ['santaApp:error', 'santaAppError'],
        hide: ['santaApp:hide', 'closeSantaApp']
    };

    /** Callbacks enviados ao jogo (fire-and-forget / request). */
    var CALLBACKS = {
        requestSession: 'santaApp:requestSession',
        opened: 'santaApp:opened'
    };

    /** Validade padrão quando o jogo não manda `expiresIn`. */
    var DEFAULT_EXPIRES_IN = 300;
    /** Depois disso a ponte NUI é considerada muda e o estado vira ERROR. */
    var REQUEST_TIMEOUT_MS = 8000;

    var COPY = {};
    COPY[STATE.PREPARING] = {
        title: 'PREPARANDO O VINCULO',
        description: 'Estamos gerando seu QR Code seguro. Isso leva só um instante.'
    };
    COPY[STATE.WAITING] = {
        // Texto aprovado no Figma — não alterar sem passar pelo UIX-231.
        title: 'ADIANTE O VINCULO',
        description: 'Escaneie o QR Code e vincule sua conta facilmente, concluindo o processo.'
    };
    // Durante a loadscreen não há client para emitir um token novo, então as
    // duas copies levam o jogador ao registro, que é onde o fluxo continua.
    COPY[STATE.EXPIRED] = {
        title: 'QR CODE EXPIRADO',
        description: 'O código expirou. Tente de novo ou conclua o vínculo no registro.'
    };
    COPY[STATE.ERROR] = {
        title: 'FALHA AO CARREGAR',
        description: 'Não conseguimos carregar o QR agora. Você pode concluir no registro.'
    };
    COPY[STATE.LINKED] = {
        title: 'VINCULO DETECTADO',
        description: 'Conta reconhecida. Continue o processo assim que entrar na cidade.'
    };

    function normalizeCity(name) {
        return typeof name === 'string' ? name.trim().toLowerCase() : '';
    }

    /** Aceita link com ou sem protocolo — o Lua manda dos dois jeitos. */
    function normalizeLink(link) {
        if (!link) return '';
        var value = String(link).trim();
        if (!value) return '';
        return /^[a-z][a-z0-9+.-]*:/i.test(value) ? value : 'https://' + value;
    }

    /** Abre URL externa. Reaproveita o openUrl global do script.js quando existe. */
    function openExternal(url) {
        if (!url) return;
        try {
            if (typeof window.openUrl === 'function') {
                window.openUrl(url);
                return;
            }
            if (typeof window.invokeNative === 'function') {
                window.invokeNative('openUrl', url);
            }
        } catch (error) {
            console.warn('[SantaAppLink] não foi possível abrir a URL:', error);
        }
    }

    function SantaAppLink() {
        this.root = null;
        this.state = STATE.PREPARING;
        this.session = {};
        this.totalSeconds = 0;
        this.expiresAt = 0;
        this.countdownTimer = null;
        this.requestPending = false;
        this.visible = false;
        this.revealed = false;
        this.currentCity = '';
        this.lastRenderedLink = '';
        this.waitTimer = null;
        /** Já houve QR válido? Decide entre "esconder" e "mostrar erro". */
        this.hadSession = false;
    }

    SantaAppLink.prototype.init = function () {
        this.root = document.getElementById('santaLink');
        if (!this.root) return;

        this.el = {
            title: document.getElementById('santaLinkTitle'),
            description: document.getElementById('santaLinkDescription'),
            qrButton: document.getElementById('santaLinkQrButton'),
            qrCode: document.getElementById('santaLinkQrCode'),
            overlay: document.getElementById('santaLinkOverlay'),
            retry: document.getElementById('santaLinkRetry'),
            stores: document.getElementById('santaLinkStores'),
            appStore: document.getElementById('santaLinkAppStore'),
            googlePlay: document.getElementById('santaLinkGooglePlay')
        };

        this.bindDom();
        this.bindNui();
        this.setState(STATE.PREPARING);
        this.syncCity(this.readCityName());

        // A cidade pode chegar depois do primeiro frame (handover é assíncrono).
        var self = this;
        this.cityPoll = setInterval(function () {
            self.syncCity(self.readCityName());
        }, 1000);
    };

    SantaAppLink.prototype.readCityName = function () {
        var handover = window.nuiHandoverData;
        if (!handover) return '';
        // `cityName` é o que o script.js lê hoje; `City` é o nome antigo do
        // handover e ainda aparece em servidores não migrados.
        return handover.cityName || handover.City || '';
    };

    /** Sessão entregue pelo servidor no `deferrals.handover()`. */
    SantaAppLink.prototype.readHandoverSession = function () {
        var handover = window.nuiHandoverData;
        var session = handover && (handover.santaApp || handover.SantaApp);
        if (session && (session.qrLink || session.code)) return session;
        return null;
    };

    SantaAppLink.prototype.bindDom = function () {
        var self = this;

        if (this.el.retry) {
            this.el.retry.addEventListener('click', function (event) {
                event.preventDefault();
                event.stopPropagation();
                self.requestSession();
            });
        }

        if (this.el.qrButton) {
            this.el.qrButton.addEventListener('click', function () {
                var link = normalizeLink(self.session.qrLink);
                if (!link) return;
                openExternal(link);
                self.emit(CALLBACKS.opened, { code: self.session.code || '' });
            });
        }

        [this.el.appStore, this.el.googlePlay].forEach(function (node) {
            if (!node) return;
            node.addEventListener('click', function (event) {
                event.preventDefault();
                var url = node.getAttribute('data-url');
                if (url) openExternal(url);
            });
        });
    };

    SantaAppLink.prototype.bindNui = function () {
        var self = this;
        var bridge = window.NuiBridge;
        if (!bridge) return;

        EVENTS_IN.session.forEach(function (name) {
            bridge.on(name, function (payload) { self.applySession(payload); });
        });
        EVENTS_IN.success.forEach(function (name) {
            bridge.on(name, function (payload) { self.handleSuccess(payload); });
        });
        EVENTS_IN.error.forEach(function (name) {
            bridge.on(name, function (payload) { self.handleError(payload); });
        });
        EVENTS_IN.hide.forEach(function (name) {
            bridge.on(name, function () { self.hide(); });
        });

        bridge.on('city:set', function (payload) {
            self.syncCity((payload && payload.cityName) || payload);
        });
    };

    SantaAppLink.prototype.emit = function (event, payload) {
        try {
            if (window.NuiBridge) window.NuiBridge.emitToBackend(event, payload || {});
        } catch (error) {
            // fail-open: a loading nunca depende da ponte responder
        }
    };

    /** Mostra/esconde conforme a cidade. Só a Grande recebe o bloco. */
    SantaAppLink.prototype.syncCity = function (cityName) {
        var normalized = normalizeCity(cityName);
        if (!normalized || normalized === this.currentCity) return;
        this.currentCity = normalized;

        if (normalized === TARGET_CITY) {
            this.show();
        } else {
            this.hide();
        }
    };

    /** Cidade é a Grande: passa a procurar uma sessão, mas ainda não exibe nada. */
    SantaAppLink.prototype.show = function () {
        if (this.visible) return;
        this.visible = true;

        // Caminho principal: a sessão vem no handover do playerConnecting.
        // Não há script client durante a loading do FiveM, então este é o único
        // canal garantido — o callback NUI é só um extra para outros contextos.
        var session = this.readHandoverSession();
        if (session) {
            this.applySession(session);
        } else {
            this.awaitSession();
        }
    };

    /**
     * Só aqui o bloco entra na tela. Sem sessão ele nunca aparece — melhor não
     * existir do que piscar um "preparando" que some.
     */
    SantaAppLink.prototype.reveal = function () {
        if (!this.visible || this.revealed || !this.root) return;
        this.revealed = true;
        this.root.hidden = false;
        document.body.classList.add('has-santa-link');
    };

    SantaAppLink.prototype.hide = function () {
        this.visible = false;
        this.revealed = false;
        this.stopCountdown();
        this.stopWaiting();
        if (this.root) this.root.hidden = true;
        document.body.classList.remove('has-santa-link');
    };

    /**
     * O handover chega antes do DOMContentLoaded, mas o servidor pode demorar
     * a preencher a chave. Observa por alguns segundos e desiste em silêncio.
     */
    SantaAppLink.prototype.awaitSession = function () {
        var self = this;
        this.stopWaiting();

        // Prazo por relógio, não por contagem de ticks: o browser estrangula
        // setInterval em aba de fundo e o limite nunca chegaria.
        var deadline = Date.now() + REQUEST_TIMEOUT_MS;
        this.waitTimer = setInterval(function () {
            var session = self.readHandoverSession();
            if (session) {
                self.stopWaiting();
                self.applySession(session);
                return;
            }
            if (Date.now() >= deadline) self.stopWaiting();
        }, 500);

        // tentativa única pela ponte, para contextos que tenham script client
        if (!window.NuiBridge) return;
        try {
            window.NuiBridge.request(CALLBACKS.requestSession, {})
                .then(function (payload) {
                    if (!payload || !(payload.qrLink || payload.code)) return;
                    self.stopWaiting();
                    self.applySession(payload);
                })
                .catch(function () { /* fail-open: o bloco só não aparece */ });
        } catch (error) {
            // idem
        }
    };

    SantaAppLink.prototype.stopWaiting = function () {
        if (this.waitTimer) {
            clearInterval(this.waitTimer);
            this.waitTimer = null;
        }
    };

    /**
     * "Tentar novamente": só existe depois de já ter havido um QR na tela, e
     * por isso mantém o bloco visível em PREPARING. Se nada responder, cai em
     * ERROR — cuja copy manda o jogador concluir no registro, porque durante a
     * loadscreen não há client para emitir outro token.
     */
    SantaAppLink.prototype.requestSession = function () {
        if (this.requestPending) return;
        this.requestPending = true;
        this.setState(STATE.PREPARING);

        var self = this;
        var settled = false;

        var giveUp = function () {
            if (!self.hadSession) {
                self.hide();
                return;
            }
            self.setState(STATE.ERROR);
        };

        var finish = function (payload) {
            if (settled) return;
            settled = true;
            self.requestPending = false;

            if (payload && (payload.qrLink || payload.code)) {
                self.applySession(payload);
                return;
            }
            // o servidor pode ter reescrito o handover enquanto isso
            var session = self.readHandoverSession();
            if (session) {
                self.applySession(session);
                return;
            }
            if (self.state === STATE.PREPARING) giveUp();
        };

        setTimeout(function () {
            if (settled) return;
            settled = true;
            self.requestPending = false;
            if (self.state === STATE.PREPARING) giveUp();
        }, REQUEST_TIMEOUT_MS);

        if (!window.NuiBridge) {
            finish(null);
            return;
        }

        try {
            window.NuiBridge.request(CALLBACKS.requestSession, {})
                .then(finish)
                .catch(function () { finish(null); });
        } catch (error) {
            finish(null);
        }
    };

    /** Aplica um payload de sessão vindo do jogo. */
    SantaAppLink.prototype.applySession = function (payload) {
        if (!payload || typeof payload !== 'object') return;

        if (payload.qrLink) this.session.qrLink = payload.qrLink;
        if (payload.code) this.session.code = payload.code;
        if (payload.stores) this.session.stores = payload.stores;
        this.applyStores(this.session.stores);

        var seconds = typeof payload.expiresIn === 'number' && payload.expiresIn > 0
            ? payload.expiresIn
            : DEFAULT_EXPIRES_IN;

        var next = payload.status && STATE[payload.status] ? STATE[payload.status] : STATE.WAITING;
        if (next === STATE.WAITING && !this.session.qrLink && !this.session.code) {
            next = STATE.PREPARING;
        }

        this.requestPending = false;
        this.hadSession = true;
        this.stopWaiting();
        this.reveal();
        this.setState(next, { seconds: seconds });
    };

    SantaAppLink.prototype.handleSuccess = function (payload) {
        this.session.account = (payload && payload.account) || null;
        this.requestPending = false;
        this.setState(STATE.LINKED);
    };

    SantaAppLink.prototype.handleError = function (payload) {
        this.requestPending = false;
        // `recoverable: false` significa sessão inutilizável — a tela oferece
        // gerar outra, que é o mesmo remédio do estado expirado.
        var recoverable = !payload || payload.recoverable !== false;
        this.setState(recoverable ? STATE.ERROR : STATE.EXPIRED, {
            message: payload && payload.message
        });
    };

    SantaAppLink.prototype.applyStores = function (stores) {
        if (!stores) return;
        if (this.el.appStore && stores.ios) {
            this.el.appStore.setAttribute('data-url', normalizeLink(stores.ios));
            this.el.appStore.removeAttribute('aria-disabled');
        }
        if (this.el.googlePlay && stores.android) {
            this.el.googlePlay.setAttribute('data-url', normalizeLink(stores.android));
            this.el.googlePlay.removeAttribute('aria-disabled');
        }
    };

    SantaAppLink.prototype.setState = function (state, options) {
        options = options || {};
        this.state = state;
        if (!this.root) return;

        this.root.setAttribute('data-state', state);

        var copy = COPY[state] || COPY[STATE.WAITING];
        if (this.el.title) this.el.title.textContent = copy.title;
        if (this.el.description) {
            this.el.description.textContent = options.message || copy.description;
        }

        if (state === STATE.WAITING) {
            this.renderQr(normalizeLink(this.session.qrLink) || this.session.code || '');
            this.startCountdown(options.seconds || this.totalSeconds || DEFAULT_EXPIRES_IN);
        } else {
            this.stopCountdown();
        }
    };

    /** Desenha o QR a partir do deep link recebido do jogo. */
    SantaAppLink.prototype.renderQr = function (content) {
        if (!this.el.qrCode) return;
        if (!content) {
            this.el.qrCode.innerHTML = '';
            this.lastRenderedLink = '';
            return;
        }
        if (content === this.lastRenderedLink) return;

        try {
            // Correção H: o selo central cobre módulos e precisa dessa folga.
            this.el.qrCode.innerHTML = window.SantaQR.svg(content, { level: 'H' });
            this.lastRenderedLink = content;
        } catch (error) {
            console.warn('[SantaAppLink] falha ao gerar o QR Code:', error);
            this.el.qrCode.innerHTML = '';
            this.lastRenderedLink = '';
            this.setState(STATE.ERROR);
        }
    };

    /**
     * Validade da sessão: o Figma não tem contador visível, então a indicação
     * é o próprio estado — ao zerar, o bloco vira EXPIRED com a ação de gerar
     * um novo QR.
     */
    SantaAppLink.prototype.startCountdown = function (seconds) {
        this.stopCountdown();
        this.totalSeconds = seconds;
        // Prazo por relógio: com contagem por tick, uma aba estrangulada
        // manteria o QR "válido" muito depois de o token ter morrido.
        this.expiresAt = Date.now() + seconds * 1000;

        var self = this;
        this.countdownTimer = setInterval(function () {
            if (Date.now() < self.expiresAt) return;
            self.stopCountdown();
            self.setState(STATE.EXPIRED);
        }, 1000);
    };

    SantaAppLink.prototype.stopCountdown = function () {
        if (this.countdownTimer) {
            clearInterval(this.countdownTimer);
            this.countdownTimer = null;
        }
    };

    var instance = new SantaAppLink();
    window.santaAppLink = instance;

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', function () { instance.init(); });
    } else {
        instance.init();
    }
})();
