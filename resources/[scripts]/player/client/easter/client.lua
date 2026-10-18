-- AlreadyObtained = {}
-- local Grabbing = false
-- local spawnedObjects = {}
-- local function SpawnObject(easterEgg, index)
--     if spawnedObjects[easterEgg] then
--         return
--     end
--     local selectedModel = math.random(1,#HuntEvents[GlobalState["HuntEventsSelected"]].Models)
--     local modelHash = GetHashKey(HuntEvents[GlobalState["HuntEventsSelected"]].Models[selectedModel])
--     RequestModel(modelHash)
--     while not HasModelLoaded(modelHash) do
--         Wait(1)
--     end

--     local obj = CreateObject(modelHash, easterEgg.x, easterEgg.y, easterEgg.z - 1.0, false, false, false)
--     SetEntityAsMissionEntity(obj, true, true)
    
--     interact.addLocalEntity({
--         id = "eventsObject"..index,
--         entity = obj,
--         options = {
--             {
--                 label = _t("get_easter_egg"),
--                 icon = "hand",
--                 onSelect = function(data)
--                     Grabbing = true
--                     local ped = PlayerPedId()
--                     local animDict = 'amb@prop_human_bum_bin@idle_a'
--                     RequestAnimDict(animDict)
--                     while not HasAnimDictLoaded(animDict) do
--                         Wait(10)
--                     end
--                     TaskPlayAnim(ped, animDict, 'idle_a', 8.0, -8.0, -1, 47, 0, false, false, false)
--                     TriggerEvent("Progress","Easter",3000)
                    
--                     SetTimeout(3000, function()
--                         local particleDictionary = "scr_xs_celebration"
--                         local particleName = "scr_xs_confetti_burst"
                        
--                         RequestNamedPtfxAsset(particleDictionary)
--                         while not HasNamedPtfxAssetLoaded(particleDictionary) do
--                             Wait(10)
--                         end
                        
--                         local coordsEffect = GetEntityCoords(spawnedObjects[easterEgg])
--                         SetPtfxAssetNextCall(particleDictionary)
--                         local effect = StartParticleFxLoopedAtCoord(particleName, coordsEffect.x, coordsEffect.y, coordsEffect.z + 0.5, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
--                         Wait(250)
--                         StopParticleFxLooped(effect, 0)
                        
--                         ClearPedTasks(ped)
--                         vSERVER.GetHuntProp(index)
--                         DespawnHuntObject(easterEgg)
--                         Grabbing = false
--                     end)
--                 end,
--                 canInteract = function(entity, distance, coords, id)
--                     return not Grabbing
--                 end
--             }
--         },
--         renderDistance = 10.0,
--         activeDistance = 2.0,
--         cooldown = 8000
--     })

--     spawnedObjects[easterEgg] = obj
-- end
-- function DespawnHuntObject(easterEgg)
--     if not spawnedObjects[easterEgg] then return end
    
--     local obj = spawnedObjects[easterEgg]
--     DeleteEntity(obj)
--     spawnedObjects[easterEgg] = nil
-- end

-- CreateThread(function()
--     while true do
--         if GlobalState["HuntEvents"] then

--             local playerPed = PlayerPedId()
--             local playerCoords = GetEntityCoords(playerPed)
            
--             for index, easterEgg in ipairs(HuntEvents[GlobalState["HuntEventsSelected"]].Coords) do
--                 local isObtained = false
--                 for _, obtainedIndex in ipairs(AlreadyObtained) do
--                     if obtainedIndex == index then
--                         isObtained = true
--                         break
--                     end
--                 end

--                 if not isObtained then
--                     local distance = #(playerCoords - easterEgg)
                    
--                     if distance <= 100.0 then
--                         SpawnObject(easterEgg, index)
--                     else
--                         DespawnHuntObject(easterEgg, index)
--                     end
--                 else
--                     DespawnHuntObject(easterEgg)
--                 end
--             end
--         end
--         Wait(1000)
--     end
-- end)

-- AddStateBagChangeHandler("HuntEvents",nil,function(Name,Key,Value)
--     if not Value then
--         for _, easterEgg in pairs(HuntEvents[GlobalState["HuntEventsSelected"]].Coords) do
--             DespawnHuntObject(easterEgg)
--         end
--     end
-- end)

-- AddEventHandler('onResourceStop', function(resourceName)
--     if (GetCurrentResourceName() ~= resourceName) then return end
    
--     for _, easterEgg in pairs(HuntEvents[GlobalState["HuntEventsSelected"]].Coords) do
--         DespawnHuntObject(easterEgg)
--     end
-- end)

-- RegisterNetEvent("player:HuntEventsUpdate",function(HuntEvents)
--     AlreadyObtained = HuntEvents
-- end)

-- RegisterNetEvent("player:HuntEventsUpdateIndex",function(index)
--     table.insert(AlreadyObtained, index)
-- end)
