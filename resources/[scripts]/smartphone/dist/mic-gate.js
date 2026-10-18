// mic-gate.js — patch sidecar (carregado antes do app.js, como o translate.js)
//
// O app.js solicita o microfone no boot, fazendo o FiveM exibir o prompt de
// permissão assim que a NUI monta. Aqui adiamos o prompt para a abertura do
// celular sem editar o app.js (artefato minificado): envolvemos o
// navigator.mediaDevices.getUserMedia. Antes da primeira mensagem "open",
// rejeitamos sem chamar a API nativa (sem prompt). Na primeira "open",
// liberamos o prompt e as chamadas reais seguem funcionando.

(function () {
    const md = navigator.mediaDevices;

    console.log('md=', md)

    const realGetUserMedia = md.getUserMedia.bind(md);
    let opened = false;

    console.log('realGetUserMedia', realGetUserMedia)

    md.getUserMedia = function (constraints) {
        if (!opened) {
            // Celular fechado: nega sem disparar o prompt nativo.
            return Promise.reject(
                new DOMException('Microphone gated until phone open', 'NotAllowedError')
            );
        }
        return realGetUserMedia(constraints);
    };

    window.addEventListener('message', function (event) {
        const data = event && event.data;
        console.log('messagedata', JSON.stringify(data));
        if (!data || data.event !== 'open' || opened) return;
        opened = true;
        // Dispara o prompt de permissão do FiveM na primeira abertura.
        realGetUserMedia({ audio: { autoGainControl: false } }).catch(function () {});
        console.log('get usermedia')
    });
})();
