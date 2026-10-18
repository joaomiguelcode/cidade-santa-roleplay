--- Wall (admin ESP) — coleta de dados (tick 500ms) e desenho per-frame.
--- Expõe apenas `WallClient.StartRender(gen)`. Todo o resto é local a este arquivo.

-- Traduções/constantes resolvidas uma única vez, no load do arquivo.
local gDeadLabel = ('~r~%s~w~'):format(_t('dead'))
local gSpeakingSuffix = ('\n~g~%s~w~'):format(_t('speaking'))
local gOnDutyLine = ('\n[~g~%s~w~]'):format(_t('on_duty_tag'))
local gOffDutyLine = ('\n[~r~%s~w~]'):format(_t('off_duty_tag'))
local gStaffDutyEnabled = true
local gRecordingLabel = _t('recording_text')
local gBugXpLabel = _t('bugxp_text')
local gProjectCsLabel = _t('projectcs_text')
local gMetricLowLabel = _t('metric_text_low')
local gMetricMediumLabel = _t('metric_text_medium')
local gMetricHighLabel = _t('metric_text_high')
local gDeadByLabel = _t('dead_by')
local gMinutesAgoSuffix = _t('minutes_ago')

---@type string[]
local gRgbTable = {
    "~r~",
    "~g~",
    "~b~",
    "~y~",
    "~p~",
    "~o~",
    "~w~",
}

---@type table<number, { [1]: number, [2]: number }>
local gVehicleOffsets = {
    [-1] = { -1.2, 1.2 },
    [0] = { 1.2, 1.2 },
    [1] = { -1.2, 0.0 },
    [2] = { 1.2, 0.0 },
    [3] = { -1.2, -1.2 },
    [4] = { 1.2, -1.2 },
    [5] = { -1.2, -2.4 },
    [6] = { 1.2, -2.4 },
}

---@class WallRenderEntry
---@field _stale boolean
---@field idx number                    -- índice do player (não o serverId); usado pelos natives por frame
---@field talkingLabel string           -- texto do overlay 2D de fala, pré-montado no tick
---@field noInfo boolean                -- true quando não há WallPlayerInfo (desconhecido)
---@field hidden boolean                -- forceRemoveWall: sem desenho 3D, mas participa do overlay de fala
---@field topText string|nil            -- usado apenas quando noInfo
---@field topTextBase string|nil        -- texto cru do nome (detecção de mudança)
---@field topDraw WallDrawText|nil
---@field topDrawTalking WallDrawText|nil -- nome + sufixo de fala, pré-montado
---@field bottomSource string|nil       -- texto cru do bloco de baixo (detecção de mudança)
---@field bottomText WallDrawText|nil
---@field headStack WallHeadStack|nil
---@field headStackTalking WallHeadStack|nil
---@field recordingText string|nil       -- entrada do último FillHeadStack (detecção de mudança)
---@field dutyLine string|nil            -- idem
---@field playerState table|nil          -- proxy de Player(serverId).state reaproveitado
---@field entityState table|nil          -- proxy de Entity(ped).state reaproveitado
---@field statePed number|nil            -- ped do entityState
---@field nameTag wall.Nametag|nil
---@field drawRainbowLine boolean|nil
---@field removeWall boolean|nil
---@field vehicle number|nil            -- handle do veículo no tick; 0 se não está em veículo
---@field offsetX number|nil
---@field offsetY number|nil

---@class WallFreecamRenderEntry
---@field _stale boolean
---@field ref NetFreecam                -- referência viva; `.pos` é mutado ao vivo por freecam.lua
---@field topText WallDrawText
---@field bottomText WallDrawText
---@field headStack WallHeadStack
---@field nameTag wall.Nametag|nil

