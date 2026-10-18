Collision = {
    status = false
}

local function OnToggleCollisionEntities(enable)
    local ped = PlayerPedId()

    for _, entity in pairs(GetGamePool('CPed')) do
        if entity ~= ped then
            SetEntityNoCollisionEntity(entity, ped, enable)
        end
    end
    for _, entity in pairs(GetGamePool('CVehicle')) do
        SetEntityNoCollisionEntity(entity, ped, enable)
    end

    -- for _, entity in pairs(GetGamePool('CObject')) do
    --     SetEntityNoCollisionEntity(entity, ped, enable)
    -- end
end

function Collision.setDisabled(toggle)
    Collision.status = toggle
    OnToggleCollisionEntities(toggle)
end

function Collision.start()
    CreateThread(function()
        while gCreationState and gCreationState.flag do
            Wait(500)
            OnToggleCollisionEntities(Collision.status)
        end
    end)
end
