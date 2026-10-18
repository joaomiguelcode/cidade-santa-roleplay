local RANKING_ACTION_COMMAND = "+hud_organization_ranking_hub"

---@return FeedbackSound
local function GetOrganizationRankingSound()
    local language = GetConvar( "language", "pt-br" ):sub( 1, 2 ):lower()
    return ORG_RANKING_CONFIG.soundsByLanguage[ language ] or ORG_RANKING_CONFIG.sound
end

---@class OrganizationRankingDisplay
---@field displayId integer
---@field visible boolean
---@field expiresAt integer
local OrganizationRanking = {}
OrganizationRanking.__index = OrganizationRanking

---@class FeedbackOrganizationClientApi
FeedbackOrganizationClient = {}

---@return OrganizationRankingDisplay display
function OrganizationRanking.New()
    return setmetatable( {
        displayId = 0,
        visible = false,
        expiresAt = 0,
    }, OrganizationRanking )
end

---@return nil
function OrganizationRanking:Close()
    self.displayId = self.displayId + 1
    self.visible = false
    self.expiresAt = 0
    TriggerEvent( "hud:orgRanking:visibilityChanged", false )
    SendNUIMessage( { action = "orgRanking:close" } )
end

---@param entries OrgRankingEntry[]
---@return nil
function OrganizationRanking:Open( entries )
    -- Nao interromper quem esta num minigame (ex.: cargame); o banner reaparece
    -- normalmente no proximo ciclo depois que o jogador sair.
    if LocalPlayer.state["minigame:active"] then
        return
    end

    self.displayId = self.displayId + 1
    self.visible = true

    local displayId = self.displayId
    local duration = FeedbackTime.ToMilliseconds(
        ORG_RANKING_CONFIG.displayDuration
    )
    self.expiresAt = GetGameTimer() + duration

    TriggerEvent( "hud:orgRanking:visibilityChanged", true )
    SendNUIMessage( {
        action = "orgRanking:open",
        data = {
            entries = entries,
            duration = duration / 1000,
            translations = {
                title = _t( "hud.feedback.org_ranking.title" ),
                subtitle = _t( "hud.feedback.org_ranking.subtitle" ),
                city = _t( "hud.feedback.org_ranking.city" ),
                hint = _t( "hud.feedback.org_ranking.hint" ),
                numberLocale = _t( "hud.feedback.org_ranking.number_locale" ),
            },
        },
    } )
    local sound = GetOrganizationRankingSound()
    TriggerEvent( "sounds:Private", sound.url, sound.volume )

    CreateThread( function()
        Wait( duration )

        if displayId == self.displayId then
            self:Close()
        end
    end )
end

---@return nil
function OrganizationRanking:OpenHub()
    if not self.visible then
        return
    end

    if GetGameTimer() >= self.expiresAt then
        self:Close()
        return
    end

    TriggerEvent( "hub:OpenRanking", { category = "organization" } )
end

local ranking = OrganizationRanking.New()

---@return boolean isInDefaultWorld
local function IsInDefaultWorld()
    return tonumber( LocalPlayer.state.Route ) == FEEDBACK_CONFIG.defaultWorldBucket
end

---@return nil
function FeedbackOrganizationClient.Register()
    RegisterNetEvent( "hud:orgRanking:open", function( entries )
        if type( entries ) ~= "table" then
            -- sx.logger:warn( "hud org ranking ignored invalid entries" )
            return
        end

        if not IsInDefaultWorld() then
            return
        end

        ranking:Open( entries )
    end )

    RegisterCommand( RANKING_ACTION_COMMAND, function()
        -- ENG-3779: com o card do convite X1 (dashboard) na tela, o U é dele.
        local ok, owned = pcall( function() return exports.dashboard:X1InviteOwnsKey( "u" ) end )

        if ok and owned then
            return
        end

        ranking:OpenHub()
    end, false )

    RegisterKeyMapping( RANKING_ACTION_COMMAND, _t( "hud.keymap.org_ranking" ), "keyboard", "U" )

    -- Fecha o banner se o jogador entrar num minigame (ex.: cargame) enquanto ele esta na tela.
    AddStateBagChangeHandler( "minigame:active", nil, function( bagName, _, value )
        if bagName ~= ( "player:%s" ):format( GetPlayerServerId( PlayerId() ) ) then
            return
        end
        if not value then
            return
        end
        ranking:Close()
    end )

    AddEventHandler( "onResourceStop", function( resourceName )
        if resourceName == GetCurrentResourceName() then
            ranking:Close()
        end
    end )
end
