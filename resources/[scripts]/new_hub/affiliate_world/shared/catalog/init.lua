---@class affiliateWorld.CategoryDefinition
---@field id string
---@field publicId? string
---@field title string
---@field notWorkInCities? string[]
---@field action string

---@class affiliateWorld.CategoryDefinitionParams
---@field id? string
---@field publicId? string
---@field title string
---@field notWorkInCities? string[]
---@field action string

---@type affiliateWorld.CategoryDefinition[]
local gAffiliateWorldCategories = {}

---@param categoryId string
---@return fun(definition: affiliateWorld.CategoryDefinitionParams)
function DEFINE_CATEGORY(categoryId)
    assert(type(categoryId) == "string" and categoryId ~= "", "affiliate category id is required")

    return function(definition)
        assert(type(definition) == "table", ("affiliate category definition is required id=%s"):format(categoryId))
        assert(type(definition.action) == "string", ("affiliate category action is required id=%s"):format(categoryId))

        definition.id = categoryId
        ---@cast definition affiliateWorld.CategoryDefinition
        gAffiliateWorldCategories[#gAffiliateWorldCategories + 1] = definition
    end
end

---@param category affiliateWorld.CategoryDefinition?
---@return boolean available
local function IsAffiliateCategoryAvailable(category)
    if not category or type(category.notWorkInCities) ~= "table" then
        return category ~= nil
    end

    for _, unavailableCityName in ipairs(category.notWorkInCities) do
        if unavailableCityName == cityName then
            return false
        end
    end

    return true
end

---@param publicCategoryId string
---@return boolean available
function IsAffiliateWorldPublicCategoryAvailable(publicCategoryId)
    for _, category in ipairs(gAffiliateWorldCategories) do
        if (category.publicId or category.id) == publicCategoryId then
            return IsAffiliateCategoryAvailable(category)
        end
    end

    return true
end

---@return string[] categoryIds
function GetAffiliateWorldVisibleCategoryIds()
    local categoryIds = {}

    for _, category in ipairs(gAffiliateWorldCategories) do
        if IsAffiliateCategoryAvailable(category) then
            categoryIds[#categoryIds + 1] = category.publicId or category.id
        end
    end

    return categoryIds
end
