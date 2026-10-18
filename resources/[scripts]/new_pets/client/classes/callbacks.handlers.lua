nuiHandlers = {
    ['CLOSE_PETS'] = {
        handler = function(data)
            SetNuiFocus(false, false)
            toggleInfoUI(false)
            return true
        end,
        cooldown = 1000,
    },
    ['GET_PETINFO'] = {
        handler = function(data)
            return getPetInfo(CURRENT_NET_ID_FOCUS)
        end,
        cooldown = 1000,
    },
    ['RENAME_PET'] = {
        handler = function(data)

            if not CURRENT_NET_ID_FOCUS then
                return { success = false, errorCode = 'pet_not_found' }
            end

            local name = type(data) == 'table' and data.name or nil
            local response = vSERVER.RenamePet(CURRENT_NET_ID_FOCUS, name)

            return response or { success = false, errorCode = 'rename_failed' }
        end,
        cooldown = 1000,
    },
    ['getCityId'] = {
        handler = function(data)
            return city
        end,
        cooldown = 1000,
    },
    ['getCityName'] = {
        handler = function(data)
            return city
        end,
        cooldown = 1000,
    },
    ['getServerHost'] = {
        handler = function(data)
            return GetConvar('api_url', '')
        end,
        cooldown = 1000,
    },
    ['HANDLE_PETINTERACTION'] = {
        handler = function(data)

            if type(data) ~= 'table' or data.action == 'sex' then
                return false
            end

            local success, err = handlePetInteraction(CURRENT_NET_ID_FOCUS, data.action)

            if (not success) then
                print(err)
                return false
            end

            return true, 'Pet interaction handled.'
        end,
        cooldown = 1000,
    },

    ['HANDLE_SELECTPET'] = {
        handler = function(data)
            return handleSelectPet(data.pet)
        end,
        cooldown = 1000,
    },

}
