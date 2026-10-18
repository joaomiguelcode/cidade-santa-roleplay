---@class PolyZoneEditor
---@field points vector3[]
---@field active boolean
---@field callback fun(points: vector3[])
PolyzoneEditor = {
    points = {},
    active = false,
    callback = function()

    end
}

local enabled = false

local POINT_MARKER = {
    type = 28,
    size = vector3(0.2, 0.2, 0.2),
    color = { r = 0, g = 255, b = 0, a = 150 }
}

local PREVIEW_MARKER = {
    type = 28,
    size = vector3(0.2, 0.2, 0.2),
    color = { r = 255, g = 255, b = 0, a = 100 }
}


---@param initialPoints vector3[] | nil
---@param callback fun(points: vector3[])
function PolyzoneEditor.start(initialPoints, callback)
    if enabled then
        return utils.notify(0, "Warning", _t('polyzone_editor_active_desc'), 5000, _t('farm_warning_title'))
    end


    local self = setmetatable({
        points = initialPoints or {},
        active = true,
        callback = callback or function(points)
            print('PolyZone saved with points:', points)
        end
    }, { __index = PolyzoneEditor })

    enabled = true
    self:drawControls()
    self:keyboard()
    self:drawPolyZone()

    return self
end

function PolyzoneEditor:save()
    self.callback(self.points)
    self:stop()
end

function PolyzoneEditor:stop()
    self.active = false
    self.points = {}
    enabled = false

    lib.hideTextUI()
end

function PolyzoneEditor:drawControls()
    local controlsText = string.format(
        "📍 Pontos: %d  \n" ..
        "🟢 **[E]** - Adicionar Ponto  \n" ..
        "🔴 **[Q]** - Remover Último  \n" ..
        "💾 **[Enter]** - Salvar Zone  \n" ..
        "❌ **[ESC]** - Cancelar",
        #self.points
    )

    lib.showTextUI(controlsText, {
        position = "right-center",
    })
end

---@param point vector3
function PolyzoneEditor:addPoint(point)
    table.insert(self.points, point)
    self:drawControls()
end

function PolyzoneEditor:removePoint()
    if not next(self.points) then
        return utils.notify(0, "Warning", _t('polyzone_no_points_desc'), 5000, _t('farm_warning_title'))
    end

    table.remove(self.points, #self.points)

    self:drawControls()
end

function PolyzoneEditor:keyboard()
    CreateThread(function()
        while self.active do
            ---@type boolean, number, vector3
            local hit, entityHit, endCoords = lib.raycast.fromCamera(1, true, 50.0)

            if hit then
                DrawMarker(
                    PREVIEW_MARKER.type,
                    endCoords.x, endCoords.y, endCoords.z,
                    0.0, 0.0, 0.0,
                    0.0, 0.0, 0.0,
                    PREVIEW_MARKER.size.x, PREVIEW_MARKER.size.y, PREVIEW_MARKER.size.z,
                    PREVIEW_MARKER.color.r, PREVIEW_MARKER.color.g, PREVIEW_MARKER.color.b, PREVIEW_MARKER.color.a,
                    false, true, 2, false, false, false, false
                )

                if IsControlJustPressed(0, 38) then      -- E
                    self:addPoint(endCoords)
                elseif IsControlJustPressed(0, 44) then  -- Q
                    self:removePoint()
                elseif IsControlJustPressed(0, 18) then  -- Enter
                    self:save()
                elseif IsControlJustPressed(0, 322) then -- ESC
                    self:stop()
                end
            end
        end
    end)
end

function PolyzoneEditor:drawPolyZone()
    ---@param initial vector
    ---@param center vector
    ---@param final vector
    local function DrawTriangle(initial, center, final)
        DrawPoly(initial.x, initial.y, initial.z, center.x, center.y, center.z, final.x, final.y, final.z, 255, 255, 255,
            60)
    end

    ---@param p1 table
    ---@param p2 table
    local function debugPoly(p1, p2)
        local height = 10
        local bottomLeft = vector3(p1[1], p1[2], p1[3] - height)
        local topLeft = vector3(p1[1], p1[2], p1[3] + height)
        local bottomRight = vector3(p2[1], p2[2], p2[3] - height)
        local topRight = vector3(p2[1], p2[2], p2[3] + height)

        DrawTriangle(bottomLeft, topLeft, bottomRight)
        DrawTriangle(topLeft, topRight, bottomRight)
        DrawTriangle(bottomRight, topRight, topLeft)
        DrawTriangle(bottomRight, topLeft, bottomLeft)
    end

    CreateThread(function()
        while self.active do
            -- Desenhar pontos confirmados
            for i, point in ipairs(self.points) do
                DrawMarker(
                    POINT_MARKER.type,
                    point.x, point.y, point.z,
                    0.0, 0.0, 0.0,
                    0.0, 0.0, 0.0,
                    POINT_MARKER.size.x, POINT_MARKER.size.y, POINT_MARKER.size.z,
                    POINT_MARKER.color.r, POINT_MARKER.color.g, POINT_MARKER.color.b, POINT_MARKER.color.a,
                    false, true, 2, false, false, false, false
                )
            end

            if #self.points >= 2 then
                for i = 1, #self.points do
                    local current = self.points[i]
                    local next = self.points[(i % #self.points) + 1]

                    debugPoly(current, next)
                end
            end

            Wait(2)
        end
    end)
end