---@class DamageStates
---@field threshold number
---@field name string

---@type DamageStates[]
local damageStates = {
    {
        threshold = 10,
        name = "destroyed"
    },
    {
        threshold = 400,
        name = "broken"
    },
    {
        threshold = 1000,
        name = "normal"
    }
}

---Get the damage state of a vehicle based on its engine health.
---@param vehicle number The vehicle entity.
---@return string The damage state: "normal", "broken", or "destroyed".
local function GetDamageState(vehicle)
    if not DoesEntityExist(vehicle) then
        return "destroyed"
    end
    
    local engineHealth = GetVehicleEngineHealth(vehicle)

    for i = 1, #damageStates do
        local state = damageStates[i]
        if engineHealth <= state.threshold then
            return state.name
        end
    end
end exports("GetDamageState", GetDamageState)