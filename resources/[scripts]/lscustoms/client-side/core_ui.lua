local currentMenuItemID = 0
local currentMenuItem = ""
local currentMenuItem2 = ""
local currentMenu = "mainMenu"
local currentCategory = 0
local currentResprayCategory = 0
local currentResprayType = 0
local currentWheelCategory = 0
local currentNeonSide = 0
local appliedResprayTypes = {}

local function roundNum(num,numDecimalPlaces)
	return tonumber(string.format("%."..(numDecimalPlaces or 0).."f",num))
end

local function toggleMenuContainer(state)
	SendNUIMessage({ toggleMenuContainer = true, state = state })
end

local function createMenu(menu,heading,subheading)
	SendNUIMessage({ createMenu = true, menu = menu, heading = heading, subheading = subheading })
end

local function destroyMenus()
	SendNUIMessage({ destroyMenus = true })
end

local function populateMenu(menu,id,item,item2,translation)
	SendNUIMessage({ populateMenu = true, menu = menu, id = id, item = item, item2 = item2, translation = translation })
end

local function finishPopulatingMenu(menu)
	SendNUIMessage({ finishPopulatingMenu = true, menu = menu })
end

local function updateMenuHeading(menu)
	SendNUIMessage({ updateMenuHeading = true, menu = menu })
end

local function updateMenuSubheading(menu)
	SendNUIMessage({ updateMenuSubheading = true, menu = menu })
end

local function updateMenuStatus(text)
	SendNUIMessage({ updateMenuStatus = true, statusText = text })
end

local function toggleMenu(state,menu)
	SendNUIMessage({ toggleMenu = true, state = state, menu = menu })
end

local function updateItem2Text(menu,id,text)
	SendNUIMessage({ updateItem2Text = true, menu = menu, id = id, item2 = text })
end

local function updateItem2TextOnly(menu,id,text)
	SendNUIMessage({ updateItem2TextOnly = true, menu = menu, id = id, item2 = text })
end

local function scrollMenuFunctionality(direction,menu)
	SendNUIMessage({ scrollMenuFunctionality = true, direction = direction, menu = menu })
end

local function playSoundEffect(soundEffect,volume)
	SendNUIMessage({ playSoundEffect = true, soundEffect = soundEffect, volume = volume })
end

local function isMenuActive(menu)
	local menuActive = false

	if menu == "modMenu" then
		for k,v in pairs(vehicleCustomisation) do 
			if (v["category"]:gsub("%s+","").."Menu") == currentMenu then
				menuActive = true

				break
			else
				menuActive = false
			end
		end
	elseif menu == "ResprayMenu" then
		for k,v in pairs(vehicleResprayOptions) do
			if (v["category"]:gsub("%s+","").."Menu") == currentMenu then
				menuActive = true

				break
			else
				menuActive = false
			end
		end
	elseif menu == "WheelsMenu" then
		for k,v in pairs(vehicleWheelOptions) do
			if (v["category"]:gsub("%s+","").."Menu") == currentMenu then
				menuActive = true

				break
			else
				menuActive = false
			end
		end
	elseif menu == "NeonsSideMenu" then
		for k,v in pairs(vehicleNeonOptions["neonTypes"]) do
			if (v["name"]:gsub("%s+","").."Menu") == currentMenu then
				menuActive = true

				break
			else
				menuActive = false
			end
		end
	end

	return menuActive
end

local function updateCurrentMenuItemID(id,item,item2)
	currentMenuItemID = id
	currentMenuItem = item
	currentMenuItem2 = item2

	if isMenuActive("modMenu") then
		if currentCategory ~= 18 then
			PreviewMod(currentCategory,currentMenuItemID)
		end
	elseif isMenuActive("ResprayMenu") then
		PreviewColour(currentResprayCategory,currentResprayType,currentMenuItemID)
	elseif isMenuActive("WheelsMenu") then
		if currentWheelCategory ~= -1 and currentWheelCategory ~= 20 then
			PreviewWheel(currentCategory,currentMenuItemID,currentWheelCategory)
		end
	elseif isMenuActive("NeonsSideMenu") then
		PreviewNeon(currentNeonSide,currentMenuItemID)
	elseif currentMenu == "WindowTintMenu" then
		PreviewWindowTint(currentMenuItemID)
	elseif currentMenu == "NeonColoursMenu" then
		local r = vehicleNeonOptions["neonColours"][currentMenuItemID]["r"]
		local g = vehicleNeonOptions["neonColours"][currentMenuItemID]["g"]
		local b = vehicleNeonOptions["neonColours"][currentMenuItemID]["b"]

		PreviewNeonColour(r,g,b)
	elseif currentMenu == "XenonColoursMenu" then
		PreviewXenonColour(currentMenuItemID)
	elseif currentMenu == "PoliceLiveryMenu" then
		PreviewPoliceLivery(currentMenuItemID)
	elseif currentMenu == "PlateIndexMenu" then
		PreviewPlateIndex(currentMenuItemID)
	end
