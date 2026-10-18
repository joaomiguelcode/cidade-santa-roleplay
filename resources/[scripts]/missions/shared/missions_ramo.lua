---@param missionDef table
---@return string|nil
function GetMissionRequiredRamo(missionDef)
	if not missionDef or not missionDef.metadata then
		return nil
	end

	local r = missionDef.metadata.required_ramo

	if type(r) ~= "string" or r == "" then
		return nil
	end

	return string.lower(r)
end

---@param playerRamo string|nil
---@param missionDef table
---@return boolean
function MissionRamoMatchesPlayer(playerRamo, missionDef)
	local req = GetMissionRequiredRamo(missionDef)

	if not req then
		return true
	end

	if not playerRamo or playerRamo == "" then
		return false
	end

	return req == string.lower(playerRamo)
end
