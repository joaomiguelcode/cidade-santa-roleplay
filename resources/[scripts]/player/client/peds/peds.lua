-----------------------------------------------------------------------------------------------------------------------------------------
-- THREAD
-----------------------------------------------------------------------------------------------------------------------------------------
local localPeds = {}
CreateThread(function()
	while true do
		local Ped = PlayerPedId()
		local Coords = GetEntityCoords(Ped)

		for Number,v in pairs(PedList) do
			local Distance = #(Coords - vec3(v["Coords"][1],v["Coords"][2],v["Coords"][3]))
			if Distance <= v["Distance"] then
				if not localPeds[Number] and LocalPlayer["state"]["Route"] < 900000 then
					if LoadModel(v["Model"]) then
						localPeds[Number] = CreatePed(4,v["Model"],v["Coords"][1],v["Coords"][2],v["Coords"][3] - 1,v["Coords"][4],false,false)
                        SetEntityVisible(localPeds[Number],true)
						SetPedArmour(localPeds[Number],99)
						SetEntityInvincible(localPeds[Number],true)
						FreezeEntityPosition(localPeds[Number],true)
						SetBlockingOfNonTemporaryEvents(localPeds[Number],true)
                        SetPedDefaultComponentVariation(localPeds[Number])
                        if v["Custom"] then
                            exports["player"]:ApplyFullAppearanceToPed(localPeds[Number], v["Custom"])
                        end

						SetModelAsNoLongerNeeded(v["Model"])
   
						if v["Model"] == "s_f_y_casino_01" then
							SetPedDefaultComponentVariation(localPeds[Number])
							SetPedComponentVariation(localPeds[Number],0,3,0,0)
							SetPedComponentVariation(localPeds[Number],1,0,0,0)
							SetPedComponentVariation(localPeds[Number],2,3,0,0)
							SetPedComponentVariation(localPeds[Number],3,0,1,0)
							SetPedComponentVariation(localPeds[Number],4,1,0,0)
							SetPedComponentVariation(localPeds[Number],6,1,0,0)
							SetPedComponentVariation(localPeds[Number],7,1,0,0)
							SetPedComponentVariation(localPeds[Number],8,0,0,0)
							SetPedComponentVariation(localPeds[Number],10,0,0,0)
							SetPedComponentVariation(localPeds[Number],11,0,0,0)
							SetPedPropIndex(localPeds[Number],1,0,0,false)
						end

						if v["anim"] ~= nil then
							if LoadAnim(v["anim"][1]) then
								TaskPlayAnim(localPeds[Number],v["anim"][1],v["anim"][2],8.0,8.0,-1,1,0,0,0,0)
							end
						end
					end
				end
			else
				if localPeds[Number] then
					if DoesEntityExist(localPeds[Number]) then
						DeleteEntity(localPeds[Number])
					end

					localPeds[Number] = nil
				end
			end
		end

		Wait(1000)
	end
end)

function CheckPed(Table)
    local Coords = vector3(Table[1],Table[2],Table[3])
    local HasPed = true
    for i=1,#PedList do
        local Distance = #(Coords - vec3(PedList[i]["Coords"][1],PedList[i]["Coords"][2],PedList[i]["Coords"][3]))
        if Distance <= 1.5 then
            HasPed = false
        end
    end
    return HasPed
end

function AddPedToList(Table)
    if CheckPed(Table["Coords"]) then
        table.insert(PedList,Table)
    end
end
exports("AddPedToList",AddPedToList)

