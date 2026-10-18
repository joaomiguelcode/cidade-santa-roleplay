-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
local vSERVER = Tunnel.getInterface("inventory/properties")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Init = ""
local Blips = {}
local Chest = ""
local Theft = nil
local Interior = ""
lang = GetConvar("language", "pt-br") or "pt-br"

---@type table<string, string>
local VOUCHER_LINKS_BY_CITIES = {
    ["Santa"] = "https://loja.cidadesantarp.com/category/vouchers?currency=BRL",
    ["CidadeNobre"] = "https://loja.cidadenobre.com/category/vouchers?currency=BRL",
    ["Universo"] = "https://loja.universoroleplay.com/category/vouchers?currency=BRL",
    ["Maresia"] = "https://loja.maresiarp.com/category/vouchers?currency=BRL",
    ["Alexandria"] = "https://loja.alexandriarp.com/category/vouchers",
    ["Malta"] = "https://loja.maltarp.com/category/vouchers?currency=EUR",
    ["Grande"] = "https://loja.cidadegrande.com/category/vouchers?currency=BRL",
    ["Fronteira"] = "https://loja.fronteirarp.com.br/category/vouchers?currency=BRL",
    ["Real"] = "https://tienda.realrp.es/category/vouchers?currency=EUR",
    ["Prime"] = "https://tienda.primerp.gg/category/vales?currency=EUR",
    ["Kingdom"] = "https://kngestate.tebex.io/category/vouchers?currency=GBP",
    ["Imperium"] = "https://store.imperium.com/category/vouchers?currency=BRL",
    ["GoatRP"] = "https://boutique.goatrp.gg/category/vouchers",
    ["Boomerang"] = "https://storee.boomerangroleplay.com/category/vouchers?currency=AUD",
    ["Royal"] = "https://storee.royalukrp.com/category/vouchers?currency=GBP",
    ["District99"] = "https://store.district99.gg/category/vouchers?currency=USD",
    ["Krown"] = "https://store.krownrp.com/category/vouchers?currency=USD",
    ["Orizon"] = "https://orizon-webstore.tebex.io/category/القسائم-الإلكتروني",
    ["Liberty99"] = "https://store.liberty99rp.com/category/vouchers?currency=USD",
}

local function GetVoucherLink()
    return VOUCHER_LINKS_BY_CITIES[cityName]
end

RegisterNetEvent("propertys:OpenVoucherStore")
AddEventHandler("propertys:OpenVoucherStore", function()
    local voucherLink = GetVoucherLink()
    if not voucherLink then
        return
    end

    TriggerEvent("dynamic:OpenUrl", voucherLink)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		local Ped = PlayerPedId()
		if not IsPedInAnyVehicle(Ped) then
			local Coords = GetEntityCoords(Ped)

			if Init ~= "" then
				if Interiors[Interior] and Interiors[Interior]["Exit"] then
                    InitName = Init
                    if CheckAppartment(Init) then
                        local Split = splitString(Init, "|")
                        InitName = Split[1]
                    end

					SetPlayerBlipPositionThisFrame(Propertys[InitName]["coords"]["x"], Propertys[InitName]["coords"]["y"])

					if Coords["z"] < (Interiors[Interior]["Exit"]["z"] - 25.0) then
						SetEntityCoords(Ped, Interiors[Interior]["Exit"], false, false, false, false)
                        FreezeEntityPosition(Ped, true)
                        Wait(5000)
                        FreezeEntityPosition(Ped, false)
					end

					if Theft and Robbery[Interior]["Furniture"] then
						for Index, v in pairs(Robbery[Interior]["Furniture"]) do
							if #(Coords - v) <= 2.2 then
								TimeDistance = 1
								DrawText(v["x"], v["y"], v["z"], "~g~E~w~  " .. _t("rob"))

								if #(Coords - v) <= 1.0 and IsControlJustPressed(1,38) and vSERVER.Robbery(Init, Index) then
									if exports["hovers"]:Task(5, 5000) then
										vSERVER.Paybbery(Init, Index)
									end
									TriggerEvent("vrp:removeObjects")
								end
							end
						end

						if Theft < GetGameTimer() and GetEntitySpeed(Ped) > 2 then
							Theft = GetGameTimer() + 60000
							vSERVER.Police(Propertys[Init]["coords"])
						end
					end

					for Line, v in pairs(Interiors[Interior]) do
						if #(Coords - v) <= 0.75 then
							TimeDistance = 1

							if Line == "Exit" and IsControlJustPressed(1,38) then
                                SetEntityCoords(Ped, Propertys[InitName]["coords"], false, false, false, false)
                                FreezeEntityPosition(Ped, true)
                                Wait(5000)
                                FreezeEntityPosition(Ped, false)
                                vSERVER.Toggle(Init, "Exit")
                                LocalPlayer["state"]["Home"] = false
                                Interior = ""
                                Theft = nil
                                Chest = ""
                                Init = ""
							elseif not Theft and (Line == "Vault" or Line == "Fridge") and IsControlJustPressed(1,38) then
                                if LocalPlayer["state"]["PVP"] then
                                    return
                                end
								Chest = Line
								toggleInventory("property")
							elseif not Theft and Line == "Clothes" and IsControlJustPressed(1,38) then
								ClothesMenu()
							end
						end
					end
				end
			end
		end

		Wait(TimeDistance)
	end

end)


