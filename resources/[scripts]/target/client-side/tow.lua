---@type nil|number
attachedTow = nil

---@type table<string, boolean>
allowedTowModels = {
    ["dlbisontownb"] = true,
	["dlbisontow"] = true
}

---@type number
local cooldown = GetGameTimer()

---@type table<string, table<integer, vector3>>
local mechanics = {
	["Santa"] = {
		vec3(-1114.89, -2070.56, 13.26),
	},
	["Grande"] = {
		vec3(563.91, -162.19, 54.52),
	},
	["Fronteira"] = {
		vec3(-1072.9, -2065.83, 13.29),
	},
	["CidadeNobre"] = {
		vec3(-1136.26, -2103.59, 13.26),
	},
	["Boomerang"] = {
		vec3(-1106.44, -2055.27, 13.26),
	},
	["Malta"] = {
		vec3(541.79, -167.59, 54.56),
	},
	["Kingdom"] = {
		vec3(541.79, -167.59, 54.56),
	},
	["Imperium"] = {
		vec3(-1072.9, -2065.83, 13.29),
	},
	["GoatRP"] = {
		vec3(-1072.9, -2065.83, 13.29),
	},
	["District99"] = {
		vec3(-1090.07, -2058.12, 13.29),
	},
	["Krown"] = {
		vec3(-1090.07, -2058.12, 13.29),
	},
	["Liberty99"] = {
		vec3(548.06, -149.76, 54.53),
	},
	["Orizon"] = {
		vec3(-1072.9, -2065.83, 13.29),
	},
	["Royal"] = {
		vec3(-1109.78, -2068.91, 13.26),
	},
	["Real"] = {
		vec3(-1104.64, -2052.81, 13.29),
	},
	["Prime"] = {
		vec3(-1104.61, -2052.98, 13.29),
	},
	["Universo"] = {
		vec3(-1082.09, -2076.26, 13.29),
	},
	["Alexandria"] = {
		vec3(-1072.9, -2065.83, 13.29),
	},
	["Maresia"] = {
		vec3(-1113.18, -2062.31, 13.26),
	},
}

local coordsMechanics = mechanics[cityName] or {}

---@type number
local towReleaseRange = 200

---@type table<integer, vector3>
local blockCoords = {
	vec3(178.54, -982.15, 29.64),
}

---@param targetVehicle number
AddEventHandler("target:client:tow",function(targetVehicle)
    if GetGameTimer() < cooldown then
        TriggerEvent("Notify2", "#cooldownRequests", { msg = math.floor((cooldown - GetGameTimer()) / 1000) })
        return
    end

    local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	for i = 1, #blockCoords do
		local distance = #(coords - blockCoords[i])
		if distance <= 100 then
			TriggerEvent("Notify2", "#tow_blocked_area")
			return
		end
	end

	local vehicle = GetLastDrivenVehicle()
    local archetypeName = GetEntityArchetypeName(vehicle)

	if allowedTowModels[archetypeName] and not IsPedInAnyVehicle(playerPed) then
		-- local targetVehicle = vRP.ClosestVehicle(10)

		if IsEntityAVehicle(vehicle) and IsEntityAVehicle(targetVehicle) then
			if #(GetEntityCoords(vehicle) - GetEntityCoords(targetVehicle)) <= 15 then
				if attachedTow then
					if DoesEntityExist(vehicle) and DoesEntityExist(attachedTow) then
                        local nearbyMechanics = false
                        for i = 1, #coordsMechanics do
                            local distance = #(coords - coordsMechanics[i])
                            if distance <= towReleaseRange then
                                nearbyMechanics = true
                                break
                            end
                        end

                        if not nearbyMechanics then
                            TriggerEvent("Notify2", "#tow_nearby_office")
                            return
                        end

						TriggerServerEvent("target:server:tow", VehToNet(vehicle), VehToNet(attachedTow), "out")
					end

					attachedTow = nil
				else
					local towAttachment = Entity(targetVehicle).state.towAttachment
					if towAttachment then
						if not attachedTow then
							TriggerServerEvent("target:server:tow", VehToNet(vehicle), VehToNet(targetVehicle), "out")
						end

						return
					end

					if vehicle ~= targetVehicle then
                        cooldown = GetGameTimer() + 10000

                        LocalPlayer.state.Cancel = true
						LocalPlayer.state.Commands = true
						TaskTurnPedToFaceEntity(playerPed, targetVehicle, 5000)
						TriggerEvent("sounds:Private", "tow", 0.5)
						vRP.playAnim(false, { "mini@repair", "fixing_a_player" }, true)
						TriggerEvent("Progress", "Rebocando", 10000)

						Wait(10000)

						TriggerEvent("vrp:removeObjects")
						attachedTow = targetVehicle
						LocalPlayer.state.Cancel = false
						LocalPlayer.state.Commands = false
						TriggerServerEvent("target:server:tow", VehToNet(vehicle), VehToNet(targetVehicle), "in")
					end
				end
			else
				TriggerEvent("Notify2", "#tow_nearby")
			end
		end
	end
end)

--- Handle tow attachment state changes
---@param bagName string
---@param key string
---@param value table<string, any>
AddStateBagChangeHandler("towAttachment", nil, function(bagName, key, value)
	if value then
		local entityId = bagName:gsub("entity:", "")
		local targetNetId = tonumber(entityId)
		if targetNetId and NetworkDoesNetworkIdExist(targetNetId) then
			local targetVehicle = NetToEnt(targetNetId)
			local towVehicle = NetToEnt(value.towVehicle)
			
			if DoesEntityExist(targetVehicle) and DoesEntityExist(towVehicle) then
				if value.mode == "in" then
					local min = GetModelDimensions(GetEntityModel(targetVehicle))

					assert( targetVehicle ~= towVehicle, ("SXSEC-7 Invalid target vehicle and tow vehicle: %s and %s, no cyclic attachments"):format(targetVehicle, towVehicle) )

					AttachEntityToEntity(targetVehicle, towVehicle, GetEntityBoneIndexByName(towVehicle, "bodyshell"), 0, -3.2, 0.3 - min.z, 5.0, 0, 0, true, true, false, true, 2, true)
				elseif value.mode == "out" then
					DetachEntity(targetVehicle, false, false)
					
					local heading = GetEntityHeading(towVehicle)
					local coords = GetOffsetFromEntityInWorldCoords(towVehicle, 0.0, -10.0, 0.0)
					SetEntityCoords(targetVehicle, coords.x, coords.y, coords.z, false, false, false, false)
					SetEntityHeading(targetVehicle, heading)
					SetVehicleOnGroundProperly(targetVehicle)

					Wait(100)
					Entity(targetVehicle).state:set("towAttachment", nil, true)
				end
			end
		end
	end
end)
