
---@class conversations.ConversationButtonDef
---@field id number
---@field label string
---@field icon string React.Icons https://react-icons.github.io/react-icons/
---@field enabled boolean
---@field onCallback function

---@class conversations.ConversationAudioDef
---@field url string
---@field duration number -- Duration in seconds
---@field autoPlay boolean
---@field loop boolean
---@field volume number -- Volume between 0.0-1.0

---@class conversations.ConversationPedDef
---@field model string
---@field animation? conversations.ConversationAnimationDef
---@field animationStages? conversations.ConversationAnimationDef[]

---@class conversations.ConversationAnimationDef
---@field dict string
---@field anim string
---@field timeout? number

---@class conversations.ConversationDef
---@field id string
---@field theme string?
---@field name string
---@field tag string
---@field description string
---@field escText? string -- Texto exibido na tecla de fechar (ex: "para fechar")
---@field coords vector4
---@field visible boolean
---@field buttons conversations.ConversationButtonDef[]
---@field backgroundImage? string
---@field audio? conversations.ConversationAudioDef
---@field entityId? number
---@field buckets? table<number, boolean> -- Routing buckets onde o NPC deve ser visível
---@field ped? conversations.ConversationPedDef
---@field overrideDescription? string
---@field icon? string
---@field resource? string -- Resource que criou esta conversa
---@field renderDistance? number
---@field activeDistance? number

---@class conversations.PedConversationData
---@field id string
---@field coords vector4
---@field conversationId number
---@field model? string
---@field animation? conversations.ConversationAnimationDef
---@field animationStages? conversations.ConversationAnimationDef[]
---@field theme? string

---@type table<number, conversations.ConversationDef>
gConversationDefinitions = { }

---@type table<number, table<number, conversations.ConversationButtonDef>>
local gConversationButtonCallbacks = { }

---@type table<string, conversations.PedConversationData>
local gPedConversationData = { }

---@type number
local gNextConversationId = 0

---@diagnostic disable-next-line: lowercase-global
IS_SERVER = GetGameName() == 'fxserver'
IS_CLIENT = not IS_SERVER

---@class conversations
conversations = {}


