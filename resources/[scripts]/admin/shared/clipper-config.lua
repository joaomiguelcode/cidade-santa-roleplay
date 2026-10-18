-- `cityName` ja e global no admin (shared.lua). Declarado aqui so como fallback para
-- o caso deste arquivo carregar primeiro.
cityName = cityName or GetConvar( 'cityName', '' )

---@class ClipperConfig
Clipper = {

    -- Cidades onde o clipe roda. O gate usa a convar `cityName`, que toda cidade ja
    -- define na propria cfg - nao existe convar nova para o clipper.
    --
    -- Fora daqui nada acontece: sem buffer, sem encode, sem comando, sem clipe.
    enabledCities = {
        [ 'Kingdom' ] = true,
        [ 'Grande' ] = true,
    },

    -- Gravacao da tela do proprio suspeito nas cidades habilitadas.
    suspect = {
        enabledCities = {
            [ 'Maresia' ] = true,
            [ 'Grande' ] = true,
            [ 'Kingdom' ] = true,
        },
        minScore = 30,
        durationMs = 180000,
        coalesceMs = 120000,
        width = 1280,
        height = 720,
        fps = 15,
        audioBitrate = 0,
        bufferRecorders = 3,
        maxUploadBytes = 32 * 1024 * 1024,
        uploadTimeoutMs = 10000,
        retentionDays = 30,
    },

    -- ENG-3948/3949: observacao de KD unificado. Ajustes sem nova build.
    kdObservation = {
        enabledCities = { Maresia = true, Grande = true, Kingdom = true },
        minKills = 10,
        minKd = 3.0,
        toxicKd = 5.0,
        lookbackDays = 7,
        damageWindowSeconds = 10,
        beforeMs = 90000,
        afterMs = 90000,
        maxClipsPerDay = 3,
        minClipIntervalSeconds = 1800,
        cleanCooldownDays = 14,
    },

    -- Endpoint do clipe de ban.
    --
    -- A Kingdom usa o Helpdesk UK; Grande e Maresia usam o Helpdesk BR.
    -- O fallback preserva o destino dos comandos de teste em cidades desabilitadas.
    apiUrl = 'https://support.roleply.com/api/ban-clips',
    apiUrlByCity = {
        [ 'Kingdom' ] = 'https://support.roleply.com/api/ban-clips',
        [ 'Grande' ] = 'https://suporte.santagroup.gg/api/ban-clips',
        [ 'Maresia' ] = 'https://suporte.santagroup.gg/api/ban-clips',
    },

    -- Duracao minima garantida do clipe retroativo, em milissegundos.
    --
    -- E um piso, nao um valor exato: com 2 gravadores o clipe entregue cobre de
    -- `durationMs` ate o dobro disso - com 45 s, de 45 s a 90 s.
    --
    -- Nao e preciso recalcular bitrate ao mexer aqui: `maxUploadBytes` deriva o bitrate
    -- do pior caso sozinho. Janela maior troca qualidade por duracao, nao por falha de
    -- envio. Suba `bufferRecorders` para apertar a faixa e recuperar bitrate, ao custo
    -- de mais encode na maquina do admin.
    durationMs = 45000,

    -- Piso para aceitar um clipe incompleto.
    --
    -- O buffer so cobre a janela inteira `durationMs` depois de armar. Um ban aplicado
    -- antes disso - admin que acabou de entrar, ou logo apos um `restart admin` - antes
    -- era descartado como `buffer_warming`, perdendo os segundos que ja existiam.
    -- Agora o que houver e enviado, desde que passe deste piso; a duracao real vai no
    -- meta da sessao, entao o suporte sabe que aquele clipe e curto e por que.
    --
    -- Zero desativa o parcial e volta ao comportamento de tudo ou nada.
    minClipMs = 5000,

    -- Quantidade de gravadores sobrepostos que mantem o buffer retroativo.
    -- Cada gravador produz um segmento WebM completo e autonomo; ao pedir o clipe, o
    -- mais antigo em execucao e fechado e vira o arquivo final.
    --
    -- Com N gravadores o segmento dura `durationMs * N / (N - 1)` e o clipe entregue
    -- cobre de `durationMs` ate esse valor.
    --
    -- N e escolha de QUALIDADE, nao de duracao. O bitrate sai de `maxUploadBytes`
    -- dividido pelo PIOR caso, entao encurtar o pior caso e o que sobra de bitrate:
    -- com a janela de 45 s, N=2 da pior caso de 90 s e ~635 kbps; N=3 da 67 s e
    -- ~868 kbps; N=4 da 60 s e ~985 kbps. Cada um custa um encode a mais na maquina do
    -- admin, e o buffer em memoria cresce junto (N=4 com 720p fica em ~30 MB).
    --
    -- Nao use N=1: sem sobreposicao nao ha garantia da janela retroativa.
    bufferRecorders = 3,

    -- Resolucao de saida. O texture do jogo e reescalado para esse tamanho na GPU,
    -- entao valores menores reduzem bitrate, CPU de encode e tamanho do upload.
    --
    -- 720p cabe com a janela de 45 s: o pior caso de 68 s deixa 3913 kbps.
    width  = 1280,
    height = 720,

    -- O custo do encode e proporcional a `width * height * fps * bufferRecorders`. O
    -- perfil que travou a maquina do admin tinha 160% da carga do perfil que desenhou
    -- 20 de 20 fps; este tem 150%, e o servidor avisa se os quadros desenhados ficarem
    -- abaixo do alvo.
    fps = 30,

    -- Teto de bitrate, nao alvo: guarda contra janela curta pedir um numero absurdo
    -- (no `/clipe-teste`, de 3 s, o orcamento sozinho liberaria dezenas de Mbps). O
    -- valor efetivo sai de `maxUploadBytes` e costuma ser bem menor.
    videoBitrate = 6000000,

    -- Orcamento de bytes por clipe.
    --
    -- Deixou de ser limite de seguranca e virou so o regulador do bitrate: o corte de
    -- 8 MB do `fetch` do CEF vale por REQUISICAO, e acima de `chunkThresholdBytes` o
    -- clipe sai fatiado. O teto agora e o da API, 40 MB.
    --
    -- Em vez de acertar o bitrate no olho a cada mudanca de `durationMs`, o bitrate
    -- passa a ser derivado deste orcamento para o PIOR caso (o segmento inteiro).
    -- Mudar a duracao nao volta a estourar o envio sozinho.
    --
    -- 32 MB deixa margem sob os 40 da API para o encode passar do alvo, o que ele faz:
    -- medido em 107% num clipe real.
    maxUploadBytes = 32 * 1024 * 1024,
    audioBitrate = 64000,

    -- Envio em partes (API v3.2). Acima do limiar o clipe e fatiado e cada parte vai
    -- numa requisicao propria, entao nenhuma chega perto do corte do CEF. Abaixo dele
    -- segue o multipart de uma vez so, que e o caminho ja rodado em producao.
    --
    -- 4 MB por parte contra os 5 MB que a API aceita: a folga cobre o overhead e mantem
    -- distancia do corte. Zero no limiar desliga o fatiamento.
    chunkThresholdBytes = 6 * 1024 * 1024,
    chunkBytes = 4 * 1024 * 1024,

    -- VP8 na frente do VP9 de proposito. Medido na base: o VP9 estourou o alvo de
    -- 1,5 Mbps e entregou 2,7 Mbps, o que dobra o tempo de envio, e ainda custa bem
    -- mais CPU - que aqui pesa em dobro, porque sao dois gravadores simultaneos.
    -- Coloque 'vp9' para priorizar qualidade por bit em vez de tamanho e custo.
    preferredCodec = 'vp8',

    -- `preserveDrawingBuffer` forca o Chromium a manter o framebuffer entre frames.
    -- Custa uma copia por frame, mas o canvas aqui fica com `opacity: 0` e 1px de CSS:
    -- sem isso o Chromium pode descartar o buffer antes do `captureStream` ler, e o
    -- clipe sai preto. So desligue se o video continuar correto sem ele.
    preserveDrawingBuffer = true,

    -- Comando que liga/desliga o HUD de metricas da NUI. Use para medir o custo real
    -- do buffer antes de liberar para o time de staff.
    debugCommand = 'clipe-debug',

    -- Comando de teste ponta a ponta: grava um clipe curto e manda para a API com um
    -- ban falso, marcado com `test = true` no payload.
    --
    -- E o UNICO ponto que ignora `Clipper.IsEnabled()`, de proposito: serve para
    -- validar a integracao em qualquer cidade antes de habilitar de verdade. Continua
    -- exigindo a mesma permissao de staff.
    testCommand = 'clipe-teste',

    -- Perfil do buffer durante o teste. Curto para o ciclo inteiro levar segundos em
    -- vez do minuto do fluxo real (aquecimento + clipe + envio).
    test = {
        durationMs = 3000,
        banId      = 0,
        reason     = '[TESTE] clipper',
    },

    -- Intervalo com que o client manda FPS/frame time do jogo para o HUD de debug.
    -- Nada e enviado enquanto o HUD estiver desligado.
    debugSampleMs = 500,

    -- Queima uma tarja no rodape do video com cidade, passaporte do admin e data/hora.
    -- A NUI dos outros resources (HUD, celular, menus) nao entra no clipe: cada pagina
    -- e um browser CEF isolado e nenhuma enxerga os pixels da outra. A tarja ao menos
    -- faz o clipe se identificar sozinho como evidencia.
    burnInOverlay = true,

    -- Microfone do admin na trilha do clipe.
    --
    -- E a unica fonte de audio que o CEF alcanca, e cobre a voz do proprio admin -
    -- que narrando a punicao ja e evidencia. A voz dos OUTROS nao vem por aqui: o
    -- Mumble e renderizado pelo motor de audio do GTA e nao passa pela NUI; ela
    -- depende do Zumble reter audio bruto (ver README).
    captureMicrophone = true,

    -- Saida manual: o fluxo normal pede sozinho ao armar.
    micCommand = 'clipe-mic',

    -- Dispositivos de loopback preferidos, por trecho do nome (minusculas).
    --
    -- Loopback e a saida da placa de som virada em entrada: capturando por ele, o
    -- clipe leva tudo que o admin OUVE - Mumble, jogo, tudo ja mixado e em sincronia
    -- nativa, sem depender do Zumble. O microfone comum so traz a voz do proprio
    -- admin, porque a voz dos outros sai pelo fone e nunca entra no mic.
    --
    -- Nem toda placa expoe isso e no Windows costuma vir desativado, entao e sempre
    -- melhor-esforco: sem loopback, usa o dispositivo padrao. Deixe a lista vazia
    -- para nunca tentar.
    loopbackDevicePatterns = {
        'mixagem estereo',
        'mixagem estéreo',
        'stereo mix',
        'what u hear',
        'wave out',
        'loopback',
        'cable output',
        'vb-audio',
        'voicemeeter',
        'virtual audio',
    },

    -- Espera antes do pedido automatico, para o prompt nao cair na tela de loading.
    micPrimeDelayMs = 15000,

    -- Intervalo entre novas tentativas quando o microfone nao veio.
    micRetryMs = 30000,

    -- Voz do clipe. Nada e capturado nem mixado: o Zumble ja grava cada fala e o
    -- sidecar de voz guarda o `.ogg` com um `audioKey`. O `admin` emite
    -- `voice:audioKey` a cada relatorio, e o clipe anota as chaves da sua janela no
    -- `.json` irmao. Quem monta a evidencia resolve o audio por essas chaves.
    voice = {

        enabled = true,


        -- Folga antes da janela, para nao perder a fala que comecou logo antes dela.
        paddingSeconds = 2,

        -- Latencia do STT: o relatorio do sidecar chega alguns segundos depois da
        -- fala, entao a janela precisa continuar aberta depois do fim do clipe.
        reportLagSeconds = 15,

        -- Pedido direto ao Zumble: "me da o audio desta janela".
        --
        -- IMPLEMENTADO E DESLIGADO DE PROPOSITO. Depende de um buffer de audio bruto
        -- que ainda nao existe do lado do Zumble - hoje o sidecar so persiste as
        -- falas que viraram incidente de toxicidade. Enquanto isso nao existir, o
        -- audio do clipe vem do microfone do admin (`captureMicrophone`).
        --
        -- Para ligar: `zumble.enabled = true` + as convars abaixo.
        --   set clipper_zumbleUrl   "https://<zumble>/clip-window"
        --   set clipper_zumbleToken "<bearer>"
        zumble = {

            enabled = false,

            urlConvar   = 'clipper_zumbleUrl',
            tokenConvar = 'clipper_zumbleToken',

            timeoutMs = 10000,

            -- 'listener' pede o mix do que o ADMIN ouviu: uma trilha so, ja misturada
            --   e ja alinhada ao relogio. O Zumble e quem roteia a voz por
            --   proximidade, entao so ele sabe reconstruir isso - e assim nao sobra
            --   nenhum trabalho de mixagem nem de alinhamento por fala.
            -- 'speakers' pede as falas de cada um separadas, para quem preferir
            --   mixar no destino.
            mode = 'listener',
        },
    },

    -- Registra quem estava falando por perto durante a janela do clipe. Nao grava
    -- audio: guarda serverId, passaporte e os instantes de fala, que e o que permite
    -- casar o clipe com o audio ja gravado pelo Zumble.
    recordTalkers = true,

    -- Frequencia da amostragem de quem esta falando.
    talkerSampleMs = 250,

    -- Cooldown por passaporte entre clipes. Precisa ser >= a duracao do segmento,
    -- senao o buffer nao tem tempo de reescalonar e o clipe seguinte sai curto.
    cooldownMs = 60000,

    -- Tempo maximo que uma sessao fica aberta aguardando o upload terminar.
    sessionTimeoutMs = 180000,

    -- Grupos autorizados a ter o buffer ligado e a gerar clipe de ban.
    permissions = {
        [ 'Admin' ] = 5,
        [ 'SS'    ] = 5,
    },
}

