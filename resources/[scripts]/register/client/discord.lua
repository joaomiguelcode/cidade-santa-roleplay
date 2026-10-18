local gDiscordCode = nil
gDiscordAccountLinkUrl = gDiscordAccountLinkUrl or nil

discordNotValidated = false

---@param value any
---@return boolean
local function IsNonEmptyString( value )

    return type( value ) == "string" and value ~= ""
end

---@return string? discordLink
local function GetLegacyDiscordLink()

    if type( DiscordConv ) ~= "table" then
        return nil
    end

    local discordLink = DiscordConv[cityName]

    if not IsNonEmptyString( discordLink ) then
        return nil
    end

    return discordLink
end

---@param code any
---@param invite string?
---@return boolean opened
local function OpenLegacyDiscordModal( code, invite )

    if IsNonEmptyString( code ) then
        gDiscordCode = code
    end

    if not IsNonEmptyString( gDiscordCode ) then
        sx.logger:warn( ("Legacy Discord modal could not be opened cityName=%s reason=missing_code"):format(
            tostring( cityName )
        ) )
        return false
    end

    local discordLink = invite or GetLegacyDiscordLink()

    if not discordLink then
        sx.logger:warn( ("Legacy Discord modal has no invite link cityName=%s"):format(
            tostring( cityName )
        ) )
    end

    -- O hook useNuiEvent do bundle entrega `event.data.data` ao handler.
    SendNUIMessage({
        action = "openDiscord",
        data = {
            discordCode = gDiscordCode,
            discordLink = discordLink,
        },
    })
    SetNuiFocus(true, true)

    return true
end

RegisterNetEvent("register:openDiscordValidation", function( code, invite )

    OpenLegacyDiscordModal( code, invite )
end)

RegisterNetEvent("register:opendiscord", function( code )

    if IsNonEmptyString( code ) then
        gDiscordCode = code
    end

    local response = vSERVER.startDiscordLinking( gDiscordCode, true )

    if response and IsNonEmptyString( response.discordCode ) then
        gDiscordCode = response.discordCode
    end

    if response and response.modal == "bot" then
        vSERVER.requestDiscordRegistration()
        return
    end

    if response and response.modal == "legacy" then
        OpenLegacyDiscordModal( gDiscordCode )
        return
    end

    -- Sem admin/OAuth disponível, o fluxo legado continua utilizável: abre o
    -- modal com o token para o player encaminhá-lo ao bot no Discord.
    if response and response.success
        and response.legacyTokenVerificationEnabled
        and not IsNonEmptyString( response.discordLink ) then
        TriggerEvent("register:openNewDiscordValidation", nil, gDiscordCode, true)
        return
    end

    if not response or not response.success then
        if IsNonEmptyString( gDiscordCode ) then
            TriggerEvent(
                "register:openNewDiscordValidation",
                nil,
                gDiscordCode,
                response and response.legacyTokenVerificationEnabled
            )
        end

        sx.logger:warn( ("Discord OAuth session could not be started error=%s"):format(
            tostring( response and response.error or "unknown" )
        ) )
    end
end)

RegisterNetEvent("register:updateDiscordStatus", function( status, code )

    discordNotValidated = status and true or false

    if IsNonEmptyString( code ) then
        gDiscordCode = code
    end
end)

local gDiscordInviteModalOpen = false

local function GetInviteModalOptions( preserveStep )
    return {
        termsInline = true,
        termsLink = TosLink[ cityName ],
        preserveStep = preserveStep == true,
    }
end

RegisterNetEvent("register:opendiscord_invite", function( code )

    gDiscordInviteModalOpen = true

    if IsNonEmptyString( code ) then
        gDiscordCode = code
    end

    local response = vSERVER.startDiscordLinking( gDiscordCode, true )

    if response and IsNonEmptyString( response.discordCode ) then
        gDiscordCode = response.discordCode
    end

    -- Bot de convite por conta (Krown): o link chega depois, em register:updateDiscordInviteLink.
    local botInvite = response and response.modal == "bot"

    DoScreenFadeIn( 1000 )

    TriggerEvent( "register:openNewDiscordValidation", not botInvite and GetLegacyDiscordLink() or nil,
        gDiscordCode, not botInvite, GetInviteModalOptions( false ) )

    if botInvite then
        vSERVER.requestDiscordRegistration()
    end
end)

RegisterNetEvent("register:updateDiscordInviteLink", function( invite )

    if not gDiscordInviteModalOpen then
        return
    end

    TriggerEvent( "register:openNewDiscordValidation", invite, gDiscordCode, false, GetInviteModalOptions( true ) )
end)

RegisterNUICallback("linkDiscord", function( data, cb )

    local code = data and data.code or gDiscordCode

    if not IsNonEmptyString( code ) then
        cb({ success = false, error = "invalid_code" })
        return
    end

    local previousLink = gDiscordAccountLinkUrl
    local response = vSERVER.startDiscordLinking( code, false )

    if gDiscordInviteModalOpen then
        if not response or not response.success then
            sx.logger:warn( ("Discord invite link refused error=%s"):format(
                tostring( response and response.error or "no_response" )
            ) )
        end
        cb( response or { success = false, error = "session_unavailable" } )
        return
    end

    if response and response.modal == "legacy" then
        OpenLegacyDiscordModal( response.discordCode or code )
        cb( response )
        return
    end

    if not response or not response.success then
        SendNUIMessage({
            action = "openNewDiscord",
            data = {
                discordCode = code,
                discordLink = gDiscordAccountLinkUrl,
                legacyTokenVerificationEnabled = response and response.legacyTokenVerificationEnabled and true or false,
            },
        })
        cb( response or { success = false, error = "session_unavailable" } )
        return
    end

    if IsNonEmptyString( response.discordLink ) then
        gDiscordAccountLinkUrl = response.discordLink

        -- Se a sessao expirou, atualiza o link mantido pelo React antes dos
        -- proximos retries. O guard de producao deixa a abertura do botao
        -- principal para este callback, sempre com a URL validada no server.
        if not IsNonEmptyString( previousLink ) or previousLink ~= gDiscordAccountLinkUrl then
            SendNUIMessage({
                action = "openNewDiscord",
                data = {
                    discordCode = code,
                    discordLink = gDiscordAccountLinkUrl,
                    legacyTokenVerificationEnabled = response.legacyTokenVerificationEnabled and true or false,
                },
            })
        end

        TriggerEvent("player:OpenURL", gDiscordAccountLinkUrl)
    end

    cb( response )
end)

RegisterNUICallback("enterCity", function( _, cb )

    local success = vSERVER.enterCity()

    if success then
        TriggerEvent("register:closeDiscordAccountLinkingModal")
    end

    cb({ success = success and true or false })
end)

-- Compatibilidade com o modal anterior durante o rollout do novo bundle.
RegisterNUICallback("validateDiscord", function( data, cb )

    cb( vSERVER.validateDiscord( data and data.code ) )
end)

RegisterNUICallback("openDiscordLink", function( data, cb )

    local discordLink = data and data.link

    if IsNonEmptyString( discordLink ) and discordLink:match( "^https://" ) then
        TriggerEvent("player:OpenURL", discordLink)
    else
        sx.logger:warn( ("Legacy Discord modal rejected invite link cityName=%s link=%s"):format(
            tostring( cityName ),
            tostring( discordLink )
        ) )
    end

    cb("ok")
end)
