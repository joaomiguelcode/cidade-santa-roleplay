---@enum AnimationStage
AnimationStage = {
	IDLE        = 1,
	TALKING     = 2,
	INTERACTING = 3
}

---@class AnimationStageManager
---@field currentStage AnimationStage
---@field entityId number
---@field animationStages conversations.ConversationAnimationDef[]
---@field resetTimer number|nil
local AnimationStageManager = { }

---@type table<number, AnimationStageManager>
local gAnimationManagers = { }

---@param entityId number
---@param animDef conversations.ConversationAnimationDef
local function PlayAnimation( entityId, animDef )
	
	assert( DoesEntityExist( entityId ), 'Entity does not exist' )
	
	assert( type( animDef ) == 'table', 'Invalid animation definition' )
	
	assert( type( animDef.dict ) == 'string' and animDef.dict ~= '', 'Invalid animation dict' )
	
	assert( type( animDef.anim ) == 'string' and animDef.anim ~= '', 'Invalid animation name' )
	
	
	local timeout = 0
	while not HasAnimDictLoaded( animDef.dict ) and timeout < 50 do
		Wait( 0 )
		RequestAnimDict( animDef.dict )
		timeout = timeout + 1
	end
	
	if not HasAnimDictLoaded( animDef.dict ) then

		-- sx.logger:warn( ('Failed to load animation dict "%s"'):format( animDef.dict ) )

		return
	end
	
	ClearPedTasks( entityId )
	TaskPlayAnim( entityId, animDef.dict, animDef.anim, 8.0, -8.0, -1, 1, 0, false, false, false )
	
	return true
end

---@param entityId number
---@param animationStages conversations.ConversationAnimationDef[]
---@return AnimationStageManager|nil
function CreateAnimationStageManager( entityId, animationStages )
	
	assert( DoesEntityExist( entityId ), 'Entity does not exist' )
	
	assert( type( animationStages ) == 'table', 'Invalid animationStages: expected table' )
	
	if #animationStages > 3 then
        
		-- sx.logger:error( ('Invalid animationStages count: expected 3, got %d'):format( #animationStages ) )

		return
	end
	
	if gAnimationManagers[ entityId ] then

		-- sx.logger:warn( ('Animation manager already exists for entityId=%d'):format( entityId ) )

		return gAnimationManagers[ entityId ]
	end
	
	-- sx.logger:debug( ('Creating animation stage manager for entityId=%d'):format( entityId ) )
	
	-- Extrair timeout do estágio INTERACTING se disponível, senão usar padrão de 10 segundos
	local interactionStage = animationStages[ AnimationStage.INTERACTING ]
	local defaultTimeout = interactionStage and ( interactionStage.timeout or 10000 ) or 10000
	
	---@type AnimationStageManager
	local manager = {
		currentStage     = AnimationStage.IDLE,
		entityId         = entityId,
		animationStages  = animationStages,
        animationTimeout = defaultTimeout,
		resetTimer       = nil
	}
	
	gAnimationManagers[ entityId ] = manager
	
	local idleAnim = animationStages[ AnimationStage.IDLE ]
	PlayAnimation( entityId, idleAnim )
	
	-- sx.logger:info( ('Animation stage manager created for entityId=%d'):format( entityId ) )
	
	return manager
end

---@param entityId number
---@param stage AnimationStage
function SetAnimationStage( entityId, stage )
	
	assert( DoesEntityExist( entityId ), 'Entity does not exist' )
	
	assert( type( stage ) == 'number', 'Invalid stage: expected number' )
	
	local manager = gAnimationManagers[ entityId ]
	
	if not manager then
		
        -- sx.logger:warn( ('Animation manager not found for entityId=%d'):format( entityId ) )

		return
	end
	
	if manager.currentStage == stage then

		-- sx.logger:debug( ('Entity %d already in stage %d'):format( entityId, stage ) )

		return
	end
	
	if manager.resetTimer then
		ClearTimeout( manager.resetTimer )
		manager.resetTimer = nil
	end
	
	-- sx.logger:debug( ('Setting animation stage for entityId=%d from %d to %d'):format( entityId, manager.currentStage, stage ) )
	
	manager.currentStage = stage
	
	local animDef = manager.animationStages[ stage ]
	
	if not animDef then

		-- sx.logger:error( ('Animation definition not found for stage %d'):format( stage ) )

		return
	end
	
	local successPlayAnimation = PlayAnimation( entityId, animDef )
	
	if successPlayAnimation then
		-- sx.logger:info( ('Animation stage set to %d for entityId=%d'):format( stage, entityId ) )
	end
	
	if stage == AnimationStage.INTERACTING then
		
		-- sx.logger:debug( ('Setting reset timer for entityId=%d'):format( entityId ) )
		
		manager.resetTimer = SetTimeout( manager.animationTimeout or 10000, 
            function( )
			
                -- sx.logger:debug( ('Reset timer triggered for entityId=%d'):format( entityId ) )
                
                if DoesEntityExist( entityId ) and gAnimationManagers[ entityId ] then
                    SetAnimationStage( entityId, AnimationStage.IDLE )
                end
                
                manager.resetTimer = nil
		    end
        )
	end
end

---@param entityId number
---@return AnimationStage|nil
function GetCurrentAnimationStage( entityId )
	
	local manager = gAnimationManagers[ entityId ]
	
	if not manager then
		return
	end

	return manager.currentStage
end

---@param entityId number
function DestroyAnimationStageManager( entityId )
	
	-- sx.logger:debug( ('Destroying animation stage manager for entityId=%d'):format( entityId ) )
	
	local manager = gAnimationManagers[ entityId ]
	
	if not manager then

		-- sx.logger:warn( ('Animation manager not found for entityId=%d'):format( entityId ) )

		return
	end
	
	if manager.resetTimer then
		ClearTimeout( manager.resetTimer )
		manager.resetTimer = nil
	end
	
	if DoesEntityExist( entityId ) then
		ClearPedTasks( entityId )
	end
	
	gAnimationManagers[ entityId ] = nil
	
	-- sx.logger:info( ('Animation stage manager destroyed for entityId=%d'):format( entityId ) )
end