---@param h number
---@param s number
---@param v number
---@return number r
---@return number g
---@return number b
local function HSVToRGB(h, s, v)

    local i = math.floor(h * 6)
    local f = h * 6 - i
    local p = v * (1 - s)
    local q = v * (1 - f * s)
    local t = v * (1 - (1 - f) * s)

    local r, g, b

    if i % 6 == 0 then
        r, g, b = v, t, p
    elseif i % 6 == 1 then
        r, g, b = q, v, p
    elseif i % 6 == 2 then
        r, g, b = p, v, t
    elseif i % 6 == 3 then
        r, g, b = p, q, v
    elseif i % 6 == 4 then
        r, g, b = t, p, v
    else
        r, g, b = v, p, q
    end

    return math.floor(r * 255), math.floor(g * 255), math.floor(b * 255)
end

---@param milliseconds number
---@return string
local function FormatTimerWallStreet(milliseconds)

    local totalSeconds = math.floor(milliseconds / 1000)
    local minutes = math.floor(totalSeconds / 60)
    local seconds = totalSeconds % 60

    return ('%02d:%02d'):format(minutes, seconds)
end

---@param milliseconds number
---@return string
local function FormatNegativeTimerWallStreet(milliseconds)

    milliseconds = milliseconds * -1
    local totalSeconds = math.floor(milliseconds / 1000)
    local minutes = math.floor(totalSeconds / 60)

    return ('%02d'):format(minutes) .. gMinutesAgoSuffix
end

---@param elapsedMs number
---@return string
local function FormatAfkDuration(elapsedMs)

    local totalMinutes = math.floor(elapsedMs / 60000)
    local hours = math.floor(totalMinutes / 60)
    local minutes = totalMinutes % 60

    if hours > 0 then
        return ('%dH %02dMIN'):format(hours, minutes)
    end

    return ('%d MIN'):format(totalMinutes)
end

-- Altura de uma linha de texto (scale 0.35, font 4) em coordenada de tela.
local GetLineHeightNative = GetRenderedCharacterHeight or GetTextScaleHeight
local gLineHeight = GetLineHeightNative and GetLineHeightNative(0.35, 4) or 0.027

---@param text string
---@return integer
local function CountLineBreaks(text)
    local _, count = text:gsub('\n', '')
    return count
end

-- O GTA corta cada componente de texto (~99 bytes, contando os tokens ~x~). Texto maior vira vários
-- componentes no MESMO DrawText, usando um label com vários ~a~.
local TEXT_CHUNK_BYTES = 60
local TEXT_MAX_CHUNKS = 8

-- Um label por quantidade de componentes, com EXATAMENTE um ~a~ por componente. Label com ~a~ sobrando
-- faz o GTA preencher o resto com componentes velhos do buffer (de outro DrawText): era o nome
-- duplicado piscando e o bloco de baixo sumindo quando o texto estourava.
---@type string[]
local gChunkedTextLabels = {}

for count = 1, TEXT_MAX_CHUNKS do
    gChunkedTextLabels[count] = ('WALL_CHUNKED_TEXT_%d'):format(count)
    AddTextEntry(gChunkedTextLabels[count], ('~a~'):rep(count))
end

---@alias WallDrawText string|string[]  -- string cabe num componente; array são os componentes em ordem

--- Maior corte <= limite que não cai dentro de um token ~x~ nem no meio de um caractere UTF-8.
---@param piece string
---@return integer
local function FindSafeCut(piece)

    for cut = TEXT_CHUNK_BYTES, 1, -1 do
        local nextByte = piece:byte(cut + 1)
        local insideUtf8 = nextByte and nextByte >= 0x80 and nextByte <= 0xBF
        local _, tildes = piece:sub(1, cut):gsub('~', '')

        if not insideUtf8 and tildes % 2 == 0 then
            return cut
        end
    end

    return TEXT_CHUNK_BYTES
end

