local shots        = 0
local nextCallTime = GetGameTimer() + 1000

---@param witnesses {}
---@param shooter number
onShotFired = function(witnesses, shooter)
    local ped = PlayerPedId()

    if LocalPlayer["state"]["minigame:active"] then
        return
    end

    if (shooter ~= ped) then
        return
    end

    if (hasReceiverGroup()) then
        return
    end

    if (hasBlacklistedGroup()) then
        return
    end

	if (GetGameTimer() < nextCallTime) then
		return
	end

    shots = shots + 1

    if (shots < config.shotThreshold) then
        return
    end

    shots = 0

    local position  = getClosestCoord()
    local grid      = getGridzone(position.x, position.y)
    local calltypes = config.callTypes[language] or config.callTypes['DEFAULT']
	nextCallTime    = (GetGameTimer() + calltypes[1].cooldown)

    TriggerServerEvent('dispatch:send', position, enum.reportType.gunShots, grid)
end

RegisterNetEvent('CEventGunShot', onShotFired)
