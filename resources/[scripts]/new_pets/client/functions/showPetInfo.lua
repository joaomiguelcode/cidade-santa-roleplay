CURRENT_NET_ID_FOCUS = nil

---@param netId number
---@return void
---@diagnostic disable-next-line: lowercase-global
showPetInfo = function(netId)
    CURRENT_NET_ID_FOCUS = netId

    toggleInfoUI(true)
end