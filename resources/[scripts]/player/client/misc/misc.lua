cityName = GetConvar("cityName", "")
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRIFTENABLE
-----------------------------------------------------------------------------------------------------------------------------------------
function driftEnable()
	if not IsPauseMenuActive() then
		local Ped = PlayerPedId()
		if IsPedInAnyVehicle(Ped) and not IsPedOnAnyBike(Ped) and not IsPedInAnyHeli(Ped) and not IsPedInAnyBoat(Ped) and not IsPedInAnyPlane(Ped) then
			local Vehicle = GetVehiclePedIsIn(Ped)
			if GetPedInVehicleSeat(Vehicle,-1) == Ped then
				local speed = GetEntitySpeed(Vehicle) * 3.6
				if speed <= 100.0 and speed >= 5.0 then
					SetVehicleReduceGrip(Vehicle,true)

					if not GetDriftTyresEnabled(Vehicle) then
						SetDriftTyresEnabled(Vehicle,true)
						SetReduceDriftVehicleSuspension(Vehicle,true)
					end
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRIFTDISABLE
-----------------------------------------------------------------------------------------------------------------------------------------
function driftDisable()
	local Ped = PlayerPedId()
	if IsPedInAnyVehicle(Ped) then
		local Vehicle = GetLastDrivenVehicle()

		if GetDriftTyresEnabled(Vehicle) then
			SetVehicleReduceGrip(Vehicle,false)
			SetDriftTyresEnabled(Vehicle,false)
			SetReduceDriftVehicleSuspension(Vehicle,false)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACTIVEDRIFT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("+activeDrift",driftEnable)
RegisterCommand("-activeDrift",driftDisable)
RegisterKeyMapping("+activeDrift", _t("activeDrift"), "keyboard", "LSHIFT")
-----------------------------------------------------------------------------------------------------------------------------------------
-- SCREAM
-----------------------------------------------------------------------------------------------------------------------------------------
local Scream = false
CreateThread(function()
    StartAudioScene("DLC_MPHEIST_TRANSITION_TO_APT_FADE_IN_RADIO_SCENE")
    SetStaticEmitterEnabled("LOS_SANTOS_VANILLA_UNICORN_01_STAGE",false)
    SetStaticEmitterEnabled("LOS_SANTOS_VANILLA_UNICORN_02_MAIN_ROOM",false)
    SetStaticEmitterEnabled("LOS_SANTOS_VANILLA_UNICORN_03_BACK_ROOM",false)
    SetAmbientZoneListStatePersistent("AZL_DLC_Hei4_Island_Disabled_Zones",false,true)
    SetAmbientZoneListStatePersistent("AZL_DLC_Hei4_Island_Zones",true,true)
    SetScenarioTypeEnabled("WORLD_VEHICLE_STREETRACE",false)
    SetScenarioTypeEnabled("WORLD_VEHICLE_SALTON_DIRT_BIKE",false)
    SetScenarioTypeEnabled("WORLD_VEHICLE_SALTON",false)
    SetScenarioTypeEnabled("WORLD_VEHICLE_POLICE_NEXT_TO_CAR",false)
    SetScenarioTypeEnabled("WORLD_VEHICLE_POLICE_CAR",false)
    SetScenarioTypeEnabled("WORLD_VEHICLE_POLICE_BIKE",false)
    SetScenarioTypeEnabled("WORLD_VEHICLE_MILITARY_PLANES_SMALL",false)
    SetScenarioTypeEnabled("WORLD_VEHICLE_MILITARY_PLANES_BIG",false)
    SetScenarioTypeEnabled("WORLD_VEHICLE_MECHANIC",false)
    SetScenarioTypeEnabled("WORLD_VEHICLE_EMPTY",false)
    SetScenarioTypeEnabled("WORLD_VEHICLE_BUSINESSMEN",false)
    SetScenarioTypeEnabled("WORLD_VEHICLE_BIKE_OFF_ROAD_RACE",false)
    StartAudioScene("FBI_HEIST_H5_MUTE_AMBIENCE_SCENE")
    StartAudioScene("CHARACTER_CHANGE_IN_SKY_SCENE")

	-- Desabilita sirens de policia que estão distantes e somente com a luz de emergencia ligadas
	DistantCopCarSirens( false )

	while true do
        local TimeDistance = 2000

        local Ped = PlayerPedId()
        local Coords = GetEntityCoords(Ped)
        local Distance = #(Coords - vector3(-542.76,1982.39,127.03))
        if not Scream and Distance <= 8 then
			Scream = true
			TriggerEvent("sounds:Private","scream",0.4)
        else
            if Scream and Distance > 8 then
                Scream = false
            end
        end

        Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
local Blips = {
	
	
}

if cityName == "CidadeNobre" then
	Blips[#Blips+1] = { 55.43,-876.19,30.66,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 598.04,2741.27,42.07,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -136.36,6357.03,31.49,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 275.23,-345.54,45.17,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 596.40,90.65,93.12,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -340.76,265.97,85.67,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -2030.01,-465.97,11.60,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -1184.92,-1510.00,4.64,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 214.02,-808.44,31.01,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -348.88,-874.02,31.31,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 67.74,12.27,69.21,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 361.90,297.81,103.88,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 1035.89,-763.89,57.99,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -796.63,-2022.77,9.16,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 453.27,-1146.76,29.52,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 528.66,-146.3,58.38,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -1159.48,-739.32,19.89,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 101.22,-1073.68,29.38,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 1725.21,4711.77,42.11,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 1624.05,3566.14,35.15,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -73.35,-2004.6,18.27,539,4,"Garagem",0.4 }
		
		-- ILHAS
		
		-- { 5053.84,-4624.94,2.76 ,384,47,"Ilha Cayo Perico",1.0 }
		
		-- PONTOS CENTRAIS
	Blips[#Blips+1] = { 178.54,-982.15,29.64,266,5,"Praça Central",1.0 }	
	Blips[#Blips+1] = { -1610.53,-1011.25,13.02,266,5,"Pier Sul",1.0 }
	Blips[#Blips+1] = { 1428.78,6490.94,20.34,266,5,"Pier Norte",0.8 }		
	Blips[#Blips+1] = { 1154.33,-1466.42,34.69,106,5,"Bombeiros",0.7 }
	Blips[#Blips+1] = { 1695.43,3591.85,35.60,106,5,"Bombeiros",0.7 }
	Blips[#Blips+1] = { 1046.64,2300.27,44.82,108,5,"Local de Farm",0.7 }
	Blips[#Blips+1] = { 134.06,-3088.0,8.21,108,5,"Local de Farm",0.7 }
	Blips[#Blips+1] = { 118.66,-1087.29,29.22,587,2,"Baú Pessoal (Grátis)",0.5 }			
	Blips[#Blips+1] = { 1420.9,6564.6,18.53,587,2,"Baú Pessoal (Grátis)",0.5 }		
	Blips[#Blips+1] = { 1860.07,2608.29,45.66,188,1,"Prisão",1.5 }
	Blips[#Blips+1] = { -2034.31,3013.1,32.81,487,5,"Zancudo",1.0 }

	Blips[#Blips+1] = { 91.72,-2832.14,6.35,595,5,"Autódromo",1.0 }

	Blips[#Blips+1] = { -444.09,6001.79,44.01,487,5,"Departamento Policial",1.0 }
	Blips[#Blips+1] = { -938.86,-766.45,17.93,80,5,"Hospital",0.5 } -- hp principal
	-- Blips[#Blips+1] = { -236.08,6331.21,32.33,80,5,"Hospital",0.5 } -- HP NORTE

	Blips[#Blips+1] = { -20.2,-1106.4,28.0,225,5,"Concessionária",0.8 }
	Blips[#Blips+1] = { 229.77,214.17,105.55,431,5,"Banco Central",0.8 }
		
	Blips[#Blips+1] = { 501.59,5604.47,797.91,164,5,"Monte Chiliad",1.0 }
	Blips[#Blips+1] = { -174.42,-2147.11,16.7,409,5,"Kartódromo",0.8 }
	Blips[#Blips+1] = { -1627.64,-3099.74,13.93,184,5,"Estúdio de Fotográfia",0.8 }	
	Blips[#Blips+1] = { -1256.65,-3356.17,13.93,184,5,"Estúdio de Fotográfia",0.8 }
		
		-- { 2380.24,5094.35,47.35,285,3,"Emprego | Lenhador",0.5 }
	Blips[#Blips+1] = { 2515.56,4763.37,34.76,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { 2953.93,2787.49,41.5,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { 1418.79,6715.32,14.37,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { 453.82,-600.6,28.58,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { 751.71,6459.04,31.53,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { 2093.65,5044.13,41.18,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { -19.92,6304.38,31.37,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { -406.04,6148.4,31.68,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { -1471.72,-920.16,10.03,108,3,"Emprego Legal",0.7 }

	Blips[#Blips+1] = { -428.56,-1728.33,19.79,365,3,"Loja | Reciclagem",0.8 }
	Blips[#Blips+1] = { 29.2,-1351.89,29.34,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 2561.74,385.22,108.61,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 1160.21,-329.4,69.03,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -711.99,-919.96,19.01,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -54.56,-1758.56,29.05,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 375.87,320.04,103.42,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -3237.48,1004.72,12.45,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 1730.64,6409.67,35.0,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 543.51,2676.85,42.14,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 1966.53,3737.95,32.18,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 2684.73,3281.2,55.23,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 1696.12,4931.56,42.07,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -1820.18,785.69,137.98,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 1395.35,3596.6,34.86,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -2977.14,391.22,15.03,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -3034.99,590.77,7.8,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 1144.46,-980.74,46.19,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 1166.06,2698.17,37.95,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -1493.12,-385.55,39.87,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -1228.6,-899.7,12.27,52,4,"Loja de Departamento",0.5 }

	Blips[#Blips+1] = { 1702.78,3748.82,34.05,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { 240.06,-43.74,69.71,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { 843.95,-1020.43,27.53,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { -322.19,6072.86,31.27,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { -664.03,-949.22,21.53,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { -1318.83,-389.19,36.43,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { -1110.11,2687.5,18.62,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { 2569.23,309.46,108.46,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { -3159.91,1080.64,20.69,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { 15.42,-1120.47,28.81,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { 811.81,-2145.58,29.34,76,4,"Loja de Armas",0.5 }


	Blips[#Blips+1] = { -815.12,-184.15,37.57,71,4,"Barbearia",0.5 }
	Blips[#Blips+1] = { 138.13,-1706.46,29.3,71,4,"Barbearia",0.5 }
	Blips[#Blips+1] = { -1280.92,-1117.07,7.0,71,4,"Barbearia",0.5 }
	Blips[#Blips+1] = { 1930.54,3732.06,32.85,71,4,"Barbearia",0.5 }
	Blips[#Blips+1] = { 1214.2,-473.18,66.21,71,4,"Barbearia",0.5 }
	Blips[#Blips+1] = { -33.61,-154.52,57.08,71,4,"Barbearia",0.5 }
	Blips[#Blips+1] = { -276.65,6226.76,31.7,71,4,"Barbearia",0.5 }


		-- { -1117.26,-1438.74,5.11,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { 86.06,-1391.64,29.23,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -719.94,-158.18,37.0,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -152.79,-306.79,38.67,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -816.39,-1081.22,11.12,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -1206.51,-781.5,17.12,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -1458.26,-229.79,49.2,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -2.41,6518.29,31.48,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { 1682.59,4819.98,42.04,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { 129.46,-205.18,54.51,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { 618.49,2745.54,42.01,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { 1197.93,2698.21,37.96,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -3165.74,1061.29,20.84,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -1093.76,2703.99,19.04,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { 414.86,-807.57,29.34,366,4,"Loja de Roupas",0.5 }
		
		
		-- { -1728.06,-1050.69,1.71,471,62,"Embarcações",0.5 }
	Blips[#Blips+1] = { 1966.36,3975.86,31.51,471,62,"Embarcações",0.5 }
	Blips[#Blips+1] = { -776.72,-1495.02,2.29,471,62,"Embarcações",0.5 }
	Blips[#Blips+1] = { -893.97,5687.78,3.29,471,62,"Embarcações",0.5 }
	Blips[#Blips+1] = { 4952.76,-5163.6,-0.3,471,62,"Embarcações",0.5 }
	Blips[#Blips+1] = { -1728.15,-1050.64,1.7,471,62,"Embarcações",0.5 }
	Blips[#Blips+1] = { -1622.55,-1167.98,1.45,471,62,"Embarcações",0.5 }


	Blips[#Blips+1] = { 591.17,2743.5,42.04,51,4,"Farmácia Clandestina",0.8 }
	Blips[#Blips+1] = { 45.95,3703.11,39.75,556,5,"Mercado Negro e Lavagem de Dinheiro",1.0 }
		-- { -1198.15,-1458.38,4.36,51,15,"Farmácia",0.5 }
		-- { -1255.49,-1436.33,4.36,51,15,"Farmácia",0.5 }

		
	Blips[#Blips+1] = { 1322.93,-1652.29,52.27,75,36,"Loja de Tatuagem",0.5 }
	Blips[#Blips+1] = { -1154.42,-1425.9,4.95,75,36,"Loja de Tatuagem",0.5 }
	Blips[#Blips+1] = { 322.84,180.16,103.58,75,36,"Loja de Tatuagem",0.5 }
	Blips[#Blips+1] = { -3169.62,1075.8,20.83,75,36,"Loja de Tatuagem",0.5 }
	Blips[#Blips+1] = { 1864.07,3747.9,33.03,75,36,"Loja de Tatuagem",0.5 }
	Blips[#Blips+1] = { -293.57,6199.85,31.48,75,36,"Loja de Tatuagem",0.5 }


	Blips[#Blips+1] = { 5323.13,-5238.68,32.76 ,539,36,"Cayo Perico",0.5 }
	Blips[#Blips+1] = { 5157.12,-5104.11,2.36 ,539,36,"Cayo Perico",0.5 }
	Blips[#Blips+1] = { 4930.78,-5146.1,2.48 ,539,36,"Cayo Perico",0.5 }
	Blips[#Blips+1] = { 4973.78,-5856.06,19.82 ,539,36,"Cayo Perico",0.5 }
	Blips[#Blips+1] = { 4936.15,-4900.87,3.62 ,539,36,"Cayo Perico",0.5 }
	Blips[#Blips+1] = { 4455.61,-4521.53,4.11 ,539,36,"Cayo Perico",0.5 }
		-- { -61.89,-1218.25,28.7 ,51,62,"Entregas de Drogas",0.6 }
		-- { 218.09,-1391.38,30.58 ,51,62,"Entregas de Droga",0.6 }
		-- { -1695.32,-287.06,51.88 ,51,62,"Entregas de Droga",0.6 }
	
	-- Blips[#Blips+1] = { 404.42,-1954.53,0.0,432,1,"Área de Risco | Pistola",1.0 }				--- VAGOS
	-- Blips[#Blips+1] = { -1287.0,2525.61,19.78,432,1,"Área de Risco | Fuzil e Pistola",1.0 }		--- PROX BOPE
	Blips[#Blips+1] = { 80.64,-1731.52,29.28,488,5,"Mecânica",0.8 } -- Mecanica
	Blips[#Blips+1] = { 2567.58,-358.4,92.99,487,5,"Departamento Policial",1.0 } -- dp principal
	Blips[#Blips+1] = { -825.44,-1220.28,6.93,487,5,"Departamento Policial",1.0 } -- Tatica
	-- Blips[#Blips+1] = { -831.85,-1215.67,6.94,487,5,"Departamento Policial",1.0 } -- Tatica
	Blips[#Blips+1] = { 2613.75,5280.4,70.6,487,5,"Prf",1.0 } -- prf
	Blips[#Blips+1] = { 120.69,-1317.15,28.93,436,5,"Vanilla +18",0.8 }
	-- Blips[#Blips+1] = { -1630.07,215.08,60.73,492,5,"Escolinha Nobre",1.0 } -- Escolinha
	Blips[#Blips+1] = { -518.0,-251.84,140.83,385,5,"Juridico",1.0 }
	-- Blips[#Blips+1] = { -3188.88,-1145.31,7.82,436,5,"Ilha da Revoada",0.8 }
	Blips[#Blips+1] = { 3050.88,-4706.21,15.27,575,47,"Porta-Aviões",1.0 }
	Blips[#Blips+1] = { -258.34,-2024.09,86.61,785,47,"Nobre Arena",1.0 }	

elseif cityName == "Boomerang" then
	Blips[#Blips+1] = { 55.43,-876.19,30.66,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 598.04,2741.27,42.07,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -136.36,6357.03,31.49,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 275.23,-345.54,45.17,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 596.40,90.65,93.12,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -340.76,265.97,85.67,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -2030.01,-465.97,11.60,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -1184.92,-1510.00,4.64,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 214.02,-808.44,31.01,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -348.88,-874.02,31.31,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 67.74,12.27,69.21,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 361.90,297.81,103.88,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 1035.89,-763.89,57.99,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -796.63,-2022.77,9.16,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 453.27,-1146.76,29.52,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 528.66,-146.3,58.38,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -1159.48,-739.32,19.89,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 101.22,-1073.68,29.38,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 1725.21,4711.77,42.11,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 1624.05,3566.14,35.15,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -73.35,-2004.6,18.27,539,4,"Garages",0.4 }
		
		-- ISLANDS
		
		
		-- CENTRAL POINTS
	Blips[#Blips+1] = { 178.54,-982.15,29.64,266,5,"Central Square",1.0 }	
	Blips[#Blips+1] = { -1610.53,-1011.25,13.02,266,5,"South Pier",1.0 }
	Blips[#Blips+1] = { 1428.78,6490.94,20.34,266,5,"North Pier",0.8 }		
	Blips[#Blips+1] = { -663.45,-73.46,38.52,106,5,"Fire Department",0.7 }
	Blips[#Blips+1] = { 1046.64,2300.27,44.82,108,5,"Farm Location",0.7 }
	Blips[#Blips+1] = { 134.06,-3088.0,8.21,108,5,"Farm Location",0.7 }
	Blips[#Blips+1] = { 118.66,-1087.29,29.22,587,2,"Personal Chest (Free)",0.5 }			
	Blips[#Blips+1] = { 1420.9,6564.6,18.53,587,2,"Personal Chest (Free)",0.5 }		
	Blips[#Blips+1] = { 1860.07,2608.29,45.66,188,1,"Prison",1.5 }

	Blips[#Blips+1] = { 1152.97,-1526.05,34.85,80,5,"Hospital",0.5 } -- main hp

	Blips[#Blips+1] = { -70.49,-1104.59,26.12,225,5,"Dealership",0.8 }
	Blips[#Blips+1] = { 229.77,214.17,105.55,431,5,"Central Bank",0.8 }
		
	Blips[#Blips+1] = { -2329.46,3266.47,32.82,487,5,"Zancudo",1.0 }
	Blips[#Blips+1] = { 501.59,5604.47,797.91,164,5,"Mount Chiliad",1.0 }
	Blips[#Blips+1] = { -174.42,-2147.11,16.7,409,5,"Go-Kart Track",0.8 }
	Blips[#Blips+1] = { -1627.64,-3099.74,13.93,184,5,"Photography Studio",0.8 }	
	Blips[#Blips+1] = { -1256.65,-3356.17,13.93,184,5,"Photography Studio",0.8 }
		

	Blips[#Blips+1] = { 2515.56,4763.37,34.76,108,3,"Legitimate Job",0.7 }
	Blips[#Blips+1] = { 2953.93,2787.49,41.5,108,3,"Legitimate Job",0.7 }
	Blips[#Blips+1] = { 1418.79,6715.32,14.37,108,3,"Legitimate Job",0.7 }
	Blips[#Blips+1] = { 453.82,-600.6,28.58,108,3,"Legitimate Job",0.7 }
	Blips[#Blips+1] = { 751.71,6459.04,31.53,108,3,"Legitimate Job",0.7 }
	Blips[#Blips+1] = { 2093.65,5044.13,41.18,108,3,"Legitimate Job",0.7 }
	Blips[#Blips+1] = { -19.92,6304.38,31.37,108,3,"Legitimate Job",0.7 }
	Blips[#Blips+1] = { -406.04,6148.4,31.68,108,3,"Legitimate Job",0.7 }
	Blips[#Blips+1] = { -1471.72,-920.16,10.03,108,3,"Legitimate Job",0.7 }

	Blips[#Blips+1] = { -428.56,-1728.33,19.79,365,3,"Store | Recycling",0.8 }
	Blips[#Blips+1] = { 29.2,-1351.89,29.34,52,4,"Department Store",0.5 }
	Blips[#Blips+1] = { 2561.74,385.22,108.61,52,4,"Department Store",0.5 }
	Blips[#Blips+1] = { 1160.21,-329.4,69.03,52,4,"Department Store",0.5 }
	Blips[#Blips+1] = { -711.99,-919.96,19.01,52,4,"Department Store",0.5 }
	Blips[#Blips+1] = { -54.56,-1758.56,29.05,52,4,"Department Store",0.5 }
	Blips[#Blips+1] = { 375.87,320.04,103.42,52,4,"Department Store",0.5 }
	Blips[#Blips+1] = { -3237.48,1004.72,12.45,52,4,"Department Store",0.5 }
	Blips[#Blips+1] = { 1730.64,6409.67,35.0,52,4,"Department Store",0.5 }
	Blips[#Blips+1] = { 543.51,2676.85,42.14,52,4,"Department Store",0.5 }
	Blips[#Blips+1] = { 1966.53,3737.95,32.18,52,4,"Department Store",0.5 }
	Blips[#Blips+1] = { 2684.73,3281.2,55.23,52,4,"Department Store",0.5 }
	Blips[#Blips+1] = { 1696.12,4931.56,42.07,52,4,"Department Store",0.5 }
	Blips[#Blips+1] = { -1820.18,785.69,137.98,52,4,"Department Store",0.5 }
	Blips[#Blips+1] = { 1395.35,3596.6,34.86,52,4,"Department Store",0.5 }
	Blips[#Blips+1] = { -2977.14,391.22,15.03,52,4,"Department Store",0.5 }
	Blips[#Blips+1] = { -3034.99,590.77,7.8,52,4,"Department Store",0.5 }
	Blips[#Blips+1] = { 1144.46,-980.74,46.19,52,4,"Department Store",0.5 }
	Blips[#Blips+1] = { 1166.06,2698.17,37.95,52,4,"Department Store",0.5 }
	Blips[#Blips+1] = { -1493.12,-385.55,39.87,52,4,"Department Store",0.5 }
	Blips[#Blips+1] = { -1228.6,-899.7,12.27,52,4,"Department Store",0.5 }

	Blips[#Blips+1] = { 1702.78,3748.82,34.05,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { 240.06,-43.74,69.71,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { 843.95,-1020.43,27.53,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { -322.19,6072.86,31.27,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { -664.03,-949.22,21.53,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { -1318.83,-389.19,36.43,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { -1110.11,2687.5,18.62,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { 2569.23,309.46,108.46,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { -3159.91,1080.64,20.69,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { 15.42,-1120.47,28.81,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { 811.81,-2145.58,29.34,76,4,"Ammunation",0.5 }


	Blips[#Blips+1] = { -815.12,-184.15,37.57,71,4,"Barbershop",0.5 }
	Blips[#Blips+1] = { 138.13,-1706.46,29.3,71,4,"Barbershop",0.5 }
	Blips[#Blips+1] = { -1280.92,-1117.07,7.0,71,4,"Barbershop",0.5 }
	Blips[#Blips+1] = { 1930.54,3732.06,32.85,71,4,"Barbershop",0.5 }
	Blips[#Blips+1] = { 1214.2,-473.18,66.21,71,4,"Barbershop",0.5 }
	Blips[#Blips+1] = { -33.61,-154.52,57.08,71,4,"Barbershop",0.5 }
	Blips[#Blips+1] = { -276.65,6226.76,31.7,71,4,"Barbershop",0.5 }


	Blips[#Blips+1] = { 86.06,-1391.64,29.23,366,4,"Clothing Shop",0.5 }
	Blips[#Blips+1] = { -719.94,-158.18,37.0,366,4,"Clothing Shop",0.5 }
	Blips[#Blips+1] = { -152.79,-306.79,38.67,366,4,"Clothing Shop",0.5 }
	Blips[#Blips+1] = { -816.39,-1081.22,11.12,366,4,"Clothing Shop",0.5 }
	Blips[#Blips+1] = { -1206.51,-781.5,17.12,366,4,"Clothing Shop",0.5 }
	Blips[#Blips+1] = { -1458.26,-229.79,49.2,366,4,"Clothing Shop",0.5 }
	Blips[#Blips+1] = { -2.41,6518.29,31.48,366,4,"Clothing Shop",0.5 }
	Blips[#Blips+1] = { 1682.59,4819.98,42.04,366,4,"Clothing Shop",0.5 }
	Blips[#Blips+1] = { 129.46,-205.18,54.51,366,4,"Clothing Shop",0.5 }
	Blips[#Blips+1] = { 618.49,2745.54,42.01,366,4,"Clothing Shop",0.5 }
	Blips[#Blips+1] = { 1197.93,2698.21,37.96,366,4,"Clothing Shop",0.5 }
	Blips[#Blips+1] = { -3165.74,1061.29,20.84,366,4,"Clothing Shop",0.5 }
	Blips[#Blips+1] = { -1093.76,2703.99,19.04,366,4,"Clothing Shop",0.5 }
	Blips[#Blips+1] = { 414.86,-807.57,29.34,366,4,"Clothing Shop",0.5 }
		

	Blips[#Blips+1] = { 1966.36,3975.86,31.51,471,62,"Boats / Vessels",0.5 }
	Blips[#Blips+1] = { -776.72,-1495.02,2.29,471,62,"Boats / Vessels",0.5 }
	Blips[#Blips+1] = { -893.97,5687.78,3.29,471,62,"Boats / Vessels",0.5 }
	Blips[#Blips+1] = { 4952.76,-5163.6,-0.3,471,62,"Boats / Vessels",0.5 }
	Blips[#Blips+1] = { -1728.15,-1050.64,1.7,471,62,"Boats / Vessels",0.5 }
	Blips[#Blips+1] = { -1622.55,-1167.98,1.45,471,62,"Boats / Vessels",0.5 }


	Blips[#Blips+1] = { 591.17,2743.5,42.04,51,4,"Illegal Pharmacy",0.8 }
	Blips[#Blips+1] = { 45.95,3703.11,39.75,556,5,"Black Market and Money Laundering",1.0 }

		
	Blips[#Blips+1] = { 1322.93,-1652.29,52.27,75,36,"Tattooshop",0.5 }
	Blips[#Blips+1] = { -1154.42,-1425.9,4.95,75,36,"Tattooshop",0.5 }
	Blips[#Blips+1] = { 322.84,180.16,103.58,75,36,"Tattooshop",0.5 }
	Blips[#Blips+1] = { -3169.62,1075.8,20.83,75,36,"Tattooshop",0.5 }
	Blips[#Blips+1] = { 1864.07,3747.9,33.03,75,36,"Tattooshop",0.5 }
	Blips[#Blips+1] = { -293.57,6199.85,31.48,75,36,"Tattooshop",0.5 }


	Blips[#Blips+1] = { 5323.13,-5238.68,32.76 ,539,36,"Cayo Perico",0.5 }
	Blips[#Blips+1] = { 5157.12,-5104.11,2.36 ,539,36,"Cayo Perico",0.5 }
	Blips[#Blips+1] = { 4930.78,-5146.1,2.48 ,539,36,"Cayo Perico",0.5 }
	Blips[#Blips+1] = { 4973.78,-5856.06,19.82 ,539,36,"Cayo Perico",0.5 }
	Blips[#Blips+1] = { 4936.15,-4900.87,3.62 ,539,36,"Cayo Perico",0.5 }
	Blips[#Blips+1] = { 4455.61,-4521.53,4.11 ,539,36,"Cayo Perico",0.5 }


	Blips[#Blips+1] = { -1072.9,-2065.83,13.29,488,5,"Mechanic",0.8 } -- Mecanica
	Blips[#Blips+1] = { -236.08,6331.21,32.33,80,5,"Hospital",0.5 } -- NORTH HP
	Blips[#Blips+1] = { 120.69,-1317.15,28.93,436,5,"Vanilla +18",0.8 }
	Blips[#Blips+1] = { -518.0,-251.84,140.83,385,5,"Legal",1.0 }
	Blips[#Blips+1] = { 3050.88,-4706.21,15.27,575,47,"Aircraft Carrier",1.0 }
	Blips[#Blips+1] = { -258.34,-2024.09,86.61,785,47,"Boomerang Arena",1.0 }
	Blips[#Blips+1] = { 2567.58,-358.4,92.99,487,5,"Police Department",1.0 } -- main pd


elseif cityName == "Malta" then
		Blips[#Blips+1] = { 55.43,-876.19,30.66,539,4,"Garagem",0.4 }
		Blips[#Blips+1] = { 598.04,2741.27,42.07,539,4,"Garagem",0.4 }
		Blips[#Blips+1] = { -136.36,6357.03,31.49,539,4,"Garagem",0.4 }
		Blips[#Blips+1] = { 275.23,-345.54,45.17,539,4,"Garagem",0.4 }
		Blips[#Blips+1] = { 596.40,90.65,93.12,539,4,"Garagem",0.4 }
		Blips[#Blips+1] = { -340.76,265.97,85.67,539,4,"Garagem",0.4 }
		Blips[#Blips+1] = { -2030.01,-465.97,11.60,539,4,"Garagem",0.4 }
		Blips[#Blips+1] = { -1184.92,-1510.00,4.64,539,4,"Garagem",0.4 }
		Blips[#Blips+1] = { 214.02,-808.44,31.01,539,4,"Garagem",0.4 }
		Blips[#Blips+1] = { -348.88,-874.02,31.31,539,4,"Garagem",0.4 }
		Blips[#Blips+1] = { 67.74,12.27,69.21,539,4,"Garagem",0.4 }
		Blips[#Blips+1] = { 361.90,297.81,103.88,539,4,"Garagem",0.4 }
		Blips[#Blips+1] = { 1035.89,-763.89,57.99,539,4,"Garagem",0.4 }
		Blips[#Blips+1] = { -796.63,-2022.77,9.16,539,4,"Garagem",0.4 }
		Blips[#Blips+1] = { 453.27,-1146.76,29.52,539,4,"Garagem",0.4 }
		Blips[#Blips+1] = { 528.66,-146.3,58.38,539,4,"Garagem",0.4 }
		Blips[#Blips+1] = { -1159.48,-739.32,19.89,539,4,"Garagem",0.4 }
		Blips[#Blips+1] = { 101.22,-1073.68,29.38,539,4,"Garagem",0.4 }
		Blips[#Blips+1] = { 1725.21,4711.77,42.11,539,4,"Garagem",0.4 }
		Blips[#Blips+1] = { 1624.05,3566.14,35.15,539,4,"Garagem",0.4 }
		Blips[#Blips+1] = { -73.35,-2004.6,18.27,539,4,"Garagem",0.4 }
			
			-- ILHAS
			
			-- { 5053.84,-4624.94,2.76 ,384,47,"Ilha Cayo Perico",1.0 }
			
			-- PONTOS CENTRAIS
		Blips[#Blips+1] = { 178.54,-982.15,29.64,266,5,"Praça Central",1.0 }	
		Blips[#Blips+1] = { -1610.53,-1011.25,13.02,266,5,"Pier Sul",1.0 }
		Blips[#Blips+1] = { 1428.78,6490.94,20.34,266,5,"Pier Norte",0.8 }		
		Blips[#Blips+1] = { -663.45,-73.46,38.52,106,5,"Bombeiros",0.7 }
		Blips[#Blips+1] = { 1686.24,3598.55,35.73,106,5,"Bombeiros",0.7 } -- Sandy Shoes
		Blips[#Blips+1] = { 1046.64,2300.27,44.82,108,5,"Local de Farm",0.7 }
		Blips[#Blips+1] = { 134.06,-3088.0,8.21,108,5,"Local de Farm",0.7 }
		Blips[#Blips+1] = { 118.66,-1087.29,29.22,587,2,"Baú Pessoal (Grátis)",0.5 }			
		Blips[#Blips+1] = { 1420.9,6564.6,18.53,587,2,"Baú Pessoal (Grátis)",0.5 }		
		Blips[#Blips+1] = { 1860.07,2608.29,45.66,188,1,"Prisão",1.5 }	
		Blips[#Blips+1] = { -310.49,-610.89,32.77,80,5,"Hospital",0.5 } -- hp principal
	
		Blips[#Blips+1] = { -70.49,-1104.59,26.12,225,5,"Stand",0.8 }
		Blips[#Blips+1] = { 229.77,214.17,105.55,431,5,"Banco Central",0.8 }
			
		-- Blips[#Blips+1] = { -2329.46,3266.47,32.82,487,5,"Forte Zancudo",1.0 }
		Blips[#Blips+1] = { 501.59,5604.47,797.91,164,5,"Monte Chiliad",1.0 }
		Blips[#Blips+1] = { -174.42,-2147.11,16.7,409,5,"Kartódromo",0.8 }
		Blips[#Blips+1] = { -1627.64,-3099.74,13.93,184,5,"Estúdio de Fotográfia",0.8 }	
		Blips[#Blips+1] = { -1256.65,-3356.17,13.93,184,5,"Estúdio de Fotográfia",0.8 }
			
			-- { 2380.24,5094.35,47.35,285,3,"Emprego | Lenhador",0.5 }
		Blips[#Blips+1] = { 2515.56,4763.37,34.76,108,3,"Emprego Legal",0.7 }
		Blips[#Blips+1] = { 2953.93,2787.49,41.5,108,3,"Emprego Legal",0.7 }
		Blips[#Blips+1] = { 1418.79,6715.32,14.37,108,3,"Emprego Legal",0.7 }
		Blips[#Blips+1] = { 453.82,-600.6,28.58,108,3,"Emprego Legal",0.7 }
		Blips[#Blips+1] = { 751.71,6459.04,31.53,108,3,"Emprego Legal",0.7 }
		Blips[#Blips+1] = { 2093.65,5044.13,41.18,108,3,"Emprego Legal",0.7 }
		Blips[#Blips+1] = { -19.92,6304.38,31.37,108,3,"Emprego Legal",0.7 }
		Blips[#Blips+1] = { -406.04,6148.4,31.68,108,3,"Emprego Legal",0.7 }
		Blips[#Blips+1] = { -1471.72,-920.16,10.03,108,3,"Emprego Legal",0.7 }
	
		-- Blips[#Blips+1] = { -428.56,-1728.33,19.79,365,3,"Loja | Reciclagem",0.8 }
		Blips[#Blips+1] = { 29.2,-1351.89,29.34,52,4,"Mercearia",0.5 }
		Blips[#Blips+1] = { 2561.74,385.22,108.61,52,4,"Mercearia",0.5 }
		Blips[#Blips+1] = { 1160.21,-329.4,69.03,52,4,"Mercearia",0.5 }
		Blips[#Blips+1] = { -711.99,-919.96,19.01,52,4,"Mercearia",0.5 }
		Blips[#Blips+1] = { -54.56,-1758.56,29.05,52,4,"Mercearia",0.5 }
		Blips[#Blips+1] = { 375.87,320.04,103.42,52,4,"Mercearia",0.5 }
		Blips[#Blips+1] = { -3237.48,1004.72,12.45,52,4,"Mercearia",0.5 }
		Blips[#Blips+1] = { 1730.64,6409.67,35.0,52,4,"Mercearia",0.5 }
		Blips[#Blips+1] = { 543.51,2676.85,42.14,52,4,"Mercearia",0.5 }
		Blips[#Blips+1] = { 1966.53,3737.95,32.18,52,4,"Mercearia",0.5 }
		Blips[#Blips+1] = { 2684.73,3281.2,55.23,52,4,"Mercearia",0.5 }
		Blips[#Blips+1] = { 1696.12,4931.56,42.07,52,4,"Mercearia",0.5 }
		Blips[#Blips+1] = { -1820.18,785.69,137.98,52,4,"Mercearia",0.5 }
		Blips[#Blips+1] = { 1395.35,3596.6,34.86,52,4,"Mercearia",0.5 }
		Blips[#Blips+1] = { -2977.14,391.22,15.03,52,4,"Mercearia",0.5 }
		Blips[#Blips+1] = { -3034.99,590.77,7.8,52,4,"Mercearia",0.5 }
		Blips[#Blips+1] = { 1144.46,-980.74,46.19,52,4,"Mercearia",0.5 }
		Blips[#Blips+1] = { 1166.06,2698.17,37.95,52,4,"Mercearia",0.5 }
		Blips[#Blips+1] = { -1493.12,-385.55,39.87,52,4,"Mercearia",0.5 }
		Blips[#Blips+1] = { -1228.6,-899.7,12.27,52,4,"Mercearia",0.5 }
	
		Blips[#Blips+1] = { 1702.78,3748.82,34.05,76,4,"Loja de Armas",0.5 }
		Blips[#Blips+1] = { 240.06,-43.74,69.71,76,4,"Loja de Armas",0.5 }
		Blips[#Blips+1] = { 843.95,-1020.43,27.53,76,4,"Loja de Armas",0.5 }
		Blips[#Blips+1] = { -322.19,6072.86,31.27,76,4,"Loja de Armas",0.5 }
		Blips[#Blips+1] = { -664.03,-949.22,21.53,76,4,"Loja de Armas",0.5 }
		Blips[#Blips+1] = { -1318.83,-389.19,36.43,76,4,"Loja de Armas",0.5 }
		Blips[#Blips+1] = { -1110.11,2687.5,18.62,76,4,"Loja de Armas",0.5 }
		Blips[#Blips+1] = { 2569.23,309.46,108.46,76,4,"Loja de Armas",0.5 }
		Blips[#Blips+1] = { -3159.91,1080.64,20.69,76,4,"Loja de Armas",0.5 }
		Blips[#Blips+1] = { 15.42,-1120.47,28.81,76,4,"Loja de Armas",0.5 }
		Blips[#Blips+1] = { 811.81,-2145.58,29.34,76,4,"Loja de Armas",0.5 }
	
	
		Blips[#Blips+1] = { -815.12,-184.15,37.57,71,4,"Barbearia",0.5 }
		Blips[#Blips+1] = { 138.13,-1706.46,29.3,71,4,"Barbearia",0.5 }
		Blips[#Blips+1] = { -1280.92,-1117.07,7.0,71,4,"Barbearia",0.5 }
		Blips[#Blips+1] = { 1930.54,3732.06,32.85,71,4,"Barbearia",0.5 }
		Blips[#Blips+1] = { 1214.2,-473.18,66.21,71,4,"Barbearia",0.5 }
		Blips[#Blips+1] = { -33.61,-154.52,57.08,71,4,"Barbearia",0.5 }
		Blips[#Blips+1] = { -276.65,6226.76,31.7,71,4,"Barbearia",0.5 }
	
	
			-- { -1117.26,-1438.74,5.11,366,4,"Loja de Roupas",0.5 }
		Blips[#Blips+1] = { 86.06,-1391.64,29.23,366,4,"Loja de Roupas",0.5 }
		Blips[#Blips+1] = { -719.94,-158.18,37.0,366,4,"Loja de Roupas",0.5 }
		Blips[#Blips+1] = { -152.79,-306.79,38.67,366,4,"Loja de Roupas",0.5 }
		Blips[#Blips+1] = { -816.39,-1081.22,11.12,366,4,"Loja de Roupas",0.5 }
		Blips[#Blips+1] = { -1206.51,-781.5,17.12,366,4,"Loja de Roupas",0.5 }
		Blips[#Blips+1] = { -1458.26,-229.79,49.2,366,4,"Loja de Roupas",0.5 }
		Blips[#Blips+1] = { -2.41,6518.29,31.48,366,4,"Loja de Roupas",0.5 }
		Blips[#Blips+1] = { 1682.59,4819.98,42.04,366,4,"Loja de Roupas",0.5 }
		Blips[#Blips+1] = { 129.46,-205.18,54.51,366,4,"Loja de Roupas",0.5 }
		Blips[#Blips+1] = { 618.49,2745.54,42.01,366,4,"Loja de Roupas",0.5 }
		Blips[#Blips+1] = { 1197.93,2698.21,37.96,366,4,"Loja de Roupas",0.5 }
		Blips[#Blips+1] = { -3165.74,1061.29,20.84,366,4,"Loja de Roupas",0.5 }
		Blips[#Blips+1] = { -1093.76,2703.99,19.04,366,4,"Loja de Roupas",0.5 }
		Blips[#Blips+1] = { 414.86,-807.57,29.34,366,4,"Loja de Roupas",0.5 }
			
			
			-- { -1728.06,-1050.69,1.71,471,62,"Embarcações",0.5 }
		Blips[#Blips+1] = { 1966.36,3975.86,31.51,471,62,"Embarcações",0.5 }
		Blips[#Blips+1] = { -776.72,-1495.02,2.29,471,62,"Embarcações",0.5 }
		Blips[#Blips+1] = { -893.97,5687.78,3.29,471,62,"Embarcações",0.5 }
		Blips[#Blips+1] = { 4952.76,-5163.6,-0.3,471,62,"Embarcações",0.5 }
		Blips[#Blips+1] = { -1728.15,-1050.64,1.7,471,62,"Embarcações",0.5 }
		Blips[#Blips+1] = { -1622.55,-1167.98,1.45,471,62,"Embarcações",0.5 }
	
	
		Blips[#Blips+1] = { 591.17,2743.5,42.04,51,4,"Farmácia Clandestina",0.8 }
		Blips[#Blips+1] = { 45.95,3703.11,39.75,556,5,"Mercado Negro e Lavagem de Dinheiro",1.0 }
			-- { -1198.15,-1458.38,4.36,51,15,"Farmácia",0.5 }
			-- { -1255.49,-1436.33,4.36,51,15,"Farmácia",0.5 }
	
			
		Blips[#Blips+1] = { 1322.93,-1652.29,52.27,75,36,"Loja de Tatuagem",0.5 }
		Blips[#Blips+1] = { -1154.42,-1425.9,4.95,75,36,"Loja de Tatuagem",0.5 }
		Blips[#Blips+1] = { 322.84,180.16,103.58,75,36,"Loja de Tatuagem",0.5 }
		Blips[#Blips+1] = { -3169.62,1075.8,20.83,75,36,"Loja de Tatuagem",0.5 }
		Blips[#Blips+1] = { 1864.07,3747.9,33.03,75,36,"Loja de Tatuagem",0.5 }
		Blips[#Blips+1] = { -293.57,6199.85,31.48,75,36,"Loja de Tatuagem",0.5 }
	
	
		Blips[#Blips+1] = { 5323.13,-5238.68,32.76 ,539,36,"Cayo Perico",0.5 }
		Blips[#Blips+1] = { 5157.12,-5104.11,2.36 ,539,36,"Cayo Perico",0.5 }
		Blips[#Blips+1] = { 4930.78,-5146.1,2.48 ,539,36,"Cayo Perico",0.5 }
		Blips[#Blips+1] = { 4973.78,-5856.06,19.82 ,539,36,"Cayo Perico",0.5 }
		Blips[#Blips+1] = { 4936.15,-4900.87,3.62 ,539,36,"Cayo Perico",0.5 }
		Blips[#Blips+1] = { 4455.61,-4521.53,4.11 ,539,36,"Cayo Perico",0.5 }
			-- { -61.89,-1218.25,28.7 ,51,62,"Entregas de Drogas",0.6 }
			-- { 218.09,-1391.38,30.58 ,51,62,"Entregas de Droga",0.6 }
			-- { -1695.32,-287.06,51.88 ,51,62,"Entregas de Droga",0.6 }
		
		-- Blips[#Blips+1] = { 404.42,-1954.53,0.0,432,1,"Área de Risco | Pistola",1.0 }				--- VAGOS
		-- Blips[#Blips+1] = { -1287.0,2525.61,19.78,432,1,"Área de Risco | Fuzil e Pistola",1.0 }		--- PROX BOPE
		Blips[#Blips+1] = { 541.79,-167.59,54.56,488,5,"Mecânica",0.8 }
		Blips[#Blips+1] = { -849.75,-1203.48,58.22,487,5,"Esquadra da Policia 4",1.0 } 
		Blips[#Blips+1] = { 444.59,-990.71,43.60,487,5,"Esquadra da Policia",1.0 } -- dp praça
		Blips[#Blips+1] = { -441.15,6031.78,32.61,487,5,"Esquadra da Policia",1.0 } 
		Blips[#Blips+1] = { 2564.57,-398.03,96.14,487,5,"Esquadra da Policia",1.0 } 
		-- Blips[#Blips+1] = { -831.85,-1215.67,6.94,487,5,"Departamento Policial",1.0 } -- Tatica
		-- Blips[#Blips+1] = { 2613.75,5280.4,70.6,487,5,"Prf",1.0 } -- prf
		Blips[#Blips+1] = { 120.69,-1317.15,28.93,436,5,"Vanilla +18",0.8 }
		-- Blips[#Blips+1] = { -1630.07,215.08,60.73,492,5,"Escolinha Nobre",1.0 } -- Escolinha
		Blips[#Blips+1] = { -518.0,-251.84,140.83,385,5,"Tribunal",1.0 }
		-- Blips[#Blips+1] = { -3188.88,-1145.31,7.82,436,5,"Ilha da Revoada",0.8 }
		Blips[#Blips+1] = { 3050.88,-4706.21,15.27,575,47,"Porta-Aviões",1.0 }
		-- Blips[#Blips+1] = { -258.34,-2024.09,86.61,785,47,"Nobre Arena",1.0 }

elseif cityName == "Kingdom" then
	Blips[#Blips+1] = { 55.43,-876.19,30.66,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 598.04,2741.27,42.07,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -136.36,6357.03,31.49,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 275.23,-345.54,45.17,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 596.40,90.65,93.12,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -340.76,265.97,85.67,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -2030.01,-465.97,11.60,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -1184.92,-1510.00,4.64,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 214.02,-808.44,31.01,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -348.88,-874.02,31.31,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 67.74,12.27,69.21,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 361.90,297.81,103.88,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 1035.89,-763.89,57.99,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -796.63,-2022.77,9.16,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 453.27,-1146.76,29.52,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 528.66,-146.3,58.38,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -1159.48,-739.32,19.89,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 101.22,-1073.68,29.38,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 1725.21,4711.77,42.11,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 1624.05,3566.14,35.15,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -73.35,-2004.6,18.27,539,4,"Garages",0.4 }
	
	-- ILHAS
	
	-- { 5053.84,-4624.94,2.76 ,384,47,"Ilha Cayo Perico",1.0 }
	
	-- PONTOS CENTRAIS
	Blips[#Blips+1] = { 178.54,-982.15,29.64,266,5,"Central Square",1.0 }	
	Blips[#Blips+1] = { 1428.78,6490.94,20.34,266,5,"North Pier",0.8 }		

	Blips[#Blips+1] = { 1046.64,2300.27,44.82,108,5,"Processing",0.7 }
	Blips[#Blips+1] = { 134.06,-3088.0,8.21,108,5,"Processing",0.7 }
	Blips[#Blips+1] = { 118.66,-1087.29,29.22,587,2,"Personal Chest",0.5 }			
	Blips[#Blips+1] = { 1420.9,6564.6,18.53,587,2,"Personal Chest",0.5 }		
	Blips[#Blips+1] = { 1860.07,2608.29,45.66,188,1,"Prison",1.5 }

	Blips[#Blips+1] = { -534.23,-222.15,37.64,385,5,"DOJ",1.0 } -- juridico
	Blips[#Blips+1] = { 2567.58,-358.4,92.99,487,5,"Police Station",1.0 }
	Blips[#Blips+1] = { -310.49,-610.89,32.77,80,5,"Hospital",0.5 } -- hp principal
	Blips[#Blips+1] = { -70.49,-1104.59,26.12,225,5,"Dealership",0.8 }
	Blips[#Blips+1] = { 229.77,214.17,105.55,431,5,"Central Bank",0.8 }
	Blips[#Blips+1] = { -852.02,-1197.13,63.91,487,5,"Police Department",1.0 } -- tatica
	
	Blips[#Blips+1] = { -2329.46,3266.47,32.82,487,5,"Zancudo",1.0 }
	Blips[#Blips+1] = { 501.59,5604.47,797.91,164,5,"Mount Chiliad",1.0 }
	Blips[#Blips+1] = { -1627.64,-3099.74,13.93,184,5,"Photography studio",0.8 }	
	Blips[#Blips+1] = { -1256.65,-3356.17,13.93,184,5,"Photography studio",0.8 }
	
	-- { 2380.24,5094.35,47.35,285,3,"Emprego | Lenhador",0.5 }
	Blips[#Blips+1] = { 2515.56,4763.37,34.76,108,3,"Legitimate job",0.7 }
	Blips[#Blips+1] = { 2953.93,2787.49,41.5,108,3,"Legitimate job",0.7 }
	Blips[#Blips+1] = { 1418.79,6715.32,14.37,108,3,"Legitimate job",0.7 }
	Blips[#Blips+1] = { 453.82,-600.6,28.58,108,3,"Legitimate job",0.7 }
	Blips[#Blips+1] = { 751.71,6459.04,31.53,108,3,"Legitimate job",0.7 }
	Blips[#Blips+1] = { 2093.65,5044.13,41.18,108,3,"Legitimate job",0.7 }
	Blips[#Blips+1] = { -19.92,6304.38,31.37,108,3,"Legitimate job",0.7 }
	Blips[#Blips+1] = { -406.04,6148.4,31.68,108,3,"Legitimate job",0.7 }
	Blips[#Blips+1] = { -1471.72,-920.16,10.03,108,3,"Legitimate job",0.7 }

	Blips[#Blips+1] = { -428.56,-1728.33,19.79,365,3,"Store | Recycling",0.8 }
	Blips[#Blips+1] = { 29.2,-1351.89,29.34,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 2561.74,385.22,108.61,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 1160.21,-329.4,69.03,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { -711.99,-919.96,19.01,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { -54.56,-1758.56,29.05,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 375.87,320.04,103.42,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { -3237.48,1004.72,12.45,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 1730.64,6409.67,35.0,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 543.51,2676.85,42.14,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 1966.53,3737.95,32.18,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 2684.73,3281.2,55.23,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 1696.12,4931.56,42.07,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { -1820.18,785.69,137.98,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 1395.35,3596.6,34.86,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { -2977.14,391.22,15.03,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { -3034.99,590.77,7.8,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 1144.46,-980.74,46.19,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 1166.06,2698.17,37.95,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { -1493.12,-385.55,39.87,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { -1228.6,-899.7,12.27,52,4,"Department store",0.5 }

	Blips[#Blips+1] = { 1702.78,3748.82,34.05,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { 240.06,-43.74,69.71,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { 843.95,-1020.43,27.53,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { -322.19,6072.86,31.27,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { -664.03,-949.22,21.53,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { -1318.83,-389.19,36.43,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { -1110.11,2687.5,18.62,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { 2569.23,309.46,108.46,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { -3159.91,1080.64,20.69,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { 15.42,-1120.47,28.81,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { 811.81,-2145.58,29.34,76,4,"Ammunation",0.5 }


	Blips[#Blips+1] = { -815.12,-184.15,37.57,71,4,"Barbershop",0.5 }
	Blips[#Blips+1] = { 138.13,-1706.46,29.3,71,4,"Barbershop",0.5 }
	Blips[#Blips+1] = { -1280.92,-1117.07,7.0,71,4,"Barbershop",0.5 }
	Blips[#Blips+1] = { 1930.54,3732.06,32.85,71,4,"Barbershop",0.5 }
	Blips[#Blips+1] = { 1214.2,-473.18,66.21,71,4,"Barbershop",0.5 }
	Blips[#Blips+1] = { -33.61,-154.52,57.08,71,4,"Barbershop",0.5 }
	Blips[#Blips+1] = { -276.65,6226.76,31.7,71,4,"Barbershop",0.5 }


	-- { -1117.26,-1438.74,5.11,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { 86.06,-1391.64,29.23,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { -719.94,-158.18,37.0,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { -152.79,-306.79,38.67,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { -816.39,-1081.22,11.12,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { -1206.51,-781.5,17.12,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { -1458.26,-229.79,49.2,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { -2.41,6518.29,31.48,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { 1682.59,4819.98,42.04,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { 129.46,-205.18,54.51,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { 618.49,2745.54,42.01,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { 1197.93,2698.21,37.96,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { -3165.74,1061.29,20.84,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { -1093.76,2703.99,19.04,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { 414.86,-807.57,29.34,366,4,"Clothes Shop",0.5 }
	
	
	-- { -1728.06,-1050.69,1.71,471,62,"Embarcações",0.5 }
	Blips[#Blips+1] = { 1966.36,3975.86,31.51,471,62,"Boats / Vessels",0.5 }
	Blips[#Blips+1] = { -776.72,-1495.02,2.29,471,62,"Boats / Vessels",0.5 }
	Blips[#Blips+1] = { -893.97,5687.78,3.29,471,62,"Boats / Vessels",0.5 }
	Blips[#Blips+1] = { 4952.76,-5163.6,-0.3,471,62,"Boats / Vessels",0.5 }
	Blips[#Blips+1] = { -1728.15,-1050.64,1.7,471,62,"Boats / Vessels",0.5 }
	Blips[#Blips+1] = { -1622.55,-1167.98,1.45,471,62,"Boats / Vessels",0.5 }


	Blips[#Blips+1] = { 591.17,2743.5,42.04,51,4,"Illegal Pharmacy",0.8 }
	Blips[#Blips+1] = { 45.95,3703.11,39.75,556,5,"Black Market and Money Laundering",1.0 }


	
	Blips[#Blips+1] = { 1322.93,-1652.29,52.27,75,36,"Tattooshop",0.5 }
	Blips[#Blips+1] = { -1154.42,-1425.9,4.95,75,36,"Tattooshop",0.5 }
	Blips[#Blips+1] = { 322.84,180.16,103.58,75,36,"Tattooshop",0.5 }
	Blips[#Blips+1] = { -3169.62,1075.8,20.83,75,36,"Tattooshop",0.5 }
	Blips[#Blips+1] = { 1864.07,3747.9,33.03,75,36,"Tattooshop",0.5 }
	Blips[#Blips+1] = { -293.57,6199.85,31.48,75,36,"Tattooshop",0.5 }


	Blips[#Blips+1] = { 541.79,-167.59,54.56,488,5,"Mechanic",0.8 }
	Blips[#Blips+1] = { 120.69,-1317.15,28.93,436,5,"Vanilla +18",0.8 }

	Blips[#Blips+1] = { 3050.88,-4706.21,15.27,575,47,"Aircraft Carrier",1.0 }
	Blips[#Blips+1] = { 1506.39,-2836.1,48.12,181,47,"Bridge | Cayo Perico",0.8 }
	Blips[#Blips+1] = { 110.13,-1724.37,30.11,513,85,"Train Station",0.8 }

elseif cityName == "Imperium" then
	Blips[#Blips+1] = { 55.43,-876.19,30.66,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 598.04,2741.27,42.07,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -136.36,6357.03,31.49,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 275.23,-345.54,45.17,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 596.40,90.65,93.12,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -340.76,265.97,85.67,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -2030.01,-465.97,11.60,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -1184.92,-1510.00,4.64,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 214.02,-808.44,31.01,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -348.88,-874.02,31.31,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 67.74,12.27,69.21,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 361.90,297.81,103.88,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 1035.89,-763.89,57.99,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -796.63,-2022.77,9.16,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 453.27,-1146.76,29.52,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 528.66,-146.3,58.38,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -1159.48,-739.32,19.89,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 101.22,-1073.68,29.38,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 1725.21,4711.77,42.11,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 1624.05,3566.14,35.15,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -73.35,-2004.6,18.27,539,4,"Garages",0.4 }
	
	-- ILHAS
	
	-- { 5053.84,-4624.94,2.76 ,384,47,"Ilha Cayo Perico",1.0 }
	
	-- PONTOS CENTRAIS
	Blips[#Blips+1] = { 178.54,-982.15,29.64,266,5,"Central Square",1.0 }	
	Blips[#Blips+1] = { 1428.78,6490.94,20.34,266,5,"North Pier",0.8 }		

	Blips[#Blips+1] = { 1046.64,2300.27,44.82,108,5,"Processing",0.7 }
	Blips[#Blips+1] = { 134.06,-3088.0,8.21,108,5,"Processing",0.7 }
	Blips[#Blips+1] = { 118.66,-1087.29,29.22,587,2,"Personal Chest",0.5 }			
	Blips[#Blips+1] = { 1420.9,6564.6,18.53,587,2,"Personal Chest",0.5 }		
	Blips[#Blips+1] = { 1860.07,2608.29,45.66,188,1,"Prison",1.5 }

	Blips[#Blips+1] = { -534.23,-222.15,37.64,385,5,"DOJ",1.0 } -- juridico
	Blips[#Blips+1] = { 2567.58,-358.4,92.99,487,5,"Police Station",1.0 }
	Blips[#Blips+1] = { 1152.97,-1526.05,34.85,80,5,"Hospital",0.5 } -- hp principal
	Blips[#Blips+1] = { -70.49,-1104.59,26.12,225,5,"Dealership",0.8 }
	Blips[#Blips+1] = { 229.77,214.17,105.55,431,5,"Central Bank",0.8 }
	
	Blips[#Blips+1] = { -2329.46,3266.47,32.82,487,5,"Zancudo",1.0 }
	Blips[#Blips+1] = { 501.59,5604.47,797.91,164,5,"Mount Chiliad",1.0 }
	Blips[#Blips+1] = { -1627.64,-3099.74,13.93,184,5,"Photography studio",0.8 }	
	Blips[#Blips+1] = { -1256.65,-3356.17,13.93,184,5,"Photography studio",0.8 }
	
	-- { 2380.24,5094.35,47.35,285,3,"Emprego | Lenhador",0.5 }
	Blips[#Blips+1] = { 2515.56,4763.37,34.76,108,3,"Legitimate job",0.7 }
	Blips[#Blips+1] = { 2953.93,2787.49,41.5,108,3,"Legitimate job",0.7 }
	Blips[#Blips+1] = { 1418.79,6715.32,14.37,108,3,"Legitimate job",0.7 }
	Blips[#Blips+1] = { 453.82,-600.6,28.58,108,3,"Legitimate job",0.7 }
	Blips[#Blips+1] = { 751.71,6459.04,31.53,108,3,"Legitimate job",0.7 }
	Blips[#Blips+1] = { 2093.65,5044.13,41.18,108,3,"Legitimate job",0.7 }
	Blips[#Blips+1] = { -19.92,6304.38,31.37,108,3,"Legitimate job",0.7 }
	Blips[#Blips+1] = { -406.04,6148.4,31.68,108,3,"Legitimate job",0.7 }
	Blips[#Blips+1] = { -1471.72,-920.16,10.03,108,3,"Legitimate job",0.7 }

	Blips[#Blips+1] = { -428.56,-1728.33,19.79,365,3,"Store | Recycling",0.8 }
	Blips[#Blips+1] = { 29.2,-1351.89,29.34,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 2561.74,385.22,108.61,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 1160.21,-329.4,69.03,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { -711.99,-919.96,19.01,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { -54.56,-1758.56,29.05,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 375.87,320.04,103.42,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { -3237.48,1004.72,12.45,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 1730.64,6409.67,35.0,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 543.51,2676.85,42.14,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 1966.53,3737.95,32.18,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 2684.73,3281.2,55.23,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 1696.12,4931.56,42.07,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { -1820.18,785.69,137.98,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 1395.35,3596.6,34.86,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { -2977.14,391.22,15.03,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { -3034.99,590.77,7.8,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 1144.46,-980.74,46.19,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 1166.06,2698.17,37.95,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { -1493.12,-385.55,39.87,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { -1228.6,-899.7,12.27,52,4,"Department store",0.5 }

	Blips[#Blips+1] = { 1702.78,3748.82,34.05,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { 240.06,-43.74,69.71,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { 843.95,-1020.43,27.53,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { -322.19,6072.86,31.27,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { -664.03,-949.22,21.53,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { -1318.83,-389.19,36.43,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { -1110.11,2687.5,18.62,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { 2569.23,309.46,108.46,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { -3159.91,1080.64,20.69,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { 15.42,-1120.47,28.81,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { 811.81,-2145.58,29.34,76,4,"Ammunation",0.5 }


	Blips[#Blips+1] = { -815.12,-184.15,37.57,71,4,"Barbershop",0.5 }
	Blips[#Blips+1] = { 138.13,-1706.46,29.3,71,4,"Barbershop",0.5 }
	Blips[#Blips+1] = { -1280.92,-1117.07,7.0,71,4,"Barbershop",0.5 }
	Blips[#Blips+1] = { 1930.54,3732.06,32.85,71,4,"Barbershop",0.5 }
	Blips[#Blips+1] = { 1214.2,-473.18,66.21,71,4,"Barbershop",0.5 }
	Blips[#Blips+1] = { -33.61,-154.52,57.08,71,4,"Barbershop",0.5 }
	Blips[#Blips+1] = { -276.65,6226.76,31.7,71,4,"Barbershop",0.5 }


	-- { -1117.26,-1438.74,5.11,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { 86.06,-1391.64,29.23,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { -719.94,-158.18,37.0,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { -152.79,-306.79,38.67,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { -816.39,-1081.22,11.12,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { -1206.51,-781.5,17.12,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { -1458.26,-229.79,49.2,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { -2.41,6518.29,31.48,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { 1682.59,4819.98,42.04,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { 129.46,-205.18,54.51,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { 618.49,2745.54,42.01,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { 1197.93,2698.21,37.96,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { -3165.74,1061.29,20.84,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { -1093.76,2703.99,19.04,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { 414.86,-807.57,29.34,366,4,"Clothes Shop",0.5 }
	
	
	-- { -1728.06,-1050.69,1.71,471,62,"Embarcações",0.5 }
	Blips[#Blips+1] = { 1966.36,3975.86,31.51,471,62,"Boats / Vessels",0.5 }
	Blips[#Blips+1] = { -776.72,-1495.02,2.29,471,62,"Boats / Vessels",0.5 }
	Blips[#Blips+1] = { -893.97,5687.78,3.29,471,62,"Boats / Vessels",0.5 }
	Blips[#Blips+1] = { 4952.76,-5163.6,-0.3,471,62,"Boats / Vessels",0.5 }
	Blips[#Blips+1] = { -1728.15,-1050.64,1.7,471,62,"Boats / Vessels",0.5 }
	Blips[#Blips+1] = { -1622.55,-1167.98,1.45,471,62,"Boats / Vessels",0.5 }


	Blips[#Blips+1] = { 591.17,2743.5,42.04,51,4,"Illegal Pharmacy",0.8 }
	Blips[#Blips+1] = { 45.95,3703.11,39.75,556,5,"Black Market and Money Laundering",1.0 }


	
	Blips[#Blips+1] = { 1322.93,-1652.29,52.27,75,36,"Tattooshop",0.5 }
	Blips[#Blips+1] = { -1154.42,-1425.9,4.95,75,36,"Tattooshop",0.5 }
	Blips[#Blips+1] = { 322.84,180.16,103.58,75,36,"Tattooshop",0.5 }
	Blips[#Blips+1] = { -3169.62,1075.8,20.83,75,36,"Tattooshop",0.5 }
	Blips[#Blips+1] = { 1864.07,3747.9,33.03,75,36,"Tattooshop",0.5 }
	Blips[#Blips+1] = { -293.57,6199.85,31.48,75,36,"Tattooshop",0.5 }


	Blips[#Blips+1] = { -1072.9,-2065.83,13.29,488,5,"Mechanic",0.8 }
	Blips[#Blips+1] = { 120.69,-1317.15,28.93,436,5,"Vanilla +18",0.8 }

	Blips[#Blips+1] = { 3050.88,-4706.21,15.27,575,47,"Aircraft Carrier",1.0 }
	Blips[#Blips+1] = { 1506.39,-2836.1,48.12,181,47,"Bridge | Cayo Perico",0.8 }

elseif cityName == "GoatRP" then
	Blips[#Blips+1] = { 55.43,-876.19,30.66,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 598.04,2741.27,42.07,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -136.36,6357.03,31.49,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 275.23,-345.54,45.17,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 596.40,90.65,93.12,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -340.76,265.97,85.67,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -2030.01,-465.97,11.60,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -1184.92,-1510.00,4.64,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 214.02,-808.44,31.01,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -348.88,-874.02,31.31,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 67.74,12.27,69.21,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 361.90,297.81,103.88,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 1035.89,-763.89,57.99,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -796.63,-2022.77,9.16,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 453.27,-1146.76,29.52,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 528.66,-146.3,58.38,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -1159.48,-739.32,19.89,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 101.22,-1073.68,29.38,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 1725.21,4711.77,42.11,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 1624.05,3566.14,35.15,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -73.35,-2004.6,18.27,539,4,"Garages",0.4 }
	
	-- PONTOS CENTRAIS
	Blips[#Blips+1] = { 178.54,-982.15,29.64,266,5,"Place Centrale",1.0 }	
	Blips[#Blips+1] = { 1428.78,6490.94,20.34,266,5,"Quai Nord",0.8 }		
	
	Blips[#Blips+1] = { 1046.64,2300.27,44.82,108,5,"Traitement",0.7 }
	Blips[#Blips+1] = { 134.06,-3088.0,8.21,108,5,"Traitement",0.7 }
	Blips[#Blips+1] = { 118.66,-1087.29,29.22,587,2,"Coffre Personnel",0.5 }			
	Blips[#Blips+1] = { 1420.9,6564.6,18.53,587,2,"Coffre Personnel",0.5 }		
	Blips[#Blips+1] = { 1860.07,2608.29,45.66,188,1,"Prison",1.5 }
	
	Blips[#Blips+1] = { -534.23,-222.15,37.64,385,5,"Tribunal",1.0 } -- juridico
	Blips[#Blips+1] = { 2567.58,-358.4,92.99,487,5,"Commissariat",1.0 }
	Blips[#Blips+1] = { 1152.97,-1526.05,34.85,80,5,"Hôpital",0.5 } -- hp principal
	Blips[#Blips+1] = { -70.49,-1104.59,26.12,225,5,"Concessionnaire",0.8 }
	Blips[#Blips+1] = { 229.77,214.17,105.55,431,5,"Banque Centrale",0.8 }
	
	Blips[#Blips+1] = { -2329.46,3266.47,32.82,487,5,"Zancudo",1.0 }
	Blips[#Blips+1] = { 501.59,5604.47,797.91,164,5,"Mont Chiliad",1.0 }
	Blips[#Blips+1] = { -1627.64,-3099.74,13.93,184,5,"Studio Photo",0.8 }	
	Blips[#Blips+1] = { -1256.65,-3356.17,13.93,184,5,"Studio Photo",0.8 }
	
	Blips[#Blips+1] = { 2515.56,4763.37,34.76,108,3,"Travail Légal",0.7 }
	Blips[#Blips+1] = { 2953.93,2787.49,41.5,108,3,"Travail Légal",0.7 }
	Blips[#Blips+1] = { 1418.79,6715.32,14.37,108,3,"Travail Légal",0.7 }
	Blips[#Blips+1] = { 453.82,-600.6,28.58,108,3,"Travail Légal",0.7 }
	Blips[#Blips+1] = { 751.71,6459.04,31.53,108,3,"Travail Légal",0.7 }
	Blips[#Blips+1] = { 2093.65,5044.13,41.18,108,3,"Travail Légal",0.7 }
	Blips[#Blips+1] = { -19.92,6304.38,31.37,108,3,"Travail Légal",0.7 }
	Blips[#Blips+1] = { -406.04,6148.4,31.68,108,3,"Travail Légal",0.7 }
	Blips[#Blips+1] = { -1471.72,-920.16,10.03,108,3,"Travail Légal",0.7 }

	Blips[#Blips+1] = { -428.56,-1728.33,19.79,365,3,"Magasin | Recyclage",0.8 }
	Blips[#Blips+1] = { 29.2,-1351.89,29.34,52,4,"Magasin Départemental",0.5 }
	Blips[#Blips+1] = { 2561.74,385.22,108.61,52,4,"Magasin Départemental",0.5 }
	Blips[#Blips+1] = { 1160.21,-329.4,69.03,52,4,"Magasin Départemental",0.5 }
	Blips[#Blips+1] = { -711.99,-919.96,19.01,52,4,"Magasin Départemental",0.5 }
	Blips[#Blips+1] = { -54.56,-1758.56,29.05,52,4,"Magasin Départemental",0.5 }
	Blips[#Blips+1] = { 375.87,320.04,103.42,52,4,"Magasin Départemental",0.5 }
	Blips[#Blips+1] = { -3237.48,1004.72,12.45,52,4,"Magasin Départemental",0.5 }
	Blips[#Blips+1] = { 1730.64,6409.67,35.0,52,4,"Magasin Départemental",0.5 }
	Blips[#Blips+1] = { 543.51,2676.85,42.14,52,4,"Magasin Départemental",0.5 }
	Blips[#Blips+1] = { 1966.53,3737.95,32.18,52,4,"Magasin Départemental",0.5 }
	Blips[#Blips+1] = { 2684.73,3281.2,55.23,52,4,"Magasin Départemental",0.5 }
	Blips[#Blips+1] = { 1696.12,4931.56,42.07,52,4,"Magasin Départemental",0.5 }
	Blips[#Blips+1] = { -1820.18,785.69,137.98,52,4,"Magasin Départemental",0.5 }
	Blips[#Blips+1] = { 1395.35,3596.6,34.86,52,4,"Magasin Départemental",0.5 }
	Blips[#Blips+1] = { -2977.14,391.22,15.03,52,4,"Magasin Départemental",0.5 }
	Blips[#Blips+1] = { -3034.99,590.77,7.8,52,4,"Magasin Départemental",0.5 }
	Blips[#Blips+1] = { 1144.46,-980.74,46.19,52,4,"Magasin Départemental",0.5 }
	Blips[#Blips+1] = { 1166.06,2698.17,37.95,52,4,"Magasin Départemental",0.5 }
	Blips[#Blips+1] = { -1493.12,-385.55,39.87,52,4,"Magasin Départemental",0.5 }
	Blips[#Blips+1] = { -1228.6,-899.7,12.27,52,4,"Magasin Départemental",0.5 }

	Blips[#Blips+1] = { 1702.78,3748.82,34.05,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { 240.06,-43.74,69.71,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { 843.95,-1020.43,27.53,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { -322.19,6072.86,31.27,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { -664.03,-949.22,21.53,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { -1318.83,-389.19,36.43,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { -1110.11,2687.5,18.62,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { 2569.23,309.46,108.46,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { -3159.91,1080.64,20.69,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { 15.42,-1120.47,28.81,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { 811.81,-2145.58,29.34,76,4,"Ammunation",0.5 }

	Blips[#Blips+1] = { -815.12,-184.15,37.57,71,4,"Salon de Coiffure",0.5 }
	Blips[#Blips+1] = { 138.13,-1706.46,29.3,71,4,"Salon de Coiffure",0.5 }
	Blips[#Blips+1] = { -1280.92,-1117.07,7.0,71,4,"Salon de Coiffure",0.5 }
	Blips[#Blips+1] = { 1930.54,3732.06,32.85,71,4,"Salon de Coiffure",0.5 }
	Blips[#Blips+1] = { 1214.2,-473.18,66.21,71,4,"Salon de Coiffure",0.5 }
	Blips[#Blips+1] = { -33.61,-154.52,57.08,71,4,"Salon de Coiffure",0.5 }
	Blips[#Blips+1] = { -276.65,6226.76,31.7,71,4,"Salon de Coiffure",0.5 }

	Blips[#Blips+1] = { 86.06,-1391.64,29.23,366,4,"Magasin de Vêtements",0.5 }
	Blips[#Blips+1] = { -719.94,-158.18,37.0,366,4,"Magasin de Vêtements",0.5 }
	Blips[#Blips+1] = { -152.79,-306.79,38.67,366,4,"Magasin de Vêtements",0.5 }
	Blips[#Blips+1] = { -816.39,-1081.22,11.12,366,4,"Magasin de Vêtements",0.5 }
	Blips[#Blips+1] = { -1206.51,-781.5,17.12,366,4,"Magasin de Vêtements",0.5 }
	Blips[#Blips+1] = { -1458.26,-229.79,49.2,366,4,"Magasin de Vêtements",0.5 }
	Blips[#Blips+1] = { -2.41,6518.29,31.48,366,4,"Magasin de Vêtements",0.5 }
	Blips[#Blips+1] = { 1682.59,4819.98,42.04,366,4,"Magasin de Vêtements",0.5 }
	Blips[#Blips+1] = { 129.46,-205.18,54.51,366,4,"Magasin de Vêtements",0.5 }
	Blips[#Blips+1] = { 618.49,2745.54,42.01,366,4,"Magasin de Vêtements",0.5 }
	Blips[#Blips+1] = { 1197.93,2698.21,37.96,366,4,"Magasin de Vêtements",0.5 }
	Blips[#Blips+1] = { -3165.74,1061.29,20.84,366,4,"Magasin de Vêtements",0.5 }
	Blips[#Blips+1] = { -1093.76,2703.99,19.04,366,4,"Magasin de Vêtements",0.5 }
	Blips[#Blips+1] = { 414.86,-807.57,29.34,366,4,"Magasin de Vêtements",0.5 }

	Blips[#Blips+1] = { 1966.36,3975.86,31.51,471,62,"Bateaux / Vaisseaux",0.5 }
	Blips[#Blips+1] = { -776.72,-1495.02,2.29,471,62,"Bateaux / Vaisseaux",0.5 }
	Blips[#Blips+1] = { -893.97,5687.78,3.29,471,62,"Bateaux / Vaisseaux",0.5 }
	Blips[#Blips+1] = { 4952.76,-5163.6,-0.3,471,62,"Bateaux / Vaisseaux",0.5 }
	Blips[#Blips+1] = { -1728.15,-1050.64,1.7,471,62,"Bateaux / Vaisseaux",0.5 }
	Blips[#Blips+1] = { -1622.55,-1167.98,1.45,471,62,"Bateaux / Vaisseaux",0.5 }
	
	Blips[#Blips+1] = { 591.17,2743.5,42.04,51,4,"Pharmacie Illégale",0.8 }
	Blips[#Blips+1] = { 45.95,3703.11,39.75,556,5,"Marché Noir et Blanchiment d'Argent",1.0 }
	
	Blips[#Blips+1] = { 1322.93,-1652.29,52.27,75,36,"Salon de Tatouage",0.5 }
	Blips[#Blips+1] = { -1154.42,-1425.9,4.95,75,36,"Salon de Tatouage",0.5 }
	Blips[#Blips+1] = { 322.84,180.16,103.58,75,36,"Salon de Tatouage",0.5 }
	Blips[#Blips+1] = { -3169.62,1075.8,20.83,75,36,"Salon de Tatouage",0.5 }
	Blips[#Blips+1] = { 1864.07,3747.9,33.03,75,36,"Salon de Tatouage",0.5 }
	Blips[#Blips+1] = { -293.57,6199.85,31.48,75,36,"Salon de Tatouage",0.5 }
	
	Blips[#Blips+1] = { -1072.9,-2065.83,13.29,488,5,"Mécanicien",0.8 }
	Blips[#Blips+1] = { 120.69,-1317.15,28.93,436,5,"Vanilla +18",0.8 }
	
	Blips[#Blips+1] = { 3050.88,-4706.21,15.27,575,47,"Porte-Avions",1.0 }
	Blips[#Blips+1] = { 1506.39,-2836.1,48.12,181,47,"Pont | Cayo Perico",0.8 }

elseif cityName == "District99" then
	Blips[#Blips+1] = { 55.43,-876.19,30.66,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 598.04,2741.27,42.07,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -136.36,6357.03,31.49,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 275.23,-345.54,45.17,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 596.40,90.65,93.12,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -340.76,265.97,85.67,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -2030.01,-465.97,11.60,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -1184.92,-1510.00,4.64,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 214.02,-808.44,31.01,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -348.88,-874.02,31.31,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 67.74,12.27,69.21,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 361.90,297.81,103.88,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 1035.89,-763.89,57.99,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -796.63,-2022.77,9.16,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 453.27,-1146.76,29.52,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 528.66,-146.3,58.38,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -1159.48,-739.32,19.89,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 101.22,-1073.68,29.38,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 1725.21,4711.77,42.11,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 1624.05,3566.14,35.15,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -73.35,-2004.6,18.27,539,4,"Garages",0.4 }
	
	-- ILHAS
	
	-- { 5053.84,-4624.94,2.76 ,384,47,"Ilha Cayo Perico",1.0 }
	
	-- PONTOS CENTRAIS
	Blips[#Blips+1] = { 178.54,-982.15,29.64,266,5,"Central Square",1.0 }	
	Blips[#Blips+1] = { 1428.78,6490.94,20.34,266,5,"North Pier",0.8 }		

	Blips[#Blips+1] = { 956.48,-2107.47,30.55,160,76,"Robbery Actions",0.8 }		
	Blips[#Blips+1] = { -72.59,6267.09,31.26,160,76,"Robbery Actions",0.8 }
	Blips[#Blips+1] = { -565.5,5325.67,73.6,160,76,"Robbery Actions",0.8 }
	Blips[#Blips+1] = { -634.07,-238.4,37.9,160,76,"Robbery Actions",0.8 }

	Blips[#Blips+1] = { 1046.64,2300.27,44.82,108,5,"Processing",0.7 }
	Blips[#Blips+1] = { 134.06,-3088.0,8.21,108,5,"Processing",0.7 }
	Blips[#Blips+1] = { 118.66,-1087.29,29.22,587,2,"Personal Chest",0.5 }			
	Blips[#Blips+1] = { 1420.9,6564.6,18.53,587,2,"Personal Chest",0.5 }		
	Blips[#Blips+1] = { 1860.07,2608.29,45.66,188,1,"Prison",1.5 }
	Blips[#Blips+1] = { -647.18,-112.7,58.72,88,1,"Firefighters",0.5 }

	Blips[#Blips+1] = { -534.23,-222.15,37.64,385,5,"DOJ",1.0 } -- juridico
	Blips[#Blips+1] = { 2567.58,-358.4,92.99,487,5,"Police Station",1.0 }
	Blips[#Blips+1] = { -719.85,-1261.58,43.1,487,5,"Police Station",1.0 }
	Blips[#Blips+1] = { 451.47,-988.14,43.69,487,5,"Police Station",1.0 } -- militar
	Blips[#Blips+1] = { 2613.75,5280.4,70.6,487,5,"Police Station",1.0 } -- prf
	Blips[#Blips+1] = { 1152.97,-1526.05,34.85,80,5,"Hospital",0.5 } -- hp principal
	Blips[#Blips+1] = { -70.49,-1104.59,26.12,225,5,"Dealership",0.8 }
	Blips[#Blips+1] = { 229.77,214.17,105.55,431,5,"Central Bank",0.8 }
	
	Blips[#Blips+1] = { -2329.46,3266.47,32.82,487,5,"Zancudo",1.0 }
	Blips[#Blips+1] = { 501.59,5604.47,797.91,164,5,"Mount Chiliad",1.0 }
	Blips[#Blips+1] = { -1627.64,-3099.74,13.93,184,5,"Photography studio",0.8 }	
	Blips[#Blips+1] = { -1256.65,-3356.17,13.93,184,5,"Photography studio",0.8 }
	
	-- { 2380.24,5094.35,47.35,285,3,"Emprego | Lenhador",0.5 }
	Blips[#Blips+1] = { 2515.56,4763.37,34.76,108,3,"Legitimate job",0.7 }
	Blips[#Blips+1] = { 2953.93,2787.49,41.5,108,3,"Legitimate job",0.7 }
	Blips[#Blips+1] = { 1418.79,6715.32,14.37,108,3,"Legitimate job",0.7 }
	Blips[#Blips+1] = { 453.82,-600.6,28.58,108,3,"Legitimate job",0.7 }
	Blips[#Blips+1] = { 751.71,6459.04,31.53,108,3,"Legitimate job",0.7 }
	Blips[#Blips+1] = { 2093.65,5044.13,41.18,108,3,"Legitimate job",0.7 }
	Blips[#Blips+1] = { -19.92,6304.38,31.37,108,3,"Legitimate job",0.7 }
	Blips[#Blips+1] = { -406.04,6148.4,31.68,108,3,"Legitimate job",0.7 }
	Blips[#Blips+1] = { -1471.72,-920.16,10.03,108,3,"Legitimate job",0.7 }

	Blips[#Blips+1] = { -428.56,-1728.33,19.79,365,3,"Store | Recycling",0.8 }
	Blips[#Blips+1] = { 29.2,-1351.89,29.34,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 2561.74,385.22,108.61,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 1160.21,-329.4,69.03,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { -711.99,-919.96,19.01,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { -54.56,-1758.56,29.05,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 375.87,320.04,103.42,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { -3237.48,1004.72,12.45,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 1730.64,6409.67,35.0,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 543.51,2676.85,42.14,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 1966.53,3737.95,32.18,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 2684.73,3281.2,55.23,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 1696.12,4931.56,42.07,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { -1820.18,785.69,137.98,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 1395.35,3596.6,34.86,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { -2977.14,391.22,15.03,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { -3034.99,590.77,7.8,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 1144.46,-980.74,46.19,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 1166.06,2698.17,37.95,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { -1493.12,-385.55,39.87,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { -1228.6,-899.7,12.27,52,4,"Department store",0.5 }

	Blips[#Blips+1] = { 1702.78,3748.82,34.05,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { 240.06,-43.74,69.71,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { 843.95,-1020.43,27.53,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { -322.19,6072.86,31.27,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { -664.03,-949.22,21.53,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { -1318.83,-389.19,36.43,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { -1110.11,2687.5,18.62,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { 2569.23,309.46,108.46,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { -3159.91,1080.64,20.69,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { 15.42,-1120.47,28.81,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { 811.81,-2145.58,29.34,76,4,"Ammunation",0.5 }


	Blips[#Blips+1] = { -815.12,-184.15,37.57,71,4,"Barbershop",0.5 }
	Blips[#Blips+1] = { 138.13,-1706.46,29.3,71,4,"Barbershop",0.5 }
	Blips[#Blips+1] = { -1280.92,-1117.07,7.0,71,4,"Barbershop",0.5 }
	Blips[#Blips+1] = { 1930.54,3732.06,32.85,71,4,"Barbershop",0.5 }
	Blips[#Blips+1] = { 1214.2,-473.18,66.21,71,4,"Barbershop",0.5 }
	Blips[#Blips+1] = { -33.61,-154.52,57.08,71,4,"Barbershop",0.5 }
	Blips[#Blips+1] = { -276.65,6226.76,31.7,71,4,"Barbershop",0.5 }


	-- { -1117.26,-1438.74,5.11,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { 86.06,-1391.64,29.23,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { -719.94,-158.18,37.0,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { -152.79,-306.79,38.67,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { -816.39,-1081.22,11.12,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { -1206.51,-781.5,17.12,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { -1458.26,-229.79,49.2,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { -2.41,6518.29,31.48,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { 1682.59,4819.98,42.04,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { 129.46,-205.18,54.51,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { 618.49,2745.54,42.01,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { 1197.93,2698.21,37.96,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { -3165.74,1061.29,20.84,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { -1093.76,2703.99,19.04,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { 414.86,-807.57,29.34,366,4,"Clothes Shop",0.5 }
	
	
	-- { -1728.06,-1050.69,1.71,471,62,"Embarcações",0.5 }
	Blips[#Blips+1] = { 1966.36,3975.86,31.51,471,62,"Boats / Vessels",0.5 }
	Blips[#Blips+1] = { -776.72,-1495.02,2.29,471,62,"Boats / Vessels",0.5 }
	Blips[#Blips+1] = { -893.97,5687.78,3.29,471,62,"Boats / Vessels",0.5 }
	Blips[#Blips+1] = { 4952.76,-5163.6,-0.3,471,62,"Boats / Vessels",0.5 }
	Blips[#Blips+1] = { -1728.15,-1050.64,1.7,471,62,"Boats / Vessels",0.5 }
	Blips[#Blips+1] = { -1622.55,-1167.98,1.45,471,62,"Boats / Vessels",0.5 }


	Blips[#Blips+1] = { 591.17,2743.5,42.04,51,4,"Illegal Pharmacy",0.8 }
	Blips[#Blips+1] = { 45.95,3703.11,39.75,556,5,"Black Market and Money Laundering",1.0 }


	
	Blips[#Blips+1] = { 1322.93,-1652.29,52.27,75,36,"Tattooshop",0.5 }
	Blips[#Blips+1] = { -1154.42,-1425.9,4.95,75,36,"Tattooshop",0.5 }
	Blips[#Blips+1] = { 322.84,180.16,103.58,75,36,"Tattooshop",0.5 }
	Blips[#Blips+1] = { -3169.62,1075.8,20.83,75,36,"Tattooshop",0.5 }
	Blips[#Blips+1] = { 1864.07,3747.9,33.03,75,36,"Tattooshop",0.5 }
	Blips[#Blips+1] = { -293.57,6199.85,31.48,75,36,"Tattooshop",0.5 }


	Blips[#Blips+1] = { -1072.9,-2065.83,13.29,488,5,"Mechanic",0.8 }
	Blips[#Blips+1] = { 120.69,-1317.15,28.93,436,5,"Vanilla +18",0.8 }

	Blips[#Blips+1] = { 3050.88,-4706.21,15.27,575,47,"Aircraft Carrier",1.0 }
	Blips[#Blips+1] = { 1506.39,-2836.1,48.12,181,47,"Bridge | Cayo Perico",0.8 }

elseif cityName == "Krown" then
	Blips[#Blips+1] = { 55.43,-876.19,30.66,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 598.04,2741.27,42.07,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -136.36,6357.03,31.49,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 275.23,-345.54,45.17,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 596.40,90.65,93.12,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -340.76,265.97,85.67,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -2030.01,-465.97,11.60,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -1184.92,-1510.00,4.64,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 214.02,-808.44,31.01,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -348.88,-874.02,31.31,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 67.74,12.27,69.21,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 361.90,297.81,103.88,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 1035.89,-763.89,57.99,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -796.63,-2022.77,9.16,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 453.27,-1146.76,29.52,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 528.66,-146.3,58.38,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -1159.48,-739.32,19.89,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 101.22,-1073.68,29.38,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 1725.21,4711.77,42.11,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 1624.05,3566.14,35.15,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -73.35,-2004.6,18.27,539,4,"Garages",0.4 }
	
	-- PONTOS CENTRAIS
	Blips[#Blips+1] = { 178.54,-982.15,29.64,266,5,"Central Square",1.0 }	
	Blips[#Blips+1] = { 1428.78,6490.94,20.34,266,5,"North Pier",0.8 }		
	Blips[#Blips+1] = { -1608.5,-1053.15,13.56,266,5,"South Pier",0.8 }		

	Blips[#Blips+1] = { 956.48,-2107.47,30.55,160,76,"Robbery Actions",0.8 }		
	Blips[#Blips+1] = { -72.59,6267.09,31.26,160,76,"Robbery Actions",0.8 }
	Blips[#Blips+1] = { -565.5,5325.67,73.6,160,76,"Robbery Actions",0.8 }
	Blips[#Blips+1] = { -634.07,-238.4,37.9,160,76,"Robbery Actions",0.8 }

	Blips[#Blips+1] = { 1046.64,2300.27,44.82,108,5,"Processing",0.7 }
	Blips[#Blips+1] = { 134.06,-3088.0,8.21,108,5,"Processing",0.7 }
	Blips[#Blips+1] = { 118.66,-1087.29,29.22,587,2,"Personal Chest",0.5 }			
	Blips[#Blips+1] = { 1420.9,6564.6,18.53,587,2,"Personal Chest",0.5 }		
	Blips[#Blips+1] = { 1860.07,2608.29,45.66,188,1,"Prison",1.5 }
	Blips[#Blips+1] = { -647.18,-112.7,58.72,88,1,"Firefighters",0.7 }

	Blips[#Blips+1] = { -534.23,-222.15,37.64,385,5,"DOJ",1.0 } -- juridico
	Blips[#Blips+1] = { 2567.58,-358.4,92.99,487,5,"Police Station",1.0 }
	Blips[#Blips+1] = { -719.85,-1261.58,43.1,487,5,"Police Station",1.0 }
	Blips[#Blips+1] = { -310.49,-610.89,32.77,80,5,"Hospital",0.5 } -- hp principal
	Blips[#Blips+1] = { -70.49,-1104.59,26.12,225,5,"Dealership",0.8 }
	Blips[#Blips+1] = { 229.77,214.17,105.55,431,5,"Central Bank",0.8 }
	
	Blips[#Blips+1] = { -2329.46,3266.47,32.82,487,5,"Zancudo",1.0 }
	Blips[#Blips+1] = { 501.59,5604.47,797.91,164,5,"Mount Chiliad",1.0 }
	Blips[#Blips+1] = { -1627.64,-3099.74,13.93,184,5,"Photography studio",0.8 }	
	Blips[#Blips+1] = { -1256.65,-3356.17,13.93,184,5,"Photography studio",0.8 }
	
	-- { 2380.24,5094.35,47.35,285,3,"Emprego | Lenhador",0.5 }
	Blips[#Blips+1] = { 2515.56,4763.37,34.76,108,3,"Legitimate job",0.7 }
	Blips[#Blips+1] = { 2953.93,2787.49,41.5,108,3,"Legitimate job",0.7 }
	Blips[#Blips+1] = { 1418.79,6715.32,14.37,108,3,"Legitimate job",0.7 }
	Blips[#Blips+1] = { 453.82,-600.6,28.58,108,3,"Legitimate job",0.7 }
	Blips[#Blips+1] = { 751.71,6459.04,31.53,108,3,"Legitimate job",0.7 }
	Blips[#Blips+1] = { 2093.65,5044.13,41.18,108,3,"Legitimate job",0.7 }
	Blips[#Blips+1] = { -19.92,6304.38,31.37,108,3,"Legitimate job",0.7 }
	Blips[#Blips+1] = { -406.04,6148.4,31.68,108,3,"Legitimate job",0.7 }
	Blips[#Blips+1] = { -1471.72,-920.16,10.03,108,3,"Legitimate job",0.7 }

	Blips[#Blips+1] = { -428.56,-1728.33,19.79,365,3,"Store | Recycling",0.8 }
	Blips[#Blips+1] = { 29.2,-1351.89,29.34,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 2561.74,385.22,108.61,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 1160.21,-329.4,69.03,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { -711.99,-919.96,19.01,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { -54.56,-1758.56,29.05,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 375.87,320.04,103.42,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { -3237.48,1004.72,12.45,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 1730.64,6409.67,35.0,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 543.51,2676.85,42.14,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 1966.53,3737.95,32.18,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 2684.73,3281.2,55.23,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 1696.12,4931.56,42.07,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { -1820.18,785.69,137.98,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 1395.35,3596.6,34.86,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { -2977.14,391.22,15.03,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { -3034.99,590.77,7.8,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 1144.46,-980.74,46.19,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 1166.06,2698.17,37.95,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { -1493.12,-385.55,39.87,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { -1228.6,-899.7,12.27,52,4,"Department store",0.5 }

	Blips[#Blips+1] = { 1702.78,3748.82,34.05,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { 240.06,-43.74,69.71,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { 843.95,-1020.43,27.53,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { -322.19,6072.86,31.27,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { -664.03,-949.22,21.53,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { -1318.83,-389.19,36.43,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { -1110.11,2687.5,18.62,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { 2569.23,309.46,108.46,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { -3159.91,1080.64,20.69,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { 15.42,-1120.47,28.81,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { 811.81,-2145.58,29.34,76,4,"Ammunation",0.5 }

	Blips[#Blips+1] = { -815.12,-184.15,37.57,71,4,"Barbershop",0.5 }
	Blips[#Blips+1] = { 138.13,-1706.46,29.3,71,4,"Barbershop",0.5 }
	Blips[#Blips+1] = { -1280.92,-1117.07,7.0,71,4,"Barbershop",0.5 }
	Blips[#Blips+1] = { 1930.54,3732.06,32.85,71,4,"Barbershop",0.5 }
	Blips[#Blips+1] = { 1214.2,-473.18,66.21,71,4,"Barbershop",0.5 }
	Blips[#Blips+1] = { -33.61,-154.52,57.08,71,4,"Barbershop",0.5 }
	Blips[#Blips+1] = { -276.65,6226.76,31.7,71,4,"Barbershop",0.5 }

	-- { -1117.26,-1438.74,5.11,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { 86.06,-1391.64,29.23,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { -719.94,-158.18,37.0,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { -152.79,-306.79,38.67,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { -816.39,-1081.22,11.12,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { -1206.51,-781.5,17.12,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { -1458.26,-229.79,49.2,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { -2.41,6518.29,31.48,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { 1682.59,4819.98,42.04,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { 129.46,-205.18,54.51,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { 618.49,2745.54,42.01,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { 1197.93,2698.21,37.96,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { -3165.74,1061.29,20.84,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { -1093.76,2703.99,19.04,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { 414.86,-807.57,29.34,366,4,"Clothes Shop",0.5 }
	
	-- { -1728.06,-1050.69,1.71,471,62,"Embarcações",0.5 }
	Blips[#Blips+1] = { 1966.36,3975.86,31.51,471,62,"Boats / Vessels",0.5 }
	Blips[#Blips+1] = { -776.72,-1495.02,2.29,471,62,"Boats / Vessels",0.5 }
	Blips[#Blips+1] = { -893.97,5687.78,3.29,471,62,"Boats / Vessels",0.5 }
	Blips[#Blips+1] = { 4952.76,-5163.6,-0.3,471,62,"Boats / Vessels",0.5 }
	Blips[#Blips+1] = { -1728.15,-1050.64,1.7,471,62,"Boats / Vessels",0.5 }
	Blips[#Blips+1] = { -1622.55,-1167.98,1.45,471,62,"Boats / Vessels",0.5 }


	Blips[#Blips+1] = { 591.17,2743.5,42.04,51,4,"Illegal Pharmacy",0.8 }
	Blips[#Blips+1] = { 45.95,3703.11,39.75,556,5,"Black Market and Money Laundering",1.0 }

	Blips[#Blips+1] = { 1322.93,-1652.29,52.27,75,36,"Tattooshop",0.5 }
	Blips[#Blips+1] = { -1154.42,-1425.9,4.95,75,36,"Tattooshop",0.5 }
	Blips[#Blips+1] = { 322.84,180.16,103.58,75,36,"Tattooshop",0.5 }
	Blips[#Blips+1] = { -3169.62,1075.8,20.83,75,36,"Tattooshop",0.5 }
	Blips[#Blips+1] = { 1864.07,3747.9,33.03,75,36,"Tattooshop",0.5 }
	Blips[#Blips+1] = { -293.57,6199.85,31.48,75,36,"Tattooshop",0.5 }

	Blips[#Blips+1] = { 541.79,-167.59,54.56,488,5,"Mechanic",0.8 }
	Blips[#Blips+1] = { 120.69,-1317.15,28.93,436,5,"Vanilla +18",0.8 }

	Blips[#Blips+1] = { 3050.88,-4706.21,15.27,575,47,"Aircraft Carrier",1.0 }
	Blips[#Blips+1] = { 1506.39,-2836.1,48.12,181,47,"Bridge | Cayo Perico",0.8 }
elseif cityName == "Orizon" then
	Blips[#Blips+1] = { 55.43,-876.19,30.66,539,4,"الكراجات",0.4 } -- Garagens
	Blips[#Blips+1] = { 598.04,2741.27,42.07,539,4,"الكراجات",0.4 } -- Garagens
	Blips[#Blips+1] = { -136.36,6357.03,31.49,539,4,"الكراجات",0.4 } -- Garagens
	Blips[#Blips+1] = { 275.23,-345.54,45.17,539,4,"الكراجات",0.4 } -- Garagens
	Blips[#Blips+1] = { 596.40,90.65,93.12,539,4,"الكراجات",0.4 } -- Garagens
	Blips[#Blips+1] = { -340.76,265.97,85.67,539,4,"الكراجات",0.4 } -- Garagens
	Blips[#Blips+1] = { -2030.01,-465.97,11.60,539,4,"الكراجات",0.4 } -- Garagens
	Blips[#Blips+1] = { -1184.92,-1510.00,4.64,539,4,"الكراجات",0.4 } -- Garagens
	Blips[#Blips+1] = { 214.02,-808.44,31.01,539,4,"الكراجات",0.4 } -- Garagens
	Blips[#Blips+1] = { -348.88,-874.02,31.31,539,4,"الكراجات",0.4 } -- Garagens
	Blips[#Blips+1] = { 67.74,12.27,69.21,539,4,"الكراجات",0.4 } -- Garagens
	Blips[#Blips+1] = { 361.90,297.81,103.88,539,4,"الكراجات",0.4 } -- Garagens
	Blips[#Blips+1] = { 1035.89,-763.89,57.99,539,4,"الكراجات",0.4 } -- Garagens
	Blips[#Blips+1] = { -796.63,-2022.77,9.16,539,4,"الكراجات",0.4 } -- Garagens
	Blips[#Blips+1] = { 453.27,-1146.76,29.52,539,4,"الكراجات",0.4 } -- Garagens
	Blips[#Blips+1] = { 528.66,-146.3,58.38,539,4,"الكراجات",0.4 } -- Garagens
	Blips[#Blips+1] = { -1159.48,-739.32,19.89,539,4,"الكراجات",0.4 } -- Garagens
	Blips[#Blips+1] = { 101.22,-1073.68,29.38,539,4,"الكراجات",0.4 } -- Garagens
	Blips[#Blips+1] = { 1725.21,4711.77,42.11,539,4,"الكراجات",0.4 } -- Garagens
	Blips[#Blips+1] = { 1624.05,3566.14,35.15,539,4,"الكراجات",0.4 } -- Garagens
	Blips[#Blips+1] = { -73.35,-2004.6,18.27,539,4,"الكراجات",0.4 } -- Garagens
	
	-- ILHAS
	
	-- { 5053.84,-4624.94,2.76 ,384,47,"الجزيرة Cayo Perico",1.0 } -- Ilha Cayo Perico
	
	-- PONTOS CENTRAIS
	Blips[#Blips+1] = { 178.54,-982.15,29.64,266,5,"الملكية",1.0 } -- Praça
	Blips[#Blips+1] = { 1428.78,6490.94,20.34,266,5,"الميناء الشمالي",0.8 } -- Pier Norte

	Blips[#Blips+1] = { 956.48,-2107.47,30.55,160,76,"منطقة السرقات",0.8 } -- Área de Roubos
	Blips[#Blips+1] = { -72.59,6267.09,31.26,160,76,"منطقة السرقات",0.8 } -- Área de Roubos
	Blips[#Blips+1] = { -565.5,5325.67,73.6,160,76,"منطقة السرقات",0.8 } -- Área de Roubos
	Blips[#Blips+1] = { -634.07,-238.4,37.9,160,76,"منطقة السرقات",0.8 } -- Área de Roubos

	Blips[#Blips+1] = { 1046.64,2300.27,44.82,108,5,"جاري المعالجة",0.7 } -- Farm
	Blips[#Blips+1] = { 134.06,-3088.0,8.21,108,5,"جاري المعالجة",0.7 } -- Farm
	Blips[#Blips+1] = { 118.66,-1087.29,29.22,587,2,"الصندوق الشخصي",0.5 } -- Baú pessoal
	Blips[#Blips+1] = { 1420.9,6564.6,18.53,587,2,"الصندوق الشخصي",0.5 } -- Baú pessoal
	Blips[#Blips+1] = { 1860.07,2608.29,45.66,188,1,"السجن",1.5 } -- Prisão
	Blips[#Blips+1] = { -647.18,-112.7,58.72,88,1,"الدفاع المدني",0.5 } -- Bombeiros

	Blips[#Blips+1] = { -534.23,-222.15,37.64,385,5,"محكمة العدل",1.0 } -- Tribunal de Justiça | jurídico
	Blips[#Blips+1] = { 2567.58,-358.4,92.99,487,5,"مركز الشرطة",1.0 } -- Departamento Policial
	-- Blips[#Blips+1] = { -719.85,-1261.58,43.1,487,5,"مركز الشرطة",1.0 } -- Departamento Policial
	-- Blips[#Blips+1] = { 451.47,-988.14,43.69,487,5,"مركز الشرطة",1.0 } -- Departamento Policial | militar
	Blips[#Blips+1] = { 1152.97,-1526.05,34.85,80,5,"المستشفى",0.5 } -- Hospital | hp principal
	Blips[#Blips+1] = { -70.49,-1104.59,26.12,225,5,"معرض السيارات",0.8 } -- Concessionária
	Blips[#Blips+1] = { 229.77,214.17,105.55,431,5,"البنك المركزي",0.8 } -- Banco Central
	
	Blips[#Blips+1] = { -2329.46,3266.47,32.82,487,5,"قاعدة الجيش",1.0 } -- Base do Exército
	Blips[#Blips+1] = { 501.59,5604.47,797.91,164,5,"جبل تشيلياد",1.0 } -- Monte Chiliad
	Blips[#Blips+1] = { -1627.64,-3099.74,13.93,184,5,"استوديو التصوير",0.8 } -- Estúdio de Fotografia
	Blips[#Blips+1] = { -1256.65,-3356.17,13.93,184,5,"استوديو التصوير",0.8 } -- Estúdio de Fotografia
	
	Blips[#Blips+1] = { 2515.56,4763.37,34.76,108,3,"وظيفة رسمية",0.7 } -- Emprego legal
	Blips[#Blips+1] = { 2953.93,2787.49,41.5,108,3,"وظيفة رسمية",0.7 } -- Emprego legal
	Blips[#Blips+1] = { 1418.79,6715.32,14.37,108,3,"وظيفة رسمية",0.7 } -- Emprego legal
	Blips[#Blips+1] = { 453.82,-600.6,28.58,108,3,"وظيفة رسمية",0.7 } -- Emprego legal
	Blips[#Blips+1] = { 751.71,6459.04,31.53,108,3,"وظيفة رسمية",0.7 } -- Emprego legal
	Blips[#Blips+1] = { 2093.65,5044.13,41.18,108,3,"وظيفة رسمية",0.7 } -- Emprego legal
	Blips[#Blips+1] = { -19.92,6304.38,31.37,108,3,"وظيفة رسمية",0.7 } -- Emprego legal
	Blips[#Blips+1] = { -406.04,6148.4,31.68,108,3,"وظيفة رسمية",0.7 } -- Emprego legal
	Blips[#Blips+1] = { -1471.72,-920.16,10.03,108,3,"وظيفة رسمية",0.7 } -- Emprego legal

	Blips[#Blips+1] = { -428.56,-1728.33,19.79,365,3,"متجر | إعادة التدوير",0.8 } -- Loja | Reciclagem
	Blips[#Blips+1] = { 29.2,-1351.89,29.34,52,4,"المتجر الشامل",0.5 } -- Loja de conveniência
	Blips[#Blips+1] = { 2561.74,385.22,108.61,52,4,"المتجر الشامل",0.5 } -- Loja de conveniência
	Blips[#Blips+1] = { 1160.21,-329.4,69.03,52,4,"المتجر الشامل",0.5 } -- Loja de conveniência
	Blips[#Blips+1] = { -711.99,-919.96,19.01,52,4,"المتجر الشامل",0.5 } -- Loja de conveniência
	Blips[#Blips+1] = { -54.56,-1758.56,29.05,52,4,"المتجر الشامل",0.5 } -- Loja de conveniência
	Blips[#Blips+1] = { 375.87,320.04,103.42,52,4,"المتجر الشامل",0.5 } -- Loja de conveniência
	Blips[#Blips+1] = { -3237.48,1004.72,12.45,52,4,"المتجر الشامل",0.5 } -- Loja de conveniência
	Blips[#Blips+1] = { 1730.64,6409.67,35.0,52,4,"المتجر الشامل",0.5 } -- Loja de conveniência
	Blips[#Blips+1] = { 543.51,2676.85,42.14,52,4,"المتجر الشامل",0.5 } -- Loja de conveniência
	Blips[#Blips+1] = { 1966.53,3737.95,32.18,52,4,"المتجر الشامل",0.5 } -- Loja de conveniência
	Blips[#Blips+1] = { 2684.73,3281.2,55.23,52,4,"المتجر الشامل",0.5 } -- Loja de conveniência
	Blips[#Blips+1] = { 1696.12,4931.56,42.07,52,4,"المتجر الشامل",0.5 } -- Loja de conveniência
	Blips[#Blips+1] = { -1820.18,785.69,137.98,52,4,"المتجر الشامل",0.5 } -- Loja de conveniência
	Blips[#Blips+1] = { 1395.35,3596.6,34.86,52,4,"المتجر الشامل",0.5 } -- Loja de conveniência
	Blips[#Blips+1] = { -2977.14,391.22,15.03,52,4,"المتجر الشامل",0.5 } -- Loja de conveniência
	Blips[#Blips+1] = { -3034.99,590.77,7.8,52,4,"المتجر الشامل",0.5 } -- Loja de conveniência
	Blips[#Blips+1] = { 1144.46,-980.74,46.19,52,4,"المتجر الشامل",0.5 } -- Loja de conveniência
	Blips[#Blips+1] = { 1166.06,2698.17,37.95,52,4,"المتجر الشامل",0.5 } -- Loja de conveniência
	Blips[#Blips+1] = { -1493.12,-385.55,39.87,52,4,"المتجر الشامل",0.5 } -- Loja de conveniência
	Blips[#Blips+1] = { -1228.6,-899.7,12.27,52,4,"المتجر الشامل",0.5 } -- Loja de conveniência

	Blips[#Blips+1] = { 1702.78,3748.82,34.05,76,4,"متجر الأسلحة",0.5 } -- Loja de armas
	Blips[#Blips+1] = { 240.06,-43.74,69.71,76,4,"متجر الأسلحة",0.5 } -- Loja de armas
	Blips[#Blips+1] = { 843.95,-1020.43,27.53,76,4,"متجر الأسلحة",0.5 } -- Loja de armas
	Blips[#Blips+1] = { -322.19,6072.86,31.27,76,4,"متجر الأسلحة",0.5 } -- Loja de armas
	Blips[#Blips+1] = { -664.03,-949.22,21.53,76,4,"متجر الأسلحة",0.5 } -- Loja de armas
	Blips[#Blips+1] = { -1318.83,-389.19,36.43,76,4,"متجر الأسلحة",0.5 } -- Loja de armas
	Blips[#Blips+1] = { -1110.11,2687.5,18.62,76,4,"متجر الأسلحة",0.5 } -- Loja de armas
	Blips[#Blips+1] = { 2569.23,309.46,108.46,76,4,"متجر الأسلحة",0.5 } -- Loja de armas
	Blips[#Blips+1] = { -3159.91,1080.64,20.69,76,4,"متجر الأسلحة",0.5 } -- Loja de armas
	Blips[#Blips+1] = { 15.42,-1120.47,28.81,76,4,"متجر الأسلحة",0.5 } -- Loja de armas
	Blips[#Blips+1] = { 811.81,-2145.58,29.34,76,4,"متجر الأسلحة",0.5 } -- Loja de armas

	Blips[#Blips+1] = { -815.12,-184.15,37.57,71,4,"صالون الحلاقة",0.5 } -- Barbearia
	Blips[#Blips+1] = { 138.13,-1706.46,29.3,71,4,"صالون الحلاقة",0.5 } -- Barbearia
	Blips[#Blips+1] = { -1280.92,-1117.07,7.0,71,4,"صالون الحلاقة",0.5 } -- Barbearia
	Blips[#Blips+1] = { 1930.54,3732.06,32.85,71,4,"صالون الحلاقة",0.5 } -- Barbearia
	Blips[#Blips+1] = { 1214.2,-473.18,66.21,71,4,"صالون الحلاقة",0.5 } -- Barbearia
	Blips[#Blips+1] = { -33.61,-154.52,57.08,71,4,"صالون الحلاقة",0.5 } -- Barbearia
	Blips[#Blips+1] = { -276.65,6226.76,31.7,71,4,"صالون الحلاقة",0.5 } -- Barbearia

	Blips[#Blips+1] = { 86.06,-1391.64,29.23,366,4,"متجر الملابس",0.5 } -- Loja de roupas
	Blips[#Blips+1] = { -719.94,-158.18,37.0,366,4,"متجر الملابس",0.5 } -- Loja de roupas
	Blips[#Blips+1] = { -152.79,-306.79,38.67,366,4,"متجر الملابس",0.5 } -- Loja de roupas
	Blips[#Blips+1] = { -816.39,-1081.22,11.12,366,4,"متجر الملابس",0.5 } -- Loja de roupas
	Blips[#Blips+1] = { -1206.51,-781.5,17.12,366,4,"متجر الملابس",0.5 } -- Loja de roupas
	Blips[#Blips+1] = { -1458.26,-229.79,49.2,366,4,"متجر الملابس",0.5 } -- Loja de roupas
	Blips[#Blips+1] = { -2.41,6518.29,31.48,366,4,"متجر الملابس",0.5 } -- Loja de roupas
	Blips[#Blips+1] = { 1682.59,4819.98,42.04,366,4,"متجر الملابس",0.5 } -- Loja de roupas
	Blips[#Blips+1] = { 129.46,-205.18,54.51,366,4,"متجر الملابس",0.5 } -- Loja de roupas
	Blips[#Blips+1] = { 618.49,2745.54,42.01,366,4,"متجر الملابس",0.5 } -- Loja de roupas
	Blips[#Blips+1] = { 1197.93,2698.21,37.96,366,4,"متجر الملابس",0.5 } -- Loja de roupas
	Blips[#Blips+1] = { -3165.74,1061.29,20.84,366,4,"متجر الملابس",0.5 } -- Loja de roupas
	Blips[#Blips+1] = { -1093.76,2703.99,19.04,366,4,"متجر الملابس",0.5 } -- Loja de roupas
	Blips[#Blips+1] = { 414.86,-807.57,29.34,366,4,"متجر الملابس",0.5 } -- Loja de roupas
	
	Blips[#Blips+1] = { 1966.36,3975.86,31.51,471,62,"القوارب / السفن",0.5 } -- Barcos / Embarcações
	Blips[#Blips+1] = { -776.72,-1495.02,2.29,471,62,"القوارب / السفن",0.5 } -- Barcos / Embarcações
	Blips[#Blips+1] = { -893.97,5687.78,3.29,471,62,"القوارب / السفن",0.5 } -- Barcos / Embarcações
	Blips[#Blips+1] = { 4952.76,-5163.6,-0.3,471,62,"القوارب / السفن",0.5 } -- Barcos / Embarcações
	Blips[#Blips+1] = { -1728.15,-1050.64,1.7,471,62,"القوارب / السفن",0.5 } -- Barcos / Embarcações
	Blips[#Blips+1] = { -1622.55,-1167.98,1.45,471,62,"القوارب / السفن",0.5 } -- Barcos / Embarcações

	Blips[#Blips+1] = { 591.17,2743.5,42.04,51,4,"صيدلية الممنوعات",0.8 } -- Farmácia ilegal
	Blips[#Blips+1] = { 45.95,3703.11,39.75,556,5,"السوق السوداء وغسيل الأموال",1.0 } -- Mercado negro e lavagem de dinheiro
	
	Blips[#Blips+1] = { 1322.93,-1652.29,52.27,75,36,"محل الوشوم",0.5 } -- Estúdio de tatuagem
	Blips[#Blips+1] = { -1154.42,-1425.9,4.95,75,36,"محل الوشوم",0.5 } -- Estúdio de tatuagem
	Blips[#Blips+1] = { 322.84,180.16,103.58,75,36,"محل الوشوم",0.5 } -- Estúdio de tatuagem
	Blips[#Blips+1] = { -3169.62,1075.8,20.83,75,36,"محل الوشوم",0.5 } -- Estúdio de tatuagem
	Blips[#Blips+1] = { 1864.07,3747.9,33.03,75,36,"محل الوشوم",0.5 } -- Estúdio de tatuagem
	Blips[#Blips+1] = { -293.57,6199.85,31.48,75,36,"محل الوشوم",0.5 } -- Estúdio de tatuagem

	Blips[#Blips+1] = { 541.79,-167.59,54.56,488,5,"الميكانيكي",0.8 } -- Mecânica
	Blips[#Blips+1] = { 120.69,-1317.15,28.93,436,5,"فانيلا +18",0.8 } -- Vanilla +18

	Blips[#Blips+1] = { 3050.88,-4706.21,15.27,575,47,"حاملة الطائرات",1.0 } -- Porta-aviões
	Blips[#Blips+1] = { 1506.39,-2836.1,48.12,181,47,"الجسر | كايو بريكو",0.8 } -- Ponte | Cayo Perico

elseif cityName == "Liberty99" then
	Blips[#Blips+1] = { 55.43,-876.19,30.66,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 598.04,2741.27,42.07,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -136.36,6357.03,31.49,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 275.23,-345.54,45.17,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 596.40,90.65,93.12,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -340.76,265.97,85.67,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -2030.01,-465.97,11.60,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -1184.92,-1510.00,4.64,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 214.02,-808.44,31.01,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -348.88,-874.02,31.31,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 67.74,12.27,69.21,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 361.90,297.81,103.88,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 1035.89,-763.89,57.99,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -796.63,-2022.77,9.16,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 453.27,-1146.76,29.52,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 528.66,-146.3,58.38,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -1159.48,-739.32,19.89,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 101.22,-1073.68,29.38,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 1725.21,4711.77,42.11,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 1624.05,3566.14,35.15,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -73.35,-2004.6,18.27,539,4,"Garages",0.4 }
	
	-- PONTOS CENTRAIS
	Blips[#Blips+1] = { 178.54,-982.15,29.64,266,5,"Central Square",1.0 }	
	Blips[#Blips+1] = { 1428.78,6490.94,20.34,266,5,"North Pier",0.8 }		
	Blips[#Blips+1] = { -1608.5,-1053.15,13.56,266,5,"South Pier",0.8 }		

	Blips[#Blips+1] = { 956.48,-2107.47,30.55,160,76,"Robbery Actions",0.8 }		
	Blips[#Blips+1] = { -72.59,6267.09,31.26,160,76,"Robbery Actions",0.8 }
	Blips[#Blips+1] = { -565.5,5325.67,73.6,160,76,"Robbery Actions",0.8 }
	Blips[#Blips+1] = { -634.07,-238.4,37.9,160,76,"Robbery Actions",0.8 }

	Blips[#Blips+1] = { 1046.64,2300.27,44.82,108,5,"Processing",0.7 }
	Blips[#Blips+1] = { 134.06,-3088.0,8.21,108,5,"Processing",0.7 }
	Blips[#Blips+1] = { 118.66,-1087.29,29.22,587,2,"Personal Chest",0.5 }			
	Blips[#Blips+1] = { 1420.9,6564.6,18.53,587,2,"Personal Chest",0.5 }		
	Blips[#Blips+1] = { 1860.07,2608.29,45.66,188,1,"Prison",1.5 }
	Blips[#Blips+1] = { -647.18,-112.7,58.72,88,1,"Firefighters",0.7 }

	Blips[#Blips+1] = { -534.23,-222.15,37.64,385,5,"DOJ",1.0 } -- juridico
	Blips[#Blips+1] = { 2567.58,-358.4,92.99,487,5,"Police Station",1.0 }
	Blips[#Blips+1] = { -719.85,-1261.58,43.1,487,5,"Police Station",1.0 }
	Blips[#Blips+1] = { -310.49,-610.89,32.77,80,5,"Hospital",0.5 } -- hp principal
	Blips[#Blips+1] = { -70.49,-1104.59,26.12,225,5,"Dealership",0.8 }
	Blips[#Blips+1] = { 229.77,214.17,105.55,431,5,"Central Bank",0.8 }
	
	Blips[#Blips+1] = { -2329.46,3266.47,32.82,487,5,"Zancudo",1.0 }
	Blips[#Blips+1] = { 501.59,5604.47,797.91,164,5,"Mount Chiliad",1.0 }
	Blips[#Blips+1] = { -1627.64,-3099.74,13.93,184,5,"Photography studio",0.8 }	
	Blips[#Blips+1] = { -1256.65,-3356.17,13.93,184,5,"Photography studio",0.8 }
	
	-- { 2380.24,5094.35,47.35,285,3,"Emprego | Lenhador",0.5 }
	Blips[#Blips+1] = { 2515.56,4763.37,34.76,108,3,"Legitimate job",0.7 }
	Blips[#Blips+1] = { 2953.93,2787.49,41.5,108,3,"Legitimate job",0.7 }
	Blips[#Blips+1] = { 1418.79,6715.32,14.37,108,3,"Legitimate job",0.7 }
	Blips[#Blips+1] = { 453.82,-600.6,28.58,108,3,"Legitimate job",0.7 }
	Blips[#Blips+1] = { 751.71,6459.04,31.53,108,3,"Legitimate job",0.7 }
	Blips[#Blips+1] = { 2093.65,5044.13,41.18,108,3,"Legitimate job",0.7 }
	Blips[#Blips+1] = { -19.92,6304.38,31.37,108,3,"Legitimate job",0.7 }
	Blips[#Blips+1] = { -406.04,6148.4,31.68,108,3,"Legitimate job",0.7 }
	Blips[#Blips+1] = { -1471.72,-920.16,10.03,108,3,"Legitimate job",0.7 }

	Blips[#Blips+1] = { -428.56,-1728.33,19.79,365,3,"Store | Recycling",0.8 }
	Blips[#Blips+1] = { 29.2,-1351.89,29.34,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 2561.74,385.22,108.61,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 1160.21,-329.4,69.03,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { -711.99,-919.96,19.01,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { -54.56,-1758.56,29.05,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 375.87,320.04,103.42,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { -3237.48,1004.72,12.45,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 1730.64,6409.67,35.0,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 543.51,2676.85,42.14,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 1966.53,3737.95,32.18,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 2684.73,3281.2,55.23,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 1696.12,4931.56,42.07,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { -1820.18,785.69,137.98,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 1395.35,3596.6,34.86,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { -2977.14,391.22,15.03,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { -3034.99,590.77,7.8,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 1144.46,-980.74,46.19,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 1166.06,2698.17,37.95,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { -1493.12,-385.55,39.87,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { -1228.6,-899.7,12.27,52,4,"Department store",0.5 }

	Blips[#Blips+1] = { 1702.78,3748.82,34.05,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { 240.06,-43.74,69.71,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { 843.95,-1020.43,27.53,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { -322.19,6072.86,31.27,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { -664.03,-949.22,21.53,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { -1318.83,-389.19,36.43,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { -1110.11,2687.5,18.62,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { 2569.23,309.46,108.46,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { -3159.91,1080.64,20.69,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { 15.42,-1120.47,28.81,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { 811.81,-2145.58,29.34,76,4,"Ammunation",0.5 }

	Blips[#Blips+1] = { -815.12,-184.15,37.57,71,4,"Barbershop",0.5 }
	Blips[#Blips+1] = { 138.13,-1706.46,29.3,71,4,"Barbershop",0.5 }
	Blips[#Blips+1] = { -1280.92,-1117.07,7.0,71,4,"Barbershop",0.5 }
	Blips[#Blips+1] = { 1930.54,3732.06,32.85,71,4,"Barbershop",0.5 }
	Blips[#Blips+1] = { 1214.2,-473.18,66.21,71,4,"Barbershop",0.5 }
	Blips[#Blips+1] = { -33.61,-154.52,57.08,71,4,"Barbershop",0.5 }
	Blips[#Blips+1] = { -276.65,6226.76,31.7,71,4,"Barbershop",0.5 }

	-- { -1117.26,-1438.74,5.11,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { 86.06,-1391.64,29.23,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { -719.94,-158.18,37.0,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { -152.79,-306.79,38.67,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { -816.39,-1081.22,11.12,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { -1206.51,-781.5,17.12,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { -1458.26,-229.79,49.2,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { -2.41,6518.29,31.48,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { 1682.59,4819.98,42.04,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { 129.46,-205.18,54.51,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { 618.49,2745.54,42.01,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { 1197.93,2698.21,37.96,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { -3165.74,1061.29,20.84,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { -1093.76,2703.99,19.04,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { 414.86,-807.57,29.34,366,4,"Clothes Shop",0.5 }
	
	-- { -1728.06,-1050.69,1.71,471,62,"Embarcações",0.5 }
	Blips[#Blips+1] = { 1966.36,3975.86,31.51,471,62,"Boats / Vessels",0.5 }
	Blips[#Blips+1] = { -776.72,-1495.02,2.29,471,62,"Boats / Vessels",0.5 }
	Blips[#Blips+1] = { -893.97,5687.78,3.29,471,62,"Boats / Vessels",0.5 }
	Blips[#Blips+1] = { 4952.76,-5163.6,-0.3,471,62,"Boats / Vessels",0.5 }
	Blips[#Blips+1] = { -1728.15,-1050.64,1.7,471,62,"Boats / Vessels",0.5 }
	Blips[#Blips+1] = { -1622.55,-1167.98,1.45,471,62,"Boats / Vessels",0.5 }


	Blips[#Blips+1] = { 591.17,2743.5,42.04,51,4,"Illegal Pharmacy",0.8 }
	Blips[#Blips+1] = { 45.95,3703.11,39.75,556,5,"Black Market and Money Laundering",1.0 }

	Blips[#Blips+1] = { 1322.93,-1652.29,52.27,75,36,"Tattooshop",0.5 }
	Blips[#Blips+1] = { -1154.42,-1425.9,4.95,75,36,"Tattooshop",0.5 }
	Blips[#Blips+1] = { 322.84,180.16,103.58,75,36,"Tattooshop",0.5 }
	Blips[#Blips+1] = { -3169.62,1075.8,20.83,75,36,"Tattooshop",0.5 }
	Blips[#Blips+1] = { 1864.07,3747.9,33.03,75,36,"Tattooshop",0.5 }
	Blips[#Blips+1] = { -293.57,6199.85,31.48,75,36,"Tattooshop",0.5 }

	Blips[#Blips+1] = { 541.79,-167.59,54.56,488,5,"Mechanic",0.8 }
	Blips[#Blips+1] = { 120.69,-1317.15,28.93,436,5,"Vanilla +18",0.8 }

	Blips[#Blips+1] = { 3050.88,-4706.21,15.27,575,47,"Aircraft Carrier",1.0 }
	Blips[#Blips+1] = { 1506.39,-2836.1,48.12,181,47,"Bridge | Cayo Perico",0.8 }

elseif cityName == "Royal" then
	Blips[#Blips+1] = { 55.43,-876.19,30.66,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 598.04,2741.27,42.07,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -136.36,6357.03,31.49,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 275.23,-345.54,45.17,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 596.40,90.65,93.12,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -340.76,265.97,85.67,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -2030.01,-465.97,11.60,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -1184.92,-1510.00,4.64,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 214.02,-808.44,31.01,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -348.88,-874.02,31.31,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 67.74,12.27,69.21,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 361.90,297.81,103.88,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 1035.89,-763.89,57.99,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -796.63,-2022.77,9.16,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 453.27,-1146.76,29.52,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 528.66,-146.3,58.38,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -1159.48,-739.32,19.89,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 101.22,-1073.68,29.38,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 1725.21,4711.77,42.11,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { 1624.05,3566.14,35.15,539,4,"Garages",0.4 }
	Blips[#Blips+1] = { -73.35,-2004.6,18.27,539,4,"Garages",0.4 }
	
	-- ILHAS
	
	-- { 5053.84,-4624.94,2.76 ,384,47,"Ilha Cayo Perico",1.0 }
	
	-- PONTOS CENTRAIS
	Blips[#Blips+1] = { 178.54,-982.15,29.64,266,5,"Central Square",1.0 }	
	Blips[#Blips+1] = { 1428.78,6490.94,20.34,266,5,"North Pier",0.8 }		

	Blips[#Blips+1] = { 1046.64,2300.27,44.82,108,5,"Processing",0.7 }
	Blips[#Blips+1] = { 134.06,-3088.0,8.21,108,5,"Processing",0.7 }
	Blips[#Blips+1] = { 118.66,-1087.29,29.22,587,2,"Personal Chest",0.5 }			
	Blips[#Blips+1] = { 1420.9,6564.6,18.53,587,2,"Personal Chest",0.5 }		
	Blips[#Blips+1] = { 1860.07,2608.29,45.66,188,1,"Prison",1.5 }

	Blips[#Blips+1] = { -534.23,-222.15,37.64,385,5,"SCR",1.0 } -- juridico
	Blips[#Blips+1] = { 2567.58,-358.4,92.99,487,5,"Police Station",1.0 }
	Blips[#Blips+1] = { -311.76,-609.63,32.76,80,5,"Hospital",0.5 } -- hp principal
	Blips[#Blips+1] = { -70.49,-1104.59,26.12,225,5,"Dealership",0.8 }
	Blips[#Blips+1] = { 229.77,214.17,105.55,431,5,"Central Bank",0.8 }
	Blips[#Blips+1] = { 541.79,-167.59,54.56,488,5,"Mechanic",0.8 }
	
	Blips[#Blips+1] = { -2329.46,3266.47,32.82,487,5,"Zancudo",1.0 }
	Blips[#Blips+1] = { 501.59,5604.47,797.91,164,5,"Mount Chiliad",1.0 }
	Blips[#Blips+1] = { -1627.64,-3099.74,13.93,184,5,"Photography studio",0.8 }	
	Blips[#Blips+1] = { -1256.65,-3356.17,13.93,184,5,"Photography studio",0.8 }
	
	-- { 2380.24,5094.35,47.35,285,3,"Emprego | Lenhador",0.5 }
	Blips[#Blips+1] = { 2515.56,4763.37,34.76,108,3,"Legitimate job",0.7 }
	Blips[#Blips+1] = { 2953.93,2787.49,41.5,108,3,"Legitimate job",0.7 }
	Blips[#Blips+1] = { 1418.79,6715.32,14.37,108,3,"Legitimate job",0.7 }
	Blips[#Blips+1] = { 453.82,-600.6,28.58,108,3,"Legitimate job",0.7 }
	Blips[#Blips+1] = { 751.71,6459.04,31.53,108,3,"Legitimate job",0.7 }
	Blips[#Blips+1] = { 2093.65,5044.13,41.18,108,3,"Legitimate job",0.7 }
	Blips[#Blips+1] = { -19.92,6304.38,31.37,108,3,"Legitimate job",0.7 }
	Blips[#Blips+1] = { -406.04,6148.4,31.68,108,3,"Legitimate job",0.7 }
	Blips[#Blips+1] = { -1471.72,-920.16,10.03,108,3,"Legitimate job",0.7 }

	Blips[#Blips+1] = { -428.56,-1728.33,19.79,365,3,"Store | Recycling",0.8 }
	Blips[#Blips+1] = { 29.2,-1351.89,29.34,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 2561.74,385.22,108.61,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 1160.21,-329.4,69.03,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { -711.99,-919.96,19.01,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { -54.56,-1758.56,29.05,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 375.87,320.04,103.42,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { -3237.48,1004.72,12.45,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 1730.64,6409.67,35.0,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 543.51,2676.85,42.14,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 1966.53,3737.95,32.18,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 2684.73,3281.2,55.23,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 1696.12,4931.56,42.07,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { -1820.18,785.69,137.98,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 1395.35,3596.6,34.86,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { -2977.14,391.22,15.03,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { -3034.99,590.77,7.8,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 1144.46,-980.74,46.19,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { 1166.06,2698.17,37.95,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { -1493.12,-385.55,39.87,52,4,"Department store",0.5 }
	Blips[#Blips+1] = { -1228.6,-899.7,12.27,52,4,"Department store",0.5 }

	Blips[#Blips+1] = { 1702.78,3748.82,34.05,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { 240.06,-43.74,69.71,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { 843.95,-1020.43,27.53,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { -322.19,6072.86,31.27,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { -664.03,-949.22,21.53,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { -1318.83,-389.19,36.43,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { -1110.11,2687.5,18.62,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { 2569.23,309.46,108.46,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { -3159.91,1080.64,20.69,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { 15.42,-1120.47,28.81,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { 811.81,-2145.58,29.34,76,4,"Ammunation",0.5 }


	Blips[#Blips+1] = { -815.12,-184.15,37.57,71,4,"Barbershop",0.5 }
	Blips[#Blips+1] = { 138.13,-1706.46,29.3,71,4,"Barbershop",0.5 }
	Blips[#Blips+1] = { -1280.92,-1117.07,7.0,71,4,"Barbershop",0.5 }
	Blips[#Blips+1] = { 1930.54,3732.06,32.85,71,4,"Barbershop",0.5 }
	Blips[#Blips+1] = { 1214.2,-473.18,66.21,71,4,"Barbershop",0.5 }
	Blips[#Blips+1] = { -33.61,-154.52,57.08,71,4,"Barbershop",0.5 }
	Blips[#Blips+1] = { -276.65,6226.76,31.7,71,4,"Barbershop",0.5 }


	-- { -1117.26,-1438.74,5.11,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { 86.06,-1391.64,29.23,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { -719.94,-158.18,37.0,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { -152.79,-306.79,38.67,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { -816.39,-1081.22,11.12,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { -1206.51,-781.5,17.12,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { -1458.26,-229.79,49.2,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { -2.41,6518.29,31.48,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { 1682.59,4819.98,42.04,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { 129.46,-205.18,54.51,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { 618.49,2745.54,42.01,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { 1197.93,2698.21,37.96,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { -3165.74,1061.29,20.84,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { -1093.76,2703.99,19.04,366,4,"Clothes Shop",0.5 }
	Blips[#Blips+1] = { 414.86,-807.57,29.34,366,4,"Clothes Shop",0.5 }
	
	
	-- { -1728.06,-1050.69,1.71,471,62,"Embarcações",0.5 }
	Blips[#Blips+1] = { 1966.36,3975.86,31.51,471,62,"Boats / Vessels",0.5 }
	Blips[#Blips+1] = { -776.72,-1495.02,2.29,471,62,"Boats / Vessels",0.5 }
	Blips[#Blips+1] = { -893.97,5687.78,3.29,471,62,"Boats / Vessels",0.5 }
	Blips[#Blips+1] = { 4952.76,-5163.6,-0.3,471,62,"Boats / Vessels",0.5 }
	Blips[#Blips+1] = { -1728.15,-1050.64,1.7,471,62,"Boats / Vessels",0.5 }
	Blips[#Blips+1] = { -1622.55,-1167.98,1.45,471,62,"Boats / Vessels",0.5 }


	Blips[#Blips+1] = { 591.17,2743.5,42.04,51,4,"Illegal Pharmacy",0.8 }
	Blips[#Blips+1] = { 45.95,3703.11,39.75,556,5,"Black Market and Money Laundering",1.0 }


	
	Blips[#Blips+1] = { 1322.93,-1652.29,52.27,75,36,"Tattooshop",0.5 }
	Blips[#Blips+1] = { -1154.42,-1425.9,4.95,75,36,"Tattooshop",0.5 }
	Blips[#Blips+1] = { 322.84,180.16,103.58,75,36,"Tattooshop",0.5 }
	Blips[#Blips+1] = { -3169.62,1075.8,20.83,75,36,"Tattooshop",0.5 }
	Blips[#Blips+1] = { 1864.07,3747.9,33.03,75,36,"Tattooshop",0.5 }
	Blips[#Blips+1] = { -293.57,6199.85,31.48,75,36,"Tattooshop",0.5 }

	Blips[#Blips+1] = { 120.69,-1317.15,28.93,436,5,"Vanilla +18",0.8 }

	Blips[#Blips+1] = { 3050.88,-4706.21,15.27,575,47,"Aircraft Carrier",1.0 }
	Blips[#Blips+1] = { 1506.39,-2836.1,48.12,181,47,"Bridge | Cayo Perico",0.8 }

elseif cityName == "Real" then
	Blips[#Blips+1] = { 55.43,-876.19,30.66,539,4,"Garajes",0.4 }
	Blips[#Blips+1] = { 598.04,2741.27,42.07,539,4,"Garajes",0.4 }
	Blips[#Blips+1] = { -136.36,6357.03,31.49,539,4,"Garajes",0.4 }
	Blips[#Blips+1] = { 275.23,-345.54,45.17,539,4,"Garajes",0.4 }
	Blips[#Blips+1] = { 596.40,90.65,93.12,539,4,"Garajes",0.4 }
	Blips[#Blips+1] = { -340.76,265.97,85.67,539,4,"Garajes",0.4 }
	Blips[#Blips+1] = { -2030.01,-465.97,11.60,539,4,"Garajes",0.4 }
	Blips[#Blips+1] = { -1184.92,-1510.00,4.64,539,4,"Garajes",0.4 }
	Blips[#Blips+1] = { 214.02,-808.44,31.01,539,4,"Garajes",0.4 }
	Blips[#Blips+1] = { -348.88,-874.02,31.31,539,4,"Garajes",0.4 }
	Blips[#Blips+1] = { 67.74,12.27,69.21,539,4,"Garajes",0.4 }
	Blips[#Blips+1] = { 361.90,297.81,103.88,539,4,"Garajes",0.4 }
	Blips[#Blips+1] = { 1035.89,-763.89,57.99,539,4,"Garajes",0.4 }
	Blips[#Blips+1] = { -796.63,-2022.77,9.16,539,4,"Garajes",0.4 }
	Blips[#Blips+1] = { 453.27,-1146.76,29.52,539,4,"Garajes",0.4 }
	Blips[#Blips+1] = { 528.66,-146.3,58.38,539,4,"Garajes",0.4 }
	Blips[#Blips+1] = { -1159.48,-739.32,19.89,539,4,"Garajes",0.4 }
	Blips[#Blips+1] = { 101.22,-1073.68,29.38,539,4,"Garajes",0.4 }
	Blips[#Blips+1] = { 1725.21,4711.77,42.11,539,4,"Garajes",0.4 }
	Blips[#Blips+1] = { 1624.05,3566.14,35.15,539,4,"Garajes",0.4 }
	Blips[#Blips+1] = { -73.35,-2004.6,18.27,539,4,"Garajes",0.4 }
	
	-- ILHAS
	
	-- { 5053.84,-4624.94,2.76 ,384,47,"Ilha Cayo Perico",1.0 }
	
	-- PONTOS CENTRAIS
	Blips[#Blips+1] = { 178.54,-982.15,29.64,266,5,"Plaza Central",1.0 }	
	Blips[#Blips+1] = { 1428.78,6490.94,20.34,266,5,"Muelle Norte",0.8 }		

	Blips[#Blips+1] = { 1046.64,2300.27,44.82,108,5,"Procesamiento",0.7 }
	Blips[#Blips+1] = { 134.06,-3088.0,8.21,108,5,"Procesamiento",0.7 }
	Blips[#Blips+1] = { 118.66,-1087.29,29.22,587,2,"Cofre Personal",0.5 }			
	Blips[#Blips+1] = { 1420.9,6564.6,18.53,587,2,"Cofre Personal",0.5 }		
	Blips[#Blips+1] = { 1860.07,2608.29,45.66,188,1,"Prisión",1.5 }

	Blips[#Blips+1] = { -534.23,-222.15,37.64,385,5,"Jurídico",1.0 } --
	Blips[#Blips+1] = { 2567.58,-358.4,92.99,487,5,"Departamento de Policía",1.0 }
	Blips[#Blips+1] = { -447.31,6007.91,48.83,487,5,"Departamento de Policía",1.0 }
	Blips[#Blips+1] = { -783.98,-1277.75,67.04,487,5,"Departamento de Policía",1.0 } -- tatica
	Blips[#Blips+1] = { -594.31,-104.76,66.04,106,1,"Bombeiros",0.7 }
	-- Blips[#Blips+1] = { -828.4,-1219.45,28.41,487,5,"Departamento de Policía",1.0 }
	-- Blips[#Blips+1] = { -435.42,6016.69,50.85,487,5,"Departamento de Policía",1.0 }
	Blips[#Blips+1] = { 1152.97,-1526.05,34.85,80,5,"Hospital",0.5 } -- hp principal
	Blips[#Blips+1] = { -70.49,-1104.59,26.12,225,5,"Concesionario",0.8 }
	Blips[#Blips+1] = { 229.77,214.17,105.55,431,5,"Banco Central",0.8 }
	
	Blips[#Blips+1] = { -2329.46,3266.47,32.82,487,5,"Zancudo",1.0 }
	Blips[#Blips+1] = { 501.59,5604.47,797.91,164,5,"Monte Chiliad",1.0 }
	Blips[#Blips+1] = { -1627.64,-3099.74,13.93,184,5,"Estudio de fotografía",0.8 }	
	Blips[#Blips+1] = { -1256.65,-3356.17,13.93,184,5,"Estudio de fotografía",0.8 }
	
	-- { 2380.24,5094.35,47.35,285,3,"Emprego | Lenhador",0.5 }
	Blips[#Blips+1] = { 2515.56,4763.37,34.76,108,3,"Trabajo legal",0.7 }
	Blips[#Blips+1] = { 2953.93,2787.49,41.5,108,3,"Trabajo legal",0.7 }
	Blips[#Blips+1] = { 1418.79,6715.32,14.37,108,3,"Trabajo legal",0.7 }
	Blips[#Blips+1] = { 453.82,-600.6,28.58,108,3,"Trabajo legal",0.7 }
	Blips[#Blips+1] = { 751.71,6459.04,31.53,108,3,"Trabajo legal",0.7 }
	Blips[#Blips+1] = { 2093.65,5044.13,41.18,108,3,"Trabajo legal",0.7 }
	Blips[#Blips+1] = { -19.92,6304.38,31.37,108,3,"Trabajo legal",0.7 }
	Blips[#Blips+1] = { -406.04,6148.4,31.68,108,3,"Trabajo legal",0.7 }
	Blips[#Blips+1] = { -1471.72,-920.16,10.03,108,3,"Trabajo legal",0.7 }

	-- Blips[#Blips+1] = { -428.56,-1728.33,19.79,365,3,"Tienda | Reciclaje",0.8 }
	Blips[#Blips+1] = { 29.2,-1351.89,29.34,52,4,"Tienda de departamentos",0.5 }
	Blips[#Blips+1] = { 2561.74,385.22,108.61,52,4,"Tienda de departamentos",0.5 }
	Blips[#Blips+1] = { 1160.21,-329.4,69.03,52,4,"Tienda de departamentos",0.5 }
	Blips[#Blips+1] = { -711.99,-919.96,19.01,52,4,"Tienda de departamentos",0.5 }
	Blips[#Blips+1] = { -54.56,-1758.56,29.05,52,4,"Tienda de departamentos",0.5 }
	Blips[#Blips+1] = { 375.87,320.04,103.42,52,4,"Tienda de departamentos",0.5 }
	Blips[#Blips+1] = { -3237.48,1004.72,12.45,52,4,"Tienda de departamentos",0.5 }
	Blips[#Blips+1] = { 1730.64,6409.67,35.0,52,4,"Tienda de departamentos",0.5 }
	Blips[#Blips+1] = { 543.51,2676.85,42.14,52,4,"Tienda de departamentos",0.5 }
	Blips[#Blips+1] = { 1966.53,3737.95,32.18,52,4,"Tienda de departamentos",0.5 }
	Blips[#Blips+1] = { 2684.73,3281.2,55.23,52,4,"Tienda de departamentos",0.5 }
	Blips[#Blips+1] = { 1696.12,4931.56,42.07,52,4,"Tienda de departamentos",0.5 }
	Blips[#Blips+1] = { -1820.18,785.69,137.98,52,4,"Tienda de departamentos",0.5 }
	Blips[#Blips+1] = { 1395.35,3596.6,34.86,52,4,"Tienda de departamentos",0.5 }
	Blips[#Blips+1] = { -2977.14,391.22,15.03,52,4,"Tienda de departamentos",0.5 }
	Blips[#Blips+1] = { -3034.99,590.77,7.8,52,4,"Tienda de departamentos",0.5 }
	Blips[#Blips+1] = { 1144.46,-980.74,46.19,52,4,"Tienda de departamentos",0.5 }
	Blips[#Blips+1] = { 1166.06,2698.17,37.95,52,4,"Tienda de departamentos",0.5 }
	Blips[#Blips+1] = { -1493.12,-385.55,39.87,52,4,"Tienda de departamentos",0.5 }
	Blips[#Blips+1] = { -1228.6,-899.7,12.27,52,4,"Tienda de departamentos",0.5 }

	Blips[#Blips+1] = { 1702.78,3748.82,34.05,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { 240.06,-43.74,69.71,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { 843.95,-1020.43,27.53,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { -322.19,6072.86,31.27,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { -664.03,-949.22,21.53,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { -1318.83,-389.19,36.43,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { -1110.11,2687.5,18.62,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { 2569.23,309.46,108.46,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { -3159.91,1080.64,20.69,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { 15.42,-1120.47,28.81,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { 811.81,-2145.58,29.34,76,4,"Ammunation",0.5 }


	Blips[#Blips+1] = { -815.12,-184.15,37.57,71,4,"Barbería",0.5 }
	Blips[#Blips+1] = { 138.13,-1706.46,29.3,71,4,"Barbería",0.5 }
	Blips[#Blips+1] = { -1280.92,-1117.07,7.0,71,4,"Barbería",0.5 }
	Blips[#Blips+1] = { 1930.54,3732.06,32.85,71,4,"Barbería",0.5 }
	Blips[#Blips+1] = { 1214.2,-473.18,66.21,71,4,"Barbería",0.5 }
	Blips[#Blips+1] = { -33.61,-154.52,57.08,71,4,"Barbería",0.5 }
	Blips[#Blips+1] = { -276.65,6226.76,31.7,71,4,"Barbería",0.5 }


	-- { -1117.26,-1438.74,5.11,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { 86.06,-1391.64,29.23,366,4,"Tienda de ropa",0.5 }
	Blips[#Blips+1] = { -719.94,-158.18,37.0,366,4,"Tienda de ropa",0.5 }
	Blips[#Blips+1] = { -152.79,-306.79,38.67,366,4,"Tienda de ropa",0.5 }
	Blips[#Blips+1] = { -816.39,-1081.22,11.12,366,4,"Tienda de ropa",0.5 }
	Blips[#Blips+1] = { -1206.51,-781.5,17.12,366,4,"Tienda de ropa",0.5 }
	Blips[#Blips+1] = { -1458.26,-229.79,49.2,366,4,"Tienda de ropa",0.5 }
	Blips[#Blips+1] = { -2.41,6518.29,31.48,366,4,"Tienda de ropa",0.5 }
	Blips[#Blips+1] = { 1682.59,4819.98,42.04,366,4,"Tienda de ropa",0.5 }
	Blips[#Blips+1] = { 129.46,-205.18,54.51,366,4,"Tienda de ropa",0.5 }
	Blips[#Blips+1] = { 618.49,2745.54,42.01,366,4,"Tienda de ropa",0.5 }
	Blips[#Blips+1] = { 1197.93,2698.21,37.96,366,4,"Tienda de ropa",0.5 }
	Blips[#Blips+1] = { -3165.74,1061.29,20.84,366,4,"Tienda de ropa",0.5 }
	Blips[#Blips+1] = { -1093.76,2703.99,19.04,366,4,"Tienda de ropa",0.5 }
	Blips[#Blips+1] = { 414.86,-807.57,29.34,366,4,"Tienda de ropa",0.5 }
	
	
	-- { -1728.06,-1050.69,1.71,471,62,"Embarcações",0.5 }
	Blips[#Blips+1] = { 1966.36,3975.86,31.51,471,62,"Barcos / Embarcaciones",0.5 }
	Blips[#Blips+1] = { -776.72,-1495.02,2.29,471,62,"Barcos / Embarcaciones",0.5 }
	Blips[#Blips+1] = { -893.97,5687.78,3.29,471,62,"Barcos / Embarcaciones",0.5 }
	Blips[#Blips+1] = { 4952.76,-5163.6,-0.3,471,62,"Barcos / Embarcaciones",0.5 }
	Blips[#Blips+1] = { -1728.15,-1050.64,1.7,471,62,"Barcos / Embarcaciones",0.5 }
	Blips[#Blips+1] = { -1622.55,-1167.98,1.45,471,62,"Barcos / Embarcaciones",0.5 }


	Blips[#Blips+1] = { 591.17,2743.5,42.04,51,4,"Farmacia ilegal",0.8 }
	Blips[#Blips+1] = { 45.95,3703.11,39.75,556,5,"Mercado negro y lavado de dinero",1.0 }


	
	Blips[#Blips+1] = { 1322.93,-1652.29,52.27,75,36,"Tienda de tatuajes",0.5 }
	Blips[#Blips+1] = { -1154.42,-1425.9,4.95,75,36,"Tienda de tatuajes",0.5 }
	Blips[#Blips+1] = { 322.84,180.16,103.58,75,36,"Tienda de tatuajes",0.5 }
	Blips[#Blips+1] = { -3169.62,1075.8,20.83,75,36,"Tienda de tatuajes",0.5 }
	Blips[#Blips+1] = { 1864.07,3747.9,33.03,75,36,"Tienda de tatuajes",0.5 }
	Blips[#Blips+1] = { -293.57,6199.85,31.48,75,36,"Tienda de tatuajes",0.5 }


	Blips[#Blips+1] = { -1072.9,-2065.83,13.29,488,5,"Mecánico",0.8 } -- Mecanica
	-- Blips[#Blips+1] = { 120.69,-1317.15,28.93,436,5,"Vanilla +18",0.8 }

	Blips[#Blips+1] = { 3050.88,-4706.21,15.27,575,47,"Portaaviones",1.0 }
	Blips[#Blips+1] = { 1506.39,-2836.1,48.12,181,47,"Puente | Cayo Perico",0.8 }


elseif cityName == "Prime" then
	Blips[#Blips+1] = { 55.43,-876.19,30.66,539,4,"Garajes",0.4 }
	Blips[#Blips+1] = { 598.04,2741.27,42.07,539,4,"Garajes",0.4 }
	Blips[#Blips+1] = { -136.36,6357.03,31.49,539,4,"Garajes",0.4 }
	Blips[#Blips+1] = { 275.23,-345.54,45.17,539,4,"Garajes",0.4 }
	Blips[#Blips+1] = { 596.40,90.65,93.12,539,4,"Garajes",0.4 }
	Blips[#Blips+1] = { -340.76,265.97,85.67,539,4,"Garajes",0.4 }
	Blips[#Blips+1] = { -2030.01,-465.97,11.60,539,4,"Garajes",0.4 }
	Blips[#Blips+1] = { -1184.92,-1510.00,4.64,539,4,"Garajes",0.4 }
	Blips[#Blips+1] = { 214.02,-808.44,31.01,539,4,"Garajes",0.4 }
	Blips[#Blips+1] = { -348.88,-874.02,31.31,539,4,"Garajes",0.4 }
	Blips[#Blips+1] = { 67.74,12.27,69.21,539,4,"Garajes",0.4 }
	Blips[#Blips+1] = { 361.90,297.81,103.88,539,4,"Garajes",0.4 }
	Blips[#Blips+1] = { 1035.89,-763.89,57.99,539,4,"Garajes",0.4 }
	Blips[#Blips+1] = { -796.63,-2022.77,9.16,539,4,"Garajes",0.4 }
	Blips[#Blips+1] = { 453.27,-1146.76,29.52,539,4,"Garajes",0.4 }
	Blips[#Blips+1] = { 528.66,-146.3,58.38,539,4,"Garajes",0.4 }
	Blips[#Blips+1] = { -1159.48,-739.32,19.89,539,4,"Garajes",0.4 }
	Blips[#Blips+1] = { 101.22,-1073.68,29.38,539,4,"Garajes",0.4 }
	Blips[#Blips+1] = { 1725.21,4711.77,42.11,539,4,"Garajes",0.4 }
	Blips[#Blips+1] = { 1624.05,3566.14,35.15,539,4,"Garajes",0.4 }
	Blips[#Blips+1] = { -73.35,-2004.6,18.27,539,4,"Garajes",0.4 }
	
	-- ILHAS
	
	-- { 5053.84,-4624.94,2.76 ,384,47,"Ilha Cayo Perico",1.0 }
	
	-- PONTOS CENTRAIS
	Blips[#Blips+1] = { 178.54,-982.15,29.64,266,5,"Plaza Central",1.0 }	
	Blips[#Blips+1] = { 1428.78,6490.94,20.34,266,5,"Muelle Norte",0.8 }		

	Blips[#Blips+1] = { 1046.64,2300.27,44.82,108,5,"Procesamiento",0.7 }
	Blips[#Blips+1] = { 134.06,-3088.0,8.21,108,5,"Procesamiento",0.7 }
	Blips[#Blips+1] = { 118.66,-1087.29,29.22,587,2,"Cofre Personal",0.5 }			
	Blips[#Blips+1] = { 1420.9,6564.6,18.53,587,2,"Cofre Personal",0.5 }		
	Blips[#Blips+1] = { 1860.07,2608.29,45.66,188,1,"Prisión",1.5 }

	Blips[#Blips+1] = { -534.23,-222.15,37.64,385,5,"Jurídico",1.0 } --
	Blips[#Blips+1] = { 2567.58,-358.4,92.99,487,5,"Departamento de Policía",1.0 }
	Blips[#Blips+1] = { -447.31,6007.91,48.83,487,5,"Departamento de Policía",1.0 }
	Blips[#Blips+1] = { -783.98,-1277.75,67.04,487,5,"Departamento de Policía",1.0 } -- tatica
	Blips[#Blips+1] = { 1105.52,-896.96,88.26,106,1,"Bombeiros",0.7 }
	-- Blips[#Blips+1] = { -828.4,-1219.45,28.41,487,5,"Departamento de Policía",1.0 }
	-- Blips[#Blips+1] = { -435.42,6016.69,50.85,487,5,"Departamento de Policía",1.0 }
	Blips[#Blips+1] = { 1152.97,-1526.05,34.85,80,5,"Hospital",0.5 } -- hp principal
	Blips[#Blips+1] = { -70.49,-1104.59,26.12,225,5,"Concesionario",0.8 }
	Blips[#Blips+1] = { 229.77,214.17,105.55,431,5,"Banco Central",0.8 }
	
	Blips[#Blips+1] = { -2329.46,3266.47,32.82,487,5,"Zancudo",1.0 }
	Blips[#Blips+1] = { 501.59,5604.47,797.91,164,5,"Monte Chiliad",1.0 }
	Blips[#Blips+1] = { -1627.64,-3099.74,13.93,184,5,"Estudio de fotografía",0.8 }	
	Blips[#Blips+1] = { -1256.65,-3356.17,13.93,184,5,"Estudio de fotografía",0.8 }
	
	-- { 2380.24,5094.35,47.35,285,3,"Emprego | Lenhador",0.5 }
	Blips[#Blips+1] = { 2515.56,4763.37,34.76,108,3,"Trabajo legal",0.7 }
	Blips[#Blips+1] = { 2953.93,2787.49,41.5,108,3,"Trabajo legal",0.7 }
	Blips[#Blips+1] = { 1418.79,6715.32,14.37,108,3,"Trabajo legal",0.7 }
	Blips[#Blips+1] = { 453.82,-600.6,28.58,108,3,"Trabajo legal",0.7 }
	Blips[#Blips+1] = { 751.71,6459.04,31.53,108,3,"Trabajo legal",0.7 }
	Blips[#Blips+1] = { 2093.65,5044.13,41.18,108,3,"Trabajo legal",0.7 }
	Blips[#Blips+1] = { -19.92,6304.38,31.37,108,3,"Trabajo legal",0.7 }
	Blips[#Blips+1] = { -406.04,6148.4,31.68,108,3,"Trabajo legal",0.7 }
	Blips[#Blips+1] = { -1471.72,-920.16,10.03,108,3,"Trabajo legal",0.7 }

	-- Blips[#Blips+1] = { -428.56,-1728.33,19.79,365,3,"Tienda | Reciclaje",0.8 }
	Blips[#Blips+1] = { 29.2,-1351.89,29.34,52,4,"Tienda de departamentos",0.5 }
	Blips[#Blips+1] = { 2561.74,385.22,108.61,52,4,"Tienda de departamentos",0.5 }
	Blips[#Blips+1] = { 1160.21,-329.4,69.03,52,4,"Tienda de departamentos",0.5 }
	Blips[#Blips+1] = { -711.99,-919.96,19.01,52,4,"Tienda de departamentos",0.5 }
	Blips[#Blips+1] = { -54.56,-1758.56,29.05,52,4,"Tienda de departamentos",0.5 }
	Blips[#Blips+1] = { 375.87,320.04,103.42,52,4,"Tienda de departamentos",0.5 }
	Blips[#Blips+1] = { -3237.48,1004.72,12.45,52,4,"Tienda de departamentos",0.5 }
	Blips[#Blips+1] = { 1730.64,6409.67,35.0,52,4,"Tienda de departamentos",0.5 }
	Blips[#Blips+1] = { 543.51,2676.85,42.14,52,4,"Tienda de departamentos",0.5 }
	Blips[#Blips+1] = { 1966.53,3737.95,32.18,52,4,"Tienda de departamentos",0.5 }
	Blips[#Blips+1] = { 2684.73,3281.2,55.23,52,4,"Tienda de departamentos",0.5 }
	Blips[#Blips+1] = { 1696.12,4931.56,42.07,52,4,"Tienda de departamentos",0.5 }
	Blips[#Blips+1] = { -1820.18,785.69,137.98,52,4,"Tienda de departamentos",0.5 }
	Blips[#Blips+1] = { 1395.35,3596.6,34.86,52,4,"Tienda de departamentos",0.5 }
	Blips[#Blips+1] = { -2977.14,391.22,15.03,52,4,"Tienda de departamentos",0.5 }
	Blips[#Blips+1] = { -3034.99,590.77,7.8,52,4,"Tienda de departamentos",0.5 }
	Blips[#Blips+1] = { 1144.46,-980.74,46.19,52,4,"Tienda de departamentos",0.5 }
	Blips[#Blips+1] = { 1166.06,2698.17,37.95,52,4,"Tienda de departamentos",0.5 }
	Blips[#Blips+1] = { -1493.12,-385.55,39.87,52,4,"Tienda de departamentos",0.5 }
	Blips[#Blips+1] = { -1228.6,-899.7,12.27,52,4,"Tienda de departamentos",0.5 }

	Blips[#Blips+1] = { 1702.78,3748.82,34.05,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { 240.06,-43.74,69.71,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { 843.95,-1020.43,27.53,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { -322.19,6072.86,31.27,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { -664.03,-949.22,21.53,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { -1318.83,-389.19,36.43,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { -1110.11,2687.5,18.62,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { 2569.23,309.46,108.46,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { -3159.91,1080.64,20.69,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { 15.42,-1120.47,28.81,76,4,"Ammunation",0.5 }
	Blips[#Blips+1] = { 811.81,-2145.58,29.34,76,4,"Ammunation",0.5 }


	Blips[#Blips+1] = { -815.12,-184.15,37.57,71,4,"Barbería",0.5 }
	Blips[#Blips+1] = { 138.13,-1706.46,29.3,71,4,"Barbería",0.5 }
	Blips[#Blips+1] = { -1280.92,-1117.07,7.0,71,4,"Barbería",0.5 }
	Blips[#Blips+1] = { 1930.54,3732.06,32.85,71,4,"Barbería",0.5 }
	Blips[#Blips+1] = { 1214.2,-473.18,66.21,71,4,"Barbería",0.5 }
	Blips[#Blips+1] = { -33.61,-154.52,57.08,71,4,"Barbería",0.5 }
	Blips[#Blips+1] = { -276.65,6226.76,31.7,71,4,"Barbería",0.5 }


	-- { -1117.26,-1438.74,5.11,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { 86.06,-1391.64,29.23,366,4,"Tienda de ropa",0.5 }
	Blips[#Blips+1] = { -719.94,-158.18,37.0,366,4,"Tienda de ropa",0.5 }
	Blips[#Blips+1] = { -152.79,-306.79,38.67,366,4,"Tienda de ropa",0.5 }
	Blips[#Blips+1] = { -816.39,-1081.22,11.12,366,4,"Tienda de ropa",0.5 }
	Blips[#Blips+1] = { -1206.51,-781.5,17.12,366,4,"Tienda de ropa",0.5 }
	Blips[#Blips+1] = { -1458.26,-229.79,49.2,366,4,"Tienda de ropa",0.5 }
	Blips[#Blips+1] = { -2.41,6518.29,31.48,366,4,"Tienda de ropa",0.5 }
	Blips[#Blips+1] = { 1682.59,4819.98,42.04,366,4,"Tienda de ropa",0.5 }
	Blips[#Blips+1] = { 129.46,-205.18,54.51,366,4,"Tienda de ropa",0.5 }
	Blips[#Blips+1] = { 618.49,2745.54,42.01,366,4,"Tienda de ropa",0.5 }
	Blips[#Blips+1] = { 1197.93,2698.21,37.96,366,4,"Tienda de ropa",0.5 }
	Blips[#Blips+1] = { -3165.74,1061.29,20.84,366,4,"Tienda de ropa",0.5 }
	Blips[#Blips+1] = { -1093.76,2703.99,19.04,366,4,"Tienda de ropa",0.5 }
	Blips[#Blips+1] = { 414.86,-807.57,29.34,366,4,"Tienda de ropa",0.5 }
	
	
	-- { -1728.06,-1050.69,1.71,471,62,"Embarcações",0.5 }
	Blips[#Blips+1] = { 1966.36,3975.86,31.51,471,62,"Barcos / Embarcaciones",0.5 }
	Blips[#Blips+1] = { -776.72,-1495.02,2.29,471,62,"Barcos / Embarcaciones",0.5 }
	Blips[#Blips+1] = { -893.97,5687.78,3.29,471,62,"Barcos / Embarcaciones",0.5 }
	Blips[#Blips+1] = { 4952.76,-5163.6,-0.3,471,62,"Barcos / Embarcaciones",0.5 }
	Blips[#Blips+1] = { -1728.15,-1050.64,1.7,471,62,"Barcos / Embarcaciones",0.5 }
	Blips[#Blips+1] = { -1622.55,-1167.98,1.45,471,62,"Barcos / Embarcaciones",0.5 }


	Blips[#Blips+1] = { 591.17,2743.5,42.04,51,4,"Farmacia ilegal",0.8 }
	Blips[#Blips+1] = { 45.95,3703.11,39.75,556,5,"Mercado negro y lavado de dinero",1.0 }


	
	Blips[#Blips+1] = { 1322.93,-1652.29,52.27,75,36,"Tienda de tatuajes",0.5 }
	Blips[#Blips+1] = { -1154.42,-1425.9,4.95,75,36,"Tienda de tatuajes",0.5 }
	Blips[#Blips+1] = { 322.84,180.16,103.58,75,36,"Tienda de tatuajes",0.5 }
	Blips[#Blips+1] = { -3169.62,1075.8,20.83,75,36,"Tienda de tatuajes",0.5 }
	Blips[#Blips+1] = { 1864.07,3747.9,33.03,75,36,"Tienda de tatuajes",0.5 }
	Blips[#Blips+1] = { -293.57,6199.85,31.48,75,36,"Tienda de tatuajes",0.5 }


	Blips[#Blips+1] = { -1072.9,-2065.83,13.29,488,5,"Mecánico",0.8 } -- Mecanica
	Blips[#Blips+1] = { 120.69,-1317.15,28.93,436,5,"Vanilla +18",0.8 }

	Blips[#Blips+1] = { 3050.88,-4706.21,15.27,575,47,"Portaaviones",1.0 }
	Blips[#Blips+1] = { 1506.39,-2836.1,48.12,181,47,"Puente | Cayo Perico",0.8 }

elseif cityName == "Santa" then
	Blips[#Blips+1] = { 55.43,-876.19,30.66,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 598.04,2741.27,42.07,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -136.36,6357.03,31.49,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 275.23,-345.54,45.17,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 596.40,90.65,93.12,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -340.76,265.97,85.67,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -2030.01,-465.97,11.60,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -1184.92,-1510.00,4.64,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 214.02,-808.44,31.01,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -348.88,-874.02,31.31,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 67.74,12.27,69.21,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 361.90,297.81,103.88,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 1035.89,-763.89,57.99,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -796.63,-2022.77,9.16,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 453.27,-1146.76,29.52,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 528.66,-146.3,58.38,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -1159.48,-739.32,19.89,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 101.22,-1073.68,29.38,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 1725.21,4711.77,42.11,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 1624.05,3566.14,35.15,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -73.35,-2004.6,18.27,539,4,"Garagem",0.4 }
		
		-- ILHAS
		
		-- { 5053.84,-4624.94,2.76 ,384,47,"Ilha Cayo Perico",1.0 }
		
		-- PONTOS CENTRAIS
	Blips[#Blips+1] = { 178.54,-982.15,29.64,266,5,"Praça Central",1.0 }	
	Blips[#Blips+1] = { -1610.53,-1011.25,13.02,266,5,"Pier Sul",1.0 }
	Blips[#Blips+1] = { 1428.78,6490.94,20.34,266,5,"Pier Norte",0.8 }		
	Blips[#Blips+1] = { 1692.35,3595.79,42.99,106,49,"Bombeiros",0.7 }
	Blips[#Blips+1] = { -1168.91,-1255.51,7.57,106,5,"Bombeiros",0.7 } -- bombeiros sul
	Blips[#Blips+1] = { 1046.64,2300.27,44.82,108,5,"Local de Farm",0.7 }
	Blips[#Blips+1] = { 134.06,-3088.0,8.21,108,5,"Local de Farm",0.7 }
	Blips[#Blips+1] = { 118.66,-1087.29,29.22,587,2,"Baú Pessoal (Grátis)",0.5 }			
	Blips[#Blips+1] = { 1420.9,6564.6,18.53,587,2,"Baú Pessoal (Grátis)",0.5 }		
	Blips[#Blips+1] = { 1860.07,2608.29,45.66,188,1,"Prisão",1.5 }
	
	Blips[#Blips+1] = { 828.98,-1295.14,33.36,487,5,"Civil",1.0 }
	Blips[#Blips+1] = { -311.76,-609.63,32.76,80,5,"Hospital",0.5 } -- hp principal
	Blips[#Blips+1] = { -241.51,6310.63,32.87,80,5,"Hospital",0.5 } -- HP NORTE
	
	Blips[#Blips+1] = { -70.49,-1104.59,26.12,225,5,"Concessionária",0.8 }
	Blips[#Blips+1] = { 229.77,214.17,105.55,431,5,"Banco Central",0.8 }
	Blips[#Blips+1] = { -537.79,-217.52,37.64,385,5,"Juridico",1.0 }
		
	Blips[#Blips+1] = { -2329.46,3266.47,32.82,487,5,"Forte Zancudo",1.0 }
	Blips[#Blips+1] = { 501.59,5604.47,797.91,164,5,"Monte Chiliad",1.0 }
	Blips[#Blips+1] = { -174.42,-2147.11,16.7,409,5,"Kartódromo",0.8 }
	Blips[#Blips+1] = { -1627.64,-3099.74,13.93,184,5,"Estúdio de Fotográfia",0.8 }	
	Blips[#Blips+1] = { -1256.65,-3356.17,13.93,184,5,"Estúdio de Fotográfia",0.8 }
		
		-- { 2380.24,5094.35,47.35,285,3,"Emprego | Lenhador",0.5 }
	Blips[#Blips+1] = { 2515.56,4763.37,34.76,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { 2953.93,2787.49,41.5,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { 1418.79,6715.32,14.37,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { 453.82,-600.6,28.58,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { 751.71,6459.04,31.53,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { 2093.65,5044.13,41.18,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { -19.92,6304.38,31.37,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { -406.04,6148.4,31.68,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { -1471.72,-920.16,10.03,108,3,"Emprego Legal",0.7 }
	
	Blips[#Blips+1] = { -428.56,-1728.33,19.79,365,3,"Loja | Reciclagem",0.8 }
	Blips[#Blips+1] = { 29.2,-1351.89,29.34,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 2561.74,385.22,108.61,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 1160.21,-329.4,69.03,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -711.99,-919.96,19.01,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -54.56,-1758.56,29.05,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 375.87,320.04,103.42,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -3237.48,1004.72,12.45,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 1730.64,6409.67,35.0,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 543.51,2676.85,42.14,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 1966.53,3737.95,32.18,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 2684.73,3281.2,55.23,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 1696.12,4931.56,42.07,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -1820.18,785.69,137.98,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 1395.35,3596.6,34.86,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -2977.14,391.22,15.03,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -3034.99,590.77,7.8,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 1144.46,-980.74,46.19,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 1166.06,2698.17,37.95,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -1493.12,-385.55,39.87,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -1228.6,-899.7,12.27,52,4,"Loja de Departamento",0.5 }
	
	Blips[#Blips+1] = { 1702.78,3748.82,34.05,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { 240.06,-43.74,69.71,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { 843.95,-1020.43,27.53,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { -322.19,6072.86,31.27,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { -664.03,-949.22,21.53,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { -1318.83,-389.19,36.43,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { -1110.11,2687.5,18.62,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { 2569.23,309.46,108.46,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { -3159.91,1080.64,20.69,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { 15.42,-1120.47,28.81,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { 811.81,-2145.58,29.34,76,4,"Loja de Armas",0.5 }
	
	
	Blips[#Blips+1] = { -815.12,-184.15,37.57,71,4,"Barbearia",0.5 }
	Blips[#Blips+1] = { 138.13,-1706.46,29.3,71,4,"Barbearia",0.5 }
	Blips[#Blips+1] = { -1280.92,-1117.07,7.0,71,4,"Barbearia",0.5 }
	Blips[#Blips+1] = { 1930.54,3732.06,32.85,71,4,"Barbearia",0.5 }
	Blips[#Blips+1] = { 1214.2,-473.18,66.21,71,4,"Barbearia",0.5 }
	Blips[#Blips+1] = { -33.61,-154.52,57.08,71,4,"Barbearia",0.5 }
	Blips[#Blips+1] = { -276.65,6226.76,31.7,71,4,"Barbearia",0.5 }
	
	
		-- { -1117.26,-1438.74,5.11,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { 86.06,-1391.64,29.23,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -719.94,-158.18,37.0,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -152.79,-306.79,38.67,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -816.39,-1081.22,11.12,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -1206.51,-781.5,17.12,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -1458.26,-229.79,49.2,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -2.41,6518.29,31.48,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { 1682.59,4819.98,42.04,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { 129.46,-205.18,54.51,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { 618.49,2745.54,42.01,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { 1197.93,2698.21,37.96,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -3165.74,1061.29,20.84,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -1093.76,2703.99,19.04,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { 414.86,-807.57,29.34,366,4,"Loja de Roupas",0.5 }
		
		
		-- { -1728.06,-1050.69,1.71,471,62,"Embarcações",0.5 }
	Blips[#Blips+1] = { 1966.36,3975.86,31.51,471,62,"Embarcações",0.5 }
	Blips[#Blips+1] = { -776.72,-1495.02,2.29,471,62,"Embarcações",0.5 }
	Blips[#Blips+1] = { -893.97,5687.78,3.29,471,62,"Embarcações",0.5 }
	Blips[#Blips+1] = { 4952.76,-5163.6,-0.3,471,62,"Embarcações",0.5 }
	Blips[#Blips+1] = { -1728.15,-1050.64,1.7,471,62,"Embarcações",0.5 }
	Blips[#Blips+1] = { -1622.55,-1167.98,1.45,471,62,"Embarcações",0.5 }
	Blips[#Blips+1] = { -3334.70,432.36,2.64,471,62,"Embarcações",0.5 }
	
	
	Blips[#Blips+1] = { 591.17,2743.5,42.04,51,4,"Farmácia Clandestina",0.8 }
	Blips[#Blips+1] = { 45.95,3703.11,39.75,556,5,"Mercado Negro e Lavagem de Dinheiro",1.0 }
		-- { -1198.15,-1458.38,4.36,51,15,"Farmácia",0.5 }
		-- { -1255.49,-1436.33,4.36,51,15,"Farmácia",0.5 }
	
		
	Blips[#Blips+1] = { 1322.93,-1652.29,52.27,75,36,"Loja de Tatuagem",0.5 }
	Blips[#Blips+1] = { -1154.42,-1425.9,4.95,75,36,"Loja de Tatuagem",0.5 }
	Blips[#Blips+1] = { 322.84,180.16,103.58,75,36,"Loja de Tatuagem",0.5 }
	Blips[#Blips+1] = { -3169.62,1075.8,20.83,75,36,"Loja de Tatuagem",0.5 }
	Blips[#Blips+1] = { 1864.07,3747.9,33.03,75,36,"Loja de Tatuagem",0.5 }
	Blips[#Blips+1] = { -293.57,6199.85,31.48,75,36,"Loja de Tatuagem",0.5 }
	
	
	Blips[#Blips+1] = { 5323.13,-5238.68,32.76 ,539,36,"Cayo Perico",0.5 }
	Blips[#Blips+1] = { 5157.12,-5104.11,2.36 ,539,36,"Cayo Perico",0.5 }
	Blips[#Blips+1] = { 4930.78,-5146.1,2.48 ,539,36,"Cayo Perico",0.5 }
	Blips[#Blips+1] = { 4973.78,-5856.06,19.82 ,539,36,"Cayo Perico",0.5 }
	Blips[#Blips+1] = { 4936.15,-4900.87,3.62 ,539,36,"Cayo Perico",0.5 }
	Blips[#Blips+1] = { 4455.61,-4521.53,4.11 ,539,36,"Cayo Perico",0.5 }
		-- { -61.89,-1218.25,28.7 ,51,62,"Entregas de Drogas",0.6 }
		-- { 218.09,-1391.38,30.58 ,51,62,"Entregas de Droga",0.6 }
		-- { -1695.32,-287.06,51.88 ,51,62,"Entregas de Droga",0.6 }

	Blips[#Blips+1] = { 545.37,-194.68,54.44,488,5,"Mecânica",0.8 } -- Mecanica
	Blips[#Blips+1] = { 2480.64,-384.0,110.11,487,5,"Departamento Policial",1.0 } -- dp principal
	Blips[#Blips+1] = { -913.56,-2043.46,9.4,487,5,"Departamento Policial",1.0 } -- dp principal
	Blips[#Blips+1] = { -852.02,-1197.13,63.91,487,5,"Departamento Policial",1.0 } -- tatica
	Blips[#Blips+1] = { -455.6,5996.0,31.71,487,5,"Departamento Policial",1.0 } -- civil
	Blips[#Blips+1] = { 2613.75,5280.4,70.6,487,5,"Prf",1.0 } -- prf
	Blips[#Blips+1] = { 120.69,-1317.15,28.93,436,5,"Vanilla +18",0.8 }
	Blips[#Blips+1] = { -3188.88,-1145.31,7.82,436,5,"Ilha da Revoada",0.8 }
	Blips[#Blips+1] = { 3050.88,-4706.21,15.27,575,47,"Porta-Aviões",1.0 }
	Blips[#Blips+1] = { 1506.39,-2836.1,48.12,181,47,"Ponte | Cayo Perico",0.8 }

elseif cityName == "Universo" then
	Blips[#Blips+1] = { 55.43,-876.19,30.66,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 598.04,2741.27,42.07,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -136.36,6357.03,31.49,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 275.23,-345.54,45.17,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 596.40,90.65,93.12,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -340.76,265.97,85.67,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -2030.01,-465.97,11.60,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -1184.92,-1510.00,4.64,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 214.02,-808.44,31.01,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -348.88,-874.02,31.31,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 67.74,12.27,69.21,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 361.90,297.81,103.88,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 1035.89,-763.89,57.99,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -796.63,-2022.77,9.16,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 453.27,-1146.76,29.52,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 528.66,-146.3,58.38,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -1159.48,-739.32,19.89,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 101.22,-1073.68,29.38,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 1725.21,4711.77,42.11,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 1624.05,3566.14,35.15,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -73.35,-2004.6,18.27,539,4,"Garagem",0.4 }
		
		-- ILHAS
		
		-- { 5053.84,-4624.94,2.76 ,384,47,"Ilha Cayo Perico",1.0 }
		
		-- PONTOS CENTRAIS
	Blips[#Blips+1] = { 178.54,-982.15,29.64,266,5,"Praça Central",1.0 }	
	Blips[#Blips+1] = { -1610.53,-1011.25,13.02,266,5,"Pier Sul",1.0 }
	Blips[#Blips+1] = { 1428.78,6490.94,20.34,266,5,"Pier Norte",0.8 }		
	Blips[#Blips+1] = { -663.45,-73.46,38.52,106,1,"Bombeiros",0.7 }
	Blips[#Blips+1] = { 1046.64,2300.27,44.82,108,5,"Local de Farm",0.7 }
	Blips[#Blips+1] = { 134.06,-3088.0,8.21,108,5,"Local de Farm",0.7 }
	Blips[#Blips+1] = { 118.66,-1087.29,29.22,587,2,"Baú Pessoal (Grátis)",0.5 }			
	Blips[#Blips+1] = { 1420.9,6564.6,18.53,587,2,"Baú Pessoal (Grátis)",0.5 }		
	Blips[#Blips+1] = { 1860.07,2608.29,45.66,188,1,"Prisão",1.5 }
	
	Blips[#Blips+1] = { -444.09,6001.79,44.01,487,5,"Departamento Policial",1.0 }
	Blips[#Blips+1] = { 1152.97,-1526.05,34.85,80,5,"Hospital",0.5 } -- hp principal
	
	Blips[#Blips+1] = { -70.49,-1104.59,26.12,225,5,"Concessionária",0.8 }
	Blips[#Blips+1] = { 229.77,214.17,105.55,431,5,"Banco Central",0.8 }
		
	Blips[#Blips+1] = { 501.59,5604.47,797.91,164,5,"Monte Chiliad",1.0 }
	Blips[#Blips+1] = { -174.42,-2147.11,16.7,409,5,"Kartódromo",0.8 }
	Blips[#Blips+1] = { -1627.64,-3099.74,13.93,184,5,"Estúdio de Fotográfia",0.8 }	
	Blips[#Blips+1] = { -1256.65,-3356.17,13.93,184,5,"Estúdio de Fotográfia",0.8 }
		
		-- { 2380.24,5094.35,47.35,285,3,"Emprego | Lenhador",0.5 }
	Blips[#Blips+1] = { 2515.56,4763.37,34.76,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { 2953.93,2787.49,41.5,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { 1418.79,6715.32,14.37,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { 453.82,-600.6,28.58,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { 751.71,6459.04,31.53,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { 2093.65,5044.13,41.18,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { -19.92,6304.38,31.37,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { -406.04,6148.4,31.68,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { -1471.72,-920.16,10.03,108,3,"Emprego Legal",0.7 }
	
	Blips[#Blips+1] = { -428.56,-1728.33,19.79,365,3,"Loja | Reciclagem",0.8 }
	Blips[#Blips+1] = { 29.2,-1351.89,29.34,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 2561.74,385.22,108.61,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 1160.21,-329.4,69.03,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -711.99,-919.96,19.01,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -54.56,-1758.56,29.05,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 375.87,320.04,103.42,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -3237.48,1004.72,12.45,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 1730.64,6409.67,35.0,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 543.51,2676.85,42.14,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 1966.53,3737.95,32.18,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 2684.73,3281.2,55.23,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 1696.12,4931.56,42.07,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -1820.18,785.69,137.98,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 1395.35,3596.6,34.86,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -2977.14,391.22,15.03,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -3034.99,590.77,7.8,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 1144.46,-980.74,46.19,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 1166.06,2698.17,37.95,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -1493.12,-385.55,39.87,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -1228.6,-899.7,12.27,52,4,"Loja de Departamento",0.5 }
	
	Blips[#Blips+1] = { 1702.78,3748.82,34.05,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { 240.06,-43.74,69.71,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { 843.95,-1020.43,27.53,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { -322.19,6072.86,31.27,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { -664.03,-949.22,21.53,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { -1318.83,-389.19,36.43,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { -1110.11,2687.5,18.62,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { 2569.23,309.46,108.46,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { -3159.91,1080.64,20.69,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { 15.42,-1120.47,28.81,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { 811.81,-2145.58,29.34,76,4,"Loja de Armas",0.5 }
	
	
	Blips[#Blips+1] = { -815.12,-184.15,37.57,71,4,"Barbearia",0.5 }
	Blips[#Blips+1] = { 138.13,-1706.46,29.3,71,4,"Barbearia",0.5 }
	Blips[#Blips+1] = { -1280.92,-1117.07,7.0,71,4,"Barbearia",0.5 }
	Blips[#Blips+1] = { 1930.54,3732.06,32.85,71,4,"Barbearia",0.5 }
	Blips[#Blips+1] = { 1214.2,-473.18,66.21,71,4,"Barbearia",0.5 }
	Blips[#Blips+1] = { -33.61,-154.52,57.08,71,4,"Barbearia",0.5 }
	Blips[#Blips+1] = { -276.65,6226.76,31.7,71,4,"Barbearia",0.5 }

	Blips[#Blips+1] = { -824.84,-1221.24,18.28,526,46,"Policia Universo",1.0 }
	Blips[#Blips+1] = { -2326.75,3267.51,32.83,526,46,"Exercito Universo",1.0 }
	Blips[#Blips+1] = { -439.91,6003.95,44.01,526,46,"Policia Investigativa",1.0 }
	Blips[#Blips+1] = { 839.42,-1290.76,37.08,60,46,"Policia Investigativa Sul",1.0 }
	Blips[#Blips+1] = { 2621.55,5288.03,53.08,526,46,"Policia Rodoviária Nacional",1.0 }
	Blips[#Blips+1] = { -550.64,-195.87,88.80,385,28,"Juridico",1.0 }
	Blips[#Blips+1] = { 3886.32,26.66,39.48,310,1,"Prisao do Crime",1.0 }

	Blips[#Blips+1] = { -304.57,6261.13,37.95,436,1,"Vanilla",0.5 }
	Blips[#Blips+1] = { 128.05,-145.41,68.02,121,76,"Night Club",0.5 }
	Blips[#Blips+1] = { 189.71,-3168.22,5.78,304,83,"Club 77",0.5 }
	Blips[#Blips+1] = { -1392.27,-596.61,42.94,121,48,"Bahama Mamas",0.5 }
	
		-- { -1117.26,-1438.74,5.11,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { 86.06,-1391.64,29.23,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -719.94,-158.18,37.0,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -152.79,-306.79,38.67,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -816.39,-1081.22,11.12,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -1206.51,-781.5,17.12,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -1458.26,-229.79,49.2,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -2.41,6518.29,31.48,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { 1682.59,4819.98,42.04,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { 129.46,-205.18,54.51,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { 618.49,2745.54,42.01,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { 1197.93,2698.21,37.96,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -3165.74,1061.29,20.84,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -1093.76,2703.99,19.04,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { 414.86,-807.57,29.34,366,4,"Loja de Roupas",0.5 }
		
		
		-- { -1728.06,-1050.69,1.71,471,62,"Embarcações",0.5 }
	Blips[#Blips+1] = { 1966.36,3975.86,31.51,471,62,"Embarcações",0.5 }
	Blips[#Blips+1] = { -776.72,-1495.02,2.29,471,62,"Embarcações",0.5 }
	Blips[#Blips+1] = { -893.97,5687.78,3.29,471,62,"Embarcações",0.5 }
	Blips[#Blips+1] = { 4952.76,-5163.6,-0.3,471,62,"Embarcações",0.5 }
	Blips[#Blips+1] = { -1728.15,-1050.64,1.7,471,62,"Embarcações",0.5 }
	Blips[#Blips+1] = { -1622.55,-1167.98,1.45,471,62,"Embarcações",0.5 }
	
	
	Blips[#Blips+1] = { 591.17,2743.5,42.04,51,4,"Farmácia Clandestina",0.8 }
	Blips[#Blips+1] = { 45.95,3703.11,39.75,556,5,"Mercado Negro e Lavagem de Dinheiro",1.0 }
		-- { -1198.15,-1458.38,4.36,51,15,"Farmácia",0.5 }
		-- { -1255.49,-1436.33,4.36,51,15,"Farmácia",0.5 }
	
		
	Blips[#Blips+1] = { 1322.93,-1652.29,52.27,75,36,"Loja de Tatuagem",0.5 }
	Blips[#Blips+1] = { -1154.42,-1425.9,4.95,75,36,"Loja de Tatuagem",0.5 }
	Blips[#Blips+1] = { 322.84,180.16,103.58,75,36,"Loja de Tatuagem",0.5 }
	Blips[#Blips+1] = { -3169.62,1075.8,20.83,75,36,"Loja de Tatuagem",0.5 }
	Blips[#Blips+1] = { 1864.07,3747.9,33.03,75,36,"Loja de Tatuagem",0.5 }
	Blips[#Blips+1] = { -293.57,6199.85,31.48,75,36,"Loja de Tatuagem",0.5 }
	
	
	Blips[#Blips+1] = { 5323.13,-5238.68,32.76 ,539,36,"Cayo Perico",0.5 }
	Blips[#Blips+1] = { 5157.12,-5104.11,2.36 ,539,36,"Cayo Perico",0.5 }
	Blips[#Blips+1] = { 4930.78,-5146.1,2.48 ,539,36,"Cayo Perico",0.5 }
	Blips[#Blips+1] = { 4973.78,-5856.06,19.82 ,539,36,"Cayo Perico",0.5 }
	Blips[#Blips+1] = { 4936.15,-4900.87,3.62 ,539,36,"Cayo Perico",0.5 }
	Blips[#Blips+1] = { 4455.61,-4521.53,4.11 ,539,36,"Cayo Perico",0.5 }
		-- { -61.89,-1218.25,28.7 ,51,62,"Entregas de Drogas",0.6 }
		-- { 218.09,-1391.38,30.58 ,51,62,"Entregas de Droga",0.6 }
		-- { -1695.32,-287.06,51.88 ,51,62,"Entregas de Droga",0.6 }
	-- Blips[#Blips+1] = { 404.42,-1954.53,0.0,432,1,"Área de Risco | Pistola",1.0 }				--- VAGOS
	-- Blips[#Blips+1] = { -1287.0,2525.61,19.78,432,1,"Área de Risco | Fuzil e Pistola",1.0 }		--- PROX BOPE

	Blips[#Blips+1] = { -236.08,6331.21,32.33,80,5,"Hospital",0.5 } -- HP NORTE
	-- Blips[#Blips+1] = { -831.85,-1215.67,6.94,487,5,"Departamento Policial",1.0 } -- Federal
	Blips[#Blips+1] = { -3188.88,-1145.31,7.82,436,5,"Ilha da Revoada",0.8 }
	Blips[#Blips+1] = { 3050.88,-4706.21,15.27,575,47,"Porta-Aviões",1.0 }
	Blips[#Blips+1] = { 1506.39,-2836.1,48.12,181,47,"Ponte | Cayo Perico",0.8 }
	Blips[#Blips+1] = { -1082.09,-2076.26,13.29,488,5,"Mecânica",0.8 }
	Blips[#Blips+1] = { -578.33,4420.09,23.98,622,46,"Altar de Casamento",0.8 }

elseif cityName == "Galaxy" then
	Blips[#Blips+1] = { 823.77,-985.23,26.49,488,5,"Mecânica",0.8 } -- Mecanica
	Blips[#Blips+1] = { 2567.58,-358.4,92.99,487,5,"Departamento Policial",1.0 } -- dp principal

elseif cityName == "Maresia" then
	Blips[#Blips+1] = { 55.43,-876.19,30.66,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 598.04,2741.27,42.07,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -136.36,6357.03,31.49,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 275.23,-345.54,45.17,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 596.40,90.65,93.12,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -340.76,265.97,85.67,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -2030.01,-465.97,11.60,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -1184.92,-1510.00,4.64,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 214.02,-808.44,31.01,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -348.88,-874.02,31.31,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 67.74,12.27,69.21,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 361.90,297.81,103.88,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 1035.89,-763.89,57.99,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -796.63,-2022.77,9.16,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 453.27,-1146.76,29.52,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 528.66,-146.3,58.38,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -1159.48,-739.32,19.89,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 101.22,-1073.68,29.38,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 1725.21,4711.77,42.11,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 1624.05,3566.14,35.15,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -73.35,-2004.6,18.27,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 2574.24,5323.58,44.58,487,5,"Prf",1.0 } -- prf
		
		-- ILHAS
		
		-- { 5053.84,-4624.94,2.76 ,384,47,"Ilha Cayo Perico",1.0 }
		
		-- PONTOS CENTRAIS
	Blips[#Blips+1] = { 178.54,-982.15,29.64,266,5,"Praça Central",1.0 }	
	Blips[#Blips+1] = { -1610.53,-1011.25,13.02,266,5,"Pier Sul",1.0 }
	Blips[#Blips+1] = { 1428.78,6490.94,20.34,266,5,"Pier Norte",0.8 }		
	Blips[#Blips+1] = { -663.45,-73.46,38.52,106,5,"Bombeiros",0.7 }
	Blips[#Blips+1] = { 1689.53,3597.28,42.66,106,5,"Bombeiros",0.7 }
	Blips[#Blips+1] = { 1046.64,2300.27,44.82,108,5,"Local de Farm",0.7 }
	Blips[#Blips+1] = { 134.06,-3088.0,8.21,108,5,"Local de Farm",0.7 }
	Blips[#Blips+1] = { 118.66,-1087.29,29.22,587,2,"Baú Pessoal (Grátis)",0.5 }			
	Blips[#Blips+1] = { 1420.9,6564.6,18.53,587,2,"Baú Pessoal (Grátis)",0.5 }		
	Blips[#Blips+1] = { 1860.07,2608.29,45.66,188,1,"Prisão",1.5 }
	
	Blips[#Blips+1] = { -444.09,6001.79,44.01,487,5,"Departamento Policial",1.0 }
	Blips[#Blips+1] = { 1152.97,-1526.05,34.85,80,5,"Hospital",0.5 } -- hp principal
	Blips[#Blips+1] = { -255.30,6325.74,39.42,80,5,"Hospital",0.5 } -- hp
	Blips[#Blips+1] = { -538.11,-216.27,37.65,385,5,"Juridico",1.0 }
	
	Blips[#Blips+1] = { -70.49,-1104.59,26.12,225,5,"Concessionária",0.8 }
	Blips[#Blips+1] = { 229.77,214.17,105.55,431,5,"Banco Central",0.8 }
		
	Blips[#Blips+1] = { -2329.46,3266.47,32.82,487,5,"Forte Zancudo",1.0 }
	Blips[#Blips+1] = { 501.59,5604.47,797.91,164,5,"Monte Chiliad",1.0 }
	Blips[#Blips+1] = { -174.42,-2147.11,16.7,409,5,"Kartódromo",0.8 }
	Blips[#Blips+1] = { -1627.64,-3099.74,13.93,184,5,"Estúdio de Fotográfia",0.8 }	
	Blips[#Blips+1] = { -1256.65,-3356.17,13.93,184,5,"Estúdio de Fotográfia",0.8 }
		
		-- { 2380.24,5094.35,47.35,285,3,"Emprego | Lenhador",0.5 }
	Blips[#Blips+1] = { 2515.56,4763.37,34.76,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { 2953.93,2787.49,41.5,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { 1418.79,6715.32,14.37,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { 453.82,-600.6,28.58,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { 751.71,6459.04,31.53,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { 2093.65,5044.13,41.18,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { -19.92,6304.38,31.37,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { -406.04,6148.4,31.68,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { -1471.72,-920.16,10.03,108,3,"Emprego Legal",0.7 }
	
	Blips[#Blips+1] = { -428.56,-1728.33,19.79,365,3,"Loja | Reciclagem",0.8 }
	Blips[#Blips+1] = { 29.2,-1351.89,29.34,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 2561.74,385.22,108.61,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 1160.21,-329.4,69.03,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -711.99,-919.96,19.01,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -54.56,-1758.56,29.05,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 375.87,320.04,103.42,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -3237.48,1004.72,12.45,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 1730.64,6409.67,35.0,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 543.51,2676.85,42.14,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 1966.53,3737.95,32.18,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 2684.73,3281.2,55.23,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 1696.12,4931.56,42.07,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -1820.18,785.69,137.98,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 1395.35,3596.6,34.86,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -2977.14,391.22,15.03,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -3034.99,590.77,7.8,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 1144.46,-980.74,46.19,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 1166.06,2698.17,37.95,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -1493.12,-385.55,39.87,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -1228.6,-899.7,12.27,52,4,"Loja de Departamento",0.5 }
	
	Blips[#Blips+1] = { 1702.78,3748.82,34.05,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { 240.06,-43.74,69.71,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { 843.95,-1020.43,27.53,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { -322.19,6072.86,31.27,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { -664.03,-949.22,21.53,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { -1318.83,-389.19,36.43,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { -1110.11,2687.5,18.62,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { 2569.23,309.46,108.46,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { -3159.91,1080.64,20.69,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { 15.42,-1120.47,28.81,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { 811.81,-2145.58,29.34,76,4,"Loja de Armas",0.5 }
	
	
	Blips[#Blips+1] = { -815.12,-184.15,37.57,71,4,"Barbearia",0.5 }
	Blips[#Blips+1] = { 138.13,-1706.46,29.3,71,4,"Barbearia",0.5 }
	Blips[#Blips+1] = { -1280.92,-1117.07,7.0,71,4,"Barbearia",0.5 }
	Blips[#Blips+1] = { 1930.54,3732.06,32.85,71,4,"Barbearia",0.5 }
	Blips[#Blips+1] = { 1214.2,-473.18,66.21,71,4,"Barbearia",0.5 }
	Blips[#Blips+1] = { -33.61,-154.52,57.08,71,4,"Barbearia",0.5 }
	Blips[#Blips+1] = { -276.65,6226.76,31.7,71,4,"Barbearia",0.5 }
	
	
		-- { -1117.26,-1438.74,5.11,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { 86.06,-1391.64,29.23,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -719.94,-158.18,37.0,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -152.79,-306.79,38.67,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -816.39,-1081.22,11.12,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -1206.51,-781.5,17.12,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -1458.26,-229.79,49.2,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -2.41,6518.29,31.48,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { 1682.59,4819.98,42.04,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { 129.46,-205.18,54.51,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { 618.49,2745.54,42.01,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { 1197.93,2698.21,37.96,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -3165.74,1061.29,20.84,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -1093.76,2703.99,19.04,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { 414.86,-807.57,29.34,366,4,"Loja de Roupas",0.5 }
		
		
		-- { -1728.06,-1050.69,1.71,471,62,"Embarcações",0.5 }
	Blips[#Blips+1] = { 1966.36,3975.86,31.51,471,62,"Embarcações",0.5 }
	Blips[#Blips+1] = { -776.72,-1495.02,2.29,471,62,"Embarcações",0.5 }
	Blips[#Blips+1] = { -893.97,5687.78,3.29,471,62,"Embarcações",0.5 }
	Blips[#Blips+1] = { 4952.76,-5163.6,-0.3,471,62,"Embarcações",0.5 }
	Blips[#Blips+1] = { -1728.15,-1050.64,1.7,471,62,"Embarcações",0.5 }
	Blips[#Blips+1] = { -1622.55,-1167.98,1.45,471,62,"Embarcações",0.5 }
	
	
	Blips[#Blips+1] = { 591.17,2743.5,42.04,51,4,"Farmácia Clandestina",0.8 }
	Blips[#Blips+1] = { 45.95,3703.11,39.75,556,5,"Mercado Negro e Lavagem de Dinheiro",1.0 }
		-- { -1198.15,-1458.38,4.36,51,15,"Farmácia",0.5 }
		-- { -1255.49,-1436.33,4.36,51,15,"Farmácia",0.5 }
	
		
	Blips[#Blips+1] = { 1322.93,-1652.29,52.27,75,36,"Loja de Tatuagem",0.5 }
	Blips[#Blips+1] = { -1154.42,-1425.9,4.95,75,36,"Loja de Tatuagem",0.5 }
	Blips[#Blips+1] = { 322.84,180.16,103.58,75,36,"Loja de Tatuagem",0.5 }
	Blips[#Blips+1] = { -3169.62,1075.8,20.83,75,36,"Loja de Tatuagem",0.5 }
	Blips[#Blips+1] = { 1864.07,3747.9,33.03,75,36,"Loja de Tatuagem",0.5 }
	Blips[#Blips+1] = { -293.57,6199.85,31.48,75,36,"Loja de Tatuagem",0.5 }
	
	
	Blips[#Blips+1] = { 5323.13,-5238.68,32.76 ,539,36,"Cayo Perico",0.5 }
	Blips[#Blips+1] = { 5157.12,-5104.11,2.36 ,539,36,"Cayo Perico",0.5 }
	Blips[#Blips+1] = { 4930.78,-5146.1,2.48 ,539,36,"Cayo Perico",0.5 }
	Blips[#Blips+1] = { 4973.78,-5856.06,19.82 ,539,36,"Cayo Perico",0.5 }
	Blips[#Blips+1] = { 4936.15,-4900.87,3.62 ,539,36,"Cayo Perico",0.5 }
	Blips[#Blips+1] = { 4455.61,-4521.53,4.11 ,539,36,"Cayo Perico",0.5 }
		-- { -61.89,-1218.25,28.7 ,51,62,"Entregas de Drogas",0.6 }
		-- { 218.09,-1391.38,30.58 ,51,62,"Entregas de Droga",0.6 }
		-- { -1695.32,-287.06,51.88 ,51,62,"Entregas de Droga",0.6 }

	Blips[#Blips+1] = { -1072.9,-2065.83,13.29,488,5,"Mecânica",0.8 } -- Mecanica
	Blips[#Blips+1] = { 2567.58,-358.4,92.99,487,5,"Departamento Policial",1.0 } -- dp principal
	Blips[#Blips+1] = { -825.44,-1220.28,6.93,487,5,"Departamento Policial",1.0 } -- Tatica
	Blips[#Blips+1] = { 120.69,-1317.15,28.93,436,5,"Vanilla +18",0.8 }
	Blips[#Blips+1] = { -3188.88,-1145.31,7.82,436,5,"Ilha da Revoada",0.8 }
	Blips[#Blips+1] = { 3050.88,-4706.21,15.27,575,47,"Porta-Aviões",1.0 }
	Blips[#Blips+1] = { 1506.39,-2836.1,48.12,181,47,"Ponte | Cayo Perico",0.8 }

elseif cityName == "Alexandria" then
	Blips[#Blips+1] = { 55.43,-876.19,30.66,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 598.04,2741.27,42.07,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -136.36,6357.03,31.49,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 275.23,-345.54,45.17,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 596.40,90.65,93.12,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -340.76,265.97,85.67,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -2030.01,-465.97,11.60,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -1184.92,-1510.00,4.64,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 214.02,-808.44,31.01,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -348.88,-874.02,31.31,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 67.74,12.27,69.21,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 361.90,297.81,103.88,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 1035.89,-763.89,57.99,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -796.63,-2022.77,9.16,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 453.27,-1146.76,29.52,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 528.66,-146.3,58.38,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -1159.48,-739.32,19.89,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 101.22,-1073.68,29.38,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 1725.21,4711.77,42.11,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 1624.05,3566.14,35.15,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -73.35,-2004.6,18.27,539,4,"Garagem",0.4 }
		
		-- ILHAS
		
		-- { 5053.84,-4624.94,2.76 ,384,47,"Ilha Cayo Perico",1.0 }
		
		-- PONTOS CENTRAIS
	Blips[#Blips+1] = { 178.54,-982.15,29.64,266,5,"Praça Central",1.0 }	
	Blips[#Blips+1] = { -1610.53,-1011.25,13.02,266,5,"Pier Sul",1.0 }
	Blips[#Blips+1] = { 1428.78,6490.94,20.34,266,5,"Pier Norte",0.8 }		
	Blips[#Blips+1] = { -663.45,-73.46,38.52,106,5,"Bombeiros",0.7 }
	Blips[#Blips+1] = { 1046.64,2300.27,44.82,108,5,"Local de Farm",0.7 }
	Blips[#Blips+1] = { 134.06,-3088.0,8.21,108,5,"Local de Farm",0.7 }
	Blips[#Blips+1] = { 118.66,-1087.29,29.22,587,2,"Baú Pessoal (Grátis)",0.5 }			
	Blips[#Blips+1] = { 1420.9,6564.6,18.53,587,2,"Baú Pessoal (Grátis)",0.5 }		
	Blips[#Blips+1] = { 1860.07,2608.29,45.66,188,1,"Prisão",1.5 }
	Blips[#Blips+1] = { 2594.31,5314.55,106.36,487,5,"Prf",1.0 } -- prf
	
	Blips[#Blips+1] = { 2548.77,-383.8,92.99,487,5,"Departamento Policial",1.0 }
	Blips[#Blips+1] = { -444.09,6001.79,44.01,487,5,"Departamento Policial",1.0 }
	Blips[#Blips+1] = { 1152.97,-1526.05,34.85,80,5,"Hospital",0.5 } -- hp principal
	
	Blips[#Blips+1] = { -70.49,-1104.59,26.12,225,5,"Concessionária",0.8 }
	Blips[#Blips+1] = { 229.77,214.17,105.55,431,5,"Banco Central",0.8 }
		
	Blips[#Blips+1] = { -2329.46,3266.47,32.82,487,5,"Forte Zancudo",1.0 }
	Blips[#Blips+1] = { 501.59,5604.47,797.91,164,5,"Monte Chiliad",1.0 }
	Blips[#Blips+1] = { -174.42,-2147.11,16.7,409,5,"Kartódromo",0.8 }
	Blips[#Blips+1] = { -1627.64,-3099.74,13.93,184,5,"Estúdio de Fotográfia",0.8 }	
	Blips[#Blips+1] = { -1256.65,-3356.17,13.93,184,5,"Estúdio de Fotográfia",0.8 }
		
		-- { 2380.24,5094.35,47.35,285,3,"Emprego | Lenhador",0.5 }
	Blips[#Blips+1] = { 2515.56,4763.37,34.76,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { 2953.93,2787.49,41.5,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { 1418.79,6715.32,14.37,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { 453.82,-600.6,28.58,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { 751.71,6459.04,31.53,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { 2093.65,5044.13,41.18,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { -19.92,6304.38,31.37,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { -406.04,6148.4,31.68,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { -1471.72,-920.16,10.03,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { -1508.15,-1145.28,1.35,108,3,"Emprego Legal",0.7 }
	
	Blips[#Blips+1] = { -428.56,-1728.33,19.79,365,3,"Loja | Reciclagem",0.8 }
	Blips[#Blips+1] = { 29.2,-1351.89,29.34,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 2561.74,385.22,108.61,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 1160.21,-329.4,69.03,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -711.99,-919.96,19.01,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -54.56,-1758.56,29.05,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 375.87,320.04,103.42,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -3237.48,1004.72,12.45,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 1730.64,6409.67,35.0,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 543.51,2676.85,42.14,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 1966.53,3737.95,32.18,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 2684.73,3281.2,55.23,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 1696.12,4931.56,42.07,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -1820.18,785.69,137.98,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 1395.35,3596.6,34.86,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -2977.14,391.22,15.03,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -3034.99,590.77,7.8,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 1144.46,-980.74,46.19,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 1166.06,2698.17,37.95,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -1493.12,-385.55,39.87,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -1228.6,-899.7,12.27,52,4,"Loja de Departamento",0.5 }
	
	Blips[#Blips+1] = { 1702.78,3748.82,34.05,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { 240.06,-43.74,69.71,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { 843.95,-1020.43,27.53,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { -322.19,6072.86,31.27,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { -664.03,-949.22,21.53,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { -1318.83,-389.19,36.43,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { -1110.11,2687.5,18.62,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { 2569.23,309.46,108.46,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { -3159.91,1080.64,20.69,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { 15.42,-1120.47,28.81,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { 811.81,-2145.58,29.34,76,4,"Loja de Armas",0.5 }
	
	
	Blips[#Blips+1] = { -815.12,-184.15,37.57,71,4,"Barbearia",0.5 }
	Blips[#Blips+1] = { 138.13,-1706.46,29.3,71,4,"Barbearia",0.5 }
	Blips[#Blips+1] = { -1280.92,-1117.07,7.0,71,4,"Barbearia",0.5 }
	Blips[#Blips+1] = { 1930.54,3732.06,32.85,71,4,"Barbearia",0.5 }
	Blips[#Blips+1] = { 1214.2,-473.18,66.21,71,4,"Barbearia",0.5 }
	Blips[#Blips+1] = { -33.61,-154.52,57.08,71,4,"Barbearia",0.5 }
	Blips[#Blips+1] = { -276.65,6226.76,31.7,71,4,"Barbearia",0.5 }
	
	
		-- { -1117.26,-1438.74,5.11,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { 86.06,-1391.64,29.23,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -719.94,-158.18,37.0,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -152.79,-306.79,38.67,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -816.39,-1081.22,11.12,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -1206.51,-781.5,17.12,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -1458.26,-229.79,49.2,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -2.41,6518.29,31.48,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { 1682.59,4819.98,42.04,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { 129.46,-205.18,54.51,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { 618.49,2745.54,42.01,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { 1197.93,2698.21,37.96,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -3165.74,1061.29,20.84,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -1093.76,2703.99,19.04,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { 414.86,-807.57,29.34,366,4,"Loja de Roupas",0.5 }
		
		
		-- { -1728.06,-1050.69,1.71,471,62,"Embarcações",0.5 }
	Blips[#Blips+1] = { 1966.36,3975.86,31.51,471,62,"Embarcações",0.5 }
	Blips[#Blips+1] = { -776.72,-1495.02,2.29,471,62,"Embarcações",0.5 }
	Blips[#Blips+1] = { -893.97,5687.78,3.29,471,62,"Embarcações",0.5 }
	Blips[#Blips+1] = { 4952.76,-5163.6,-0.3,471,62,"Embarcações",0.5 }
	Blips[#Blips+1] = { -1728.15,-1050.64,1.7,471,62,"Embarcações",0.5 }
	Blips[#Blips+1] = { -1622.55,-1167.98,1.45,471,62,"Embarcações",0.5 }
	
	
	Blips[#Blips+1] = { 591.17,2743.5,42.04,51,4,"Farmácia Clandestina",0.8 }
	Blips[#Blips+1] = { 45.95,3703.11,39.75,556,5,"Mercado Negro e Lavagem de Dinheiro",1.0 }
		-- { -1198.15,-1458.38,4.36,51,15,"Farmácia",0.5 }
		-- { -1255.49,-1436.33,4.36,51,15,"Farmácia",0.5 }
	
		
	Blips[#Blips+1] = { 1322.93,-1652.29,52.27,75,36,"Loja de Tatuagem",0.5 }
	Blips[#Blips+1] = { -1154.42,-1425.9,4.95,75,36,"Loja de Tatuagem",0.5 }
	Blips[#Blips+1] = { 322.84,180.16,103.58,75,36,"Loja de Tatuagem",0.5 }
	Blips[#Blips+1] = { -3169.62,1075.8,20.83,75,36,"Loja de Tatuagem",0.5 }
	Blips[#Blips+1] = { 1864.07,3747.9,33.03,75,36,"Loja de Tatuagem",0.5 }
	Blips[#Blips+1] = { -293.57,6199.85,31.48,75,36,"Loja de Tatuagem",0.5 }
	
	
	Blips[#Blips+1] = { 5323.13,-5238.68,32.76 ,539,36,"Cayo Perico",0.5 }
	Blips[#Blips+1] = { 5157.12,-5104.11,2.36 ,539,36,"Cayo Perico",0.5 }
	Blips[#Blips+1] = { 4930.78,-5146.1,2.48 ,539,36,"Cayo Perico",0.5 }
	Blips[#Blips+1] = { 4973.78,-5856.06,19.82 ,539,36,"Cayo Perico",0.5 }
	Blips[#Blips+1] = { 4936.15,-4900.87,3.62 ,539,36,"Cayo Perico",0.5 }
	Blips[#Blips+1] = { 4455.61,-4521.53,4.11 ,539,36,"Cayo Perico",0.5 }
		-- { -61.89,-1218.25,28.7 ,51,62,"Entregas de Drogas",0.6 }
		-- { 218.09,-1391.38,30.58 ,51,62,"Entregas de Droga",0.6 }
		-- { -1695.32,-287.06,51.88 ,51,62,"Entregas de Droga",0.6 }
		
	Blips[#Blips+1] = { -1072.9,-2065.83,13.29,488,5,"Mecânica",0.8 } -- Mecanica
	Blips[#Blips+1] = { -535.93,-221.11,37.64,498,5,"Departamento Jurídico",1.0 }
	Blips[#Blips+1] = { -3188.88,-1145.31,7.82,436,5,"Ilha da Revoada",0.8 }
	Blips[#Blips+1] = { 3050.88,-4706.21,15.27,575,47,"Porta-Aviões",1.0 }
	Blips[#Blips+1] = { 120.69,-1317.15,28.93,436,5,"Vanilla +18",0.8 }
	Blips[#Blips+1] = { 1506.39,-2836.1,48.12,181,47,"Ponte | Cayo Perico",0.8 }

	Blips[#Blips+1] = { -787.82,-1262.18,5.70,487,5,"Departamento Policial",1.0 }

elseif cityName == "Grande" then
	Blips[#Blips+1] = { 55.43,-876.19,30.66,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 598.04,2741.27,42.07,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -136.36,6357.03,31.49,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 275.23,-345.54,45.17,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 596.40,90.65,93.12,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -340.76,265.97,85.67,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -2030.01,-465.97,11.60,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -1184.92,-1510.00,4.64,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 214.02,-808.44,31.01,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -348.88,-874.02,31.31,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 67.74,12.27,69.21,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 361.90,297.81,103.88,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 1035.89,-763.89,57.99,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -796.63,-2022.77,9.16,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 453.27,-1146.76,29.52,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 528.66,-146.3,58.38,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -1159.48,-739.32,19.89,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 101.22,-1073.68,29.38,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 1725.21,4711.77,42.11,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 1624.05,3566.14,35.15,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -73.35,-2004.6,18.27,539,4,"Garagem",0.4 }
		
		-- ILHAS
		
		-- { 5053.84,-4624.94,2.76 ,384,47,"Ilha Cayo Perico",1.0 }
		
		-- PONTOS CENTRAIS
	Blips[#Blips+1] = { 178.54,-982.15,29.64,266,5,"Praça Central",1.0 }	
	Blips[#Blips+1] = { -1610.53,-1011.25,13.02,266,5,"Pier Sul",1.0 }
	Blips[#Blips+1] = { 1428.78,6490.94,20.34,266,5,"Pier Norte",0.8 }		
	Blips[#Blips+1] = { -663.45,-73.46,38.52,106,5,"Bombeiros",0.7 }
	Blips[#Blips+1] = { 1692.35,3595.79,42.99,106,49,"Bombeiros",0.7 }
	Blips[#Blips+1] = { 1046.64,2300.27,44.82,108,5,"Local de Farm",0.7 }
	Blips[#Blips+1] = { 134.06,-3088.0,8.21,108,5,"Local de Farm",0.7 }
	Blips[#Blips+1] = { 118.66,-1087.29,29.22,587,2,"Baú Pessoal (Grátis)",0.5 }			
	Blips[#Blips+1] = { 1420.9,6564.6,18.53,587,2,"Baú Pessoal (Grátis)",0.5 }		
	Blips[#Blips+1] = { 1860.07,2608.29,45.66,188,1,"Prisão",1.5 }

	Blips[#Blips+1] = { -444.09,6001.79,44.01,487,5,"Departamento Policial",1.0 }
	Blips[#Blips+1] = { -311.76,-609.63,32.76,80,5,"Hospital",0.5 } -- hp principal

	Blips[#Blips+1] = { -70.49,-1104.59,26.12,225,5,"Concessionária",0.8 }
	Blips[#Blips+1] = { 229.77,214.17,105.55,431,5,"Banco Central",0.8 }
		
	Blips[#Blips+1] = { -2329.46,3266.47,32.82,487,5,"Forte Zancudo",1.0 }
	Blips[#Blips+1] = { 501.59,5604.47,797.91,164,5,"Monte Chiliad",1.0 }
	Blips[#Blips+1] = { -174.42,-2147.11,16.7,409,5,"Kartódromo",0.8 }
	Blips[#Blips+1] = { -1627.64,-3099.74,13.93,184,5,"Estúdio de Fotográfia",0.8 }	
	Blips[#Blips+1] = { -1256.65,-3356.17,13.93,184,5,"Estúdio de Fotográfia",0.8 }
		
		-- { 2380.24,5094.35,47.35,285,3,"Emprego | Lenhador",0.5 }
	Blips[#Blips+1] = { 2515.56,4763.37,34.76,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { 2953.93,2787.49,41.5,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { 1418.79,6715.32,14.37,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { 453.82,-600.6,28.58,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { 751.71,6459.04,31.53,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { 2093.65,5044.13,41.18,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { -19.92,6304.38,31.37,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { -406.04,6148.4,31.68,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { -1471.72,-920.16,10.03,108,3,"Emprego Legal",0.7 }

	Blips[#Blips+1] = { -428.56,-1728.33,19.79,365,3,"Loja | Reciclagem",0.8 }
	Blips[#Blips+1] = { 29.2,-1351.89,29.34,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 2561.74,385.22,108.61,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 1160.21,-329.4,69.03,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -711.99,-919.96,19.01,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -54.56,-1758.56,29.05,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 375.87,320.04,103.42,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -3237.48,1004.72,12.45,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 1730.64,6409.67,35.0,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 543.51,2676.85,42.14,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 1966.53,3737.95,32.18,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 2684.73,3281.2,55.23,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 1696.12,4931.56,42.07,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -1820.18,785.69,137.98,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 1395.35,3596.6,34.86,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -2977.14,391.22,15.03,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -3034.99,590.77,7.8,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 1144.46,-980.74,46.19,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 1166.06,2698.17,37.95,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -1493.12,-385.55,39.87,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -1228.6,-899.7,12.27,52,4,"Loja de Departamento",0.5 }

	Blips[#Blips+1] = { 1702.78,3748.82,34.05,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { 240.06,-43.74,69.71,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { 843.95,-1020.43,27.53,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { -322.19,6072.86,31.27,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { -664.03,-949.22,21.53,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { -1318.83,-389.19,36.43,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { -1110.11,2687.5,18.62,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { 2569.23,309.46,108.46,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { -3159.91,1080.64,20.69,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { 15.42,-1120.47,28.81,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { 811.81,-2145.58,29.34,76,4,"Loja de Armas",0.5 }


	Blips[#Blips+1] = { -815.12,-184.15,37.57,71,4,"Barbearia",0.5 }
	Blips[#Blips+1] = { 138.13,-1706.46,29.3,71,4,"Barbearia",0.5 }
	Blips[#Blips+1] = { -1280.92,-1117.07,7.0,71,4,"Barbearia",0.5 }
	Blips[#Blips+1] = { 1930.54,3732.06,32.85,71,4,"Barbearia",0.5 }
	Blips[#Blips+1] = { 1214.2,-473.18,66.21,71,4,"Barbearia",0.5 }
	Blips[#Blips+1] = { -33.61,-154.52,57.08,71,4,"Barbearia",0.5 }
	Blips[#Blips+1] = { -276.65,6226.76,31.7,71,4,"Barbearia",0.5 }

	
	Blips[#Blips+1] = { 86.06,-1391.64,29.23,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -719.94,-158.18,37.0,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -152.79,-306.79,38.67,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -816.39,-1081.22,11.12,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -1206.51,-781.5,17.12,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -1458.26,-229.79,49.2,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -2.41,6518.29,31.48,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { 1682.59,4819.98,42.04,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { 129.46,-205.18,54.51,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { 618.49,2745.54,42.01,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { 1197.93,2698.21,37.96,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -3165.74,1061.29,20.84,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -1093.76,2703.99,19.04,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { 414.86,-807.57,29.34,366,4,"Loja de Roupas",0.5 }
	
		
		-- { -1728.06,-1050.69,1.71,471,62,"Embarcações",0.5 }
	Blips[#Blips+1] = { 1966.36,3975.86,31.51,471,62,"Embarcações",0.5 }
	Blips[#Blips+1] = { -776.72,-1495.02,2.29,471,62,"Embarcações",0.5 }
	Blips[#Blips+1] = { -893.97,5687.78,3.29,471,62,"Embarcações",0.5 }
	Blips[#Blips+1] = { 4952.76,-5163.6,-0.3,471,62,"Embarcações",0.5 }
	Blips[#Blips+1] = { -1728.15,-1050.64,1.7,471,62,"Embarcações",0.5 }
	Blips[#Blips+1] = { -1622.55,-1167.98,1.45,471,62,"Embarcações",0.5 }


	Blips[#Blips+1] = { 591.17,2743.5,42.04,51,4,"Farmácia Clandestina",0.8 }
	Blips[#Blips+1] = { 45.95,3703.11,39.75,556,5,"Mercado Negro e Lavagem de Dinheiro",1.0 }

		
	Blips[#Blips+1] = { 1322.93,-1652.29,52.27,75,36,"Loja de Tatuagem",0.5 }
	Blips[#Blips+1] = { -1154.42,-1425.9,4.95,75,36,"Loja de Tatuagem",0.5 }
	Blips[#Blips+1] = { 322.84,180.16,103.58,75,36,"Loja de Tatuagem",0.5 }
	Blips[#Blips+1] = { -3169.62,1075.8,20.83,75,36,"Loja de Tatuagem",0.5 }
	Blips[#Blips+1] = { 1864.07,3747.9,33.03,75,36,"Loja de Tatuagem",0.5 }
	Blips[#Blips+1] = { -293.57,6199.85,31.48,75,36,"Loja de Tatuagem",0.5 }


	Blips[#Blips+1] = { 5323.13,-5238.68,32.76 ,539,36,"Cayo Perico",0.5 }
	Blips[#Blips+1] = { 5157.12,-5104.11,2.36 ,539,36,"Cayo Perico",0.5 }
	Blips[#Blips+1] = { 4930.78,-5146.1,2.48 ,539,36,"Cayo Perico",0.5 }
	Blips[#Blips+1] = { 4973.78,-5856.06,19.82 ,539,36,"Cayo Perico",0.5 }
	Blips[#Blips+1] = { 4936.15,-4900.87,3.62 ,539,36,"Cayo Perico",0.5 }
	Blips[#Blips+1] = { 4455.61,-4521.53,4.11 ,539,36,"Cayo Perico",0.5 }

	Blips[#Blips+1] = { 545.37,-194.68,54.44,488,5,"Mecânica",0.8 } -- Mecanica
	Blips[#Blips+1] = { -236.08,6331.21,32.33,80,5,"Hospital",0.5 } -- HP NORTE
	Blips[#Blips+1] = { 2567.58,-358.4,92.99,487,5,"Departamento Policial",1.0 } -- dp principal
	Blips[#Blips+1] = { -825.44,-1220.28,6.93,487,5,"Departamento Policial",1.0 } -- Tatica
	-- Blips[#Blips+1] = { -831.85,-1215.67,6.94,487,5,"Departamento Policial",1.0 } -- Tatica
	Blips[#Blips+1] = { 2613.75,5280.4,70.6,487,5,"Prf",1.0 } -- prf
	Blips[#Blips+1] = { 120.69,-1317.15,28.93,436,5,"Vanilla +18",0.8 }
	-- Blips[#Blips+1] = { -1630.07,215.08,60.73,492,5,"Escolinha Nobre",1.0 } -- Escolinha
	Blips[#Blips+1] = { -518.0,-251.84,140.83,385,5,"Juridico",1.0 }
	-- Blips[#Blips+1] = { -3188.88,-1145.31,7.82,436,5,"Ilha da Revoada",0.8 }
	Blips[#Blips+1] = { 3050.88,-4706.21,15.27,575,47,"Porta-Aviões",1.0 }
	Blips[#Blips+1] = { -258.34,-2024.09,86.61,785,47,"Grande Arena",1.0 }


elseif cityName == "Fronteira" then
	Blips[#Blips+1] = { 55.43,-876.19,30.66,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 598.04,2741.27,42.07,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -136.36,6357.03,31.49,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 275.23,-345.54,45.17,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 596.40,90.65,93.12,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -340.76,265.97,85.67,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -2030.01,-465.97,11.60,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -1184.92,-1510.00,4.64,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 214.02,-808.44,31.01,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -348.88,-874.02,31.31,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 67.74,12.27,69.21,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 361.90,297.81,103.88,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 1035.89,-763.89,57.99,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -796.63,-2022.77,9.16,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 453.27,-1146.76,29.52,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 528.66,-146.3,58.38,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -1159.48,-739.32,19.89,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 101.22,-1073.68,29.38,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 1725.21,4711.77,42.11,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { 1624.05,3566.14,35.15,539,4,"Garagem",0.4 }
	Blips[#Blips+1] = { -73.35,-2004.6,18.27,539,4,"Garagem",0.4 }
		
		-- ILHAS
		
		-- { 5053.84,-4624.94,2.76 ,384,47,"Ilha Cayo Perico",1.0 }
		
		-- PONTOS CENTRAIS
	Blips[#Blips+1] = { 178.54,-982.15,29.64,266,5,"Praça Central",1.0 }	
	Blips[#Blips+1] = { -1610.53,-1011.25,13.02,266,5,"Pier Sul",1.0 }
	Blips[#Blips+1] = { 1428.78,6490.94,20.34,266,5,"Pier Norte",0.8 }		
	Blips[#Blips+1] = { 1692.35,3595.79,42.99,106,49,"Bombeiros",0.7 }
	Blips[#Blips+1] = { 1098.57,-894.22,51.17,106,49,"Bombeiros",0.7 }
	Blips[#Blips+1] = { 1046.64,2300.27,44.82,108,5,"Local de Farm",0.7 }
	Blips[#Blips+1] = { 134.06,-3088.0,8.21,108,5,"Local de Farm",0.7 }
	Blips[#Blips+1] = { 118.66,-1087.29,29.22,587,2,"Baú Pessoal (Grátis)",0.5 }			
	Blips[#Blips+1] = { 1420.9,6564.6,18.53,587,2,"Baú Pessoal (Grátis)",0.5 }		
	Blips[#Blips+1] = { 1860.07,2608.29,45.66,188,1,"Prisão",1.5 }

	Blips[#Blips+1] = { -444.09,6001.79,44.01,487,5,"Departamento Policial",1.0 }
	Blips[#Blips+1] = { 1152.97,-1526.05,34.85,80,5,"Hospital",0.5 } -- hp principal

	Blips[#Blips+1] = { -70.49,-1104.59,26.12,225,5,"Concessionária",0.8 }
	Blips[#Blips+1] = { 229.77,214.17,105.55,431,5,"Banco Central",0.8 }
		
	Blips[#Blips+1] = { -2329.46,3266.47,32.82,487,5,"Forte Zancudo",1.0 }
	Blips[#Blips+1] = { 501.59,5604.47,797.91,164,5,"Monte Chiliad",1.0 }
	Blips[#Blips+1] = { -174.42,-2147.11,16.7,409,5,"Kartódromo",0.8 }
	Blips[#Blips+1] = { -1627.64,-3099.74,13.93,184,5,"Estúdio de Fotográfia",0.8 }	
	Blips[#Blips+1] = { -1256.65,-3356.17,13.93,184,5,"Estúdio de Fotográfia",0.8 }
		
		-- { 2380.24,5094.35,47.35,285,3,"Emprego | Lenhador",0.5 }
	Blips[#Blips+1] = { 2515.56,4763.37,34.76,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { 2953.93,2787.49,41.5,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { 1418.79,6715.32,14.37,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { 453.82,-600.6,28.58,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { 751.71,6459.04,31.53,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { 2093.65,5044.13,41.18,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { -19.92,6304.38,31.37,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { -406.04,6148.4,31.68,108,3,"Emprego Legal",0.7 }
	Blips[#Blips+1] = { -1471.72,-920.16,10.03,108,3,"Emprego Legal",0.7 }

	Blips[#Blips+1] = { -428.56,-1728.33,19.79,365,3,"Loja | Reciclagem",0.8 }
	Blips[#Blips+1] = { 29.2,-1351.89,29.34,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 2561.74,385.22,108.61,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 1160.21,-329.4,69.03,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -711.99,-919.96,19.01,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -54.56,-1758.56,29.05,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 375.87,320.04,103.42,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -3237.48,1004.72,12.45,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 1730.64,6409.67,35.0,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 543.51,2676.85,42.14,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 1966.53,3737.95,32.18,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 2684.73,3281.2,55.23,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 1696.12,4931.56,42.07,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -1820.18,785.69,137.98,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 1395.35,3596.6,34.86,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -2977.14,391.22,15.03,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -3034.99,590.77,7.8,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 1144.46,-980.74,46.19,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { 1166.06,2698.17,37.95,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -1493.12,-385.55,39.87,52,4,"Loja de Departamento",0.5 }
	Blips[#Blips+1] = { -1228.6,-899.7,12.27,52,4,"Loja de Departamento",0.5 }

	Blips[#Blips+1] = { 1702.78,3748.82,34.05,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { 240.06,-43.74,69.71,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { 843.95,-1020.43,27.53,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { -322.19,6072.86,31.27,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { -664.03,-949.22,21.53,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { -1318.83,-389.19,36.43,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { -1110.11,2687.5,18.62,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { 2569.23,309.46,108.46,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { -3159.91,1080.64,20.69,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { 15.42,-1120.47,28.81,76,4,"Loja de Armas",0.5 }
	Blips[#Blips+1] = { 811.81,-2145.58,29.34,76,4,"Loja de Armas",0.5 }


	Blips[#Blips+1] = { -815.12,-184.15,37.57,71,4,"Barbearia",0.5 }
	Blips[#Blips+1] = { 138.13,-1706.46,29.3,71,4,"Barbearia",0.5 }
	Blips[#Blips+1] = { -1280.92,-1117.07,7.0,71,4,"Barbearia",0.5 }
	Blips[#Blips+1] = { 1930.54,3732.06,32.85,71,4,"Barbearia",0.5 }
	Blips[#Blips+1] = { 1214.2,-473.18,66.21,71,4,"Barbearia",0.5 }
	Blips[#Blips+1] = { -33.61,-154.52,57.08,71,4,"Barbearia",0.5 }
	Blips[#Blips+1] = { -276.65,6226.76,31.7,71,4,"Barbearia",0.5 }

	
	Blips[#Blips+1] = { 86.06,-1391.64,29.23,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -719.94,-158.18,37.0,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -152.79,-306.79,38.67,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -816.39,-1081.22,11.12,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -1206.51,-781.5,17.12,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -1458.26,-229.79,49.2,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -2.41,6518.29,31.48,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { 1682.59,4819.98,42.04,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { 129.46,-205.18,54.51,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { 618.49,2745.54,42.01,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { 1197.93,2698.21,37.96,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -3165.74,1061.29,20.84,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { -1093.76,2703.99,19.04,366,4,"Loja de Roupas",0.5 }
	Blips[#Blips+1] = { 414.86,-807.57,29.34,366,4,"Loja de Roupas",0.5 }
	
		
		-- { -1728.06,-1050.69,1.71,471,62,"Embarcações",0.5 }
	Blips[#Blips+1] = { 1966.36,3975.86,31.51,471,62,"Embarcações",0.5 }
	Blips[#Blips+1] = { -776.72,-1495.02,2.29,471,62,"Embarcações",0.5 }
	Blips[#Blips+1] = { -893.97,5687.78,3.29,471,62,"Embarcações",0.5 }
	Blips[#Blips+1] = { 4952.76,-5163.6,-0.3,471,62,"Embarcações",0.5 }
	Blips[#Blips+1] = { -1728.15,-1050.64,1.7,471,62,"Embarcações",0.5 }
	Blips[#Blips+1] = { -1622.55,-1167.98,1.45,471,62,"Embarcações",0.5 }


	Blips[#Blips+1] = { 591.17,2743.5,42.04,51,4,"Farmácia Clandestina",0.8 }
	Blips[#Blips+1] = { 45.95,3703.11,39.75,556,5,"Mercado Negro e Lavagem de Dinheiro",1.0 }

		
	Blips[#Blips+1] = { 1322.93,-1652.29,52.27,75,36,"Loja de Tatuagem",0.5 }
	Blips[#Blips+1] = { -1154.42,-1425.9,4.95,75,36,"Loja de Tatuagem",0.5 }
	Blips[#Blips+1] = { 322.84,180.16,103.58,75,36,"Loja de Tatuagem",0.5 }
	Blips[#Blips+1] = { -3169.62,1075.8,20.83,75,36,"Loja de Tatuagem",0.5 }
	Blips[#Blips+1] = { 1864.07,3747.9,33.03,75,36,"Loja de Tatuagem",0.5 }
	Blips[#Blips+1] = { -293.57,6199.85,31.48,75,36,"Loja de Tatuagem",0.5 }


	Blips[#Blips+1] = { 5323.13,-5238.68,32.76 ,539,36,"Cayo Perico",0.5 }
	Blips[#Blips+1] = { 5157.12,-5104.11,2.36 ,539,36,"Cayo Perico",0.5 }
	Blips[#Blips+1] = { 4930.78,-5146.1,2.48 ,539,36,"Cayo Perico",0.5 }
	Blips[#Blips+1] = { 4973.78,-5856.06,19.82 ,539,36,"Cayo Perico",0.5 }
	Blips[#Blips+1] = { 4936.15,-4900.87,3.62 ,539,36,"Cayo Perico",0.5 }
	Blips[#Blips+1] = { 4455.61,-4521.53,4.11 ,539,36,"Cayo Perico",0.5 }

	Blips[#Blips+1] = { -1072.9,-2065.83,13.29,488,5,"Mecânica",0.8 } -- Mecanica
	Blips[#Blips+1] = { -236.08,6331.21,32.33,80,5,"Hospital",0.5 } -- HP NORTE
	Blips[#Blips+1] = { 2567.58,-358.4,92.99,487,5,"Departamento Policial",1.0 } -- dp principal
	Blips[#Blips+1] = { -825.44,-1220.28,6.93,487,5,"Departamento Policial",1.0 } -- Tatica
	-- Blips[#Blips+1] = { -831.85,-1215.67,6.94,487,5,"Departamento Policial",1.0 } -- Tatica
	Blips[#Blips+1] = { 2613.75,5280.4,70.6,487,5,"Prf",1.0 } -- prf
	Blips[#Blips+1] = { 120.69,-1317.15,28.93,436,5,"Vanilla +18",0.8 }
	-- Blips[#Blips+1] = { -1630.07,215.08,60.73,492,5,"Escolinha Nobre",1.0 } -- Escolinha
	Blips[#Blips+1] = { -518.0,-251.84,140.83,385,5,"Juridico",1.0 }
	-- Blips[#Blips+1] = { -3188.88,-1145.31,7.82,436,5,"Ilha da Revoada",0.8 }
	Blips[#Blips+1] = { 3050.88,-4706.21,15.27,575,47,"Porta-Aviões",1.0 }
	Blips[#Blips+1] = { -258.34,-2024.09,86.61,785,47,"Grande Arena",1.0 }

	
end

	

	


-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
local NormalStamina = {
    ["Rise"] = true,
    ["Real"] = true,
	["Fronteira"] = true,
}

CreateThread(function()
	while true do
		-- SetPlayerTargetingMode( 2 )
		InvalidateIdleCam()
		InvalidateVehicleIdleCam()

		SetCreateRandomCops(false)
		CancelCurrentPoliceReport()
        if not NormalStamina[cityName] then
		    RestorePlayerStamina(PlayerId(),1.0)
        end
		SetCreateRandomCopsOnScenarios(false)
		SetCreateRandomCopsNotOnScenarios(false)

		SetPedInfiniteAmmoClip(PlayerPedId(),false)

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
-- Slow thread: ops that don't need per-frame
local isPedArmed = false
CreateThread(function()
	while true do
		DisablePlayerVehicleRewards(PlayerId())
		SetPauseMenuActive(false)
		isPedArmed = IsPedArmed(PlayerPedId(), 6)
		Wait(500)
	end
end)

-- Single per-frame thread: all DisableControlAction + HideHudComponent calls
CreateThread(function()
    while true do
		DisableControlAction(1,37,true)
		DisableControlAction(1,204,true)
		DisableControlAction(1,211,true)
		DisableControlAction(1,349,true)
		DisableControlAction(1,192,true)
		DisableControlAction(1,157,true)
		DisableControlAction(1,158,true)
		DisableControlAction(1,159,true)
		DisableControlAction(1,160,true)
		DisableControlAction(1,161,true)
		DisableControlAction(1,162,true)
		DisableControlAction(1,163,true)
		DisableControlAction(1,164,true)
		DisableControlAction(1,165,true)

		if isPedArmed then
			DisableControlAction(1,140,true)
			DisableControlAction(1,141,true)
			DisableControlAction(1,142,true)
		end

		HideHudComponentThisFrame(1)
		HideHudComponentThisFrame(2)
		HideHudComponentThisFrame(3)
		HideHudComponentThisFrame(4)
		HideHudComponentThisFrame(5)
		HideHudComponentThisFrame(6)
		HideHudComponentThisFrame(7)
		HideHudComponentThisFrame(8)
		HideHudComponentThisFrame(9)
		HideHudComponentThisFrame(10)
		HideHudComponentThisFrame(11)
		HideHudComponentThisFrame(12)
		HideHudComponentThisFrame(13)
		HideHudComponentThisFrame(15)
		HideHudComponentThisFrame(17)
		HideHudComponentThisFrame(18)
		HideHudComponentThisFrame(19)
		HideHudComponentThisFrame(20)
		HideHudComponentThisFrame(21)
		HideHudComponentThisFrame(22)

        Wait(0)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TELEPORT
-----------------------------------------------------------------------------------------------------------------------------------------
local Teleport = {
	-- Jornal
	{ -1078.33,-254.82,37.76,-1072.58,-246.19,54.0 },
	{ -1072.58,-246.19,54.0,-1078.33,-254.82,37.76 },

	{ 330.19,-601.21,43.29,343.65,-581.77,28.8 },
	{ 343.65,-581.77,28.8,330.19,-601.21,43.29 },

	{ 327.16,-603.53,43.29,338.97,-583.85,74.16 },
	{ 338.97,-583.85,74.16,327.16,-603.53,43.29 },

	{ -741.07,5593.13,41.66,446.19,5568.79,781.19 },
	{ 446.19,5568.79,781.19,-741.07,5593.13,41.66 },

	{ -740.78,5597.04,41.66,446.37,5575.02,781.19 },
	{ 446.37,5575.02,781.19,-740.78,5597.04,41.66 },

	{ -1194.46,-1189.31,7.69,1173.55,-3196.68,-39.00 },
	{ 1173.55,-3196.68,-39.00,-1194.46,-1189.31,7.69 },

	{ -1007.12,-486.67,39.97,-1003.05,-477.92,50.02 },
	{ -1003.05,-477.92,50.02,-1007.12,-486.67,39.97 },

	{ -1908.09,-570.9,22.97,-1902.05,-572.42,19.09 },
	{ -1902.05,-572.42,19.09,-1908.09,-570.9,22.97 },

	-- { -71.05,-801.01,44.23,-75.0,-824.54,321.29 },
	-- { -75.0,-824.54,321.29,-71.05,-801.01,44.23 },

	{ 236.23,229.27,97.11,234.24,229.94,97.11 },
	{ 234.24,229.94,97.11,236.23,229.27,97.11 },
	-- -- Mecanica
	-- { -687.12,-778.36,31.53,-691.14,-755.15,34.59 },
	-- { -691.14,-755.15,34.59,-687.12,-778.36,31.53 },
	-- dp zancudo
	{ -2360.55,3249.61,32.81,-2360.88,3249.5,92.89 },
	{ -2360.88,3249.5,92.89,-2360.55,3249.61,32.81 },
	-- dp paleto
	{ -450.09,6010.5,32.28,-449.2,6009.12,36.99 },
	{ -449.2,6009.12,36.99,-450.09,6010.5,32.28 },
	-- hospital
	-- { -1844.65,-343.56,49.44,-1871.43,-311.03,58.15 },
	-- { -1871.43,-311.03,58.15,-1844.65,-343.56,49.44 },
	-- bellagio
	{ 974.59,12.85,81.03,960.84,22.28,111.28 },
	{ 960.84,22.28,111.28,974.59,12.85,81.03 },
	-- luxor
	{ -321.08,209.65,81.77,-303.75,192.27,144.37 },
	{ -303.75,192.27,144.37,-321.08,209.65,81.77 },
	-- dp terceiro andar
	{ 2504.42,-342.0,94.09,2504.4,-342.02,101.89 },
	{ 2504.4,-342.02,101.89,2504.42,-342.0,94.09 },
	-- dp quarto andar
	{ 2497.19,-349.58,94.09,2504.18,-342.22,105.68 },
	{ 2504.18,-342.22,105.68,2497.19,-349.58,94.09 },
	-- dp quarto andar
	{ 2504.66,-433.01,99.11,2504.67,-433.12,106.91 },
	{ 2504.67,-433.12,106.91,2504.66,-433.01,99.11 },
	-- dp andar 3 pro 4
	{ 2497.36,-349.54,105.68,2497.32,-349.12,101.89 },
	{ 2497.32,-349.12,101.89,2497.36,-349.54,105.68 },
	-- mecanica
	-- { 841.82,-990.67,26.49,914.89,-946.68,59.09 },
	-- { 914.89,-946.68,59.09,841.82,-990.67,26.49 },


	{ 330.15,-601.24,43.29,339.25,-584.71,74.17 },
	{ 339.25,-584.71,74.17,330.15,-601.24,43.29 },

    {-1471.5,-920.37,10.03,2157.93,2921.08,-81.25},
    {2157.93,2921.08,-81.25,-1471.5,-920.37,10.03},

	{ -782.76,-2587.91,13.58,-788.67,-2628.71,13.95 },
	{ -788.67,-2628.71,13.95,-782.76,-2587.91,13.58 },
	-- mansão 31
	{ -305.07,-721.25,28.02,-288.19,-722.55,125.46 },
	{ -288.19,-722.55,125.46,-305.07,-721.25,28.02 },
	-- mansão 56
	{ -1993.01,-229.18,34.93,-1983.0,-223.46,84.96 },
	{ -1983.0,-223.46,84.96,-1993.01,-229.18,34.93 },

	-- { -1649.22,-994.53,13.01,1420.32,6689.9,14.37 },
	-- { 1420.32,6689.9,14.37,-1649.22,-994.53,13.01 },

	-- mecanica
	{ 839.5,-986.95,26.49,912.1,-945.74,59.09 },
	{ 912.1,-945.74,59.09,839.5,-986.95,26.49 },
	-- pier sul para norte
	-- { -1620.59,-955.84,13.01,1424.17,6687.17,14.47  },
	-- { 1424.17,6687.17,14.47,-1620.59,-955.84,13.01 },
	-- vanilla
	{ 118.63,-1262.0,22.8,129.95,-1282.8,-84.22 },
	{ 129.95,-1282.8,-84.22,118.63,-1262.0,22.8 },
	-- aircraft
	{ 1129.51,-1304.98,34.73,3079.64,-4705.54,15.25 },
	{ 3079.64,-4705.54,15.25,1129.51,-1304.98,34.73 },


	{ 1122.4,-1304.61,34.71,3100.96,-4815.91,2.04 },
	{ 3100.96,-4815.91,2.04,1122.4,-1304.61,34.71 },
	-- mansao68
	{ -814.44,-696.25,28.05,-813.74,-683.44,123.42 },
	{ -813.74,-683.44,123.42,-814.44,-696.25,28.05 },
	-- criação personagem pier
	{ 565.63,-427.62,-69.66, -1631.72,-1113.94,13.02 },
	-- { -1607.34,-1054.6,13.01,565.63,-427.62,-69.66 },
	-- pier > dp
	{ -1839.38,-1210.11,13.01,2564.8,-438.35,92.99 },
	-- pier > hp
	{ -1844.36,-1211.63,13.01,1148.52,-1523.64,34.85 },
	-- pier > mecanica
	{ -1833.62,-1213.23,13.01,829.13,-995.93,26.62 },
	
}

if cityName == "Santa" then
	Teleport[#Teleport+1] = { -1160.34,-1221.52,6.96,1673.57,3594.04,35.59 }
	Teleport[#Teleport+1] = { 1673.57,3594.04,35.59,-1160.34,-1221.52,6.96 }

	Teleport[#Teleport+1] = { 4634.6,-4793.89,12.23,4993.57,-5708.76,20.08 }
	Teleport[#Teleport+1] = { 4993.57,-5708.76,20.08,4634.6,-4793.89,12.23 }

	Teleport[#Teleport+1] = { -3203.28,846.59,8.94,796.04,1833.77,140.39 }
	Teleport[#Teleport+1] = { 796.04,1833.77,140.39,-3203.28,846.59,8.94 }

	Teleport[#Teleport+1] = { -343.90,-594.80,37.34,-329.97,-611.49,47.98 } -- hp
	Teleport[#Teleport+1] = { -329.97,-611.49,47.98,-343.90,-594.80,37.34 }

	Teleport[#Teleport+1] = { -304.62,-590.82,32.78,-304.93,-590.59,37.34 } -- hp
	Teleport[#Teleport+1] = { -304.93,-590.59,37.34,-304.62,-590.82,32.78 }

	Teleport[#Teleport+1] = { -331.96,-608.61,32.78,-333.01,-606.99,41.05 } -- hp
	Teleport[#Teleport+1] = { -333.01,-606.99,41.05,-331.96,-608.61,32.78 }

	Teleport[#Teleport+1] = { -349.51,-607.77,32.78, -280.83,6317.76,32.47 } -- hp	
	Teleport[#Teleport+1] = { -280.83,6317.76,32.47, -349.51,-607.77,32.78 }

	Teleport[#Teleport+1] = { -71.05,-801.01,44.23,-75.0,-824.54,321.29 }
	Teleport[#Teleport+1] = { -75.0,-824.54,321.29,-71.05,-801.01,44.23 }

	Teleport[#Teleport+1] = { 876.36,-1353.39,26.32,-450.18,6010.30,27.58 }
	Teleport[#Teleport+1] = { -450.18,6010.30,27.58,876.36,-1353.39,26.32 }

	Teleport[#Teleport+1] = { 2539.88,-335.57,94.32,1828.38,2553.01,45.89 }
	Teleport[#Teleport+1] = { 1828.38,2553.01,45.89,2539.88,-335.57,94.32 }

	Teleport[#Teleport+1] = { -1565.35,-409.68,48.26,-1542.93,-447.54,35.92 } -- QG_27
	Teleport[#Teleport+1] = { -1542.93,-447.54,35.92,-1565.35,-409.68,48.26 }

	Teleport[#Teleport+1] = { -2737.40,-184.40,17.32, -2658.55,-116.23,19.54 }
	Teleport[#Teleport+1] = { -2658.55,-116.23,19.54, -2737.40,-184.40,17.32 }

	Teleport[#Teleport+1] = { -1523.6,337.73,86.29, -1535.43,361.4,178.79 } -- QG_11
	Teleport[#Teleport+1] = { -1535.43,361.4,178.79, -1523.6,337.73,86.29 }

	-- Teleport[#Teleport+1] = { -2598.77,1885.22,167.27, -2597.18,1916.87,171.68 } -- QG_366
	-- Teleport[#Teleport+1] = { -2597.18,1916.87,171.68, -2598.77,1885.22,167.27 }

	Teleport[#Teleport+1] = { -1532.35,307.36,83.36, -1613.13,430.35,108.59 } -- QG_11
	Teleport[#Teleport+1] = { -1613.13,430.35,108.59, -1532.35,307.36,83.36 }

	Teleport[#Teleport+1] = { -2003.07,-2115.19,22.54,-1925.68,-2168.41,145.45 } -- QG_370
	Teleport[#Teleport+1] = { -1925.68,-2168.41,145.45,-2003.07,-2115.19,22.54 }

	Teleport[#Teleport+1] = { -2031.69,-2131.3,27.72,-2133.4,-2610.1,6.27 } -- QG_370
	Teleport[#Teleport+1] = { -2133.4,-2610.1,6.27,-2031.69,-2131.3,27.72 }

	Teleport[#Teleport+1] = { 2653.67,1822.13,32.79,2795.23,2050.86,230.03 } 
	Teleport[#Teleport+1] = { 2795.23,2050.86,230.03,2653.67,1822.13,32.79 } -- QG_210
	
	Teleport[#Teleport+1] = { -2374.85,1777.09,212.13, -2493.73,1848.10,175.56 }
	Teleport[#Teleport+1] = { -2493.73,1848.10,175.56, -2374.85,1777.09,212.13 }

	Teleport[#Teleport+1] = { -2276.27,346.93,174.60, -2268.53,378.72,188.76 }
	Teleport[#Teleport+1] = { -2268.53,378.72,188.76, -2276.27,346.93,174.60 }

	Teleport[#Teleport+1] = { -3110.43,1531.68,37.28,1269.87,-295.46,87.53 }
	Teleport[#Teleport+1] = { 1269.87,-295.46,87.53,-3110.43,1531.68,37.28 }

	Teleport[#Teleport+1] = { -1206.61,483.42,92.86, -1204.2,490.2,98.79 }
	Teleport[#Teleport+1] = { -1204.2,490.2,98.79, -1206.61,483.42,92.86 }

	Teleport[#Teleport+1] = { -3007.12,2181.75,41.55, -3140.89,2142.18,6.53 }
	Teleport[#Teleport+1] = { -3140.89,2142.18,6.53, -3007.12,2181.75,41.55 }

	Teleport[#Teleport+1] = { 2475.8,-384.09,94.39,-2172.51,3255.95,32.81 }
	Teleport[#Teleport+1] = { -2172.51,3255.95,32.81,2475.8,-384.09,94.39 }

	Teleport[#Teleport+1] = { 1267.34,-296.30,84.59, -2996.99,2174.76,45.19 }
	Teleport[#Teleport+1] = { -2996.99,2174.76,45.19, 1267.34,-296.30,84.59 }

	Teleport[#Teleport+1] = { 868.04,-2130.44,30.58,881.72,-2129.42,40.15 }
	Teleport[#Teleport+1] = { 881.72,-2129.42,40.15,868.04,-2130.44,30.58 }

	Teleport[#Teleport+1] = { 3479.4,5127.01,9.69,-452.38,1579.64,360.86 }
	Teleport[#Teleport+1] = { -452.38,1579.64,360.86,3479.4,5127.01,9.69 }

	Teleport[#Teleport+1] = { -3302.25,-1221.4,8.16,148.94,-1956.02,20.81 }
	Teleport[#Teleport+1] = { 148.94,-1956.02,20.81,-3302.25,-1221.4,8.16 }

	Teleport[#Teleport+1] = { -2208.90,3316.47,34.72,-743.36,-1241.93,5.70 }
	Teleport[#Teleport+1] = { -743.36,-1241.93,5.70,-2208.90,3316.47,34.72 }

	Teleport[#Teleport+1] = { 417.41,-10.61,99.65,418.86,-3.97,160.40 }
	Teleport[#Teleport+1] = { 418.86,-3.97,160.40,417.41,-10.61,99.65 }

	Teleport[#Teleport+1] = { 3740.18,4594.85,23.30,3735.7,4583.35,73.33 }
	Teleport[#Teleport+1] = { 3735.7,4583.35,73.33,3740.18,4594.85,23.30 }

	Teleport[#Teleport+1] = { -3835.23,336.13,22.24,-3856.74,337.81,101.73 }
	Teleport[#Teleport+1] = { -3856.74,337.81,101.73,-3835.23,336.13,22.24 }

	Teleport[#Teleport+1] = { -3624.93,204.21,22.23,-3615.02,205.75,88.29 }
	Teleport[#Teleport+1] = { -3615.02,205.75,88.29,-3624.93,204.21,22.23 }

	Teleport[#Teleport+1] = { -589.89,-911.88,23.88,-568.78,-927.78,36.83 }
	Teleport[#Teleport+1] = { -568.78,-927.78,36.83,-589.89,-911.88,23.88 }

	Teleport[#Teleport+1] = { -3787.41,263.59,22.82,-3795.88,284.93,155.54 }
	Teleport[#Teleport+1] = { -3795.88,284.93,155.54,-3787.41,263.59,22.82 }

	Teleport[#Teleport+1] = { -3787.41,270.43,22.81,-3787.31,249.21,29.67 }
	Teleport[#Teleport+1] = { -3787.31,249.21,29.67,-3787.41,270.43,22.81 }

	Teleport[#Teleport+1] = { 3576.11,-3246.50,2.76,-2195.43,-278.33,39.70 }
	Teleport[#Teleport+1] = { -2195.43,-278.33,39.70,3576.11,-3246.50,2.76 }
	
	-- outlaws
	Teleport[#Teleport+1] = { -783.03,-2587.87,13.58,-746.69,-2562.98,13.93 }
	Teleport[#Teleport+1] = { -746.69,-2562.98,13.93,-783.03,-2587.87,13.58 }

	Teleport[#Teleport+1] = { -117.14,503.54,142.88,-125.38,493.21,137.03 }
	Teleport[#Teleport+1] = { -125.38,493.21,137.03,-117.14,503.54,142.88 }

	Teleport[#Teleport+1] = { -2221.96,-268.03,46.33,-2052.62,-142.26,26.85 }
	Teleport[#Teleport+1] = { -2052.62,-142.26,26.85,-2221.96,-268.03,46.33 }

	Teleport[#Teleport+1] = { -917.38,-1526.04,5.18,-920.55,-1516.31,17.98 }
	Teleport[#Teleport+1] = { -920.55,-1516.31,17.98,-917.38,-1526.04,5.18 }

	Teleport[#Teleport+1] = { -121.33,-503.30,-117.70,125.11,-115.43,49.77 }
	Teleport[#Teleport+1] = { 125.11,-115.43,49.77,-121.33,-503.30,-117.70 }

	-- favela PK
	Teleport[#Teleport+1] = { -468.76,1553.52,393.24,-456.46,1539.57,407.24 }
	Teleport[#Teleport+1] = { -456.46,1539.57,407.24,-468.76,1553.52,393.24 }
	-- cassino
	Teleport[#Teleport+1] = { 945.46,47.44,80.29,965.15,58.45,112.56 }
	Teleport[#Teleport+1] = { 965.15,58.45,112.56,945.46,47.44,80.29 }

	Teleport[#Teleport+1] = { 2540.01,-432.47,94.11,865.32,-1337.53,26.3 }
	Teleport[#Teleport+1] = { 865.32,-1337.53,26.3,2540.01,-432.47,94.11 }

	-- hp
	Teleport[#Teleport+1] = { 1120.36,-1533.29,34.85,1144.0,-1534.7,48.14 }
	Teleport[#Teleport+1] = { 1144.0,-1534.7,48.14,1120.36,-1533.29,34.85 }
	-- Callisto
	Teleport[#Teleport+1] = { 380.02,-14.99,83.0,414.89,-15.38,99.65 }
	Teleport[#Teleport+1] = { 414.89,-15.38,99.65,380.02,-14.99,83.0 }

	Teleport[#Teleport+1] = { 2539.77,-432.71,94.31,-464.47,6004.16,31.49 }
	Teleport[#Teleport+1] = { -464.47,6004.16,31.49,2539.77,-432.71,94.31 }

	Teleport[#Teleport+1] = { 2477.13,-366.36,94.81,-970.21,-2062.24,9.4 }
	Teleport[#Teleport+1] = { -970.21,-2062.24,9.4,2477.13,-366.36,94.81 }

	Teleport[#Teleport+1] = { -435.08,5983.92,31.49,-941.14,-2033.78,9.54 }
	Teleport[#Teleport+1] = { -941.14,-2033.78,9.54,-435.08,5983.92,31.49 }

	Teleport[#Teleport+1] = { 2477.02,-401.74,94.81,2645.78,5282.87,47.26 }
	Teleport[#Teleport+1] = { 2645.78,5282.87,47.26,2477.02,-401.74,94.81 }
	
	Teleport[#Teleport+1] = { -410.13,1583.98,357.22,-77.43,1528.62,286.14 }
	Teleport[#Teleport+1] = { -77.43,1528.62,286.14,-410.13,1583.98,357.22 }

	Teleport[#Teleport+1] = { -408.73,1561.8,356.56,-400.12,1537.46,381.23 }
	Teleport[#Teleport+1] = { -400.12,1537.46,381.23,-408.73,1561.8,356.56 }

	Teleport[#Teleport+1] = { -291.16,1917.0,165.3,-349.5,1883.7,194.48 }
	Teleport[#Teleport+1] = { -349.5,1883.7,194.48,-291.16,1917.0,165.3 }

	Teleport[#Teleport+1] = { -796.05,336.95,85.70,-768.91,336.81,243.38 }
	Teleport[#Teleport+1] = { -768.91,336.81,243.38,-796.05,336.95,85.70 }

	Teleport[#Teleport+1] = { -621.19,-108.65,38.15,-379.43,6117.96,31.85 }
	Teleport[#Teleport+1] = { -379.43,6117.96,31.85,-621.19,-108.65,38.15 }

	Teleport[#Teleport+1] = { 3887.98,-29.4,6.71,1759.43,2615.17,45.54 } -- Prisão / Alcatraz
	Teleport[#Teleport+1] = { 1759.43,2615.17,45.54,3887.98,-29.4,6.71 }

	Teleport[#Teleport+1] = { 2251.73,-920.47,221.24,2395.39,-878.29,135.2 }
	Teleport[#Teleport+1] = { 2395.39,-878.29,135.2,2251.73,-920.47,221.24 }

	Teleport[#Teleport+1] = { -837.62,175.61,70.53,851.95,1748.71,171.72 }
	Teleport[#Teleport+1] = { 851.95,1748.71,171.72,-837.62,175.61,70.53 }

	Teleport[#Teleport+1] = { 710.09,1235.94,361.14,2362.99,-970.69,154.28 }
	Teleport[#Teleport+1] = { 2362.99,-970.69,154.28,710.09,1235.94,361.14 }

elseif cityName == "Grande" then

	Teleport[#Teleport+1] = { -3270.35,-1160.25,7.85,-1838.7,424.99,118.37 }
	Teleport[#Teleport+1] = { -1838.7,424.99,118.37,-3270.35,-1160.25,7.85 }

	Teleport[#Teleport+1] = { 1066.51,-2392.85,-14.91,1022.41,-2432.16,22.07 }
	Teleport[#Teleport+1] = { 1022.41,-2432.16,22.07,1066.51,-2392.85,-14.91 }

	Teleport[#Teleport+1] = { -1439.44,-1766.71,14.34,-2242.24,-559.14,6.99 }
	Teleport[#Teleport+1] = { -2242.24,-559.14,6.99,-1439.44,-1766.71,14.34 }

	Teleport[#Teleport+1] = { -71.05,-801.01,44.23,-75.0,-824.54,321.29 }
	Teleport[#Teleport+1] = { -75.0,-824.54,321.29,-71.05,-801.01,44.23 }

	Teleport[#Teleport+1] = { 1828.61,2552.99,45.89,2477.26,-420.89,93.74 } -- prisional
	Teleport[#Teleport+1] = { 2477.26,-420.89,93.74,1828.61,2552.99,45.89 }

	Teleport[#Teleport+1] = { 923.77,-2530.41,28.41,929.74,-2520.1,78.45 }
	Teleport[#Teleport+1] = { 929.74,-2520.1,78.45,923.77,-2530.41,28.41 }

	Teleport[#Teleport+1] = { 2667.50,-430.72,120.43, -550.26,-204.97,47.55 }
	Teleport[#Teleport+1] = { -550.26,-204.97,47.55, 2667.50,-430.72,120.43 }

	Teleport[#Teleport+1] = { -2020.66,4459.01,57.27,-1956.03,4402.37,153.1 }
	Teleport[#Teleport+1] = { -1956.03,4402.37,153.1,-2020.66,4459.01,57.27 }

	Teleport[#Teleport+1] = { 2605.68,1814.25,32.35,-3362.22,553.44,12.23 }
	Teleport[#Teleport+1] = { -3362.22,553.44,12.23,2605.68,1814.25,32.35 }

	Teleport[#Teleport+1] = { -1538.03,155.4,56.11,1426.28,4727.33,134.97 }-- mansao50
	Teleport[#Teleport+1] = { 1426.28,4727.33,134.97,-1538.03,155.4,56.11 }

	Teleport[#Teleport+1] = { 2747.95,3463.89,55.74, 2743.43,3467.68,55.71 }
	Teleport[#Teleport+1] = { 2743.43,3467.68,55.71, 2747.95,3463.89,55.74 }

	Teleport[#Teleport+1] = { -414.13,1596.3,358.67,-2584.69,-2234.67,4.75 }
	Teleport[#Teleport+1] = { -2584.69,-2234.67,4.75,-414.13,1596.3,358.67 }
	
	Teleport[#Teleport+1] = { -343.90,-594.80,37.34,-329.97,-611.49,47.98 }
	Teleport[#Teleport+1] = { -329.97,-611.49,47.98,-343.90,-594.80,37.34 }

	Teleport[#Teleport+1] = { -304.62,-590.82,32.78,-304.93,-590.59,37.34 }
	Teleport[#Teleport+1] = { -304.93,-590.59,37.34,-304.62,-590.82,32.78 }

	Teleport[#Teleport+1] = { -331.96,-608.61,32.78,-333.01,-606.99,41.05 }
	Teleport[#Teleport+1] = { -333.01,-606.99,41.05,-331.96,-608.61,32.78 }

	Teleport[#Teleport+1] = { -349.51,-607.77,32.78, -280.83,6317.76,32.47 }
	Teleport[#Teleport+1] = { -280.83,6317.76,32.47, -349.51,-607.77,32.78 }

	Teleport[#Teleport+1] = { -1036.39,2811.24,23.70,-4496.26,-65.28,6.77 }
	Teleport[#Teleport+1] = { -4496.26,-65.28,6.77,-1036.39,2811.24,23.70 }

	Teleport[#Teleport+1] = { -344.28,1588.17,346.26, -3520.6,1302.95,7.55 }
	Teleport[#Teleport+1] = { -3520.6,1302.95,7.55, -344.28,1588.17,346.26 }

	Teleport[#Teleport+1] = { -450.11,1617.93,360.42,5030.22,-5760.46,15.75 }
	Teleport[#Teleport+1] = { 5030.22,-5760.46,15.75,-450.11,1617.93,360.42 }

	Teleport[#Teleport+1] = { 147.61,-357.82,44.94,-3766.61,4653.96,5.91 } -- mansao96
	Teleport[#Teleport+1] = { -3766.61,4653.96,5.91,147.61,-357.82,44.94 }

	Teleport[#Teleport+1] = { -1464.76,182.8,55.92,-1237.45,813.63,193.37 } 
	Teleport[#Teleport+1] = { -1237.45,813.63,193.37,-1464.76,182.8,55.92 }

	Teleport[#Teleport+1] = { -454.91,1589.45,360.20,-2795.04,6015.81,823.62 } -- QG_94
	Teleport[#Teleport+1] = { -2795.04,6015.81,823.62,-454.91,1589.45,360.20 }

	Teleport[#Teleport+1] = { -618.28,-109.62,38.15,1682.35,3593.41,35.59 }
	Teleport[#Teleport+1] = { 1682.35,3593.41,35.59,-618.28,-109.62,38.15 }

	Teleport[#Teleport+1] = { -410.47,1585.64,361.92,-395.8,1537.42,381.31 }
	Teleport[#Teleport+1] = { -395.8,1537.42,381.31,-410.47,1585.64,361.92 }

	Teleport[#Teleport+1] = { 2475.8,-384.09,94.39,-1902.07,2910.49,32.81 }
	Teleport[#Teleport+1] = { -1902.07,2910.49,32.81,2475.8,-384.09,94.39 }

	Teleport[#Teleport+1] = { 137.62,-362.32,50.34,-463.15,-1375.12,31.14 }
	Teleport[#Teleport+1] = { -463.15,-1375.12,31.14,137.62,-362.32,50.34 }

	Teleport[#Teleport+1] = { 1805.25,-2719.74,2.90,445.50,3562.33,33.24 }
	Teleport[#Teleport+1] = { 445.50,3562.33,33.24,1805.25,-2719.74,2.90 }

	Teleport[#Teleport+1] = { 864.83,3672.61,32.86,3099.51,5462.58,23.61 }
	Teleport[#Teleport+1] = { 3099.51,5462.58,23.61,864.83,3672.61,32.86 }

	Teleport[#Teleport+1] = { -1993.70,-510.48,12.33,-272.80,-1636.18,32.25 }
	Teleport[#Teleport+1] = { -272.80,-1636.18,32.25,-1993.70,-510.48,12.33 }

	Teleport[#Teleport+1] = { -2003.03,4486.11,57.29,-1947.34,4491.71,34.93 }
	Teleport[#Teleport+1] = { -1947.34,4491.71,34.93,-2003.03,4486.11,57.29 }

	Teleport[#Teleport+1] = { -272.91,6320.21,32.32,-271.23,6321.8,37.56 }
	Teleport[#Teleport+1] = { -271.23,6321.8,37.56,-272.91,6320.21,32.32 }

	Teleport[#Teleport+1] = { -2590.11,1921.41,167.40,-481.58,1607.32,375.10 } -- Mansao11
	Teleport[#Teleport+1] = { -481.58,1607.32,375.10,-2590.11,1921.41,167.40 } -- Mansao11

	Teleport[#Teleport+1] = { -339.98,-1523.09,27.74,-307.22,-1655.49,32.28 } -- QG_112
	Teleport[#Teleport+1] = { -307.22,-1655.49,32.28,-339.98,-1523.09,27.74 }

	Teleport[#Teleport+1] = { -2268.39,378.54,188.76,-2276.35,346.88,174.60 } 
	Teleport[#Teleport+1] = { -2276.35,346.88,174.60,-2268.39,378.54,188.76 }

	Teleport[#Teleport+1] = { 960.51,-962.70,42.95,931.32,-934.23,59.10 } 
	Teleport[#Teleport+1] = { 931.32,-934.23,59.10,960.51,-962.70,42.95 }

	Teleport[#Teleport+1] = { 1827.49,456.00,166.64,1618.79,446.85,253.23 } 
	Teleport[#Teleport+1] = { 1618.79,446.85,253.23,1827.49,456.00,166.64 }

	Teleport[#Teleport+1] = { -625.37,-127.22,36.02,-365.49,6102.72,35.44 } 
	Teleport[#Teleport+1] = { -365.49,6102.72,35.44,-625.37,-127.22,36.02 }

	Teleport[#Teleport+1] = { -2053.24,-142.08,26.85,-2200.24,-278.12,35.57 } 
	Teleport[#Teleport+1] = { -2200.24,-278.12,35.57,-2053.24,-142.08,26.85 }

	Teleport[#Teleport+1] = { -3949.56,-828.28,13.26,-3230.57,809.49,14.08 } 
	Teleport[#Teleport+1] = { -3230.57,809.49,14.08,-3949.56,-828.28,13.26 }

	Teleport[#Teleport+1] = { 1461.59,1086.94,114.33,807.12,3435.06,57.86 } 
	Teleport[#Teleport+1] = { 807.12,3435.06,57.86,1461.59,1086.94,114.33 }

	Teleport[#Teleport+1] = { -3184.32,817.73,8.93,-3949.57,-827.94,13.26 } 
	Teleport[#Teleport+1] = { -3949.57,-827.94,13.26,-3184.32,817.73,8.93 }

	Teleport[#Teleport+1] = { -1572.5,-394.52,59.14,-1566.93,-406.77,42.38 } 
	Teleport[#Teleport+1] = { -1566.93,-406.77,42.38,-1572.5,-394.52,59.14 }

	Teleport[#Teleport+1] = { -1581.21,374.54,98.66,2585.93,6147.9,162.92 }
	Teleport[#Teleport+1] = { 2585.93,6147.9,162.92,-1581.21,374.54,98.66 }

	Teleport[#Teleport+1] = { -770.54,309.17,85.7,-768.8,336.73,243.38 }
	Teleport[#Teleport+1] = { -768.8,336.73,243.38,-770.54,309.17,85.7 }

	Teleport[#Teleport+1] = { -3939.35,-832.10,13.26,-3082.61,3429.55,12.52 }
	Teleport[#Teleport+1] = { -3082.61,3429.55,12.52,-3939.35,-832.10,13.26 }

	Teleport[#Teleport+1] = { -325.66,-143.3,60.47,-334.02,-90.87,47.04 }
	Teleport[#Teleport+1] = { -334.02,-90.87,47.04,-325.66,-143.3,60.47 }

	Teleport[#Teleport+1] = { 3540.52,3675.41,28.12,3540.59,3675.34,20.99 }
	Teleport[#Teleport+1] = { 3540.59,3675.34,20.99,3540.52,3675.41,28.12 }

	Teleport[#Teleport+1] = { 1407.24,4706.69,140.27,-107.43,976.91,240.88 }
	Teleport[#Teleport+1] = { -107.43,976.91,240.88,1407.24,4706.69,140.27 }

	Teleport[#Teleport+1] = { -3227.44,-1221.46,7.84,-308.39,-1624.75,31.85 }
	Teleport[#Teleport+1] = { -308.39,-1624.75,31.85,-3227.44,-1221.46,7.84 }
	-- dp tatica
	Teleport[#Teleport+1] = { -786.48,-1212.63,6.86,-777.04,-1226.04,15.55 }
	Teleport[#Teleport+1] = { -777.04,-1226.04,15.55,-786.48,-1212.63,6.86 }

	Teleport[#Teleport+1] = { 2620.07,5364.66,47.3,2549.44,-314.94,93.1 }
	Teleport[#Teleport+1] = { 2549.44,-314.94,93.1,2620.07,5364.66,47.3 }

	Teleport[#Teleport+1] = { 2641.47,3617.21,110.08,2593.05,3633.85,-6.07 }
	Teleport[#Teleport+1] = { 2593.05,3633.85,-6.07,2641.47,3617.21,110.08 }

	Teleport[#Teleport+1] = { 2590.61,3657.68,-5.49,2349.64,3314.75,54.86 }
	Teleport[#Teleport+1] = { 2349.64,3314.75,54.86,2590.61,3657.68,-5.49 }
	-- dp zancudo
	Teleport[#Teleport+1] = { 2540.06,-432.42,94.12,-862.61,-1227.5,6.45 }
	Teleport[#Teleport+1] = { -862.61,-1227.5,6.45,2540.06,-432.42,94.12 }

	Teleport[#Teleport+1] = { 4890.18,-5454.87,33.72,259.56,-783.15,30.5 }
	Teleport[#Teleport+1] = { 259.56,-783.15,30.5,4890.18,-5454.87,33.72 }
	
	-- civil para militar
	Teleport[#Teleport+1] = { 2540.68,-336.10,94.12,-464.55,6004.32,31.49 }
	Teleport[#Teleport+1] = { -464.55,6004.32,31.49,2540.68,-336.10,94.12 }

	Teleport[#Teleport+1] = { -170.49,8250.23,12.82,-196.37,6566.81,11.14 }
	Teleport[#Teleport+1] = { -196.37,6566.81,11.14,-170.49,8250.23,12.82 }

	Teleport[#Teleport+1] = { -1799.1,-1327.99,7.18,1399.53,1496.56,113.87 }
	Teleport[#Teleport+1] = { 1399.53,1496.56,113.87,-1799.1,-1327.99,7.18 }

	Teleport[#Teleport+1] = { -2663.89,1298.76,147.44,-1788.01,427.84,122.63 }
	Teleport[#Teleport+1] = { -1788.01,427.84,122.63,-2663.89,1298.76,147.44 }

	Teleport[#Teleport+1] = { 1036.86,-2544.59,32.28,3481.69,5121.49,9.69 }
	Teleport[#Teleport+1] = { 3481.69,5121.49,9.69,1036.86,-2544.59,32.28 }

	Teleport[#Teleport+1] = { -1877.61,-1160.96,11.73,-2020.52,4461.76,57.25 }
	Teleport[#Teleport+1] = { -2020.52,4461.76,57.25,-1877.61,-1160.96,11.73 }
	-- bombeiros
	Teleport[#Teleport+1] = { -620.95,-108.75,38.15,-2094.81,2829.59,33.16 }
	Teleport[#Teleport+1] = { -2094.81,2829.59,33.16,-620.95,-108.75,38.15 }

	Teleport[#Teleport+1] = { 3466.46,5098.5,9.39,3402.65,4994.3,30.85 }
	Teleport[#Teleport+1] = { 3402.65,4994.3,30.85,3466.46,5098.5,9.39 }

	-- mansao74
	Teleport[#Teleport+1] = { -3933.05,-859.74,7.6,1036.82,-2544.64,32.28 }
	Teleport[#Teleport+1] = { 1036.82,-2544.64,32.28,-3933.05,-859.74,7.6 }

	Teleport[#Teleport+1] = { -4492.64,-28.91,8.1,1174.16,871.92,144.03 }
	Teleport[#Teleport+1] = { 1174.16,871.92,144.03,-4492.64,-28.91,8.1 }

	Teleport[#Teleport+1] = { 916.55,1744.5,165.79,819.0,1785.34,150.86 }
	Teleport[#Teleport+1] = { 819.0,1785.34,150.86,916.55,1744.5,165.79 }

	Teleport[#Teleport+1] = { -416.62,1590.49,358.28,-77.53,1528.67,286.14 }
	Teleport[#Teleport+1] = { -77.53,1528.67,286.14,-416.62,1590.49,358.28 }

	Teleport[#Teleport+1] = { -433.51,1592.43,360.32,-454.81,1547.02,393.22 }
	Teleport[#Teleport+1] = { -454.81,1547.02,393.22,-433.51,1592.43,360.32 }

	Teleport[#Teleport+1] = { -319.55,1620.08,343.79,-403.8,1582.98,357.37 }
	Teleport[#Teleport+1] = { -403.8,1582.98,357.37,-319.55,1620.08,343.79 }

	Teleport[#Teleport+1] = { -468.65,1553.48,393.24,-456.31,1539.66,407.24 }
	Teleport[#Teleport+1] = { -456.31,1539.66,407.24,-468.65,1553.48,393.24 }

	Teleport[#Teleport+1] = { -451.51,1601.03,360.08,-466.32,1618.98,461.55 }
	Teleport[#Teleport+1] = { -466.32,1618.98,461.55,-451.51,1601.03,360.08 }

	Teleport[#Teleport+1] = { 958.09,-952.54,50.33,503.61,-3121.96,9.79 }
	Teleport[#Teleport+1] = { 503.61,-3121.96,9.79,958.09,-952.54,50.33 }

	Teleport[#Teleport+1] = { 201.3,725.85,205.85,-1801.59,-1326.11,7.78 }
	Teleport[#Teleport+1] = { -1801.59,-1326.11,7.78,201.3,725.85,205.85 }

	Teleport[#Teleport+1] = { 62.98,2165.92,-84.22,528.13,-1946.93,25.36 }
	Teleport[#Teleport+1] = { 528.13,-1946.93,25.36,62.98,2165.92,-84.22 }

	Teleport[#Teleport+1] = { 140.29,-141.0,49.57,122.08,-127.62,54.93 }
	Teleport[#Teleport+1] = { 122.08,-127.62,54.93,140.29,-141.0,49.57 }

	Teleport[#Teleport+1] = { 125.11,-115.43,49.76,773.25,1423.56,-84.22 }
	Teleport[#Teleport+1] = { 773.25,1423.56,-84.22,125.11,-115.43,49.76 }

	Teleport[#Teleport+1] = { -1399.52,-482.0,72.03,940.77,2.08,111.28 }
	Teleport[#Teleport+1] = { 940.77,2.08,111.28,-1399.52,-482.0,72.03 }

	Teleport[#Teleport+1] = { -695.27,6390.47,13.31,1219.14,-1534.97,34.9 }
	Teleport[#Teleport+1] = { 1219.14,-1534.97,34.9,-695.27,6390.47,13.31 }

	Teleport[#Teleport+1] = { -453.27,1618.05,362.96,-145.40,893.20,235.66 }
	Teleport[#Teleport+1] = { -145.40,893.20,235.66,-453.27,1618.05,362.96 }

	Teleport[#Teleport+1] = { -149.45,892.9,235.64,-1229.55,846.44,193.37 }
	Teleport[#Teleport+1] = { -1229.55,846.44,193.37,-149.45,892.9,235.64 }	

	Teleport[#Teleport+1] = { -280.93,6404.91,31.39,-5841.6,1146.02,7.57 }
	Teleport[#Teleport+1] = { -5841.6,1146.02,7.57,-280.93,6404.91,31.39 }	

	Teleport[#Teleport+1] = { -1064.28,-1663.46,4.55,1988.41,4373.11,37.25 }
	Teleport[#Teleport+1] = { 1988.41,4373.11,37.25,-1064.28,-1663.46,4.55 }

	Teleport[#Teleport+1] = { -3305.7,557.19,17.44,-398.91,4392.52,58.77 }
	Teleport[#Teleport+1] = { -398.91,4392.52,58.77,-3305.7,557.19,17.44 }

	-- Prf
	Teleport[#Teleport+1] = { -764.59,-1240.74,5.7,2624.37,5314.13,47.52 }
	Teleport[#Teleport+1] = { 2624.37,5314.13,47.52,-764.59,-1240.74,5.7 }

	-- Militar
	Teleport[#Teleport+1] = { -761.47,-1243.31,5.7,2540.05,-335.6,94.33 }
	Teleport[#Teleport+1] = { 2540.05,-335.6,94.33,-761.47,-1243.31,5.7 }

	-- Exercito
	Teleport[#Teleport+1] = { -757.62,-1246.82,5.7,-1832.05,3020.55,32.81 }
	Teleport[#Teleport+1] = { -1832.05,3020.55,32.81,-757.62,-1246.82,5.7 }

	-- Civil
	Teleport[#Teleport+1] = { -754.08,-1249.74,5.7,-450.13,6010.5,27.58 }
	Teleport[#Teleport+1] = { -450.13,6010.5,27.58,-754.08,-1249.74,5.7 }

	Teleport[#Teleport+1] = { 1035.43,903.67,220.36,897.22,1030.38,277.15 }
	Teleport[#Teleport+1] = { 897.22,1030.38,277.15,1035.43,903.67,220.36 }

	Teleport[#Teleport+1] = { -2268.19,378.16,188.76,2276.11,346.65,174.61 }
	Teleport[#Teleport+1] = { 2276.11,346.65,174.61,-2268.19,378.16,188.76 }

	Teleport[#Teleport+1] = { 119.61,-120.50,54.92,1433.08,4705.48,129.74 }
	Teleport[#Teleport+1] = { 1433.08,4705.48,129.74,119.61,-120.50,54.92 }

	Teleport[#Teleport+1] = { -1045.68,311.18,71.67,-1045.32,299.39,76.33 }
	Teleport[#Teleport+1] = { -1045.32,299.39,76.33,-1045.68,311.18,71.67 }

	Teleport[#Teleport+1] = { 1352.95,-2271.43,62.06,1401.87,-2390.11,68.21 }
	Teleport[#Teleport+1] = { 1401.87,-2390.11,68.21,1352.95,-2271.43,62.06 }

	Teleport[#Teleport+1] = { 93.54,-1297.5,29.32,-2623.15,1698.70,141.72 }
	Teleport[#Teleport+1] = { -2623.15,1698.70,141.72,93.54,-1297.5,29.32 }

	Teleport[#Teleport+1] = { 109.70,-1977.48,20.96,22.05,535.55,170.62 }
	Teleport[#Teleport+1] = { 22.05,535.55,170.62,109.70,-1977.48,20.96 }

	Teleport[#Teleport+1] = { 1371.73,-1734.35,66.43,-3520.34,4590.45,5.94 }
	Teleport[#Teleport+1] = { -3520.34,4590.45,5.94,1371.73,-1734.35,66.43 }

	Teleport[#Teleport+1] = { -111.17,578.12,196.76,-105.83,582.15,207.88 }
	Teleport[#Teleport+1] = { -105.83,582.15,207.88,-111.17,578.12,196.76 }

	Teleport[#Teleport+1] = { -106.28,582.06,196.76,-103.06,590.51,204.54 }
	Teleport[#Teleport+1] = { -103.06,590.51,204.54,-106.28,582.06,196.76 }

	Teleport[#Teleport+1] = { 2736.92,3512.20,55.71,-3212.08,804.23,8.93 }
	Teleport[#Teleport+1] = { -3212.08,804.23,8.93,2736.92,3512.20,55.71 }

	Teleport[#Teleport+1] = { -1579.57,-564.92,108.52,-101.97,585.13,207.88 }
	Teleport[#Teleport+1] = { -101.97,585.13,207.88,-1579.57,-564.92,108.52 }

	Teleport[#Teleport+1] = { -2645.68,-866.87,14.41,-1889.14,-39.61,130.11 }
	Teleport[#Teleport+1] = { -1889.14,-39.61,130.11,-2645.68,-866.87,14.41 }

elseif cityName == "Fronteira" then

	Teleport[#Teleport+1] = { -3270.35,-1160.25,7.85,-1838.7,424.99,118.37 }
	Teleport[#Teleport+1] = { -1838.7,424.99,118.37,-3270.35,-1160.25,7.85 }

	Teleport[#Teleport+1] = { -768.65,336.77,243.38,-796.15,337.06,85.7 }
	Teleport[#Teleport+1] = { -796.15,337.06,85.7,-768.65,336.77,243.38 }

	Teleport[#Teleport+1] = { -344.28,1588.17,346.26, -3520.6,1302.95,7.55 }
	Teleport[#Teleport+1] = { -3520.6,1302.95,7.55, -344.28,1588.17,346.26 }

	Teleport[#Teleport+1] = { -450.11,1617.93,360.42,5030.22,-5760.46,15.75 }
	Teleport[#Teleport+1] = { 5030.22,-5760.46,15.75,-450.11,1617.93,360.42 }

	Teleport[#Teleport+1] = { 201.54,1719.8,226.93,-3266.14,-1169.06,7.84 }
	Teleport[#Teleport+1] = { -3266.14,-1169.06,7.84,201.54,1719.8,226.93 }

	Teleport[#Teleport+1] = { 147.61,-357.82,44.94,-3766.61,4653.96,5.91 } -- mansao96
	Teleport[#Teleport+1] = { -3766.61,4653.96,5.91,147.61,-357.82,44.94 }

	Teleport[#Teleport+1] = { -1464.76,182.8,55.92,-1237.45,813.63,193.37 } 
	Teleport[#Teleport+1] = { -1237.45,813.63,193.37,-1464.76,182.8,55.92 }

	Teleport[#Teleport+1] = { -454.91,1589.45,360.20,-2795.04,6015.81,823.62 } -- QG_94
	Teleport[#Teleport+1] = { -2795.04,6015.81,823.62,-454.91,1589.45,360.20 }

	Teleport[#Teleport+1] = { -618.28,-109.62,38.15,1682.35,3593.41,35.59 }
	Teleport[#Teleport+1] = { 1682.35,3593.41,35.59,-618.28,-109.62,38.15 }

	Teleport[#Teleport+1] = { -410.47,1585.64,361.92,-395.8,1537.42,381.31 }
	Teleport[#Teleport+1] = { -395.8,1537.42,381.31,-410.47,1585.64,361.92 }

	Teleport[#Teleport+1] = { 2475.8,-384.09,94.39,-1902.07,2910.49,32.81 }
	Teleport[#Teleport+1] = { -1902.07,2910.49,32.81,2475.8,-384.09,94.39 }

	Teleport[#Teleport+1] = { 137.62,-362.32,50.34,-463.15,-1375.12,31.14 }
	Teleport[#Teleport+1] = { -463.15,-1375.12,31.14,137.62,-362.32,50.34 }

	Teleport[#Teleport+1] = { -1532.68,820.63,181.69,663.48,959.28,247.38 }
	Teleport[#Teleport+1] = { 663.48,959.28,247.38,-1532.68,820.63,181.69 }

	Teleport[#Teleport+1] = { 1516.46,1413.86,108.71,1878.14,6380.75,46.35 }
	Teleport[#Teleport+1] = { 1878.14,6380.75,46.35,1516.46,1413.86,108.71 }

	Teleport[#Teleport+1] = { 135.83,-1278.99,29.37,1521.17,1441.34,108.72 }
	Teleport[#Teleport+1] = { 1521.17,1441.34,108.72,135.83,-1278.99,29.37 }

	Teleport[#Teleport+1] = { 1805.25,-2719.74,2.90,445.50,3562.33,33.24 }
	Teleport[#Teleport+1] = { 445.50,3562.33,33.24,1805.25,-2719.74,2.90 }

	Teleport[#Teleport+1] = { 864.83,3672.61,32.86,3099.51,5462.58,23.61 }
	Teleport[#Teleport+1] = { 3099.51,5462.58,23.61,864.83,3672.61,32.86 }

	Teleport[#Teleport+1] = { -1993.70,-510.48,12.33,-272.80,-1636.18,32.25 }
	Teleport[#Teleport+1] = { -272.80,-1636.18,32.25,-1993.70,-510.48,12.33 }

	Teleport[#Teleport+1] = { -2003.03,4486.11,57.29,-1947.34,4491.71,34.93 }
	Teleport[#Teleport+1] = { -1947.34,4491.71,34.93,-2003.03,4486.11,57.29 }

	Teleport[#Teleport+1] = { -272.91,6320.21,32.32,-271.23,6321.8,37.56 }
	Teleport[#Teleport+1] = { -271.23,6321.8,37.56,-272.91,6320.21,32.32 }

	Teleport[#Teleport+1] = { -2590.11,1921.41,167.40,-481.58,1607.32,375.10 } -- Mansao11
	Teleport[#Teleport+1] = { -481.58,1607.32,375.10,-2590.11,1921.41,167.40 } -- Mansao11

	Teleport[#Teleport+1] = { -339.98,-1523.09,27.74,-307.22,-1655.49,32.28 } -- QG_112
	Teleport[#Teleport+1] = { -307.22,-1655.49,32.28,-339.98,-1523.09,27.74 }

	Teleport[#Teleport+1] = { -2268.39,378.54,188.76,-2276.35,346.88,174.60 } 
	Teleport[#Teleport+1] = { -2276.35,346.88,174.60,-2268.39,378.54,188.76 }

	Teleport[#Teleport+1] = { 960.51,-962.70,42.95,931.32,-934.23,59.10 } 
	Teleport[#Teleport+1] = { 931.32,-934.23,59.10,960.51,-962.70,42.95 }

	Teleport[#Teleport+1] = { 1827.49,456.00,166.64,1618.79,446.85,253.23 } 
	Teleport[#Teleport+1] = { 1618.79,446.85,253.23,1827.49,456.00,166.64 }

	Teleport[#Teleport+1] = { -625.37,-127.22,36.02,-365.49,6102.72,35.44 } 
	Teleport[#Teleport+1] = { -365.49,6102.72,35.44,-625.37,-127.22,36.02 }

	Teleport[#Teleport+1] = { -2053.24,-142.08,26.85,-2200.24,-278.12,35.57 } 
	Teleport[#Teleport+1] = { -2200.24,-278.12,35.57,-2053.24,-142.08,26.85 }

	Teleport[#Teleport+1] = { -3949.56,-828.28,13.26,-3230.57,809.49,14.08 } 
	Teleport[#Teleport+1] = { -3230.57,809.49,14.08,-3949.56,-828.28,13.26 }

	Teleport[#Teleport+1] = { 1461.59,1086.94,114.33,807.12,3435.06,57.86 } 
	Teleport[#Teleport+1] = { 807.12,3435.06,57.86,1461.59,1086.94,114.33 }

	Teleport[#Teleport+1] = { -3184.32,817.73,8.93,-3949.57,-827.94,13.26 } 
	Teleport[#Teleport+1] = { -3949.57,-827.94,13.26,-3184.32,817.73,8.93 }

	Teleport[#Teleport+1] = { -2375.32,1777.56,212.13,-2568.41,-2240.62,5.05 } 
	Teleport[#Teleport+1] = { -2568.41,-2240.62,5.05,-2375.32,1777.56,212.13 }

	Teleport[#Teleport+1] = { -1572.5,-394.52,59.14,-1566.93,-406.77,42.38 } 
	Teleport[#Teleport+1] = { -1566.93,-406.77,42.38,-1572.5,-394.52,59.14 }

	Teleport[#Teleport+1] = { -1581.21,374.54,98.66,2585.93,6147.9,162.92 }
	Teleport[#Teleport+1] = { 2585.93,6147.9,162.92,-1581.21,374.54,98.66 }

	Teleport[#Teleport+1] = { -770.54,309.17,85.7,-768.8,336.73,243.38 }
	Teleport[#Teleport+1] = { -768.8,336.73,243.38,-770.54,309.17,85.7 }

	Teleport[#Teleport+1] = { -3939.35,-832.10,13.26,-3082.61,3429.55,12.52 }
	Teleport[#Teleport+1] = { -3082.61,3429.55,12.52,-3939.35,-832.10,13.26 }

	Teleport[#Teleport+1] = { -325.66,-143.3,60.47,-334.02,-90.87,47.04 }
	Teleport[#Teleport+1] = { -334.02,-90.87,47.04,-325.66,-143.3,60.47 }

	Teleport[#Teleport+1] = { -256.95,6334.18,32.43,1150.44,-1556.82,35.38 }
	Teleport[#Teleport+1] = { 1150.44,-1556.82,35.38,-256.95,6334.18,32.43 }

	Teleport[#Teleport+1] = { 3540.52,3675.41,28.12,3540.59,3675.34,20.99 }
	Teleport[#Teleport+1] = { 3540.59,3675.34,20.99,3540.52,3675.41,28.12 }

	Teleport[#Teleport+1] = { 1407.24,4706.69,140.27,-107.43,976.91,240.88 }
	Teleport[#Teleport+1] = { -107.43,976.91,240.88,1407.24,4706.69,140.27 }

	Teleport[#Teleport+1] = { -3227.44,-1221.46,7.84,-308.39,-1624.75,31.85 }
	Teleport[#Teleport+1] = { -308.39,-1624.75,31.85,-3227.44,-1221.46,7.84 }
	-- dp tatica
	Teleport[#Teleport+1] = { -786.48,-1212.63,6.86,-777.04,-1226.04,15.55 }
	Teleport[#Teleport+1] = { -777.04,-1226.04,15.55,-786.48,-1212.63,6.86 }

	Teleport[#Teleport+1] = { 2620.07,5364.66,47.3,2549.44,-314.94,93.1 }
	Teleport[#Teleport+1] = { 2549.44,-314.94,93.1,2620.07,5364.66,47.3 }

	Teleport[#Teleport+1] = { 2641.47,3617.21,110.08,2593.05,3633.85,-6.07 }
	Teleport[#Teleport+1] = { 2593.05,3633.85,-6.07,2641.47,3617.21,110.08 }

	Teleport[#Teleport+1] = { 2590.61,3657.68,-5.49,2349.64,3314.75,54.86 }
	Teleport[#Teleport+1] = { 2349.64,3314.75,54.86,2590.61,3657.68,-5.49 }
	-- dp zancudo
	Teleport[#Teleport+1] = { 2540.06,-432.42,94.12,-862.61,-1227.5,6.45 }
	Teleport[#Teleport+1] = { -862.61,-1227.5,6.45,2540.06,-432.42,94.12 }

	Teleport[#Teleport+1] = { 4890.18,-5454.87,33.72,259.56,-783.15,30.5 }
	Teleport[#Teleport+1] = { 259.56,-783.15,30.5,4890.18,-5454.87,33.72 }

	Teleport[#Teleport+1] = { 835.11,326.51,118.35,-111.61,827.87,235.73 }
	Teleport[#Teleport+1] = { -111.61,827.87,235.73,835.11,326.51,118.35 }
	-- civil para militar
	Teleport[#Teleport+1] = { -389.59,6050.64,31.49,2540.02,-335.65,94.31 }
	Teleport[#Teleport+1] = { 2540.02,-335.65,94.31,-389.59,6050.64,31.49 }

	Teleport[#Teleport+1] = { -170.49,8250.23,12.82,-196.37,6566.81,11.14 }
	Teleport[#Teleport+1] = { -196.37,6566.81,11.14,-170.49,8250.23,12.82 }

	Teleport[#Teleport+1] = { -1799.1,-1327.99,7.18,1399.53,1496.56,113.87 }
	Teleport[#Teleport+1] = { 1399.53,1496.56,113.87,-1799.1,-1327.99,7.18 }

	Teleport[#Teleport+1] = { -2663.89,1298.76,147.44,-1788.01,427.84,122.63 }
	Teleport[#Teleport+1] = { -1788.01,427.84,122.63,-2663.89,1298.76,147.44 }

	Teleport[#Teleport+1] = { 1036.86,-2544.59,32.28,3481.69,5121.49,9.69 }
	Teleport[#Teleport+1] = { 3481.69,5121.49,9.69,1036.86,-2544.59,32.28 }

	Teleport[#Teleport+1] = { -1877.61,-1160.96,11.73,-2020.52,4461.76,57.25 }
	Teleport[#Teleport+1] = { -2020.52,4461.76,57.25,-1877.61,-1160.96,11.73 }
	-- bombeiros
	Teleport[#Teleport+1] = { -620.95,-108.75,38.15,-2094.81,2829.59,33.16 }
	Teleport[#Teleport+1] = { -2094.81,2829.59,33.16,-620.95,-108.75,38.15 }

	Teleport[#Teleport+1] = { 3466.46,5098.5,9.39,3402.65,4994.3,30.85 }
	Teleport[#Teleport+1] = { 3402.65,4994.3,30.85,3466.46,5098.5,9.39 }

	-- mansao74
	Teleport[#Teleport+1] = { -3933.05,-859.74,7.6,1036.82,-2544.64,32.28 }
	Teleport[#Teleport+1] = { 1036.82,-2544.64,32.28,-3933.05,-859.74,7.6 }

	Teleport[#Teleport+1] = { -4492.64,-28.91,8.1,1174.16,871.92,144.03 }
	Teleport[#Teleport+1] = { 1174.16,871.92,144.03,-4492.64,-28.91,8.1 }

	Teleport[#Teleport+1] = { 916.55,1744.5,165.79,819.0,1785.34,150.86 }
	Teleport[#Teleport+1] = { 819.0,1785.34,150.86,916.55,1744.5,165.79 }

	Teleport[#Teleport+1] = { -416.62,1590.49,358.28,-77.53,1528.67,286.14 }
	Teleport[#Teleport+1] = { -77.53,1528.67,286.14,-416.62,1590.49,358.28 }

	Teleport[#Teleport+1] = { -433.51,1592.43,360.32,-454.81,1547.02,393.22 }
	Teleport[#Teleport+1] = { -454.81,1547.02,393.22,-433.51,1592.43,360.32 }

	Teleport[#Teleport+1] = { -319.55,1620.08,343.79,-403.8,1582.98,357.37 }
	Teleport[#Teleport+1] = { -403.8,1582.98,357.37,-319.55,1620.08,343.79 }

	Teleport[#Teleport+1] = { -468.65,1553.48,393.24,-456.31,1539.66,407.24 }
	Teleport[#Teleport+1] = { -456.31,1539.66,407.24,-468.65,1553.48,393.24 }

	Teleport[#Teleport+1] = { -451.51,1601.03,360.08,-466.32,1618.98,461.55 }
	Teleport[#Teleport+1] = { -466.32,1618.98,461.55,-451.51,1601.03,360.08 }

	Teleport[#Teleport+1] = { 958.09,-952.54,50.33,503.61,-3121.96,9.79 }
	Teleport[#Teleport+1] = { 503.61,-3121.96,9.79,958.09,-952.54,50.33 }

	Teleport[#Teleport+1] = { 201.3,725.85,205.85,-1801.59,-1326.11,7.78 }
	Teleport[#Teleport+1] = { -1801.59,-1326.11,7.78,201.3,725.85,205.85 }

	Teleport[#Teleport+1] = { 62.98,2165.92,-84.22,528.13,-1946.93,25.36 }
	Teleport[#Teleport+1] = { 528.13,-1946.93,25.36,62.98,2165.92,-84.22 }

	Teleport[#Teleport+1] = { 140.29,-141.0,49.57,122.08,-127.62,54.93 }
	Teleport[#Teleport+1] = { 122.08,-127.62,54.93,140.29,-141.0,49.57 }

	Teleport[#Teleport+1] = { 125.11,-115.43,49.76,773.25,1423.56,-84.22 }
	Teleport[#Teleport+1] = { 773.25,1423.56,-84.22,125.11,-115.43,49.76 }

	Teleport[#Teleport+1] = { -1399.52,-482.0,72.03,940.77,2.08,111.28 }
	Teleport[#Teleport+1] = { 940.77,2.08,111.28,-1399.52,-482.0,72.03 }

	Teleport[#Teleport+1] = { -695.27,6390.47,13.31,1219.14,-1534.97,34.9 }
	Teleport[#Teleport+1] = { 1219.14,-1534.97,34.9,-695.27,6390.47,13.31 }

	Teleport[#Teleport+1] = { -453.27,1618.05,362.96,-146.12,889.92,235.64 }
	Teleport[#Teleport+1] = { -146.12,889.92,235.64,-453.27,1618.05,362.96 }

	Teleport[#Teleport+1] = { -149.45,892.9,235.64,-1229.55,846.44,193.37 }
	Teleport[#Teleport+1] = { -1229.55,846.44,193.37,-149.45,892.9,235.64 }	

	Teleport[#Teleport+1] = { -280.93,6404.91,31.39,-5841.6,1146.02,7.57 }
	Teleport[#Teleport+1] = { -5841.6,1146.02,7.57,-280.93,6404.91,31.39 }	

	Teleport[#Teleport+1] = { -1064.28,-1663.46,4.55,1988.41,4373.11,37.25 }
	Teleport[#Teleport+1] = { 1988.41,4373.11,37.25,-1064.28,-1663.46,4.55 }

	Teleport[#Teleport+1] = { 742.36,-814.16,24.26,-835.64,262.45,82.8 }
	Teleport[#Teleport+1] = { -835.64,262.45,82.8,742.36,-814.16,24.26 }

	Teleport[#Teleport+1] = { -3305.7,557.19,17.44,-398.91,4392.52,58.77 }
	Teleport[#Teleport+1] = { -398.91,4392.52,58.77,-3305.7,557.19,17.44 }

	-- Prf
	Teleport[#Teleport+1] = { -764.59,-1240.74,5.7,2624.37,5314.13,47.52 }
	Teleport[#Teleport+1] = { 2624.37,5314.13,47.52,-764.59,-1240.74,5.7 }

	-- Militar
	Teleport[#Teleport+1] = { -761.47,-1243.31,5.7,2540.05,-335.6,94.33 }
	Teleport[#Teleport+1] = { 2540.05,-335.6,94.33,-761.47,-1243.31,5.7 }

	-- Exercito
	Teleport[#Teleport+1] = { -757.62,-1246.82,5.7,-1832.05,3020.55,32.81 }
	Teleport[#Teleport+1] = { -1832.05,3020.55,32.81,-757.62,-1246.82,5.7 }

	-- Civil
	Teleport[#Teleport+1] = { -754.08,-1249.74,5.7,-450.13,6010.5,27.58 }
	Teleport[#Teleport+1] = { -450.13,6010.5,27.58,-754.08,-1249.74,5.7 }

	Teleport[#Teleport+1] = { 1035.43,903.67,220.36,897.22,1030.38,277.15 }
	Teleport[#Teleport+1] = { 897.22,1030.38,277.15,1035.43,903.67,220.36 }

	Teleport[#Teleport+1] = { -2268.19,378.16,188.76,2276.11,346.65,174.61 }
	Teleport[#Teleport+1] = { 2276.11,346.65,174.61,-2268.19,378.16,188.76 }

	Teleport[#Teleport+1] = { 119.61,-120.50,54.92,1433.08,4705.48,129.74 }
	Teleport[#Teleport+1] = { 1433.08,4705.48,129.74,119.61,-120.50,54.92 }

	Teleport[#Teleport+1] = { -1045.68,311.18,71.67,-1045.32,299.39,76.33 }
	Teleport[#Teleport+1] = { -1045.32,299.39,76.33,-1045.68,311.18,71.67 }

	Teleport[#Teleport+1] = { 1352.95,-2271.43,62.06,1401.87,-2390.11,68.21 }
	Teleport[#Teleport+1] = { 1401.87,-2390.11,68.21,1352.95,-2271.43,62.06 }

	Teleport[#Teleport+1] = { 93.54,-1297.5,29.32,-2623.15,1698.70,141.72 }
	Teleport[#Teleport+1] = { -2623.15,1698.70,141.72,93.54,-1297.5,29.32 }

	Teleport[#Teleport+1] = { 109.70,-1977.48,20.96,22.05,535.55,170.62 }
	Teleport[#Teleport+1] = { 22.05,535.55,170.62,109.70,-1977.48,20.96 }

	Teleport[#Teleport+1] = { 1371.73,-1734.35,66.43,-3520.34,4590.45,5.94 }
	Teleport[#Teleport+1] = { -3520.34,4590.45,5.94,1371.73,-1734.35,66.43 }

	Teleport[#Teleport+1] = { -111.17,578.12,196.76,-105.83,582.15,207.88 }
	Teleport[#Teleport+1] = { -105.83,582.15,207.88,-111.17,578.12,196.76 }

	Teleport[#Teleport+1] = { -106.28,582.06,196.76,-103.06,590.51,204.54 }
	Teleport[#Teleport+1] = { -103.06,590.51,204.54,-106.28,582.06,196.76 }

	Teleport[#Teleport+1] = { 2736.92,3512.20,55.71,-3212.08,804.23,8.93 }
	Teleport[#Teleport+1] = { -3212.08,804.23,8.93,2736.92,3512.20,55.71 }

	Teleport[#Teleport+1] = { -1579.57,-564.92,108.52,-101.97,585.13,207.88 }
	Teleport[#Teleport+1] = { -101.97,585.13,207.88,-1579.57,-564.92,108.52 }

elseif cityName == "CidadeNobre" then

	Teleport[#Teleport+1] = { -1985.52,-490.19,11.69,1001.53,887.0,209.65 }
	Teleport[#Teleport+1] = { 1001.53,887.0,209.65,-1985.52,-490.19,11.69 }

	Teleport[#Teleport+1] = { -71.05,-801.01,44.23,-75.0,-824.54,321.29 }
	Teleport[#Teleport+1] = { -75.0,-824.54,321.29,-71.05,-801.01,44.23 }

	Teleport[#Teleport+1] = { -3491.14,4524.91,27.26,-3413.89,4410.69,150.23 }
	Teleport[#Teleport+1] = { -3413.89,4410.69,150.23,-3491.14,4524.91,27.26 }

	Teleport[#Teleport+1] = { 850.61,1749.08,171.72,793.11,1835.83,140.39 }
	Teleport[#Teleport+1] = { 793.11,1835.83,140.39,850.61,1749.08,171.72 }

	Teleport[#Teleport+1] = { 1372.57,-2316.4,62.28,-2958.51,31.51,11.61 }
	Teleport[#Teleport+1] = { -2958.51,31.51,11.61,1372.57,-2316.4,62.28 }

	Teleport[#Teleport+1] = { -2932.61,57.60,11.61, 727.26,-815.18,24.90 }
	Teleport[#Teleport+1] = { 727.26,-815.18,24.90,-2932.61,57.60,11.61 }

	Teleport[#Teleport+1] = { 2621.44,5395.31,47.23,2577.2,5335.56,56.92 }
	Teleport[#Teleport+1] = { 2577.2,5335.56,56.92,2621.44,5395.31,47.23 }

	Teleport[#Teleport+1] = { -1531.59,307.26,83.36, -1592.88,445.68,199.42 } -- QG_11
	Teleport[#Teleport+1] = { -1592.88,445.68,199.42, -1531.59,307.26,83.36 }

	Teleport[#Teleport+1] = { -133.43,863.74,232.7,-196.94,793.38,198.1 }
	Teleport[#Teleport+1] = { -196.94,793.38,198.1,-133.43,863.74,232.7 }

	Teleport[#Teleport+1] = { -2206.86,-274.88,42.53, -2248.40,-176.62,171.01 } -- QG_04
	Teleport[#Teleport+1] = { -2248.40,-176.62,171.01, -2206.86,-274.88,42.53 }

	Teleport[#Teleport+1] = { -362.09,172.15,87.11,621.46,915.78,247.57 }
	Teleport[#Teleport+1] = { 621.46,915.78,247.57,-362.09,172.15,87.11 }

	Teleport[#Teleport+1] = { 1410.41,4735.06,135.93,1410.08,4709.5,144.55 }
	Teleport[#Teleport+1] = { 1410.08,4709.5,144.55,1410.41,4735.06,135.93 }

	Teleport[#Teleport+1] = { -321.19,209.81,87.92, 962.06,995.71,-84.22 } -- QG_281
	Teleport[#Teleport+1] = { 962.06,995.71,-84.22, -321.19,209.81,87.92 }

	Teleport[#Teleport+1] = { -117.0,503.61,142.89, -112.91,492.52,137.02 }
	Teleport[#Teleport+1] = { -112.91,492.52,137.02, -117.0,503.61,142.89 }

	Teleport[#Teleport+1] = { -2235.48,-240.06,46.99, -2271.15,-215.84,78.3 } -- QG_04
	Teleport[#Teleport+1] = { -2271.15,-215.84,78.3, -2235.48,-240.06,46.99 }

	Teleport[#Teleport+1] = { -181.18,913.18,233.45, -180.6,915.55,244.9 }
	Teleport[#Teleport+1] = { -180.6,915.55,244.9, -181.18,913.18,233.45 }

	Teleport[#Teleport+1] = { -131.05,867.33,232.7,-1544.55,78.18,56.75 }
	Teleport[#Teleport+1] = { -1544.55,78.18,56.75,-131.05,867.33,232.7 }

	Teleport[#Teleport+1] = { -161.05,-1292.9,31.31, -142.86,-1285.99,47.89 }
	Teleport[#Teleport+1] = { -142.86,-1285.99,47.89, -161.05,-1292.9,31.31 }

	Teleport[#Teleport+1] = { 959.08,18.85,75.74,135.39,-358.86,61.6 }
	Teleport[#Teleport+1] = { 135.39,-358.86,61.6,959.08,18.85,75.74 }

	Teleport[#Teleport+1] = { -437.7,5993.66,44.26, -464.34,6004.58,31.81 }
	Teleport[#Teleport+1] = { -464.34,6004.58,31.81, -437.7,5993.66,44.26 }

	Teleport[#Teleport+1] = { 2567.24,3653.07,105.67,2494.25,3605.93,203.6 }
	Teleport[#Teleport+1] = { 2494.25,3605.93,203.6,2567.24,3653.07,105.67 }

	Teleport[#Teleport+1] = { 414.91,-15.16,99.65,380.64,-15.32,83.0 } -- QG_10
	Teleport[#Teleport+1] = { 380.64,-15.32,83.0,414.91,-15.16,99.65 }

	Teleport[#Teleport+1] = { -449.98,1671.97,360.42, -3276.13,559.47,13.02 }
	Teleport[#Teleport+1] = { -3276.13,559.47,13.02, -449.98,1671.97,360.42 }

	Teleport[#Teleport+1] = { -288.58,215.06,81.77, -315.95,200.93,164.99 }
	Teleport[#Teleport+1] = { -315.95,200.93,164.99, -288.58,215.06,81.77 }

	Teleport[#Teleport+1] = { 473.05,-1027.06,28.16,2617.14,5406.74,47.25 }
	Teleport[#Teleport+1] = { 2617.14,5406.74,47.25,473.05,-1027.06,28.16 }

	Teleport[#Teleport+1] = { 2618.88,5404.05,47.23,1174.69,-1485.94,34.85 }
	Teleport[#Teleport+1] = { 1174.69,-1485.94,34.85,2618.88,5404.05,47.23 }

	Teleport[#Teleport+1] = { 2620.04,5400.02,47.23, 2549.29,-315.41,93.1 }
	Teleport[#Teleport+1] = { 2549.29,-315.41,93.1, 2620.04,5400.02,47.23 }

	Teleport[#Teleport+1] = { 2621.0,5396.68,47.23, -764.01,-1240.68,5.7 }
	Teleport[#Teleport+1] = { -764.01,-1240.68,5.7, 2621.0,5396.68,47.23 }

	Teleport[#Teleport+1] = { 2622.15,5357.43,45.33, 2678.59,5343.12,162.13 }
	Teleport[#Teleport+1] = { 2678.59,5343.12,162.13, 2622.15,5357.43,45.33 }

	Teleport[#Teleport+1] = { 2024.93,3389.12,46.69, -2934.46,-1835.68,7.43 }
	Teleport[#Teleport+1] = { -2934.46,-1835.68,7.43, 2024.93,3389.12,46.69 }

	Teleport[#Teleport+1] = { 913.35,56.88,80.9,984.9,64.53,123.12 }
	Teleport[#Teleport+1] = { 984.9,64.53,123.12,913.35,56.88,80.9 }

	Teleport[#Teleport+1] = { 244.25,2726.44,47.35, 33.83,6433.61,31.51 } -- QG_181
	Teleport[#Teleport+1] = { 33.83,6433.61,31.51, 244.25,2726.44,47.35 }

	Teleport[#Teleport+1] = { -549.74,6468.94,13.49, -548.53,6464.68,13.49 }

	Teleport[#Teleport+1] = { -530.21,6468.67,6.59, -1722.98,-89.77,93.63 }
	Teleport[#Teleport+1] = { -1722.98,-89.77,93.63, -530.21,6468.67,6.59 }

	Teleport[#Teleport+1] = { 2609.31,5339.45,47.58,1778.59,2503.90,50.43 }
	Teleport[#Teleport+1] = { 1778.59,2503.90,50.43,2609.31,5339.45,47.58 }

	Teleport[#Teleport+1] = { -1811.44,4477.43,18.59,-2004.79,4486.41,57.22 }
	Teleport[#Teleport+1] = { -2004.79,4486.41,57.22,-1811.44,4477.43,18.59 }

	Teleport[#Teleport+1] = { 2618.08,5406.91,47.23,-1726.93,-79.1,89.71 } -- mansao141
	Teleport[#Teleport+1] = { -1726.93,-79.1,89.71,2618.08,5406.91,47.23 }

	Teleport[#Teleport+1] = { 2566.59,6180.86,163.22,-1550.2,76.75,53.87 }
	Teleport[#Teleport+1] = { -1550.2,76.75,53.87,2566.59,6180.86,163.22 }

	Teleport[#Teleport+1] = { 1413.99,1351.18,111.28, -2576.97,3748.23,19.29 }
	Teleport[#Teleport+1] = { -2576.97,3748.23,19.29,1413.99,1351.18,111.28 }

	Teleport[#Teleport+1] = { -1158.67,-1728.77,4.2,-1187.78,-1675.27,4.47 }
	Teleport[#Teleport+1] = { -1187.78,-1675.27,4.47,-1158.67,-1728.77,4.2 }

	Teleport[#Teleport+1] = { -1191.99,-1658.57,4.55,-1292.16,-1637.36,4.6 }
	Teleport[#Teleport+1] = { -1292.16,-1637.36,4.6,-1191.99,-1658.57,4.55 }

	Teleport[#Teleport+1] = { -1158.83,-1656.35,4.47,-1382.75,-1819.96,6.66 }
	Teleport[#Teleport+1] = { -1382.75,-1819.96,6.66,-1158.83,-1656.35,4.47 }

	Teleport[#Teleport+1] = { -1290.47,-1689.87,4.8,-1303.74,-1693.0,31.05 }
	Teleport[#Teleport+1] = { -1303.74,-1693.0,31.05,-1290.47,-1689.87,4.8 }

	Teleport[#Teleport+1] = { 491.61,1462.0,357.08,2723.13,1750.07,33.51 }
	Teleport[#Teleport+1] = { 2723.13,1750.07,33.51,491.61,1462.0,357.08 }

	Teleport[#Teleport+1] = { -535.38,4999.21,159.92, -5843.28,1183.09,7.55 } -- mansao17
	Teleport[#Teleport+1] = { -5843.28,1183.09,7.55, -535.38,4999.21,159.92 }

	Teleport[#Teleport+1] = { -1312.89,-1710.32,6.24,-1307.35,-1693.64,27.24 } -- QG_266
	Teleport[#Teleport+1] = { -1307.35,-1693.64,27.24,-1312.89,-1710.32,6.24 }

	Teleport[#Teleport+1] = { -3631.19,2526.52,16.88,-3726.29,2529.37,85.07 }
	Teleport[#Teleport+1] = { -3726.29,2529.37,85.07,-3631.19,2526.52,16.88 }

	Teleport[#Teleport+1] = { -796.62,398.50,91.34,2458.24,4975.54,46.83 }
	Teleport[#Teleport+1] = { 2458.24,4975.54,46.83,-796.62,398.50,91.34 }

	Teleport[#Teleport+1] = { 2475.8,-384.09,94.39,-1902.07,2910.49,32.81 }
	Teleport[#Teleport+1] = { -1902.07,2910.49,32.81,2475.8,-384.09,94.39 }

	Teleport[#Teleport+1] = { 2588.02,1771.42,30.03,2591.56,1847.13,39.92 }
	Teleport[#Teleport+1] = { 2591.56,1847.13,39.92,2588.02,1771.42,30.03 }

	Teleport[#Teleport+1] = { 1682.65,3594.14,35.59,1194.86,-1486.68,34.69 } -- Bombeiros
	Teleport[#Teleport+1] = { 1194.86,-1486.68,34.69,1682.65,3594.14,35.59 }

	Teleport[#Teleport+1] = { -1160.28,-1221.48,6.96,1673.52,3593.99,35.59 } -- Bombeiro Sul / Bombeiro Norte
	Teleport[#Teleport+1] = { 1673.52,3593.99,35.59,-1160.28,-1221.48,6.96 }

	Teleport[#Teleport+1] = { -2207.09,3311.17,33.16,-743.36,-1241.93,5.70 } -- Exercito
	Teleport[#Teleport+1] = { -743.36,-1241.93,5.70,-2207.09,3311.17,33.16 }

	Teleport[#Teleport+1] = { 2720.84,1915.79,74.21,2636.93,1833.3,33.03 } -- QG_210
	Teleport[#Teleport+1] = { 2636.93,1833.3,33.03,2720.84,1915.79,74.21 }

	Teleport[#Teleport+1] = { -1483.14,-1029.71,6.13,-3728.27,2092.39,27.15 }
	Teleport[#Teleport+1] = { -3728.27,2092.39,27.15,-1483.14,-1029.71,6.13 }

	Teleport[#Teleport+1] = { -1169.41,7326.03,21.53,-1790.01,419.97,132.3 } -- mansao125
	Teleport[#Teleport+1] = { -1790.01,419.97,132.3,-1169.41,7326.03,21.53 }

	Teleport[#Teleport+1] = { 1367.65,1435.31,106.05,3211.55,2018.67,16.29 }
	Teleport[#Teleport+1] = { 3211.55,2018.67,16.29,1367.65,1435.31,106.05 }

	Teleport[#Teleport+1] = { 1529.4,1403.7,108.73,-3557.82,4621.34,10.33 }
	Teleport[#Teleport+1] = { -3557.82,4621.34,10.33,1529.4,1403.7,108.73 }

	Teleport[#Teleport+1] = { 54.73,6517.35,31.53,77.69,6569.99,45.63 } -- QG_181
	Teleport[#Teleport+1] = { 77.69,6569.99,45.63,54.73,6517.35,31.53 }

	Teleport[#Teleport+1] = { 724.21,-697.52,28.54,725.25,-696.58,49.14 }
	Teleport[#Teleport+1] = { 725.25,-696.58,49.14,724.21,-697.52,28.54 }

	Teleport[#Teleport+1] = { 1090.34,3765.57,41.2,1107.16,243.12,-45.85 }
	Teleport[#Teleport+1] = { 1107.16,243.12,-45.85,1090.34,3765.57,41.2 }

	Teleport[#Teleport+1] = { 891.94,326.95,111.76,2008.11,-1586.61,253.38 }
	Teleport[#Teleport+1] = { 2008.11,-1586.61,253.38,891.94,326.95,111.76 }

	Teleport[#Teleport+1] = { -79.32,991.79,234.40,1646.66,7036.94,5.74 }
	Teleport[#Teleport+1] = { 1646.66,7036.94,5.74,-79.32,991.79,234.40 }

	Teleport[#Teleport+1] = { -2003.03,4486.11,57.29,-1947.34,4491.71,34.93 }
	Teleport[#Teleport+1] = { -1947.34,4491.71,34.93,-2003.03,4486.11,57.29 }

	Teleport[#Teleport+1] = { -272.91,6320.21,32.32,-271.23,6321.8,37.56 }
	Teleport[#Teleport+1] = { -271.23,6321.8,37.56,-272.91,6320.21,32.32 }

	Teleport[#Teleport+1] = { -2590.11,1921.41,167.40,-481.58,1607.32,375.10 } -- Mansao11
	Teleport[#Teleport+1] = { -481.58,1607.32,375.10,-2590.11,1921.41,167.40 } -- Mansao11

	Teleport[#Teleport+1] = { 80.21,6548.33,35.18,63.21,6529.77,64.67 }
	Teleport[#Teleport+1] = { 63.21,6529.77,64.67,80.21,6548.33,35.18 }

	Teleport[#Teleport+1] = { 146.06,-364.81,44.94,130.7,-374.01,61.6 }
	Teleport[#Teleport+1] = { 130.7,-374.01,61.6,146.06,-364.81,44.94 }

	Teleport[#Teleport+1] = { -339.98,-1523.09,27.74,-307.22,-1655.49,32.28 } -- QG_112
	Teleport[#Teleport+1] = { -307.22,-1655.49,32.28,-339.98,-1523.09,27.74 }

	Teleport[#Teleport+1] = { 1827.49,456.00,166.64,1618.79,446.85,253.23 } 
	Teleport[#Teleport+1] = { 1618.79,446.85,253.23,1827.49,456.00,166.64 }

	Teleport[#Teleport+1] = { 2632.78,3651.85,105.40,2332.04,3293.08,51.92 } 
	Teleport[#Teleport+1] = { 2332.04,3293.08,51.92,2632.78,3651.85,105.40 }

	Teleport[#Teleport+1] = { -2053.24,-142.08,26.85,-2200.24,-278.12,35.57 } 
	Teleport[#Teleport+1] = { -2200.24,-278.12,35.57,-2053.24,-142.08,26.85 }

	Teleport[#Teleport+1] = { -3949.56,-828.28,13.26,-3230.57,809.49,14.08 } 
	Teleport[#Teleport+1] = { -3230.57,809.49,14.08,-3949.56,-828.28,13.26 }

	Teleport[#Teleport+1] = { 1461.59,1086.94,114.33,807.12,3435.06,57.86 } 
	Teleport[#Teleport+1] = { 807.12,3435.06,57.86,1461.59,1086.94,114.33 }

	Teleport[#Teleport+1] = { -3184.32,817.73,8.93,-3949.57,-827.94,13.26 } 
	Teleport[#Teleport+1] = { -3949.57,-827.94,13.26,-3184.32,817.73,8.93 }

	Teleport[#Teleport+1] = { -2375.32,1777.56,212.13,-2568.41,-2240.62,5.05 } 
	Teleport[#Teleport+1] = { -2568.41,-2240.62,5.05,-2375.32,1777.56,212.13 }

	Teleport[#Teleport+1] = { -1581.21,374.54,98.66,2585.93,6147.9,162.92 }
	Teleport[#Teleport+1] = { 2585.93,6147.9,162.92,-1581.21,374.54,98.66 }

	Teleport[#Teleport+1] = { -770.54,309.17,85.7,-768.8,336.73,243.38 }
	Teleport[#Teleport+1] = { -768.8,336.73,243.38,-770.54,309.17,85.7 }

	Teleport[#Teleport+1] = { -325.66,-143.3,60.47,-334.02,-90.87,47.04 }
	Teleport[#Teleport+1] = { -334.02,-90.87,47.04,-325.66,-143.3,60.47 }

	Teleport[#Teleport+1] = { -955.32,-751.29,18.05,-256.49,6334.64,32.43 }
	Teleport[#Teleport+1] = { -256.49,6334.64,32.43,-955.32,-751.29,18.05 }

	Teleport[#Teleport+1] = { 3540.52,3675.41,28.12,3540.59,3675.34,20.99 }
	Teleport[#Teleport+1] = { 3540.59,3675.34,20.99,3540.52,3675.41,28.12 }
	-- dp tatica
	Teleport[#Teleport+1] = { -786.48,-1212.63,6.86,-777.04,-1226.04,15.55 }
	Teleport[#Teleport+1] = { -777.04,-1226.04,15.55,-786.48,-1212.63,6.86 }

	Teleport[#Teleport+1] = { 2620.07,5364.66,47.3,2549.44,-314.94,93.1 }
	Teleport[#Teleport+1] = { 2549.44,-314.94,93.1,2620.07,5364.66,47.3 }

	Teleport[#Teleport+1] = { 2641.47,3617.21,110.08,2593.05,3633.85,-6.07 }
	Teleport[#Teleport+1] = { 2593.05,3633.85,-6.07,2641.47,3617.21,110.08 }

	Teleport[#Teleport+1] = { 2590.61,3657.68,-5.49,2349.64,3314.75,54.86 }
	Teleport[#Teleport+1] = { 2349.64,3314.75,54.86,2590.61,3657.68,-5.49 }
	-- dp zancudo
	Teleport[#Teleport+1] = { 2540.06,-432.42,94.12,-862.61,-1227.5,6.45 }
	Teleport[#Teleport+1] = { -862.61,-1227.5,6.45,2540.06,-432.42,94.12 }

	Teleport[#Teleport+1] = { 835.11,326.51,118.35,-111.61,827.87,235.73 }
	Teleport[#Teleport+1] = { -111.61,827.87,235.73,835.11,326.51,118.35 }
	-- civil para militar
	Teleport[#Teleport+1] = { -389.59,6050.64,31.49,2540.02,-335.65,94.31 }
	Teleport[#Teleport+1] = { 2540.02,-335.65,94.31,-389.59,6050.64,31.49 }

	Teleport[#Teleport+1] = { -2663.89,1298.76,147.44,-1788.01,427.84,122.63 }
	Teleport[#Teleport+1] = { -1788.01,427.84,122.63,-2663.89,1298.76,147.44 }

	Teleport[#Teleport+1] = { -1877.61,-1160.96,11.73,-2020.52,4461.76,57.25 }
	Teleport[#Teleport+1] = { -2020.52,4461.76,57.25,-1877.61,-1160.96,11.73 }
	-- bombeiros
	Teleport[#Teleport+1] = { -620.95,-108.75,38.15,-2094.81,2829.59,33.16 }
	Teleport[#Teleport+1] = { -2094.81,2829.59,33.16,-620.95,-108.75,38.15 }

	-- mansao74
	Teleport[#Teleport+1] = { -3933.05,-859.74,7.6,1036.82,-2544.64,32.28 }
	Teleport[#Teleport+1] = { 1036.82,-2544.64,32.28,-3933.05,-859.74,7.6 }

	Teleport[#Teleport+1] = { 916.55,1744.5,165.79,819.0,1785.34,150.86 }
	Teleport[#Teleport+1] = { 819.0,1785.34,150.86,916.55,1744.5,165.79 }

	Teleport[#Teleport+1] = { -416.62,1590.49,358.28,-77.53,1528.67,286.14 }
	Teleport[#Teleport+1] = { -77.53,1528.67,286.14,-416.62,1590.49,358.28 }

	Teleport[#Teleport+1] = { -433.51,1592.43,360.32,-454.81,1547.02,393.22 }
	Teleport[#Teleport+1] = { -454.81,1547.02,393.22,-433.51,1592.43,360.32 }

	Teleport[#Teleport+1] = { -319.55,1620.08,343.79,-403.8,1582.98,357.37 }
	Teleport[#Teleport+1] = { -403.8,1582.98,357.37,-319.55,1620.08,343.79 }

	Teleport[#Teleport+1] = { -451.51,1601.03,360.08,-466.32,1618.98,461.55 }
	Teleport[#Teleport+1] = { -466.32,1618.98,461.55,-451.51,1601.03,360.08 }

	Teleport[#Teleport+1] = { 3137.85,5378.17,26.15,-704.74,-1292.66,5.39 }
	Teleport[#Teleport+1] = { -704.74,-1292.66,5.39,3137.85,5378.17,26.15 }

	Teleport[#Teleport+1] = { 62.88,2165.74,-84.22,-3421.0,73.38,12.47 }
	Teleport[#Teleport+1] = { -3421.0,73.38,12.47,62.88,2165.74,-84.22 }

	Teleport[#Teleport+1] = { 140.29,-141.0,49.57,122.08,-127.62,54.93 }
	Teleport[#Teleport+1] = { 122.08,-127.62,54.93,140.29,-141.0,49.57 }

	Teleport[#Teleport+1] = { 125.11,-115.43,49.76,773.25,1423.56,-84.22 }
	Teleport[#Teleport+1] = { 773.25,1423.56,-84.22,125.11,-115.43,49.76 }

	Teleport[#Teleport+1] = { -149.45,892.9,235.64,-1229.55,846.44,193.37 }
	Teleport[#Teleport+1] = { -1229.55,846.44,193.37,-149.45,892.9,235.64 }

	Teleport[#Teleport+1] = { -450.11,1616.95,360.42,5030.1,-5759.77,15.74 }
	Teleport[#Teleport+1] = { 5030.1,-5759.77,15.74,-450.11,1616.95,360.42 }

	Teleport[#Teleport+1] = { -1931.66,396.87,96.51,-835.96,262.49,82.80 }
	Teleport[#Teleport+1] = { -835.96,262.49,82.80,-1931.66,396.87,96.51 }

	Teleport[#Teleport+1] = { -3305.7,557.19,17.44,-398.91,4392.52,58.77 }
	Teleport[#Teleport+1] = { -398.91,4392.52,58.77,-3305.7,557.19,17.44 }

	-- Prf
	Teleport[#Teleport+1] = { -764.59,-1240.74,5.7,2624.37,5314.13,47.52 }
	Teleport[#Teleport+1] = { 2624.37,5314.13,47.52,-764.59,-1240.74,5.7 }

	-- Militar
	Teleport[#Teleport+1] = { -761.47,-1243.31,5.7,2540.05,-335.6,94.33 }
	Teleport[#Teleport+1] = { 2540.05,-335.6,94.33,-761.47,-1243.31,5.7 }

	-- Exercito
	Teleport[#Teleport+1] = { -757.62,-1246.82,5.7,-1832.05,3020.55,32.81 }
	Teleport[#Teleport+1] = { -1832.05,3020.55,32.81,-757.62,-1246.82,5.7 }

	-- Civil
	Teleport[#Teleport+1] = { -754.08,-1249.74,5.7,-450.13,6010.5,27.58 }
	Teleport[#Teleport+1] = { -450.13,6010.5,27.58,-754.08,-1249.74,5.7 }

	Teleport[#Teleport+1] = { 1035.43,903.67,220.36,897.22,1030.38,277.15 }
	Teleport[#Teleport+1] = { 897.22,1030.38,277.15,1035.43,903.67,220.36 }

	Teleport[#Teleport+1] = { -1045.68,311.18,71.67,-1045.32,299.39,76.33 }
	Teleport[#Teleport+1] = { -1045.32,299.39,76.33,-1045.68,311.18,71.67 }

	Teleport[#Teleport+1] = { 1352.95,-2271.43,62.06,1401.87,-2390.11,68.21 }
	Teleport[#Teleport+1] = { 1401.87,-2390.11,68.21,1352.95,-2271.43,62.06 }

	Teleport[#Teleport+1] = { 93.54,-1297.5,29.32,-2623.15,1698.70,141.72 }
	Teleport[#Teleport+1] = { -2623.15,1698.70,141.72,93.54,-1297.5,29.32 }

	Teleport[#Teleport+1] = { -106.28,582.06,196.76,-103.06,590.51,204.54 }
	Teleport[#Teleport+1] = { -103.06,590.51,204.54,-106.28,582.06,196.76 }

	Teleport[#Teleport+1] = { 2736.92,3512.20,55.71,-3212.08,804.23,8.93 }
	Teleport[#Teleport+1] = { -3212.08,804.23,8.93,2736.92,3512.20,55.71 }

	Teleport[#Teleport+1] = { -3787.45,251.17,22.81,-3787.42,249.17,29.67 }
	Teleport[#Teleport+1] = { -3787.42,249.17,29.67,-3787.45,251.17,22.81 }

	Teleport[#Teleport+1] = { -3857.44,337.6,101.72,-3835.95,336.02,22.22 }
	Teleport[#Teleport+1] = { -3835.95,336.02,22.22,-3857.44,337.6,101.72 }

	Teleport[#Teleport+1] = { -3776.87,346.2,127.74,-3690.71,382.49,22.49 }
	Teleport[#Teleport+1] = { -3690.71,382.49,22.49,-3776.87,346.2,127.74 }

	Teleport[#Teleport+1] = { -3862.53,302.08,22.22,-3855.27,301.43,50.89 }
	Teleport[#Teleport+1] = { -3855.27,301.43,50.89,-3862.53,302.08,22.22 }

	Teleport[#Teleport+1] = { -3712.31,267.41,21.01,-3743.86,395.23,116.68 }
	Teleport[#Teleport+1] = { -3743.86,395.23,116.68,-3712.31,267.41,21.01 }

	Teleport[#Teleport+1] = { -3605.53,279.18,22.22,-3597.85,289.82,60.96 }
	Teleport[#Teleport+1] = { -3597.85,289.82,60.96,-3605.53,279.18,22.22 }

	Teleport[#Teleport+1] = { -800.22,6144.07,15.27,-821.77,-1237.63,6.87 }
	Teleport[#Teleport+1] = { -821.77,-1237.63,6.87,-800.22,6144.07,15.27 }

	Teleport[#Teleport+1] = { -908.59,-750.40,18.06,-938.42,-717.83,39.06 } -- Elevador
	Teleport[#Teleport+1] = { -938.42,-717.83,39.06,-908.59,-750.40,18.06 }

	Teleport[#Teleport+1] = { -2437.52,-1665.44,19.93,-855.13,-11.3,40.56 }
	Teleport[#Teleport+1] = { -855.13,-11.3,40.56,-2437.52,-1665.44,19.93 }

elseif cityName == "Boomerang" then
	Teleport[#Teleport+1] = { -1464.76,182.8,55.92,-1237.45,813.63,193.37 } 
	Teleport[#Teleport+1] = { -1237.45,813.63,193.37,-1464.76,182.8,55.92 }

	Teleport[#Teleport+1] = { 2475.8,-384.09,94.39,-1902.07,2910.49,32.81 }
	Teleport[#Teleport+1] = { -1902.07,2910.49,32.81,2475.8,-384.09,94.39 }

	Teleport[#Teleport+1] = { 1090.34,3765.57,41.2,1107.16,243.12,-45.85 }
	Teleport[#Teleport+1] = { 1107.16,243.12,-45.85,1090.34,3765.57,41.2 }

	Teleport[#Teleport+1] = { 891.94,326.95,111.76,2008.11,-1586.61,253.38 }
	Teleport[#Teleport+1] = { 2008.11,-1586.61,253.38,891.94,326.95,111.76 }

	Teleport[#Teleport+1] = { -79.32,991.79,234.40,1646.66,7036.94,5.74 }
	Teleport[#Teleport+1] = { 1646.66,7036.94,5.74,-79.32,991.79,234.40 }

	Teleport[#Teleport+1] = { 1054.44,3665.0,34.15,1014.88,882.65,220.36 }
	Teleport[#Teleport+1] = { 1014.88,882.65,220.36,1054.44,3665.0,34.15 }

	Teleport[#Teleport+1] = { -2003.03,4486.11,57.29,-1947.34,4491.71,34.93 }
	Teleport[#Teleport+1] = { -1947.34,4491.71,34.93,-2003.03,4486.11,57.29 }

	Teleport[#Teleport+1] = { -1474.44,-912.79,10.03,-147.36,994.91,236.91 }
	Teleport[#Teleport+1] = { -147.36,994.91,236.91,-1474.44,-912.79,10.03 }

	Teleport[#Teleport+1] = { -272.91,6320.21,32.32,-271.23,6321.8,37.56 }
	Teleport[#Teleport+1] = { -271.23,6321.8,37.56,-272.91,6320.21,32.32 }

	Teleport[#Teleport+1] = { -2590.11,1921.41,167.40,-481.58,1607.32,375.10 } -- Mansao11
	Teleport[#Teleport+1] = { -481.58,1607.32,375.10,-2590.11,1921.41,167.40 } -- Mansao11

	Teleport[#Teleport+1] = { 80.21,6548.33,35.18,73.9,6549.82,51.93 }
	Teleport[#Teleport+1] = { 73.9,6549.82,51.93,80.21,6548.33,35.18 }

	Teleport[#Teleport+1] = { -2279.80,345.26,174.60,-2186.21,209.07,194.6 }
	Teleport[#Teleport+1] = { -2186.21,209.07,194.6,-2279.80,345.26,174.60 }

	Teleport[#Teleport+1] = { 146.06,-364.81,44.94,130.7,-374.01,61.6 }
	Teleport[#Teleport+1] = { 130.7,-374.01,61.6,146.06,-364.81,44.94 }

	Teleport[#Teleport+1] = { -1027.64,-998.39,2.15,-1021.86,-1006.85,4.11 } 
	Teleport[#Teleport+1] = { -1021.86,-1006.85,4.11,-1027.64,-998.39,2.15 }

	Teleport[#Teleport+1] = { 1993.81,-510.37,12.33,272.99,-1636.51,32.25 } -- Mansao_19
	Teleport[#Teleport+1] = { 272.99,-1636.51,32.25,1993.81,-510.37,12.33 }

	Teleport[#Teleport+1] = { 1047.53,3667.11,34.15,163.56,-108.72,61.37 } 
	Teleport[#Teleport+1] = { 163.56,-108.72,61.37,1047.53,3667.11,34.15 }

	Teleport[#Teleport+1] = { -339.98,-1523.09,27.74,-307.22,-1655.49,32.28 } -- QG_112
	Teleport[#Teleport+1] = { -307.22,-1655.49,32.28,-339.98,-1523.09,27.74 }

	Teleport[#Teleport+1] = { -343.47,-159.24,44.59,-3470.28,1295.60,7.55 } 
	Teleport[#Teleport+1] = { -3470.28,1295.60,7.55,-343.47,-159.24,44.59 }

	Teleport[#Teleport+1] = { -2268.39,378.54,188.76,-2276.35,346.88,174.60 } 
	Teleport[#Teleport+1] = { -2276.35,346.88,174.60,-2268.39,378.54,188.76 }

	Teleport[#Teleport+1] = { 960.51,-962.70,42.95,931.32,-934.23,59.10 } 
	Teleport[#Teleport+1] = { 931.32,-934.23,59.10,960.51,-962.70,42.95 }

	Teleport[#Teleport+1] = { -2039.90,-131.74,27.57,-2336.60,-251.08,47.82 } 
	Teleport[#Teleport+1] = { -2336.60,-251.08,47.82,-2039.90,-131.74,27.57 }

	Teleport[#Teleport+1] = { 559.32,6597.52,28.23,281.56,-986.13,33.10 } 
	Teleport[#Teleport+1] = { 281.56,-986.13,33.10,559.32,6597.52,28.23 }

	Teleport[#Teleport+1] = { -1748.95,-724.93,10.45,3044.11,5052.06,26.12 } 
	Teleport[#Teleport+1] = { 3044.11,5052.06,26.12,-1748.95,-724.93,10.45 }

	Teleport[#Teleport+1] = { 1827.49,456.00,166.64,1618.79,446.85,253.23 } 
	Teleport[#Teleport+1] = { 1618.79,446.85,253.23,1827.49,456.00,166.64 }

	-- Teleport[#Teleport+1] = { 69.07,1855.72,116.26,-1367.26,-614.10,30.32 } 
	-- Teleport[#Teleport+1] = { -1367.26,-614.10,30.32,69.07,1855.72,116.26 }

	Teleport[#Teleport+1] = { -2240.86,-261.93,46.42,-2257.36,-129.70,108.31 } 
	Teleport[#Teleport+1] = { -2257.36,-129.70,108.31,-2240.86,-261.93,46.42 }

	Teleport[#Teleport+1] = { 2632.78,3651.85,105.40,2332.04,3293.08,51.92 } 
	Teleport[#Teleport+1] = { 2332.04,3293.08,51.92,2632.78,3651.85,105.40 }

	Teleport[#Teleport+1] = { -625.37,-127.22,36.02,-365.49,6102.72,35.44 } 
	Teleport[#Teleport+1] = { -365.49,6102.72,35.44,-625.37,-127.22,36.02 }

	Teleport[#Teleport+1] = { -2053.24,-142.08,26.85,-2200.24,-278.12,35.57 } 
	Teleport[#Teleport+1] = { -2200.24,-278.12,35.57,-2053.24,-142.08,26.85 }

	Teleport[#Teleport+1] = { -3949.56,-828.28,13.26,-3230.57,809.49,14.08 } 
	Teleport[#Teleport+1] = { -3230.57,809.49,14.08,-3949.56,-828.28,13.26 }

	Teleport[#Teleport+1] = { 1461.59,1086.94,114.33,807.12,3435.06,57.86 } 
	Teleport[#Teleport+1] = { 807.12,3435.06,57.86,1461.59,1086.94,114.33 }

	Teleport[#Teleport+1] = { -3184.32,817.73,8.93,-3949.57,-827.94,13.26 } 
	Teleport[#Teleport+1] = { -3949.57,-827.94,13.26,-3184.32,817.73,8.93 }

	Teleport[#Teleport+1] = { -2375.32,1777.56,212.13,-2568.41,-2240.62,5.05 } 
	Teleport[#Teleport+1] = { -2568.41,-2240.62,5.05,-2375.32,1777.56,212.13 }

	Teleport[#Teleport+1] = { -1572.5,-394.52,59.14,-1566.93,-406.77,42.38 } 
	Teleport[#Teleport+1] = { -1566.93,-406.77,42.38,-1572.5,-394.52,59.14 }

	Teleport[#Teleport+1] = { -1581.21,374.54,98.66,2585.93,6147.9,162.92 }
	Teleport[#Teleport+1] = { 2585.93,6147.9,162.92,-1581.21,374.54,98.66 }

	Teleport[#Teleport+1] = { -770.54,309.17,85.7,-768.8,336.73,243.38 }
	Teleport[#Teleport+1] = { -768.8,336.73,243.38,-770.54,309.17,85.7 }

	Teleport[#Teleport+1] = { -3939.35,-832.10,13.26,-3082.61,3429.55,12.52 }
	Teleport[#Teleport+1] = { -3082.61,3429.55,12.52,-3939.35,-832.10,13.26 }

	-- Calisto
	Teleport[#Teleport+1] = { 380.37,-15.25,83.0,414.95,-15.21,99.65 }
	Teleport[#Teleport+1] = { 414.95,-15.21,99.65,380.37,-15.25,83.0 }

	Teleport[#Teleport+1] = { -325.66,-143.3,60.47,-334.02,-90.87,47.04 }
	Teleport[#Teleport+1] = { -334.02,-90.87,47.04,-325.66,-143.3,60.47 }

	Teleport[#Teleport+1] = { -256.95,6334.18,32.43,1150.44,-1556.82,35.38 }
	Teleport[#Teleport+1] = { 1150.44,-1556.82,35.38,-256.95,6334.18,32.43 }

	Teleport[#Teleport+1] = { 3540.52,3675.41,28.12,3540.59,3675.34,20.99 }
	Teleport[#Teleport+1] = { 3540.59,3675.34,20.99,3540.52,3675.41,28.12 }
	-- dp tatica
	Teleport[#Teleport+1] = { -786.48,-1212.63,6.86,-777.04,-1226.04,15.55 }
	Teleport[#Teleport+1] = { -777.04,-1226.04,15.55,-786.48,-1212.63,6.86 }

	Teleport[#Teleport+1] = { 2620.07,5364.66,47.3,2549.44,-314.94,93.1 }
	Teleport[#Teleport+1] = { 2549.44,-314.94,93.1,2620.07,5364.66,47.3 }

	Teleport[#Teleport+1] = { 2641.47,3617.21,110.08,2593.05,3633.85,-6.07 }
	Teleport[#Teleport+1] = { 2593.05,3633.85,-6.07,2641.47,3617.21,110.08 }

	Teleport[#Teleport+1] = { 2590.61,3657.68,-5.49,2349.64,3314.75,54.86 }
	Teleport[#Teleport+1] = { 2349.64,3314.75,54.86,2590.61,3657.68,-5.49 }
	-- dp zancudo
	Teleport[#Teleport+1] = { 2540.06,-432.42,94.12,-862.61,-1227.5,6.45 }
	Teleport[#Teleport+1] = { -862.61,-1227.5,6.45,2540.06,-432.42,94.12 }

	Teleport[#Teleport+1] = { 4890.18,-5454.87,33.72,259.56,-783.15,30.5 }
	Teleport[#Teleport+1] = { 259.56,-783.15,30.5,4890.18,-5454.87,33.72 }

	Teleport[#Teleport+1] = { 835.11,326.51,118.35,-111.61,827.87,235.73 }
	Teleport[#Teleport+1] = { -111.61,827.87,235.73,835.11,326.51,118.35 }
	-- civil para militar
	Teleport[#Teleport+1] = { -389.59,6050.64,31.49,2540.02,-335.65,94.31 }
	Teleport[#Teleport+1] = { 2540.02,-335.65,94.31,-389.59,6050.64,31.49 }

	Teleport[#Teleport+1] = { -170.49,8250.23,12.82,-196.37,6566.81,11.14 }
	Teleport[#Teleport+1] = { -196.37,6566.81,11.14,-170.49,8250.23,12.82 }

	Teleport[#Teleport+1] = { -1799.1,-1327.99,7.18,1399.53,1496.56,113.87 }
	Teleport[#Teleport+1] = { 1399.53,1496.56,113.87,-1799.1,-1327.99,7.18 }

	Teleport[#Teleport+1] = { -2663.89,1298.76,147.44,-1788.01,427.84,122.63 }
	Teleport[#Teleport+1] = { -1788.01,427.84,122.63,-2663.89,1298.76,147.44 }

	Teleport[#Teleport+1] = { 1036.86,-2544.59,32.28,3481.69,5121.49,9.69 }
	Teleport[#Teleport+1] = { 3481.69,5121.49,9.69,1036.86,-2544.59,32.28 }

	Teleport[#Teleport+1] = { -1877.61,-1160.96,11.73,-2020.52,4461.76,57.25 }
	Teleport[#Teleport+1] = { -2020.52,4461.76,57.25,-1877.61,-1160.96,11.73 }
	-- bombeiros
	Teleport[#Teleport+1] = { -620.95,-108.75,38.15,-2094.81,2829.59,33.16 }
	Teleport[#Teleport+1] = { -2094.81,2829.59,33.16,-620.95,-108.75,38.15 }

	Teleport[#Teleport+1] = { 3466.46,5098.5,9.39,3402.65,4994.3,30.85 }
	Teleport[#Teleport+1] = { 3402.65,4994.3,30.85,3466.46,5098.5,9.39 }

	-- mansao74
	Teleport[#Teleport+1] = { -3933.05,-859.74,7.6,1036.82,-2544.64,32.28 }
	Teleport[#Teleport+1] = { 1036.82,-2544.64,32.28,-3933.05,-859.74,7.6 }

	Teleport[#Teleport+1] = { -4492.64,-28.91,8.1,1174.16,871.92,144.03 }
	Teleport[#Teleport+1] = { 1174.16,871.92,144.03,-4492.64,-28.91,8.1 }

	Teleport[#Teleport+1] = { 916.55,1744.5,165.79,819.0,1785.34,150.86 }
	Teleport[#Teleport+1] = { 819.0,1785.34,150.86,916.55,1744.5,165.79 }

	Teleport[#Teleport+1] = { -416.62,1590.49,358.28,-77.53,1528.67,286.14 }
	Teleport[#Teleport+1] = { -77.53,1528.67,286.14,-416.62,1590.49,358.28 }

	Teleport[#Teleport+1] = { -433.51,1592.43,360.32,-454.81,1547.02,393.22 }
	Teleport[#Teleport+1] = { -454.81,1547.02,393.22,-433.51,1592.43,360.32 }

	Teleport[#Teleport+1] = { -319.55,1620.08,343.79,-403.8,1582.98,357.37 }
	Teleport[#Teleport+1] = { -403.8,1582.98,357.37,-319.55,1620.08,343.79 }

	Teleport[#Teleport+1] = { -468.65,1553.48,393.24,-456.31,1539.66,407.24 }
	Teleport[#Teleport+1] = { -456.31,1539.66,407.24,-468.65,1553.48,393.24 }

	Teleport[#Teleport+1] = { -451.51,1601.03,360.08,-466.32,1618.98,461.55 }
	Teleport[#Teleport+1] = { -466.32,1618.98,461.55,-451.51,1601.03,360.08 }

	Teleport[#Teleport+1] = { 958.09,-952.54,50.33,503.61,-3121.96,9.79 }
	Teleport[#Teleport+1] = { 503.61,-3121.96,9.79,958.09,-952.54,50.33 }

	Teleport[#Teleport+1] = { -447.73,1611.2,363.25,1127.54,3069.62,42.24 }
	Teleport[#Teleport+1] = { 1127.54,3069.62,42.24,-447.73,1611.2,363.25 }

	Teleport[#Teleport+1] = { 1131.3,3056.68,42.24,3138.02,5378.14,26.15 }
	Teleport[#Teleport+1] = { 3138.02,5378.14,26.15,1131.3,3056.68,42.24 }

	Teleport[#Teleport+1] = { 201.3,725.85,205.85,-1801.59,-1326.11,7.78 }
	Teleport[#Teleport+1] = { -1801.59,-1326.11,7.78,201.3,725.85,205.85 }

	Teleport[#Teleport+1] = { 62.88,2165.74,-84.22,-3421.0,73.38,12.47 }
	Teleport[#Teleport+1] = { -3421.0,73.38,12.47,62.88,2165.74,-84.22 }

	Teleport[#Teleport+1] = { 140.29,-141.0,49.57,122.08,-127.62,54.93 }
	Teleport[#Teleport+1] = { 122.08,-127.62,54.93,140.29,-141.0,49.57 }

	Teleport[#Teleport+1] = { 125.11,-115.43,49.76,773.25,1423.56,-84.22 }
	Teleport[#Teleport+1] = { 773.25,1423.56,-84.22,125.11,-115.43,49.76 }

	Teleport[#Teleport+1] = { -1399.52,-482.0,72.03,940.77,2.08,111.28 }
	Teleport[#Teleport+1] = { 940.77,2.08,111.28,-1399.52,-482.0,72.03 }

	Teleport[#Teleport+1] = { -695.27,6390.47,13.31,1219.14,-1534.97,34.9 }
	Teleport[#Teleport+1] = { 1219.14,-1534.97,34.9,-695.27,6390.47,13.31 }

	Teleport[#Teleport+1] = { -453.27,1618.05,362.96,-146.12,889.92,235.64 }
	Teleport[#Teleport+1] = { -146.12,889.92,235.64,-453.27,1618.05,362.96 }

	Teleport[#Teleport+1] = { -149.45,892.9,235.64,-1229.55,846.44,193.37 }
	Teleport[#Teleport+1] = { -1229.55,846.44,193.37,-149.45,892.9,235.64 }	

	Teleport[#Teleport+1] = { -280.93,6404.91,31.39,-5841.6,1146.02,7.57 }
	Teleport[#Teleport+1] = { -5841.6,1146.02,7.57,-280.93,6404.91,31.39 }	

	Teleport[#Teleport+1] = { -450.11,1616.95,360.42,5030.1,-5759.77,15.74 }
	Teleport[#Teleport+1] = { 5030.1,-5759.77,15.74,-450.11,1616.95,360.42 }

	Teleport[#Teleport+1] = { 742.36,-814.16,24.26,-835.64,262.45,82.8 }
	Teleport[#Teleport+1] = { -835.64,262.45,82.8,742.36,-814.16,24.26 }

	Teleport[#Teleport+1] = { -3305.7,557.19,17.44,-398.91,4392.52,58.77 }
	Teleport[#Teleport+1] = { -398.91,4392.52,58.77,-3305.7,557.19,17.44 }

	-- Prf
	Teleport[#Teleport+1] = { -764.59,-1240.74,5.7,2624.37,5314.13,47.52 }
	Teleport[#Teleport+1] = { 2624.37,5314.13,47.52,-764.59,-1240.74,5.7 }

	-- Militar
	Teleport[#Teleport+1] = { -761.47,-1243.31,5.7,2540.05,-335.6,94.33 }
	Teleport[#Teleport+1] = { 2540.05,-335.6,94.33,-761.47,-1243.31,5.7 }

	-- Exercito
	Teleport[#Teleport+1] = { -757.62,-1246.82,5.7,-1832.05,3020.55,32.81 }
	Teleport[#Teleport+1] = { -1832.05,3020.55,32.81,-757.62,-1246.82,5.7 }

	-- Civil
	Teleport[#Teleport+1] = { -754.08,-1249.74,5.7,-450.13,6010.5,27.58 }
	Teleport[#Teleport+1] = { -450.13,6010.5,27.58,-754.08,-1249.74,5.7 }

	Teleport[#Teleport+1] = { 1035.43,903.67,220.36,897.22,1030.38,277.15 }
	Teleport[#Teleport+1] = { 897.22,1030.38,277.15,1035.43,903.67,220.36 }

	Teleport[#Teleport+1] = { -2268.19,378.16,188.76,2276.11,346.65,174.61 }
	Teleport[#Teleport+1] = { 2276.11,346.65,174.61,-2268.19,378.16,188.76 }

	Teleport[#Teleport+1] = { 119.61,-120.50,54.92,1433.08,4705.48,129.74 }
	Teleport[#Teleport+1] = { 1433.08,4705.48,129.74,119.61,-120.50,54.92 }

	Teleport[#Teleport+1] = { -1045.68,311.18,71.67,-1045.32,299.39,76.33 }
	Teleport[#Teleport+1] = { -1045.32,299.39,76.33,-1045.68,311.18,71.67 }

	Teleport[#Teleport+1] = { 1352.95,-2271.43,62.06,1401.87,-2390.11,68.21 }
	Teleport[#Teleport+1] = { 1401.87,-2390.11,68.21,1352.95,-2271.43,62.06 }

	Teleport[#Teleport+1] = { 93.54,-1297.5,29.32,-2623.15,1698.70,141.72 }
	Teleport[#Teleport+1] = { -2623.15,1698.70,141.72,93.54,-1297.5,29.32 }

	Teleport[#Teleport+1] = { 109.70,-1977.48,20.96,22.05,535.55,170.62 }
	Teleport[#Teleport+1] = { 22.05,535.55,170.62,109.70,-1977.48,20.96 }

	Teleport[#Teleport+1] = { 981.04,485.55,112.25,-3539.80,4629.07,10.33 }
	Teleport[#Teleport+1] = { -3539.80,4629.07,10.33,981.04,485.55,112.25 }

	Teleport[#Teleport+1] = { -111.17,578.12,196.76,-105.83,582.15,207.88 }
	Teleport[#Teleport+1] = { -105.83,582.15,207.88,-111.17,578.12,196.76 }

	Teleport[#Teleport+1] = { -106.28,582.06,196.76,-103.06,590.51,204.54 }
	Teleport[#Teleport+1] = { -103.06,590.51,204.54,-106.28,582.06,196.76 }

	Teleport[#Teleport+1] = { 2736.92,3512.20,55.71,-3212.08,804.23,8.93 }
	Teleport[#Teleport+1] = { -3212.08,804.23,8.93,2736.92,3512.20,55.71 }

	Teleport[#Teleport+1] = { 1391.93,-751.79,72.15,1521.0,-777.11,207.13 }
	Teleport[#Teleport+1] = { 1521.0,-777.11,207.13,1391.93,-751.79,72.15 }

	Teleport[#Teleport+1] = { -1579.57,-564.92,108.52,-101.97,585.13,207.88 }
	Teleport[#Teleport+1] = { -101.97,585.13,207.88,-1579.57,-564.92,108.52 }

	Teleport[#Teleport+1] = { -3787.45,251.17,22.81,-3787.42,249.17,29.67 }
	Teleport[#Teleport+1] = { -3787.42,249.17,29.67,-3787.45,251.17,22.81 }

	Teleport[#Teleport+1] = { -3857.44,337.6,101.72,-3835.95,336.02,22.22 }
	Teleport[#Teleport+1] = { -3835.95,336.02,22.22,-3857.44,337.6,101.72 }

	Teleport[#Teleport+1] = { -3776.87,346.2,127.74,-3690.71,382.49,22.49 }
	Teleport[#Teleport+1] = { -3690.71,382.49,22.49,-3776.87,346.2,127.74 }

	Teleport[#Teleport+1] = { -3862.53,302.08,22.22,-3855.27,301.43,50.89 }
	Teleport[#Teleport+1] = { -3855.27,301.43,50.89,-3862.53,302.08,22.22 }

	Teleport[#Teleport+1] = { -3743.86,395.23,116.68,-3840.26,291.06,50.89 }
	Teleport[#Teleport+1] = { -3840.26,291.06,50.89,-3743.86,395.23,116.68 }

	Teleport[#Teleport+1] = { -3605.53,279.18,22.22,-3597.85,289.82,60.96 }
	Teleport[#Teleport+1] = { -3597.85,289.82,60.96,-3605.53,279.18,22.22 }

elseif cityName == "Malta" then
	Teleport[#Teleport+1] = { -1197.32,825.51,191.21,2027.98,4303.67,38.25 }
	Teleport[#Teleport+1] = { 2027.98,4303.67,38.25,-1197.32,825.51,191.21 }

	Teleport[#Teleport+1] = { 1812.06,3911.32,35.05,-787.42,5.39,41.68 }
	Teleport[#Teleport+1] = { -787.42,5.39,41.68,1812.06,3911.32,35.05 }

	Teleport[#Teleport+1] = { -331.43,-609.28,32.78,-331.50,-609.42,37.34 } -- hp
	Teleport[#Teleport+1] = { -331.50,-609.42,37.34,-331.43,-609.28,32.78 }

	Teleport[#Teleport+1] = { -1176.30,-1239.30,6.96,-1174.92,-1239.41,16.01 } -- bombeiros
	Teleport[#Teleport+1] = { -1174.92,-1239.41,16.01,-1176.30,-1239.30,6.96 }

	Teleport[#Teleport+1] = { -304.49,-590.64,32.78,-302.26,-593.49,47.98 } -- paramedic
	Teleport[#Teleport+1] = { -302.26,-593.49,47.98,-304.49,-590.64,32.78 }

	Teleport[#Teleport+1] = { 1207.86,3092.67,41.67,1207.67,3092.76,50.59 } -- QG_459 
	Teleport[#Teleport+1] = { 1207.67,3092.76,50.59,1207.86,3092.67,41.67 }

	Teleport[#Teleport+1] = { 1056.31,3062.10,45.69,1056.13,3061.99,52.39 } -- QG_459 
	Teleport[#Teleport+1] = { 1056.13,3061.99,52.39,1056.31,3062.10,45.69 }

	Teleport[#Teleport+1] = { -71.05,-801.01,44.23,-75.0,-824.54,321.29 }
	Teleport[#Teleport+1] = { -75.0,-824.54,321.29,-71.05,-801.01,44.23 }

	Teleport[#Teleport+1] = { -2308.99,350.52,178.57,-2290.46,266.04,164.47 }
	Teleport[#Teleport+1] = { -2290.46,266.04,164.47,-2308.99,350.52,178.57 }

	Teleport[#Teleport+1] = { 4991.57,-5732.80,14.84,5012.85,-5748.25,28.95 }
	Teleport[#Teleport+1] = { 5012.85,-5748.25,28.95,4991.57,-5732.80,14.84 }

	Teleport[#Teleport+1] = { 788.27,5743.32,702.57,-1032.29,875.07,220.37 }
	Teleport[#Teleport+1] = { -1032.29,875.07,220.37,788.27,5743.32,702.57 }

	Teleport[#Teleport+1] = { 687.37,919.83,247.60,773.93,5752.30,698.72 }
	Teleport[#Teleport+1] = { 773.93,5752.30,698.72,687.37,919.83,247.60 }

	Teleport[#Teleport+1] = { -3737.94,3759.37,14.79,-3726.25,3753.59,64.82 } -- Mansao170
	Teleport[#Teleport+1] = { -3726.25,3753.59,64.82,-3737.94,3759.37,14.79 }

	Teleport[#Teleport+1] = { 1125.25,-1576.53,35.38,-659.01,-87.99,38.79 }
	Teleport[#Teleport+1] = { -659.01,-87.99,38.79,1125.25,-1576.53,35.38 }

	Teleport[#Teleport+1] = { 87.41,6505.05,31.26,779.66,5751.16,698.76 }
	Teleport[#Teleport+1] = { 779.66,5751.16,698.76,87.41,6505.05,31.26 }

	Teleport[#Teleport+1] = { -2209.23,3316.35,34.72,-743.22,-1241.74,5.70 }
	Teleport[#Teleport+1] = { -743.22,-1241.74,5.70,-2209.23,3316.35,34.72 }

	Teleport[#Teleport+1] = { -2090.53,2837.97,32.96,2488.19,-404.03,93.74 }
	Teleport[#Teleport+1] = { 2488.19,-404.03,93.74,-2090.53,2837.97,32.96 }

	Teleport[#Teleport+1] = { -1918.49,3315.40,33.35,-1917.26,3315.64,144.11 }
	Teleport[#Teleport+1] = { -1917.26,3315.64,144.11,-1918.49,3315.40,33.35 }

	Teleport[#Teleport+1] = { -1905.36,3319.32,33.35,-1905.36,3319.32,33.35 }
	Teleport[#Teleport+1] = { -1905.36,3319.32,33.35,-1905.36,3319.32,33.35 }

	Teleport[#Teleport+1] = { -3097.6,1494.86,37.27,-3287.7,1503.53,5.66 }
	Teleport[#Teleport+1] = { -3287.7,1503.53,5.66,-3097.6,1494.86,37.27 }

	Teleport[#Teleport+1] = { 2475.8,-384.09,94.39,-1902.07,2910.49,32.81 }
	Teleport[#Teleport+1] = { -1902.07,2910.49,32.81,2475.8,-384.09,94.39 }

	Teleport[#Teleport+1] = { -1752.69,174.85,118.12,-1765.1,172.57,68.09 }
	Teleport[#Teleport+1] = { -1765.1,172.57,68.09,-1752.69,174.85,118.12 }

	Teleport[#Teleport+1] = { 1547.75,1408.65,108.74,1543.47,1353.07,97.39 }
	Teleport[#Teleport+1] = { 1543.47,1353.07,97.39,1547.75,1408.65,108.74 }

	Teleport[#Teleport+1] = { -2986.56,43.01,11.61,-3077.85,97.88,100.95 }
	Teleport[#Teleport+1] = { -3077.85,97.88,100.95,-2986.56,43.01,11.61 }

	Teleport[#Teleport+1] = { -1509.01,130.09,55.65,-1510.62,173.85,143.37 }
	Teleport[#Teleport+1] = { -1510.62,173.85,143.37,-1509.01,130.09,55.65 }

	Teleport[#Teleport+1] = { -1581.21,374.54,98.66,2585.93,6147.9,162.92 }
	Teleport[#Teleport+1] = { 2585.93,6147.9,162.92,-1581.21,374.54,98.66 }

	Teleport[#Teleport+1] = { -770.54,309.17,85.7,-768.8,336.73,243.38 }
	Teleport[#Teleport+1] = { -768.8,336.73,243.38,-770.54,309.17,85.7 }

	Teleport[#Teleport+1] = { -513.92,-177.39,38.22,1712.30,2621.57,45.55 } -- juridico
	Teleport[#Teleport+1] = { 1712.30,2621.57,45.55,-513.92,-177.39,38.22 }

	Teleport[#Teleport+1] = { 1141.01,-1567.96,35.03,-262.33,6319.11,32.42 }
	Teleport[#Teleport+1] = { -262.33,6319.11,32.42,1141.01,-1567.96,35.03 }
	-- Calisto
	Teleport[#Teleport+1] = { 380.37,-15.25,83.0,414.95,-15.21,99.65 }
	Teleport[#Teleport+1] = { 414.95,-15.21,99.65,380.37,-15.25,83.0 }

	Teleport[#Teleport+1] = { -325.66,-143.3,60.47,-334.02,-90.87,47.04 }
	Teleport[#Teleport+1] = { -334.02,-90.87,47.04,-325.66,-143.3,60.47 }

	Teleport[#Teleport+1] = { 1149.82,-1556.38,35.38,-262.62,6318.93,32.42 }
	Teleport[#Teleport+1] = { -262.62,6318.93,32.42,1149.82,-1556.38,35.38 }

	Teleport[#Teleport+1] = { 3540.52,3675.41,28.12,3540.59,3675.34,20.99 }
	Teleport[#Teleport+1] = { 3540.59,3675.34,20.99,3540.52,3675.41,28.12 }
	-- dp tatica
	Teleport[#Teleport+1] = { -786.48,-1212.63,6.86,-777.04,-1226.04,15.55 }
	Teleport[#Teleport+1] = { -777.04,-1226.04,15.55,-786.48,-1212.63,6.86 }

	Teleport[#Teleport+1] = { 2620.07,5364.66,47.3,2549.44,-314.94,93.1 }
	Teleport[#Teleport+1] = { 2549.44,-314.94,93.1,2620.07,5364.66,47.3 }

	Teleport[#Teleport+1] = { 2641.47,3617.21,110.08,2593.05,3633.85,-6.07 }
	Teleport[#Teleport+1] = { 2593.05,3633.85,-6.07,2641.47,3617.21,110.08 }

	Teleport[#Teleport+1] = { 2590.61,3657.68,-5.49,2349.64,3314.75,54.86 }
	Teleport[#Teleport+1] = { 2349.64,3314.75,54.86,2590.61,3657.68,-5.49 }
	-- dp zancudo
	Teleport[#Teleport+1] = { 2540.06,-432.42,94.12,-862.61,-1227.5,6.45 }
	Teleport[#Teleport+1] = { -862.61,-1227.5,6.45,2540.06,-432.42,94.12 }

	Teleport[#Teleport+1] = { 835.11,326.51,118.35,-111.61,827.87,235.73 }
	Teleport[#Teleport+1] = { -111.61,827.87,235.73,835.11,326.51,118.35 }
	-- civil para militar
	Teleport[#Teleport+1] = { -389.59,6050.64,31.49,2540.02,-335.65,94.31 }
	Teleport[#Teleport+1] = { 2540.02,-335.65,94.31,-389.59,6050.64,31.49 }

	Teleport[#Teleport+1] = { -170.49,8250.23,12.82,-196.37,6566.81,11.14 }
	Teleport[#Teleport+1] = { -196.37,6566.81,11.14,-170.49,8250.23,12.82 }

	Teleport[#Teleport+1] = { -1799.1,-1327.99,7.18,1399.53,1496.56,113.87 }
	Teleport[#Teleport+1] = { 1399.53,1496.56,113.87,-1799.1,-1327.99,7.18 }

	Teleport[#Teleport+1] = { -2663.89,1298.76,147.44,-1788.01,427.84,122.63 }
	Teleport[#Teleport+1] = { -1788.01,427.84,122.63,-2663.89,1298.76,147.44 }

	Teleport[#Teleport+1] = { 1036.86,-2544.59,32.28,3481.69,5121.49,9.69 }
	Teleport[#Teleport+1] = { 3481.69,5121.49,9.69,1036.86,-2544.59,32.28 }

	Teleport[#Teleport+1] = { -768.61,332.84,243.38,-2578.19,-2236.66,5.05 }
	Teleport[#Teleport+1] = { -2578.19,-2236.66,5.05,-768.61,332.84,243.38 }

	Teleport[#Teleport+1] = { 3466.46,5098.5,9.39,3402.65,4994.3,30.85 }
	Teleport[#Teleport+1] = { 3402.65,4994.3,30.85,3466.46,5098.5,9.39 }

	-- mansao74
	Teleport[#Teleport+1] = { -3933.05,-859.74,7.6,1036.82,-2544.64,32.28 }
	Teleport[#Teleport+1] = { 1036.82,-2544.64,32.28,-3933.05,-859.74,7.6 }

	Teleport[#Teleport+1] = { -2615.59,3729.63,13.11,1900.19,6392.88,55.1 }
	Teleport[#Teleport+1] = { 1900.19,6392.88,55.1,-2615.59,3729.63,13.11 }

	Teleport[#Teleport+1] = { -4492.64,-28.91,8.1,1174.16,871.92,144.03 }
	Teleport[#Teleport+1] = { 1174.16,871.92,144.03,-4492.64,-28.91,8.1 }

	Teleport[#Teleport+1] = { 916.55,1744.5,165.79,819.0,1785.34,150.86 }
	Teleport[#Teleport+1] = { 819.0,1785.34,150.86,916.55,1744.5,165.79 }

	Teleport[#Teleport+1] = { -416.62,1590.49,358.28,-77.53,1528.67,286.14 }
	Teleport[#Teleport+1] = { -77.53,1528.67,286.14,-416.62,1590.49,358.28 }

	Teleport[#Teleport+1] = { -433.51,1592.43,360.32,-454.81,1547.02,393.22 }
	Teleport[#Teleport+1] = { -454.81,1547.02,393.22,-433.51,1592.43,360.32 }

	Teleport[#Teleport+1] = { -319.55,1620.08,343.79,-403.8,1582.98,357.37 }
	Teleport[#Teleport+1] = { -403.8,1582.98,357.37,-319.55,1620.08,343.79 }

	Teleport[#Teleport+1] = { -468.65,1553.48,393.24,-456.31,1539.66,407.24 }
	Teleport[#Teleport+1] = { -456.31,1539.66,407.24,-468.65,1553.48,393.24 }

	Teleport[#Teleport+1] = { -451.51,1601.03,360.08,-466.32,1618.98,461.55 }
	Teleport[#Teleport+1] = { -466.32,1618.98,461.55,-451.51,1601.03,360.08 }

	Teleport[#Teleport+1] = { 958.09,-952.54,50.33,503.61,-3121.96,9.79 }
	Teleport[#Teleport+1] = { 503.61,-3121.96,9.79,958.09,-952.54,50.33 }

	Teleport[#Teleport+1] = { -447.73,1611.2,363.25,1127.54,3069.62,42.24 }
	Teleport[#Teleport+1] = { 1127.54,3069.62,42.24,-447.73,1611.2,363.25 }

	Teleport[#Teleport+1] = { 1131.3,3056.68,42.24,3138.02,5378.14,26.15 }
	Teleport[#Teleport+1] = { 3138.02,5378.14,26.15,1131.3,3056.68,42.24 }

	Teleport[#Teleport+1] = { -148.82,-507.44,-117.71,-10.45,531.3,170.62 }
	Teleport[#Teleport+1] = { -10.45,531.3,170.62,-148.82,-507.44,-117.71 }

	Teleport[#Teleport+1] = { 201.3,725.85,205.85,-1801.59,-1326.11,7.78 }
	Teleport[#Teleport+1] = { -1801.59,-1326.11,7.78,201.3,725.85,205.85 }

	Teleport[#Teleport+1] = { 62.88,2165.74,-84.22,-3421.0,73.38,12.47 }
	Teleport[#Teleport+1] = { -3421.0,73.38,12.47,62.88,2165.74,-84.22 }

	Teleport[#Teleport+1] = { 140.29,-141.0,49.57,122.08,-127.62,54.93 }
	Teleport[#Teleport+1] = { 122.08,-127.62,54.93,140.29,-141.0,49.57 }

	Teleport[#Teleport+1] = { -121.33,-503.3,-117.7,125.11,-115.43,49.77 }
	Teleport[#Teleport+1] = { 125.11,-115.43,49.77,-121.33,-503.3,-117.7 }

	Teleport[#Teleport+1] = { -1399.52,-482.0,72.03,940.77,2.08,111.28 }
	Teleport[#Teleport+1] = { 940.77,2.08,111.28,-1399.52,-482.0,72.03 }

	Teleport[#Teleport+1] = { -695.27,6390.47,13.31,1219.14,-1534.97,34.9 }
	Teleport[#Teleport+1] = { 1219.14,-1534.97,34.9,-695.27,6390.47,13.31 }

	Teleport[#Teleport+1] = { -453.27,1618.05,362.96,-146.12,889.92,235.64 }
	Teleport[#Teleport+1] = { -146.12,889.92,235.64,-453.27,1618.05,362.96 }

	Teleport[#Teleport+1] = { -149.45,892.9,235.64,-1229.55,846.44,193.37 }
	Teleport[#Teleport+1] = { -1229.55,846.44,193.37,-149.45,892.9,235.64 }	

	Teleport[#Teleport+1] = { -280.93,6404.91,31.39,-5841.6,1146.02,7.57 }
	Teleport[#Teleport+1] = { -5841.6,1146.02,7.57,-280.93,6404.91,31.39 }	

	Teleport[#Teleport+1] = { -1064.28,-1663.46,4.55,1988.41,4373.11,37.25 }
	Teleport[#Teleport+1] = { 1988.41,4373.11,37.25,-1064.28,-1663.46,4.55 }

	Teleport[#Teleport+1] = { 2756.96,3428.71,56.16,1995.86,4375.02,37.32 }
	Teleport[#Teleport+1] = { 1995.86,4375.02,37.32,2756.96,3428.71,56.16 }

	Teleport[#Teleport+1] = { -450.11,1616.95,360.42,5030.1,-5759.77,15.74 }
	Teleport[#Teleport+1] = { 5030.1,-5759.77,15.74,-450.11,1616.95,360.42 }

	Teleport[#Teleport+1] = { -2791.22,1443.71,100.83,731.2,-835.58,16.45 }
	Teleport[#Teleport+1] = { 731.2,-835.58,16.45,-2791.22,1443.71,100.83 }

	-- Prf
	Teleport[#Teleport+1] = { -764.59,-1240.74,5.7,2624.37,5314.13,47.52 }
	Teleport[#Teleport+1] = { 2624.37,5314.13,47.52,-764.59,-1240.74,5.7 }

	-- Militar
	Teleport[#Teleport+1] = { -761.47,-1243.31,5.7,2540.05,-335.6,94.33 }
	Teleport[#Teleport+1] = { 2540.05,-335.6,94.33,-761.47,-1243.31,5.7 }

	-- Exercito
	Teleport[#Teleport+1] = { -757.62,-1246.82,5.7,-1832.05,3020.55,32.81 }
	Teleport[#Teleport+1] = { -1832.05,3020.55,32.81,-757.62,-1246.82,5.7 }

	-- Civil
	Teleport[#Teleport+1] = { -754.08,-1249.74,5.7,-450.13,6010.5,27.58 }
	Teleport[#Teleport+1] = { -450.13,6010.5,27.58,-754.08,-1249.74,5.7 }

	Teleport[#Teleport+1] = { 1035.43,903.67,220.36,897.22,1030.38,277.15 }
	Teleport[#Teleport+1] = { 897.22,1030.38,277.15,1035.43,903.67,220.36 }

	Teleport[#Teleport+1] = { 2187.20,3990.48,33.65,-1645.11,-1056.35,13.15 }
	Teleport[#Teleport+1] = { -1645.11,-1056.35,13.15,2187.20,3990.48,33.65 }

	Teleport[#Teleport+1] = { -2268.19,378.16,188.76,2276.11,346.65,174.61 }
	Teleport[#Teleport+1] = { 2276.11,346.65,174.61,-2268.19,378.16,188.76 }

	Teleport[#Teleport+1] = { 119.61,-120.50,54.92,1433.08,4705.48,129.74 }
	Teleport[#Teleport+1] = { 1433.08,4705.48,129.74,119.61,-120.50,54.92 }

	Teleport[#Teleport+1] = { -1045.68,311.18,71.67,-1045.32,299.39,76.33 }
	Teleport[#Teleport+1] = { -1045.32,299.39,76.33,-1045.68,311.18,71.67 }

	Teleport[#Teleport+1] = { 1352.95,-2271.43,62.06,1401.87,-2390.11,68.21 }
	Teleport[#Teleport+1] = { 1401.87,-2390.11,68.21,1352.95,-2271.43,62.06 }

	Teleport[#Teleport+1] = { -539.08,-204.44,37.65,1896.81,3569.60,38.82 } -- Juridico Sandy Shoes
	Teleport[#Teleport+1] = { 1896.81,3569.60,38.82,-539.08,-204.44,37.65 }

	Teleport[#Teleport+1] = { -652.91,-105.81,37.94,1683.71,3571.48,35.43 } -- Bombeiros Sandy Shoes
	Teleport[#Teleport+1] = { 1683.71,3571.48,35.43,-652.91,-105.81,37.94 }

	Teleport[#Teleport+1] = { -327.08,-614.99,32.79,1765.81,3624.48,34.58 } -- Hospital Sandy Shoes
	Teleport[#Teleport+1] = { 1765.81,3624.48,34.58,-327.08,-614.99,32.79 }

	Teleport[#Teleport+1] = { 551.31,-194.28,54.50,1716.76,3687.68,34.52 } -- Mecanica Sandy Shoes
	Teleport[#Teleport+1] = { 1716.76,3687.68,34.52,551.31,-194.28,54.50 }

	Teleport[#Teleport+1] = { -2165.09,3242.29,32.81,1746.35,3803.50,35.46 } -- Exercito Sandy Shoes
	Teleport[#Teleport+1] = { 1746.35,3803.50,35.46,-2165.09,3242.29,32.81 }

	Teleport[#Teleport+1] = { -525.78,-214.44,37.65,1598.78,2550.78,45.55 }
	Teleport[#Teleport+1] = { 1598.78,2550.78,45.55,-525.78,-214.44,37.65 }

elseif cityName == "Kingdom" then
	-- tower bridge
	Teleport[#Teleport+1] = { 521.61,-1052.5,41.0,538.16,-1046.94,100.69 }
	Teleport[#Teleport+1] = { 538.16,-1046.94,100.69,521.61,-1052.5,41.0 }

	Teleport[#Teleport+1] = { -331.85,-608.74,37.34,-652.05,-84.00,38.79 }
	Teleport[#Teleport+1] = { -652.05,-84.00,38.79,-331.85,-608.74,37.34 }

	Teleport[#Teleport+1] = { -304.52,-590.64,32.78,-302.16,-593.83,47.98 } -- paramedic
	Teleport[#Teleport+1] = { -302.16,-593.83,47.98,-304.52,-590.64,32.78 }

	Teleport[#Teleport+1] = { -331.61,-609.10,32.78,-329.88,-611.43,47.98 } -- paramedic
	Teleport[#Teleport+1] = { -329.88,-611.43,47.98,-331.61,-609.10,32.78 }

	Teleport[#Teleport+1] = { -71.05,-801.01,44.23,-75.0,-824.54,321.29 }
	Teleport[#Teleport+1] = { -75.0,-824.54,321.29,-71.05,-801.01,44.23 }

	Teleport[#Teleport+1] = { 773.28,1422.66,-84.2,250.66,-3150.18,3.33 }
	Teleport[#Teleport+1] = { 250.66,-3150.18,3.33,773.28,1422.66,-84.2 }

	Teleport[#Teleport+1] = { -3561.16,4622.77,10.56,-2414.24,4005.9,19.02 }
	Teleport[#Teleport+1] = { -2414.24,4005.9,19.02,-3561.16,4622.77,10.56 }

	Teleport[#Teleport+1] = { -2967.3,-364.04,15.23,-2980.4,-375.91,30.36 } -- MANSAO57
	Teleport[#Teleport+1] = { -2980.4,-375.91,30.36,-2967.3,-364.04,15.23 }

	Teleport[#Teleport+1] = { -273.42,-734.83,125.46,-1574.01,-565.3,108.51 }
	Teleport[#Teleport+1] = { -1574.01,-565.3,108.51,-273.42,-734.83,125.46 }

	Teleport[#Teleport+1] = { -1579.18,-569.05,108.51,-3004.77,-381.65,14.81 }
	Teleport[#Teleport+1] = { -3004.77,-381.65,14.81,-1579.18,-569.05,108.51 }

	Teleport[#Teleport+1] = { -1535.22,-580.95,25.71,-1583.23,-558.85,108.51 }
	Teleport[#Teleport+1] = { -1583.23,-558.85,108.51,-1535.22,-580.95,25.71 }

	Teleport[#Teleport+1] = { 60.41,2304.26,-84.22,255.24,-3186.47,3.23 }
	Teleport[#Teleport+1] = { 255.24,-3186.47,3.23,60.41,2304.26,-84.22 }

	Teleport[#Teleport+1] = { 241.06,-3176.75,1.3,254.88,-3186.58,3.23 }
	Teleport[#Teleport+1] = { 254.88,-3186.58,3.23,241.06,-3176.75,1.3 }

	Teleport[#Teleport+1] = { -313.8,6265.59,31.49,87.62,-1290.21,21.11 } -- QG_259
	Teleport[#Teleport+1] = { 87.62,-1290.21,21.11,-313.8,6265.59,31.49 }

	Teleport[#Teleport+1] = { -2614.18,1717.24,146.32,-557.84,823.61,197.95 }
	Teleport[#Teleport+1] = { -557.84,823.61,197.95,-2614.18,1717.24,146.32 }

	Teleport[#Teleport+1] = { -550.4,823.89,197.51,1431.7,4719.25,129.73 }
	Teleport[#Teleport+1] = { 1431.7,4719.25,129.73,-550.4,823.89,197.51 }

	Teleport[#Teleport+1] = { -533.53,820.11,197.51,-2050.49,3236.5,31.49 }
	Teleport[#Teleport+1] = { -2050.49,3236.5,31.49,-533.53,820.11,197.51 }

	Teleport[#Teleport+1] = { 2475.8,-384.09,94.39,-1902.07,2910.49,32.81 }
	Teleport[#Teleport+1] = { -1902.07,2910.49,32.81,2475.8,-384.09,94.39 }

	Teleport[#Teleport+1] = { 444.3,-1341.23,-78.17,553.79,765.3,206.21 }
	Teleport[#Teleport+1] = { 553.79,765.3,206.21,444.3,-1341.23,-78.17 }

	Teleport[#Teleport+1] = { 63.06,2164.62,-84.22,-293.28,6266.17,31.53 }
	Teleport[#Teleport+1] = { -293.28,6266.17,31.53,63.06,2164.62,-84.22 }

	Teleport[#Teleport+1] = { -2279.82,345.26,174.60,-2290.80,265.98,164.47 }
	Teleport[#Teleport+1] = { -2290.80,265.98,164.47,-2279.82,345.26,174.60 }

	Teleport[#Teleport+1] = { 1418.58,6758.42,11.91,1418.58,6758.42,11.91 }
	Teleport[#Teleport+1] = { 1418.58,6758.42,11.91,1418.58,6758.42,11.91 }

	Teleport[#Teleport+1] = { -1418.58,6758.42,11.91,545.78,746.15,203.17 }
	Teleport[#Teleport+1] = { 545.78,746.15,203.17,-1418.58,6758.42,11.91 }

	Teleport[#Teleport+1] = { 554.43,760.73,203.17,-1399.19,-480.3,72.03 }
	Teleport[#Teleport+1] = { -1399.19,-480.3,72.03,554.43,760.73,203.17 } 

	Teleport[#Teleport+1] = { -3787.53,263.56,22.82,-3796.02,284.81,155.54 }
	Teleport[#Teleport+1] = { -3796.02,284.81,155.54,-3787.53,263.56,22.82 }

	Teleport[#Teleport+1] = { 516.84,-1017.53,40.93,534.22,-1018.18,100.66 }
	Teleport[#Teleport+1] = { 534.22,-1018.18,100.66,516.84,-1017.53,40.93 }

	Teleport[#Teleport+1] = { 725.17,2347.42,-78.17,569.12,756.18,203.17 }
	Teleport[#Teleport+1] = { 569.12,756.18,203.17,725.17,2347.42,-78.17 }

	Teleport[#Teleport+1] = { 636.84,2090.69,110.28,-2976.80,2187.75,41.88 }
	Teleport[#Teleport+1] = { -2976.80,2187.75,41.88,636.84,2090.69,110.28 }

	Teleport[#Teleport+1] = { 126.1,-115.75,49.77,122.66,-127.87,54.93 }
	Teleport[#Teleport+1] = { 122.66,-127.87,54.93,126.1,-115.75,49.77 }

	Teleport[#Teleport+1] = { -699.29,5766.73,31.61,-700.91,5762.76,18.08 }
	Teleport[#Teleport+1] = { -700.91,5762.76,18.08,-699.29,5766.73,31.61 }

	Teleport[#Teleport+1] = { -1196.16,-1614.1,9.33,-1196.05,-1614.02,16.04 }
	Teleport[#Teleport+1] = { -1196.05,-1614.02,16.04,-1196.16,-1614.1,9.33 }

	Teleport[#Teleport+1] = { 380.26,-15.05,83.0,417.45,-10.73,99.65 }
	Teleport[#Teleport+1] = { 417.45,-10.73,99.65,380.26,-15.05,83.0 }

	Teleport[#Teleport+1] = { 414.61,-15.23,99.65,420.15,-15.86,152.95 }
	Teleport[#Teleport+1] = { 420.15,-15.86,152.95,414.61,-15.23,99.65 }

	Teleport[#Teleport+1] = { -3448.07,92.0,12.47,475.93,-1241.7,-78.33 }
	Teleport[#Teleport+1] = { 475.93,-1241.7,-78.33,-3448.07,92.0,12.47 }

elseif cityName == "Imperium" then
	-- tower bridge
	Teleport[#Teleport+1] = { 521.61,-1052.5,41.0,538.16,-1046.94,100.69 }
	Teleport[#Teleport+1] = { 538.16,-1046.94,100.69,521.61,-1052.5,41.0 }

	Teleport[#Teleport+1] = { -313.8,6265.59,31.49,87.62,-1290.21,21.11 } -- QG_259
	Teleport[#Teleport+1] = { 87.62,-1290.21,21.11,-313.8,6265.59,31.49 }

	Teleport[#Teleport+1] = { -2614.18,1717.24,146.32,-557.84,823.61,197.95 }
	Teleport[#Teleport+1] = { -557.84,823.61,197.95,-2614.18,1717.24,146.32 }

	Teleport[#Teleport+1] = { -550.4,823.89,197.51,1431.7,4719.25,129.73 }
	Teleport[#Teleport+1] = { 1431.7,4719.25,129.73,-550.4,823.89,197.51 }

	Teleport[#Teleport+1] = { -533.53,820.11,197.51,-2050.49,3236.5,31.49 }
	Teleport[#Teleport+1] = { -2050.49,3236.5,31.49,-533.53,820.11,197.51 }

	Teleport[#Teleport+1] = { 2475.8,-384.09,94.39,-1902.07,2910.49,32.81 }
	Teleport[#Teleport+1] = { -1902.07,2910.49,32.81,2475.8,-384.09,94.39 }

	Teleport[#Teleport+1] = { 444.3,-1341.23,-78.17,553.79,765.3,206.21 }
	Teleport[#Teleport+1] = { 553.79,765.3,206.21,444.3,-1341.23,-78.17 }

	Teleport[#Teleport+1] = { 63.06,2164.62,-84.22,-293.28,6266.17,31.53 }
	Teleport[#Teleport+1] = { -293.28,6266.17,31.53,63.06,2164.62,-84.22 }

	Teleport[#Teleport+1] = { -2279.82,345.26,174.60,-2290.80,265.98,164.47 }
	Teleport[#Teleport+1] = { -2290.80,265.98,164.47,-2279.82,345.26,174.60 }

	Teleport[#Teleport+1] = { 1418.58,6758.42,11.91,1418.58,6758.42,11.91 }
	Teleport[#Teleport+1] = { 1418.58,6758.42,11.91,1418.58,6758.42,11.91 }

	Teleport[#Teleport+1] = { -1418.58,6758.42,11.91,545.78,746.15,203.17 }
	Teleport[#Teleport+1] = { 545.78,746.15,203.17,-1418.58,6758.42,11.91 }

	Teleport[#Teleport+1] = { 554.43,760.73,203.17,-1399.19,-480.3,72.03 }
	Teleport[#Teleport+1] = { -1399.19,-480.3,72.03,554.43,760.73,203.17 } 

	Teleport[#Teleport+1] = { -3787.53,263.56,22.82,-3796.02,284.81,155.54 }
	Teleport[#Teleport+1] = { -3796.02,284.81,155.54,-3787.53,263.56,22.82 }

	Teleport[#Teleport+1] = { 516.84,-1017.53,40.93,534.22,-1018.18,100.66 }
	Teleport[#Teleport+1] = { 534.22,-1018.18,100.66,516.84,-1017.53,40.93 }

	Teleport[#Teleport+1] = { 725.17,2347.42,-78.17,569.12,756.18,203.17 }
	Teleport[#Teleport+1] = { 569.12,756.18,203.17,725.17,2347.42,-78.17 }

	Teleport[#Teleport+1] = { 636.84,2090.69,110.28,-2976.80,2187.75,41.88 }
	Teleport[#Teleport+1] = { -2976.80,2187.75,41.88,636.84,2090.69,110.28 }

	Teleport[#Teleport+1] = { 126.1,-115.75,49.77,122.66,-127.87,54.93 }
	Teleport[#Teleport+1] = { 122.66,-127.87,54.93,126.1,-115.75,49.77 }

	Teleport[#Teleport+1] = { -699.29,5766.73,31.61,-700.91,5762.76,18.08 }
	Teleport[#Teleport+1] = { -700.91,5762.76,18.08,-699.29,5766.73,31.61 }

	Teleport[#Teleport+1] = { -1196.16,-1614.1,9.33,-1196.05,-1614.02,16.04 }
	Teleport[#Teleport+1] = { -1196.05,-1614.02,16.04,-1196.16,-1614.1,9.33 }

	Teleport[#Teleport+1] = { 380.26,-15.05,83.0,417.45,-10.73,99.65 }
	Teleport[#Teleport+1] = { 417.45,-10.73,99.65,380.26,-15.05,83.0 }

	Teleport[#Teleport+1] = { 414.61,-15.23,99.65,420.15,-15.86,152.95 }
	Teleport[#Teleport+1] = { 420.15,-15.86,152.95,414.61,-15.23,99.65 }

elseif cityName == "GoatRP" then
	-- tower bridge
	Teleport[#Teleport+1] = { 521.61,-1052.5,41.0,538.16,-1046.94,100.69 }
	Teleport[#Teleport+1] = { 538.16,-1046.94,100.69,521.61,-1052.5,41.0 }

	Teleport[#Teleport+1] = { -313.8,6265.59,31.49,87.62,-1290.21,21.11 } -- QG_259
	Teleport[#Teleport+1] = { 87.62,-1290.21,21.11,-313.8,6265.59,31.49 }

	Teleport[#Teleport+1] = { -2614.18,1717.24,146.32,-557.84,823.61,197.95 }
	Teleport[#Teleport+1] = { -557.84,823.61,197.95,-2614.18,1717.24,146.32 }

	Teleport[#Teleport+1] = { -550.4,823.89,197.51,1431.7,4719.25,129.73 }
	Teleport[#Teleport+1] = { 1431.7,4719.25,129.73,-550.4,823.89,197.51 }

	Teleport[#Teleport+1] = { -533.53,820.11,197.51,-2050.49,3236.5,31.49 }
	Teleport[#Teleport+1] = { -2050.49,3236.5,31.49,-533.53,820.11,197.51 }

	Teleport[#Teleport+1] = { 2475.8,-384.09,94.39,-1902.07,2910.49,32.81 }
	Teleport[#Teleport+1] = { -1902.07,2910.49,32.81,2475.8,-384.09,94.39 }

	Teleport[#Teleport+1] = { 444.3,-1341.23,-78.17,553.79,765.3,206.21 }
	Teleport[#Teleport+1] = { 553.79,765.3,206.21,444.3,-1341.23,-78.17 }

	Teleport[#Teleport+1] = { 63.06,2164.62,-84.22,-293.28,6266.17,31.53 }
	Teleport[#Teleport+1] = { -293.28,6266.17,31.53,63.06,2164.62,-84.22 }

	Teleport[#Teleport+1] = { -2279.82,345.26,174.60,-2290.80,265.98,164.47 }
	Teleport[#Teleport+1] = { -2290.80,265.98,164.47,-2279.82,345.26,174.60 }

	Teleport[#Teleport+1] = { 1418.58,6758.42,11.91,1418.58,6758.42,11.91 }
	Teleport[#Teleport+1] = { 1418.58,6758.42,11.91,1418.58,6758.42,11.91 }

	Teleport[#Teleport+1] = { -1418.58,6758.42,11.91,545.78,746.15,203.17 }
	Teleport[#Teleport+1] = { 545.78,746.15,203.17,-1418.58,6758.42,11.91 }

	Teleport[#Teleport+1] = { 554.43,760.73,203.17,-1399.19,-480.3,72.03 }
	Teleport[#Teleport+1] = { -1399.19,-480.3,72.03,554.43,760.73,203.17 } 

	Teleport[#Teleport+1] = { -3787.53,263.56,22.82,-3796.02,284.81,155.54 }
	Teleport[#Teleport+1] = { -3796.02,284.81,155.54,-3787.53,263.56,22.82 }

	Teleport[#Teleport+1] = { 516.84,-1017.53,40.93,534.22,-1018.18,100.66 }
	Teleport[#Teleport+1] = { 534.22,-1018.18,100.66,516.84,-1017.53,40.93 }

	Teleport[#Teleport+1] = { 725.17,2347.42,-78.17,569.12,756.18,203.17 }
	Teleport[#Teleport+1] = { 569.12,756.18,203.17,725.17,2347.42,-78.17 }

	Teleport[#Teleport+1] = { 636.84,2090.69,110.28,-2976.80,2187.75,41.88 }
	Teleport[#Teleport+1] = { -2976.80,2187.75,41.88,636.84,2090.69,110.28 }

	Teleport[#Teleport+1] = { 126.1,-115.75,49.77,122.66,-127.87,54.93 }
	Teleport[#Teleport+1] = { 122.66,-127.87,54.93,126.1,-115.75,49.77 }

	Teleport[#Teleport+1] = { -699.29,5766.73,31.61,-700.91,5762.76,18.08 }
	Teleport[#Teleport+1] = { -700.91,5762.76,18.08,-699.29,5766.73,31.61 }

	Teleport[#Teleport+1] = { -1196.16,-1614.1,9.33,-1196.05,-1614.02,16.04 }
	Teleport[#Teleport+1] = { -1196.05,-1614.02,16.04,-1196.16,-1614.1,9.33 }

	Teleport[#Teleport+1] = { 380.26,-15.05,83.0,417.45,-10.73,99.65 }
	Teleport[#Teleport+1] = { 417.45,-10.73,99.65,380.26,-15.05,83.0 }

	Teleport[#Teleport+1] = { 414.61,-15.23,99.65,420.15,-15.86,152.95 }
	Teleport[#Teleport+1] = { 420.15,-15.86,152.95,414.61,-15.23,99.65 }

elseif cityName == "District99" then

	Teleport[#Teleport+1] = { -71.05,-801.01,44.23,-75.0,-824.54,321.29 }
	Teleport[#Teleport+1] = { -75.0,-824.54,321.29,-71.05,-801.01,44.23 }

	Teleport[#Teleport+1] = { -1063.71,-2097.56,21.29, -3523.97,4644.93,10.33 }
	Teleport[#Teleport+1] = { -3523.97,4644.93,10.33, -1063.71,-2097.56,21.29 }

	Teleport[#Teleport+1] = { 43.64,3704.1,39.75,-990.6,1018.96,221.36 }
	Teleport[#Teleport+1] = { -990.6,1018.96,221.36,43.64,3704.1,39.75 }

	-- tower bridge
	Teleport[#Teleport+1] = { 521.61,-1052.5,41.0,538.16,-1046.94,100.69 }
	Teleport[#Teleport+1] = { 538.16,-1046.94,100.69,521.61,-1052.5,41.0 }

	Teleport[#Teleport+1] = { -2976.8,2187.75,41.87,636.84,2090.68,110.27 }
	Teleport[#Teleport+1] = { 636.84,2090.68,110.27,-2976.8,2187.75,41.87 }

	Teleport[#Teleport+1] = { -136.21,1286.29,306.51,359.04,2324.26,75.05 }
	Teleport[#Teleport+1] = { 359.04,2324.26,75.05,-136.21,1286.29,306.51 }

	Teleport[#Teleport+1] = { 96.08,-399.3,41.52, 134.99,-1330.54,29.27 }
	Teleport[#Teleport+1] = { 134.99,-1330.54,29.27,96.08,-399.3,41.52 }

	Teleport[#Teleport+1] = { 94.78,-426.61,40.51,66.2, 1919.06,-83.51 }
	Teleport[#Teleport+1] = { 66.2, 1919.06,-83.51,94.78,-426.61,40.51 }

	Teleport[#Teleport+1] = { 229.28,742.33,200.10,294.21,-1350.93,-54.97 }
	Teleport[#Teleport+1] = { 294.21,-1350.93,-54.97,229.28,742.33,200.10 }

	Teleport[#Teleport+1] = { 748.68,-529.03,27.78,755.11,-544.97,28.65 }
	Teleport[#Teleport+1] = { 755.11,-544.97,28.65,748.68,-529.03,27.78 }

	Teleport[#Teleport+1] = { -3302.94,532.23,14.41,-177.19,-1012.91,21.28 }
	Teleport[#Teleport+1] = { -177.19,-1012.91,21.28,-3302.94,532.23,14.41 }

	Teleport[#Teleport+1] = { 2475.8,-384.09,94.39,-1902.07,2910.49,32.81 }
	Teleport[#Teleport+1] = { -1902.07,2910.49,32.81,2475.8,-384.09,94.39 }

	Teleport[#Teleport+1] = { 444.23,-1341.67,-78.16,542.12,896.65,250.95 }
	Teleport[#Teleport+1] = { 542.12,896.65,250.95,444.23,-1341.67,-78.16 }

	Teleport[#Teleport+1] = { 63.06,2164.62,-84.22,-293.28,6266.17,31.53 }
	Teleport[#Teleport+1] = { -293.28,6266.17,31.53,63.06,2164.62,-84.22 }

	Teleport[#Teleport+1] = { -2279.82,345.26,174.60,-2290.80,265.98,164.47 }
	Teleport[#Teleport+1] = { -2290.80,265.98,164.47,-2279.82,345.26,174.60 }

	Teleport[#Teleport+1] = { 1418.58,6758.42,11.91,1418.58,6758.42,11.91 }
	Teleport[#Teleport+1] = { 1418.58,6758.42,11.91,1418.58,6758.42,11.91 }

	Teleport[#Teleport+1] = { -1418.58,6758.42,11.91,545.78,746.15,203.17 }
	Teleport[#Teleport+1] = { 545.78,746.15,203.17,-1418.58,6758.42,11.91 }

	Teleport[#Teleport+1] = { 554.43,760.73,203.17,-1399.19,-480.3,72.03 }
	Teleport[#Teleport+1] = { -1399.19,-480.3,72.03,554.43,760.73,203.17 } 

	Teleport[#Teleport+1] = { -3787.53,263.56,22.82,-3796.02,284.81,155.54 }
	Teleport[#Teleport+1] = { -3796.02,284.81,155.54,-3787.53,263.56,22.82 }

	Teleport[#Teleport+1] = { 516.84,-1017.53,40.93,534.22,-1018.18,100.66 }
	Teleport[#Teleport+1] = { 534.22,-1018.18,100.66,516.84,-1017.53,40.93 }

	Teleport[#Teleport+1] = { 725.17,2347.42,-78.17,569.12,756.18,203.17 }
	Teleport[#Teleport+1] = { 569.12,756.18,203.17,725.17,2347.42,-78.17 }

	Teleport[#Teleport+1] = { 636.84,2090.69,110.28,-2976.80,2187.75,41.88 }
	Teleport[#Teleport+1] = { -2976.80,2187.75,41.88,636.84,2090.69,110.28 }

	Teleport[#Teleport+1] = { 126.1,-115.75,49.77,122.66,-127.87,54.93 }
	Teleport[#Teleport+1] = { 122.66,-127.87,54.93,126.1,-115.75,49.77 }

	Teleport[#Teleport+1] = { -699.29,5766.73,31.61,-700.91,5762.76,18.08 }
	Teleport[#Teleport+1] = { -700.91,5762.76,18.08,-699.29,5766.73,31.61 }

	Teleport[#Teleport+1] = { -1196.16,-1614.1,9.33,-1196.05,-1614.02,16.04 }
	Teleport[#Teleport+1] = { -1196.05,-1614.02,16.04,-1196.16,-1614.1,9.33 }

	Teleport[#Teleport+1] = { 380.26,-15.05,83.0,417.45,-10.73,99.65 }
	Teleport[#Teleport+1] = { 417.45,-10.73,99.65,380.26,-15.05,83.0 }

	Teleport[#Teleport+1] = { 414.61,-15.23,99.65,420.15,-15.86,152.95 }
	Teleport[#Teleport+1] = { 420.15,-15.86,152.95,414.61,-15.23,99.65 }

	Teleport[#Teleport+1] = { 928.19,-673.69,58.10,-587.29,5024.21,159.99 }
	Teleport[#Teleport+1] = { -587.29,5024.21,159.99,928.19,-673.69,58.10 }

	Teleport[#Teleport+1] = { 4648.55,-4831.68,25.95,4974.65,-5718.94,19.89 }
	Teleport[#Teleport+1] = { 4974.65,-5718.94,19.89,4648.55,-4831.68,25.95 }

elseif cityName == "Krown" then
	-- tower bridge
	Teleport[#Teleport+1] = { 521.61,-1052.5,41.0,538.16,-1046.94,100.69 }
	Teleport[#Teleport+1] = { 538.16,-1046.94,100.69,521.61,-1052.5,41.0 }

	Teleport[#Teleport+1] = { -71.05,-801.01,44.23,-75.0,-824.54,321.29 }
	Teleport[#Teleport+1] = { -75.0,-824.54,321.29,-71.05,-801.01,44.23 }

	Teleport[#Teleport+1] = { 96.08,-399.3,41.52, 134.99,-1330.54,29.27 }
	Teleport[#Teleport+1] = { 134.99,-1330.54,29.27,96.08,-399.3,41.52 }

	Teleport[#Teleport+1] = { 94.78,-426.61,40.51,66.2, 1919.06,-83.51 }
	Teleport[#Teleport+1] = { 66.2, 1919.06,-83.51,94.78,-426.61,40.51 }

	Teleport[#Teleport+1] = { 229.28,742.33,200.10,294.21,-1350.93,-54.97 }
	Teleport[#Teleport+1] = { 294.21,-1350.93,-54.97,229.28,742.33,200.10 }

	Teleport[#Teleport+1] = { 748.68,-529.03,27.78,755.11,-544.97,28.65 }
	Teleport[#Teleport+1] = { 755.11,-544.97,28.65,748.68,-529.03,27.78 }

	Teleport[#Teleport+1] = { -3302.94,532.23,14.41,-177.19,-1012.91,21.28 }
	Teleport[#Teleport+1] = { -177.19,-1012.91,21.28,-3302.94,532.23,14.41 }

	Teleport[#Teleport+1] = { 2475.8,-384.09,94.39,-1902.07,2910.49,32.81 }
	Teleport[#Teleport+1] = { -1902.07,2910.49,32.81,2475.8,-384.09,94.39 }

	Teleport[#Teleport+1] = { 444.23,-1341.67,-78.16,542.12,896.65,250.95 }
	Teleport[#Teleport+1] = { 542.12,896.65,250.95,444.23,-1341.67,-78.16 }

	Teleport[#Teleport+1] = { 63.06,2164.62,-84.22,-293.28,6266.17,31.53 }
	Teleport[#Teleport+1] = { -293.28,6266.17,31.53,63.06,2164.62,-84.22 }

	Teleport[#Teleport+1] = { -2279.82,345.26,174.60,-2290.80,265.98,164.47 }
	Teleport[#Teleport+1] = { -2290.80,265.98,164.47,-2279.82,345.26,174.60 }

	Teleport[#Teleport+1] = { 1418.58,6758.42,11.91,1418.58,6758.42,11.91 }
	Teleport[#Teleport+1] = { 1418.58,6758.42,11.91,1418.58,6758.42,11.91 }

	Teleport[#Teleport+1] = { -1418.58,6758.42,11.91,545.78,746.15,203.17 }
	Teleport[#Teleport+1] = { 545.78,746.15,203.17,-1418.58,6758.42,11.91 }

	Teleport[#Teleport+1] = { 554.43,760.73,203.17,-1399.19,-480.3,72.03 }
	Teleport[#Teleport+1] = { -1399.19,-480.3,72.03,554.43,760.73,203.17 } 

	Teleport[#Teleport+1] = { -3787.53,263.56,22.82,-3796.02,284.81,155.54 }
	Teleport[#Teleport+1] = { -3796.02,284.81,155.54,-3787.53,263.56,22.82 }

	Teleport[#Teleport+1] = { 516.84,-1017.53,40.93,534.22,-1018.18,100.66 }
	Teleport[#Teleport+1] = { 534.22,-1018.18,100.66,516.84,-1017.53,40.93 }

	Teleport[#Teleport+1] = { 725.17,2347.42,-78.17,569.12,756.18,203.17 }
	Teleport[#Teleport+1] = { 569.12,756.18,203.17,725.17,2347.42,-78.17 }

	Teleport[#Teleport+1] = { 636.84,2090.69,110.28,-2976.80,2187.75,41.88 }
	Teleport[#Teleport+1] = { -2976.80,2187.75,41.88,636.84,2090.69,110.28 }

	Teleport[#Teleport+1] = { 126.1,-115.75,49.77,122.66,-127.87,54.93 }
	Teleport[#Teleport+1] = { 122.66,-127.87,54.93,126.1,-115.75,49.77 }

	Teleport[#Teleport+1] = { -699.29,5766.73,31.61,-700.91,5762.76,18.08 }
	Teleport[#Teleport+1] = { -700.91,5762.76,18.08,-699.29,5766.73,31.61 }

	Teleport[#Teleport+1] = { -1196.16,-1614.1,9.33,-1196.05,-1614.02,16.04 }
	Teleport[#Teleport+1] = { -1196.05,-1614.02,16.04,-1196.16,-1614.1,9.33 }

	Teleport[#Teleport+1] = { 380.26,-15.05,83.0,417.45,-10.73,99.65 }
	Teleport[#Teleport+1] = { 417.45,-10.73,99.65,380.26,-15.05,83.0 }

	Teleport[#Teleport+1] = { 414.61,-15.23,99.65,420.15,-15.86,152.95 }
	Teleport[#Teleport+1] = { 420.15,-15.86,152.95,414.61,-15.23,99.65 }

elseif cityName == "Orizon" then
	-- tower bridge
	Teleport[#Teleport+1] = { 521.61,-1052.5,41.0,538.16,-1046.94,100.69 }
	Teleport[#Teleport+1] = { 538.16,-1046.94,100.69,521.61,-1052.5,41.0 }

	Teleport[#Teleport+1] = { -71.05,-801.01,44.23,-75.0,-824.54,321.29 }
	Teleport[#Teleport+1] = { -75.0,-824.54,321.29,-71.05,-801.01,44.23 }

	Teleport[#Teleport+1] = { 224.35,745.93,200.09,287.79,-1339.99,-55.15 }
	Teleport[#Teleport+1] = { 287.79,-1339.99,-55.15,224.35,745.93,200.09 }

	Teleport[#Teleport+1] = { 748.68,-529.03,27.78,755.11,-544.97,28.65 }
	Teleport[#Teleport+1] = { 755.11,-544.97,28.65,748.68,-529.03,27.78 }

	Teleport[#Teleport+1] = { -3302.94,532.23,14.41,-177.19,-1012.91,21.28 }
	Teleport[#Teleport+1] = { -177.19,-1012.91,21.28,-3302.94,532.23,14.41 }

	Teleport[#Teleport+1] = { 2475.8,-384.09,94.39,-1902.07,2910.49,32.81 }
	Teleport[#Teleport+1] = { -1902.07,2910.49,32.81,2475.8,-384.09,94.39 }

	Teleport[#Teleport+1] = { 444.23,-1341.67,-78.16,542.12,896.65,250.95 }
	Teleport[#Teleport+1] = { 542.12,896.65,250.95,444.23,-1341.67,-78.16 }

	Teleport[#Teleport+1] = { 63.06,2164.62,-84.22,-293.28,6266.17,31.53 }
	Teleport[#Teleport+1] = { -293.28,6266.17,31.53,63.06,2164.62,-84.22 }

	Teleport[#Teleport+1] = { -2279.82,345.26,174.60,-2290.80,265.98,164.47 }
	Teleport[#Teleport+1] = { -2290.80,265.98,164.47,-2279.82,345.26,174.60 }

	Teleport[#Teleport+1] = { 1418.58,6758.42,11.91,1418.58,6758.42,11.91 }
	Teleport[#Teleport+1] = { 1418.58,6758.42,11.91,1418.58,6758.42,11.91 }

	Teleport[#Teleport+1] = { -1418.58,6758.42,11.91,545.78,746.15,203.17 }
	Teleport[#Teleport+1] = { 545.78,746.15,203.17,-1418.58,6758.42,11.91 }

	Teleport[#Teleport+1] = { 554.43,760.73,203.17,-1399.19,-480.3,72.03 }
	Teleport[#Teleport+1] = { -1399.19,-480.3,72.03,554.43,760.73,203.17 } 

	Teleport[#Teleport+1] = { -3787.53,263.56,22.82,-3796.02,284.81,155.54 }
	Teleport[#Teleport+1] = { -3796.02,284.81,155.54,-3787.53,263.56,22.82 }

	Teleport[#Teleport+1] = { 516.84,-1017.53,40.93,534.22,-1018.18,100.66 }
	Teleport[#Teleport+1] = { 534.22,-1018.18,100.66,516.84,-1017.53,40.93 }

	Teleport[#Teleport+1] = { 725.17,2347.42,-78.17,569.12,756.18,203.17 }
	Teleport[#Teleport+1] = { 569.12,756.18,203.17,725.17,2347.42,-78.17 }

	Teleport[#Teleport+1] = { 636.84,2090.69,110.28,-2976.80,2187.75,41.88 }
	Teleport[#Teleport+1] = { -2976.80,2187.75,41.88,636.84,2090.69,110.28 }

	Teleport[#Teleport+1] = { 126.1,-115.75,49.77,122.66,-127.87,54.93 }
	Teleport[#Teleport+1] = { 122.66,-127.87,54.93,126.1,-115.75,49.77 }

	Teleport[#Teleport+1] = { -699.29,5766.73,31.61,-700.91,5762.76,18.08 }
	Teleport[#Teleport+1] = { -700.91,5762.76,18.08,-699.29,5766.73,31.61 }

	Teleport[#Teleport+1] = { -1196.16,-1614.1,9.33,-1196.05,-1614.02,16.04 }
	Teleport[#Teleport+1] = { -1196.05,-1614.02,16.04,-1196.16,-1614.1,9.33 }

	Teleport[#Teleport+1] = { 380.26,-15.05,83.0,417.45,-10.73,99.65 }
	Teleport[#Teleport+1] = { 417.45,-10.73,99.65,380.26,-15.05,83.0 }

	Teleport[#Teleport+1] = { 414.61,-15.23,99.65,420.15,-15.86,152.95 }
	Teleport[#Teleport+1] = { 420.15,-15.86,152.95,414.61,-15.23,99.65 }

	Teleport[#Teleport+1] = { -3011.45,-1364.69,6.55,-2978.82,-1389.77,64.85 } -- QG_479
	Teleport[#Teleport+1] = { -2978.82,-1389.77,64.85,-3011.45,-1364.69,6.55 }

elseif cityName == "Liberty99" then
	-- tower bridge
	Teleport[#Teleport+1] = { 521.61,-1052.5,41.0,538.16,-1046.94,100.69 }
	Teleport[#Teleport+1] = { 538.16,-1046.94,100.69,521.61,-1052.5,41.0 }

	Teleport[#Teleport+1] = { 945.20,47.51,80.29,69.11,1854.99,116.26 }
	Teleport[#Teleport+1] = { 69.11,1854.99,116.26,945.20,47.51,80.29 }

	Teleport[#Teleport+1] = { -71.05,-801.01,44.23,-75.0,-824.54,321.29 }
	Teleport[#Teleport+1] = { -75.0,-824.54,321.29,-71.05,-801.01,44.23 }

	Teleport[#Teleport+1] = { -1526.38,823.92,185.00,-3357.09,1494.93,12.82 }
	Teleport[#Teleport+1] = { -3357.09,1494.93,12.82,-1526.38,823.92,185.00 }

	Teleport[#Teleport+1] = { -313.75,6265.19,31.50,97.25,-1303.13,29.32 }
	Teleport[#Teleport+1] = { 97.25,-1303.13,29.32,-313.75,6265.19,31.50 }

	Teleport[#Teleport+1] = { 748.68,-529.03,27.78,755.11,-544.97,28.65 }
	Teleport[#Teleport+1] = { 755.11,-544.97,28.65,748.68,-529.03,27.78 }

	Teleport[#Teleport+1] = { -3277.58,545.61,12.87,-1070.63,760.03,168.04 }
	Teleport[#Teleport+1] = { -1070.63,760.03,168.04,-3277.58,545.61,12.87 }

	Teleport[#Teleport+1] = { 2475.8,-384.09,94.39,-1902.07,2910.49,32.81 }
	Teleport[#Teleport+1] = { -1902.07,2910.49,32.81,2475.8,-384.09,94.39 }

	Teleport[#Teleport+1] = { 444.23,-1341.67,-78.16,542.12,896.65,250.95 }
	Teleport[#Teleport+1] = { 542.12,896.65,250.95,444.23,-1341.67,-78.16 }

	Teleport[#Teleport+1] = { 63.06,2164.62,-84.22,-293.28,6266.17,31.53 }
	Teleport[#Teleport+1] = { -293.28,6266.17,31.53,63.06,2164.62,-84.22 }

	Teleport[#Teleport+1] = { -2279.82,345.26,174.60,-2290.80,265.98,164.47 }
	Teleport[#Teleport+1] = { -2290.80,265.98,164.47,-2279.82,345.26,174.60 }

	Teleport[#Teleport+1] = { 1418.58,6758.42,11.91,1418.58,6758.42,11.91 }
	Teleport[#Teleport+1] = { 1418.58,6758.42,11.91,1418.58,6758.42,11.91 }

	Teleport[#Teleport+1] = { -1418.58,6758.42,11.91,545.78,746.15,203.17 }
	Teleport[#Teleport+1] = { 545.78,746.15,203.17,-1418.58,6758.42,11.91 }

	Teleport[#Teleport+1] = { 554.43,760.73,203.17,-1399.19,-480.3,72.03 }
	Teleport[#Teleport+1] = { -1399.19,-480.3,72.03,554.43,760.73,203.17 } 

	Teleport[#Teleport+1] = { -3787.53,263.56,22.82,-3796.02,284.81,155.54 }
	Teleport[#Teleport+1] = { -3796.02,284.81,155.54,-3787.53,263.56,22.82 }

	Teleport[#Teleport+1] = { 516.84,-1017.53,40.93,534.22,-1018.18,100.66 }
	Teleport[#Teleport+1] = { 534.22,-1018.18,100.66,516.84,-1017.53,40.93 }

	Teleport[#Teleport+1] = { 725.17,2347.42,-78.17,569.12,756.18,203.17 }
	Teleport[#Teleport+1] = { 569.12,756.18,203.17,725.17,2347.42,-78.17 }

	Teleport[#Teleport+1] = { 636.84,2090.69,110.28,-2976.80,2187.75,41.88 }
	Teleport[#Teleport+1] = { -2976.80,2187.75,41.88,636.84,2090.69,110.28 }

	Teleport[#Teleport+1] = { 126.1,-115.75,49.77,122.66,-127.87,54.93 }
	Teleport[#Teleport+1] = { 122.66,-127.87,54.93,126.1,-115.75,49.77 }

	Teleport[#Teleport+1] = { -699.29,5766.73,31.61,-700.91,5762.76,18.08 }
	Teleport[#Teleport+1] = { -700.91,5762.76,18.08,-699.29,5766.73,31.61 }

	Teleport[#Teleport+1] = { -1196.16,-1614.1,9.33,-1196.05,-1614.02,16.04 }
	Teleport[#Teleport+1] = { -1196.05,-1614.02,16.04,-1196.16,-1614.1,9.33 }

	Teleport[#Teleport+1] = { 380.26,-15.05,83.0,417.45,-10.73,99.65 }
	Teleport[#Teleport+1] = { 417.45,-10.73,99.65,380.26,-15.05,83.0 }

	Teleport[#Teleport+1] = { 414.61,-15.23,99.65,420.15,-15.86,152.95 }
	Teleport[#Teleport+1] = { 420.15,-15.86,152.95,414.61,-15.23,99.65 }

	Teleport[#Teleport+1] = { -548.50,-185.63,40.20,-1827.75,2541.75,45.89 }
	Teleport[#Teleport+1] = { -1827.75,2541.75,45.89,-548.50,-185.63,40.20 }

elseif cityName == "Royal" then
	-- tower bridge
	Teleport[#Teleport+1] = { 521.61,-1052.5,41.0,538.16,-1046.94,100.69 }
	Teleport[#Teleport+1] = { 538.16,-1046.94,100.69,521.61,-1052.5,41.0 }

	Teleport[#Teleport+1] = { -293.68,6266.3,31.53,444.18,-1341.25,-78.17 }
	Teleport[#Teleport+1] = { 444.18,-1341.25,-78.17,-293.68,6266.3,31.53 }

	Teleport[#Teleport+1] = { 2475.8,-384.09,94.39,-1902.07,2910.49,32.81 }
	Teleport[#Teleport+1] = { -1902.07,2910.49,32.81,2475.8,-384.09,94.39 }

	Teleport[#Teleport+1] = { 1418.58,6758.42,11.91,1418.58,6758.42,11.91 }
	Teleport[#Teleport+1] = { 1418.58,6758.42,11.91,1418.58,6758.42,11.91 }

	Teleport[#Teleport+1] = { -1418.58,6758.42,11.91,545.78,746.15,203.17 }
	Teleport[#Teleport+1] = { 545.78,746.15,203.17,-1418.58,6758.42,11.91 }

	Teleport[#Teleport+1] = { 554.43,760.73,203.17,-1399.19,-480.3,72.03 }
	Teleport[#Teleport+1] = { -1399.19,-480.3,72.03,554.43,760.73,203.17 } 

	Teleport[#Teleport+1] = { -3787.53,263.56,22.82,-3796.02,284.81,155.54 }
	Teleport[#Teleport+1] = { -3796.02,284.81,155.54,-3787.53,263.56,22.82 }

	Teleport[#Teleport+1] = { 516.84,-1017.53,40.93,534.22,-1018.18,100.66 }
	Teleport[#Teleport+1] = { 534.22,-1018.18,100.66,516.84,-1017.53,40.93 }

	Teleport[#Teleport+1] = { 725.17,2347.42,-78.17,569.12,756.18,203.17 }
	Teleport[#Teleport+1] = { 569.12,756.18,203.17,725.17,2347.42,-78.17 }

	Teleport[#Teleport+1] = { 126.1,-115.75,49.77,122.66,-127.87,54.93 }
	Teleport[#Teleport+1] = { 122.66,-127.87,54.93,126.1,-115.75,49.77 }

	Teleport[#Teleport+1] = { -699.29,5766.73,31.61,-700.91,5762.76,18.08 }
	Teleport[#Teleport+1] = { -700.91,5762.76,18.08,-699.29,5766.73,31.61 }

	Teleport[#Teleport+1] = { -1196.16,-1614.1,9.33,-1196.05,-1614.02,16.04 }
	Teleport[#Teleport+1] = { -1196.05,-1614.02,16.04,-1196.16,-1614.1,9.33 }

	Teleport[#Teleport+1] = { 380.26,-15.05,83.0,417.45,-10.73,99.65 }
	Teleport[#Teleport+1] = { 417.45,-10.73,99.65,380.26,-15.05,83.0 }

	Teleport[#Teleport+1] = { 414.61,-15.23,99.65,420.15,-15.86,152.95 }
	Teleport[#Teleport+1] = { 420.15,-15.86,152.95,414.61,-15.23,99.65 }

	Teleport[#Teleport+1] = { 237.88,-914.94,33.73,-3525.88,4642.08,10.57 }
	Teleport[#Teleport+1] = { -3525.88,4642.08,10.57,237.88,-914.94,33.73 }

elseif cityName == "Real" then
	-- tower bridge
	Teleport[#Teleport+1] = { 521.61,-1052.5,41.0,538.16,-1046.94,100.69 }
	Teleport[#Teleport+1] = { 538.16,-1046.94,100.69,521.61,-1052.5,41.0 }

	Teleport[#Teleport+1] = { -2980.83,-371.57,19.68,-3333.2,559.05,17.14 }
	Teleport[#Teleport+1] = { -3333.2,559.05,17.14,-2980.83,-371.57,19.68 }

	Teleport[#Teleport+1] = { -71.05,-801.01,44.23,-75.0,-824.54,321.29 }
	Teleport[#Teleport+1] = { -75.0,-824.54,321.29,-71.05,-801.01,44.23 }

	Teleport[#Teleport+1] = { 2475.8,-384.09,94.39,-1902.07,2910.49,32.81 }
	Teleport[#Teleport+1] = { -1902.07,2910.49,32.81,2475.8,-384.09,94.39 }

	Teleport[#Teleport+1] = { 516.84,-1017.53,40.93,534.22,-1018.18,100.66 }
	Teleport[#Teleport+1] = { 534.22,-1018.18,100.66,516.84,-1017.53,40.93 }

	Teleport[#Teleport+1] = { 126.1,-115.75,49.77,122.66,-127.87,54.93 }
	Teleport[#Teleport+1] = { 122.66,-127.87,54.93,126.1,-115.75,49.77 }

	Teleport[#Teleport+1] = { -321.19,209.76,87.92,639.43,698.01,-139.19 }
	Teleport[#Teleport+1] = { 639.43,698.01,-139.19,-321.19,209.76,87.92 }

	Teleport[#Teleport+1] = { -699.29,5766.73,31.61,-700.91,5762.76,18.08 }
	Teleport[#Teleport+1] = { -700.91,5762.76,18.08,-699.29,5766.73,31.61 }

	Teleport[#Teleport+1] = { -1196.16,-1614.1,9.33,-1196.05,-1614.02,16.04 }
	Teleport[#Teleport+1] = { -1196.05,-1614.02,16.04,-1196.16,-1614.1,9.33 }

	Teleport[#Teleport+1] = { 380.26,-15.05,83.0,417.45,-10.73,99.65 }
	Teleport[#Teleport+1] = { 417.45,-10.73,99.65,380.26,-15.05,83.0 }

	Teleport[#Teleport+1] = { 414.61,-15.23,99.65,420.15,-15.86,152.95 }
	Teleport[#Teleport+1] = { 420.15,-15.86,152.95,414.61,-15.23,99.65 }

	Teleport[#Teleport+1] = { 135.68,-1278.91,29.37,-3757.05,4640.04,5.64 }
	Teleport[#Teleport+1] = { -3757.05,4640.04,5.64,135.68,-1278.91,29.37 }

elseif cityName == "Prime" then
	-- tower bridge
	Teleport[#Teleport+1] = { 521.61,-1052.5,41.0,538.16,-1046.94,100.69 }
	Teleport[#Teleport+1] = { 538.16,-1046.94,100.69,521.61,-1052.5,41.0 }

	Teleport[#Teleport+1] = { -71.05,-801.01,44.23,-75.0,-824.54,321.29 }
	Teleport[#Teleport+1] = { -75.0,-824.54,321.29,-71.05,-801.01,44.23 }

	Teleport[#Teleport+1] = { 2007.33,3386.61,51.60,-1479.68,435.73,112.54 }
	Teleport[#Teleport+1] = { -1479.68,435.73,112.54,2007.33,3386.61,51.60 }

	Teleport[#Teleport+1] = { 2475.8,-384.09,94.39,-1902.07,2910.49,32.81 }
	Teleport[#Teleport+1] = { -1902.07,2910.49,32.81,2475.8,-384.09,94.39 }

	Teleport[#Teleport+1] = { 516.84,-1017.53,40.93,534.22,-1018.18,100.66 }
	Teleport[#Teleport+1] = { 534.22,-1018.18,100.66,516.84,-1017.53,40.93 }

	Teleport[#Teleport+1] = { 126.1,-115.75,49.77,122.66,-127.87,54.93 }
	Teleport[#Teleport+1] = { 122.66,-127.87,54.93,126.1,-115.75,49.77 }

	Teleport[#Teleport+1] = { -321.19,209.76,87.92,639.43,698.01,-139.19 }
	Teleport[#Teleport+1] = { 639.43,698.01,-139.19,-321.19,209.76,87.92 }

	Teleport[#Teleport+1] = { -699.29,5766.73,31.61,-700.91,5762.76,18.08 }
	Teleport[#Teleport+1] = { -700.91,5762.76,18.08,-699.29,5766.73,31.61 }

	Teleport[#Teleport+1] = { -1196.16,-1614.1,9.33,-1196.05,-1614.02,16.04 }
	Teleport[#Teleport+1] = { -1196.05,-1614.02,16.04,-1196.16,-1614.1,9.33 }

	Teleport[#Teleport+1] = { 380.26,-15.05,83.0,417.45,-10.73,99.65 }
	Teleport[#Teleport+1] = { 417.45,-10.73,99.65,380.26,-15.05,83.0 }

	Teleport[#Teleport+1] = { 414.61,-15.23,99.65,420.15,-15.86,152.95 }
	Teleport[#Teleport+1] = { 420.15,-15.86,152.95,414.61,-15.23,99.65 }

elseif cityName == "Galaxy" then
	Teleport[#Teleport+1] = { 936.84,14.13,112.56,-75.99,1009.8,239.47 }
	Teleport[#Teleport+1] = { -75.99,1009.8,239.47,936.84,14.13,112.56 }

	Teleport[#Teleport+1] = { -1394.58,-630.44,30.31,-1392.77,-640.49,28.68 }
	Teleport[#Teleport+1] = { -1392.77,-640.49,28.68,-1394.58,-630.44,30.31 }

	Teleport[#Teleport+1] = { -468.76,1553.53,393.24,-456.46,1539.54,407.24 }
	Teleport[#Teleport+1] = { -456.46,1539.54,407.24,-468.76,1553.53,393.24 }

	Teleport[#Teleport+1] = { 168.18,-936.25,30.01,-6034.97,-2295.36,932.42 }
	Teleport[#Teleport+1] = { -6034.97,-2295.36,932.42,168.18,-936.25,30.01 }

elseif cityName == "Universo" then

	Teleport[#Teleport+1] = { -2183.98,-240.71,37.19,-1965.38,-246.21,84.96 }
	Teleport[#Teleport+1] = { -1965.38,-246.21,84.96,-2183.98,-240.71,37.19 }

	Teleport[#Teleport+1] = { 2475.8,-384.09,94.39,-1902.07,2910.49,32.81 }
	Teleport[#Teleport+1] = { -1902.07,2910.49,32.81,2475.8,-384.09,94.39 }

	Teleport[#Teleport+1] = { -2208.90,3316.47,34.72,-743.36,-1241.93,5.70 } -- Exercito
	Teleport[#Teleport+1] = { -743.36,-1241.93,5.70,-2208.90,3316.47,34.72 }

	Teleport[#Teleport+1] = { -534.57,-190.46,38.22,1833.78,2580.95,46.01 }
	Teleport[#Teleport+1] = { 1833.78,2580.95,46.01,-534.57,-190.46,38.22 }

	Teleport[#Teleport+1] = { 2529.84,-423.32,94.12,-696.58,-1320.55,5.10 }
	Teleport[#Teleport+1] = { -696.58,-1320.55,5.10,2529.84,-423.32,94.12 }

	Teleport[#Teleport+1] = { -256.03,6335.21,32.43,-252.46,6338.32,37.61 }
	Teleport[#Teleport+1] = { -252.46,6338.32,37.61,-256.03,6335.21,32.43 }

	Teleport[#Teleport+1] = { -621.03,-108.67,38.15,-370.58,6101.87,31.62 }
	Teleport[#Teleport+1] = { -370.58,6101.87,31.62,-621.03,-108.67,38.15 }

	Teleport[#Teleport+1] = { -224.07,-1334.16,30.89,-184.27,961.03,237.53 }
	Teleport[#Teleport+1] = { -184.27,961.03,237.53,-224.07,-1334.16,30.89 }

	Teleport[#Teleport+1] = { 2238.37,3936.42,35.90,551.19,-154.23,57.04 }
	Teleport[#Teleport+1] = { 551.19,-154.23,57.04,2238.37,3936.42,35.90 }

	Teleport[#Teleport+1] = { -1581.21,374.54,98.66,2585.93,6147.9,162.92 }
	Teleport[#Teleport+1] = { 2585.93,6147.9,162.92,-1581.21,374.54,98.66 }

	Teleport[#Teleport+1] = { 2566.86,6181.36,163.12,-1399.64,-480.4,72.03 }
	Teleport[#Teleport+1] = { -1399.64,-480.4,72.03,2566.86,6181.36,163.12 }

	Teleport[#Teleport+1] = { -3194.53,833.42,8.93,-1576.72,-567.07,108.51 }
	Teleport[#Teleport+1] = { -1576.72,-567.07,108.51,-3194.53,833.42,8.93 }

	Teleport[#Teleport+1] = { -770.54,309.17,85.7,-768.8,336.73,243.38 }
	Teleport[#Teleport+1] = { -768.8,336.73,243.38,-770.54,309.17,85.7 }

	Teleport[#Teleport+1] = { 1148.75,-1556.47,35.38,-263.59,6320.15,32.42 }
	Teleport[#Teleport+1] = { -263.59,6320.15,32.42,1148.75,-1556.47,35.38 }

	Teleport[#Teleport+1] = { -325.66,-143.3,60.47,-334.02,-90.87,47.04 }
	Teleport[#Teleport+1] = { -334.02,-90.87,47.04,-325.66,-143.3,60.47 }

	Teleport[#Teleport+1] = { -783.04,5.15,41.5,-5839.05,1150.01,5.81 }
	Teleport[#Teleport+1] = { -5839.05,1150.01,5.81,-783.04,5.15,41.5 }

	Teleport[#Teleport+1] = { -262.0,6318.84,32.42,1150.17,-1556.91,35.38 }
	Teleport[#Teleport+1] = { 1150.17,-1556.91,35.38,-262.0,6318.84,32.42 }

	Teleport[#Teleport+1] = { -468.76,1553.53,393.24,-456.46,1539.54,407.24 }
	Teleport[#Teleport+1] = { -456.46,1539.54,407.24,-468.76,1553.53,393.24 }

	Teleport[#Teleport+1] = { -5840.04,1145.07,5.81,-1231.46,788.0,192.9 }
	Teleport[#Teleport+1] = { -1231.46,788.0,192.9,-5840.04,1145.07,5.81 }
	-- tp civil paleto
	Teleport[#Teleport+1] = { -970.28,-2062.56,9.4,-438.23,5981.97,31.49 }
	Teleport[#Teleport+1] = { -438.23,5981.97,31.49,-970.28,-2062.56,9.4 }

	Teleport[#Teleport+1] = { 1390.86,-811.54,84.01,800.58,3416.92,57.88 }
	Teleport[#Teleport+1] = { 800.58,3416.92,57.88,1390.86,-811.54,84.01 }

	Teleport[#Teleport+1] = { 4999.84,-5753.85,14.84,857.35,-3250.02,-98.34 }
	Teleport[#Teleport+1] = { 857.35,-3250.02,-98.34,4999.84,-5753.85,14.84 }

	Teleport[#Teleport+1] = { 2349.72,3315.16,54.86,2593.02,3633.64,-5.49 }
	Teleport[#Teleport+1] = { 2593.02,3633.64,-5.49,2349.72,3315.16,54.86 }

	Teleport[#Teleport+1] = { -2760.4,-228.29,22.07,-2927.93,-1801.83,13.26 }
	Teleport[#Teleport+1] = { -2927.93,-1801.83,13.26,-2760.4,-228.29,22.07 }

	Teleport[#Teleport+1] = { 2540.13,-432.26,94.12,-464.59,6004.38,31.49 }
	Teleport[#Teleport+1] = { -464.59,6004.38,31.49,2540.13,-432.26,94.12 }

	Teleport[#Teleport+1] = { 2540.13,-335.98,94.12,-862.52,-1227.61,6.47 }
	Teleport[#Teleport+1] = { -862.52,-1227.61,6.47,2540.13,-335.98,94.12 }

	Teleport[#Teleport+1] = { 2475.06,-388.4,94.39,2616.45,5336.44,47.53 }
	Teleport[#Teleport+1] = { 2616.45,5336.44,47.53,2475.06,-388.4,94.39 }

	Teleport[#Teleport+1] = { -786.56,-1212.29,6.86,-777.27,-1226.08,15.55 }
	Teleport[#Teleport+1] = { -777.27,-1226.08,15.55,-786.56,-1212.29,6.86 }

	Teleport[#Teleport+1] = {-2268.43,378.51,188.75,-2276.14,346.63,174.6}
	Teleport[#Teleport+1] = {-2276.14,346.63,174.6,-2268.43,378.51,188.75}
	
	Teleport[#Teleport+1] = {-2290.78,266.1,164.47,-2279.81,345.3,174.6}
	Teleport[#Teleport+1] = {-2279.81,345.3,174.6,-2290.78,266.1,164.47}

	Teleport[#Teleport+1] = {125.5,-115.64,49.77,-121.43,-503.14,-117.7}
	Teleport[#Teleport+1] = {-121.43,-503.14,-117.7,125.5,-115.64,49.77}

	Teleport[#Teleport+1] = { 130.92,-373.97,61.6,126.0,-387.91,44.94 }
	Teleport[#Teleport+1] = { 126.0,-387.91,44.94,130.92,-373.97,61.6 }

	Teleport[#Teleport+1] = { 2477.40,-366.31,94.82,837.90,-1375.32,26.31 }
	Teleport[#Teleport+1] = { 837.90,-1375.32,26.31,2477.40,-366.31,94.82 }
	-- Mansao96
	Teleport[#Teleport+1] = { 4885.17,-5660.07,26.10,4884.18,-5671.78,76.14 }
	Teleport[#Teleport+1] = { 4884.18,-5671.78,76.14,4885.17,-5660.07,26.10 }


elseif cityName == "Gaules" then

elseif cityName == "Alexandria" then
	Teleport[#Teleport+1] = { -1390.25,-479.2,72.03,-3194.39,833.6,8.93 }
	Teleport[#Teleport+1] = { -3194.39,833.6,8.93,-1390.25,-479.2,72.03 }

	Teleport[#Teleport+1] = { 2475.8,-384.09,94.39,-1902.07,2910.49,32.81 }
	Teleport[#Teleport+1] = { -1902.07,2910.49,32.81,2475.8,-384.09,94.39 }

	Teleport[#Teleport+1] = { -2012.78,299.5,91.76,4984.79,-5719.02,19.88 }
	Teleport[#Teleport+1] = { 4984.79,-5719.02,19.88,-2012.78,299.5,91.76 }

	Teleport[#Teleport+1] = { -262.47,6319.02,32.42,1150.17,-1553.68,35.38 }
	Teleport[#Teleport+1] = { 1150.17,-1553.68,35.38,-262.47,6319.02,32.42 }



elseif cityName == "Maresia" then

	Teleport[#Teleport+1] = { -818.26,-687.42,127.56,-1237.16,813.47,193.38 } -- QG_186
	Teleport[#Teleport+1] = { -1237.16,813.47,193.38,-818.26,-687.42,127.56 }

	Teleport[#Teleport+1] = { 559.58,704.68,202.97,956.67,39.68,81.26 }
	Teleport[#Teleport+1] = { 956.67,39.68,81.26,559.58,704.68,202.97 }

	Teleport[#Teleport+1] = { -71.05,-801.01,44.23,-75.0,-824.54,321.29 }
	Teleport[#Teleport+1] = { -75.0,-824.54,321.29,-71.05,-801.01,44.23 }

	Teleport[#Teleport+1] = { 2484.45,-350.81,93.74,-506.09,-199.65,34.22 }
	Teleport[#Teleport+1] = { -506.09,-199.65,34.22,2484.45,-350.81,93.74 }

	Teleport[#Teleport+1] = { 125.95,-1275.89,39.6,-3477.27,2820.45,16.9 }
	Teleport[#Teleport+1] = { -3477.27,2820.45,16.9,125.95,-1275.89,39.6 }

	Teleport[#Teleport+1] = { -256.78,6334.37,32.43,-253.09,6339.94,37.56 }
	Teleport[#Teleport+1] = { -253.09,6339.94,37.56,-256.78,6334.37,32.43 }

	Teleport[#Teleport+1] = { 1828.98,2554.68,47.21,2477.26,-347.43,93.74 }
	Teleport[#Teleport+1] = { 2477.26,-347.43,93.74,1828.98,2554.68,47.21 }

	Teleport[#Teleport+1] = { 690.16,891.13,246.58,-3825.81,-4453.79,6.08 }
	Teleport[#Teleport+1] = { -3825.81,-4453.79,6.08,690.16,891.13,246.58 }

	Teleport[#Teleport+1] = { -808.37,-1371.20,5.15,-3817.23,-4328.03,6.08 }
	Teleport[#Teleport+1] = { -3817.23,-4328.03,6.08,-808.37,-1371.20,5.15 }

	Teleport[#Teleport+1] = { 1670.49,3594.06,35.89, -626.50,-127.53,36.02 } -- bombeiros
	Teleport[#Teleport+1] = { -626.50,-127.53,36.02, 1670.49,3594.06,35.89 }

	Teleport[#Teleport+1] = { -2051.76,3237.27,31.50,2476.26,-384.10,94.40 }
	Teleport[#Teleport+1] = { 2476.26,-384.10,94.40,-2051.76,3237.27,31.50 }

	Teleport[#Teleport+1] = { -742.98,-1242.00,5.70,2477.63,-365.66,94.82 }
	Teleport[#Teleport+1] = { 2477.63,-365.66,94.82,-742.98,-1242.00,5.70 }

	Teleport[#Teleport+1] = { 2630.77,5295.98,47.54,2477.56,-402.05,94.82 }
	Teleport[#Teleport+1] = { 2477.56,-402.05,94.82,2630.77,5295.98,47.54 }

	Teleport[#Teleport+1] = { -433.55,1592.10,360.32,-74.76,1524.11,289.17 }
	Teleport[#Teleport+1] = { -74.76,1524.11,289.17,-433.55,1592.10,360.32 }

	Teleport[#Teleport+1] = { -468.66,1553.33,393.24,-454.13,1551.41,411.06 }
	Teleport[#Teleport+1] = { -454.13,1551.41,411.06,-468.66,1553.33,393.24 }

	Teleport[#Teleport+1] = { 140.77,-141.0,49.57,122.95,-128.01,54.93 }
	Teleport[#Teleport+1] = { 122.95,-128.01,54.93,140.77,-141.0,49.57 }

	Teleport[#Teleport+1] = { 126.27,-115.7,49.77,-121.43,-502.86,-117.71 }
	Teleport[#Teleport+1] = { -121.43,-502.86,-117.71,126.27,-115.7,49.77 }

	Teleport[#Teleport+1] = { -321.27,209.68,81.77,-303.75,192.27,144.37 }
	Teleport[#Teleport+1] = { -303.75,192.27,144.37,-321.27,209.68,81.77 }

	Teleport[#Teleport+1] = { 1141.15,-1622.48,35.42,-249.27,6334.67,32.42 }
	Teleport[#Teleport+1] = { -249.27,6334.67,32.42,1141.15,-1622.48,35.42 }

	Teleport[#Teleport+1] = { -764.99,-1240.37,5.7,2626.41,5273.85,47.58 } -- prf
	Teleport[#Teleport+1] = { 2626.41,5273.85,47.58,-764.99,-1240.37,5.7 }

	Teleport[#Teleport+1] = { -761.86,-1242.84,5.7,2528.11,-313.89,92.99 } -- militar
	Teleport[#Teleport+1] = { 2528.11,-313.89,92.99,-761.86,-1242.84,5.7 }

	Teleport[#Teleport+1] = { -754.61,-1249.27,5.7,-453.01,6000.88,32.28 } -- civil
	Teleport[#Teleport+1] = { -453.01,6000.88,32.28,-754.61,-1249.27,5.7 }

	Teleport[#Teleport+1] = { -754.1,-1249.13,5.7,-1822.44,3017.36,32.81 } -- civil
	Teleport[#Teleport+1] = { -1822.44,3017.36,32.81,-754.1,-1249.13,5.7 }

	Teleport[#Teleport+1] = { -757.2,-1246.37,5.7,-1822.44,3017.36,32.81 } -- exercito
	Teleport[#Teleport+1] = { -1822.44,3017.36,32.81,-757.2,-1246.37,5.7 }

	Teleport[#Teleport+1] = { -761.4,-1243.0,5.7,-2539.9,-335.69,94.33 } -- militar
	Teleport[#Teleport+1] = { -2539.9,-335.69,94.33,-761.4,-1243.0,5.7 }
	
	Teleport[#Teleport+1] = { -764.45,-1240.27,5.7,-2624.23,5314.34,47.52 } -- prf
	Teleport[#Teleport+1] = { -2624.23,5314.34,47.52,-764.45,-1240.27,5.7 }

	-- tp bellagio
	Teleport[#Teleport+1] = { 944.89,47.79,80.29,964.63,58.78,112.56 }
	Teleport[#Teleport+1] = { 964.63,58.78,112.56,944.89,47.79,80.29 }
	-- hp
	Teleport[#Teleport+1] = { 1120.3,-1532.67,34.85,1143.17,-1539.52,48.14 }
	Teleport[#Teleport+1] = { 1143.17,-1539.52,48.14,1120.3,-1532.67,34.85 }

	Teleport[#Teleport+1] = { 3429.0,3749.69,30.8,3839.49,3648.26,1.21 }
	Teleport[#Teleport+1] = { 3839.49,3648.26,1.21,3429.0,3749.69,30.8 }
	-- militar
	Teleport[#Teleport+1] = { 2501.58,-340.08,94.09,2511.2,-346.7,111.68 }
	Teleport[#Teleport+1] = { 2511.2,-346.7,111.68,2501.58,-340.08,94.09 }
	-- tatica
	Teleport[#Teleport+1] = { -777.05,-1225.88,15.55,-786.39,-1212.6,6.86 }
	Teleport[#Teleport+1] = { -786.39,-1212.6,6.86,-777.05,-1225.88,15.55 }
	-- militar/civil
	Teleport[#Teleport+1] = { 2488.34,-364.11,93.74,-450.23,6010.4,27.58 }
	Teleport[#Teleport+1] = { -450.23,6010.4,27.58,2488.34,-364.11,93.74 }
	-- militar/tatica
	Teleport[#Teleport+1] = { 2488.25,-404.1,93.74,-862.56,-1227.58,6.47 }
	Teleport[#Teleport+1] = { -862.56,-1227.58,6.47,2488.25,-404.1,93.74 }
	-- QG_106 quartos
	Teleport[#Teleport+1] = { 125.71,-115.80,49.78,-121.36,-502.99,-117.70 }
	Teleport[#Teleport+1] = { -121.36,-502.99,-117.70,125.71,-115.80,49.78 }
	--QG_106 lateral
	Teleport[#Teleport+1] = { 123.04,-127.92,54.94,140.97,-141.09,49.58 }
	Teleport[#Teleport+1] = { 140.97,-141.09,49.58,123.04,-127.92,54.94 }

	Teleport[#Teleport+1] = { -1562.1,155.64,58.32,-1511.51,173.41,143.7 } -- QG_414
	Teleport[#Teleport+1] = { -1511.51,173.41,143.7,-1562.1,155.64,58.32 }

	Teleport[#Teleport+1] = { 142.75,-349.1,50.33,130.73,-373.89,61.6 }
	Teleport[#Teleport+1] = { 130.73,-373.89,61.6,142.75,-349.1,50.33 }

	Teleport[#Teleport+1] = { 94.96,-1299.77,29.32,146.3,-366.23,61.6 }
	Teleport[#Teleport+1] = { 146.3,-366.23,61.6,94.96,-1299.77,29.32 }

	Teleport[#Teleport+1] = { -1572.33,-394.23,59.15,-1562.60,-404.07,42.38 } -- QG_496
	Teleport[#Teleport+1] = { -1562.60,-404.07,42.38,-1572.33,-394.23,59.15 }

	Teleport[#Teleport+1] = { -1465.38,184.04,55.62,-2741.08,-235.62,12.48 }
	Teleport[#Teleport+1] = { -2741.08,-235.62,12.48,-1465.38,184.04,55.62 }

end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
local CachedBlips = {}
function DeleteBlips()
    for k,v in pairs(CachedBlips) do
        RemoveBlip(v)
        CachedBlips[k] = nil
    end
    CachedBlips = {}
end
function CreateBlips()
	for k,v in pairs(Blips) do
		CachedBlips[k] = AddBlipForCoord(v[1],v[2],v[3])
		SetBlipSprite(CachedBlips[k],v[4])
		SetBlipDisplay(CachedBlips[k],4)
		SetBlipAsShortRange(CachedBlips[k],true)
		SetBlipColour(CachedBlips[k],v[5])
		SetBlipScale(CachedBlips[k],v[7])
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(v[6])
		EndTextCommandSetBlipName(CachedBlips[k])
	end
end

AddEventHandler("misc:CreateBlips",function(resource)
    CreateBlips()
end)

AddEventHandler("misc:DeleteBlips",function(resource)
    DeleteBlips()
end)
CreateThread(function()
    CreateBlips()

	local Table = {}

	for _,v in pairs(Teleport) do
		table.insert(Table,{ v[1],v[2],v[3],1,"E",_t("accessDoor"),_t("pressToAccess") })
	end

	for _, teleport in pairs(gWorldTeleports[cityName] or {}) do
		table.insert(Table,{ teleport.entry.coords.x,teleport.entry.coords.y,teleport.entry.coords.z,1,"E",_t("accessDoor"),_t("pressToAccess") })
		table.insert(Table,{ teleport.exit.coords.x,teleport.exit.coords.y,teleport.exit.coords.z,1,"E",_t("accessDoor"),_t("pressToAccess") })
	end

	TriggerEvent("hoverfy:Insert",Table)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTELEPORT
-----------------------------------------------------------------------------------------------------------------------------------------
---@param ped number
---@param teleport number[]
---@param teleportIndex number
---@param originCoords vector3
---@param shouldFreezeNearbyObject boolean
local function ExecuteTeleport( ped, teleport, teleportIndex, originCoords, shouldFreezeNearbyObject )
	SetEntityCoords(ped,teleport[4],teleport[5],teleport[6],false,false,false,false)

	if teleport[7] then
		SetEntityHeading(ped, teleport[7])
	end

    FreezeEntityPosition(ped,true)
    Wait(5000)
    FreezeEntityPosition(ped,false)

	if shouldFreezeNearbyObject and (teleportIndex == 19 or teleportIndex == 20) then
		local Finishing = false
		local Handle,Object = FindFirstObject()

		repeat
			local Coords2 = GetEntityCoords(Object)
			local Distance = #(Coords2 - originCoords)

			if Distance < 3.0 and GetEntityModel(Object) == 961976194 then
				FreezeEntityPosition(Object,true)
			end

			Finishing,Object = FindNextObject(Handle)
		until not Finishing

		EndFindObject(Handle)
	end
end

CreateThread(function()
	while true do
		local TimeDistance = 999
		if LocalPlayer["state"]["Route"] < 900000 then
			local Ped = PlayerPedId()
			if not IsPedInAnyVehicle(Ped) then
				local Coords = GetEntityCoords(Ped)
				for k,v in pairs(Teleport) do
					local Distance = #(Coords - vec3(v[1],v[2],v[3]))
					if Distance <= 1 then
						TimeDistance = 1

						if IsControlJustPressed(1,38) and not vRP.ReturnNoClip() then
							ExecuteTeleport(Ped, v, k, Coords, true)
						end
					end
				end

				for teleportIndex, teleport in pairs(gWorldTeleports[cityName] or {}) do
					for side, sideConfig in pairs(teleport) do
						if side == "entry" or side == "exit" then
							local distance = #(Coords - vec3(sideConfig.coords.x, sideConfig.coords.y, sideConfig.coords.z))

							if distance <= 1 then
								TimeDistance = 1

								if IsControlJustPressed(1,38) and not vRP.ReturnNoClip() then
									local destination = side == "entry" and teleport.exit or teleport.entry
									TriggerServerEvent("player:WorldTeleport", teleportIndex, side)
									ExecuteTeleport(Ped, { 0, 0, 0, destination.coords.x, destination.coords.y, destination.coords.z, destination.coords.w }, teleportIndex, Coords, false)
								end
							end
						end
					end
				end
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHCAMERA
-----------------------------------------------------------------------------------------------------------------------------------------
local fov_max = 80.0
local fov_min = 10.0
local speed_ud = 3.0
local zoomspeed = 2.0
local vehCamera = false
local fov = (fov_max + fov_min) * 0.5

---@param pedId number
local function StartRappelFromHeliPassengerSeat( pedId )

	if not IsPedInAnyHeli( pedId ) then
		return
	end

	local vehicleEntityId = GetVehiclePedIsUsing( pedId )

	if GetPedInVehicleSeat( vehicleEntityId, 1 ) == pedId or GetPedInVehicleSeat( vehicleEntityId, 2 ) == pedId then
		TaskRappelFromHeli( pedId, 1 )
	end
end

RegisterCommand( "rappel", function()

	StartRappelFromHeliPassengerSeat( PlayerPedId() )
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADCAMERA
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local waitPacket = 500
		local Ped = PlayerPedId()
		if IsPedInAnyHeli(Ped) then
			waitPacket = 4

			local veh = GetVehiclePedIsUsing(Ped)
			SetVehicleRadioEnabled(veh,false)

			if IsControlJustPressed(1,51) then
				TriggerEvent("hud:Active",false)
				vehCamera = true
			end

			if IsControlJustPressed(1,154) then
				StartRappelFromHeliPassengerSeat( Ped )
			end

			if vehCamera then
				SetTimecycleModifierStrength(0.3)
				SetTimecycleModifier("heliGunCam")

				local scaleform = RequestScaleformMovie("HELI_CAM")
				while not HasScaleformMovieLoaded(scaleform) do
					Wait(1)
				end

				local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA",true)
				AttachCamToEntity(cam,veh,0.0,0.0,-1.5,true)
				SetCamRot(cam,0.0,0.0,GetEntityHeading(veh))
				SetCamFov(cam,fov)
				RenderScriptCams(true,false,0,1,0)
				PushScaleformMovieFunction(scaleform,"SET_CAM_LOGO")
				PushScaleformMovieFunctionParameterInt(0)
				PopScaleformMovieFunctionVoid()

				while vehCamera do
					if IsControlJustPressed(1,51) then
						TriggerEvent("hud:Active",true)
						vehCamera = false
					end

					local zoomvalue = (1.0 / (fov_max - fov_min)) * (fov - fov_min)
					CheckInputRotation(cam,zoomvalue)
					HandleZoom(cam)
					HideHudAndRadarThisFrame()
					HideHudComponentThisFrame(19)
					PushScaleformMovieFunction(scaleform,"SET_ALT_FOV_HEADING")
					PushScaleformMovieFunctionParameterFloat(GetEntityCoords(veh).z)
					PushScaleformMovieFunctionParameterFloat(zoomvalue)
					PushScaleformMovieFunctionParameterFloat(GetCamRot(cam,2).z)
					PopScaleformMovieFunctionVoid()
					DrawScaleformMovieFullscreen(scaleform,255,255,255,255)

					Wait(1)
				end

				ClearTimecycleModifier()
				fov = (fov_max + fov_min) * 0.5
				RenderScriptCams(false,false,0,1,0)
				SetScaleformMovieAsNoLongerNeeded(scaleform)
				DestroyCam(cam,false)
				SetNightvision(false)
				SetSeethrough(false)
			end
		end

		Wait(waitPacket)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKINPUTROTATION
-----------------------------------------------------------------------------------------------------------------------------------------
function CheckInputRotation(cam,zoomvalue)
	local rightAxisX = GetDisabledControlNormal(0,220)
	local rightAxisY = GetDisabledControlNormal(0,221)
	local rotation = GetCamRot(cam,2)
	if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
		new_z = rotation.z + rightAxisX * -1.0 * (speed_ud) * (zoomvalue + 0.1)
		new_x = math.max(math.min(20.0,rotation.x + rightAxisY * -1.0 * (3.0) * (zoomvalue + 0.1)),-89.5)
		SetCamRot(cam,new_x,0.0,new_z,2)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HANDLEZOOM
-----------------------------------------------------------------------------------------------------------------------------------------
function HandleZoom(cam)
	if IsControlJustPressed(1,241) then
		fov = math.max(fov - zoomspeed,fov_min)
	end

	if IsControlJustPressed(1,242) then
		fov = math.min(fov + zoomspeed,fov_max)
	end

	local current_fov = GetCamFov(cam)
	if math.abs(fov - current_fov) < 0.1 then
		fov = current_fov
	end

	SetCamFov(cam,current_fov + (fov - current_fov) * 0.05)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTITYSETLOADER
-----------------------------------------------------------------------------------------------------------------------------------------
local entitySetList = {
	{
		props = {
			"swap_clean_apt",
			"layer_debra_pic",
			"layer_whiskey",
			"swap_sofa_A"
		},
		coords = { -1150.7, -1520.7, 10.6 }
	}, {
		props = {
			"csr_beforeMission",
			"csr_inMission"
		},
		coords = { -47.1, -1115.3, 26.5 }
	}, {
		props = {
			"V_Michael_bed_tidy",
			"V_Michael_M_items",
			"V_Michael_D_items",
			"V_Michael_S_items",
			"V_Michael_L_Items"
		},
		coords = { -802.3, 175.0, 72.8 }
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADENTITYSETLOADER
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for _k, _v in pairs(entitySetList) do
		local interiorCoords = GetInteriorAtCoords(_v["coords"][1], _v["coords"][2], _v["coords"][3])
		LoadInterior(interiorCoords)

		if _v["props"] ~= nil then
			for k, v in pairs(_v["props"]) do
				EnableInteriorProp(interiorCoords, v)
				Wait(1)
			end
		end

		RefreshInterior(interiorCoords)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ISLAND
-----------------------------------------------------------------------------------------------------------------------------------------
local Island = {
	"h4_islandairstrip",
	"h4_islandairstrip_props",
	"h4_islandx_mansion",
	"h4_islandx_mansion_props",
	"h4_islandx_props",
	"h4_islandxdock",
	"h4_islandxdock_props",
	"h4_islandxdock_props_2",
	"h4_islandxtower",
	"h4_islandx_maindock",
	"h4_islandx_maindock_props",
	"h4_islandx_maindock_props_2",
	"h4_IslandX_Mansion_Vault",
	"h4_islandairstrip_propsb",
	"h4_beach",
	"h4_beach_props",
	"h4_beach_bar_props",
	"h4_islandx_barrack_props",
	"h4_islandx_checkpoint",
	"h4_islandx_checkpoint_props",
	"h4_islandx_Mansion_Office",
	"h4_islandx_Mansion_LockUp_01",
	"h4_islandx_Mansion_LockUp_02",
	"h4_islandx_Mansion_LockUp_03",
	"h4_islandairstrip_hangar_props",
	"h4_IslandX_Mansion_B",
	"h4_islandairstrip_doorsclosed",
	"h4_Underwater_Gate_Closed",
	"h4_mansion_gate_closed",
	"h4_aa_guns",
	"h4_IslandX_Mansion_GuardFence",
	"h4_IslandX_Mansion_Entrance_Fence",
	"h4_IslandX_Mansion_B_Side_Fence",
	"h4_IslandX_Mansion_Lights",
	"h4_islandxcanal_props",
	"h4_beach_props_party",
	"h4_islandX_Terrain_props_06_a",
	"h4_islandX_Terrain_props_06_b",
	"h4_islandX_Terrain_props_06_c",
	"h4_islandX_Terrain_props_05_a",
	"h4_islandX_Terrain_props_05_b",
	"h4_islandX_Terrain_props_05_c",
	"h4_islandX_Terrain_props_05_d",
	"h4_islandX_Terrain_props_05_e",
	"h4_islandX_Terrain_props_05_f",
	"h4_islandx_terrain_01",
	"h4_islandx_terrain_02",
	"h4_islandx_terrain_03",
	"h4_islandx_terrain_04",
	"h4_islandx_terrain_05",
	"h4_islandx_terrain_06",
	"h4_ne_ipl_00",
	"h4_ne_ipl_01",
	"h4_ne_ipl_02",
	"h4_ne_ipl_03",
	"h4_ne_ipl_04",
	"h4_ne_ipl_05",
	"h4_ne_ipl_06",
	"h4_ne_ipl_07",
	"h4_ne_ipl_08",
	"h4_ne_ipl_09",
	"h4_nw_ipl_00",
	"h4_nw_ipl_01",
	"h4_nw_ipl_02",
	"h4_nw_ipl_03",
	"h4_nw_ipl_04",
	"h4_nw_ipl_05",
	"h4_nw_ipl_06",
	"h4_nw_ipl_07",
	"h4_nw_ipl_08",
	"h4_nw_ipl_09",
	"h4_se_ipl_00",
	"h4_se_ipl_01",
	"h4_se_ipl_02",
	"h4_se_ipl_03",
	"h4_se_ipl_04",
	"h4_se_ipl_05",
	"h4_se_ipl_06",
	"h4_se_ipl_07",
	"h4_se_ipl_08",
	"h4_se_ipl_09",
	"h4_sw_ipl_00",
	"h4_sw_ipl_01",
	"h4_sw_ipl_02",
	"h4_sw_ipl_03",
	"h4_sw_ipl_04",
	"h4_sw_ipl_05",
	"h4_sw_ipl_06",
	"h4_sw_ipl_07",
	"h4_sw_ipl_08",
	"h4_sw_ipl_09",
	"h4_islandx_mansion",
	"h4_islandxtower_veg",
	"h4_islandx_sea_mines",
	"h4_islandx",
	"h4_islandx_barrack_hatch",
	"h4_islandxdock_water_hatch",
	"h4_beach_party"
}

local CAYO_PERICO_CENTER = vec3(5007.27, -5077.20, -0.40)
local CAYO_PERICO_LOAD_DISTANCE = 3500.0
local CAYO_PERICO_MINIMAP_CENTER = vec3(4858.0, -5171.0, 2.0)
local CAYO_PERICO_MINIMAP_DISTANCE = 2200.0
local CayoPericoPreview = nil
local CayoPerico = false

---@type boolean
local _isCloseToCayo = false

---@type boolean
local _isCayoMinimapLoaded = false

---@param coords vector3
---@return boolean
local function IsCloseToCayoPerico(coords)
	return #(coords - CAYO_PERICO_CENTER) <= CAYO_PERICO_LOAD_DISTANCE
end

---@param coords vector3
---@return boolean
local function IsCloseToCayoPericoMinimap(coords)
	return #(coords - CAYO_PERICO_MINIMAP_CENTER) < CAYO_PERICO_MINIMAP_DISTANCE
end

---@param enabled boolean
local function SetCayoPericoEnabled(enabled)
	if CayoPerico ~= enabled then
		for _, ipl in ipairs(Island) do
			if enabled then
				RequestIpl(ipl)
			else
				RemoveIpl(ipl)
			end
		end

		SetIslandHopperEnabled("HeistIsland", enabled)
		SetAiGlobalPathNodesType(enabled and 1 or 0)
		SetDeepOceanScaler(enabled and 0.0 or 1.0)
		LoadGlobalWaterType(enabled and 1 or 0)
		CayoPerico = enabled
	end
end

---@param enabled boolean
local function SetCayoPericoMinimapEnabled(enabled)
	if _isCayoMinimapLoaded ~= enabled then
		_isCayoMinimapLoaded = enabled
		SetToggleMinimapHeistIsland(enabled)
	end
end

local function RefreshCayoPerico()
	local enabled = CayoPericoPreview

	if enabled == nil then
		local pos = (sx and sx.client and sx.client.player and sx.client.player.getFocusPosition) and sx.client.player.getFocusPosition() or GetEntityCoords(PlayerPedId())
		enabled = IsCloseToCayoPerico(pos)
	end

	SetCayoPericoEnabled(enabled)
end

exports("SetCayoPericoPreview", function(enabled)
	if enabled ~= nil and type(enabled) ~= "boolean" then
		return false
	end

	CayoPericoPreview = enabled
	RefreshCayoPerico()

	local minimapEnabled = enabled

	if minimapEnabled == nil then
		minimapEnabled = IsCloseToCayoPericoMinimap(GetEntityCoords(PlayerPedId()))
	end

	SetCayoPericoMinimapEnabled(minimapEnabled)

	return true
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADCAYO
-----------------------------------------------------------------------------------------------------------------------------------------
local StealthKills = {
    "ACT_stealth_kill_a",
    "ACT_stealth_kill_weapon",
    "ACT_stealth_kill_b",
    "ACT_stealth_kill_c",
    "ACT_stealth_kill_d",
    "ACT_stealth_kill_a_gardener"
}

CreateThread(function()
    for _, killName in ipairs(StealthKills) do
        local hash = GetHashKey(killName)
        RemoveStealthKill(hash, false)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADCAYO
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    Wait(10000)

	while true do
		RefreshCayoPerico()
		Wait(1000)
	end
end)

-- Dano soco
CreateThread(function()
    while true do
		SetWeaponDamageModifier(GetHashKey("WEAPON_UNARMED"),0.1)
        Wait(100)
    end
end)


---Checks coords to know if the player is close enough to cayo perico to be in need to load the minimap with SetToggleMinimapHeistIsland
Citizen.CreateThread(function()
    while true do
        ---Wether the player is actually close to cayo perico or not
        ---@type boolean
        local isCloseToCayo<const> = IsCloseToCayoPericoMinimap(GetEntityCoords(PlayerPedId()))

        if _isCloseToCayo ~= isCloseToCayo then
            -- If the player is now close to cayo perico and was not, or vice versa
            -- Then we init our variables and unload the minimap
            _isCloseToCayo = isCloseToCayo
            local shouldLoadMinimap = CayoPericoPreview

            if shouldLoadMinimap == nil then
				shouldLoadMinimap = isCloseToCayo
			end

            -- switch radar interior
            SetCayoPericoMinimapEnabled(shouldLoadMinimap)
        end

        Wait(5000)
    end
end)

---Handle the minimap loading and unloading
CreateThread(function()
    while true do
        ---We don't need to do something every frame in every cases
        ---@type integer
        local wait = 500

        if IsPauseMenuActive() and not IsMinimapInInterior() then
            -- If the player is in the pause menu and not looking at an interior minimap
            if _isCayoMinimapLoaded then
                -- If the minimap was loaded with SetToggleMinimapHeistIsland, then we disable it
                _isCayoMinimapLoaded = false
                SetToggleMinimapHeistIsland(false)
            end
            -- We force load the cayo perico minimap
            SetRadarAsExteriorThisFrame()
            SetRadarAsInteriorThisFrame(GetHashKey("h4_fake_islandx"), 4700.0, -5145.0, 0, 0)
            wait = 0

        elseif CayoPericoPreview == nil and not _isCayoMinimapLoaded and _isCloseToCayo then
            -- If the minimap is not loaded with SetToggleMinimapHeistIsland and the player is close to cayo perico, then we load it
            SetCayoPericoMinimapEnabled(true)
        end
        Wait(wait)
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- WATERCALM
-----------------------------------------------------------------------------------------------------------------------------------------
-- TODO: Otimization needed
local overrideWaves = {
    { cds = vec3(-2507.57,-2247.85,2.9), range = 180.0}
}
local function SetWaterCalm(set, fade)
    if set then
        WaterOverrideFadeIn(fade)
        WaterOverrideSetOceannoiseminamplitude(0.05)
        WaterOverrideSetOceanwaveamplitude(0.05)
        WaterOverrideSetOceanwaveminamplitude(0.05)
        WaterOverrideSetOceanwavemaxamplitude(0.05)
        WaterOverrideSetShorewaveamplitude(0.10)
        WaterOverrideSetShorewaveminamplitude(0.05)
        WaterOverrideSetShorewavemaxamplitude(0.10)
        WaterOverrideSetRipplebumpiness(0.15)
        WaterOverrideSetRippledisturb(0.3)
        WaterOverrideSetRipplemaxbumpiness(0.4)
        WaterOverrideSetRippleminbumpiness(0.05)
    else
        WaterOverrideFadeOut(fade)
    end
end
CreateThread(function()
    while true do
        local cds = GetEntityCoords(PlayerPedId())
        for _, waveInfo in pairs(overrideWaves) do
            local waveCds = waveInfo.cds
            if #(cds - waveCds) <= waveInfo.range then
                SetWaterCalm(true, 1.0)
                while #(cds - waveCds) <= waveInfo.range do
                    Wait(1000)
                    cds = GetEntityCoords(PlayerPedId())
                end
                SetWaterCalm(false, 1.0)
            end
        end
        Wait(1000)
    end
end)
