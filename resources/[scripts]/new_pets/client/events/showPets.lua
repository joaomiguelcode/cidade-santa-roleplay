RegisterNetEvent('pets.client:showPets', function(pets, admin)
    local data = {}

    for key, pet in pairs(pets) do
        if (config.modelSettings[pet.model]) then
            data[#data + 1] = {
                id = pet.id,
                name = ResolvePetName(pet.name, pet.model),
                owner = pet.owner,
                age = pet.age,
                type = _t((config.modelSettings[pet.model].type):lower()),
                image = config.modelSettings[pet.model].image
            }
        end
    end

    IS_ADMIN = admin

    togglePetsUI(true, data)
end)
