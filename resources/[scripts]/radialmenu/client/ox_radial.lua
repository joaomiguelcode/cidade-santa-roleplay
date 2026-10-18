---@class RadialItem
---@field icon string | {[1]: IconProp, [2]: string};
---@field label string
---@field menu? string
---@field onSelect? fun(currentMenu: string | nil, itemIndex: number) | string
---@field [string] any
---@field keepOpen? boolean
---@field iconWidth? number
---@field iconHeight? number
---@field isEnabled? fun(pEntity: number | nil) | boolean

---@class RadialMenuItem: RadialItem
---@field id string

---@class RadialMenuProps
---@field id string
---@field items RadialItem[]
---@field isEnabled? fun(pEntity: number | nil) | boolean
---@field [string] any

local isOpen = false

---@type table<string, RadialMenuProps>
local menus = {}

---@type RadialMenuItem[]
local menuItems = {}

---@type table<{id: string, option: string}>
local menuHistory = {}

---@type RadialMenuProps?
local currentRadial = nil

---Open a the global radial menu or a registered radial submenu with the given id.
---@param id string?
---@param option number?
local function showRadial(id, option)
    local radial = id and menus[id]
    -- print(id)   
    if id and not radial then
        return error('No radial menu with such id found.')
    end
    
    currentRadial = radial
    
    -- Hide current menu and allow for transition
    SendNUIMessage({
        action = 'openRadialMenu',
        data = false
    })
    
    Wait(100)
    
    local radialItems = radial and radial.items or menuItems
    
    -- If menu was closed during transition, don't open the submenu
    if not isOpen then return end
    local cacheWithoutDisabled = getMenuItemsWithoutDisabled(radialItems)
    SendNUIMessage({
        action = 'openRadialMenu',
        data = {
            items = cacheWithoutDisabled,
            sub = radial and true or nil,
            option = option
        }
    })
end

---Refresh the current menu items or return from a submenu to its parent.
local function refreshRadial(menuId)
    if not isOpen then return end
    
    if currentRadial and menuId then
        if menuId == currentRadial.id then
            return showRadial(menuId)
        else
            for i = 1, #menuHistory do
                local subMenu = menuHistory[i]
                
                if subMenu.id == menuId then
                    local parent = menus[subMenu.id]
                    
                    for j = 1, #parent.items do
                        -- If we still have a path to the current submenu, refresh instead of returning
                        if parent.items[j].menu == currentRadial.id then
                            return -- showRadial(currentRadial.id)
                        end
                    end
                    
                    currentRadial = parent
                    
                    for j = #menuHistory, i, -1 do
                        menuHistory[j] = nil
                    end
                    
                    return showRadial(currentRadial.id)
                end
            end
        end
        
        return
    end
    
    table.wipe(menuHistory)
    showRadial()
end

function getMenuItemsWithoutDisabled(items)
    local itemsCloned = deepClone(items)
    local deepCloneTable = {}
    
    for id, item in pairs(itemsCloned) do
        local isEnabled = item.isEnabled
        
        if isEnabled and type(isEnabled) ~= "boolean" then
            item.isEnabled = isEnabled(game.currentEntityTarget)
        end
        
        
        table.insert(deepCloneTable, {
            id = item.id,
            label = item.label,
            icon = item.icon,
            isEnabled = item.isEnabled
        })
    end
    
    return deepCloneTable
end

function deepClone(orig)
    local origType = type(orig)
    local copy
    if origType == 'table' then
        copy = {}
        for key, value in pairs(orig) do
            copy[key] = deepClone(value) -- Recursivamente clona sub-tabelas
        end
        setmetatable(copy, deepClone(getmetatable(orig))) -- Clona metatable (se existir)
    else
        copy = orig -- Para tipos primitivos, apenas copia o valor
    end
    return copy
end

---Registers a radial sub menu with predefined options.
---@param radial RadialMenuProps
function game.registerRadial(radial)
    menus[radial.id] = radial
    radial.resource = GetInvokingResource()
    
    if currentRadial then
        refreshRadial(radial.id)
    end
end

function game.getCurrentRadialId()
    return currentRadial and currentRadial.id
end

function game.hideRadial()
    if not isOpen then return end
    

    SendNUIMessage({
        action = 'openRadialMenu',
        data = false
    })
    
    SendNUIMessage({
        action = 'SHOW_PROFILE',
        data   = {
            display = false
        }
    })

    TriggerEvent('hub:close')

    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    table.wipe(menuHistory)
    
    isOpen = false
    currentRadial = nil