end

function InitiateMenus(isMotorcycle)
	destroyMenus()

	-- Resetar tipos de respray aplicados ao iniciar
	appliedResprayTypes = {}
	
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)
	local vehclass = GetVehicleClass(vehicle)

	createMenu("mainMenu", _t("welcome_bennys"), _t("choose_category"))

	for k,v in ipairs(vehicleCustomisation) do 
		local validMods,amountValidMods = CheckValidMods(v["category"],v["id"])

		if amountValidMods > 0 or v["id"] == 18 then
			populateMenu("mainMenu",v["id"],v["category"],"none")
		end
	end

	populateMenu("mainMenu",-1,"Respray","none", _t("respray"))

	if not isMotorcycle then
		populateMenu("mainMenu",-2,"Window Tint","none", _t("window_tint"))
		populateMenu("mainMenu",-3,"Neons","none")
	end

	populateMenu("mainMenu",22,"Xenons","none", _t("xenons"))
	populateMenu("mainMenu",23,"Wheels","none", _t("wheels"))

	populateMenu("mainMenu",26,"Vehicle Extras","none", _t("vehicle_extras"))

	populateMenu("mainMenu",24,"Police Livery","none", _t("police_livery"))
	populateMenu("mainMenu",25,"Plate Index","none", _t("plate_index"))

	finishPopulatingMenu("mainMenu")

	for k,v in ipairs(vehicleCustomisation) do 
		local validMods,amountValidMods = CheckValidMods(v["category"],v["id"])
		local currentMod,currentModName = GetCurrentMod(v["id"])

		if amountValidMods > 0 or v["id"] == 18 then
			if v["id"] == 11 or v["id"] == 12 or v["id"] == 13 or v["id"] == 15 or v["id"] == 16 then
				local tempNum = 0

				createMenu(v["category"]:gsub("%s+","").."Menu",v["category"],_t("choose_upgrade"))

				for m,n in pairs(validMods) do
					tempNum = tempNum + 1

					local price = vehicleCustomisationPrices[v["type"]] and vehicleCustomisationPrices[v["type"]][tempNum] or 0

					-- print('price:', price, 'v["type"]:', v["type"], 'tempNum:', tempNum)


					populateMenu(v["category"]:gsub("%s+","").."Menu",n["id"],n["name"],"$"..price)

					if currentMod == n["id"] then
						updateItem2Text(v["category"]:gsub("%s+","").."Menu",n["id"],_t("installed"))
					end
				end

				finishPopulatingMenu(v["category"]:gsub("%s+","").."Menu")
			elseif v["id"] == 18 then
				local currentTurboState = GetCurrentTurboState()
				createMenu(v["category"]:gsub("%s+","").."Menu",v["category"].." "..(_t("customisation")),_t("toggle_turbo"))

				populateMenu(v["category"]:gsub("%s+","").."Menu",0,_t("disabled"),"$7500")
				populateMenu(v["category"]:gsub("%s+","").."Menu",1,_t("enabled"),"$"..vehicleCustomisationPrices["turbo"])

				updateItem2Text(v["category"]:gsub("%s+","").."Menu",currentTurboState,_t("installed"))

				finishPopulatingMenu(v["category"]:gsub("%s+","").."Menu")
			else
				createMenu(v["category"]:gsub("%s+","").."Menu",v["category"].." "..(_t("customisation")),_t("choose_mod"))

				for m,n in pairs(validMods) do
					populateMenu(v["category"]:gsub("%s+","").."Menu",n["id"],n["name"],"$"..vehicleCustomisationPrices["cosmetics"])

					if currentMod == n["id"] then
						updateItem2Text(v["category"]:gsub("%s+","").."Menu",n["id"],_t("installed"))
					end
				end

				finishPopulatingMenu(v["category"]:gsub("%s+","").."Menu")
			end
		end
	end

	createMenu("ResprayMenu", _t("respray"), _t("choose_color"))

    for k,v in ipairs(vehicleResprayCategories) do
        populateMenu("ResprayMenu",v["id"],v["category"],"none")
    end

	finishPopulatingMenu("ResprayMenu")

	createMenu("ResprayTypeMenu", _t("respray_types"), _t("choose_respray_type"))

	for k,v in ipairs(vehicleResprayOptions) do
		populateMenu("ResprayTypeMenu",v["id"],v["category"],"none")
	end

	finishPopulatingMenu("ResprayTypeMenu")

	for k,v in ipairs(vehicleResprayOptions) do 
		createMenu(v["category"].."Menu",v["category"],_t("choose_color"))

		for m,n in ipairs(v["colours"]) do
			populateMenu(v["category"].."Menu",n["id"],n["name"],"$"..vehicleCustomisationPrices["respray"])
		end

		finishPopulatingMenu(v["category"].."Menu")
	end

	createMenu("WheelsMenu", _t("wheel_categories"), _t("choose_category"))

	for k,v in ipairs(vehicleWheelOptions) do 
		if isMotorcycle then
			if v["id"] == -1 or v["id"] == 20 or v["id"] == 6 then
				populateMenu("WheelsMenu",v["id"],v["category"],"none")
			end
		else
			populateMenu("WheelsMenu",v["id"],v["category"],"none")
		end
	end

	finishPopulatingMenu("WheelsMenu")

	for k,v in ipairs(vehicleWheelOptions) do 
		if v["id"] == -1 then
			local currentCustomWheelState = GetCurrentCustomWheelState()
			createMenu(v["category"]:gsub("%s+","").."Menu",v["category"], _t("toggle_wheels"))

			populateMenu(v["category"]:gsub("%s+","").."Menu",0,_t("disabled"),"$0")
			populateMenu(v["category"]:gsub("%s+","").."Menu",1,_t("enabled"),"$"..vehicleCustomisationPrices["customwheels"])

			updateItem2Text(v["category"]:gsub("%s+","").."Menu",currentCustomWheelState,_t("installed"))

			finishPopulatingMenu(v["category"]:gsub("%s+","").."Menu")
		elseif v["id"] ~= 20 then
			if isMotorcycle then
				if v["id"] == 6 then
					local validMods,amountValidMods = CheckValidMods(v["category"],v.wheelID,v["id"])

					createMenu(v["category"].."Menu",v["category"].." Wheels",_t("choose_color"))

					for m,n in pairs(validMods) do
						populateMenu(v["category"].."Menu",n["id"],n["name"],"$"..vehicleCustomisationPrices["wheels"])
					end

					finishPopulatingMenu(v["category"].."Menu")
				end
			else
				local validMods,amountValidMods = CheckValidMods(v["category"],v.wheelID,v["id"])

				createMenu(v["category"].."Menu",v["category"].." Wheels",_t("choose_color"))

				for m,n in pairs(validMods) do
					populateMenu(v["category"].."Menu",n["id"],n["name"],"$"..vehicleCustomisationPrices["wheels"])
				end

				finishPopulatingMenu(v["category"].."Menu")
			end
		end
	end

	local currentWheelSmokeR,currentWheelSmokeG,currentWheelSmokeB = GetCurrentVehicleWheelSmokeColour()
	createMenu("TyreSmokeMenu", _t("tyre_smoke_customisation"), _t("choose_color"))

	for k,v in ipairs(vehicleTyreSmokeOptions) do
		populateMenu("TyreSmokeMenu",k,v["name"],"$"..vehicleCustomisationPrices["wheelsmoke"])

		if v["r"] == currentWheelSmokeR and v["g"] == currentWheelSmokeG and v["b"] == currentWheelSmokeB then
			updateItem2Text("TyreSmokeMenu",k,_t("installed"))
		end
	end

	finishPopulatingMenu("TyreSmokeMenu")

	local currentWindowTint = GetCurrentWindowTint()
	createMenu("WindowTintMenu", _t("window_tint_customisation"), _t("choose_tint"))

	for k,v in ipairs(vehicleWindowTintOptions) do
		populateMenu("WindowTintMenu",v["id"],v["name"],"$"..vehicleCustomisationPrices["windowtint"])

		if currentWindowTint == v["id"] then
			updateItem2Text("WindowTintMenu",v["id"],_t("installed"))
		end
	end

	finishPopulatingMenu("WindowTintMenu")

	local temporaryPlate = GetVehicleNumberPlateTextIndex(vehicle)
	createMenu("PlateIndexMenu", _t("plate_color"), _t("choose_type"))

	local plateTypes = {
		_t("plate_san_andreas_cosmo"),
		_t("plate_san_andreas_supermesh"),
		_t("plate_san_andreas_outsider"),
		_t("plate_san_andreas_slicer"),
		_t("plate_san_andreas_elquatro"),
		_t("plate_san_andreas_dubbed")
	}

	for i = 0,#plateTypes - 1 do
		populateMenu("PlateIndexMenu",i,plateTypes[i+1],"$1000")

		if temporaryPlate == i then
			updateItem2Text("PlateIndexMenu",i,_t("installed"))
		end
	end
	finishPopulatingMenu("PlateIndexMenu")

	local currentLivery = GetVehicleLivery(vehicle)
	local liveryCount = GetVehicleLiveryCount(vehicle)
	createMenu("PoliceLiveryMenu", _t("police_livery"), _t("choose_livery"))

	if liveryCount > 0 then
		for i = 0, liveryCount - 1 do
			populateMenu("PoliceLiveryMenu", i, _t("livery").." "..i, "$"..vehicleCustomisationPrices["policelivery"])

			if currentLivery == i then
				updateItem2Text("PoliceLiveryMenu", i, _t("installed"))
			end
		end
	end

	finishPopulatingMenu("PoliceLiveryMenu")

	createMenu("VehicleExtrasMenu",_t("vehicle_extras_customisation"),_t("toggle_extras"))

	for i = 1,12 do
		if DoesExtraExist(vehicle,i) then
			if IsVehicleExtraTurnedOn(vehicle,i) then
					populateMenu("VehicleExtrasMenu",i,_t("extra").." 0"..i,_t("enabled"))
			else
					populateMenu("VehicleExtrasMenu",i,_t("extra").." 0"..i,_t("disabled"))
			end
		end
	end

	finishPopulatingMenu("VehicleExtrasMenu")

	createMenu("NeonsMenu", _t("neon_customisation"), _t("choose_category"))

	for k,v in ipairs(vehicleNeonOptions["neonTypes"]) do
		populateMenu("NeonsMenu",v["id"],v["name"],"none")
	end

	populateMenu("NeonsMenu",-1,"Neon Colours",_t("choose_color"))
	finishPopulatingMenu("NeonsMenu")

	for k,v in ipairs(vehicleNeonOptions["neonTypes"]) do
		local currentNeonState = GetCurrentNeonState(v["id"])
		createMenu(v["name"]:gsub("%s+","").."Menu", _t("neon_customisation"), _t("toggle_neon"))

		populateMenu(v["name"]:gsub("%s+","").."Menu", 0, _t("disabled"), "$0")
		populateMenu(v["name"]:gsub("%s+","").."Menu", 1, _t("enabled"), "$"..vehicleCustomisationPrices["neonside"])

		updateItem2Text(v["name"]:gsub("%s+","").."Menu",currentNeonState,_t("installed"))

		finishPopulatingMenu(v["name"]:gsub("%s+","").."Menu")
	end

	local currentNeonR,currentNeonG,currentNeonB = GetCurrentNeonColour()
	createMenu("NeonColoursMenu", _t("neon_colors"), _t("choose_color"))

	for k,v in ipairs(vehicleNeonOptions["neonColours"]) do
		populateMenu("NeonColoursMenu",k,vehicleNeonOptions["neonColours"][k]["name"],"$"..vehicleCustomisationPrices["neoncolours"])

		if currentNeonR == vehicleNeonOptions["neonColours"][k]["r"] and currentNeonG == vehicleNeonOptions["neonColours"][k]["g"] and currentNeonB == vehicleNeonOptions["neonColours"][k]["b"] then
			updateItem2Text("NeonColoursMenu",k,_t("installed"))
		end
	end

	finishPopulatingMenu("NeonColoursMenu")

	createMenu("XenonsMenu", _t("xenon_customisation"), _t("choose_category"))

	populateMenu("XenonsMenu",0,"Headlights",_t("choose_color"))
	populateMenu("XenonsMenu",1,"Xenon Colours",_t("choose_color"))

	finishPopulatingMenu("XenonsMenu")

	local currentXenonState = GetCurrentXenonState()
	createMenu("HeadlightsMenu",_t("headlights_customisation"),_t("toggle_xenon"))

	populateMenu("HeadlightsMenu",0,_t("disabled"),"$0")
	populateMenu("HeadlightsMenu",1,_t("enabled"),"$"..vehicleCustomisationPrices["headlights"])

	updateItem2Text("HeadlightsMenu",currentXenonState,_t("installed"))

	finishPopulatingMenu("HeadlightsMenu")

	local currentXenonColour = GetCurrentXenonColour()
	createMenu("XenonColoursMenu", _t("xenon_colors"), _t("choose_color"))

	for k,v in ipairs(vehicleXenonOptions["xenonColours"]) do
		populateMenu("XenonColoursMenu",v["id"],v["name"],"$"..vehicleCustomisationPrices["xenoncolours"])

		if currentXenonColour == v["id"] then
			updateItem2Text("XenonColoursMenu",v["id"],_t("installed"))
		end
	end

	finishPopulatingMenu("XenonColoursMenu")
