-- Ponte NUI do modal de punição por recrutamento sem qualidade (ENG-3352 / UIX-332).
-- RF-37 exige que o modal nunca abra sozinho no login, só por ação do jogador — o gatilho real é
-- o evento genérico `recruitment_punishment:openModal`, disparado hoje pelo `painel` (`Server.Hire`,
-- "clique no painel bloqueado"), pela tecla M dos cards Risco/Último aviso, e automaticamente pelo
-- `hud` quando o card Suspenso aparece (RF-41: esse não tem tecla, abre sozinho).
--
-- O servidor decide QUAL dos três modais mostrar (`net.recruitment_punishment.get_modal_data`, em
-- social_ranking) -- este arquivo só exibe o `stage` que vier: "risk" | "last_warning" | "blocked".

-- Evita reabrir por cima de si mesmo se o gatilho disparar duas vezes seguidas (ex.: o jogador
-- clica em recrutar de novo enquanto o modal anterior ainda está na tela).
local gModalOpen = false

---@return nil
local function OpenRecruitmentPunishmentModal()
    if gModalOpen then
        return
    end

    -- Falha aberta: se `social_ranking` estiver fora do ar ou o callback não responder, só não
    -- abre nada -- mesma postura do `painel` ao checar `IsRecruitmentSuspended`.
    local ok, data = pcall( function()
        return lib.callback.await( "net.recruitment_punishment.get_modal_data", false )
    end)

    if not ok or type( data ) ~= "table" or type( data.stage ) ~= "string" then
        return
    end

    gModalOpen = true

    -- NÃO usar `ui:exclusiveModalOpened` aqui: esse evento manda o próprio `client.lua` fechar o
    -- Hub (`setVisible=false`), o que esconderia esta tela antes do `recruitmentPunishment:open`
    -- abaixo chegar. Esse evento serve pra avisar OUTRO resource com modal próprio; aqui o modal já
    -- é do `new_hub` — a mensagem abaixo sozinha basta (`VisibilityProvider`, sempre montado, liga
    -- a visibilidade sozinho).
    SetNuiFocus( true, true )
    SendNUIMessage( {
        action = "recruitmentPunishment:open",
        data = { stage = data.stage, remaining = data.remaining },
    } )
end

RegisterNetEvent( "recruitment_punishment:openModal", OpenRecruitmentPunishmentModal )

-- O front só confirma que exibiu o card (RF-33/RF-40); o botão não devolve a permissão sozinho --
-- se o card confirmado era o de Bloqueada, é o SERVIDOR quem decide iniciar o relógio a partir daí.
RegisterNUICallback( "recruitmentPunishment:acknowledge", function( _data, callback )
    TriggerServerEvent( "recruitment_punishment:acknowledge" )
    SetNuiFocus( false, false )
    gModalOpen = false
    callback( { ok = true } )
end )

-- Sem argumento: usa o fluxo REAL (precisa de estado de verdade no banco pra abrir). Com
-- `risk`/`last_warning`/`blocked`: abre o modal na hora com dados fake, pra testar o front sem
-- precisar montar suspensão real -- mesmo par de botões que já existe no debug menu do hub.
local MOCK_STAGES = {
    risk = { stage = "risk" },
    last_warning = { stage = "last_warning" },
    blocked = { stage = "blocked", remaining = "2 dias e 3 horas" },
}

RegisterCommand( "testrecruitmentpunishment", function( _source, args )
    local mock = MOCK_STAGES[ args[1] ]

    if mock then
        gModalOpen = false
        SetNuiFocus( true, true )
        SendNUIMessage( { action = "recruitmentPunishment:open", data = mock } )
        return
    end

    OpenRecruitmentPunishmentModal()
end, false )
