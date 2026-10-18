---@param isOpen boolean
---@return void
---@diagnostic disable-next-line: lowercase-global
toggleInfoUI = function(isOpen)
    SendNUIMessage({
        action = "VISIBLE_PETINFO",
        data = isOpen
    })
    SetNuiFocus(isOpen, isOpen)
end

---@param isOpen boolean
---@param data table
---@return void
---@diagnostic disable-next-line: lowercase-global
togglePetsUI = function(isOpen, data)
    SendNUIMessage({
        action = "VISIBLE_OWNPETS",
        data = {
            visible = isOpen,
            pets = data
        }
    })
    SetNuiFocus(isOpen, isOpen)
end