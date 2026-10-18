--- ENG-3273/ENG-3288 - Modal de punicao da WallStreet.
---
--- A tela e o `ActivityPunishmentOverlay` do proprio app do dashboard (sxarch),
--- ja presente no bundle de `web/`. Contrato NUI:
---   -> `recruitmentShowActivityPunishment`  abre o modal
---   <- `recruitmentAckActivityPunishment`   clique em "Entendi" (inicia a contagem)
---
--- Fecha SOMENTE pelo "Entendi": o overlay nao tem ESC, clique fora nem X; aqui o
--- foco NUI fica preso e os controles desabilitados enquanto ele estiver aberto.

local gWallStreetModalOpen = false
local gPunishmentReason = nil
local gPunishmentQueue = {}

---@param reason string  -- 'lowActivity', 'lowRetention' ou 'comercialLowActivity'
RegisterNetEvent( 'dashboard:ShowWallStreetPunishment', function( reason, expiresDate )

    if gWallStreetModalOpen then
        gPunishmentQueue[ #gPunishmentQueue + 1 ] = { reason = reason, expiresDate = expiresDate }
        return
    end

    gWallStreetModalOpen = true
    gPunishmentReason = reason

    SendNUIMessage( {
        action = 'recruitmentShowActivityPunishment',
        data = { reason = reason, expiresDate = expiresDate },
    } )

    SetNuiFocus( true, true )

    CreateThread( function()
        while gWallStreetModalOpen do
            DisableAllControlActions( 0 )
            DisableAllControlActions( 1 )
            DisableAllControlActions( 2 )
            Wait( 0 )
        end
    end )
end )

RegisterNUICallback( 'recruitmentAckActivityPunishment', function( _, cb )

    gWallStreetModalOpen = false

    SetNuiFocus( false, false )

    -- Cada blacklist conta os proprios 7 dias a partir do proprio aceite, entao o
    -- motivo decide para quem vai o "Entendi" (ENG-3292).
    local tickets = gPunishmentReason == 'ticketsLowActivity' or gPunishmentReason == 'ticketsLowQuality'
    TriggerServerEvent( tickets and 'dashboard:AckTicketPunishment'
        or ( gPunishmentReason == 'comercialLowActivity'
            and 'dashboard:AckComercialPunishment' or 'dashboard:AckWallStreetPunishment' ) )

    gPunishmentReason = nil

    cb( { ok = true } )

    local queued = table.remove( gPunishmentQueue, 1 )

    if queued then
        -- O ACK da NUI atual precisa terminar antes de abrir o proximo overlay.
        SetTimeout( 100, function()
            TriggerEvent( 'dashboard:ShowWallStreetPunishment', queued.reason, queued.expiresDate )
        end )
    end
end )