--- Endpoint do clipe de ban.
---@return string
function Clipper.ApiUrl()
    return Clipper.apiUrlByCity[ cityName ] or Clipper.apiUrl
end

--- O clipe roda nesta cidade?
---
--- Decidido pela convar `cityName`, que a cidade ja define na cfg. Fora das cidades
--- habilitadas gravar seria so queimar CPU do admin, entao nao ha buffer, encode,
--- comando nem clipe.
---@return boolean
function Clipper.IsEnabled()
    return Clipper.enabledCities[ cityName ] == true
end

--- Duracao de cada segmento do buffer, derivada da sobreposicao.
---@return integer
---@param durationMs integer|nil  janela alternativa (usada pelo `/clipe-teste`)
---@return integer
function Clipper.SegmentMs( durationMs, bufferRecorders )

    local recorders = math.max( 2, bufferRecorders or Clipper.bufferRecorders )

    return math.ceil( ( durationMs or Clipper.durationMs ) * recorders / ( recorders - 1 ) )
end

--- Piso de qualidade. Abaixo disto o clipe deixa de servir como prova, entao preferimos
--- avisar no boot a entregar um borrao dentro do orcamento.
-- Piso de qualidade em bits por pixel, nao em bitrate absoluto: 100 kbps e decente em
-- 540p e ilegivel em 1080p, entao um numero fixo deixa de valer assim que a resolucao
-- muda. 0,03 fica abaixo do perfil 540p original (0,047), o que faz dele um piso de
-- verdade sem estreitar o que ja rodava.
local MIN_BITS_PER_PIXEL = 0.03

