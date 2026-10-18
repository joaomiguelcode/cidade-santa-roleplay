config = {}

config.DEFAULT_PET_MODEL = 'mp_f_freemode_01' -- default ped model for new pets

config.dataMigration = false -- if true, will migrate the data from the old database to the new one
config.warnCooldown = true -- warn the player when the cooldown is active
config.lostBlipSprite = 161 -- blip sprite for lost pets
config.cuddlesPerDay = 3 -- how many times a player can cuddle a pet per day
config.HUNGER_RATE = 1.0 -- rate at which hunger decreases per minute
config.THIRST_RATE = 2.0 -- rate at which thirst increases per minute

config.warpDistance = 25.0 -- distance at which the pet will be warped to the owner

-- level system
config.levelSystem = {
    enabled = true, -- enable/disable level system
    cuddlesForMaxLevel = 500, -- cuddles needed to reach max level
    maxLevel = 100, -- max level
    cuddlesPerLevel = function() -- function to calculate cuddles per level
        return config.levelSystem.cuddlesForMaxLevel / config.levelSystem.maxLevel
    end
}

config.feed = {
    amount   = 10, -- amount of hunger restored when feeding the pet
    consumes = {
        ['money'] = 10000, -- amount of money consumed when feeding the pet
    }
}

config.modelSettings = { -- model settings for new pets
    ['DEFAULT_CONFIG'] = {
        name = 'Pet',
        type = 'Pet',
        image = 'https://santaimagens.roleplayrp.com/img/imagens_variadas/pets/A_C_Husky_2.png'
    },
    ['a_c_chimp'] = {
        name = 'Chimp',
        type = 'chimp',
        image = 'https://santaimagens.roleplayrp.com/img/imagens_variadas/pets/a_c_chimp.png',
        vaultItemId = 'petchimp',
    },
    ['a_c_rhesus'] = {
        name = 'Rhesus',
        type = 'Pet',
        image = 'https://santaimagens.roleplayrp.com/img/imagens_variadas/pets/a_c_rhesus.png',
        vaultItemId = 'petrhesus',
    },
    ['crocodilo'] = {
        name = 'Crocodilo',
        type = 'Crocodile',
        image = 'https://santaimagens.roleplayrp.com/img/imagens_variadas/pets/crocodilo.png',
        vaultItemId = 'petcrocodilo',
    },
    ['dog_jully'] = {
        name = 'dog_jully',
        type = 'Pet',
        image = 'https://santaimagens.roleplayrp.com/img/imagens_variadas/pets/dog_jully.png',
        vaultItemId = 'petjully',
    },
    ['a_c_chop'] = {
        name = 'Rottweiler',
        type = 'Dog',
        image = 'https://santaimagens.roleplayrp.com/img/pets/Rottweiler.png',
        vaultItemId = 'petrottweiler',
    },
    ['a_c_deer'] = {
        name = 'Urso',
        type = 'Bear',
        image = 'https://santaimagens.roleplayrp.com/img/pets/Urso.png',
        vaultItemId = 'peturso',
    },
    ['A_C_Retriever_2'] = {
        name = 'Golden Retriever',
        type = 'Dog',
        image = 'https://santaimagens.roleplayrp.com/img/pets/golden.png',
        vaultItemId = 'petretriever',
    },
    ['a_c_pug'] = {
        name = 'Pug',
        type = 'Dog',
        image = 'https://santaimagens.roleplayrp.com/img/pets/Pug.png',
        vaultItemId = 'petpug',
    },
    ['ft-fbulldog'] = {
        name = 'Bulldog',
        type = 'Dog',
        image = 'https://santaimagens.roleplayrp.com/img/pets/Bulldog.png',
        vaultItemId = 'petbulldog',
    },
    ['ft_greyhound'] = {
        name = 'Greyhound',
        type = 'Dog',
        image = 'https://santaimagens.roleplayrp.com/img/pets/Greyhound.png',
        vaultItemId = 'petgreyhound',
    },
    ['A_C_Husky_2'] = {
        name = 'Husky Siberiano',
        type = 'Dog',
        image = 'https://santaimagens.roleplayrp.com/img/pets/HuskySiberiano.png',
        vaultItemId = 'pethusky',
    },
    ['A_C_shepherd_2'] = {
        name = 'Pastor Alemão',
        type = 'Dog',
        image = 'https://santaimagens.roleplayrp.com/img/pets/PastorAlemao.png',
        vaultItemId = 'petshepherd',
    },
    ['a_c_poodle_2'] = {
        name = 'Poodle',
        type = 'Dog',
        image = 'https://santaimagens.roleplayrp.com/img/pets/Poodle.png',
        vaultItemId = 'petpoodle',
    },
    ['a_c_sheep'] = {
        name = 'Ovelha',
        type = 'Sheep',
        image = 'https://santaimagens.roleplayrp.com/img/inventory/a_c_sheep.png',
        vaultItemId = 'petovelha',
    },
    ['a_c_panda'] = {
        name = 'Panda',
        type = 'Panda',
        image = 'https://cdn.santagroup.gg/petpanda.webp',
        vaultItemId = 'petpanda',
    },
    ['a_c_boar'] = {
        name = 'Javali',
        type = 'Boar',
        image = 'https://santaimagens.roleplayrp.com/img/inventory/petjavali.png',
        vaultItemId = 'petjavali',
    },
    ['dragaolcfr'] = {
        name = 'Dragão',
        type = 'Dragon',
        image = 'https://santaimagens.roleplayrp.com/img/inventory/dragaolcfr.png',
        vaultItemId = 'dragaolcfr',
    },
    ['DragaoLCFR'] = {
        name = 'Dragão',
        type = 'Dragon',
        image = 'https://santaimagens.roleplayrp.com/img/inventory/dragaolcfr.png'
    },
    ['Dragao1'] = {
        name = 'Dragão Fúria',
        type = 'Dragon',
        image = 'https://cdn.santagroup.gg/dragao1.webp',
        vaultItemId = 'petdragao1',
    },
    ['Dragao2'] = {
        name = 'Dragão Lunar',
        type = 'Dragon',
        image = 'https://cdn.santagroup.gg/dragao2.webp',
        vaultItemId = 'petdragao2',
    },
    ['Dragao3'] = {
        name = 'Dragão Colosso',
        type = 'Dragon',
        image = 'https://cdn.santagroup.gg/petdragao3.webp',
        vaultItemId = 'petdragao3',
    },
    ['Dragao4'] = {
        name = 'Dragão Soberano',
        type = 'Dragon',
        image = 'https://cdn.santagroup.gg/pets/dragao4.webp',
        vaultItemId = 'petdragao4',
    },
    ['Dragao5'] = {
        name = 'Dragão Celestial',
        type = 'Dragon',
        image = 'https://cdn.santagroup.gg/pets/dragao5.webp',
        vaultItemId = 'petdragao5',
    },
    ['Dragao6'] = {
        name = 'Dragão Abissal',
        type = 'Dragon',
        image = 'https://cdn.santagroup.gg/pets/dragao6.webp',
        vaultItemId = 'petdragao6',
    },
    ['Dragao7'] = {
        name = 'Dragão Boreal',
        type = 'Dragon',
        image = 'https://cdn.santagroup.gg/pets/dragao7.webp',
        vaultItemId = 'petdragao7',
    },
    ['Dragao8'] = {
        name = 'Dragão Ônix',
        type = 'Dragon',
        image = 'https://cdn.santagroup.gg/pets/dragao8.webp',
        vaultItemId = 'petdragao8',
    },
    ['canecorso'] = {
        name = 'Cane Corso',
        type = 'Dog',
        image = 'https://santaimagens.roleplayrp.com/img/imagens_variadas/pets/canecorso.png',
        vaultItemId = 'petcanecorso',
    },
    ['doberman'] = {
        name = 'Doberman',
        type = 'Dog',
        image = 'https://santaimagens.roleplayrp.com/img/imagens_variadas/pets/doberman.png',
        vaultItemId = 'petdoberman',
    },
    ['a_c_cat_01'] = {
        name = 'Siamês',
        type = 'Cat',
        image = 'https://santaimagens.roleplayrp.com/img/pets/gato.png',
        vaultItemId = 'petcat',
    },
    ['sphynx'] = {
        name = 'Sphynx',
        type = 'Cat',
        image = 'https://santaimagens.roleplayrp.com/img/imagens_variadas/pets/sphynx.png',
        vaultItemId = 'petsphynx',
    },
    ['Rajah'] = {
        name = 'Rajah',
        type = 'Cat',
        image = 'https://santaimagens.roleplayrp.com/img/pets/Rajah.png',
        vaultItemId = 'Rajah',
    },
    ['Tigor'] = {
        name = 'Tigor',
        type = 'Tiger',
        image = 'https://santaimagens.roleplayrp.com/img/pets/Tigor.png',
        vaultItemId = 'Tigor',
    },
    ['LoboSirius'] = {
        name = 'LoboSirius',
        type = 'Tiger',
        image = 'https://santaimagens.roleplayrp.com/img/pets/Loboaguado.png',
        vaultItemId = 'LoboSirius',
    },
    ['a_c_westy_2'] = {
        name = 'Yorkshire Terrier',
        type = 'Dog',
        image = 'https://santaimagens.roleplayrp.com/img/pets/Yorkshire.png',
        vaultItemId = 'petwesty',
    },
}

