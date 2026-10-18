---@class pededitor.RedeemConstraints
---@field maxOptions integer
---@field maxSelectionLimit integer
---@field maxPendingPackages integer
---@field maxDurationDays integer
---@field maxModelLength integer
---@field sessionTtlSeconds integer
---@field expirationBatchSize integer
---@field swapWindowHours integer

---@class pededitor.RedeemCatalogEntry
---@field name string
---@field model string
---@field image string
---@field category string

---@class pededitor.Config
---@field blockedModels table<string, boolean>
---@field nativeModelPrefixes string[]
---@field redeem { constraints: pededitor.RedeemConstraints, catalog: table<string, pededitor.RedeemCatalogEntry>, defaultModels: table<string, boolean> }

---@type pededitor.Config
gPedEditorConfig = {
    blockedModels = {
        a_c_rhesus = true,
        a_c_stingray = true,
        a_c_sharktiger = true,
        a_c_sharkhammer = true,
        a_c_killerwhale = true,
        a_c_humpback = true,
        a_c_fish = true,
        a_c_dolphin = true,
        a_c_boar = true,
        a_c_rat = true,
        a_f_m_bodybuild_01 = true,
        a_f_m_beach_01 = true,
        a_f_m_fatblk_01 = true,
        a_f_m_ktown_01 = true,
        a_f_m_ktown_02 = true,
        a_f_y_gencaspat_01 = true,
        a_f_y_skater_01 = true,
        a_f_y_vinewood_01 = true,
        a_m_m_socenlat_01 = true,
        a_m_o_soucent_02 = true,
        a_m_y_gencaspat_01 = true,
        a_m_y_skater_01 = true,
        csb_customer = true,
        cs_customer = true,
        g_m_importexport_01 = true,
        g_m_m_mexboss_01 = true,
        g_m_m_mexboss_02 = true,
        g_m_y_ballasout_01 = true,
        g_m_y_mexgang_01 = true,
        g_m_y_mexgoon_01 = true,
        g_m_y_mexgoon_03 = true,
        mp_m_waremech_01 = true,
        mp_m_weapexp_01 = true,
        mp_m_weapwork_01 = true,
        mp_m_forgery_01 = true,
        mp_m_famdd_01 = true,
        u_m_y_justin = true,
        a_m_o_acult_01 = true,
        a_m_m_acult_01 = true,
    },
    -- Peds nativos do GTA ficam fora do catálogo de assets; estes prefixos os liberam no /skins.
    nativeModelPrefixes = {
        "a_c_", "a_f_", "a_m_",
        "cs_", "csb_",
        "g_f_", "g_m_",
        "hc_", "ig_", "mp_", "player_",
        "s_f_", "s_m_",
        "u_f_", "u_m_",
    },
    redeem = {
        constraints = {
            swapWindowHours = 24,
            maxOptions = 50,
            maxSelectionLimit = 50,
            maxPendingPackages = 10,
            maxDurationDays = 3650,
            maxModelLength = 50,
            sessionTtlSeconds = 900,
            expirationBatchSize = 500,
        },
        catalog = {
            pedretrom = {
                name = "Retro M",
                model = "omex_retro_m_bot",
                image = "https://i.ibb.co/rrtgk2p/image.png",
                category = eSkinCategory.HUMANOS,
            },
            pedretrof = {
                name = "Retro F",
                model = "omex_retro_f_bot",
                image = "https://i.ibb.co/ynRzB2NH/imagem-2026-08-19-192743332.png",
                category = eSkinCategory.HUMANOS,
            },
            mp_f_freemode_01 = {
                name = "Mulher",
                model = "mp_f_freemode_01",
                image = "https://docs.fivem.net/peds/mp_f_freemode_01.webp",
                category = eSkinCategory.HUMANOS,
            },
            mp_m_freemode_01 = {
                name = "Homem",
                model = "mp_m_freemode_01",
                image = "https://docs.fivem.net/peds/mp_m_freemode_01.webp",
                category = eSkinCategory.HUMANOS,
            },
            a_c_deer = {
                name = "Urso",
                model = "a_c_deer",
                image = "",
                category = eSkinCategory.ANIMAIS,
            },
            a_c_husky_2 = {
                name = "Husky 2",
                model = "a_c_husky_2",
                image = "",
                category = eSkinCategory.ANIMAIS,
            },
            a_c_panda = {
                name = "Panda",
                model = "a_c_panda",
                image = "",
                category = eSkinCategory.ANIMAIS,
            },
            a_c_poodle_2 = {
                name = "Poodle 2",
                model = "a_c_poodle_2",
                image = "",
                category = eSkinCategory.ANIMAIS,
            },
            a_c_retriever_2 = {
                name = "Retriever 2",
                model = "a_c_retriever_2",
                image = "",
                category = eSkinCategory.ANIMAIS,
            },
            a_c_sheep = {
                name = "Ovelha",
                model = "a_c_sheep",
                image = "",
                category = eSkinCategory.ANIMAIS,
            },
            a_c_shepherd_2 = {
                name = "Pastor Alemão 2",
                model = "a_c_shepherd_2",
                image = "",
                category = eSkinCategory.ANIMAIS,
            },
            a_c_westy_2 = {
                name = "Westy 2",
                model = "a_c_westy_2",
                image = "",
                category = eSkinCategory.ANIMAIS,
            },
            a2n_gordodanielzinho_01 = {
                name = "Gordo Danielzinho",
                model = "a2n_gordodanielzinho_01",
                image = "",
                category = eSkinCategory.HUMANOS,
            },
            alienlcfr = {
                name = "Alien LCFR",
                model = "AlienLCFR",
                image = "",
                category = eSkinCategory.CHARACTERS,
            },
            anao_feio = {
                name = "Anão Feio",
                model = "anao_feio",
                image = "",
                category = eSkinCategory.HUMANOS,
            },
            angel_franklin = {
                name = "Angel Franklin",
                model = "ANGEL_Franklin",
                image = "",
                category = eSkinCategory.HUMANOS,
            },
            canecorso = {
                name = "Cane Corso",
                model = "canecorso",
                image = "",
                category = eSkinCategory.ANIMAIS,
            },
            cj_junior = {
                name = "CJ Junior",
                model = "CJ_JUNIOR",
                image = "",
                category = eSkinCategory.HUMANOS,
            },
            crocodilo = {
                name = "Crocodilo",
                model = "crocodilo",
                image = "",
                category = eSkinCategory.ANIMAIS,
            },
            doberman = {
                name = "Doberman",
                model = "doberman",
                image = "",
                category = eSkinCategory.ANIMAIS,
            },
            dog_jully = {
                name = "Jully",
                model = "dog_jully",
                image = "",
                category = eSkinCategory.ANIMAIS,
            },
            dogmilitary = {
                name = "Cão Militar",
                model = "DogMilitary",
                image = "",
                category = eSkinCategory.ANIMAIS,
            },
            dragao1 = {
                name = "Dragão 1",
                model = "Dragao1",
                image = "",
                category = eSkinCategory.ANIMAIS,
            },
            dragao2 = {
                name = "Dragão 2",
                model = "Dragao2",
                image = "",
                category = eSkinCategory.ANIMAIS,
            },
            dragao3 = {
                name = "Dragão 3",
                model = "Dragao3",
                image = "",
                category = eSkinCategory.ANIMAIS,
            },
            dragao4 = {
                name = "Dragão 4",
                model = "Dragao4",
                image = "",
                category = eSkinCategory.ANIMAIS,
            },
            dragao5 = {
                name = "Dragão 5",
                model = "Dragao5",
                image = "",
                category = eSkinCategory.ANIMAIS,
            },
            dragao6 = {
                name = "Dragão 6",
                model = "Dragao6",
                image = "",
                category = eSkinCategory.ANIMAIS,
            },
            dragao7 = {
                name = "Dragão 7",
                model = "Dragao7",
                image = "",
                category = eSkinCategory.ANIMAIS,
            },
            dragao8 = {
                name = "Dragão 8",
                model = "Dragao8",
                image = "",
                category = eSkinCategory.ANIMAIS,
            },
            dragaolcfr = {
                name = "Dragão LCFR",
                model = "DragaoLCFR",
                image = "",
                category = eSkinCategory.ANIMAIS,
            },
            ft_greyhound = {
                name = "Greyhound",
                model = "ft_greyhound",
                image = "",
                category = eSkinCategory.ANIMAIS,
            },
            ["ft-fbulldog"] = {
                name = "Bulldog",
                model = "ft-fbulldog",
                image = "",
                category = eSkinCategory.ANIMAIS,
            },
            grimace = {
                name = "Grimace",
                model = "grimace",
                image = "",
                category = eSkinCategory.CHARACTERS,
            },
            guardabritanica = {
                name = "Guarda Britânica",
                model = "GuardaBritanica",
                image = "",
                category = eSkinCategory.HUMANOS,
            },
            heroitomatao = {
                name = "Herói Tomatão",
                model = "HeroiTomatao",
                image = "",
                category = eSkinCategory.CHARACTERS,
            },
            -- husky = {
            --     name = "Husky",
            --     model = "husky",
            --     image = "",
            --     category = eSkinCategory.ANIMAIS,
            -- },
            omex_retro_f_bot = {
                name = "Retro F",
                model = "omex_retro_f_bot",
                image = "",
                category = eSkinCategory.HUMANOS,
            },
            omex_retro_m_bot = {
                name = "Retro M",
                model = "omex_retro_m_bot",
                image = "",
                category = eSkinCategory.HUMANOS,
            },
            papainoel = {
                name = "Papai Noel",
                model = "papainoel",
                image = "",
                category = eSkinCategory.HUMANOS,
            },
            rajah = {
                name = "Rajah",
                model = "Rajah",
                image = "",
                category = eSkinCategory.ANIMAIS,
            },
            samurai = {
                name = "Samurai",
                model = "Samurai",
                image = "",
                category = eSkinCategory.CHARACTERS,
            },
            sphynx = {
                name = "Gato Sphynx",
                model = "sphynx",
                image = "",
                category = eSkinCategory.ANIMAIS,
            },
            spiked = {
                name = "Spiked",
                model = "spiked",
                image = "",
                category = eSkinCategory.CHARACTERS,
            },
            tigor = {
                name = "Tigor",
                model = "Tigor",
                image = "",
                category = eSkinCategory.ANIMAIS,
            },
            tigre = {
                name = "Tigre",
                model = "tigre",
                image = "",
                category = eSkinCategory.ANIMAIS,
            },
            trex = {
                name = "T-Rex",
                model = "trex",
                image = "",
                category = eSkinCategory.ANIMAIS,
            },
            zombie_argonix = {
                name = "Zombie Argonix",
                model = "zombie_argonix",
                image = "",
                category = eSkinCategory.CHARACTERS,
            },
        },
        defaultModels = {
            mp_f_freemode_01 = true,
            mp_m_freemode_01 = true,
        },
    },
}
