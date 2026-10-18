local spriteLoaded = false
currentAlpha = 255
drawIndicatorAtCoords = function(dict, sprite, x,y,z, width, height, dist)
    local dict   = dict
    local sprite = sprite
    local r,g,b  = 255, 255, 255

    if (not spriteLoaded) then 
        RequestStreamedTextureDict(dict, true)

        while not HasStreamedTextureDictLoaded(dict) do
            Wait(0)
        end

        spriteLoaded = true
    end

    local isClose = #(vec3(x,y,z) - GetEntityCoords(PlayerPedId())) < dist

    if (isClose) then
        currentAlpha = math.min(255, currentAlpha + 10)

    else
        currentAlpha = math.max(-255, currentAlpha - 10)
    end

    -- print(currentAlpha)

    SetScriptGfxAlignParams(0.0, 0.0, 0.0, 0.0)
    SetDrawOrigin(x,y,z)
    DrawSprite(dict, sprite, 0, 0,  width, height, 0, r or 255, g or 255, b or 255, currentAlpha)

    ResetScriptGfxAlign()

    ClearDrawOrigin()
end