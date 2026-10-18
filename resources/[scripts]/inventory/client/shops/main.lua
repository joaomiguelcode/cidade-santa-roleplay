-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
local ClientShops = {}
Tunnel.bindInterface("inventory/shops",ClientShops)
local vSERVER = Tunnel.getInterface("inventory/shops")
local ShoppingAt = nil
local DynamicShopPoints = {}
local DynamicShopTypes = {}
local DYNAMIC_SHOPS_STATE_KEY = "inventory:dynamicShops"
local gLastValidDynamicShopsSnapshot = nil
local CANNOT_SHOW_COLLECTIONS_IDS = {
    pets = true,
}
CustomShopsConfig = CustomShopsConfig or {}
CustomShopsTexts = CustomShopsTexts or {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    Wait(1000)
    ModifiedStores = exports['variables']:GetVariable('variables','ModifiedStores') or {}
    for Shop,Data in pairs (ModifiedStores) do
        ShopsConfig[Shop] = Data
    end
    EconomyVar = exports['variables']:GetVariable('variables','ShopBuy') or 1.0
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler('inventory:CloseAll', function()
	TriggerEvent("inventory:Close")
end)

RegisterNetEvent('register:Open')
AddEventHandler('register:Open', function()
	TriggerEvent("inventory:Close")
	SetNuiFocus(false,false)
end)

---@class inventory.OpenShopParams
---@field tag string
---@field type string

---@param shop inventory.OpenShopParams 
local function openShop(shop)

	if not exports.admin:SafeguardAccountHasDiscordAccountLink() then
		return
	end

	ShoppingAt = shop
	toggleInventory("shop")
end
exports('openShop', openShop)

local function registerDynamicShopType(shopKey, shopConfig, shopTextConfig)
    if type(shopKey) ~= "string" or shopKey == "" or type(shopConfig) ~= "table" then
        return false
    end

    ShopsConfig[shopKey] = shopConfig
    DynamicShopTypes[shopKey] = true
    CustomShopsTexts[shopKey] = shopTextConfig or {
        text = shopConfig.name or shopKey,
        icon = "shopping-cart",
    }

    return true
end

local function removeDynamicShopType(shopKey)
    if type(shopKey) ~= "string" or shopKey == "" then
        return false
    end

    ShopsConfig[shopKey] = nil
    DynamicShopTypes[shopKey] = nil
    CustomShopsTexts[shopKey] = nil

    return true
end

local function removeDynamicShopPoint(pointId)
    local interactId = "dynamicCustomShops:"..tostring(pointId)
    local removeStatus, removeErr = xpcall(function()
        interact.removeById(interactId)
    end, function(err)
        return debug.traceback(tostring(err), 2)
    end)

    if not removeStatus then
        sx.logger:error(([[
[inventory/shops] Falha ao remover interacao dinamica antiga
  pointId: %s
  interactId: %s
  motivo:
%s]]):format(
            tostring(pointId),
            interactId,
            tostring(removeErr)
        ))
        return false
    end

    DynamicShopPoints[pointId] = nil

    return true
end

local function registerDynamicShopPoint(pointId, coords, shopTypes)
    if not pointId or not coords or not coords.x or not coords.y or not coords.z or type(shopTypes) ~= "table" then
        return false
    end

    local x = tonumber(coords.x)
    local y = tonumber(coords.y)
    local z = tonumber(coords.z)

    if not x or not y or not z then
        return false
    end

    if not removeDynamicShopPoint(pointId) then
        return false
    end

    local options = {}

    for _, selectedType in ipairs(shopTypes) do
        local shopText = CustomShopsTexts[selectedType] or {
            text = selectedType,
            icon = "shopping-cart",
        }

        options[#options + 1] = {
            label = shopText.text,
            icon = shopText.icon,
            onSelect = function(data)
                TriggerEvent("shops:openSystem:NPC", selectedType)
            end,
            canInteract = function(entity, distance, coords, id)
                return true
            end
        }
    end

    if #options < 1 then
        return false
    end

    local interactId = "dynamicCustomShops:"..tostring(pointId)
    local addStatus, addErr = xpcall(function()
        interact.addCoords({
            id = interactId,
            coords = vec3(x, y, z),
            options = options,
            renderDistance = 7.5,
            activeDistance = 1.25,
            cooldown = 1500
        })
    end, function(err)
        return debug.traceback(tostring(err), 2)
    end)

    if not addStatus then
        sx.logger:error(([[
[inventory/shops] Falha ao adicionar interacao dinamica
  pointId: %s
  interactId: %s
  coords: %.2f, %.2f, %.2f
  shopTypes: %d
  motivo:
%s]]):format(
            tostring(pointId),
            interactId,
            x,
            y,
            z,
            #shopTypes,
            tostring(addErr)
        ))
        return false
    end

    DynamicShopPoints[pointId] = true

    return true
end

---@param value table
---@return boolean
local function IsDenseArray(value)
    if type(value) ~= "table" then
        return false
    end

    local length = #value
    local count = 0

    for key in pairs(value) do
        if type(key) ~= "number" or key < 1 or key > length or key ~= math.floor(key) then
            return false
        end

        count = count + 1
    end

    return count == length
end

---@param snapshot table
---@return table? normalizedSnapshot
---@return string? errorMessage
local function NormalizeCompactDynamicShopsSnapshot(snapshot)
    if not IsDenseArray(snapshot.shops) or not IsDenseArray(snapshot.points) then
        return nil, "compact snapshot arrays are invalid"
    end

    local shops = {}
    local points = {}
    local seenTypes = {}
    local seenPoints = {}

    for index, shop in ipairs(snapshot.shops) do
        if type(shop) ~= "table" then
            return nil, ("shop %d must be a table"):format(index)
        end

        local shopKey = shop[1]

        if type(shopKey) ~= "string" or shopKey == "" then
            return nil, ("shop %d has invalid key"):format(index)
        end

        if seenTypes[shopKey] then
            return nil, ("shop %d duplicates key %s"):format(index, shopKey)
        end

        if type(shop[7]) ~= "table" then
            return nil, ("shop %d has invalid item list"):format(index)
        end

        seenTypes[shopKey] = true
        shops[#shops + 1] = {
            shopKey,
            shop[2] or false,
            shop[3] or false,
            shop[4] or false,
            shop[5] or false,
            shop[6] or false,
            shop[7],
        }
    end

    for index, point in ipairs(snapshot.points) do
        if type(point) ~= "table" then
            return nil, ("point %d must be a table"):format(index)
        end

        local pointId = point[1] and tostring(point[1]) or nil
        local x = tonumber(point[2])
        local y = tonumber(point[3])
        local z = tonumber(point[4])
        local shopTypes = point[5]

        if not pointId or pointId == "" or seenPoints[pointId] then
            return nil, ("point %d has invalid or duplicate id"):format(index)
        end

        if not x or not y or not z then
            return nil, ("point %d has invalid coordinates"):format(index)
        end

        if not IsDenseArray(shopTypes) or #shopTypes < 1 then
            return nil, ("point %d has invalid shop types"):format(index)
        end

        for typeIndex, shopType in ipairs(shopTypes) do
            if type(shopType) ~= "string" or shopType == "" then
                return nil, ("point %d has invalid shop type at %d"):format(index, typeIndex)
            end
        end

        seenPoints[pointId] = true
        points[#points + 1] = { pointId, x, y, z, shopTypes }
    end

    local expectedShopCount = snapshot.shopCount ~= nil and tonumber(snapshot.shopCount) or #shops
    local expectedPointCount = snapshot.pointCount ~= nil and tonumber(snapshot.pointCount) or #points

    if expectedShopCount ~= #shops or expectedPointCount ~= #points then
        return nil, ("snapshot count mismatch shops=%s/%d points=%s/%d"):format(
            tostring(expectedShopCount),
            #shops,
            tostring(expectedPointCount),
            #points
        )
    end

    return {
        schemaVersion = tonumber(snapshot.schemaVersion) or 0,
        shopCount = #shops,
        pointCount = #points,
        shops = shops,
        points = points,
    }
end

---@param snapshot table
---@return table? normalizedSnapshot
---@return string? errorMessage
local function NormalizeLegacyDynamicShopsSnapshot(snapshot)
    if type(snapshot.types) ~= "table" or type(snapshot.points) ~= "table" then
        return nil, "legacy snapshot maps are invalid"
    end

    local shops = {}
    local points = {}
    local texts = type(snapshot.texts) == "table" and snapshot.texts or {}

    for shopKey, shopConfig in pairs(snapshot.types) do
        if type(shopKey) ~= "string" or shopKey == "" or type(shopConfig) ~= "table" then
            return nil, "legacy snapshot contains invalid shop"
        end

        local shopText = type(texts[shopKey]) == "table" and texts[shopKey] or {}

        shops[#shops + 1] = {
            shopKey,
            shopConfig.name or false,
            shopConfig.Slots or false,
            shopConfig.Type or false,
            shopText.text or false,
            shopText.icon or false,
            type(shopConfig.List) == "table" and shopConfig.List or {},
        }
    end

    for pointId, point in pairs(snapshot.points) do
        local coords = type(point) == "table" and point.coords or nil
        local shopTypes = type(point) == "table" and point.shopTypes or nil

        if not coords or not tonumber(coords.x) or not tonumber(coords.y) or not tonumber(coords.z) then
            return nil, ("legacy point %s has invalid coordinates"):format(tostring(pointId))
        end

        points[#points + 1] = {
            tostring(pointId),
            math.floor(tonumber(coords.x) * 100 + 0.5),
            math.floor(tonumber(coords.y) * 100 + 0.5),
            math.floor(tonumber(coords.z) * 100 + 0.5),
            shopTypes,
        }
    end

    return NormalizeCompactDynamicShopsSnapshot({
        schemaVersion = 0,
        shopCount = #shops,
        pointCount = #points,
        shops = shops,
        points = points,
    })
end

---@param snapshot table
---@return table? normalizedSnapshot
---@return string? errorMessage
local function NormalizeDynamicShopsSnapshot(snapshot)
    if type(snapshot) ~= "table" then
        return nil, "snapshot is not a table"
    end

    if snapshot.shops ~= nil then
        return NormalizeCompactDynamicShopsSnapshot(snapshot)
    end

    if snapshot.types ~= nil then
        return NormalizeLegacyDynamicShopsSnapshot(snapshot)
    end

    return nil, "snapshot schema is unknown"
end

---@param snapshot table
---@return boolean success
local function ApplyDynamicShopsSnapshot(snapshot)
    local normalizedSnapshot, normalizeErr = NormalizeDynamicShopsSnapshot(snapshot)

    if not normalizedSnapshot then
        if snapshot ~= nil then
            -- sx.logger:warn(('[inventory/shops] Snapshot dinamico ignorado; estado anterior preservado: %s'):format(
            --     tostring(normalizeErr)
            -- ))
        end
        return false
    end

    if GetResourceState('sleepless_interact') ~= 'started' then
        -- sx.logger:warn('[inventory/shops] Snapshot dinamico aguardando sleepless_interact')
        gLastValidDynamicShopsSnapshot = normalizedSnapshot
        return false
    end

    local shops = normalizedSnapshot.shops
    local points = normalizedSnapshot.points
    local seenTypes = {}
    local typesToRemove = {}
    local pointsToRemove = {}

    for _, shop in ipairs(shops) do
        seenTypes[shop[1]] = true
    end

    for shopKey in pairs(DynamicShopTypes) do
        if not seenTypes[shopKey] then
            typesToRemove[#typesToRemove + 1] = shopKey
        end
    end

    for _, shopKey in ipairs(typesToRemove) do
        removeDynamicShopType(shopKey)
    end

    for _, shop in ipairs(shops) do
        local shopKey = shop[1]

        registerDynamicShopType(shopKey, {
            name = shop[2] or nil,
            Slots = shop[3] or nil,
            Type = shop[4] or nil,
            List = shop[7] or {},
        }, {
            text = shop[5] or shop[2] or shopKey,
            icon = shop[6] or "shopping-cart",
        })
    end

    for pointId in pairs(DynamicShopPoints) do
        pointsToRemove[#pointsToRemove + 1] = pointId
    end

    for index, pointId in ipairs(pointsToRemove) do
        if not removeDynamicShopPoint(pointId) then
            sx.logger:error(('[inventory/shops] Aplicacao do snapshot abortada apos falha na limpeza point=%s removidas=%d/%d incoming=%d'):format(
                tostring(pointId),
                index - 1,
                #pointsToRemove,
                #points
            ))
            return false
        end
    end

    for _, point in ipairs(points) do
        if type(point) == "table" then
            local registered = registerDynamicShopPoint(point[1], {
                x = point[2] / 100,
                y = point[3] / 100,
                z = point[4] / 100,
            }, point[5] or {})

            if not registered then
                -- sx.logger:warn(('[inventory/shops] Falha ao registrar point dinamico %s'):format(tostring(point[1])))
            end
        end
    end

    gLastValidDynamicShopsSnapshot = normalizedSnapshot
    -- sx.logger:debug(('[inventory/shops] Snapshot dinamico aplicado shops=%d points=%d schema=%d'):format(
    --     normalizedSnapshot.shopCount,
    --     normalizedSnapshot.pointCount,
    --     normalizedSnapshot.schemaVersion
    -- ))

    return true
end

exports("RegisterDynamicShopType", registerDynamicShopType)
exports("RemoveDynamicShopType", removeDynamicShopType)
exports("RegisterDynamicShopPoint", registerDynamicShopPoint)
exports("RemoveDynamicShopPoint", removeDynamicShopPoint)

AddStateBagChangeHandler(DYNAMIC_SHOPS_STATE_KEY, nil, function(_, _, value)
    ApplyDynamicShopsSnapshot(value)
end)

CreateThread(function()
    ApplyDynamicShopsSnapshot(GlobalState[DYNAMIC_SHOPS_STATE_KEY])
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTSHOP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestShop",function(Data,Callback)
	if not ShoppingAt then
        -- sx.logger:warn("[inventory/shops] requestShop chamado sem loja ativa")
        return
	end

	local shopConfig = ShopsConfig[ShoppingAt["tag"]]

    local inventoryShop = {}
    local shopSlots = shopConfig and shopConfig["Slots"] or 20
    local shopStock = false

    -- sx.logger:debug(("[inventory/shops] requestShop data=%s"):format(json.encode(ShoppingAt, { indent = true })))

	if ShoppingAt["tag"] == "Collectibles" then

		inventoryShop = exports.santa_radio:GetCollectiblesShopInventory( CANNOT_SHOW_COLLECTIONS_IDS )
		shopSlots = math.max(#inventoryShop, shopSlots)
        if shopSlots <= 20 then
            shopSlots = 20
        end

	elseif shopConfig and shopConfig["name"] then

        shopStock = vSERVER.GetShopStock(ShoppingAt["tag"])
    end
    for k,v in pairs(shopConfig and shopConfig["List"] or {}) do
        if shopStock then
            table.insert(inventoryShop,{
                key = k,
                price = parseInt(v*EconomyVar),
                stock = shopStock[k] or 0
            })
        else
            table.insert(inventoryShop,{
                key = k,
                price = parseInt(v*EconomyVar)
            })
        end
    end
	for k,v in pairs(inventoryShop) do
		inventoryShop[k]["slot"] = k
		inventoryShop[k]["amount"] = 1
		inventoryShop[k]["name"] = itemName(v["key"])
		inventoryShop[k]["weight"] = itemWeight(v["key"])
		inventoryShop[k]["index"] = itemIndex(v["key"])
		inventoryShop[k]["max"] = itemMaxAmount(v["key"])
		inventoryShop[k]["desc"] = v["desc"] or itemDescription(v["key"])
		inventoryShop[k]["economy"] = itemEconomy(v["key"])
		-- 
		inventoryShop[k]["premium"] = ShoppingAt["tag"] == "Premium" or ShoppingAt["tag"] == "Premium2"
	end
    local Info = {
        items = inventoryShop, 
        type = "shop", 
        slots = shopSlots
    }

	if exports.tutorial:CanStartUiTutorial('tutorial.ui.store') then
		SendNUIMessage({ action = 'tutorialInventory:start', data = exports.tutorial:GetTutorialById('tutorial.ui.store') })
	end

	Callback(Info)
end)

RegisterNUICallback("useItemShop",function(Data, Callback)
	vSERVER._functionShops(ShoppingAt.tag, Data["item"], Data["amount"], Data["target"])

	Callback("Ok")
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTBUY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("pickupSlotShop",function(Data, Callback)
	vSERVER._functionShops(ShoppingAt.tag, Data["item"], Data["amount"], Data["target"])

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTBUY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("dropSlotShop",function(Data, Callback)
	vSERVER._functionShops(ShoppingAt.tag, Data["item"], Data["amount"], Data["slot"])

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POPULATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("populateSlotShops",function(Data,Callback)
	--TriggerServerEvent("shops:populateSlot",Data["item"],Data["slot"],Data["target"],Data["amount"])
	--
	--Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("updateSlotShop",function(Data,Callback)
	--TriggerServerEvent("shops:updateSlot",Data["item"],Data["slot"],Data["target"],Data["amount"])
	--
	--Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRUNKCHEST:UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
function ClientShops.updateShops(action)
	SendNUIMessage({ action = "updateInventory" })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPLIST
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
-- CreateThread(function()
--     local Table = {}

--     for _,v in pairs(shopList) do
--         table.insert(Table,{ v[1],v[2],v[3],1.25,"E","Loja","Pressione para abrir" })
--     end

--     TriggerEvent("hoverfy:Insert",Table)
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADOPEN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler('onResourceStart', function(resource)
    Wait(1500)
    if resource == "sleepless_interact" then
        StartShopsInteraction()

        if gLastValidDynamicShopsSnapshot then
            ApplyDynamicShopsSnapshot(gLastValidDynamicShopsSnapshot)
        else
            ApplyDynamicShopsSnapshot(GlobalState[DYNAMIC_SHOPS_STATE_KEY])
        end
    end

    if resource == GetCurrentResourceName() then
        StartShopsInteraction()
    end
end)

AddEventHandler('playerSpawned', function(resource)
    StartShopsInteraction()
end)

function StartShopsInteraction()
    for k,v in pairs(shopList) do
        interact.addCoords({
            id = "shops:"..tostring(k),
            coords = vec3(v[1],v[2],v[3]),
            options = {
                {
                    label = _t("openShops"),
                    icon = "shopping-cart",
                    onSelect = function(data)
                        
                        if not v[4] or v[4] ~= "Bebidas" then
                            if not vSERVER.requestPerm(v[4]) then
                                return
                            end
                        end
                        openShop({
                            tag = v[4],
                            type = ShopsConfig[v[4]]["Type"]
                        })

                        if v[5] then
                            TriggerEvent("sounds:Private","shop",0.5)
                        end
                    end,
                    canInteract = function(entity, distance, coords, id)
                        return true
                    end
                }
            },
            renderDistance = 7.5,
            activeDistance = 1.25,
            cooldown = 1500
        })
    end
    for i=1,#CustomShopsConfig do
        local SelectedShop = CustomShopsConfig[i]
        local options = {}
        for j=1,#SelectedShop["type"] do
            local SelectedType = SelectedShop["type"][j]
            if SelectedType then
                table.insert(options,{
                    label = CustomShopsTexts[SelectedType]["text"],
                    icon = CustomShopsTexts[SelectedType]["icon"],
                    onSelect = function(data)
                        TriggerEvent("shops:openSystem:NPC",SelectedType)
                    end,
                    canInteract = function(entity, distance, coords, id)
                        return true
                    end
                })
            end
        end
        interact.addCoords({
            id = "customShops:"..tostring(i),
            coords = SelectedShop["coords"],
            options = options,
            renderDistance = 7.5,
            activeDistance = 1.25,
            cooldown = 1500
        })
    end
end
exports('AddShop',function(Name, id, Coords)
	interact.addCoords({
		id = "shops:"..tostring(Name)..":"..tostring(id),
		coords = vec3(Coords.x,Coords.y,Coords.z),
		options = {
			{
				label = _t("openShops"),
				icon = "shopping-cart",
				onSelect = function(data)
					openShop({
						tag = Name,
						type = ShopsConfig[Name]["Type"]
					})
				end,
				canInteract = function(entity, distance, coords, id)
					return true
				end
			}
		},
		renderDistance = 7.5,
		activeDistance = 1.25,
		cooldown = 1500
	})
end)
exports("RemoveShop",function(Name, id)
	interact.removeById("shops:"..tostring(Name)..":"..tostring(id))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:OPENSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("shops:openSystem:NPC",function(Perm)
	if LocalPlayer["state"]["Route"] < 900000 then
		if not exports["hud"]:Wanted() and vSERVER.requestPerm(Perm) then
			openShop({
				tag = Perm,
				type = ShopsConfig[Perm]["Type"]
			})
		end
        TriggerEvent("talknpc:closeTalkWSound")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:COFFEEMACHINE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("shops:coffeeMachine",function()
	if LocalPlayer["state"]["Route"] < 900000 then
		openShop({
			tag = "coffeeMachine",
			type = "Buy"
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:SODAMACHINE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("shops:sodaMachine",function()
	if LocalPlayer["state"]["Route"] < 900000 then
		openShop({
			tag = "sodaMachine",
			type = "Buy"
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:DONUTMACHINE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("shops:donutMachine",function()
	if LocalPlayer["state"]["Route"] < 900000 then
		openShop({
			tag = "donutMachine",
			type = "Buy"
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:BURGERMACHINE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("shops:burgerMachine",function()
	if LocalPlayer["state"]["Route"] < 900000 then
		openShop({
			tag = "burgerMachine",
			type = "Buy"
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:HOTDOGMACHINE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("shops:hotdogMachine",function()
	if LocalPlayer["state"]["Route"] < 900000 then
		openShop({
			tag = "hotdogMachine",
			type = "Buy"
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:CHIHUAHUA
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("shops:Chihuahua",function()
	if LocalPlayer["state"]["Route"] < 900000 then
		openShop({
			tag = "Chihuahua",
			type = "Buy"
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:WATERMACHINE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("shops:waterMachine",function()
	if LocalPlayer["state"]["Route"] < 900000 then
		openShop({
			tag = "waterMachine",
			type = "Buy"
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:MEDICBAG
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("shops:medicBag",function()
	if LocalPlayer["state"]["Route"] < 900000 then
		if not exports["hud"]:Wanted() and vSERVER.requestPerm("Paramedic") then
			openShop({
				tag = "Paramedic",
				type = "Buy"
			})
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:FUEL
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("shops:Fuel",function()
	openShop({
		tag = "Fuel",
		type = "Buy"
	})
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:Diamantes
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("shops:OpenShop",function(tag)
	if LocalPlayer["state"]["Route"] < 900000 then
		openShop({
			tag = tag,
			type = "Buy"
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DIAMANTES
-----------------------------------------------------------------------------------------------------------------------------------------
-- RegisterCommand("diamantes",function()
--     if GlobalState["BlockDiamond"] then
--         return
--     end
--     if LocalPlayer["state"]["Handcuff"] then
--         return
--     end

--     local Ped = PlayerPedId()
--     local Health = GetEntityHealth(Ped)
--     if Health <= 100 then
--         return
--     end
-- 	if LocalPlayer["state"]["Route"] < 900000 then
-- 		openShop({
-- 			tag = "Premium",
-- 			type = "Buy"
-- 		})
-- 	end
-- end)

-- exports( 'openShop', openShop )
