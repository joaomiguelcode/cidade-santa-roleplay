local FREEZE_PLAYER_MINIGAME_PRESETS = {
    fishing = true,
    milking = true,
    milking_no_task = true,
}

---@param minigame Minigame
---@return string?
function GetFreezePlayerMinigamePreset(minigame)
    local minigamePreset = minigame.def.minigamePreset or minigame.def.name

    if type(minigamePreset) ~= 'string' then
        return nil
    end

    local staffgangTemplatePrefix = 'staffgang_template_'

    if minigamePreset:sub(1, #staffgangTemplatePrefix) == staffgangTemplatePrefix then
        return minigamePreset:sub(#staffgangTemplatePrefix + 1)
    end

    return minigamePreset
end

---@param minigame Minigame
---@return boolean
function ShouldFreezePlayerDuringMinigame(minigame)
    return FREEZE_PLAYER_MINIGAME_PRESETS[GetFreezePlayerMinigamePreset(minigame)] == true
end

---@param minigame Minigame
---@param enabled boolean
function SetFreezePlayerDuringMinigame(minigame, enabled)
    if ShouldFreezePlayerDuringMinigame(minigame) then
        FreezeEntityPosition(PlayerPedId(), enabled)
    end
end

---@param minigame Minigame
function OnMinigameCreated( minigame )

    -- print('OnMinigameCreated=', OnMinigameCreated, minigame, minigame.point, minigame.point.def.x, minigame.point.y)
    TriggerEvent( 'Notify:Text', _t( 'cancelCollection', minigame.def.displayName:upper() ) )

    -- #DEBUG
    -- SetNewWaypoint( minigame.point.def.x, minigame.point.def.y )
    -- #DEBUG end

    CreateThread(function()

        while minigame.isValid do

            OnUpdateMinigame( minigame )

            Wait( 0 )
        end
    end)
end
