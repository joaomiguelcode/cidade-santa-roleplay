PlayerClassification = {}

function PlayerClassification.GetRole(passport)
    if vRP.HasGroup(passport, 'Admin') then return 'Admin' end
    if vRP.HasGroup(passport, 'Moderador') then return 'Mod' end
    if vRP.HasGroup(passport, 'Policia') then return 'Police' end
    if vRP.HasGroup(passport, 'Paramedico') then return 'Medic' end
    return 'Player'
end