end

---Registers an item or array of items in the global radial menu.
---@param items RadialMenuItem | RadialMenuItem[]
function game.addRadialItem(items)
    local menuSize = #menuItems
    local invokingResource = GetInvokingResource()
    
    items = deepClone(table.type(items) == 'array' and items or { items })  
    Debug("addRadialItem ->") 
    for i = 1, #items do
        local item = items[i]
        Debug("item ->> "..json.encode(item.id))   
        item.resource = invokingResource
        if type(item.isEnabled) == "function" then
            item.isEnabled = item.isEnabled(game.currentEntityTarget) or false
            Debug("isEnabled ->> "..tostring(item.isEnabled))
        end
        -- if item.isEnabled == nil then
        --     item.isEnabled = true
        -- end
        
        if menuSize == 0 then
            menuSize += 1
            menuItems[menuSize] = item
        else
            for j = 1, menuSize do
                if menuItems[j].id == item.id then
                    menuItems[j] = item
                    break
                end
                
                if j == menuSize then
                    menuSize += 1
                    menuItems[menuSize] = item
                end
            end
        end
    end
    
    if isOpen and not currentRadial then
        refreshRadial()
    end
end

---Removes an item from the global radial menu with the given id.
---@param id string
function game.removeRadialItem(id)
    local menuItem
    
    for i = 1, #menuItems do
        menuItem = menuItems[i]
        
        if menuItem.id == id then
            table.remove(menuItems, i)
            break
        end
    end
    
    if not isOpen then return end
    
    refreshRadial(id)
end

---Removes all items from the global radial menu.
function game.clearRadialItems()
    table.wipe(menuItems)
    
    if isOpen then
        refreshRadial()
    end
end

cityName = GetConvar('cityName', '')
city     = string.lower(cityName)

RegisterNUICallback('getCityName', function(data, cb)
    -- print('getCityName', cityName)
    cb(cityName)
end)

RegisterNUICallback("getCityId",function(Data,cb)
    -- print('getCityId', cityName)
    cb(cityName)
end)

RegisterNUICallback('getServerHost', function(Data, cb)
    local api_url = GetConvar("api_url", "127.0.0.1")
    if api_url == "" then
        api_url = "127.0.0.1"
    end
    cb(api_url)
end)