function ApplyClothes(Ped,Data)
	SetPedComponentVariation(Ped,4,Data["pants"]["item"],Data["pants"]["texture"],1)
	SetPedComponentVariation(Ped,3,Data["arms"]["item"],Data["arms"]["texture"],1)
	SetPedComponentVariation(Ped,5,Data["backpack"]["item"],Data["backpack"]["texture"],1)
	SetPedComponentVariation(Ped,8,Data["tshirt"]["item"],Data["tshirt"]["texture"],1)
	SetPedComponentVariation(Ped,9,Data["vest"]["item"],Data["vest"]["texture"],1)
	SetPedComponentVariation(Ped,11,Data["torso"]["item"],Data["torso"]["texture"],1)
	SetPedComponentVariation(Ped,6,Data["shoes"]["item"],Data["shoes"]["texture"],1)
	SetPedComponentVariation(Ped,1,Data["mask"]["item"],Data["mask"]["texture"],1)
	SetPedComponentVariation(Ped,10,Data["decals"]["item"],Data["decals"]["texture"],1)
	SetPedComponentVariation(Ped,7,Data["accessory"]["item"],Data["accessory"]["texture"],1)

	if Data["hat"]["item"] ~= -1 and Data["hat"]["item"] ~= 0 then
		SetPedPropIndex(Ped,0,Data["hat"]["item"],Data["hat"]["texture"],1)
	else
		ClearPedProp(Ped,0)
	end

	if Data["glass"]["item"] ~= -1 and Data["glass"]["item"] ~= 0 then
		SetPedPropIndex(Ped,1,Data["glass"]["item"],Data["glass"]["texture"],1)
	else
		ClearPedProp(Ped,1)
	end

	if Data["ear"]["item"] ~= -1 and Data["ear"]["item"] ~= 0 then
		SetPedPropIndex(Ped,2,Data["ear"]["item"],Data["ear"]["texture"],1)
	else
		ClearPedProp(Ped,2)
	end

	if Data["watch"]["item"] ~= -1 and Data["watch"]["item"] ~= 0 then
		SetPedPropIndex(Ped,6,Data["watch"]["item"],Data["watch"]["texture"],1)
	else
		ClearPedProp(Ped,6)
	end

	if Data["bracelet"]["item"] ~= -1 and Data["bracelet"]["item"] ~= 0 then
		SetPedPropIndex(Ped,7,Data["bracelet"]["item"],Data["bracelet"]["texture"],1)
	else
		ClearPedProp(Ped,7)
	end
end

function ApplyFacials(Ped,Table)
    if Table then
		Barber = Table
	end

	for Number = 1,50 do
		if not Barber[Number] then
			Barber[Number] = 0
		end
	end

	SetPedHeadBlendData(Ped,Fathers[Barber[1] + 1],Mothers[Barber[2] + 1],0,Barber[5],0,0,Barber[3] + 0.0,0,0,false)

	SetPedEyeColor(Ped,Barber[4])

	SetPedComponentVariation(Ped,2,Barber[10],0,0)
	SetPedHairColor(Ped,Barber[11],Barber[12])

	SetPedHeadOverlay(Ped,0,Barber[7],0.99)
	SetPedHeadOverlayColor(Ped,0,0,0,0)

	SetPedHeadOverlay(Ped,1,Barber[22],Barber[23])
	SetPedHeadOverlayColor(Ped,1,1,Barber[24],Barber[24])

	SetPedHeadOverlay(Ped,2,Barber[19],Barber[20])
	SetPedHeadOverlayColor(Ped,2,1,Barber[21],Barber[21])

	SetPedHeadOverlay(Ped,3,Barber[9],0.99)
	SetPedHeadOverlayColor(Ped,3,0,0,0)

	SetPedHeadOverlay(Ped,4,Barber[13],Barber[14])
	SetPedHeadOverlayColor(Ped,4,1,Barber[15],Barber[15])

	SetPedHeadOverlay(Ped,5,Barber[25],Barber[26])
	SetPedHeadOverlayColor(Ped,5,1,Barber[27],Barber[27])

	SetPedHeadOverlay(Ped,6,Barber[6],0.99)
	SetPedHeadOverlayColor(Ped,6,0,0,0)

	SetPedHeadOverlay(Ped,8,Barber[16],Barber[17])
	SetPedHeadOverlayColor(Ped,8,1,Barber[18],Barber[18])

	SetPedHeadOverlay(Ped,9,Barber[8],0.99)
	SetPedHeadOverlayColor(Ped,9,0,0,0)

    SetPedHeadOverlay(Ped,10, Barber[48], Barber[49])
    SetPedHeadOverlayColor(Ped, 10, 1, Barber[50], Barber[51])

	SetPedFaceFeature(Ped,0,Barber[28])
	SetPedFaceFeature(Ped,1,Barber[29])
	SetPedFaceFeature(Ped,2,Barber[30])
	SetPedFaceFeature(Ped,3,Barber[31])
	SetPedFaceFeature(Ped,4,Barber[32])
	SetPedFaceFeature(Ped,5,Barber[33])
	SetPedFaceFeature(Ped,6,Barber[44])
	SetPedFaceFeature(Ped,7,Barber[34])
	SetPedFaceFeature(Ped,8,Barber[36])
	SetPedFaceFeature(Ped,9,Barber[35])
	SetPedFaceFeature(Ped,10,Barber[45])
	SetPedFaceFeature(Ped,12,Barber[42])
	SetPedFaceFeature(Ped,13,Barber[46])
	SetPedFaceFeature(Ped,14,Barber[37])
	SetPedFaceFeature(Ped,15,Barber[38])
	SetPedFaceFeature(Ped,16,Barber[40])
	SetPedFaceFeature(Ped,17,Barber[39])
	SetPedFaceFeature(Ped,18,Barber[41])
	SetPedFaceFeature(Ped,19,Barber[43])
end