end

function DestroyMenus()
	destroyMenus()
	-- Resetar tipos de respray aplicados
	appliedResprayTypes = {}
end

function DisplayMenuContainer(state)
	toggleMenuContainer(state)
    TriggerEvent("help:open")
end

function DisplayMenu(state,menu)
	if state then
		currentMenu = menu
	end

	toggleMenu(state,menu)
	updateMenuHeading(menu)
	updateMenuSubheading(menu)
end

function MenuManager(state)
	if state then
		if currentMenuItem2 ~= _t("installed") then
			if isMenuActive("modMenu") then
				if currentCategory == 18 then
					if AttemptPurchase("turbo") then
						ApplyMod(currentCategory,currentMenuItemID)
						playSoundEffect("wrench",0.25)
						updateItem2Text(currentMenu,currentMenuItemID,_t("installed"))
						updateMenuStatus(_t("purchased"))
					else
						updateMenuStatus(_t("insufficient_funds"))
					end
				elseif currentCategory == 11 then
					if AttemptPurchase("engines",currentMenuItemID) then
						ApplyMod(currentCategory,currentMenuItemID)
						playSoundEffect("wrench",0.25)
						updateItem2Text(currentMenu,currentMenuItemID,_t("installed"))
						updateMenuStatus(_t("purchased"))
					else
						updateMenuStatus(_t("insufficient_funds"))
					end
				elseif currentCategory == 12 then
					if AttemptPurchase("brakes",currentMenuItemID) then
						ApplyMod(currentCategory,currentMenuItemID)
						playSoundEffect("wrench",0.25)
						updateItem2Text(currentMenu,currentMenuItemID,_t("installed"))
						updateMenuStatus(_t("purchased"))
					else
						updateMenuStatus(_t("insufficient_funds"))
					end
				elseif currentCategory == 13 then
					if AttemptPurchase("transmission",currentMenuItemID) then
						ApplyMod(currentCategory,currentMenuItemID)
						playSoundEffect("wrench",0.25)
						updateItem2Text(currentMenu,currentMenuItemID,_t("installed"))
						updateMenuStatus(_t("purchased"))
					else
						updateMenuStatus(_t("insufficient_funds"))
					end
				elseif currentCategory == 15 then
					if AttemptPurchase("suspension",currentMenuItemID) then
						ApplyMod(currentCategory,currentMenuItemID)
						playSoundEffect("wrench",0.25)
						updateItem2Text(currentMenu,currentMenuItemID,_t("installed"))
						updateMenuStatus(_t("purchased"))
					else
						updateMenuStatus(_t("insufficient_funds"))
					end
				elseif currentCategory == 16 then
					if AttemptPurchase("shield",currentMenuItemID) then
						ApplyMod(currentCategory,currentMenuItemID)
						playSoundEffect("wrench",0.25)
						updateItem2Text(currentMenu,currentMenuItemID,_t("installed"))
						updateMenuStatus(_t("purchased"))
					else
						updateMenuStatus(_t("insufficient_funds"))
					end
				else
					if AttemptPurchase("cosmetics") then
						ApplyMod(currentCategory,currentMenuItemID)
						playSoundEffect("wrench",0.25)
						updateItem2Text(currentMenu,currentMenuItemID,_t("installed"))
						updateMenuStatus(_t("purchased"))
					else
						updateMenuStatus(_t("insufficient_funds"))
					end
				end
			elseif isMenuActive("ResprayMenu") then
				if AttemptPurchase("respray") then
					ApplyColour(currentResprayCategory,currentResprayType,currentMenuItemID)
					playSoundEffect("respray",1.0)
					-- Armazenar qual tipo de respray foi aplicado para esta categoria
					appliedResprayTypes[currentResprayCategory] = currentResprayType
					updateItem2Text(currentMenu,currentMenuItemID,_t("installed"))
					updateMenuStatus(_t("purchased"))
				else
					updateMenuStatus(_t("insufficient_funds"))
				end
			elseif isMenuActive("WheelsMenu") then
				if currentWheelCategory == 20 then
					if AttemptPurchase("wheelsmoke") then
						local r = vehicleTyreSmokeOptions[currentMenuItemID]["r"]
						local g = vehicleTyreSmokeOptions[currentMenuItemID]["g"]
						local b = vehicleTyreSmokeOptions[currentMenuItemID]["b"]

						ApplyTyreSmoke(r,g,b)
						playSoundEffect("wrench",0.25)
						updateItem2Text(currentMenu,currentMenuItemID,_t("installed"))
						updateMenuStatus(_t("purchased"))
					else
						updateMenuStatus(_t("insufficient_funds"))
					end
				else
					if currentWheelCategory == -1 then
						local currentWheel = GetCurrentWheel()

						if currentWheel == -1 then
							updateMenuStatus(_t("stock_wheels_required"))
						else
							if AttemptPurchase("customwheels") then
								ApplyCustomWheel(currentMenuItemID)
								playSoundEffect("wrench",0.25)
								updateItem2Text(currentMenu,currentMenuItemID,_t("installed"))
								updateMenuStatus(_t("modifications_saved"))
							else
								updateMenuStatus(_t("purchase_failed"))
							end
						end
					else
						local currentWheel = GetCurrentWheel()
						local currentCustomWheelState = GetOriginalCustomWheel()

						if currentCustomWheelState and currentWheel == -1 then
							updateMenuStatus(_t("cant_apply_stock_wheels"))
						else
							if AttemptPurchase("wheels") then
								ApplyWheel(currentCategory,currentMenuItemID,currentWheelCategory)
									playSoundEffect("wrench",0.25)
									updateItem2Text(currentMenu,currentMenuItemID,_t("installed"))
									updateMenuStatus(_t("purchased"))
							else
								updateMenuStatus(_t("insufficient_funds"))
							end
						end
					end
				end
			elseif isMenuActive("NeonsSideMenu") then
				if AttemptPurchase("neonside") then
					playSoundEffect("wrench",0.25)
					ApplyNeon(currentNeonSide,currentMenuItemID)
					updateItem2Text(currentMenu,currentMenuItemID,_t("installed"))
					updateMenuStatus(_t("purchased"))
				else
					updateMenuStatus(_t("insufficient_funds"))
				end 
			else
				if currentMenu == "mainMenu" then
					currentMenu = currentMenuItem:gsub("%s+","").."Menu"
					currentCategory = currentMenuItemID

					toggleMenu(false,"mainMenu")
					toggleMenu(true,currentMenu)
					updateMenuHeading(currentMenu)
					updateMenuSubheading(currentMenu)
				elseif currentMenu == "ResprayMenu" then
					currentMenu = "ResprayTypeMenu"
					currentResprayCategory = currentMenuItemID

					toggleMenu(false,"ResprayMenu")
					toggleMenu(true,currentMenu)
					updateMenuHeading(currentMenu)
					updateMenuSubheading(currentMenu)
				elseif currentMenu == "ResprayTypeMenu" then
					currentMenu = currentMenuItem:gsub("%s+","").."Menu"
					currentResprayType = currentMenuItemID

					toggleMenu(false,"ResprayTypeMenu")
					toggleMenu(true,currentMenu)
					updateMenuHeading(currentMenu)
					updateMenuSubheading(currentMenu)
					
					
					local Ped = PlayerPedId()
					local vehicle = GetVehiclePedIsUsing(Ped)
					if vehicle and vehicle ~= 0 then
						local vehPrimaryColour,vehSecondaryColour = GetVehicleColours(vehicle)
						local vehPearlescentColour,vehWheelColour = GetVehicleExtraColours(vehicle)
						local vehDashColour = GetVehicleDashboardColour(vehicle)
						local vehInterColour = GetVehicleInteriorColour(vehicle)
						
						local currentColour = nil
						-- Verificar apenas a categoria atual selecionada
						if currentResprayCategory == 0 then
							currentColour = vehPrimaryColour
						elseif currentResprayCategory == 1 then
							currentColour = vehSecondaryColour
						elseif currentResprayCategory == 2 then
							currentColour = vehPearlescentColour
						elseif currentResprayCategory == 3 then
							currentColour = vehWheelColour
						elseif currentResprayCategory == 4 then
							currentColour = vehDashColour
						elseif currentResprayCategory == 5 then
							currentColour = vehInterColour
						end
						
						
						if currentColour then
							local colourExistsInThisType = false
							for k,v in ipairs(vehicleResprayOptions) do
								if v.id == currentResprayType then
									for m,n in ipairs(v["colours"]) do
										if n["id"] == currentColour then
											colourExistsInThisType = true
											break
										end
									end
									break
								end
							end
							
							
							if colourExistsInThisType and appliedResprayTypes[currentResprayCategory] == currentResprayType then
								updateItem2Text(currentMenu,currentColour,_t("installed"))
							end
						end
					end
				elseif currentMenu == "WheelsMenu" then
					local currentWheel,currentWheelName,currentWheelType = GetCurrentWheel()

					currentMenu = currentMenuItem:gsub("%s+","").."Menu"
					currentWheelCategory = currentMenuItemID

					if currentWheelType == currentWheelCategory then
						updateItem2Text(currentMenu,currentWheel,_t("installed"))
					end

					toggleMenu(false,"WheelsMenu")
					toggleMenu(true,currentMenu)
					updateMenuHeading(currentMenu)
					updateMenuSubheading(currentMenu)
				elseif currentMenu == "NeonsMenu" then
					currentMenu = currentMenuItem:gsub("%s+","").."Menu"
					currentNeonSide = currentMenuItemID

					toggleMenu(false,"NeonsMenu")
					toggleMenu(true,currentMenu)
					updateMenuHeading(currentMenu)
					updateMenuSubheading(currentMenu)
				elseif currentMenu == "XenonsMenu" then
					currentMenu = currentMenuItem:gsub("%s+","").."Menu"

					toggleMenu(false,"XenonsMenu")
					toggleMenu(true,currentMenu)
					updateMenuHeading(currentMenu)
					updateMenuSubheading(currentMenu)
				elseif currentMenu == "WindowTintMenu" then
					if AttemptPurchase("windowtint") then
						ApplyWindowTint(currentMenuItemID)
						playSoundEffect("respray",1.0)
						updateItem2Text(currentMenu,currentMenuItemID,_t("installed"))
						updateMenuStatus(_t("purchased"))
					else
						updateMenuStatus(_t("insufficient_funds"))
					end
				elseif currentMenu == "NeonColoursMenu" then
					if AttemptPurchase("neoncolours") then
						local r = vehicleNeonOptions["neonColours"][currentMenuItemID]["r"]
						local g = vehicleNeonOptions["neonColours"][currentMenuItemID]["g"]
						local b = vehicleNeonOptions["neonColours"][currentMenuItemID]["b"]

						ApplyNeonColour(r,g,b)
						playSoundEffect("respray",1.0)
						updateItem2Text(currentMenu,currentMenuItemID,_t("installed"))
						updateMenuStatus(_t("purchased"))
					else
						updateMenuStatus(_t("insufficient_funds"))
					end
				elseif currentMenu == "HeadlightsMenu" then
					if AttemptPurchase("headlights") then
						ApplyXenonLights(currentCategory,currentMenuItemID)
						playSoundEffect("wrench",0.25)
						updateItem2Text(currentMenu,currentMenuItemID,_t("installed"))
						updateMenuStatus(_t("purchased"))
					else
						updateMenuStatus(_t("insufficient_funds"))
					end
				elseif currentMenu == "XenonColoursMenu" then
					if AttemptPurchase("xenoncolours") then
						ApplyXenonColour(currentMenuItemID)
						playSoundEffect("respray",1.0)
						updateItem2Text(currentMenu,currentMenuItemID,_t("installed"))
						updateMenuStatus(_t("purchased"))
					else
						updateMenuStatus(_t("insufficient_funds"))
					end
				elseif currentMenu == "PoliceLiveryMenu" then
					if AttemptPurchase("policelivery") then
						ApplyPoliceLivery(currentMenuItemID)
						playSoundEffect("wrench",0.25)
						updateItem2Text(currentMenu,currentMenuItemID,_t("installed"))
						updateMenuStatus(_t("purchased"))
					else
						updateMenuStatus(_t("insufficient_funds"))   
					end
				elseif currentMenu == "PlateIndexMenu" then
					if AttemptPurchase("plateindex") then
						ApplyPlateIndex(currentMenuItemID)
						playSoundEffect("wrench",0.25)
						updateItem2Text(currentMenu,currentMenuItemID,_t("installed"))
						updateMenuStatus(_t("purchased"))
					else
						updateMenuStatus(_t("insufficient_funds"))
					end
				elseif currentMenu == "VehicleExtrasMenu" then
					ApplyExtra(currentMenuItemID)
					playSoundEffect("wrench",0.25)

					local Ped = PlayerPedId()
					local vehicle = GetVehiclePedIsUsing(Ped)
					if IsVehicleExtraTurnedOn(vehicle,currentMenuItemID) then
						updateItem2TextOnly(currentMenu,currentMenuItemID,_t("enabled"))
						updateMenuStatus(_t("extra_activated"))
					else
						updateItem2TextOnly(currentMenu,currentMenuItemID,_t("disabled"))
						updateMenuStatus(_t("extra_deactivated"))
					end
				end
			end
		else
			if currentMenu == "VehicleExtrasMenu" then
				ApplyExtra(currentMenuItemID)
					playSoundEffect("wrench",0.25)

				local Ped = PlayerPedId()
				local vehicle = GetVehiclePedIsUsing(Ped)
				if IsVehicleExtraTurnedOn(vehicle,currentMenuItemID) then
					updateItem2TextOnly(currentMenu,currentMenuItemID,_t("enabled"))
					updateMenuStatus(_t("extra_activated"))
				else
					updateItem2TextOnly(currentMenu,currentMenuItemID,_t("disabled"))
					updateMenuStatus(_t("extra_deactivated"))
				end
			end
		end
	else
		updateMenuStatus("")

		if isMenuActive("modMenu") then
			toggleMenu(false,currentMenu)

			currentMenu = "mainMenu"

			if currentCategory ~= 18 then
				RestoreOriginalMod()
			end

			toggleMenu(true,currentMenu)
			updateMenuHeading(currentMenu)
			updateMenuSubheading(currentMenu)
		elseif isMenuActive("ResprayMenu") then
			toggleMenu(false,currentMenu)

			currentMenu = "ResprayTypeMenu"

			RestoreOriginalColours()

			toggleMenu(true,currentMenu)
			updateMenuHeading(currentMenu)
			updateMenuSubheading(currentMenu)
		elseif isMenuActive("WheelsMenu") then            
			if currentWheelCategory ~= 20 and currentWheelCategory ~= -1 then
				local currentWheel = GetOriginalWheel()

				updateItem2Text(currentMenu,currentWheel,"$"..vehicleCustomisationPrices["wheels"])

				RestoreOriginalWheels()
			end

			toggleMenu(false,currentMenu)

			currentMenu = "WheelsMenu"

			toggleMenu(true,currentMenu)
			updateMenuHeading(currentMenu)
			updateMenuSubheading(currentMenu)
		elseif isMenuActive("NeonsSideMenu") then
			toggleMenu(false,currentMenu)

			currentMenu = "NeonsMenu"

			RestoreOriginalNeonStates()

			toggleMenu(true,currentMenu)
			updateMenuHeading(currentMenu)
			updateMenuSubheading(currentMenu)
		else
			if currentMenu == "mainMenu" then
				ExitBennys()
			elseif currentMenu == "ResprayMenu" or currentMenu == "WindowTintMenu" or currentMenu == "WheelsMenu" or currentMenu == "NeonsMenu" or currentMenu == "XenonsMenu" or currentMenu == "PoliceLiveryMenu" or currentMenu == "PlateIndexMenu" or currentMenu == "VehicleExtrasMenu" then
				toggleMenu(false,currentMenu)

				if currentMenu == "WindowTintMenu" then
					RestoreOriginalWindowTint()
				end

				if currentMenu == "PoliceLiveryMenu" then
					RestorePoliceLivery()
				end

				if currentMenu == "PlateIndexMenu" then
					RestorePlateIndex()
				end

				currentMenu = "mainMenu"

				toggleMenu(true,currentMenu)
				updateMenuHeading(currentMenu)
				updateMenuSubheading(currentMenu)
			elseif currentMenu == "ResprayTypeMenu" then
				toggleMenu(false,currentMenu)

				currentMenu = "ResprayMenu"
				currentResprayType = nil

				toggleMenu(true,currentMenu)
				updateMenuHeading(currentMenu)
				updateMenuSubheading(currentMenu)
			elseif currentMenu == "NeonColoursMenu" then
				toggleMenu(false,currentMenu)

				currentMenu = "NeonsMenu"

				RestoreOriginalNeonColours()

				toggleMenu(true,currentMenu)
				updateMenuHeading(currentMenu)
				updateMenuSubheading(currentMenu)
			elseif currentMenu == "HeadlightsMenu" then
				toggleMenu(false,currentMenu)

				currentMenu = "XenonsMenu"

				toggleMenu(true,currentMenu)
				updateMenuHeading(currentMenu)
				updateMenuSubheading(currentMenu)
			elseif currentMenu == "XenonColoursMenu" then
				toggleMenu(false,currentMenu)

				currentMenu = "XenonsMenu"

				RestoreOriginalXenonColour()

				toggleMenu(true,currentMenu)
				updateMenuHeading(currentMenu)
				updateMenuSubheading(currentMenu)
			end
		end
	end