---@param conversationId number
---@param conversationData conversations.ConversationDef
function RegisterConversationDefinition( conversationId, conversationData )
	
	assert( type( conversationId ) == 'number', 'Invalid conversationId' )
	
	assert( type( conversationData ) == 'table', 'Invalid conversationData' )
	
	assert( type( conversationData.buttons ) == 'table', 'Invalid buttons array' )
	
	-- sx.logger:debug( ('Registering conversation definition for id=%d'):format( conversationId ) )
	
	local processedButtons = {}
	
	-- Inicializar storage de botões para esta conversa
	gConversationButtonCallbacks[ conversationId ] = {}
	
	for i = 1, #conversationData.buttons do
		
		local button = conversationData.buttons[i]
		
		assert( type( button ) == 'table', ('Invalid button at index %d'):format( i ) )

		assert( type( button.label ) == 'string', ('Invalid button label at index %d'):format( i ) )

		-- Gerar ID numérico baseado no índice
		local buttonId = i
		
		-- Criar novo objeto de botão com ID numérico
		local processedButton = {
			id         = buttonId,
			label      = button.label,
			icon       = button.icon,
			enabled    = button.enabled,
			onCallback = button.onCallback
		}
		
		gConversationButtonCallbacks[ conversationId ][ buttonId ] = processedButton

		processedButtons[ #processedButtons + 1 ] = processedButton
	end
	
	local processedAudio = nil
	if conversationData.audio then
		processedAudio = {
			url = conversationData.audio.url,
			duration = conversationData.audio.duration,
			autoPlay = conversationData.audio.autoPlay or false,
			loop = conversationData.audio.loop or false,
			volume = conversationData.audio.volume
		}

		if processedAudio.volume < 0.0 or processedAudio.volume > 1.0 then

			-- sx.logger:warn( ('Invalid volume %.2f for conversation %d, using default %.2f'):format( processedAudio.volume, conversationId, conversations.ConversationAudioVolume.MEDIUM ) )

			processedAudio.volume = conversations.ConversationAudioVolume.MEDIUM
		end
		
		if processedAudio.duration <= 0 then

			-- sx.logger:warn( ('Invalid duration %d for conversation %d, using default %d'):format( processedAudio.duration, conversationId, conversations.ConversationAudioDuration.MEDIUM ) )

			processedAudio.duration = conversations.ConversationAudioDuration.MEDIUM
		end
	end
	
	local conversationDef = {
		id              = conversationId,
		visible         = conversationData.visible,
		name            = conversationData.name,
		tag             = conversationData.tag,
		description     = conversationData.description,
		escText         = conversationData.escText,
		coords          = conversationData.coords,
		buttons         = processedButtons,
		backgroundImage = conversationData.backgroundImage,
		audio           = processedAudio,
		buckets         = conversationData.buckets,
		ped             = conversationData.ped,
		icon            = conversationData.icon,
		resource        = conversationData.resource,
		theme           = conversationData.theme,
		renderDistance  = conversationData.renderDistance,
		activeDistance  = conversationData.activeDistance
	}
	
	gConversationDefinitions[ conversationId ] = conversationDef
	
	-- sx.logger:info( ('Conversation definition registered successfully for id=%d with %d buttons'):format( conversationId, #processedButtons ) )
end

---@param conversationId number
---@return conversations.ConversationDef|nil
function GetConversationDefinition( conversationId )
	
	assert( type( conversationId ) == 'number', 'Invalid conversationId' )
	
	local conversationDef = gConversationDefinitions[ conversationId ]
	
	if not conversationDef then
		-- sx.logger:error( ('Conversation definition with id=%d not found!'):format( conversationId ) )

		return
	end
	
	return conversationDef
end

---@param conversationId number
---@param buttonId number
---@return conversations.ConversationButtonDef|nil
function GetConversationButtonDefinition( conversationId, buttonId )
	
	assert( type( conversationId ) == 'number', 'Invalid conversationId' )
	assert( type( buttonId ) == 'number', 'Invalid buttonId' )
	
	local conversationButtons = gConversationButtonCallbacks[ conversationId ]
	if not conversationButtons then
		-- sx.logger:error( ('Conversation %d not found for button lookup!'):format( conversationId ) )
		return
	end
	
	local buttonDef = conversationButtons[ buttonId ]
	
	if not buttonDef then
		-- sx.logger:error( ('Conversation button with id=%d not found in conversation %d!'):format( buttonId, conversationId ) )

		return
	end
	
	return buttonDef
end

---@param conversationId number
---@return boolean
function IsConversationDefinitionValid( conversationId )

	assert( type( conversationId ) == 'number', 'Invalid conversationId' )

	return gConversationDefinitions[ conversationId ] ~= nil
end

---@param pedId string
---@param pedData conversations.PedConversationData
function RegisterPedConversationData( pedId, pedData )
	
	assert( type( pedId ) == 'string' and pedId ~= '', 'Invalid pedId' )
	
	assert( type( pedData ) == 'table', 'Invalid pedData' )

	assert( type( pedData.conversationId ) == 'number', 'Invalid conversationId in pedData' )
	
	-- sx.logger:debug( ('Registering ped conversation data for pedId="%s" conversationId=%d'):format( pedId, pedData.conversationId ) )
	
	if not IsConversationDefinitionValid( pedData.conversationId ) then
		-- sx.logger:error( ('Conversation %d not found for ped "%s"'):format( pedData.conversationId, pedId ) )

		return
	end
	
	gPedConversationData[ pedId ] = pedData
	
	-- sx.logger:info( ('Ped conversation data registered successfully for pedId="%s"'):format( pedId ) )
end

---@param pedId string
---@return conversations.PedConversationData|nil
function GetPedConversationData( pedId )
	
	assert( type( pedId ) == 'string' and pedId ~= '', 'Invalid pedId' )
	
	local pedData = gPedConversationData[ pedId ]
	
	if not pedData then
		-- sx.logger:error( ('Ped conversation data with pedId="%s" not found!'):format( pedId ) )
		return
	end
	
	return pedData
end

---@param pedId string
---@return boolean
function IsPedConversationDataValid( pedId )
	
	if type( pedId ) ~= 'string' or pedId == '' then
		return
	end
	
	return gPedConversationData[ pedId ] ~= nil
end

---@param conversationId number
---@param buttonId number
function ExecuteConversationButtonCallback( conversationId, buttonId )
	
	assert( type( conversationId ) == 'number', 'Invalid conversationId' )

	assert( type( buttonId ) == 'number', 'Invalid buttonId' )
	
	-- sx.logger:debug( ('Executing conversation button callback for conversationId=%d buttonId=%d'):format( conversationId, buttonId ) )
	
	if not IsConversationDefinitionValid( conversationId ) then
		-- sx.logger:error( ('Conversation %d not found'):format( conversationId ) )
	end
	
	local buttonDef = GetConversationButtonDefinition( conversationId, buttonId )
	
	if not buttonDef then
		return
	end
		
	local success, err = pcall( buttonDef.onCallback, conversationId )
	
	if not success then
		-- sx.logger:error( ('Conversation button callback failed for buttonId=%d: %s'):format( buttonId, tostring( err ) ) )

		return
	end

	-- sx.logger:info( ('Conversation button callback executed successfully for buttonId=%d'):format( buttonId ) )
end

---@param conversationId number
function RemoveConversationData( conversationId )
	
	-- Remover dados do ped
	local pedId = ('conversation_ped_%d'):format( conversationId )
	gPedConversationData[ pedId ] = nil
	
	-- Remover callbacks dos botões
	gConversationButtonCallbacks[ conversationId ] = nil
	
	-- Remover definição
	gConversationDefinitions[ conversationId ] = nil
	
	-- sx.logger:debug( ('Removed conversation data for id=%d'):format( conversationId ) )
end


---@param conversationData conversations.ConversationDef
---@return number|nil conversationId
function CreateConversation( conversationData )
	
	assert( type( conversationData ) == 'table', 'Invalid conversationData' )
	
	gNextConversationId += 1

	local conversationId = gNextConversationId
	
	if IsConversationDefinitionValid( conversationId ) then
		
		print( ('Conversation with id %d already exists'):format( conversationId ) )

		return
	end
	
	if not conversationData.coords then

		print( ('Conversation with id %d has no coords'):format( conversationId ) )

		return
	end 

	local pedId = ('conversation_ped_%d'):format( conversationId )
	
	---@type conversations.PedConversationData
	local pedData = {
		id               = pedId,
		coords           = conversationData.coords,
		conversationId   = conversationId,
		model            = conversationData.ped and conversationData.ped.model,
		animation        = conversationData.ped and conversationData.ped.animation,
		animationStages  = conversationData.ped and conversationData.ped.animationStages,
		theme            = conversationData.theme,
	}
	
	RegisterConversationDefinition( conversationId, conversationData )
	
	RegisterPedConversationData( pedId, pedData )
	
	-- NPCs serão criados pelo worker de streaming baseado na distância
	-- Não criamos mais automaticamente aqui
	
	return conversationId
end