RegisterNUICallback('radialClick', function(index, cb)
    SetNuiZindex(9999999)
    cb(1)
    local itemIndex = index + 1
    local item, currentMenu
    
    if currentRadial then
        item = currentRadial.items[itemIndex]
        currentMenu = currentRadial.id
    else
        item = menuItems[itemIndex]
    end
    
    local menuResource = currentRadial and currentRadial.resource or item.resource
    
    if item.menu then
        menuHistory[#menuHistory + 1] = { id = currentRadial and currentRadial.id, option = item.menu }
        showRadial(item.menu)
    elseif not item.keepOpen then
        game.hideRadial()
    end
    
    local onSelect = item.onSelect
    
    if onSelect then
        if type(onSelect) == 'string' then
            return exports[menuResource][onSelect](0, currentMenu, itemIndex)
        end
        onSelect(currentMenu, itemIndex, game.currentEntityTarget)
    end
    
    local onEvent = item.onEvent
    local arguments = item.arguments

    if onEvent then
        if type(onEvent) == "string" then
            TriggerEvent(onEvent, arguments)
        end
    end
end)

RegisterNUICallback('radialBack', function(_, cb)
    Debug("radialBack callback triggered")
    SetNuiZindex(9999999)
    cb(1)
    
    local numHistory = #menuHistory
    Debug("Current menu history length", numHistory)
    
    local lastMenu = numHistory > 0 and menuHistory[numHistory]
    Debug("Last menu in history", lastMenu)
    
    if not lastMenu then 
        Debug("No previous menu found, returning")
        return 
    end
    
    menuHistory[numHistory] = nil
    Debug("Removed last menu from history, new length", #menuHistory)
    
    if lastMenu.id then
        Debug("Opening previous menu with ID", {id=lastMenu.id, option=lastMenu.option})
        return showRadial(lastMenu.id, lastMenu.option)
    end
    
    currentRadial = nil
    Debug("Reset currentRadial to nil")
    
    -- Hide current menu and allow for transition
    Debug("Sending NUI message to hide menu")
    SendNUIMessage({
        action = 'openRadialMenu',
        data = false
    })
    
    
    SendNUIMessage({
        action = 'SHOW_PROFILE',
        data   = {
            display = false
        }
    })


    TriggerEvent('hub:close')
    Wait(100)
    
    -- If menu was closed during transition, don't open the submenu
    if not isOpen then 
        Debug("Menu was closed during transition, canceling submenu open")
        return 
    end
    local cacheWithoutDisabled = getMenuItemsWithoutDisabled(menuItems)
    Debug("Opening main menu with options", {items=#cacheWithoutDisabled, selectedOption=lastMenu.option})
    SendNUIMessage({
        action = 'openRadialMenu',
        data = {
            items = cacheWithoutDisabled,
            option = lastMenu.option
        }
    })
end)

RegisterNUICallback('radialClose', function(_, cb)
    cb(1)
    -- print("[DEBUG] radialClose")
    TriggerEvent('hub:close')

    -- SendNUIMessage({
    --     action = 'SHOW_PROFILE',
    --     data   = {
    --         display = false
    --     }
    -- })

    closeProfile()

    if not isOpen then return end
    


    SetNuiFocus(false, false)
    isOpen = false
    currentRadial = nil
    
end)

RegisterNUICallback('radialTransition', function(_, cb)
    Wait(100)
    
    -- If menu was closed during transition, don't open the submenu
    if not isOpen then return cb(false) end
    
    cb(true)
end)

local isDisabled = false

---Disallow players from opening the radial menu.
---@param state boolean
function game.disableRadial(state)
    isDisabled = state
    
    if isOpen and state then
        return game.hideRadial()
    end
end

---Open the global radial menu.
function game.openRadialMenu()
    if isDisabled then return end
    
    if isOpen then
        return game.hideRadial()
    end
    
    if #menuItems == 0 or IsNuiFocused() or IsPauseMenuActive() then return end
    
    isOpen = true
    
    local cacheWithoutDisabled = getMenuItemsWithoutDisabled(menuItems)

    Debug("openRadialMenu ->> "..json.encode(cacheWithoutDisabled))

    local target = nil
    local missionInProgress = GetResourceState("missions") == "started" and exports["missions"]:MissionInProgress("cara_conhecida")
    if missionInProgress then
        target = "[data-radial-id='like']"
    end
    
    SendNUIMessage({
        action = 'openRadialMenu',
        data = {
            items = cacheWithoutDisabled,
            target = target
        }
    })
    
    SetNuiFocus(true, true)
    --SetNuiFocusKeepInput(true)
    SetCursorLocation(0.5, 0.5)
    
    while isOpen do
        DisablePlayerFiring(PlayerId(), true)
        DisableControlAction(0, 1, true)
        DisableControlAction(0, 2, true)
        DisableControlAction(0, 142, true)
        DisableControlAction(2, 199, true)
        DisableControlAction(2, 200, true)
        Wait(0)
    end
end

-- RegisterKeyMapping("openRadialMenu", _t("open_radial_menu"), "KEYBOARD", "x")
-- RegisterCommand("openRadialMenu", function()
--     game.openRadialMenu()
-- end)

AddEventHandler('onClientResourceStop', function(resource)
    for i = #menuItems, 1, -1 do
        local item = menuItems[i]
        
        if item.resource == resource then
            table.remove(menuItems, i)
        end
    end
end)

RegisterNUICallback('PROFILE_SAVECONFIG', function(data, cb)
    local response = data.response

    TriggerServerEvent('player:SaveInfos', response)

    LocalPlayer["state"]:set("showPhone",response.showPhone,true)
    LocalPlayer["state"]:set("showJob",response.showJob,true)

    SetResourceKvpInt("showPhone",response.showPhone and 1 or 0)
    SetResourceKvpInt("showJob",response.showJob and 1 or 0)

    cb(true)
end)

RegisterNUICallback('CLOSE_PROFILE', function(data, cb)
    SetNuiZindex(88888)
    SetNuiFocus(false, false)
    TriggerEvent('dminigames:neighbor:profileClosed')
    cb(true)
end)

RegisterNUICallback('PROFILE_ACTIONRELATION', function(data, cb)
    TriggerServerEvent('player:ActionRelation', data)

    game.hideRadial()

    closeProfile()

    TriggerEvent('hub:close')

    cb(true)
end)



CreateThread(function()
    local showPhone   = GetResourceKvpInt("showPhone")
    local showJob     = GetResourceKvpInt("showJob")
    local phoneActive = showPhone == 1
    local jobActive   = showJob   == 1

    LocalPlayer["state"]:set("showPhone", phoneActive,true)
    LocalPlayer["state"]:set("showJob",jobActive,true)
end)