--- Quebra o texto em componentes de até TEXT_CHUNK_BYTES, preferindo cortar nas quebras de linha.
--- Só roda no tick e só pra texto que não cabe num componente.
---@param text string
---@return string[]
local function SplitTextChunks(text)

    local chunks = {}
    local current = ''
    local first = true

    for line in (text .. '\n'):gmatch('(.-)\n') do

        local piece = first and line or '\n' .. line
        first = false

        if #current + #piece <= TEXT_CHUNK_BYTES then
            current = current .. piece
        else
            if current ~= '' then
                chunks[#chunks + 1] = current
            end

            while #piece > TEXT_CHUNK_BYTES do
                local cut = FindSafeCut(piece)
                chunks[#chunks + 1] = piece:sub(1, cut)
                piece = piece:sub(cut + 1)
            end

            current = piece
        end
    end

    if current ~= '' then
        chunks[#chunks + 1] = current
    end

    -- Acima de TEXT_MAX_CHUNKS * TEXT_CHUNK_BYTES o resto é descartado; aumente o label se precisar.
    for i = TEXT_MAX_CHUNKS + 1, #chunks do
        chunks[i] = nil
    end

    return chunks
end

--- Texto pronto pra desenhar: a própria string se couber num componente, senão os componentes.
---@param text string
---@return WallDrawText
local function PrepareDrawText(text)

    -- ponytail: fatiar em vários componentes (label com N ~a~) estoura o buffer de texto do frame com
    -- muita gente na tela e o GTA desenha nomes/SOURCE de outros players. Volta a ser um componente só
    -- (texto > ~99 bytes corta, como antes do refactor).
    return text
end

---@class WallHeadStack
---@field recording WallDrawText|nil  -- tags de gravação/bug xp já com padding pra começar embaixo do nome
---@field duty WallDrawText|nil       -- selo de serviço com padding pra ficar embaixo das tags de gravação
---@field lines integer               -- linhas ocupadas na âncora da cabeça (nome + gravação + selo)

--- Selo de serviço: em serviço em verde; staff (label visível) fora de serviço em vermelho;
--- player comum sem selo.
---@param playerInfo WallPlayerInfo
---@return string|nil
local function GetDutyLine(playerInfo)
    if not gStaffDutyEnabled then
        return nil
    end

    if playerInfo.staffOnDuty then
        return gOnDutyLine
    end

    if playerInfo.staff then
        return gOffDutyLine
    end
end

--- Preenche (sem alocar tabela nova) o que é desenhado na âncora da cabeça além do nome.
--- Gravação e selo são DrawTexts próprios (a linha do nome não tem espaço) com padding de `\n`
--- na MESMA projeção do nome: usam o espaçamento de linha do jogo e ficam colados embaixo dele
--- em qualquer distância.
---@param stack WallHeadStack
---@param topText string
---@param recordingText string  -- '' ou linhas começando com `\n`
---@param dutyLine string|nil   -- gOnDutyLine, gOffDutyLine ou nil
local function FillHeadStack(stack, topText, recordingText, dutyLine)

    local topLineBreaks = CountLineBreaks(topText)
    local recordingLines = CountLineBreaks(recordingText)
    local padding = ('\n'):rep(topLineBreaks)

    stack.lines = topLineBreaks + 1 + recordingLines
    stack.recording = recordingText ~= '' and PrepareDrawText(padding .. recordingText) or nil
    stack.duty = nil

    if dutyLine then
        stack.duty = PrepareDrawText(padding .. ('\n'):rep(recordingLines) .. dutyLine)
        stack.lines = stack.lines + 1
    end
end

--- Overlay 2D de fala (canto da tela). Sem font/cor customizados.
---@param text string
---@param x number
---@param y number
local function DrawTalkingText(text, x, y)

    SetTextScale(0.35, 0.35)
    SetTextEntry('STRING')
    AddTextComponentString(text)
    DrawText(x, y)
end

---@param text WallDrawText
---@param screenX number
---@param screenY number
---@param r number
---@param g number
---@param b number
local function DrawOverlayText(text, screenX, screenY, r, g, b)

    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextDropShadow(1, 0, 0, 0, 255)
    SetTextOutline()
    SetTextProportional(1)
    SetTextColour(r, g, b, 215)
    SetTextCentre(1)

    if type(text) == 'table' then
        SetTextEntry(gChunkedTextLabels[#text])

        for i = 1, #text do
            AddTextComponentString(text[i])
        end
    else
        SetTextEntry('STRING')
        AddTextComponentString(text)
    end

    DrawText(screenX, screenY)
end

--- Nametag, nome, gravação e selo numa única projeção da cabeça.
---@param x number
---@param y number
---@param z number
---@param topText WallDrawText
---@param nameTag wall.Nametag|nil
---@param stack WallHeadStack|nil
---@return number|nil screenY  -- nil quando a cabeça está fora da tela
local function DrawHeadOverlay(x, y, z, topText, nameTag, stack)

    local onScreen, screenX, screenY = GetScreenCoordFromWorldCoord(x, y, z)

    if not onScreen then
        return nil
    end

    if nameTag then
        DrawOverlayText(nameTag.label, screenX, screenY - 0.02, nameTag.color.r, nameTag.color.g, nameTag.color.b)
    end

    DrawOverlayText(topText, screenX, screenY, 255, 255, 255)

    if stack then
        if stack.recording then
            DrawOverlayText(stack.recording, screenX, screenY, 255, 255, 255)
        end

        if stack.duty then
            DrawOverlayText(stack.duty, screenX, screenY, 255, 255, 255)
        end
    end

    return screenY
end

--- bottomText (health/source/metric/wall/assento/AFK), âncora `z - 1.2 - Newz`. De longe a projeção
--- dos pés sobe até a cabeça; nunca deixa o bloco começar acima do fim do bloco da cabeça.
---@param x number
---@param y number
---@param z number
---@param text WallDrawText
---@param distance number
---@param headY number|nil
---@param headLines integer
local function DrawBottomOverlay(x, y, z, text, distance, headY, headLines)

    local newz = distance > 10 and (0.35 + distance / 100) or 0.22
    local onScreen, screenX, screenY = GetScreenCoordFromWorldCoord(x, y, z - 1.2 - newz)

    if not onScreen then
        return
    end

    if headY then
        screenY = math.max(screenY, headY + headLines * gLineHeight)
    end

    DrawOverlayText(text, screenX, screenY, 255, 255, 255)
end

--- Descobre veículo/assento do ped UMA vez (tira o loop de 8 `GetPedInVehicleSeat` do per-frame).
---@param ped number
---@return number vehicle  -- 0 quando não está em veículo (ou assento sem offset mapeado)
---@return number offsetX
---@return number offsetY
---@return number|false seat
local function ComputeVehicleSeatInfo(ped)

    local vehicle = GetVehiclePedIsIn(ped, false)

    if vehicle == 0 or not DoesEntityExist(vehicle) or not IsEntityAVehicle(vehicle) then
        return 0, 0.0, 0.0, false
    end

    local seat = -2

    for i = -1, 6 do
        if GetPedInVehicleSeat(vehicle, i) == ped then
            seat = i
            break
        end
    end

    local offsets = gVehicleOffsets[seat]

    if not offsets then
        return 0, 0.0, 0.0, false
    end

    return vehicle, offsets[1], offsets[2], seat
end

--- Posição de desenho no frame: usa offset do veículo (fresco) só se o ped ainda
--- estiver no MESMO veículo calculado no tick; senão cai pras coords do ped.
---@param ped number
---@param pedCoords vector3
---@param entry WallRenderEntry
---@return number x
---@return number y
---@return number z
local function ResolvePedPosition(ped, pedCoords, entry)

    if entry.vehicle ~= 0 and GetVehiclePedIsIn(ped, false) == entry.vehicle then
        local offset = GetOffsetFromEntityInWorldCoords(entry.vehicle, entry.offsetX, entry.offsetY, 0.0)
        return offset.x, offset.y, pedCoords.z + 1.0
    end

    return pedCoords.x, pedCoords.y, pedCoords.z + 1.0
end

--- Monta todos os textos/flags de um player "normal" (com info, sem forceRemoveWall).
--- Chamado uma vez por player por tick (500ms); nada aqui roda por frame.
---@param entry WallRenderEntry
---@param playerInfo WallPlayerInfo
---@param serverId number
---@param ped number
---@param recordingTagColor string  -- '~r~' ou '~w~'; alterna a cada tick (500ms)
local function FillPlayerEntry(entry, playerInfo, serverId, ped, recordingTagColor)

    local removeWall = playerInfo.removeWall

    local drawRainbowLine = false
    local nameColor = '~w~'

    if WallClient.FilterNewbie and type(playerInfo.tracking) == 'number' and playerInfo.tracking <= 10 then
        nameColor = gRgbTable[math.random(1, #gRgbTable)]
        drawRainbowLine = true
    end

    local playerName = ('%s%s~w~'):format(IsEntityVisible(ped) and nameColor or '~r~', playerInfo.identity.name)

    -- Health / Killer
    local health = GetEntityHealth(ped)
    local deadLabel = gDeadLabel
    -- Proxies de state bag reaproveitados entre ticks: Entity()/Player() alocam tabelas a cada chamada.
    if entry.statePed ~= ped or not entry.entityState then
        entry.statePed = ped
        entry.entityState = Entity(ped).state
    end

    local killer = entry.entityState and entry.entityState.Killer

    if killer then
        local killerId = tonumber(killer[2]) -- killerPassport
        local customKillerId = WallClient.GetPassportLabel(killerId)

        if customKillerId then
            killerId = customKillerId
        end

        if killerId then
            deadLabel = ('~r~[%s %s]~w~'):format(gDeadByLabel, tostring(killerId):gsub('~', ''))
        end
    end

    local healthText = health > 100 and ('~g~%d~w~'):format(health) or deadLabel
    local armorText = ('~b~%d~w~'):format(GetPedArmour(ped))

    local sideText = playerInfo.job and ('~y~%s~w~'):format(playerInfo.job) or ''
    local bannedText = playerInfo.banned and '\n~r~B~w~ ' or ''
    local bannedIpText = playerInfo.bannedIp and '\n~r~IP~w~' or ''
    local wallText = (playerInfo.wall and not removeWall) and '\n[~g~WALL~w~]' or ''
    local sourceText = WallClient.Settings.Source and ('\n SOURCE: [~g~%s~w~]'):format(serverId) or ''

    -- Proxy do state bag do player criado uma vez por entry (a entry é por serverId).
    entry.playerState = entry.playerState or Player(serverId).state
    local playerState = entry.playerState

    local afkText = ''
    local afkState = playerState['player-afk']

    if afkState and afkState[1] == true then
        local afkSince = afkState[2]
        local elapsedMs = type(afkSince) == 'number' and math.max(0, GetNetworkTimeAccurate() - afkSince) or nil
        local durationText = elapsedMs and ('[%s]'):format(FormatAfkDuration(elapsedMs)) or ''

        afkText = ('\n ~r~AFK~w~%s'):format(durationText)
    end

    -- WallStreet timer
    local wallStreetText = ''
    local wallStreetState = playerState.WallStreetTimer

    if wallStreetState and type(wallStreetState.WallStreetTimer) == 'number' then
        local wsAdmin = wallStreetState.admin

        if not wallStreetState.WallStreetDate then
            local remaining = wallStreetState.WallStreetTimer - GetNetworkTimeAccurate()

            if remaining and remaining > 0 then
                wallStreetText = ('~r~[%s]~w~ | ~g~(%s)~w~\n'):format(wsAdmin, FormatTimerWallStreet(remaining))
            else
                wallStreetText = ('~g~[%s]~w~  | ~w~(%s)~w~\n'):format(wsAdmin, FormatNegativeTimerWallStreet(remaining))
            end
        else
            wallStreetText = ('~g~[%s]~w~ | ~w~(%s)~w~\n'):format(wsAdmin, wallStreetState.WallStreetDate)
        end
    end

    -- Recording / proteção em serviço (cor alterna a cada tick de 500ms via recordingTagColor)
    local recordingText = ''

    if playerInfo.recording then
        recordingText = ('%s\n[%s%s~w~]'):format(recordingText, recordingTagColor, gRecordingLabel)
    end

    if playerInfo.bugXp then
        local label = playerInfo.projectCs and gProjectCsLabel or gBugXpLabel
        recordingText = ('%s\n[%s%s~w~]'):format(recordingText, recordingTagColor, label)
    end

    -- Metric
    local metricText = ''
    local inMetricsSystem = playerState.m

    if inMetricsSystem and inMetricsSystem > 0 then
        local value = math.floor(inMetricsSystem * 10)
        local metricColor = '~g~'
        local metricStatus = gMetricLowLabel

        if value >= 80 then
            metricColor = '~r~'
            metricStatus = gMetricHighLabel
        elseif value >= 30 then
            metricColor = '~y~'
            metricStatus = gMetricMediumLabel
        end

        metricText = ('\n[%s%s~w~]'):format(metricColor, metricStatus)
    end

    -- PlayerId label
    local customPlayerId = WallClient.GetPassportLabel(playerInfo.identity.id)
    local playerId = customPlayerId and ('~r~%s~w~'):format(customPlayerId) or ('~o~%s~w~'):format(playerInfo.identity.id)

    local nameTag = playerInfo.identity.nameTagIndex and NAMETAGS[playerInfo.identity.nameTagIndex]

    local passportText = WallClient.Settings.Passport and ('[%s] '):format(playerId) or ''
    local topTextBase = ('%s%s%s%s (%s) %s'):format(bannedText, bannedIpText, passportText, playerName, sideText, playerInfo.staffLabel)

    -- Vehicle / seat (loop de 8 GetPedInVehicleSeat roda aqui, não no per-frame)
    local vehicle, offsetX, offsetY, seat = ComputeVehicleSeatInfo(ped)
    local vehicleSeatText = WallClient.Settings.Vehicle and (seat and '\n~y~P' .. (seat + 2) .. '~w~' or '') or ''

    local healthSection = WallClient.Settings.Health and ('%s | %s'):format(healthText, armorText) or ''
    -- AFK por último: fica embaixo de tudo. Texto longo é fatiado em componentes, então não corta.
    local bottomText = ('%s%s%s%s%s%s%s'):format(wallStreetText, healthSection, sourceText, metricText, wallText, vehicleSeatText, afkText)

    local dutyLine = GetDutyLine(playerInfo)

    -- Head stack só é remontado quando nome, gravação ou selo mudam (a gravação troca de cor a cada tick).
    if entry.topTextBase ~= topTextBase or entry.recordingText ~= recordingText or entry.dutyLine ~= dutyLine then
        local topTextTalking = topTextBase .. gSpeakingSuffix

        entry.topTextBase = topTextBase
        entry.topDraw = PrepareDrawText(topTextBase)
        entry.topDrawTalking = PrepareDrawText(topTextTalking)
        entry.recordingText = recordingText
        entry.dutyLine = dutyLine
        entry.headStack = entry.headStack or {}
        entry.headStackTalking = entry.headStackTalking or {}

        FillHeadStack(entry.headStack, topTextBase, recordingText, dutyLine)
        FillHeadStack(entry.headStackTalking, topTextTalking, recordingText, dutyLine)
    end

    if entry.bottomSource ~= bottomText then
        entry.bottomSource = bottomText
        entry.bottomText = PrepareDrawText(bottomText)
    end

    entry.nameTag = nameTag
    entry.drawRainbowLine = drawRainbowLine
    entry.removeWall = removeWall
    entry.vehicle = vehicle
    entry.offsetX = offsetX
    entry.offsetY = offsetY
end

--- Remonta o array de freecams reaproveitando as entries por source (sem tabela nova por tick).
---@param freecamCache WallFreecamRenderEntry[]
---@param freecamEntries table<number, WallFreecamRenderEntry>
local function RebuildFreecamCache(freecamCache, freecamEntries)

    for _, fc in pairs(freecamEntries) do
        fc._stale = true
    end

    local count = 0
    local freecams = WallClient.Freecam.List()

    for i = 1, #freecams do
        local netfreecam = freecams[i]
        local playerInfo = WallClient.Players[netfreecam.source]

        if playerInfo and not playerInfo.removeWall then

            local fcCustomId = WallClient.GetPassportLabel(playerInfo.identity.id)
            local fcPlayerId = fcCustomId and ('~r~%s~w~'):format(fcCustomId) or ('~o~%s~w~'):format(playerInfo.identity.id)
            local fcNameTag = playerInfo.identity.nameTagIndex and NAMETAGS[playerInfo.identity.nameTagIndex]
            local fcPassport = WallClient.Settings.Passport and ('[%s] '):format(fcPlayerId) or ''

            local topText = ('%s%s (%s) %s'):format(fcPassport, playerInfo.identity.name, playerInfo.job, playerInfo.staff or '')
            local bottomText = ('SOURCE: [~g~%s~w~]'):format(netfreecam.source)

            if playerInfo.wall then
                bottomText = bottomText .. '\n[~g~WALL~w~]'
            end

            local fc = freecamEntries[netfreecam.source]

            if not fc then
                fc = { headStack = {} }
                freecamEntries[netfreecam.source] = fc
            end

            fc._stale = false
            fc.ref = netfreecam
            fc.topText = PrepareDrawText(topText)
            fc.bottomText = PrepareDrawText(bottomText)
            fc.nameTag = fcNameTag
            FillHeadStack(fc.headStack, topText, '', GetDutyLine(playerInfo))

            count = count + 1
            freecamCache[count] = fc
        end
    end

    for i = count + 1, #freecamCache do
        freecamCache[i] = nil
    end

    for source, fc in pairs(freecamEntries) do
        if fc._stale then
            freecamEntries[source] = nil
        end
    end
end

--- Cria as threads de data (500ms) e render (per-frame) presas à `gen`.
--- Caches são locais desta chamada: cada ativação começa do zero.
---@param gen number
function WallClient.StartRender(gen)

    ---@type table<number, WallRenderEntry>
    local cache = {}
    ---@type number[]
    local order = {}
    ---@type WallFreecamRenderEntry[]
    local freecamCache = {}
    ---@type table<number, WallFreecamRenderEntry>
    local freecamEntries = {}
    local recordingFlashOn = false

    -- DATA THREAD: monta os caches a cada 500ms (state bags, exports, strings).
    CreateThread(function()

        local myPlayerId = PlayerId()

        while WallClient.IsRunning(gen) do

            recordingFlashOn = not recordingFlashOn
            local recordingTagColor = recordingFlashOn and '~r~' or '~w~'

            for _, entry in pairs(cache) do
                entry._stale = true
            end

            local activePlayers = GetActivePlayers()
            local count = 0

            for i = 1, #activePlayers do
                local idx = activePlayers[i]

                if idx ~= myPlayerId then

                    local serverId = GetPlayerServerId(idx)
                    local ped = GetPlayerPed(idx)

                    if serverId and ped ~= 0 and DoesEntityExist(ped) then

                        local entry = cache[serverId]

                        if not entry then
                            entry = {}
                            cache[serverId] = entry
                        end

                        entry._stale = false
                        entry.idx = idx
                        entry.talkingLabel = entry.talkingLabel or ('* "%s" (%s)'):format(GetPlayerName(idx), serverId)

                        local playerInfo = WallClient.Players[serverId]

                        if not playerInfo then
                            entry.noInfo = true
                            entry.hidden = false
                            entry.topText = entry.topText or ('\n SOURCE: [~g~%s~w~]'):format(serverId)
                            entry.vehicle, entry.offsetX, entry.offsetY = ComputeVehicleSeatInfo(ped)
                        elseif playerInfo.forceRemoveWall then
                            entry.noInfo = false
                            entry.hidden = true
                        else
                            entry.noInfo = false
                            entry.hidden = false
                            FillPlayerEntry(entry, playerInfo, serverId, ped, recordingTagColor)
                        end

                        count = count + 1
                        order[count] = serverId
                    end
                end
            end

            for serverId, entry in pairs(cache) do
                if entry._stale then
                    cache[serverId] = nil
                end
            end

            for i = count + 1, #order do
                order[i] = nil
            end

            RebuildFreecamCache(freecamCache, freecamEntries)

            Wait(500)
        end
    end)

    -- RENDER THREAD: per-frame, só desenha (sem exports/state bags/concat pesado).
    CreateThread(function()

        while WallClient.IsRunning(gen) do

            local hasRendered = false

            local camCoords = GetFinalRenderedCamCoord()
            local camX, camY, camZ = camCoords.x, camCoords.y, camCoords.z

            local myCoords = GetEntityCoords(PlayerPedId())
            local myCx, myCy, myCz = myCoords.x, myCoords.y, myCoords.z

            local viewDistSq = WallClient.ViewDistance * WallClient.ViewDistance

            -- HSV só é calculado se algum desenho do frame precisar dele.
            local rainbowR, rainbowG, rainbowB

            DrawRect(0.5, 0.5, 0.0025, 0.005, 255, 0, 0, 150)
            DrawLine(0.5, 0.5, 0.0, 0.75, 0.5, 0.0, 255, 0, 0, 255)

            local numTalking = 0

            for i = 1, #order do

                -- order e cache são atualizados juntos no tick, sem yield no meio: a entry sempre existe.
                local entry = cache[order[i]]
                local ped = GetPlayerPed(entry.idx)

                if ped ~= 0 then

                    local isTalking = MumbleIsPlayerTalking(entry.idx)

                    if isTalking then
                        numTalking = numTalking + 1
                        DrawTalkingText(entry.talkingLabel, 0.9, 0.1 + numTalking * 0.05)
                    end

                    if not entry.hidden then

                        local pedCoords = GetEntityCoords(ped)

                        if entry.noInfo then

                            local x, y, z = ResolvePedPosition(ped, pedCoords, entry)

                            if not rainbowR then
                                local hue = (GetGameTimer() % 30000) / 15000.0
                                rainbowR, rainbowG, rainbowB = HSVToRGB(hue, 1, 1)
                            end

                            DrawHeadOverlay(x, y, z, entry.topText, nil, nil)
                            DrawLine(myCx, myCy, myCz, pedCoords.x, pedCoords.y, pedCoords.z, rainbowR, rainbowG, rainbowB, 255)
                            hasRendered = true
                        else

                            local dx = pedCoords.x - camX
                            local dy = pedCoords.y - camY
                            local dz = pedCoords.z - camZ
                            local distSq = dx * dx + dy * dy + dz * dz

                            if distSq <= viewDistSq and not (entry.removeWall and not IsEntityVisible(ped)) then

                                hasRendered = true

                                local distance = math.sqrt(distSq)

                                if entry.drawRainbowLine then

                                    if not rainbowR then
                                        local hue = (GetGameTimer() % 30000) / 15000.0
                                        rainbowR, rainbowG, rainbowB = HSVToRGB(hue, 1, 1)
                                    end

                                    DrawLine(myCx, myCy, myCz, pedCoords.x, pedCoords.y, pedCoords.z, rainbowR, rainbowG, rainbowB, 255)
                                end

                                local x, y, z = ResolvePedPosition(ped, pedCoords, entry)
                                local topText = isTalking and entry.topDrawTalking or entry.topDraw

                                local stack = isTalking and entry.headStackTalking or entry.headStack
                                local headY = DrawHeadOverlay(x, y, z, topText, entry.nameTag, stack)

                                DrawBottomOverlay(x, y, z, entry.bottomText, distance, headY, stack.lines)
                            end
                        end
                    end
                end
            end

            for i = 1, #freecamCache do

                local fc = freecamCache[i]
                local pos = fc.ref.pos
                local fdx = pos.x - camX
                local fdy = pos.y - camY
                local fdz = pos.z - camZ
                local fcDistSq = fdx * fdx + fdy * fdy + fdz * fdz

                if fcDistSq <= viewDistSq then

                    hasRendered = true

                    local distance = math.sqrt(fcDistSq)

                    local headY = DrawHeadOverlay(pos.x, pos.y, pos.z, fc.topText, fc.nameTag, fc.headStack)

                    DrawBottomOverlay(pos.x, pos.y, pos.z, fc.bottomText, distance, headY, fc.headStack.lines)
                end
            end

            Wait(hasRendered and 0 or 250)
        end
    end)
end
