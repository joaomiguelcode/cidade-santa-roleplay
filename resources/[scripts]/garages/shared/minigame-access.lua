local GARAGE_ALLOWED_ACTIVE_MINIGAMES = {
	["Domination"] = true,
}

---@param source Source?
---@return string | boolean | nil
local function GetActiveMinigame(source)
	if IsDuplicityVersion() then
		if not source then
			return nil
		end

		return Player(source).state["minigame:active"]
	end

	return LocalPlayer.state["minigame:active"]
end

---@param source Source?
---@return boolean
function IsGarageBlockedByMinigame(source)
	local activeMinigame = GetActiveMinigame(source)

	if not activeMinigame then
		return false
	end

	if not IsDuplicityVersion() then
		return true
	end

	return GARAGE_ALLOWED_ACTIVE_MINIGAMES[tostring(activeMinigame)] ~= true
end
