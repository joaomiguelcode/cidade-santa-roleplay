---@param entity number
---@return void
---@diagnostic disable-next-line: lowercase-global
petSetters = function(entity)
    TaskSetBlockingOfNonTemporaryEvents(entity, true)
    SetEntityInvincible(entity, true)
    SetEntityCanBeDamaged(entity, false)
    SetPedCanBeTargetted(entity, false)
    SetPedCanBeDraggedOut(entity, false)
    SetPedCanRagdollFromPlayerImpact(entity, false)
    SetPedStayInVehicleWhenJacked(entity, true)

    local ped = PlayerPedId()

    -- print('adding relationship group')

    AddRelationshipGroup("PETS")
    SetPedRelationshipGroupHash(entity, `PETS`)
    SetRelationshipBetweenGroups(0, `PETS`, `PLAYER`)
    SetRelationshipBetweenGroups(0, `PLAYER`, `PETS`)
    SetEntityCanBeDamagedByRelationshipGroup(ped, false, `PETS`)
    SetEntityCanBeDamagedByRelationshipGroup(entity, false, `PLAYER`)

    -- Configurar o pet para ignorar outros jogadores
    SetPedCanBeTargettedByPlayer(entity, -1, false)
    SetPedCanBeTargetted(entity, false)
    SetCanAttackFriendly(entity, false, false)

    -- Configurar comportamento do pet
    SetPedAlertness(entity, 0)
    SetPedCombatRange(entity, 0)
    SetPedFleeAttributes(entity, 0, false)
    SetPedCombatAttributes(entity, 46, false) -- Não atacar outros peds
    SetPedCombatAttributes(entity, 5, false)  -- Não fugir de combate
    SetPedCombatAttributes(entity, 17, false) -- Não usar cobertura

    return true, 'Pet setters'
end
