local dict = "rcmextreme2atv"
local anims = {
	"idle_b",
	"idle_c",
	"idle_d",
	"idle_e"
}

local WhitelistBikes = {
    [`Bike`] = true,
    [`brrampbike001`] = true,
    [`lowriderb`] = true,
    [`monowheel`] = true,
    [`surron`] = true,
    [`bmx`] = true,
}

RegisterCommand('tricks', function(source, args, rawCommand)
    local index = tonumber(args[1])
    if not index then
        return
    end
    if index < 1 or index > #anims then
        return
    end

    local ped = PlayerPedId()
    local bike = GetVehiclePedIsIn(ped)
    local speed = GetEntitySpeed(bike)*3.6
    local model = GetEntityModel(bike)
    if IsPedOnAnyBike(ped) and WhitelistBikes[model] then
        while not HasAnimDictLoaded(dict) do 
            Wait(0)
            RequestAnimDict(dict)
        end
        if index == 1 then
            TaskPlayAnim(ped,dict,anims[1], 8.0, -8.0, -1, 32, 0, false, false, false)
        elseif index == 2 then
            TaskPlayAnim(ped,dict,anims[2], 8.0, -8.0, -1, 32, 0, false, false, false)
        elseif index == 3 then
            TaskPlayAnim(ped,dict,anims[3], 8.0, -8.0, -1, 32, 0, false, false, false)
        elseif index == 4 then
            TaskPlayAnim(ped,dict,anims[4], 8.0, -8.0, -1, 32, 0, false, false, false)
        end
    end
end)
RegisterKeyMapping('tricks 1', 'Tricks 1', 'keyboard', 'NUMPAD4')
RegisterKeyMapping('tricks 2', 'Tricks 2 ', 'keyboard', 'NUMPAD6')
RegisterKeyMapping('tricks 3', 'Tricks 3', 'keyboard', 'NUMPAD5')
RegisterKeyMapping('tricks 4', 'Tricks 4', 'keyboard', 'NUMPAD8')