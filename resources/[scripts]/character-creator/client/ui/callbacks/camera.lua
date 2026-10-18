
RegisterNUICallback("zoom", function(zoom, callback)
    if Camera.isLerpingTransition() then
        return callback(false)
    end
    Camera.zoom(zoom)
    callback(true)
end)

local MAP_CATEGORIES = {
    eye = "eyes",
    nose = "nose",
    parents = "head",
    face = "head",
    body = "head",
    barber = "head",
    dna = "head",
    presets = "head",
    appearance = "head",
    register = "center-screen"
}

RegisterNUICallback("appearance:onCategoryChange", function(data, callback)
    callback(true)

    local category = MAP_CATEGORIES[data.category]

    if not category then
        return
    end

    if data.category == "presets" then
        ResetPlayerPosition()
    end

    Camera.focusOnPart(category, 500)
end)