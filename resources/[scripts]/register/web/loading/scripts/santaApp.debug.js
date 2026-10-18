/**
 * ENG-2981 — painel de debug do bloco de vínculo (Santa App).
 *
 * Só liga fora do FiveM (ou com ?santaDebug=1 na URL). Dentro do jogo o
 * arquivo carrega, não encontra ambiente de browser e sai sem tocar em nada —
 * mesmo padrão do DebugMenu do register.
 *
 * Serve para conferir o bloco contra o frame "01 · Loadscreen" do Figma:
 *  - forçar cidade e estados;
 *  - injetar sessões falsas (link, código, validade);
 *  - "Conferir medidas": compara os valores computados com os do Figma;
 *  - "Guias": desenha o contorno de cada nó com medida real vs esperada.
 */
(function () {
    'use strict';

    /**
     * Dentro do FiveM a página é servida por nui:// ou https://cfx-nui-*, nunca
     * por localhost/file. Usar a origem como discriminador é mais seguro do que
     * procurar invokeNative: se o painel vazasse para produção, apareceria em
     * cima da loading de todo mundo.
     */
    function isBrowserPreview() {
        var host = window.location.hostname;
        return window.location.protocol === 'file:' ||
            host === 'localhost' || host === '127.0.0.1' || host === '';
    }

    function isDebugEnabled() {
        if (/[?&]santaDebug=1/.test(window.location.search)) return true;
        return isBrowserPreview();
    }

    if (!isDebugEnabled()) return;

    /**
     * Medidas do Figma (UIX-231 · "Bloco - vínculo QR"), em px @1920x1080.
     * `tol` é a folga aceita — os valores fracionários do Figma são arredondados
     * pelo layout do browser.
     */
    var SPEC = [
        { sel: '.santa-link', node: 'Bloco - vínculo QR', props: [
            ['width', 416], ['height', 126.21, 1.5], ['padding-top', 12], ['padding-left', 12],
            ['column-gap', 12], ['border-top-left-radius', 4],
            ['background-color', 'rgba(0, 0, 0, 0.6)'], ['justify-content', 'flex-end'],
            ['align-items', 'center']
        ] },
        { sel: '.santa-link__content', node: 'Vínculo - conteúdo', props: [
            ['width', 278], ['height', 102, 1.5], ['row-gap', 12],
            ['flex-direction', 'column'], ['justify-content', 'center'], ['align-items', 'flex-end']
        ] },
        { sel: '.santa-link__text', node: 'Vínculo - texto', props: [
            ['width', 278], ['height', 59, 1.5], ['column-gap', 8], ['align-items', 'center']
        ] },
        { sel: '.santa-link__labels', node: 'Vínculo - rótulos', props: [
            ['width', 268], ['height', 59, 1.5], ['row-gap', 6],
            ['flex-direction', 'column'], ['align-items', 'flex-end']
        ] },
        { sel: '.santa-link__title', node: '"ADIANTE O VINCULO"', props: [
            ['font-size', 16], ['font-weight', '700'], ['color', 'rgb(255, 255, 255)']
        ] },
        { sel: '.santa-link__description', node: '"Escaneie o QR Code…"', props: [
            ['font-size', 14], ['font-weight', '500'], ['color', 'rgb(191, 191, 191)'],
            ['text-align', 'right'], ['height', 34, 1.5]
        ] },
        { sel: '.santa-link__accent', node: 'Rectangle 18', props: [
            ['width', 2], ['height', 52]
        ] },
        { sel: '.santa-link__stores', node: 'Vínculo - lojas', props: [
            ['width', 218], ['height', 31.21, 1.5], ['column-gap', 8.14, 0.3],
            ['align-items', 'flex-start']
        ] },
        { sel: '.santa-link__store', node: 'Selo de loja', props: [
            ['width', 104.93, 1], ['height', 31.21, 1.5]
        ] },
        { sel: '.santa-link__qr', node: 'QR block', props: [
            ['width', 102], ['height', 102], ['padding-top', 7.65, 0.3],
            ['border-top-left-radius', 7.65, 0.3], ['background-color', 'rgb(255, 255, 255)']
        ] }
    ];

    var MOCK = {
        qrLink: 'https://app.santagroup.gg/link/SNTA-7K29',
        code: 'SNTA7K29',
        expiresIn: 300,
        stores: {
            ios: 'https://apps.apple.com/br/app/santa-group',
            android: 'https://play.google.com/store/apps/details?id=gg.santagroup'
        }
    };

    var STATES = ['PREPARING', 'WAITING', 'EXPIRED', 'ERROR', 'LINKED'];

    var panel;
    var output;
    var guidesOn = false;

    function css() {
        var style = document.createElement('style');
        style.textContent = [
            '.santa-debug{position:fixed;left:12px;bottom:12px;z-index:9999998;width:330px;',
            'font:11px/1.45 Consolas,Menlo,monospace;color:#E6E6E6;background:rgba(10,10,12,.94);',
            'border:1px solid rgba(255,255,255,.14);border-radius:8px;padding:10px;',
            'box-shadow:0 12px 32px rgba(0,0,0,.6);user-select:text}',
            '.santa-debug[data-collapsed="1"] .santa-debug__body{display:none}',
            '.santa-debug__head{display:flex;align-items:center;justify-content:space-between;gap:8px;',
            'cursor:pointer;font-weight:700;letter-spacing:.04em;color:#22D3EE}',
            '.santa-debug__row{display:flex;flex-wrap:wrap;gap:4px;margin-top:8px}',
            '.santa-debug__label{width:100%;color:#8A8A93;text-transform:uppercase;letter-spacing:.06em;',
            'font-size:9px;margin-top:6px}',
            '.santa-debug button{font:inherit;color:#E6E6E6;background:rgba(255,255,255,.07);',
            'border:1px solid rgba(255,255,255,.12);border-radius:4px;padding:3px 7px;cursor:pointer}',
            '.santa-debug button:hover{background:rgba(255,255,255,.14)}',
            '.santa-debug button[data-active="1"]{background:#22D3EE;border-color:#22D3EE;color:#04222A;',
            'font-weight:700}',
            '.santa-debug input{font:inherit;color:#E6E6E6;background:rgba(255,255,255,.05);',
            'border:1px solid rgba(255,255,255,.12);border-radius:4px;padding:3px 6px;flex:1;min-width:0}',
            '.santa-debug__out{margin-top:8px;max-height:230px;overflow:auto;border-top:1px solid ',
            'rgba(255,255,255,.12);padding-top:6px;white-space:pre-wrap}',
            '.santa-debug__out b{color:#FFF}',
            '.santa-debug__ok{color:#4ADE80}.santa-debug__bad{color:#FF6B6B}',
            '.santa-debug__node{color:#22D3EE}',
            '.santa-guide{position:fixed;z-index:9999997;pointer-events:none;',
            'outline:1px dashed rgba(34,211,238,.9);outline-offset:0}',
            '.santa-guide span{position:absolute;left:0;top:-13px;white-space:nowrap;',
            'font:9px/1 Consolas,monospace;color:#04222A;background:#22D3EE;padding:2px 4px;border-radius:2px}',
            '.santa-guide[data-bad="1"]{outline-color:rgba(255,107,107,.95)}',
            '.santa-guide[data-bad="1"] span{background:#FF6B6B;color:#2A0404}'
        ].join('');
        document.head.appendChild(style);
    }

    function button(label, onClick, name) {
        var el = document.createElement('button');
        el.type = 'button';
        el.textContent = label;
        if (name) el.dataset.name = name;
        el.addEventListener('click', onClick);
        return el;
    }

    function link() {
        return window.santaAppLink;
    }

    /** Aplica a sessão falsa e devolve o bloco ao estado de leitura. */
    function applyMock(extra) {
        var payload = JSON.parse(JSON.stringify(MOCK));
        if (extra) Object.keys(extra).forEach(function (k) { payload[k] = extra[k]; });
        link().syncCity('Grande');
        link().applySession(payload);
    }

    function markActiveState() {
        if (!panel) return;
        var current = link() ? link().state : '';
        panel.querySelectorAll('button[data-name^="state:"]').forEach(function (el) {
            el.dataset.active = el.dataset.name === 'state:' + current ? '1' : '0';
        });
    }

    // ---------- conferência de medidas ----------

    function readProp(el, prop) {
        var cs = getComputedStyle(el);
        if (prop === 'width') return el.getBoundingClientRect().width;
        if (prop === 'height') return el.getBoundingClientRect().height;
        var raw = cs.getPropertyValue(prop);
        var num = parseFloat(raw);
        return isNaN(num) || /[a-z%]/i.test(raw.replace(/px|\s|-?\d|\./gi, '')) ? raw.trim() : num;
    }

    function compare(actual, expected, tol) {
        if (typeof expected === 'number') {
            return Math.abs(actual - expected) <= (tol === undefined ? 0.6 : tol);
        }
        return String(actual).replace(/\s+/g, ' ') === String(expected);
    }

    function fmt(value) {
        return typeof value === 'number' ? Math.round(value * 100) / 100 : value;
    }

    function checkSpec() {
        var lines = [];
        var okCount = 0;
        var total = 0;

        SPEC.forEach(function (entry) {
            var el = document.querySelector(entry.sel);
            if (!el) {
                lines.push('<span class="santa-debug__bad">✗ ' + entry.sel + ' não encontrado</span>');
                return;
            }
            lines.push('<b class="santa-debug__node">' + entry.node + '</b>');
            entry.props.forEach(function (p) {
                var prop = p[0], expected = p[1], tol = p[2];
                var actual = readProp(el, prop);
                var ok = compare(actual, expected, tol);
                total++;
                if (ok) okCount++;
                lines.push(
                    '  <span class="santa-debug__' + (ok ? 'ok' : 'bad') + '">' +
                    (ok ? '✓' : '✗') + '</span> ' + prop + ': ' + fmt(actual) +
                    (ok ? '' : '  (Figma: ' + expected + ')')
                );
            });
        });

        // a descrição precisa quebrar em 2 linhas, como no Figma
        var desc = document.querySelector('.santa-link__description');
        if (desc) {
            // line-height é "normal" aqui, então conta pelos retângulos do Range
            var range = document.createRange();
            range.selectNodeContents(desc);
            var rows = range.getClientRects().length;
            total++;
            if (rows === 2) okCount++;
            lines.push(
                '<b class="santa-debug__node">Quebra do texto</b>\n  <span class="santa-debug__' +
                (rows === 2 ? 'ok">✓' : 'bad">✗') + '</span> linhas: ' + rows +
                (rows === 2 ? '' : '  (Figma: 2)')
            );
        }

        // A Inter vem do Google Fonts. Se ela falhar, o bloco cai no fallback e
        // o "peso" muda visivelmente — este bloco denuncia isso.
        lines.push('<b class="santa-debug__node">Fonte</b>');
        [['500 14px', 'descrição'], ['700 16px', 'título']].forEach(function (f) {
            var ok = document.fonts.check(f[0] + ' Inter');
            total++;
            if (ok) okCount++;
            lines.push('  <span class="santa-debug__' + (ok ? 'ok">✓' : 'bad">✗') +
                '</span> Inter ' + f[0] + ' (' + f[1] + ') carregada');
        });
        var probe = document.createElement('canvas').getContext('2d');
        probe.font = '500 14px Inter';
        var measured = probe.measureText('Escaneie o QR Code e vincule sua conta').width;
        var interOk = Math.abs(measured - 268.69) <= 3;
        total++;
        if (interOk) okCount++;
        lines.push('  <span class="santa-debug__' + (interOk ? 'ok">✓' : 'bad">✗') +
            '</span> largura da linha 1: ' + fmt(measured) +
            (interOk ? 'px (Inter)' : 'px  (Inter = 268,69 — está caindo no fallback)'));

        // distância até o rodapé (Corpo do Figma termina 10px acima)
        var card = document.querySelector('.santa-link');
        var footer = document.querySelector('.footer');
        if (card && footer) {
            var gap = footer.getBoundingClientRect().top - card.getBoundingClientRect().bottom;
            var ok = Math.abs(gap - 10) <= 1;
            total++;
            if (ok) okCount++;
            lines.push(
                '<b class="santa-debug__node">Posição</b>\n  <span class="santa-debug__' +
                (ok ? 'ok">✓' : 'bad">✗') + '</span> folga até o rodapé: ' + fmt(gap) + 'px' +
                (ok ? '' : '  (esperado: 10)')
            );
            var right = window.innerWidth - card.getBoundingClientRect().right;
            var okR = Math.abs(right - 20) <= 1;
            total++;
            if (okR) okCount++;
            lines.push(
                '  <span class="santa-debug__' + (okR ? 'ok">✓' : 'bad">✗') + '</span> margem direita: ' +
                fmt(right) + 'px' + (okR ? '' : '  (Figma: 20)')
            );
        }

        var head = okCount === total
            ? '<b class="santa-debug__ok">' + okCount + '/' + total + ' conferem com o Figma</b>'
            : '<b class="santa-debug__bad">' + okCount + '/' + total + ' conferem — veja os ✗</b>';

        output.innerHTML = head + '\n' + lines.join('\n');
    }

    // ---------- guias visuais ----------

    function clearGuides() {
        document.querySelectorAll('.santa-guide').forEach(function (el) { el.remove(); });
    }

    function drawGuides() {
        clearGuides();
        SPEC.forEach(function (entry) {
            document.querySelectorAll(entry.sel).forEach(function (el) {
                var rect = el.getBoundingClientRect();
                if (!rect.width || !rect.height) return;

                var w = entry.props.filter(function (p) { return p[0] === 'width'; })[0];
                var h = entry.props.filter(function (p) { return p[0] === 'height'; })[0];
                var bad = false;
                var label = entry.node + ' ' + fmt(rect.width) + '×' + fmt(rect.height);
                if (w && !compare(rect.width, w[1], w[2])) bad = true;
                if (h && !compare(rect.height, h[1], h[2])) bad = true;
                if (bad) label += ' · Figma ' + (w ? w[1] : '–') + '×' + (h ? h[1] : '–');

                var guide = document.createElement('div');
                guide.className = 'santa-guide';
                guide.dataset.bad = bad ? '1' : '0';
                guide.style.left = rect.left + 'px';
                guide.style.top = rect.top + 'px';
                guide.style.width = rect.width + 'px';
                guide.style.height = rect.height + 'px';
                guide.innerHTML = '<span>' + label + '</span>';
                document.body.appendChild(guide);
            });
        });
    }

    function toggleGuides(el) {
        guidesOn = !guidesOn;
        el.dataset.active = guidesOn ? '1' : '0';
        if (guidesOn) drawGuides(); else clearGuides();
    }

    // ---------- montagem do painel ----------

    function build() {
        css();

        panel = document.createElement('div');
        panel.className = 'santa-debug';
        panel.dataset.collapsed = '0';

        var head = document.createElement('div');
        head.className = 'santa-debug__head';
        head.innerHTML = '<span>SANTA APP · DEBUG (ENG-2981)</span><span>▾</span>';
        head.addEventListener('click', function () {
            panel.dataset.collapsed = panel.dataset.collapsed === '1' ? '0' : '1';
            head.lastChild.textContent = panel.dataset.collapsed === '1' ? '▸' : '▾';
        });
        panel.appendChild(head);

        var body = document.createElement('div');
        body.className = 'santa-debug__body';
        panel.appendChild(body);

        // cidade
        var cityLabel = document.createElement('div');
        cityLabel.className = 'santa-debug__label';
        cityLabel.textContent = 'cidade';
        body.appendChild(cityLabel);

        var cityRow = document.createElement('div');
        cityRow.className = 'santa-debug__row';
        cityRow.appendChild(button('Grande (mostra)', function () { applyMock(); markActiveState(); }));
        cityRow.appendChild(button('Maresia (esconde)', function () { link().syncCity('Maresia'); }));
        body.appendChild(cityRow);

        // estados
        var stateLabel = document.createElement('div');
        stateLabel.className = 'santa-debug__label';
        stateLabel.textContent = 'estado';
        body.appendChild(stateLabel);

        var stateRow = document.createElement('div');
        stateRow.className = 'santa-debug__row';
        STATES.forEach(function (state) {
            stateRow.appendChild(button(state, function () {
                link().syncCity('Grande');
                if (state === 'WAITING') applyMock();
                else link().setState(state);
                markActiveState();
                if (guidesOn) drawGuides();
            }, 'state:' + state));
        });
        body.appendChild(stateRow);

        // sessão
        var sessionLabel = document.createElement('div');
        sessionLabel.className = 'santa-debug__label';
        sessionLabel.textContent = 'sessão falsa (link · validade em s)';
        body.appendChild(sessionLabel);

        var sessionRow = document.createElement('div');
        sessionRow.className = 'santa-debug__row';
        var linkInput = document.createElement('input');
        linkInput.value = MOCK.qrLink;
        var secInput = document.createElement('input');
        secInput.value = '300';
        secInput.style.flex = '0 0 52px';
        sessionRow.appendChild(linkInput);
        sessionRow.appendChild(secInput);
        sessionRow.appendChild(button('aplicar', function () {
            link().lastRenderedLink = '';
            applyMock({ qrLink: linkInput.value, expiresIn: parseInt(secInput.value, 10) || 300 });
            markActiveState();
        }));
        sessionRow.appendChild(button('expirar em 3s', function () {
            link().lastRenderedLink = '';
            applyMock({ qrLink: linkInput.value, expiresIn: 3 });
            markActiveState();
            setTimeout(markActiveState, 3400);
        }));
        body.appendChild(sessionRow);

        // A/B de peso e suavização — para bater o texto contra o frame do Figma
        var fontLabel = document.createElement('div');
        fontLabel.className = 'santa-debug__label';
        fontLabel.textContent = 'fonte (figma: título 700 · descrição 500)';
        body.appendChild(fontLabel);

        var fontRow = document.createElement('div');
        fontRow.className = 'santa-debug__row';

        function weightButtons(sel, weights, figmaWeight) {
            weights.forEach(function (w) {
                var b = button(String(w), function () {
                    document.querySelectorAll(sel).forEach(function (el) { el.style.fontWeight = w; });
                    fontRow.querySelectorAll('button[data-name^="w:' + sel + '"]').forEach(function (o) {
                        o.dataset.active = o.textContent === String(w) ? '1' : '0';
                    });
                }, 'w:' + sel + ':' + w);
                b.dataset.active = w === figmaWeight ? '1' : '0';
                fontRow.appendChild(b);
            });
        }

        var titleTag = document.createElement('span');
        titleTag.style.cssText = 'width:100%;color:#8A8A93';
        titleTag.textContent = 'título';
        fontRow.appendChild(titleTag);
        weightButtons('.santa-link__title', [600, 700, 800], 700);

        var descTag = document.createElement('span');
        descTag.style.cssText = 'width:100%;color:#8A8A93';
        descTag.textContent = 'descrição';
        fontRow.appendChild(descTag);
        weightButtons('.santa-link__description', [400, 500, 600], 500);

        var smoothTag = document.createElement('span');
        smoothTag.style.cssText = 'width:100%;color:#8A8A93';
        smoothTag.textContent = 'suavização';
        fontRow.appendChild(smoothTag);
        var smooth = true;
        fontRow.appendChild(button('antialiased', function () {
            smooth = !smooth;
            var card = document.querySelector('.santa-link');
            card.style.webkitFontSmoothing = smooth ? 'antialiased' : 'auto';
            this.textContent = smooth ? 'antialiased' : 'auto (padrão)';
            this.dataset.active = smooth ? '1' : '0';
        })).dataset.active = '1';
        body.appendChild(fontRow);

        // conferência
        var checkLabel = document.createElement('div');
        checkLabel.className = 'santa-debug__label';
        checkLabel.textContent = 'conferência com o figma';
        body.appendChild(checkLabel);

        var checkRow = document.createElement('div');
        checkRow.className = 'santa-debug__row';
        checkRow.appendChild(button('Conferir medidas', checkSpec));
        checkRow.appendChild(button('Guias', function () { toggleGuides(this); }, 'guides'));
        checkRow.appendChild(button('Limpar', function () {
            output.innerHTML = '';
            clearGuides();
            guidesOn = false;
            var g = panel.querySelector('button[data-name="guides"]');
            if (g) g.dataset.active = '0';
        }));
        body.appendChild(checkRow);

        output = document.createElement('div');
        output.className = 'santa-debug__out';
        body.appendChild(output);

        document.body.appendChild(panel);

        window.addEventListener('resize', function () { if (guidesOn) drawGuides(); });

        // Já abre no estado do Figma para a comparação direta. A conferência
        // espera a Inter: com a fonte de fallback as alturas dão falso negativo.
        applyMock();
        markActiveState();
        var whenReady = document.fonts && document.fonts.ready
            ? document.fonts.ready
            : Promise.resolve();
        whenReady.then(function () {
            setTimeout(checkSpec, 60);
        });
    }

    function start() {
        if (!window.santaAppLink) {
            setTimeout(start, 60);
            return;
        }
        build();
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', start);
    } else {
        start();
    }
})();
