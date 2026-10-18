-- Single facade to apply a full saved appearance (clothes + barbershop + tattoos) to a ped.
-- Replaces the 3-call trio duplicated across peds.lua and new_spawn. Accepts either casing of
-- the customisation keys (vrp:GetCharacterCustomisations returns Clothings/Barbershop/Tattooshop;
-- the peds/new_spawn data uses lowercase clothings/barbershop/tattooshop).
--
---@param ped number
---@param custom table -- { Clothings|clothings, Barbershop|barbershop, Tattooshop|tattooshop }
exports( 'ApplyFullAppearanceToPed', function( ped, custom )

    if not custom then
        return
    end

    local clothings  = custom.Clothings  or custom.clothings
    local barbershop  = custom.Barbershop  or custom.barbershop
    local tattooshop  = custom.Tattooshop  or custom.tattooshop

    if clothings then
        exports['skinshop']:Apply( clothings, ped )
    end

    if barbershop then
        -- ped ~= nil => character-creator applies to this ped without persisting to the player
        TriggerEvent( 'net.character-creator.set-customization', barbershop, ped )
    end

    if tattooshop then
        exports['tattooshop']:Apply( tattooshop, ped )
    end
end )
