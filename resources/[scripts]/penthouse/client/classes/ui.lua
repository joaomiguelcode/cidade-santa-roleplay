PenthouseUI = class()

function PenthouseUI:__init()
    self.visible = false
    self.elevatorVisible = false
    self.doorbellVisible = false
    self.editVisible = false
end

---@param visible boolean
---@param view string|nil
---@return void
function PenthouseUI:showRealEstateMenu(visible, view)
    SetPenthouseVersion()

    SendNUIMessage({
        action = 'PENTHOUSE_SHOWHOME',
        data = visible
    })

    SetNuiFocus(visible, visible)
    self.visible = visible
end

---@param visible boolean
---@return void
function PenthouseUI:showElevator(visible)
    SendNUIMessage({
        action = "PENTHOUSE_SHOWELEVATOR",
        data = visible
    })

    SetPenthouseVersion()

    SetNuiFocus(visible, visible)
    self.elevatorVisible = visible
end

---@return void
function PenthouseUI:hideElevator()
    self:showElevator(false)
end

---@param visible boolean
---@param houseData table|nil
---@return void
function PenthouseUI:showEditPenthouse(visible, houseData)
    SetNuiFocus(visible, visible)
    
    SendNUIMessage({
        action = 'PENTHOUSE_SHOWEDIT',
        data = {
            visible = visible,
            house = houseData or {}
        }
    })

    SetPenthouseVersion()

    print(json.encode(houseData))

    self.editVisible = visible
end

---@param penthouse table
---@return void
function PenthouseUI:updatePenthouseData(penthouse)
    SendNUIMessage({
        action = 'penthouseDataUpdate',
        data = penthouse
    })

    SetPenthouseVersion()
end

---@param visible boolean
---@param data table|nil
---@return void
function PenthouseUI:showDoorbellModal(visible, data)
    SetNuiFocus(visible, visible)

    SendNUIMessage({
        action = 'visibleDoorbellModal',
        data = visible
    })

    self.doorbellVisible = visible

    if data then
        Wait(300)
        local penthouse = data.penthouse

        SendNUIMessage({
            action = 'doorbellModalData',
            data = {
                id = penthouse.id,
                name = penthouse.name,
                ownerName = penthouse.name,
                isOnline = true
            }
        })
    end
end

---@return boolean
function PenthouseUI:isAnyMenuVisible()
    return self.visible or self.elevatorVisible or self.doorbellVisible or self.editVisible
end

---@return void
function PenthouseUI:closeAll()
    if self.visible then
        self:showRealEstateMenu(false)
    end
    
    if self.elevatorVisible then
        self:showElevator(false)
    end
    
    if self.doorbellVisible then
        self:showDoorbellModal(false)
    end
    
    if self.editVisible then
        self:showEditPenthouse(false)
    end
end