config.interactions = { -- interactions for non-owners
    {
        label = 'task_cuddle',
        action  = 'cuddle'
    },
}

config.ownerInteractions = { -- interactions for owners
    {
        label = 'task_retrieve',
        action = 'retrieve',
        closeUI = true,
    },
    {
        label = 'task_carry',
        action = 'carry',
        closeUI = true,
    },
    {
        label = 'task_follow',
        action = 'follow',
        closeUI = true,
    },
    {
        label = 'task_getup',
        action  = 'getup',
        animation = {
            default = { -- default animation
                dict = "creatures@rottweiler@amb@world_dog_sitting@exit",
                name = "exit",
            },
        },
        closeUI = true,
        minLevel = 10
    },
    {
        label = 'task_sit',
        action = 'sit',
        animation = {
            default = {
                dict = "creatures@rottweiler@amb@world_dog_sitting@idle_a",
                name = "idle_b",
            },
        },
        closeUI = true,
        minLevel = 10,
    },
    {
        label = 'task_sex',
        action = 'sex',
        animation = {
            default = {
                dict = "creatures@rottweiler@amb@",
                name = "hump_loop_chop",    
            },
        },
        closeUI = true,
        minLevel = 10,
    },
    {
        label = 'task_sleep',
        action = 'sleep',   
        animation = {
            default = {
                dict = "creatures@rottweiler@amb@sleep_in_kennel@",
                name = "sleep_in_kennel",
            },
        },
        closeUI = true,
    },
    {
        label = 'task_bark',
        action = 'bark',
        animation = {
            default = { 
                dict = "creatures@rottweiler@amb@world_dog_barking@idle_a",
                name = "idle_a",
            },
        },
        closeUI = true,
        minLevel = 10,
    },
    {
        label = 'task_feed',
        action = 'feed',
        closeUI = true
    },
    {
        label = 'task_rename',
        action = 'rename_pet',
    },
}
