
--[[
    Esse filtro é utilizado da seguinte maneira.
    - Quando uma interação não carrega uma animação no corpo do proprio player.
     - não limpamos a interação e sim deixamos ele apenas executar uma animação, mas caso isso seja diferente a interação vai ser limpa.
]]

local function ShouldRemoveObjectsStopScriptedInteractionWithFilter()

	local ok, shouldStop = pcall( function()
		return IsRunningPedAnimatedScriptedInteraction()
	end)

	if ok then
		return shouldStop
	end

	if sx and sx.logger then
		sx.logger:warn( ('vrp:removeObjects scripted_interactions auto policy failed: %s'):format( tostring( shouldStop ) ) )
	end

	return true
end

-- eventos onde são invocados o exports.scripted_interactions:stopScriptedInteraction e que devem ser filtrados
local EVENTS_LIST = {'vrp:removeObjects'}

for index, eventName in pairs(EVENTS_LIST) do 
    RegisterNetEvent(eventName,function()
        if exports.scripted_interactions:isRunningAnyScriptedInteraction() and ShouldRemoveObjectsStopScriptedInteractionWithFilter() then
            exports.scripted_interactions:stopScriptedInteraction( false )
        end
    end)
end