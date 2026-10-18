---@param owner boolean
---@return table
---@diagnostic disable-next-line: lowercase-global
processInteractions = function(owner)
    local interactions = {}

    if (owner) then
        for _, interaction in ipairs(config.ownerInteractions) do
            local translatedInteraction = {
                label = _t(interaction.label),
                action = interaction.action,
                closeUI = interaction.closeUI,
                animation = interaction.animation,
                minLevel = interaction.minLevel
            }
            table.insert(interactions, translatedInteraction)
        end 
        for _, interaction in ipairs(config.interactions) do
            local translatedInteraction = {
                label = _t(interaction.label),
                action = interaction.action,
                closeUI = interaction.closeUI,
                animation = interaction.animation,
                minLevel = interaction.minLevel
            }
            table.insert(interactions, translatedInteraction)
        end
    else 
        for _, interaction in ipairs(config.interactions) do
            local translatedInteraction = {
                label = _t(interaction.label),
                action = interaction.action,
                closeUI = interaction.closeUI,
                animation = interaction.animation,
                minLevel = interaction.minLevel
            }
            table.insert(interactions, translatedInteraction)
        end
    end

    return interactions
end

---@param NET_ID_FOCUS number
---@return table
---@diagnostic disable-next-line: lowercase-global
getPetInfo = function(NET_ID_FOCUS)
    local entity = NetworkGetEntityFromNetworkId(NET_ID_FOCUS)

    if not DoesEntityExist(entity) then
        return
    end

    local state = Entity(entity).state
    local cuddles = state.pet_cuddles

    local isOwner = state.pet_owner == GetPlayerServerId(PlayerId())
    local hunger, thirst = calculateStatusAt(state.pet_spawnedAt, state.pet_hunger, state.pet_thirst)
    local ownerName =  state.pet_ownerName
    local cuddles = state.pet_cuddles
    local age = state.pet_age

    local modelName = GetEntityArchetypeName(entity)

    local modelSettings = config.modelSettings[modelName] and config.modelSettings[modelName] or config.modelSettings['DEFAULT_CONFIG']

    local petData = {
        name = ResolvePetName(state.pet_name, modelName),
        animal = modelSettings.type,
        age = age,
        image = modelSettings.image,
        hungerLevel = hunger,
        petLevel = state.pet_level,
        countCaresses = cuddles,
        owner = ownerName
    }

    TriggerEvent('Notify', 'Pets', _t('pet_info_menu_level_up', petData.petLevel), 5000)

    local interactions = processInteractions(isOwner)

    return {
        pet = petData,
        interactions = interactions
    }
end
