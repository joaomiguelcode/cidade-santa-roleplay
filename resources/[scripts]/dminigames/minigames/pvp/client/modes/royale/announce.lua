---@class RoyaleAnnouncementPayload: PvpEventAnnouncementPayload
---@field canEnter boolean

local function EnterFromAnnouncement()

    TriggerServerEvent( 'pvp.royale:enterFromAnnounce' )
end

RegisterNetEvent( 'pvp.royale:announce', function( payload )

    if type( payload ) ~= 'table' then
        return
    end

    local hudPayload = {}

    for key, value in pairs( payload ) do
        hudPayload[ key ] = value
    end

    hudPayload.canEnter = nil
    local onAccept = payload.canEnter == true and EnterFromAnnouncement or nil

    if not onAccept then
        hudPayload.keyPrompt = ''
        hudPayload.keyLabel = ''
    end

    PvpEventAnnounce.Show( 'royale', hudPayload, onAccept )
end )

RegisterNetEvent( 'pvp.royale:closeAnnounce', function()

    PvpEventAnnounce.Close( 'royale' )
end )

RegisterCommand( 'royale.enter', function()

    PvpEventAnnounce.Accept( 'royale' )
end, false )

RegisterKeyMapping( 'royale.enter', PvpTranslations.get( 'royale_keymap' ), 'keyboard', 'F3' )