end

function MenuScrollFunctionality(direction)
	scrollMenuFunctionality(direction,currentMenu)
end

RegisterNUICallback("selectedItem",function(Data,Callback)
	updateCurrentMenuItemID(tonumber(Data["id"]),Data["item"],Data["item2"])

	Callback("Ok")
end)

RegisterNUICallback("updateItem2",function(Data,Callback)
	currentMenuItem2 = Data["item"]

	Callback("Ok")
end)

local vehicleWheelCategories = {
    {
        category = _t("sport_wheels"),
        id = 0
    },
    {
        category = _t("muscle_wheels"),
        id = 1
    },
    {
        category = _t("lowrider_wheels"),
        id = 2
    },
    {
        category = _t("suv_wheels"),
        id = 3
    },
    {
        category = _t("offroad_wheels"),
        id = 4
    },
    {
        category = _t("tuner_wheels"),
        id = 5
    },
    {
        category = _t("super_wheels"),
        id = 7
    },
    {
        category = _t("high_end_wheels"),
        id = 7
    }
}

local vehicleResprayCategories = {
    {
        category = _t("primary_color"),
        id = 1
    },
    {
        category = _t("secondary_color"),
        id = 2
    },
    {
        category = _t("pearl_color"),
        id = 3
    },
    {
        category = _t("wheel_color"),
        id = 4
    },
    {
        category = _t("dashboard_color"),
        id = 5
    },
    {
        category = _t("interior_color"),
        id = 6
    }
}

local vehicleResprayTypes = {
    {
        category = _t("metallic"),
        id = 1
    },
    {
        category = _t("matte"),
        id = 2
    },
    {
        category = _t("metals"),
        id = 3
    }
}