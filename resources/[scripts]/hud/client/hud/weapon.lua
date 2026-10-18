-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local AmmoMax = -1
local AmmoMin = -1
local Active = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:WEAPON
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Weapon")
AddEventHandler("hud:Weapon",function(Status,Hash,CustomWeapon)
	if Status then
		Active = true
        local trueHash = Hash
        if CustomWeapon then
            Hash = GetHashKey(CustomWeapon)
        end
		while Active do
			local Ped = PlayerPedId()
			local _,Min = GetAmmoInClip(Ped,Hash)
			local Max = GetAmmoInPedWeapon(Ped,Hash)
			local MaxClip = GetMaxAmmoInClip(Ped, Hash, false)

			if AmmoMax ~= Max or AmmoMin ~= Min then
				AmmoMax = Max
				AmmoMin = Min

				if (Max - Min) <= 0 then
					Max = 0
				else
					Max = Max - Min
				end

				SendNUIMessage({ action = "Weapon", data = { Status = true, Min = Min, Max = Max, Name = trueHash, MaxClip = MaxClip }})
			end

			Wait(100)
		end
	else
		SendNUIMessage({ action = "Weapon", data = { Status = false }})
		Active = false
		AmmoMax = -1
		AmmoMin = -1
	end
end)