AddEventHandler('onResourceStart', function(resource)
    Wait(1500)
    if resource == "sleepless_interact" then
        StartPropertiesInteraction()
    end

    if resource == GetCurrentResourceName() then
        StartPropertiesInteraction()
    end
end)

AddEventHandler('playerSpawned', function(resource)
    StartPropertiesInteraction()
end)

function StartPropertiesInteraction()
    for Name,v in pairs(Propertys) do
        interact.addCoords({
            id = "properties:"..tostring(Name),
            coords = v["coords"],
            options = {
                {
                    label = _t("openProperties"),
                    icon = "home",
                    onSelect = function(data)
                        if CheckAppartment(Name) then
                            exports["dynamic"]:AddButton(_t("enter_apartment"), _t("enter_apartment"), "propertys:EnterAppartment", Name, false, false)
                            exports["dynamic"]:AddButton(_t("buy_apartment"), _t("buy_apartment"), "propertys:BuyAppartment", Name, false, false)
                            exports["dynamic"]:openMenu()
                        else
                            local Consult = vSERVER.Propertys(Name)
                            if not Consult then
                                if not LocalPlayer["state"]["Home"] then
                                    if not vSERVER.HasOwner(Name) then
                                        exports["dynamic"]:AddButton(_t("buy_house"), _t("buy_house"), "propertys:BuyHouse", Name, false, false)
                                        exports["dynamic"]:openMenu()
                                    else
                                        TriggerEvent("Notify2","#propOwned",{msg=_t("property_owned")})
                                    end
                                end
                            else
                                Interior = Consult["Interior"]
                
                                if string.sub(Name, 1, 9) == "Propertys" then
                                    exports["dynamic"]:AddButton(_t("enter_property"), _t("enter_property"), "propertys:Enter", Name, false, false)
                                    exports["dynamic"]:AddButton(_t("configure_credentials"), _t("configure_credentials"), "propertys:Credentials", Name, false, true)
                                    exports["dynamic"]:AddButton(_t("lock_unlock"), _t("lock_unlock"), "propertys:Lock", Name, false, true)
                                    exports["dynamic"]:AddButton(_t("mortgage"), _t("next_payment") .. Consult["Tax"], "", "", false, false)
                                    local renewalLabel = cityName == "Santa" and _t("renew_with_voucher") or _t("advance_mortgage")
                                    exports["dynamic"]:AddButton(renewalLabel, renewalLabel, "propertys:updateTax", Name, false, true)
                                    exports["dynamic"]:AddButton(_t("sell_property"), _t("sell_property"), "propertys:Sell", Name, false, true)
                                    exports["dynamic"]:openMenu()
                                else
                                    TriggerEvent("propertys:Enter", Name)
                                end
                            end
                        end
                    end,
                    canInteract = function(entity, distance, coords, id)
                        return not LocalPlayer["state"]["minigame:active"]
                    end
                },
                {
                    label = _t("robProperty"),
                    icon = "exclamation-triangle",
                    onSelect = function(data)
                        exports["houserobbery"]:open(Name)
                    end,
                    canInteract = function(entity, distance, coords, id)
                        return not LocalPlayer["state"]["minigame:active"]
                    end
                }
            
            },
            renderDistance = 25.0,
            activeDistance = 1.5,
            cooldown = 1500
        })
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOTHESMENU
-----------------------------------------------------------------------------------------------------------------------------------------
function ClothesMenu()
	exports["dynamic"]:AddButton(_t("save_outfit"), _t("save_outfit"), "propertys:Clothes", "save", false, true)
	exports["dynamic"]:AddButton(_t("open_clothing_store"), _t("open_clothing_store"), "skinshop:Open", "", false, false)
	exports["dynamic"]:SubMenu(_t("apply_outfit"), _t("apply_outfit"), "apply")
	exports["dynamic"]:SubMenu(_t("remove_outfit"), _t("remove_outfit"), "delete")

	local Clothes = vSERVER.Clothes()
	if parseInt(#Clothes) > 0 then
		for _, v in pairs(Clothes) do
			exports["dynamic"]:AddButton(v["name"], _t("wear_outfit"), "propertys:Clothes", "apply-" .. v["name"], "apply", true)
			exports["dynamic"]:AddButton(v["name"], _t("delete_outfit"), "propertys:Clothes", "delete-" .. v["name"], "delete", true)
		end
	end

	exports["dynamic"]:openMenu()
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:CLOTHESRESET
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("propertys:ClothesReset")
AddEventHandler("propertys:ClothesReset",function()
	TriggerEvent("dynamic:closeSystem")
	ClothesMenu()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:ENTER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("propertys:ForceExit")
AddEventHandler("propertys:ForceExit", function()
	Init = ""
	Interior = ""
	Chest = ""
	Theft = nil
	LocalPlayer["state"]["Home"] = false
end)

RegisterNetEvent("propertys:Enter")
AddEventHandler("propertys:Enter",function(Name,Thefting,Frenter)
    if LocalPlayer["state"]["PVP"] then
        return
    end
    if GlobalState["Restarting"] then
        --TriggerEvent("Notify","vermelho","Servidor em reinicialização, aguarde.",8000)
        TriggerEvent("Notify2","#reiniciaServ")
        return false
    end
    -- print("Thefting: "..tostring(Thefting))
    if CheckAppartment(Name) then
        local HaveInterior =  vSERVER.GetAppartmentInterior(Name)
        Interior = HaveInterior
        if not Thefting then
            local Consult = vSERVER.Propertys(Name)
            if not Consult then
                return
            end
        end
    end
	if Thefting then
		Theft = GetGameTimer() + 10000
		Interior = Thefting
	end
    if not Interior or Interior == "" then
        local Consult = vSERVER.Propertys(Name)
        if not Consult then
            return
        else
            Interior = Consult["Interior"]
        end
    end
    LocalPlayer["state"]["Home"] = true
	Init = Name
	local Ped = PlayerPedId()
	vSERVER.Toggle(Init,"Enter")
	TriggerEvent("dynamic:closeSystem")
    -- print("Interior: "..tostring(Interior))
	SetEntityCoords(Ped,Interiors[Interior]["Exit"],false,false,false,false)
    FreezeEntityPosition(Ped,true)
    Wait(5000)
    FreezeEntityPosition(Ped,false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUEST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestProperty",function(Data,Callback)
	local items,chestPeso,chestMaxpeso = vSERVER.OpenChest(Init,Chest)
	if not items then
		return
	end
	Callback({ items = items, type = "property", weight = {
		current = chestPeso,
		max = chestMaxpeso
	}})
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("inventory:CloseAll",function()
	TriggerEvent("inventory:Close")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("pickupSlotProperty",function(Data,Callback)
	vSERVER.Take(Data["slot"],Data["amount"],Data["target"],Init,Chest)

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STORE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("dropSlotProperty",function(Data,Callback)
	vSERVER.Store(Data["item"],Data["slot"],Data["amount"],Data["target"],Init,Chest)

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("updateSlotProperty",function(Data,Callback)
	vSERVER.Update(Data["slot"],Data["target"],Data["amount"],Init,Chest)

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STORE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestUpgradeProperty",function(Data,Callback)
	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("propertys:Update")
AddEventHandler("propertys:Update",function()
	SendNUIMessage({ action = "updateInventory" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:WEIGHT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("propertys:Weight")
AddEventHandler("propertys:Weight",function(InvPeso,InvMax,ChestPeso,ChestMax)
	SendNUIMessage({ action = "updateInventory" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	local Tables = {}
	-- for _,v in pairs(Propertys) do
	-- 	Tables[#Tables + 1] = { v["coords"]["x"],v["coords"]["y"],v["coords"]["z"],0.75,"E",_t("property"),_t("pressToAccess") }
	-- end

	for _,Intern in pairs(Interiors) do
		for Line,v in pairs(Intern) do
			local Message = _t("exit")

			if Line == "Vault" then
				Message = _t("vault")
			elseif Line == "Fridge" then
				Message = _t("fridge")
			elseif Line == "Clothes" then
				Message = _t("clothes")
			end

			Tables[#Tables + 1] = { v["x"],v["y"],v["z"],0.75,"E",Message,_t("pressToAccess") }
		end
	end

	TriggerEvent("hoverfy:Insert",Tables)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CASAS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommandLocalized("command.houses",function(source,args)
    TriggerEvent("propertys:Blips")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:BLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("propertys:Blips")
AddEventHandler("propertys:Blips",function()
    local Markers = vSERVER.GetMarkers()
	if json.encode(Blips) ~= "[]" then
		for _,v in pairs(Blips) do
			if DoesBlipExist(v) then
				RemoveBlip(v)
			end
		end

		Blips = {}

		--TriggerEvent("Notify","verde","Marcações desativadas.",10000)
		TriggerEvent("Notify2","#marcacaoDesativada")

	else
		for Name,v in pairs(Propertys) do
			Blips[Name] = AddBlipForCoord(v["coords"]["x"],v["coords"]["y"],v["coords"]["z"])
			SetBlipSprite(Blips[Name],374)
			SetBlipAsShortRange(Blips[Name],true)
			SetBlipColour(Blips[Name],Markers[Name] and 35 or 43)
			SetBlipScale(Blips[Name],0.4)
		end

		--TriggerEvent("Notify","verde","Marcações ativadas.",10000)
		TriggerEvent("Notify2","#marcacaoAtivada")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAWTEXT3D
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText(x,y,z,Message)
	local onScreen,_x,_y = GetScreenCoordFromWorldCoord(x,y,z)

	if onScreen then
		BeginTextCommandDisplayText("STRING")
		AddTextComponentSubstringKeyboardDisplay(Message)
		SetTextColour(255,255,255,150)
		SetTextScale(0.35,0.35)
		SetTextFont(4)
		SetTextCentre(1)
		EndTextCommandDisplayText(_x,_y)

		local width = string.len(Message) / 160 * 0.45
		DrawRect(_x,_y + 0.0125,width,0.03,15,15,15,175)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:HOMEBLIPS
-----------------------------------------------------------------------------------------------------------------------------------------

---@param property unknown
local function CreateOwnedPropertyMapBlip( property )

    local propertyCoords = property.coords

    --- Essa verificação é necessaria?
    if not propertyCoords or not propertyCoords.x then
        return
    end

    local blipId = AddBlipForCoord( propertyCoords.x, propertyCoords.y, propertyCoords.z )
    SetBlipSprite(blipId,374)
    SetBlipDisplay(blipId,4)
    SetBlipAsShortRange(blipId,true)
    SetBlipColour(blipId,3)
    SetBlipScale(blipId,0.8)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(_t("my_property"))
    EndTextCommandSetBlipName(blipId)
end

---@param ownedPropertiesNames string[]
RegisterNetEvent('net:inventory:properties:ownedPropertiesLoaded', function( ownedPropertiesNames )

    for _, ownedPropertyName in ipairs( ownedPropertiesNames ) do

        local property = Propertys[ ownedPropertyName ]

        CreateOwnedPropertyMapBlip( property )
    end

    -- TODO: Caso queira enviar informações para outros scripts no client.
    -- TriggerEvent( 'inventory:properties:ownedPropertiesLoaded', propertiesNames )
end)

RegisterNetEvent("propertys:EnterAppartment")
AddEventHandler("propertys:EnterAppartment", function(Name)
    local Appartments = vSERVER.GetAppartments(Name)
    TriggerEvent("dynamic:closeSystem")
    if not Appartments then
        return
    end
    Wait(100)
    for i = 1, Appartments do
        local Appartment = Name .. "|" .. i
        exports["dynamic"]:SubMenu(_t("apartment") .. " " .. i, _t("select_apartment"), i)
        exports["dynamic"]:AddButton(_t("enter_property"), _t("enter_property"), "propertys:Enter", Appartment, i, false)
        exports["dynamic"]:AddButton(_t("configure_credentials"), _t("configure_credentials"), "propertys:Credentials", Appartment, i, true)
        local renewalLabel = cityName == "Santa" and _t("renew_with_voucher") or _t("advance_mortgage")
        exports["dynamic"]:AddButton(renewalLabel, renewalLabel, "propertys:updateTax", Appartment, i, true)
        exports["dynamic"]:AddButton(_t("lock_unlock"), _t("lock_unlock"), "propertys:Lock", Appartment, i, true)
        exports["dynamic"]:AddButton(_t("sell_property"), _t("sell_property"), "propertys:Sell", Appartment, i, true)
    end
    exports["dynamic"]:openMenu()
end)

RegisterNetEvent("propertys:BuyAppartment")
AddEventHandler("propertys:BuyAppartment", function(Name)
    TriggerEvent("dynamic:closeSystem")
    Wait(250)
    local Table = {}
    exports["dynamic"]:SubMenu(_t("choose_interior"), "", "Interiores")
    local keyToSortBy = "Price"
    if cityName ~= "Santa" and Gemstone[Name] then
        keyToSortBy = "Gemstone"
    end
    
    local sortedKeys = sortInformations(Informations, keyToSortBy)

    
    for _, Line in ipairs(sortedKeys) do
        local v = Informations[Line]
        exports["dynamic"]:AddButton(_t("buy"), _t("acquire_property"), "propertys:Buy", Name .. "-" .. Line, Line, true)
        exports["dynamic"]:AddButton(_t("visit"), _t("visit_interior"), "propertys:Interiors", Line, Line, false)

        local Level = tostring(Propertys[Name]["level"] or 1)
        local PriceAmount = v["Price"] + Levels[Level]["Price"]

        local Price = ""
        if cityName == "Santa" then
            exports["dynamic"]:AddButton(_t("price"), _t("price") .. " 🎫 1 voucher", "", "", Line, false)
            Price = "🎫 <yellow>1</yellow>"
        elseif Gemstone[Name] then
            exports["dynamic"]:AddButton(_t("price"), _t("price") .. parseFormat(v["Gemstone"]) .. " " .. _t("diamonds"), "", "", Line, false)
            Price = "💎 <yellow> " .. nonSpecifiedFormatter(v["Gemstone"]) .. "</yellow>"
        else
            exports["dynamic"]:AddButton(_t("price"), _t("price") .. "$" .. parseFormat(PriceAmount) .. " " .. _t("dollars"), "", "", Line, false)
            Price = "💲 <yellow> " .. nonSpecifiedFormatter(PriceAmount) .. "</yellow> "
        end

        exports["dynamic"]:AddButton(_t("compartment"), _t("compartment") .. v["Vault"] .. "Kg " .. _t("vault") .. " " .. v["Fridge"] .. "Kg " .. _t("fridge"), "", "", Line, false)
        exports["dynamic"]:SubMenu(Line .. " | " .. Price, _t("vault_size") .. v["Vault"] .. "Kgs.", Line)
    end
    exports["dynamic"]:openMenu()
end)

function sortInformations(infos, keyToSortBy)
    local keys = {}

    -- Extract the keys from the dictionary.
    for key in pairs(infos) do
        table.insert(keys, key)
    end

    -- Sort the keys based on the values they point to in the dictionary.
    table.sort(keys, function(a, b)
        return infos[a][keyToSortBy] < infos[b][keyToSortBy]
    end)

    return keys
end

-- for debug 
-- Gemstone['Propertys1043'] = true


---@alias CHOICE_METHOD_PAYMENT_TYPE 'gems' | 'voucher'

---@param priceGems number
---@param userDiamonds number
---@param voucher number
---@return CHOICE_METHOD_PAYMENT_TYPE
function ChoiceMethodPayment(priceGems, userDiamonds, voucher)
    if userDiamonds >= priceGems then
        return 'gems'
    end
    return 'voucher'
end

local FORMAT_HAS_ITEM = 'voucher_property_%s'
RegisterNetEvent("propertys:BuyHouse")
AddEventHandler("propertys:BuyHouse", function(Name)
    TriggerEvent("dynamic:closeSystem")
    Wait(250)
    local Table = {}
    exports["dynamic"]:SubMenu(_t("choose_interior"), "", "Interiores")

    local keyToSortBy = "Price"
    if cityName ~= "Santa" and Gemstone[Name] then
        keyToSortBy = "Gemstone"
    end
    
    local sortedKeys = sortInformations(Informations, keyToSortBy)
    local userDiamonds = cityName == "Santa" and 0 or vSERVER.CheckDiamondsAvailable()
    local userItems = cityName == "Santa" and {} or vSERVER.GetUpgradeHomesItemsAvailable()

    for _, Line in ipairs(sortedKeys) do
        local v = Informations[Line]

        exports["dynamic"]:AddButton(_t("buy"), _t("acquire_property"), "propertys:Buy", Name .. "-" .. Line, Line, true)
        exports["dynamic"]:AddButton(_t("visit"), _t("visit_interior"), "propertys:Interiors", Line, Line, false)

        local Level = tostring(Propertys[Name]["level"] or 1)
        local PriceAmount = v["Price"] + Levels[Level]["Price"]
        local Price = ""
        if cityName == "Santa" then
            exports["dynamic"]:AddButton(_t("price"), _t("price") .. " 🎫 1 voucher", "", "", Line, false)
            Price = "🎫 <yellow>1</yellow>"
        elseif Gemstone[Name] then
            local priceGems = v["Gemstone"]
            local voucher = userItems[FORMAT_HAS_ITEM:format(Line:lower())] or 0
            local method = ChoiceMethodPayment(priceGems, userDiamonds, voucher)

            if method == 'gems' then
                exports["dynamic"]:AddButton(_t("price"), _t("price") .. ' 💎 ' .. parseFormat(priceGems) .. " " .. _t("diamonds"), "", "", Line, false)
                Price = "💎 <yellow> " .. nonSpecifiedFormatter(priceGems) .. "</yellow>"
            end

            if method == 'voucher' then
                exports["dynamic"]:AddButton(_t("price"), _t("price") .. ' 🎫 ' ..parseFormat(1) .. " " .. 'voucher', "", "", Line, false)
                Price = "🎫 <yellow> " .. nonSpecifiedFormatter(1) .. "</yellow>"
            end
        else
            exports["dynamic"]:AddButton(_t("price"), _t("price") .. ' 🎫 ' ..parseFormat(1) .. " " .. 'voucher', "", "", Line, false)
            Price = "🎫 <yellow> " .. nonSpecifiedFormatter(1) .. "</yellow>"
            -- exports["dynamic"]:AddButton(_t("price"), _t("price") .. ' 💲 ' .. parseFormat(PriceAmount) .. " " .. _t("dollars"), "", "", Line, false)
            -- Price = "💲 <yellow> " .. nonSpecifiedFormatter(PriceAmount) .. "</yellow> "
        end


        exports["dynamic"]:AddButton(_t("compartment"), _t("compartment") .. v["Vault"] .. "Kg " .. _t("vault") .. " " .. v["Fridge"] .. "Kg " .. _t("fridge"), "", "", Line, false)
        exports["dynamic"]:SubMenu(Line .. " | " .. Price, _t("vault_size") .. v["Vault"] .. "Kgs.", Line)
    end
    exports["dynamic"]:openMenu()
end)

local NearHome = false
local Start = {}
CreateThread(function()
    for Name,v in pairs(Propertys) do
        Start[#Start + 1] = vector3(v["coords"]["x"],v["coords"]["y"],v["coords"]["z"])
    end
    while true do
        local Idle = 1000
        if not InJob then
            local Ped = PlayerPedId()
            local Coords = GetEntityCoords(Ped)
            local Near = 100
            for i=1,#Start do
                local Start = vector3(Start[i]["x"],Start[i]["y"],Start[i]["z"])
                local Distance = #(Coords - Start)
                if Distance < Near then
                    Near = Distance
                    NearHome = i
                end
            end
        end
        Wait(Idle)
    end
end)

-- CreateThread(function()
--     while true do
--         local Idle = 1000
--         if NearHome then
--             local Ped = PlayerPedId()
--             local Coords = GetEntityCoords(Ped)
--             local Start = vector3(Start[NearHome]["x"],Start[NearHome]["y"],Start[NearHome]["z"])
--             local Distance = #(Coords - Start)
--             if Distance < 30.0 then
--                 Idle = 5
--                 DrawMarker(20, Start.x, Start.y, Start.z - 0.50, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0,THEME.rgb.r, THEME.rgb.g, THEME.rgb.b, 100, 0, 0, 0, 1)
--             end
--         end
--         Wait(Idle)
--     end
-- end)

local OldCoords = false

RegisterNetEvent("propertys:Interiors")
AddEventHandler("propertys:Interiors",function(Interior)
    local Ped = PlayerPedId()
    TriggerEvent("dynamic:closeSystem")
    local Coords = GetEntityCoords(Ped)
    local InsideInterior = true
    OldCoords = Coords
	SetEntityCoords(Ped,Interiors[Interior]["Exit"],false,false,false,false)
    FreezeEntityPosition(Ped,true)
    Wait(5000)
    FreezeEntityPosition(Ped,false)
    TriggerEvent("Notify:Text", _t("exit_visitation"))
    while InsideInterior do
        local Idle = 1
        local Coords = GetEntityCoords(Ped)
        if Coords["z"] < (Interiors[Interior]["Exit"]["z"] - 25.0) then
            SetEntityCoords(Ped,Interiors[Interior]["Exit"],false,false,false,false)
            FreezeEntityPosition(Ped,true)
            Wait(5000)
            FreezeEntityPosition(Ped,false)
        end
        if IsControlJustPressed(1,38) then
            SetEntityCoords(Ped,OldCoords,false,false,false,false)
            FreezeEntityPosition(Ped,true)
            Wait(5000)
            FreezeEntityPosition(Ped,false)
            TriggerEvent("Notify:Text","")
            InsideInterior = false
        end
        Wait(Idle)
    end
end)
