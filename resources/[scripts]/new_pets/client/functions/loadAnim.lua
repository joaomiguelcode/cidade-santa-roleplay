---@param dict string
---@return void
---@diagnostic disable-next-line: lowercase-global
loadAnim = function(dict)
    RequestAnimDict(dict)
    repeat Wait(100) until HasAnimDictLoaded(dict)
    RemoveAnimDict(dict)
end