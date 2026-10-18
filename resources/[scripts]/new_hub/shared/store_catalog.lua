-----------------------------------------------------------------------------------------------------------------------------------------
-- LOJA DE GEMAS - Catalogo gerenciado pela TebexAPI/Vault
-----------------------------------------------------------------------------------------------------------------------------------------

local gStoreCatalog = { categories = {}, items = {} }
local gStoreCatalogById = {}
local gStoreCatalogSkinDisplays = {}

---@param catalog table
---@return boolean
---@return string|nil error
function SetStoreCatalog( catalog )
    if type( catalog ) ~= "table" or type( catalog.categories ) ~= "table" or type( catalog.items ) ~= "table" then
        return false, "catalog, categories or items is not a table"
    end

    local byId = {}
    for index, item in ipairs( catalog.items ) do
        if type( item ) ~= "table" or type( item.id ) ~= "string" or type( item.price ) ~= "number"
            or item.price < 1 or item.price % 1 ~= 0 or type( item.commands_to_give ) ~= "table" then
            return false, ("invalid item at index %d"):format( index )
        end
        byId[item.id] = item
    end

    local skinDisplays = {}
    for _, item in ipairs( catalog.items ) do
        if #item.commands_to_give == 1 and type( item.commands_to_give[1] ) == "string" then
            local command = item.commands_to_give[1]
            local component = command:match( "^%s*GiveWeaponSkin%s+{passport}%s+([%w_]+)%s*$" )
                or command:match( "^%s*GiveWeaponSkin%s+{passport}%s+([%w_]+)%s+%d+%s*$" )

            if component and type( item.name ) == "string" and item.name:find( "%S" ) then
                component = component:upper()
                if not skinDisplays[component] then
                    skinDisplays[component] = {
                        name = item.name,
                        image = type( item.image ) == "string" and item.image or nil,
                    }
                end
            end
        end
    end

    gStoreCatalog = catalog
    gStoreCatalogById = byId
    gStoreCatalogSkinDisplays = skinDisplays
    return true, nil
end

---@param id string
---@return table|nil
function GetStoreCatalogItem( id )
    return gStoreCatalogById[id]
end

--- Apresentacao da skin avulsa pelo componente exato, independente da duracao.
--- Nao cria associacao de compra nem retorna comandos, UUID ou preco.
---@param component string
---@return { name: string, image: string? }?
function GetStoreCatalogSkinDisplay( component )
    if type( component ) ~= "string" then
        return nil
    end

    local display = gStoreCatalogSkinDisplays[component:upper()]
    return display and { name = display.name, image = display.image } or nil
end

---@param categoryId string
---@return string?
function GetStoreCatalogCategoryName( categoryId )
    for _, category in ipairs( gStoreCatalog.categories ) do
        if category.id == categoryId then
            return category.name
        end
    end

    return nil
end

--- Retorna somente os dados necessarios para entrega server-side programada.
---@param productId string
---@return { id: string, name: string|nil, commands_to_give: string[] }|nil
function GetStoreCatalogDeliveryItem( productId )
    local item = gStoreCatalogById[productId]

    if not item or type( item.commands_to_give ) ~= "table" or #item.commands_to_give < 1 then
        return nil
    end

    return {
        id = item.id,
        name = item.name,
        commands_to_give = item.commands_to_give,
    }
end

exports( "GetStoreCatalogDeliveryItem", GetStoreCatalogDeliveryItem )

---@return boolean
function IsStoreCatalogReady()
    return next( gStoreCatalogById ) ~= nil
end

--- Payload seguro para a NUI: sem os comandos autoritativos de entrega.
---@return { categories: table, items: table }
function GetStoreCatalogPayload()
    local items = {}
    for _, item in ipairs( gStoreCatalog.items ) do
        items[#items + 1] = {
            id = item.id,
            categoryId = item.categoryId,
            name = item.name,
            description = item.description,
            price = item.price,
            image = item.image,
        }
    end

    return { categories = gStoreCatalog.categories, items = items }
end
