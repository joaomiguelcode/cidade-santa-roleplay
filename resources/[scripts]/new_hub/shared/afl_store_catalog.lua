-----------------------------------------------------------------------------------------------------------------------------------------
-- LOJA AFL.COINS - Catalogo gerenciado pela TebexAPI/Vault
-----------------------------------------------------------------------------------------------------------------------------------------

gAflStoreCatalogState = gAflStoreCatalogState or {
    catalog = { categories = {}, items = {} },
    byId = {},
}

local gAflStoreCatalogState = gAflStoreCatalogState

---@param left string[]
---@param right string[]
---@return boolean
local function AreAflStoreCatalogCommandsEqual( left, right )

    if #left ~= #right then
        return false
    end

    for index, command in ipairs( left ) do
        if command ~= right[index] then
            return false
        end
    end

    return true
end

---@param left table
---@param right table
---@return boolean
local function AreAflStoreCatalogItemsEquivalent( left, right )

    return left.categoryId == right.categoryId
        and left.name == right.name
        and left.description == right.description
        and left.price == right.price
        and left.image == right.image
        and left.stock == right.stock
        and left.limit_per_affiliate == right.limit_per_affiliate
        and AreAflStoreCatalogCommandsEqual( left.commands_to_give, right.commands_to_give )
end

---@param catalog table
---@return boolean
---@return string|nil error
---@return table|nil normalizedCatalog
function SetAflStoreCatalog( catalog )
    if type( catalog ) ~= "table" or type( catalog.categories ) ~= "table" or type( catalog.items ) ~= "table" then
        return false, "catalog, categories or items is not a table"
    end

    local byId = {}
    local items = {}

    for index, item in ipairs( catalog.items ) do
        if type( item ) ~= "table" or type( item.id ) ~= "string" or type( item.price ) ~= "number"
            or item.price < 1 or item.price % 1 ~= 0 or type( item.commands_to_give ) ~= "table" then
            return false, ("invalid item at index %d"):format( index )
        end

        local existingItem = byId[item.id]

        if existingItem then
            if not AreAflStoreCatalogItemsEquivalent( existingItem, item ) then
                return false, ("conflicting duplicate item id=%s"):format( item.id )
            end
        else
            byId[item.id] = item
            items[#items + 1] = item
        end
    end

    local normalizedCatalog = {
        categories = catalog.categories,
        items = items,
    }

    gAflStoreCatalogState.catalog = normalizedCatalog
    gAflStoreCatalogState.byId = byId

    return true, nil, normalizedCatalog
end

---@param id string
---@return table|nil
function GetAflStoreCatalogItem( id )
    if type( id ) ~= "string" or #id > 128 then
        return nil
    end

    return gAflStoreCatalogState.byId[id]
end

---@param id any
---@return table
function GetAflStoreCatalogLookupDiagnostics( id )
    local diagnostics = {
        items = #gAflStoreCatalogState.catalog.items,
        itemId = false,
    }

    if type( id ) ~= "string" or #id > 128 then
        return diagnostics
    end

    diagnostics.itemId = gAflStoreCatalogState.byId[id] ~= nil

    return diagnostics
end

---@return boolean
function IsAflStoreCatalogReady()
    return next( gAflStoreCatalogState.byId ) ~= nil
end

---@return table
function GetAflStoreCatalogPayload()
    local items = {}
    for _, item in ipairs( gAflStoreCatalogState.catalog.items ) do
        items[#items + 1] = {
            id = item.id,
            categoryId = item.categoryId,
            name = item.name,
            description = item.description,
            price = item.price,
            image = item.image,
            -- ponytail: modelo cru pro client checar existencia com IsModelInCdimage
            vehicle = item.commands_to_give[1] and item.commands_to_give[1]:match( "^GiveVehicle {passport} (%S+)" ) or nil,
        }
    end

    return { categories = gAflStoreCatalogState.catalog.categories, items = items }
end
