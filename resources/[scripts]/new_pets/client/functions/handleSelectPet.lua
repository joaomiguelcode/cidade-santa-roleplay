---@param data table
---@return void
---@diagnostic disable-next-line: lowercase-global
handleSelectPet = function(data)
    TriggerServerEvent('pets.server:selectPet', data)
end