---@return integer
local function MinVideoBitrate()

    return math.floor( Clipper.width * Clipper.height * Clipper.fps * MIN_BITS_PER_PIXEL )
end

--- Bitrate de video que cabe em `maxUploadBytes` no pior caso.
---
--- O pior caso e o segmento inteiro, nao a janela minima: o clipe entregue e o gravador
--- mais antigo, que pode ter ate `SegmentMs` acumulado. Dimensionar pela janela minima
--- deixaria metade dos clipes acima do teto.
---
--- O audio entra na conta porque ele tambem ocupa o mesmo orcamento.
---@param durationMs integer|nil
---@return integer
function Clipper.VideoBitrate( durationMs, profile )

    profile = profile or Clipper
    local budget = profile.maxUploadBytes

    if not budget or budget <= 0 then
        return profile.videoBitrate or Clipper.videoBitrate
    end

    local worstSeconds = Clipper.SegmentMs( durationMs, profile.bufferRecorders ) / 1000
    local fits = math.floor( ( budget * 8 ) / worstSeconds ) - ( profile.audioBitrate or 0 )

    -- Nunca acima do teto configurado: o orcamento serve para baixar, nao para subir.
    -- E nunca abaixo do piso: um clipe ilegivel nao serve de prova, entao acima de uma
    -- certa janela o certo e avisar (ver `FitsBudget`), nao entregar um borrao.
    local minVideoBitrate = profile == Clipper and MinVideoBitrate()
        or math.floor( profile.width * profile.height * profile.fps * MIN_BITS_PER_PIXEL )
    return math.max( minVideoBitrate, math.min( profile.videoBitrate or Clipper.videoBitrate, fits ) )
end

--- A janela configurada cabe no orcamento sem furar o piso de qualidade?
---
--- Falso quer dizer que o clipe vai passar de `maxUploadBytes` e ser cortado no envio.
--- O boot avisa; a saida e diminuir `durationMs`, subir `bufferRecorders` (que encurta
--- o pior caso) ou baixar a resolucao.
---@param durationMs integer|nil
---@return boolean
function Clipper.FitsBudget( durationMs )

    if not Clipper.maxUploadBytes or Clipper.maxUploadBytes <= 0 then
        return true
    end

    local worstSeconds = Clipper.SegmentMs( durationMs ) / 1000
    local bytes = ( Clipper.VideoBitrate( durationMs ) + ( Clipper.audioBitrate or 0 ) ) * worstSeconds / 8

    return bytes <= Clipper.maxUploadBytes
end
