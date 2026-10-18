-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local List = {}
cityName = GetConvar("cityName","")
lang = GetConvar("language", "pt-br") or "pt-br"
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREMIUM
-----------------------------------------------------------------------------------------------------------------------------------------
PremiumItems = {
    "premium01",
    "premium02",
    "premium03",
    "premium04",
    "premium05",
    "WEAPON_TACTICALRIFLE",
    "WEAPON_COMBATMG_MK2",
    "setvehicles1",
    "setvehicles2",
    "vehicleselite",
    "vehiclesstart",
    "vehicles16t",
    "vehicles16tpf",
    "vehicles32t",
    "vehiclesfull2k",
    "vehiclesfull2500k",
    "vehiclesfull3k",
    "vehiclesfullabs",
    "skorpion2_15d",
    "skorpion2_30d",
    "vipstaff",
    "vipevento1",
    "vipevento2",
    "picole2",
    "petretriever",
    "petrottweiler",
    "petwesty",
    "petpug",
    "petbulldog",
    "petgreyhound",
    "PetLoboSirius",
    "Tigor",
    "Rajah",
    "pethusky",
    "petshepherd",
    "petpoodle",
    "petovelha",
    "pedretrom",
    "pedretrof",
    "petpanda",
    "petjavali",
    "dragaolcfr",
    "petdragao1",
    "petdragao2",
    "petdragao3",
    "petdragao4",
    "petdragao5",
    "petdragao6",
    "petdragao7",
    "petdragao8",
    "petcanecorso",
    "petdoberman",
    "petcat",
    "petsphynx",
    "monkey",
    "kitblack2",
    "kitarmas1",
    "kitarmas2",
    "kitarmas3",
    "kitarmas4",
    "kitarmas5",
    "kitarmas6",
    "kitarmas7",
    "kitorgs",
    "kitfaclavagem",
    "kitfacmaconha",
    "kitfaccoca",
    "kitfacmeta",
    "kitfacmunicao",
    "kitfacdesmanche",
    "kitfacarmas",
    "postit",
    "vipsorteio",
    "kitfogueteiro",
    "kitcriminal",
    "kitmafioso",
    "kitdosraul",
    "kitboqueta",
	"gemstone",
    "premiumplate",
    "phonechange",
    "money1",
    "money2",
    "money3",
    "money4",
    "money5",
    "packbasic",
    "packelite",
    "packpremium",
    "rolepass",
	"megaphone",
	"namechange",
    "profilepicture",
    "passportchange11to20",
    "passportchange21to50",
    "passportchange51to100",
    "passportchange101to500",
    "passportchange501to999",
    "passportchangeemblematic",
	"creator",
    "newchars",
	"WEAPON_GRENADELAUNCHER",
    'WEAPON_MINIGUN',
    'WEAPON_FIREWORK',
    "WEAPON_HOMINGLAUNCHER",
    "WEAPON_RAILGUN",
    "WEAPON_RPG",
    "WEAPON_RPG_AMMO",
    "WEAPON_MINIGUN_AMMO",
    "WEAPON_RAYPISTOL",
    "WEAPON_RAYCARBINE",
    "WEAPON_RAYMINIGUN",
    "WEAPON_TONYSTARK",
    "WEAPON_IRON",
    "WEAPON_SKORPION",
    "WEAPON_APPISTOL_MISTICDRAGON",
    "WEAPON_SPECIALCARBINE_MK2_MISTICDRAGON",
    "WEAPON_SNIPER_MISTICDRAGON",
    "WEAPON_KNIFE_MISTICDRAGON",
    "WEAPON_SPECIALCARBINE_MK2_ZEUS",
    "WEAPON_APPISTOL_ZEUS",
    "WEAPON_KARAMBIT_ZEUS",
    "WEAPON_BAT_ZEUS",
    "WEAPON_GGSPURPLEVVS",
    "WEAPON_GGSGREYVVS",
    "WEAPON_GGSBLUEVVS",
    "WEAPON_GGSWHITEVVS",
    "WEAPON_GGSREDVVS",
    "WEAPON_APPISTOLPINK",
    "WEAPON_GADGETPISTOL",
    "WEAPON_APPISTOL_OUTLAW",
    "WEAPON_APPISTOL_RETROPIXEL_BLUE",
    "WEAPON_APPISTOL_RETROPIXEL_PURPLE",
    "WEAPON_APPISTOL_RETROPIXEL_RED",
    "WEAPON_APPISTOL_RETROPIXEL_WHITE",
    "WEAPON_ASSAULTSMG_RETROPIXEL_BLUE",
    "WEAPON_ASSAULTSMG_RETROPIXEL_PURPLE",
    "WEAPON_ASSAULTSMG_RETROPIXEL_RED",
    "WEAPON_ASSAULTSMG_RETROPIXEL_WHITE",
    "WEAPON_CARBINERIFLE_MK2_RETROPIXEL_BLUE",
    "WEAPON_CARBINERIFLE_MK2_RETROPIXEL_PURPLE",
    "WEAPON_CARBINERIFLE_MK2_RETROPIXEL_RED",
    "WEAPON_CARBINERIFLE_MK2_RETROPIXEL_WHITE",
    "WEAPON_SPECIALCARBINE_MK2_RETROPIXEL_BLUE",
    "WEAPON_SPECIALCARBINE_MK2_RETROPIXEL_PURPLE",
    "WEAPON_SPECIALCARBINE_MK2_RETROPIXEL_RED",
    "WEAPON_SPECIALCARBINE_MK2_RETROPIXEL_WHITE",
    "WEAPON_BULLPUPMK2_RETROPIXEL_BLUE",
    "WEAPON_BULLPUPMK2_RETROPIXEL_PURPLE",
    "WEAPON_BULLPUPMK2_RETROPIXEL_RED",
    "WEAPON_BULLPUPMK2_RETROPIXEL_WHITE",
    "WEAPON_MACHETTE_RETROPIXEL_BLUE",
    "WEAPON_MACHETTE_RETROPIXEL_PURPLE",
    "WEAPON_MACHETTE_RETROPIXEL_RED",
    "WEAPON_MACHETTE_RETROPIXEL_WHITE",
    "WEAPON_CARBINERIFLE_MK2_STEAMPUNK",
    "WEAPON_KNIFE_VORTEX",
    "WEAPON_APPISTOL_STEAMPUNK",
    "WEAPON_APPISTOL_IRONDUST",
    "WEAPON_SPECIALCARBINE_MK2_WINTERFLOWER",
    "WEAPON_SNIPER_DRAGONREDRUSTIC",
    "WEAPON_SPECIALCARBINE_MK2_DRAGONREDRUSTIC",
    "WEAPON_KATANA_DRAGONREDRUSTIC",
    "WEAPON_APPISTOL_DRAGONREDRUSTIC",
    "WEAPON_SPECIALCARBINE_MK2_KAWAI",
    "WEAPON_APPISTOL_KAWAI",
    "WEAPON_PISTOLMK2_KAWAI",
    "WEAPON_PISTOL50_KAWAI",
    "WEAPON_BULLPUPMK2_KAWAI",
    "WEAPON_SWITCHBLADE_KAWAI",
    "WEAPON_ASSAULTRIFLE_MK2_KAWAI",
    "WEAPON_COMBATPDW_KAWAI",
    "WEAPON_CARBINERIFLE_MK2_KAWAI",
    "WEAPON_APPISTOL_GRAVEYARD",
    "WEAPON_BATTLEAXE_GRAVEYARD",
    "WEAPON_BAT_KAWAI",
    "WEAPON_CARBINERIFLE_MK2_GRAVEYARD",
    "WEAPON_SPECIALCARBINE_MK2_GRAVEYARD",
    "WEAPON_CENOURA",
    "WEAPON_KATANA_CENOURA",
    "WEAPON_PL_PENHASHOP_G3_PCJ_V2",
    "WEAPON_BLACKSNAKE",
    "WEAPON_BULLPUP_ANIME",
    "WEAPON_PINKFIRE",
    "WEAPON_SPECIALCARBINE_TOXIC",
    "WEAPON_BULLPUPRIFLE_MK2_LOBO",
    "WEAPON_G3LCHELLFIRE",
    "WEAPON_RAIJIN",
    "WEAPON_APPISTOL_SHOCKVOLT",
    "WEAPON_APPISTOL_DARKMATTER",
    "WEAPON_APPISTOL_SNAGDRAGON",
    "WEAPON_TIGER_PISTOL",
    "WEAPON_ONI",
    "WEAPON_TIGER",
    "WEAPON_ABISSAL",
    "WEAPON_SHINIGAMI",
    "WEAPON_SKORPION_SNIPER",
    "WEAPON_SHOCKVOLT_SNIPER",
    "WEAPON_SNIPERRIFLE_CYBERTRIBAL",
    "WEAPON_DRAGONRED_SNIPER",
    "WEAPON_HEAVYSNIPER_MK2_LOBO",
    "WEAPON_THYZUK_SNIPER",
    "WEAPON_TIGER_SNIPER",
    "WEAPON_PABSS",
    "voucher_property_emerald",
    "voucher_property_diamond",
    "voucher_property_ruby",
    "voucher_property_sapphire",
    "voucher_property_amethyst",
    "voucher_property_amber",
    "pent01",
    "pent02",
    "pent03",
    "pent04",
    "pent05",
    "backpack1",
    "backpack2",
    "backpack3",
    "backpack4",
    "backpack5",
    "backpack6",
    "backpack7",
    "backpack8",
    "fans1",
    "fans100",
    "fans200",
    "fans300",
    "fans500",
    "fans1000",
    "fans2000",
    "fans5000",
    "fans10000",
    "verificado1",
    "blackjack_table",
    "baccarat_table",
    "roulette_table",
    "thunder_roulette_table",
    "poker_table",
    "horseracing_machine",
    "slot_machine",
    "wheel_machine",
    "WEAPON_WOLFSTORM",
    "WEAPON_SKORPION_SNIPER",
    "WEAPON_SKORPION",
    "WEAPON_APPISTOL_CHROME",
    "WEAPON_APPISTOL_CROSSDIAMOND",
    "WEAPON_CENOURA",
    "WEAPON_KATANA_CENOURA",
    "WEAPON_PL_PENHASHOP_G3_PCJ_V2",
}

BlackList = {
	-- ["WEAPON_COMBATPISTOL"] = true,
	-- ["WEAPON_CARBINERIFLE"] = true,
	-- ["WEAPON_CARBINERIFLE_MK2"] = true,
    -- ["WEAPON_SPECIALCARBINE"] = true,
    -- ["WEAPON_SPECIALCARBINE_MK2"] = true,
    -- ["WEAPON_PUMPSHOTGUN"] = true,
	-- ["WEAPON_SMG"] = true,
	["WEAPON_NIGHTSTICK"] = true,
	["WEAPON_GRENADELAUNCHER"] = true,
    ["WEAPON_MINIGUN"] = true,
    ["WEAPON_FIREWORK"] = true,
    ["WEAPON_HOMINGLAUNCHER"] = true,
    ["WEAPON_RAILGUN"] = true,
    ["WEAPON_RPG"] = true,
    ["WEAPON_RPG_AMMO"] = true,
    ["WEAPON_MINIGUN_AMMO"] = true,
    ["WEAPON_RAYPISTOL"] = true,
    ["WEAPON_RAYCARBINE"] = true,
    ["WEAPON_RAYMINIGUN"] = true,
    ["WEAPON_TONYSTARK"] = true,
    ["WEAPON_IRON"] = true,
    ["WEAPON_SKORPION"] = true,
    ["WEAPON_APPISTOL_MISTICDRAGON"] = true,
    ["WEAPON_SPECIALCARBINE_MK2_MISTICDRAGON"] = true,
    ["WEAPON_SNIPER_MISTICDRAGON"] = true,
    ["WEAPON_KNIFE_MISTICDRAGON"] = true,
    ["WEAPON_SPECIALCARBINE_MK2_ZEUS"] = true,
    ["WEAPON_APPISTOL_ZEUS"] = true,
    ["WEAPON_KARAMBIT_ZEUS"] = true,
    ["WEAPON_BAT_ZEUS"] = true,
    ["WEAPON_GGSPURPLEVVS"] = true,
    ["WEAPON_GGSGREYVVS"] = true,
    ["WEAPON_GGSBLUEVVS"] = true,
    ["WEAPON_GGSWHITEVVS"] = true,
    ["WEAPON_GGSREDVVS"] = true,
    ["WEAPON_APPISTOLPINK"] = true,
    ["WEAPON_APPISTOL_CHROME"] = true,
    ["WEAPON_APPISTOL_CROSSDIAMOND"] = true,
    ["WEAPON_GADGETPISTOL"] = true,
    ["WEAPON_APPISTOL_OUTLAW"] = true,
    ["WEAPON_APPISTOL_RETROPIXEL_BLUE"] = true,
    ["WEAPON_APPISTOL_RETROPIXEL_PURPLE"] = true,
    ["WEAPON_APPISTOL_RETROPIXEL_RED"] = true,
    ["WEAPON_APPISTOL_RETROPIXEL_WHITE"] = true,
    ["WEAPON_ASSAULTSMG_RETROPIXEL_BLUE"] = true,
    ["WEAPON_ASSAULTSMG_RETROPIXEL_PURPLE"] = true,
    ["WEAPON_ASSAULTSMG_RETROPIXEL_RED"] = true,
    ["WEAPON_ASSAULTSMG_RETROPIXEL_WHITE"] = true,
    ["WEAPON_CARBINERIFLE_MK2_RETROPIXEL_BLUE"] = true,
    ["WEAPON_CARBINERIFLE_MK2_RETROPIXEL_PURPLE"] = true,
    ["WEAPON_CARBINERIFLE_MK2_RETROPIXEL_RED"] = true,
    ["WEAPON_CARBINERIFLE_MK2_RETROPIXEL_WHITE"] = true,
    ["WEAPON_SPECIALCARBINE_MK2_RETROPIXEL_BLUE"] = true,
    ["WEAPON_SPECIALCARBINE_MK2_RETROPIXEL_PURPLE"] = true,
    ["WEAPON_SPECIALCARBINE_MK2_RETROPIXEL_RED"] = true,
    ["WEAPON_SPECIALCARBINE_MK2_RETROPIXEL_WHITE"] = true,
    ["WEAPON_BULLPUPMK2_RETROPIXEL_BLUE"] = true,
    ["WEAPON_BULLPUPMK2_RETROPIXEL_PURPLE"] = true,
    ["WEAPON_BULLPUPMK2_RETROPIXEL_RED"] = true,
    ["WEAPON_BULLPUPMK2_RETROPIXEL_WHITE"] = true,
    ["WEAPON_MACHETTE_RETROPIXEL_BLUE"] = true,
    ["WEAPON_MACHETTE_RETROPIXEL_PURPLE"] = true,
    ["WEAPON_MACHETTE_RETROPIXEL_RED"] = true,
    ["WEAPON_MACHETTE_RETROPIXEL_WHITE"] = true,
    ["WEAPON_CARBINERIFLE_MK2_STEAMPUNK"] = true,
    ["WEAPON_KNIFE_VORTEX"] = true,
    ["WEAPON_APPISTOL_STEAMPUNK"] = true,
    ["WEAPON_APPISTOL_IRONDUST"] = true,
    ["WEAPON_SPECIALCARBINE_MK2_WINTERFLOWER"] = true,
    ["WEAPON_SNIPER_DRAGONREDRUSTIC"] = true,
    ["WEAPON_SPECIALCARBINE_MK2_DRAGONREDRUSTIC"] = true,
    ["WEAPON_KATANA_DRAGONREDRUSTIC"] = true,
    ["WEAPON_APPISTOL_DRAGONREDRUSTIC"] = true,
    ["WEAPON_SPECIALCARBINE_MK2_KAWAI"] = true,
    ["WEAPON_APPISTOL_KAWAI"] = true,
    ["WEAPON_PISTOLMK2_KAWAI"] = true,
    ["WEAPON_PISTOL50_KAWAI"] = true,
    ["WEAPON_BULLPUPMK2_KAWAI"] = true,
    ["WEAPON_SWITCHBLADE_KAWAI"] = true,
    ["WEAPON_ASSAULTRIFLE_MK2_KAWAI"] = true,
    ["WEAPON_COMBATPDW_KAWAI"] = true,
    ["WEAPON_CARBINERIFLE_MK2_KAWAI"] = true,
    ["WEAPON_APPISTOL_GRAVEYARD"] = true,
    ["WEAPON_BATTLEAXE_GRAVEYARD"] = true,
    ["WEAPON_BAT_KAWAI"] = true,
    ["WEAPON_CARBINERIFLE_MK2_GRAVEYARD"] = true,
    ["WEAPON_SPECIALCARBINE_MK2_GRAVEYARD"] = true,
    ["WEAPON_CENOURA"] = true,
    ["WEAPON_KATANA_CENOURA"] = true,
    ["WEAPON_PL_PENHASHOP_G3_PCJ_V2"] = true,
    ["WEAPON_BLACKSNAKE"] = true,
    ["WEAPON_BULLPUP_ANIME"] = true,
    ["WEAPON_PINKFIRE"] = true,
    ["WEAPON_SPECIALCARBINE_TOXIC"] = true,
    ["WEAPON_BULLPUPRIFLE_MK2_LOBO"] = true,
    ["WEAPON_G3LCHELLFIRE"] = true,
    ["WEAPON_RAIJIN"] = true,
    ["WEAPON_APPISTOL_SHOCKVOLT"] = true,
    ["WEAPON_APPISTOL_DARKMATTER"] = true,
    ["WEAPON_APPISTOL_SNAGDRAGON"] = true,
    ["WEAPON_TIGER_PISTOL"] = true,
    ["WEAPON_PABSS"] = true,
    ["backpack1"] = true,
    ["backpack2"] = true,
    ["backpack3"] = true,
    ["backpack4"] = true,
    ["backpack5"] = true,
    ["backpack6"] = true,
    ["backpack7"] = true,
    ["backpack8"] = true,
    ["fans1"] = true,
    ["fans100"] = true,
    ["fans200"] = true,
    ["fans300"] = true,
    ["fans500"] = true,
    ["fans1000"] = true,
    ["fans2000"] = true,
    ["fans5000"] = true,
    ["fans10000"] = true,
    ["dragaolcfr"] = true,
    ["petdragao1"] = true,
    ["petdragao2"] = true,
    ["petdragao3"] = true,
    ["petdragao4"] = true,
    ["petdragao5"] = true,
    ["petdragao6"] = true,
    ["petdragao7"] = true,
    ["petdragao8"] = true,
    ["verificado1"] = true,
    ["passportchange11to20"] = true,
    ["passportchange21to50"] = true,
    ["passportchange51to100"] = true,
    ["passportchange101to500"] = true,
    ["passportchange501to999"] = true,
    ["passportchangeemblematic"] = true,
    ["blackjack_table"] = true,
    ["baccarat_table"] = true,
    ["roulette_table"] = true,
    ["thunder_roulette_table"] = true,
    ["poker_table"] = true,
    ["horseracing_machine"] = true,
    ["slot_machine"] = true,
    ["wheel_machine"] = true,
}

function IsBlackListed(Item)
    if BlackList[Item] then
        return true
    else
        return false
    end
end

-- WARNING: Caso o número de items em "PremiumItems" aumente, mudar para uma hashmap!
-- WARNING: Caso o número de items em "PremiumItems" aumente, mudar para uma hashmap!
-- WARNING: Caso o número de items em "PremiumItems" aumente, mudar para uma hashmap!
function IsPremiumItem(Item)
    for i=1,#PremiumItems do
        if PremiumItems[i] == Item then
            return true
        end
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIST
-----------------------------------------------------------------------------------------------------------------------------------------
List = {
    ["advrem"] = {
        ["Index"] = "advrem",
        ["Name"] = "Remover ADV",
        ["Description"] = "Item adquirido na loja, para remoção de advertência",
        ["Type"] = "Usável",
        ["Weight"] = 0.35,
        ["Block"] = true,
        ["BlockChest"] = true,
["Class"] = "Premium",
        ["Economy"] = 2250
    },
    ["WEAPON_RPG_AMMO"] = {
        ["Index"] = "WEAPON_RPG_AMMO",
        ["Name"] = "M. RPG",
        ["Description"] = "Munição utilizada para o armamento",
        ["Type"] = "Munição",
        ["Weight"] = 0.03,
        ["Block"] = true,
        ["BlockChest"] = true,
["Class"] = "Armas",
        ["Economy"] = 30
    },
    ["WEAPON_MINIGUN_AMMO"] = {
        ["Index"] = "WEAPON_MINIGUN_AMMO",
        ["Name"] = "M. MINIGUN",
        ["Description"] = "Munição utilizada para o armamento",
        ["Type"] = "Munição",
        ["Weight"] = 0.03,
        ["Block"] = true,
        ["BlockChest"] = true,
["Class"] = "Armas",
        ["Economy"] = 30
    },
    ["WEAPON_FIREWORK"] = {
        ["Index"] = "WEAPON_FIREWORK",
        ["Name"] = "WEAPON_FIREWORK",
        ["Description"] = "Armamento de RPG",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RPG_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_MINIGUN"] = {
        ["Index"] = "WEAPON_MINIGUN",
        ["Name"] = "WEAPON_MINIGUN",
        ["Description"] = "Armamento de RPG",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_MINIGUN_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
["Class"] = "Armas",
        ["Economy"] = 775
    },

    ["WEAPON_GRENADELAUNCHER"] = {
        ["Index"] = "WEAPON_GRENADELAUNCHER",
        ["Name"] = "WEAPON_GRENADELAUNCHER",
        ["Description"] = "Armamento de RPG",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RPG_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_HOMINGLAUNCHER"] = {
        ["Index"] = "WEAPON_HOMINGLAUNCHER",
        ["Name"] = "WEAPON_HOMINGLAUNCHER",
        ["Description"] = "Armamento de RPG",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RPG_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
["Class"] = "Armas",
        ["Economy"] = 775
    },
    -- ["WEAPON_RAILGUN"] = {
    --     ["Index"] = "WEAPON_RAILGUN",
    --     ["Name"] = "WEAPON_RAILGUN",
    --     ["Description"] = "Armamento de RPG",
    --     ["Description"] = "Munição utilizada para o armamento",
    --     ["Repair"] = "repairkit04",
    --     ["Type"] = "Armamento",
    --     ["Ammo"] = "WEAPON_RPG_AMMO",
    --     ["Weight"] = 3.75,
    --     ["Block"] = true,
    --["BlockChest"] = true,
--     ["Class"] = "Armas",
    --     ["Economy"] = 775
    -- },
    ["WEAPON_RPG"] = {
        ["Index"] = "RPG",
        ["Name"] = "WEAPON_RPG",
        ["Description"] = "Armamento de RPG",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RPG_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_RAYPISTOL"] = {
        ["Index"] = "Ray Pistol",
        ["Description"] = "Armamento de RPG",
        ["Name"] = "WEAPON_RAYPISTOL",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RPG_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_RAYCARBINE"] = {
        ["Index"] = "Ray Carbine",
        ["Name"] = "WEAPON_RAYCARBINE",
        ["Description"] = "Armamento de RPG",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RPG_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_RAYMINIGUN"] = {
        ["Index"] = "Ray MiniguN",
        ["Name"] = "Ray MiniguN",
        ["Description"] = "Armamento de RPG",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_MINIGUN_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_IRON"] = {
        ["Index"] = "Iron",
        ["Name"] = "Iron",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["packbasic"] = {
        ["Index"] = "packbasic",
        ["Name"] = "Pack de Armas - Basic",
        ["Description"] = "Pacote básico de armamento, adquirido em nossa loja",
        ["Type"] = "Usável",
        ["Weight"] = 0.35,
        ["Block"] = true,
        ["BlockChest"] = true,
["Class"] = "Premium",
        ["Economy"] = 2250
    },
    ["packelite"] = {
        ["Index"] = "packelite",
        ["Name"] = "Pack de Armas - Elite",
        ["Description"] = "Pacote elite de armamento, adquirido em nossa loja",
        ["Type"] = "Usável",
        ["Weight"] = 0.35,
        ["Block"] = true,
        ["BlockChest"] = true,
["Class"] = "Premium",
        ["Economy"] = 2250
    },
    ["packpremium"] = {
        ["Index"] = "packpremium",
        ["Name"] = "Pack de Armas - Premium",
        ["Description"] = "Pacote premium de armamento, adquirido em nossa loja",
        ["Type"] = "Usável",
        ["Weight"] = 0.35,
        ["Block"] = true,
        ["BlockChest"] = true,
["Class"] = "Premium",
        ["Economy"] = 2250
    },
    ["prisaorem"] = {
        ["Index"] = "prisaorem",
        ["Name"] = "Remover Prisao",
        ["Description"] = "Item adquirido em nossa loja para remoção de prisão",
        ["Type"] = "Usável",
        ["Weight"] = 0.35,
        ["Block"] = true,
        ["BlockChest"] = true,
["Class"] = "Premium",
        ["Economy"] = 2250
    },
    ["money1"] = {
        ["Index"] = "money1",
        ["Name"] = "50 milhões de Dollars",
        ["Description"] = "Item adquirido em nossa loja para obter 50 milhões de dolares em sua contra bancária",
        ["Type"] = "Usável",
        ["Weight"] = 0.35,
        ["Block"] = true,
        ["BlockChest"] = true,
["Class"] = "Premium",
        ["Economy"] = 2250
    },
    ["money2"] = {
        ["Index"] = "money2",
        ["Name"] = "25 milhões de Dollars",
        ["Description"] = "Item adquirido em nossa loja para obter 25 milhões de dolares em sua contra bancária",
        ["Type"] = "Usável",
        ["Weight"] = 0.35,
        ["Block"] = true,
        ["BlockChest"] = true,
["Class"] = "Premium",
        ["Economy"] = 2250
    },
    ["money3"] = {
        ["Index"] = "money3",
        ["Name"] = "10 milhões de Dollars",
        ["Description"] = "Item adquirido em nossa loja para obter 10 milhões de dolares em sua contra bancária",
        ["Type"] = "Usável",
        ["Weight"] = 0.35,
        ["Block"] = true,
        ["BlockChest"] = true,
["Class"] = "Premium",
        ["Economy"] = 2250
    },
    ["money4"] = {
        ["Index"] = "money4",
        ["Name"] = "1 milhão de Dollars",
        ["Description"] = "Item adquirido em nossa loja para obter 1 milhão de dolares em sua contra bancária",
        ["Type"] = "Usável",
        ["Weight"] = 0.35,
        ["Block"] = true,
        ["BlockChest"] = true,
["Class"] = "Premium",
        ["Economy"] = 2250
    },
    ["money5"] = {
        ["Index"] = "money5",
        ["Name"] = "10 milhões de Dollars",
        ["Description"] = "Item adquirido em nossa loja para obter 10 milhões de dolares em sua contra bancária",
        ["Type"] = "Usável",
        ["Weight"] = 0.35,
        ["Block"] = true,
        ["BlockChest"] = true,
["Class"] = "Premium",
        ["Economy"] = 2250
    },
    ["adrenaline"] = {
        ["Index"] = "adrenaline",
        ["Name"] = "Adrenalina",
        ["Description"] = "Item para reanimar player morto",
        ["Type"] = "Usável",
        ["Weight"] = 0.35,
        ["Class"] = "Utilitarios",
        ["Economy"] = 200000
    },
    ["valeroleta"] = {
        ["Index"] = "valeroleta",
        ["Name"] = "Vale Roleta",
        ["Description"] = "Item para usar na roleta",
        ["Type"] = "Usável",
        ["Weight"] = 0.35,
        ["Class"] = "Utilitarios",
        ["Economy"] = 200000
    },
    ["bolsadesangue"] = {
        ["Index"] = "bolsadesangue",
        ["Name"] = "Bolsa de Sangue",
        ["Type"] = "Usável",
        ["Weight"] = 0.35,
        ["Class"] = "Utilitarios",
        ["Economy"] = 5000
    },
    ["dogtag"] = {
        ["Index"] = "insignia",
        ["Name"] = "Dog Tag",
        ["Type"] = "Usável",
        ["Weight"] = 0.06,
        ["Block"] = false,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["kitfarm1"] = {
        ["Index"] = "kitfarm1",
        ["Name"] = "Kit Farme 1",
        ["Type"] = "Usável",
        ["Weight"] = 0.06,
        ["Block"] = false,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["kitfarm2"] = {
        ["Index"] = "kitfarm2",
        ["Name"] = "Kit Farme 2",
        ["Type"] = "Usável",
        ["Weight"] = 0.06,
        ["Block"] = false,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["kitfarm3"] = {
        ["Index"] = "kitfarm3",
        ["Name"] = "Kit Farme 3",
        ["Type"] = "Usável",
        ["Weight"] = 0.06,
        ["Block"] = false,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["creator"] = {
        ["Index"] = "creator",
        ["Name"] = "Criação de Personagem",
        ["Description"] = "Item adquirido com diamantes ou spawn para reset para troca de aparência física",
        ["Type"] = "Usável",
        ["Weight"] = 15.0,
        ["Block"] = true,
        ["BlockChest"] = true,
["Class"] = "Premium",
        ["Economy"] = 0
    },
    ["picole2"] = {
        ["Index"] = "picole",
        ["Name"] = "picole",
        ["Type"] = "Usável",
        ["Weight"] = 15.0,
        ["Block"] = false,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["milho"] = {
        ["Index"] = "milho",
        ["Name"] = "Milho",
        ["Type"] = "Usável",
        ["Weight"] = 15.0,
        ["Block"] = false,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["algodaodoce"] = {
        ["Index"] = "algodaodoce",
        ["Name"] = "Algodão doce",
        ["Type"] = "Usável",
        ["Weight"] = 15.0,
        ["Block"] = false,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["macadoamor"] = {
        ["Index"] = "macadoamor",
        ["Name"] = "Maçã do amor",
        ["Type"] = "Usável",
        ["Weight"] = 15.0,
        ["Block"] = false,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["nos"] = {
        ["Index"] = "nos",
        ["Name"] = "Nitro",
        ["Type"] = "Usável",
        ["Weight"] = 15.0,
        ["Block"] = false,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["changesexm"] = {
        ["Index"] = "changesexm",
        ["Name"] = "Mudança para sexo Masculino",
        ["Type"] = "Usável",
        ["Weight"] = 15.0,
        ["Block"] = false,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["changesexf"] = {
        ["Index"] = "changesexf",
        ["Name"] = "Mudança para sexo Feminino",
        ["Type"] = "Usável",
        ["Weight"] = 15.0,
        ["Block"] = false,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["album"] = {
        ["Index"] = "album",
        ["Name"] = "Álbum da Copa",
        ["Description"] = "Álbum de copa, para colecionar figurinhas",
        ["Type"] = "Usável",
        ["Weight"] = 2.0,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["aboboradoce"] = {
        ["Index"] = "aboboradoce",
        ["Name"] = "Aboboradoce",
        ["Type"] = "Usável",
        ["Weight"] = 2.0,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["balinhas"] = {
        ["Index"] = "balinhas",
        ["Name"] = "Balinhas",
        ["Type"] = "Usável",
        ["Weight"] = 2.0,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["chiclete"] = {
        ["Index"] = "chiclete",
        ["Name"] = "Chiclete",
        ["Type"] = "Usável",
        ["Weight"] = 2.0,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["docefantasma"] = {
        ["Index"] = "docefantasma",
        ["Name"] = "Doce Fantasma",
        ["Type"] = "Usável",
        ["Weight"] = 2.0,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["milhodoce"] = {
        ["Index"] = "milhodoce",
        ["Name"] = "Milho doce",
        ["Type"] = "Usável",
        ["Weight"] = 2.0,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["minhocadoce"] = {
        ["Index"] = "minhocadoce",
        ["Name"] = "Minhoca Doce",
        ["Type"] = "Usável",
        ["Weight"] = 2.0,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["lixo"] = {
        ["Index"] = "lixo",
        ["Name"] = "Lixo",
        ["Type"] = "Usável",
        ["Weight"] = 2.0,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["esqueleto"] = {
        ["Index"] = "esqueleto",
        ["Name"] = "Esqueleto",
        ["Type"] = "Usável",
        ["Weight"] = 2.0,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["rainha"] = {
        ["Index"] = "rainha",
        ["Name"] = "Rainha",
        ["Type"] = "Usável",
        ["Weight"] = 2.0,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["mulherfrank"] = {
        ["Index"] = "mulherfrank",
        ["Name"] = "Mulher Frank",
        ["Type"] = "Usável",
        ["Weight"] = 2.0,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["et"] = {
        ["Index"] = "et",
        ["Name"] = "ET",
        ["Type"] = "Usável",
        ["Weight"] = 2.0,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["troll"] = {
        ["Index"] = "troll",
        ["Name"] = "Troll",
        ["Type"] = "Usável",
        ["Weight"] = 2.0,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["skate"] = {
        ["Index"] = "skate",
        ["Name"] = "Skate",
        ["Type"] = "Usável",
        ["Weight"] = 2.0,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["frankenstein"] = {
        ["Index"] = "frankenstein",
        ["Name"] = "Frankenstein",
        ["Type"] = "Usável",
        ["Weight"] = 2.0,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["heman"] = {
        ["Index"] = "heman",
        ["Name"] = "Heman",
        ["Type"] = "Usável",
        ["Weight"] = 2.0,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["alvejante"] = {
        ["Index"] = "alvejante",
        ["Name"] = "Alvejante",
        ["Description"] = "Item de farm, para limpar dinheiro sujo",
        ["Type"] = "Comum",
        ["Weight"] = 0.0,
        ["Class"] = "Drogas",
        ["Economy"] = 0
    },
    ["ferro"] = {
        ["Index"] = "ferro",
        ["Name"] = "Ferro",
        ["Description"] = "Barra de ferro, sem utilitário",
        ["Type"] = "Comum",
        ["Weight"] = 0.0,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["capsula"] = {
        ["Index"] = "capsula",
        ["Name"] = "Capsula",
        ["Description"] = "Item de farm para produção de munição",
        ["Type"] = "Comum",
        ["Weight"] = 0.0,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["Pao"] = {
        ["Index"] = "Pao",
        ["Name"] = "Pao",
        ["Description"] = "Item de farm para produção de hamburger",
        ["Type"] = "Comum",
        ["Weight"] = 0.0,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["HamburguerBovino"] = {
        ["Index"] = "HamburguerBovino",
        ["Name"] = "HamburguerBovino",
        ["Description"] = "Item de farm para produção de hamburger",
        ["Type"] = "Comum",
        ["Weight"] = 0.0,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["valecasa"] = {
        ["Index"] = "valecasa",
        ["Name"] = "Vale Casa",
        ["Description"] = "Item para adquirir uma residência simples",
        ["Type"] = "Comum",
        ["Weight"] = 0.0,
        ["Class"] = "Premium",
        ["Economy"] = 0
    },
    ["voucher_property_emerald"] = {
        ["Index"] = "voucher_property_emerald",
        ["Name"] = "Vale Casa Emerald",
        ["Description"] = "Item para adquirir uma residência simples",
        ["Type"] = "Comum",
        ["Weight"] = 0.0,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 0
    },
    ["voucher_property_diamond"] = {
        ["Index"] = "voucher_property_diamond",
        ["Name"] = "Vale Casa Diamond",
        ["Description"] = "Item para adquirir uma residência simples",
        ["Type"] = "Comum",
        ["Weight"] = 0.0,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 0
    },
    ["voucher_property_ruby"] = {
        ["Index"] = "voucher_property_ruby",
        ["Name"] = "Vale Casa Ruby",
        ["Description"] = "Item para adquirir uma residência simples",
        ["Type"] = "Comum",
        ["Weight"] = 0.0,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 0
    },
    ["voucher_property_sapphire"] = {
        ["Index"] = "voucher_property_sapphire",
        ["Name"] = "Vale Casa Sapphire",
        ["Description"] = "Item para adquirir uma residência simples",
        ["Type"] = "Comum",
        ["Weight"] = 0.0,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 0
    },
    ["voucher_property_amethyst"] = {
        ["Index"] = "voucher_property_amethyst",
        ["Name"] = "Vale Casa Amethyst",
        ["Description"] = "Item para adquirir uma residência simples",
        ["Type"] = "Comum",
        ["Weight"] = 0.0,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 0
    },
    ["voucher_property_amber"] = {
        ["Index"] = "voucher_property_amber",
        ["Name"] = "Vale Casa Amber",
        ["Description"] = "Item para adquirir uma residência simples",
        ["Type"] = "Comum",
        ["Weight"] = 0.0,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 0
    },
    ["voucher_property_turquoise"] = {
        ["Index"] = "voucher_property_turquoise",
        ["Name"] = "Vale Casa Turquoise",
        ["Description"] = "Item para adquirir uma residência simples",
        ["Type"] = "Comum",
        ["Weight"] = 0.0,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 0
    },
    ["voucher_property_topaz"] = {
        ["Index"] = "voucher_property_topaz",
        ["Name"] = "Vale Casa Topaz",
        ["Description"] = "Item para adquirir uma residência simples",
        ["Type"] = "Comum",
        ["Weight"] = 0.0,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 0
    },
    ["pent01"] = {
        ["Index"] = "pent01",
        ["Name"] = "Voucher Essencial",
        ["Description"] = "Voucher de Penthouse Essencial",
        ["Type"] = "Comum",
        ["Weight"] = 0.0,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["Economy"] = 0
    },
    ["pent02"] = {
        ["Index"] = "pent02",
        ["Name"] = "Voucher Gourmet",
        ["Description"] = "Voucher de Penthouse Gourmet",
        ["Type"] = "Comum",
        ["Weight"] = 0.0,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["Economy"] = 0
    },
    ["pent03"] = {
        ["Index"] = "pent03",
        ["Name"] = "Voucher Premium",
        ["Description"] = "Voucher de Penthouse Premium",
        ["Type"] = "Comum",
        ["Weight"] = 0.0,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["Economy"] = 0
    },
    ["pent04"] = {
        ["Index"] = "pent04",
        ["Name"] = "Voucher Resort",
        ["Description"] = "Voucher de Penthouse Resort",
        ["Type"] = "Comum",
        ["Weight"] = 0.0,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["Economy"] = 0
    },
    ["pent05"] = {
        ["Index"] = "pent05",
        ["Name"] = "Voucher Supreme",
        ["Description"] = "Voucher de Penthouse Supreme",
        ["Type"] = "Comum",
        ["Weight"] = 0.0,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["Economy"] = 0
    },
    ["valemansao"] = {
        ["Index"] = "valemansao",
        ["Name"] = "Vale Mansão",
        ["Description"] = "Item para adquirir uma mansão",
        ["Type"] = "Comum",
        ["Weight"] = 0.0,
        ["Class"] = "Premium",
        ["Economy"] = 0
    },
    ["creditcard"] = {
        ["Index"] = "creditcard",
        ["Name"] = "Cartão de Crédito",
        ["Description"] = "Item para utilizar em compras nos blips de pagamento",
        ["Type"] = "Comum",
        ["Weight"] = 0.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["diagram"] = {
        ["Index"] = "diagram",
        ["Name"] = "Diagrama",
        ["Type"] = "Comum",
                ["Weight"] = 0.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["propertys"] = {
        ["Index"] = "propertys",
        ["Name"] = "Cartão de Segurança",
        ["Type"] = "Comum",
        ["Weight"] = 0.35,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["megaphone"] = {
        ["Index"] = "megaphone",
        ["Name"] = "Megafone",
        ["Description"] = "Item adquirido na loja para mandar mensagem no chat em geral",
        ["Type"] = "Usável",
        ["Durability"] = 15,
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.01,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    -- ["sprays01"] = {
    --     ["Index"] = "sprays",
    --     ["Name"] = "Spray",
    --     ["Description"] = "Spray de tinta, item sem função",
    --     ["Type"] = "Usável",
    --              ["Weight"] = 0.75,
    --     ["Class"] = "Utilitarios",
    --     ["Economy"] = 0
    -- },
    ["enginea"] = {
        ["Index"] = "enginea",
        ["Name"] = "Motor",
        ["Description"] = "Morto de veiculo A",
        ["Type"] = "Usável",
        ["Weight"] = 9.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["engineb"] = {
        ["Index"] = "engineb",
        ["Name"] = "Motor",
        ["Description"] = "Morto de veiculo B",
        ["Type"] = "Usável",
        ["Weight"] = 10.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["enginec"] = {
        ["Index"] = "enginec",
        ["Name"] = "Motor",
        ["Description"] = "Morto de veiculo C",
        ["Type"] = "Usável",
        ["Weight"] = 11.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["engined"] = {
        ["Index"] = "engined",
        ["Name"] = "Motor",
        ["Description"] = "Morto de veiculo D",
        ["Type"] = "Usável",
        ["Weight"] = 12.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["enginee"] = {
        ["Index"] = "enginee",
        ["Name"] = "Motor",
        ["Description"] = "Morto de veiculo E",
        ["Type"] = "Usável",
        ["Weight"] = 13.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["transmissiona"] = {
        ["Index"] = "transmissiona",
        ["Name"] = "Transmissão",
        ["Description"] = "Transmissão, peça de veiculo A",
        ["Type"] = "Usável",
        ["Weight"] = 9.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["transmissionb"] = {
        ["Index"] = "transmissionb",
        ["Name"] = "Transmissão",
        ["Description"] = "Transmissão, peça de veiculo B",
        ["Type"] = "Usável",
        ["Weight"] = 10.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["transmissionc"] = {
        ["Index"] = "transmissionc",
        ["Name"] = "Transmissão",
        ["Description"] = "Transmissão, peça de veiculo C",
        ["Type"] = "Usável",
        ["Weight"] = 11.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["transmissiond"] = {
        ["Index"] = "transmissiond",
        ["Name"] = "Transmissão",
        ["Description"] = "Transmissão, peça de veiculo D",
        ["Type"] = "Usável",
        ["Weight"] = 12.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["transmissione"] = {
        ["Index"] = "transmissione",
        ["Name"] = "Transmissão",
        ["Description"] = "Transmissão, peça de veiculo E",
        ["Type"] = "Usável",
        ["Weight"] = 13.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["brakea"] = {
        ["Index"] = "brakea",
        ["Name"] = "Freios",
        ["Description"] = "Freio, peça de veiculo A",
        ["Type"] = "Usável",
        ["Weight"] = 7.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["brakeb"] = {
        ["Index"] = "brakeb",
        ["Name"] = "Freios",
        ["Description"] = "Freio, peça de veiculo B",
        ["Type"] = "Usável",
        ["Weight"] = 8.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["brakec"] = {
        ["Index"] = "brakec",
        ["Name"] = "Freios",
        ["Description"] = "Freio, peça de veiculo C",
        ["Type"] = "Usável",
        ["Weight"] = 9.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["braked"] = {
        ["Index"] = "braked",
        ["Name"] = "Freios",
        ["Description"] = "Freio, peça de veiculo D",
        ["Type"] = "Usável",
        ["Weight"] = 10.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["brakee"] = {
        ["Index"] = "brakee",
        ["Name"] = "Freios",
        ["Description"] = "Freio, peça de veiculo E",
        ["Type"] = "Usável",
        ["Weight"] = 11.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["suspensiona"] = {
        ["Index"] = "suspensiona",
        ["Name"] = "Suspensão",
        ["Description"] = "Suspensão, peça de veiculo A",
        ["Type"] = "Usável",
        ["Weight"] = 7.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["suspensionb"] = {
        ["Index"] = "suspensionb",
        ["Name"] = "Suspensão",
        ["Description"] = "Suspensão, peça de veiculo B",
        ["Type"] = "Usável",
        ["Weight"] = 8.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["suspensionc"] = {
        ["Index"] = "suspensionc",
        ["Name"] = "Suspensão",
        ["Description"] = "Suspensão, peça de veiculo C",
        ["Type"] = "Usável",
        ["Weight"] = 9.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["suspensiond"] = {
        ["Index"] = "suspensiond",
        ["Name"] = "Suspensão",
        ["Description"] = "Suspensão, peça de veiculo D",
        ["Type"] = "Usável",
        ["Weight"] = 10.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["suspensione"] = {
        ["Index"] = "suspensione",
        ["Name"] = "Suspensão",
        ["Description"] = "Suspensão, peça de veiculo E",
        ["Type"] = "Usável",
        ["Weight"] = 11.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["dismantle"] = {
        ["Index"] = "dismantle",
        ["Name"] = "Contrato",
        ["Description"] = "Ativando o mesmo você assume a responsabilidade com o Lester de desmanchar um veículo.",
        ["Type"] = "Usável",
                ["Weight"] = 0.75,
        ["Block"] = true,
["Class"] = "Utilitarios",
        ["Economy"] = 125,
        ["Max"] = 1
    },
    ["repairkit01"] = {
        ["Index"] = "repairkit01",
        ["Name"] = "Kit de Reparos - Comum",
        ["Description"] = "Kit reparo para veiculo",
        ["Type"] = "Comum",
        ["Weight"] = 1.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 550
    },
    ["repairkit02"] = {
        ["Index"] = "repairkit02",
        ["Name"] = "Kit de Reparos - Raro",
        ["Description"] = "Kit reparo para veiculo",
        ["Type"] = "Comum",
        ["Weight"] = 3.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 3250
    },
    ["repairkit03"] = {
        ["Index"] = "repairkit03",
        ["Name"] = "Kit de Reparos - Épico",
        ["Description"] = "Kit reparo para veiculo",
        ["Type"] = "Comum",
        ["Weight"] = 1.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 7250
    },
    ["repairkit04"] = {
        ["Index"] = "repairkit04",
        ["Name"] = "Kit de Reparos - Lendário",
        ["Description"] = "Kit reparo para veiculo",
        ["Type"] = "Comum",
        ["Weight"] = 1.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 16000
    },
    ["backschool"] = {
        ["Index"] = "backschool",
        ["Name"] = "Mochila de Escola",
        ["Description"] = "Mochila escolar, sem função especifica",
        ["Type"] = "Usável",
        ["Weight"] = 1.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 100000
    },
    ["backcyclist"] = {
        ["Index"] = "backcyclist",
        ["Name"] = "Mochila de Ciclista",
        ["Description"] = "Mochila de Ciclista, sem função especifica",
        ["Type"] = "Usável",
        ["Weight"] = 1.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 100000
    },
    ["backcamping"] = {
        ["Index"] = "backcamping",
        ["Name"] = "Mochila de Acampamento",
        ["Description"] = "Mochila de Acampamento, sem função especifica",
        ["Type"] = "Usável",
        ["Weight"] = 1.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 100000
    },
    ["backalohomorawhite"] = {
        ["Index"] = "backalohomorawhite",
        ["Name"] = "Mochila Alohomora Branca",
        ["Description"] = "Mochila Alohomora Branca, sem função especifica",
        ["Type"] = "Usável",
        ["Weight"] = 1.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 150000
    },
    ["backalohomorablack"] = {
        ["Index"] = "backalohomorablack",
        ["Name"] = "Mochila Alohomora Preta",
        ["Description"] = "Mochila Alohomora Preta, sem função especifica",
        ["Type"] = "Usável",
        ["Weight"] = 1.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 150000
    },
    ["backalohomorared"] = {
        ["Index"] = "backalohomorared",
        ["Name"] = "Mochila Alohomora Vermelha",
        ["Description"] = "Mochila Alohomora Vermelha, sem função especifica",
        ["Type"] = "Usável",
        ["Weight"] = 1.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 150000
    },
    ["backrudolphpurple"] = {
        ["Index"] = "backrudolphpurple",
        ["Name"] = "Mochila Rudolph Roxo",
        ["Description"] = "Mochila Rudolph Roxo, sem função especifica",
        ["Type"] = "Usável",
        ["Weight"] = 1.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 150000
    },
    ["backrudolphred"] = {
        ["Index"] = "backrudolphred",
        ["Name"] = "Mochila Rudolph Vermelho",
        ["Description"] = "Mochila Rudolph Vermelho, sem função especifica",
        ["Type"] = "Usável",
        ["Weight"] = 1.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 150000
    },
    ["paper"] = {
        ["Index"] = "paper",
        ["Name"] = "Papel",
        ["Description"] = "Papel, sem função especifica",
        ["Type"] = "Comum",
        ["Weight"] = 0.15,
        ["Class"] = "Utilitarios",
        ["Economy"] = 120
    },
    ["rentalveh"] = {
        ["Index"] = "rentalveh",
        ["Name"] = "Aluguel de Veículo",
        ["Description"] = "Leve até a concessionária para usa-lo.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Economy"] = 0
    },
    ["paramedicpass"] = {
        ["Index"] = "medicbag",
        ["Name"] = "Vale - Médico",
        ["Description"] = "Leve até um médico para troca-lo.",
        ["Type"] = "Comum",
        ["Weight"] = 0.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["luckywheelpass"] = {
        ["Index"] = "luckywheelpass",
        ["Name"] = "Vale - Roda da Fortuna",
        ["Description"] = "Leve até o cassino para usa-lo.",
        ["Type"] = "Comum",
        ["Weight"] = 0.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 5000
    },
    ["mechanicpass"] = {
        ["Index"] = "mechanicpass",
        ["Name"] = "Vale - Mecânico",
        ["Description"] = "Leve até um mecânico para troca-lo.",
        ["Type"] = "Comum",
        ["Weight"] = 0.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["uwucoffeepass"] = {
        ["Index"] = "foodpass",
        ["Name"] = "Vale - Uwu Café",
        ["Description"] = "Leve até o restaurante para troca-lo.",
        ["Type"] = "Comum",
        ["Weight"] = 0.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["pizzathispass"] = {
        ["Index"] = "foodpass",
        ["Name"] = "Vale - Pizza This",
        ["Description"] = "Leve até o restaurante para troca-lo.",
        ["Type"] = "Comum",
        ["Weight"] = 0.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["burgershotpass"] = {
        ["Index"] = "foodpass",
        ["Name"] = "Vale - BurgerShot",
        ["Description"] = "Leve até o restaurante para troca-lo.",
        ["Type"] = "Comum",
        ["Weight"] = 0.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["c4"] = {
        ["Index"] = "c4",
        ["Name"] = "C4",
        ["Description"] = "C4, Bomba para roubar banco central",
        ["Type"] = "Usável",
        ["Weight"] = 1.75,
        ["Max"] = 10,
        ["Class"] = "Utilitarios",
        ["Economy"] = 625
    },
    ["geode"] = {
        ["Index"] = "geode",
        ["Name"] = "Geodo",
        ["Type"] = "Usável",
                ["Weight"] = 0.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 10
    },
    ["pickaxe"] = {
        ["Index"] = "pickaxe",
        ["Name"] = "Picareta",
        ["Description"] = "Picareta, arma branca",
        ["Repair"] = "repairkit01",
        ["Type"] = "Comum",
        ["Durability"] = 15,
        ["Weight"] = 1.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 525
    },
    -- ["suitcase"] = {
    --     ["Index"] = "suitcase",
    --     ["Name"] = "Maleta",
    --     ["Description"] = "Maleta, item sem função especifica",
    --     ["Type"] = "Usável",
    --     ["Weight"] = 1.0,
    --     ["Class"] = "Utilitarios",
    --     ["Economy"] = 275
    -- },
    ["badge01"] = {
        ["Index"] = "badge01",
        ["Name"] = "Distintivo",
        ["Description"] = "Departamento de policia",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Weight"] = 0.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 10
    },
    ["badge02"] = {
        ["Index"] = "badge02",
        ["Name"] = "Distintivo",
        ["Description"] = "Hospital",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Weight"] = 0.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 10
    },
    ["nigirizushi"] = {
        ["Index"] = "nigirizushi",
        ["Name"] = "Nigirizushi",
        ["Description"] = "Sushi, alimento",
        ["Type"] = "Usável",
        ["Weight"] = 0.65,
        ["Class"] = "Comida",
        ["Max"] = 3,
        ["Economy"] = 75
    },
    ["sushi"] = {
        ["Index"] = "sushi",
        ["Name"] = "Sushi",
        ["Description"] = "Sushi, alimento",
        ["Type"] = "Usável",
        ["Weight"] = 0.65,
        ["Class"] = "Comida",
        ["Max"] = 3,
        ["Economy"] = 75
    },
    ["cupcake"] = {
        ["Index"] = "cupcake",
        ["Name"] = "Cupcake",
        ["Description"] = "Cupcake, alimento",
        ["Type"] = "Usável",
        ["Weight"] = 0.55,
        ["Class"] = "Comida",
        ["Max"] = 3,
        ["Economy"] = 75
    },
    ["milkshake"] = {
        ["Index"] = "milkshake",
        ["Name"] = "Milk Shake",
        ["Description"] = "Milk Shake, alimento",
        ["Type"] = "Usável",
        ["Weight"] = 0.8555,
        ["Class"] = "Comida",
        ["Max"] = 3,
        ["Economy"] = 125
    },
    ["cappuccino"] = {
        ["Index"] = "cappuccino",
        ["Name"] = "Cappuccino",
        ["Description"] = "Cappuccino, café, alimento",
        ["Type"] = "Usável",
        ["Weight"] = 0.65,
        ["Class"] = "Comida",
        ["Max"] = 3,
        ["Economy"] = 150
    },
    ["applelove"] = {
        ["Index"] = "applelove",
        ["Name"] = "Maça do Amor",
        ["Description"] = "Maça do Amor, alimento",
        ["Type"] = "Usável",
        ["Weight"] = 0.55,
        ["Class"] = "Comida",
        ["Max"] = 2,
        ["Economy"] = 75
    },
    ["credential"] = {
        ["Index"] = "credential",
        ["Name"] = "Credencial",
        ["Description"] = "Credencial, para identificação, sem utilidade",
        ["Type"] = "Comum",
                ["Weight"] = 0.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 1000
    },
    ["racetrophy"] = {
        ["Index"] = "racetrophy",
        ["Name"] = "Troféu",
        ["Description"] = "Trofeu, item sem função",
        ["Type"] = "Comum",
        ["Weight"] = 1.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 2250
    },
    ["scanner"] = {
        ["Index"] = "scanner",
        ["Name"] = "Scanner",
        ["Description"] = "Scanner, item sem função",
        ["Repair"] = "repairkit02",
        ["Type"] = "Usável",
        ["Weight"] = 4.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 6750
    },
    ["postit"] = {
    	["Index"] = "postit",
        ["Description"] = "Postit, item sem função",
    	["Name"] = "Post-It",
    	["Type"] = "Usável",
    	["Weight"] = 0.25,
    	["Economy"] = 20
    },
    ["attachsFlashlight"] = {
        ["Index"] = "attachsFlashlight",
        ["Description"] = "Lanterna tatica, item para melhoria do armamento",
        ["Name"] = "Lanterna Tatica",
        ["Type"] = "Usável",
        ["Weight"] = 1.15,
        ["Class"] = "Utilitarios",
        ["Economy"] = 1750
    },
    ["attachsCrosshair"] = {
        ["Index"] = "attachsCrosshair",
        ["Name"] = "Mira Holográfica",
        ["Description"] = "Mira holográfica, item para melhoria do armamento",
        ["Type"] = "Usável",
        ["Weight"] = 1.15,
        ["Class"] = "Utilitarios",
        ["Economy"] = 1750
    },
    ["attachsSilencer"] = {
        ["Index"] = "attachsSilencer",
        ["Name"] = "Silenciador",
        ["Description"] = "Silenciador, item para melhoria do armamento",
        ["Type"] = "Usável",
        ["Weight"] = 1.15,
        ["Class"] = "Utilitarios",
        ["Economy"] = 1750
    },
    ["attachsMagazine"] = {
        ["Index"] = "attachsMagazine",
        ["Name"] = "Pente Estendido",
        ["Description"] = "Pente estendido, quantidade maior de munição para melhoria do armamento",
        ["Type"] = "Usável",
        ["Weight"] = 1.15,
        ["Class"] = "Utilitarios",
        ["Economy"] = 1750
    },
    ["attachsGrip"] = {
        ["Index"] = "attachsGrip",
        ["Name"] = "Empunhadura",
        ["Description"] = "Empunhadura, item para melhoria do armamento",
        ["Type"] = "Usável",
        ["Weight"] = 1.15,
        ["Class"] = "Utilitarios",
        ["Economy"] = 1750
    },
    ["cheese"] = {
        ["Index"] = "cheese",
        ["Name"] = "Queijo",
        ["Description"] = "Queijo, alimennto",
        ["Type"] = "Comum",
        ["Weight"] = 0.55,
        ["Class"] = "Comida",
        ["Economy"] = 10
    },
    ["silk"] = {
        ["Index"] = "silk",
        ["Name"] = "Seda",
        ["Description"] = "Seda, farm para produção de maconha",
        ["Type"] = "Comum",
        ["Weight"] = 0.01,
        ["Block"] = true,
["Class"] = "Drogas",
        ["Economy"] = 1000
    },
    ["tablecoke"] = {
        ["Index"] = "tablecoke",
        ["Name"] = "Mesa de Criação",
        ["Description"] = "Utilizada para criação de Cocaína.",
        ["Repair"] = "repairkit02",
        ["Type"] = "Usável",
        ["Weight"] = 12.75,
        ["Class"] = "Drogas",
        ["Economy"] = 1750
    },
    ["tablemeth"] = {
        ["Index"] = "tablemeth",
        ["Name"] = "Mesa de Criação",
        ["Description"] = "Utilizada para criação de Metanfetamina.",
        ["Repair"] = "repairkit02",
        ["Type"] = "Usável",
        ["Weight"] = 12.75,
        ["Class"] = "Drogas",
        ["Economy"] = 1750
    },
    ["tableweed"] = {
        ["Index"] = "tableweed",
        ["Name"] = "Mesa de Criação",
        ["Description"] = "Utilizada para criação de Baseados.",
        ["Repair"] = "repairkit02",
        ["Type"] = "Usável",
        ["Weight"] = 12.75,
        ["Class"] = "Drogas",
        ["Economy"] = 1750
    },
    ["campfire"] = {
        ["Index"] = "campfire",
        ["Name"] = "Fogueira",
        ["Description"] = "Fogueira, item sem função",
        ["Type"] = "Usável",
        ["Weight"] = 1.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 675
    },
    -- ["barrier"] = {
    --     ["Index"] = "barrier",
    --     ["Name"] = "Barreira",
    --     ["Description"] = "Barreira, item sem função",
    --     ["Type"] = "Usável",
    --     ["Weight"] = 1.75,
    --     ["Class"] = "Utilitarios",
    --     ["Economy"] = 250
    -- },
    ["medicbag"] = {
        ["Index"] = "medicbag",
        ["Name"] = "Bolsa Médica",
        ["Description"] = "Bolsa médica, item sem função", 
        ["Type"] = "Usável",
        ["Weight"] = 1.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 425
    },
    ["medicbed"] = {
        ["Index"] = "medicbed",
        ["Name"] = "Maca Médica",
        ["Description"] = "Maca médica, item para colocar o paciente a locomoção ou atendimento",
        ["Type"] = "Usável",
        ["Weight"] = 1.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 725
    },
    ["techtrash"] = {
        ["Index"] = "techtrash",
        ["Name"] = "Lixo Eletrônico",
        ["Description"] = "Lixo para descarte, sem função",
        ["Type"] = "Comum",
                ["Weight"] = 0.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 125
    },
    ["tarp"] = {
        ["Index"] = "tarp",
        ["Name"] = "Lona",
        ["Description"] = "Lona, sem função",
        ["Type"] = "Comum",
        ["Weight"] = 0.65,
        ["Class"] = "Utilitarios",
        ["Economy"] = 50
    },
    ["sheetmetal"] = {
        ["Index"] = "sheetmetal",
        ["Name"] = "Chapa de Metal",
        ["Description"] = "Chapa de Metal, sem função",
        ["Type"] = "Comum",
                ["Weight"] = 0.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 50
    },
    ["roadsigns"] = {
        ["Index"] = "roadsigns",
        ["Name"] = "Placas de Trânsito",
        ["Description"] = "Placas de trânsito, sem função",
        ["Type"] = "Comum",
        ["Weight"] = 0.65,
        ["Class"] = "Utilitarios",
        ["Economy"] = 50
    },
    ["leather"] = {
        ["Index"] = "leather",
        ["Name"] = "Couro",
        ["Description"] = "Couro, sem função",
        ["Type"] = "Comum",
        ["Weight"] = 0.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 20
    },
    ["explosives"] = {
        ["Index"] = "explosives",
        ["Name"] = "Explosivos",
        ["Description"] = "",
        ["Type"] = "Comum",
        ["Weight"] = 0.55,
        ["Class"] = "Utilitarios",
        ["Economy"] = 75
    },
    ["fidentity"] = {
        ["Index"] = "identity",
        ["Name"] = "Passaporte",
        ["Description"] = "Passaporte para identificação",
        ["Type"] = "Comum",
        ["Weight"] = 0.15,
        ["Class"] = "Utilitarios",
        ["Economy"] = 10000
    },
    ["identity"] = {
        ["Index"] = "identity",
        ["Name"] = "Passaporte",
        ["Description"] = "Passaporte para identificação",
        ["Type"] = "Comum",
        ["Weight"] = 0.15,
        ["Class"] = "Utilitarios",
        ["Economy"] = 5000
    },
    ["blocksignal"] = {
        ["Index"] = "blocksignal",
        ["Name"] = "Bloqueador de Sinal",
        ["Description"] = "Bloqueador de Sinal, sem função",
        ["Type"] = "Usável",
                ["Weight"] = 0.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 325
    },
    ["pistolbody"] = {
        ["Index"] = "pistolbody",
        ["Name"] = "Corpo de Pistola",
        ["Description"] = "Corpo de Pistola, farma para criação de armamento",
        ["Type"] = "Comum",
                ["Weight"] = 0.75,
        ["Class"] = "Armas",
        ["Economy"] = 425
    },
    ["smgbody"] = {
        ["Index"] = "smgbody",
        ["Name"] = "Corpo de Sub-Metralhadora",
        ["Description"] = "Corpo de Sub-Metralhadora, farm para criação de armamento",
        ["Type"] = "Comum",
        ["Weight"] = 0.85,
        ["Class"] = "Armas",
        ["Economy"] = 525
    },
    ["dinheirosujo"] = {
        ["Index"] = "dinheirosujo",
        ["Name"] = "Dinheiro Sujo",
        ["Description"] = "Dinheiro sujo, feito em algo ilegal, por ex: desmanche de carro",
        ["Type"] = "Comum",
        ["Weight"] = 0.0,
        ["Class"] = "Utilitarios",
        ["Economy"] = 1
    },
    ["keycard"] = {
        ["Index"] = "keycard",
        ["Name"] = "Keycard",
        ["Type"] = "Comum",
        ["Weight"] = 0.95,
        ["Class"] = "Utilitarios",
        ["Economy"] = 625
    },
    ["aguadestilada"] = {
        ["Index"] = "aguadestilada",
        ["Name"] = "Agua Destilada",
        ["Description"] = "Agua destilada, item de farm para criação de meta",
        ["Type"] = "Comum",
        ["Weight"] = 0.00,
        ["Block"] = true,
        ["Class"] = "Drogas",
        ["Economy"] = 1000
    },
    ["cloro"] = {
        ["Index"] = "cloro",
        ["Name"] = "Cloro",
        ["Description"] = "Cloro, item de farm para criação de meta",
        ["Type"] = "Comum",
        ["Weight"] = 0.0,
        ["Block"] = true,
        ["Class"] = "Drogas",
        ["Economy"] = 625
    },
    ["weaponbody"] = {
        ["Index"] = "weaponbody",
        ["Name"] = "Peça de Arma",
        ["Description"] = "Peça de Arma, item de farm para criação para armamento",
        ["Type"] = "Comum",
        ["Weight"] = 0.01,
        ["Block"] = true,
["Class"] = "Armas",
        ["Economy"] = 625
    },
    ["alvejantepequeno"] = {
        ["Index"] = "alvejantepequeno",
        ["Name"] = "Alvejante Pequeno ",
        ["Description"] = "Alvejante Pequeno, item de farm para lavar dinheiro sujo",
        ["Type"] = "Comum",
        ["Weight"] = 0.95,
        ["Class"] = "Drogas",
        ["Economy"] = 625
    },
    ["alvejantemedio"] = {
        ["Index"] = "alvejantemedio",
        ["Name"] = "Alvejante Medio",
        ["Description"] = "Alvejante Médio, item de farm para lavar dinheiro sujo",
        ["Type"] = "Comum",
        ["Weight"] = 0.95,
        ["Class"] = "Drogas",
        ["Economy"] = 625
    },
    ["alvejantegrande"] = {
        ["Index"] = "alvejantegrande",
        ["Name"] = "Alvejante Grande",
        ["Description"] = "Alvejante Grande, item de farm para lavar dinheiro sujo",
        ["Type"] = "Comum",
        ["Weight"] = 0.95,
        ["Class"] = "Drogas",
        ["Economy"] = 625
    },
    ["molas"] = {
        ["Index"] = "molas",
        ["Name"] = "Molas",
        ["Description"] = "Molas, item de farm para criação de armamento",
        ["Type"] = "Comum",
        ["Weight"] = 0.01,
        ["Block"] = true,
["Class"] = "Armas",
        ["Economy"] = 0
    },
    ["capsula"] = {
        ["Index"] = "capsula",
        ["Name"] = "Capsula",
        ["Description"] = "Item de farm para criação de munição",
        ["Type"] = "Comum",
        ["Weight"] = 0.01,
        ["Block"] = true,
["Class"] = "Armas",
        ["Economy"] = 0
    },
    ["polvora"] = {
        ["Index"] = "polvora",
        ["Name"] = "Polvora",
        ["Description"] = "Item de farm para criação de munição",
        ["Type"] = "Comum",
        ["Weight"] = 0.01,
        ["Block"] = true,
["Class"] = "Armas",
        ["Economy"] = 625
    },
    ["cotton"] = {
        ["Index"] = "cotton",
        ["Name"] = "Algodão",
        ["Description"] = "Algodão, item sem função",
        ["Type"] = "Comum",
        ["Weight"] = 0.35,
        ["Class"] = "Utilitarios",
        ["Economy"] = 45
    },
    ["plaster"] = {
        ["Index"] = "plaster",
        ["Name"] = "Esparadrapo",
        ["Description"] = "Esparadrapo, item sem função",
        ["Type"] = "Comum",
        ["Weight"] = 0.45,
        ["Class"] = "Utilitarios",
        ["Economy"] = 35
    },
    ["sulfuric"] = {
        ["Index"] = "sulfuric",
        ["Name"] = "Ácido Sulfúrico",
        ["Description"] = "Ácido Sulfúrico, item de farm para cocaina",
        ["Type"] = "Usável",
        ["Weight"] = 0.01,
        ["Block"] = true,
["Class"] = "Drogas",
        ["Economy"] = 30
    },
    ["saline"] = {
        ["Index"] = "saline",
        ["Name"] = "Soro Fisiológico",
        ["Description"] = "Soro Fisiológico, item sem função",
        ["Type"] = "Comum",
        ["Weight"] = 0.01,
        ["Block"] = true,
        ["Class"] = "Drogas",
        ["Economy"] = 1000
    },
    ["alcohol"] = {
        ["Index"] = "alcohol",
        ["Name"] = "Álcool",
        ["Description"] = "Álcool, item sem função",
        ["Type"] = "Comum",
        ["Weight"] = 0.65,
        ["Class"] = "Drogas",
        ["Economy"] = 40
    },
    ["notebook"] = {
        ["Index"] = "notebook",
        ["Name"] = "Notebook",
        ["Description"] = "Notbook, serve para melhoria em alguns aspctos do veiculo",
        ["Repair"] = "repairkit02",
        ["Type"] = "Usável",
        ["Weight"] = 1.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 4250
    },
    ["syringe"] = {
        ["Index"] = "syringe",
        ["Name"] = "Seringa",
        ["Description"] = "Seringa, item sem função",
        ["Type"] = "Comum",
        ["Weight"] = 0.15,
        ["Class"] = "Utilitarios",
        ["Economy"] = 2
    },
    ["syringe01"] = {
        ["Index"] = "syringe2",
        ["Name"] = "Seringa A+",
        ["Description"] = "Seringa A+, item sem função",
        ["Type"] = "Comum",
        ["Weight"] = 0.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 10
    },
    ["syringe02"] = {
        ["Index"] = "syringe2",
        ["Name"] = "Seringa B+",
        ["Description"] = "Seringa B+, item sem função",
        ["Type"] = "Comum",
        ["Weight"] = 0.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 10
    },
    ["syringe03"] = {
        ["Index"] = "syringe2",
        ["Name"] = "Seringa A-",
        ["Description"] = "Seringa A-, item sem função",
        ["Type"] = "Comum",
        ["Weight"] = 0.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 10
    },
    ["syringe04"] = {
        ["Index"] = "syringe2",
        ["Name"] = "Seringa B-",
        ["Description"] = "Seringa B-, item sem função",
        ["Type"] = "Comum",
        ["Weight"] = 0.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 10
    },
    ["burgershot1"] = {
        ["Index"] = "burgershot1",
        ["Name"] = "Copo de Suco",
        ["Description"] = "Copo de suco, alimento",
        ["Type"] = "Comum",
        ["Weight"] = 0.25,
        ["Class"] = "Comida",
        ["Max"] = 1,
        ["Economy"] = 10
    },
    ["burgershot2"] = {
        ["Index"] = "burgershot2",
        ["Name"] = "Caixa de Lanche",
        ["Type"] = "Comum",
        ["Weight"] = 0.25,
        ["Class"] = "Comida",
        ["Max"] = 1,
        ["Economy"] = 10
    },
    ["burgershot3"] = {
        ["Index"] = "burgershot3",
        ["Name"] = "Combo",
        ["Type"] = "Comum",
        ["Weight"] = 1.25,
        ["Class"] = "Comida",
        ["Max"] = 2,
        ["Economy"] = 120
    },
    ["burgershot4"] = {
        ["Index"] = "burgershot3",
        ["Name"] = "Combo + Brinquedo",
        ["Type"] = "Comum",
        ["Weight"] = 1.25,
        ["Class"] = "Comida",
        ["Max"] = 2,
        ["Economy"] = 270
    },
    ["pizzathis1"] = {
        ["Index"] = "pizzathis1",
        ["Name"] = "Copo de Suco",
        ["Type"] = "Comum",
        ["Weight"] = 0.25,
        ["Class"] = "Comida",
        ["Max"] = 1,
        ["Economy"] = 10
    },
    ["pizzathis2"] = {
        ["Index"] = "pizzathis2",
        ["Name"] = "Caixa de Lanche",
        ["Type"] = "Comum",
        ["Weight"] = 0.25,
        ["Class"] = "Comida",
        ["Max"] = 1,
        ["Economy"] = 10
    },
    ["pizzathis3"] = {
        ["Index"] = "pizzathis3",
        ["Name"] = "Combo",
        ["Type"] = "Comum",
        ["Weight"] = 1.25,
        ["Class"] = "Comida",
        ["Max"] = 2,
        ["Economy"] = 120
    },
    ["pizzathis4"] = {
        ["Index"] = "pizzathis3",
        ["Name"] = "Combo + Brinquedo",
        ["Type"] = "Comum",
        ["Weight"] = 1.25,
        ["Class"] = "Comida",
        ["Max"] = 2,
        ["Economy"] = 270
    },
    ["uwucoffee1"] = {
        ["Index"] = "uwucoffee1",
        ["Name"] = "Copo de Suco",
        ["Description"] = "Copo de suco, alimento",
        ["Type"] = "Comum",
        ["Weight"] = 0.25,
        ["Class"] = "Comida",
        ["Max"] = 1,
        ["Economy"] = 10
    },
    ["uwucoffee2"] = {
        ["Index"] = "uwucoffee2",
        ["Name"] = "Caixa de Lanche",
        ["Type"] = "Comum",
        ["Weight"] = 0.25,
        ["Class"] = "Comida",
        ["Max"] = 1,
        ["Economy"] = 10
    },
    ["uwucoffee3"] = {
        ["Index"] = "uwucoffee3",
        ["Name"] = "Combo",
        ["Type"] = "Comum",
        ["Weight"] = 1.25,
        ["Class"] = "Comida",
        ["Max"] = 2,
        ["Economy"] = 120
    },
    ["uwucoffee4"] = {
        ["Index"] = "uwucoffee3",
        ["Name"] = "Combo + Brinquedo",
        ["Type"] = "Comum",
        ["Weight"] = 1.25,
        ["Class"] = "Comida",
        ["Max"] = 2,
        ["Economy"] = 270
    },
    ["beanmachine1"] = {
        ["Index"] = "beanmachine1",
        ["Name"] = "Copo de Suco",
        ["Description"] = "Copo de suco, alimento",
        ["Type"] = "Comum",
        ["Weight"] = 0.25,
        ["Class"] = "Comida",
        ["Max"] = 1,
        ["Economy"] = 10
    },
    ["beanmachine2"] = {
        ["Index"] = "beanmachine2",
        ["Name"] = "Caixa de Lanche",
        ["Type"] = "Comum",
        ["Weight"] = 0.25,
        ["Class"] = "Comida",
        ["Max"] = 1,
        ["Economy"] = 10
    },
    ["beanmachine3"] = {
        ["Index"] = "beanmachine3",
        ["Name"] = "Combo",
        ["Type"] = "Comum",
        ["Weight"] = 1.25,
        ["Class"] = "Comida",
        ["Max"] = 2,
        ["Economy"] = 120
    },
    ["beanmachine4"] = {
        ["Index"] = "beanmachine3",
        ["Name"] = "Combo + Brinquedo",
        ["Type"] = "Comum",
        ["Weight"] = 1.25,
        ["Class"] = "Comida",
        ["Max"] = 2,
        ["Economy"] = 270
    },
    ["wheelchair"] = {
        ["Index"] = "wheelchair",
        ["Name"] = "Cadeira de Rodas",
        ["Description"] = "Cadeira de Rodas, item para rp de [doente, machucado]",
        ["Type"] = "Usável",
        ["Weight"] = 1.25,
        ["Class"] = "Utilitarios",
        ["Block"] = true,
        ["BlockChest"] = true,
["Max"] = 1,
        ["Economy"] = 2750
    },
    ["vehkey"] = {
        ["Index"] = "vehkey",
        ["Name"] = "Chave Cópia",
        ["Type"] = "Usável",
                ["Weight"] = 0.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["evidence01"] = {
        ["Index"] = "evidence01",
        ["Name"] = "Evidência",
        ["Type"] = "Usável",
        ["Weight"] = 0.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["evidence02"] = {
        ["Index"] = "evidence02",
        ["Name"] = "Evidência",
        ["Type"] = "Usável",
        ["Weight"] = 0.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["evidence03"] = {
        ["Index"] = "evidence03",
        ["Name"] = "Evidência",
        ["Type"] = "Usável",
        ["Weight"] = 0.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["evidence04"] = {
        ["Index"] = "evidence04",
        ["Name"] = "Evidência",
        ["Type"] = "Usável",
        ["Weight"] = 0.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["card01"] = {
        ["Index"] = "card01",
        ["Name"] = "Cartão Comum",
        ["Description"] = "Roubar Lojas de Departamento.",
        ["Repair"] = "repairkit01",
        ["Type"] = "Comum",
        ["Weight"] = 0.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 325
    },
    ["card02"] = {
        ["Index"] = "card02",
        ["Name"] = "Cartão In-Comum",
        ["Description"] = "Roubar Lojas de Armas.",
        ["Repair"] = "repairkit01",
        ["Type"] = "Comum",
        ["Weight"] = 0.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 325
    },
    ["card03"] = {
        ["Index"] = "card03",
        ["Name"] = "Cartão Épico",
        ["Description"] = "Roubar Bancos Fleeca.",
        ["Repair"] = "repairkit01",
        ["Type"] = "Comum",
        ["Weight"] = 0.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 375
    },
    ["card04"] = {
        ["Index"] = "card04",
        ["Name"] = "Cartão Raro",
        ["Description"] = "Roubar Barbearias.",
        ["Repair"] = "repairkit01",
        ["Type"] = "Comum",
        ["Weight"] = 0.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 275
    },
    ["card05"] = {
        ["Index"] = "card05",
        ["Name"] = "Cartão Lendário",
        ["Description"] = "Roubar Bancos.",
        ["Repair"] = "repairkit01",
        ["Type"] = "Comum",
        ["Weight"] = 0.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 425
    },
    ["gemstone"] = {
        ["Index"] = "gemstone",
        ["Name"] = "Gemstone",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 2000
    },
    ["wardrobeslot"] = {
        ["Index"] = "wardrobeslot",
        ["Name"] = "Slot de Roupas",
        ["Description"] = "Adiciona um slot ao guarda-roupas.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["Economy"] = 100000
    },
    ["wardrobeslot"] = {
        ["Index"] = "wardrobeslot",
        ["Name"] = "Slot de Roupas",
        ["Description"] = "Adiciona um slot ao guarda-roupas.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["Economy"] = 100000
    },
    ["radio"] = {
        ["Index"] = "radio",
        ["Name"] = "Rádio",
        ["Description"] = "Rádio aparelho de comunicação.",
        ["Type"] = "Usável",
        ["Repair"] = "repairkit01",
                ["Weight"] = 0.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 975
    },
    ["ingresso-vanilla"] = {
        ["Index"] = "ingresso-vanilla",
        ["Name"] = "Ingresso Vanilla",
        ["Type"] = "Usável",
        ["Repair"] = "repairkit01",
                ["Weight"] = 0.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 975
    },
    ["separar"] = {
        ["Index"] = "separar",
        ["Name"] = "Separar",
        ["Type"] = "Usável",
        ["Repair"] = "repairkit01",
                ["Weight"] = 0.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 975
    },
    ["vest"] = {
        ["Index"] = "vest",
        ["Name"] = "Colete",
        ["Description"] = "Colete, vestimento de proteção contra tiros.",
        ["Type"] = "Usável",
        ["Durability"] = 3,
        ["Weight"] = 0.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 1500
    },
    ["bandage"] = {
        ["Index"] = "bandage",
        ["Name"] = "Bandagem",
        ["Description"] = "Bandagem, item médico para cura da vida.",
        ["Type"] = "Usável",
        ["Weight"] = 0.25,
        ["Class"] = "Medicamentos",
        ["Max"] = 3,
        ["Scape"] = {
            ["Paramedic"] = {
                {
                    ["Level"] = 1,
                    ["Amount"] = 10000
                }
            }
        },
        ["Economy"] = 15000
    },
    ["spray_red"] = {
        ["Index"] = "spray_red",
        ["Name"] = "Spray Vermelho",
        ["Description"] = "Spray para pintar veículo próximo (Admin/Influencer).",
        ["Type"] = "Usável",
        ["Weight"] = 0.2,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["spray_blue"] = {
        ["Index"] = "spray_blue",
        ["Name"] = "Spray Azul",
        ["Description"] = "Spray para pintar veículo próximo (Admin/Influencer).",
        ["Type"] = "Usável",
        ["Weight"] = 0.2,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["spray_green"] = {
        ["Index"] = "spray_green",
        ["Name"] = "Spray Verde",
        ["Description"] = "Spray para pintar veículo próximo (Admin/Influencer).",
        ["Type"] = "Usável",
        ["Weight"] = 0.2,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["spray_yellow"] = {
        ["Index"] = "spray_yellow",
        ["Name"] = "Spray Amarelo",
        ["Description"] = "Spray para pintar veículo próximo (Admin/Influencer).",
        ["Type"] = "Usável",
        ["Weight"] = 0.2,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["spray_white"] = {
        ["Index"] = "spray_white",
        ["Name"] = "Spray Branco",
        ["Description"] = "Spray para pintar veículo próximo (Admin/Influencer).",
        ["Type"] = "Usável",
        ["Weight"] = 0.2,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["spray_black"] = {
        ["Index"] = "spray_black",
        ["Name"] = "Spray Preto",
        ["Description"] = "Spray para pintar veículo próximo (Admin/Influencer).",
        ["Type"] = "Usável",
        ["Weight"] = 0.2,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["spray_purple"] = {
        ["Index"] = "spray_purple",
        ["Name"] = "Spray Roxo",
        ["Description"] = "Spray para pintar veículo próximo (Admin/Influencer).",
        ["Type"] = "Usável",
        ["Weight"] = 0.2,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["spray_orange"] = {
        ["Index"] = "spray_orange",
        ["Name"] = "Spray Laranja",
        ["Description"] = "Spray para pintar veículo próximo (Admin/Influencer).",
        ["Type"] = "Usável",
        ["Weight"] = 0.2,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["medkit"] = {
        ["Index"] = "medkit",
        ["Name"] = "Kit Médico",
        ["Type"] = "Usável",
                ["Weight"] = 0.75,
        ["Class"] = "Medicamentos",
        ["Max"] = 1,
        ["Economy"] = 575
    },
    ["woodlog"] = {
        ["Index"] = "woodlog",
        ["Name"] = "Tora de Madeira",
        ["Description"] = "Tora de Madeira, item sem função.",
        ["Type"] = "Comum",
                ["Weight"] = 0.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 40
    },
    ["fishingrod"] = {
        ["Index"] = "fishingrod",
        ["Name"] = "Vara de Pescar",
        ["Description"] = "Item para pesca.",
        ["Type"] = "Usável",
        ["Weight"] = 1.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 725
    },
    ["switchblade"] = {
        ["Index"] = "switchblade",
        ["Name"] = "Canivete",
        ["Type"] = "Usável",
        ["Description"] = "Utilizada para remoção de carne.",
                ["Weight"] = 0.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 525
    },
    ["octopus"] = {
        ["Index"] = "octopus",
        ["Name"] = "Polvo",
        ["Type"] = "Comum",
                ["Weight"] = 0.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 14
    },
    ["shrimp"] = {
        ["Index"] = "shrimp",
        ["Name"] = "Camarão",
        ["Type"] = "Comum",
        ["Weight"] = 0.50,
        ["Class"] = "Utilitarios",
        ["Economy"] = 14
    },
    ["carp"] = {
        ["Index"] = "carp",
        ["Name"] = "Carpa",
        ["Type"] = "Usável",
        ["Weight"] = 0.50,
        ["Class"] = "Utilitarios",
        ["Economy"] = 12
    },
    ["codfish"] = {
        ["Index"] = "codfish",
        ["Name"] = "Bacalhau",
        ["Type"] = "Usável",
        ["Weight"] = 0.50,
        ["Class"] = "Utilitarios",
        ["Economy"] = 16
    },
    ["catfish"] = {
        ["Index"] = "catfish",
        ["Name"] = "Bagre",
        ["Type"] = "Usável",
        ["Weight"] = 0.50,
        ["Class"] = "Utilitarios",
        ["Economy"] = 16
    },
    ["goldenfish"] = {
        ["Index"] = "goldenfish",
        ["Name"] = "Dourado",
        ["Type"] = "Usável",
        ["Weight"] = 0.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 30
    },
    ["horsefish"] = {
        ["Index"] = "horsefish",
        ["Name"] = "Cavala",
        ["Type"] = "Usável",
        ["Weight"] = 0.50,
        ["Class"] = "Utilitarios",
        ["Economy"] = 12
    },
    ["tilapia"] = {
        ["Index"] = "tilapia",
        ["Name"] = "Tilápia",
        ["Type"] = "Usável",
        ["Weight"] = 0.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 14
    },
    ["pacu"] = {
        ["Index"] = "pacu",
        ["Name"] = "Pacu",
        ["Type"] = "Usável",
        ["Weight"] = 0.50,
        ["Class"] = "Utilitarios",
        ["Economy"] = 24
    },
    ["pirarucu"] = {
        ["Index"] = "pirarucu",
        ["Name"] = "Pirarucu",
        ["Type"] = "Usável",
        ["Weight"] = 0.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 26
    },
    ["tambaqui"] = {
        ["Index"] = "tambaqui",
        ["Name"] = "Tambaqui",
        ["Type"] = "Usável",
                ["Weight"] = 0.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 28
    },
    ["bait"] = {
        ["Index"] = "bait",
        ["Name"] = "Isca",
        ["Type"] = "Comum",
        ["Weight"] = 0.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 5
    },
    ["weedclone"] = {
        ["Index"] = "weedclone",
        ["Name"] = "Clonagem de Maconha",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Drogas",
        ["Economy"] = 0
    },
    ["weedleaf"] = {
        ["Index"] = "weedleaf",
        ["Name"] = "Folha de Maconha",
        ["Description"] = "Farm para craft de baeado.",
        ["Type"] = "Comum",
        ["Weight"] = 0.01,
        ["Block"] = true,
["Class"] = "Drogas",
        ["Economy"] = 1000
    },
    ["joint"] = {
        ["Index"] = "joint",
        ["Name"] = "Baseado",
        ["Description"] = "Você recebe um colete extra ao usar este item.",
        ["Type"] = "Usável",
        ["Weight"] = 0.05,
        ["Class"] = "Drogas",
        ["Economy"] = 10000
    },
    ["lanca"] = {
        ["Index"] = "lanca",
        ["Name"] = "Lança",
        ["Description"] = "Apenas para ficar doidão.",
        ["Type"] = "Usável",
        ["Weight"] = 0.05,
        ["Class"] = "Drogas",
        ["Economy"] = 10000
    },
    ["md"] = {
        ["Index"] = "md",
        ["Name"] = "MD",
        ["Description"] = "Apenas para ficar doidão.",
        ["Type"] = "Usável",
        ["Weight"] = 0.05,
        ["Class"] = "Drogas",
        ["Economy"] = 10000
    },
    ["codeine"] = {
        ["Index"] = "codeine",
        ["Name"] = "Codeína",
        ["Type"] = "Comum",
        ["Weight"] = 0.10,
        ["Class"] = "Drogas",
        ["Economy"] = 10000
    },
    ["amphetamine"] = {
        ["Index"] = "amphetamine",
        ["Name"] = "Anfetamina",
        ["Type"] = "Comum",
        ["Weight"] = 0.05,
        ["Class"] = "Drogas",
        ["Economy"] = 1000
    },
    ["cocaine"] = {
        ["Index"] = "cocaine",
        ["Name"] = "Coca",
        ["Description"] = "Aumenta sua velocidade ao correr.",
        ["Type"] = "Usável",
        ["Weight"] = 0.05,
        ["Class"] = "Drogas",
        ["Economy"] = 10000
    },
    ["cokeleaf"] = {
        ["Index"] = "cokeleaf",
        ["Name"] = "Folha de Coca",
        ["Description"] = "Item de farm para cocaina.",
        ["Type"] = "Comum",
        ["Weight"] = 0.01,
        ["Block"] = true,
["Class"] = "Drogas",
        ["Economy"] = 1000
    },
    ["meth"] = {
        ["Index"] = "meth",
        ["Name"] = "Metanfetamina",
        ["Description"] = "Você recebe um colete extra ao usar este item.",
        ["Type"] = "Usável",
        ["Weight"] = 0.05,
        ["Class"] = "Drogas",
        ["Economy"] = 10000
    },
    ["acetone"] = {
        ["Index"] = "acetone",
        ["Name"] = "Acetona",
        ["Type"] = "Comum",
        ["Weight"] = 0.01,
        ["Class"] = "Drogas",
        ["Economy"] = 1000
    },
    ["drugtoy"] = {
        ["Index"] = "drugtoy",
        ["Name"] = "Brinquedo",
        ["Type"] = "Comum",
        ["Weight"] = 0.50,
        ["Class"] = "Utilitarios",
        ["Economy"] = 100
    },
    ["rolepass"] = {
        ["Index"] = "rolepass",
        ["Name"] = "BattlePass Premium",
        ["Description"] = "Item da loja vip.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 200000
    },
    ["premium01"] = {
        ["Index"] = "premium01",
        ["Name"] = "VIP Diamante",
        ["Description"] = "Item da loja vip.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 300000
    },
    ["premium02"] = {
        ["Index"] = "premium02",
        ["Name"] = "VIP Policia",
        ["Description"] = "Item da loja vip.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 250000
    },
    ["premium03"] = {
        ["Index"] = "premium03",
        ["Name"] = "VIP Ouro",
        ["Description"] = "Item da loja vip.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 200000
    },
    ["setvehicles1"] = {
        ["Index"] = "setvehicles1",
        ["Name"] = "Veiculo VIP",
        ["Description"] = "Item para setar veículos.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Economy"] = 200000
    },
    ["setvehicles2"] = {
        ["Index"] = "setvehicles2",
        ["Name"] = "Veiculo VIP Black",
        ["Description"] = "Item para setar veículos VIP Black.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["Economy"] = 200000
    },

    ["vehicleselite"] = {
        ["Index"] = "vehicleselite",
        ["Name"] = "Veiculo Elite",
        ["Description"] = "Item para setar veículos.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 200000
    },
    ["vehiclesstart"] = {
        ["Index"] = "vehiclesstart",
        ["Name"] = "Veiculo Start",
        ["Description"] = "Item para setar veículos.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 200000
    },
    ["vehicles16t"] = {
        ["Index"] = "vehicles16t",
        ["Name"] = "Veiculo 16T",
        ["Description"] = "Item para setar veículos.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 200000
    },
    ["vehicles16tpf"] = {
        ["Index"] = "vehicles16tpf",
        ["Name"] = "Veiculo 16TPF",
        ["Description"] = "Item para setar veículos.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 200000
    },
    ["vehicles32t"] = {
        ["Index"] = "vehicles32t",
        ["Name"] = "Veiculo 32T",
        ["Description"] = "Item para setar veículos.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 200000
    },
    ["vehiclesfull2k"] = {  
        ["Index"] = "vehiclesfull2k",
        ["Name"] = "Veiculo 2K",
        ["Description"] = "Item para setar veículos.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 200000
    },
    ["vehiclesfull2500k"] = {
        ["Index"] = "vehiclesfull2500k",
        ["Name"] = "Veiculo 2500K",
        ["Description"] = "Item para setar veículos.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 200000
    },
    ["vehiclesfull3k"] = {
        ["Index"] = "vehiclesfull3k",
        ["Name"] = "Veiculo 3K",
        ["Description"] = "Item para setar veículos.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 200000
    },
    ["vehiclesfullabs"] = {
        ["Index"] = "vehiclesfullabs",
        ["Name"] = "Veiculo ABS",
        ["Description"] = "Item para setar veículos.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 200000
    },
    ["skorpion2_15d"] = {
        ["Index"] = "skorpion2_15d",
        ["Name"] = "Skorpion II — 15 dias",
        ["Description"] = "Adiciona o veículo Skorpion II na garagem por 15 dias (temporário).",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 0
    },
    ["skorpion2_30d"] = {
        ["Index"] = "skorpion2_30d",
        ["Name"] = "Skorpion II — 30 dias",
        ["Description"] = "Adiciona o veículo Skorpion II na garagem por 30 dias (temporário).",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 0
    },
    ["vipevento1"] = {
        ["Index"] = "vipevento1",
        ["Name"] = "Vip Evento Prata",
        ["Description"] = "Item para eventos.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 200000
    },
    ["vipevento2"] = {
        ["Index"] = "vipevento2",
        ["Name"] = "Vip Evento Ouro",
        ["Description"] = "Item para eventos.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 200000
    },
    ['ticketrace'] = {
        ["Index"] = "ticketrace",
        ["Name"] = "Ticket de Corrida",
        ["Description"] = "Item para corridas comuns.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 200000
    },
    ['ticketracevip'] = {
        ["Index"] = "ticketracevip",
        ["Name"] = "Ticket de Corrida VIP",
        ["Description"] = "Item para corridas VIP.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 200000
    },
    ["vipstaff"] = {
        ["Index"] = "vipstaff",
        ["Name"] = "VIP Staff",
        ["Description"] = "Item para staff.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 200000
    },

    ["vipsorteio"] = {
        ["Index"] = "premium03",
        ["Name"] = "VIP Sorteio",
        ["Description"] = "Item para sorteios.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 200000
    },
    ["premium04"] = {
        ["Index"] = "premium04",
        ["Name"] = "VIP Prata",
        ["Description"] = "Item da loja vip.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 150000
    },
    ["premium05"] = {
        ["Index"] = "premium05",
        ["Name"] = "VIP Bronze",
        ["Description"] = "Item da loja vip.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 150000
    },
    ["WEAPON_TONYSTARK"] = {
        ["Index"] = "Tony Stark",
        ["Name"] = "TONYSTARK",
        ["Description"] = "Item da loja vip.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 150000
    },
    -- ["WEAPON_TONYSTARK"] = {
    --     ["Index"] = "Tony Stark",
    --     ["Name"] = "TONYSTARK",
    --     ["Repair"] = "repairkit04",
    --     ["Type"] = "Armamento",
    --     ["Ammo"] = "WEAPON_RIFLE_AMMO",
    --     ["Weight"] = 3.75,
    --     ["Block"] = true,
   -- ["BlockChest"] = true,
--     ["Class"] = "Armas",
    --     ["Economy"] = 775
    -- },
    ["petretriever"] = {
        ["Index"] = "petretriever",
        ["Name"] = "petretriever",
        ["Description"] = "Item para pets.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 200000
    },
    ["petrottweiler"] = {
        ["Index"] = "petrottweiler",
        ["Name"] = "petrottweiler",
        ["Description"] = "Item para pets.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 200000
    },
    ["peturso"] = {
        ["Index"] = "peturso",
        ["Name"] = "peturso",
        ["Description"] = "Item para pets.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 200000
    },
    ["petwesty"] = {
        ["Index"] = "petwesty",
        ["Name"] = "petwesty",
        ["Description"] = "Item para pets.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 200000
    },
    ["petpug"] = {
        ["Index"] = "petpug",
        ["Name"] = "petpug",
        ["Description"] = "Item para pets.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 200000
    },
    ["petbulldog"] = {
        ["Index"] = "petbulldog",
        ["Name"] = "petbulldog",
        ["Description"] = "Item para pets.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 200000
    },
    ["petgreyhound"] = {
        ["Index"] = "petgreyhound",
        ["Name"] = "petgreyhound",
        ["Description"] = "Item para pets.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 200000
    },
    ["petchimp"] = {
        ["Index"] = "petchimp",
        ["Name"] = "petchimp",
        ["Description"] = "Item para pets.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 200000
    },
    ["petrhesus"] = {
        ["Index"] = "petrhesus",
        ["Name"] = "petrhesus",
        ["Description"] = "Item para pets.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 200000
    },
    ["petcrocodilo"] = {
        ["Index"] = "petcrocodilo",
        ["Name"] = "petcrocodilo",
        ["Description"] = "Item para pets.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 200000
    },
    ["petjully"] = {
        ["Index"] = "petjully",
        ["Name"] = "petjully",
        ["Description"] = "Item para pets.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 200000
    },
    ["LoboSirius"] = {
        ["Index"] = "LoboSirius",
        ["Name"] = "LoboSirius",
        ["Description"] = "Item para pets.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 200000
    },
    ["Tigor"] = {
        ["Index"] = "Tigor",
        ["Name"] = "Tigor",
        ["Description"] = "Item para pets.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 200000
    },
    ["Rajah"] = {
        ["Index"] = "Rajah",
        ["Name"] = "Rajah",
        ["Description"] = "Item para pets.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 200000
    },
    ["pethusky"] = {
        ["Index"] = "pethusky",
        ["Name"] = "pethusky",
        ["Description"] = "Item para pets.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 200000
    },
    ["petshepherd"] = {
        ["Index"] = "petshepherd",
        ["Name"] = "petshepherd",
        ["Description"] = "Item para pets.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 200000
    },
    ["petpoodle"] = {
        ["Index"] = "petpoodle",
        ["Name"] = "petpoodle",
        ["Description"] = "Item para pets.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 200000
    },
    ["petovelha"] = {
        ["Index"] = "petovelha",
        ["Name"] = "petovelha",
        ["Description"] = "Item para pets.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 200000
    },
    ["pedretrom"] = {
        ["Index"] = "pedretrom",
        ["Name"] = "Retro M",
        ["Description"] = "Libera a skin de personagem Retro M.",
        ["Type"] = "Usável",
        ["Weight"] = 0.0,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Economy"] = 0
    },
    ["pedretrof"] = {
        ["Index"] = "pedretrof",
        ["Name"] = "Retro F",
        ["Description"] = "Libera a skin de personagem Retro F.",
        ["Type"] = "Usável",
        ["Weight"] = 0.0,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Economy"] = 0
    },
    ["petpanda"] = {
        ["Index"] = "petpanda",
        ["Name"] = "petpanda",
        ["Description"] = "Item para pets.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Economy"] = 200000
    },
    ["petjavali"] = {
        ["Index"] = "petjavali",
        ["Name"] = "petjavali",
        ["Description"] = "Item para pets.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 200000
    },
    ["dragaolcfr"] = {
        ["Index"] = "dragaolcfr",
        ["Name"] = "dragaolcfr",
        ["Description"] = "Item para pets.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["Economy"] = 200000
    },
    ["petdragao1"] = {
        ["Index"] = "dragao1",
        ["Name"] = "Dragão Fúria",
        ["Description"] = "Item para pets.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Economy"] = 200000
    },
    ["petdragao2"] = {
        ["Index"] = "dragao2",
        ["Name"] = "Dragão Lunar",
        ["Description"] = "Item para pets.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Economy"] = 200000
    },
    ["petdragao3"] = {
        ["Index"] = "petdragao3",
        ["Name"] = "Dragão Colosso",
        ["Description"] = "Item para pets.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Economy"] = 200000
    },
    ["petdragao4"] = {
        ["Index"] = "petdragao4",
        ["Name"] = "Dragão Soberano",
        ["Description"] = "Item para pets.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Economy"] = 200000
    },
    ["petdragao5"] = {
        ["Index"] = "petdragao5",
        ["Name"] = "Dragão Celestial",
        ["Description"] = "Item para pets.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Economy"] = 200000
    },
    ["petdragao6"] = {
        ["Index"] = "petdragao6",
        ["Name"] = "Dragão Abissal",
        ["Description"] = "Item para pets.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Economy"] = 200000
    },
    ["petdragao7"] = {
        ["Index"] = "petdragao7",
        ["Name"] = "Dragão Boreal",
        ["Description"] = "Item para pets.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Economy"] = 200000
    },
    ["petdragao8"] = {
        ["Index"] = "petdragao8",
        ["Name"] = "Dragão Ônix",
        ["Description"] = "Item para pets.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Economy"] = 200000
    },
    ["petcanecorso"] = {
        ["Index"] = "petcanecorso",
        ["Name"] = "petcanecorso",
        ["Description"] = "Item para pets.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 200000
    },
    ["petdoberman"] = {
        ["Index"] = "petdoberman",
        ["Name"] = "petdoberman",
        ["Description"] = "Item para pets.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 200000
    },
    ["petcat"] = {
        ["Index"] = "petcat",
        ["Name"] = "petcat",
        ["Description"] = "Item para pets.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 200000
    },
    ["petsphynx"] = {
        ["Index"] = "petsphynx",
        ["Name"] = "petsphynx",
        ["Description"] = "Item para pets.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 200000
    },  
    ["monkey"] = {
        ["Index"] = "monkey",
        ["Name"] = "monkey",
        ["Description"] = "Item para pets.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 200000
    }, 
    ["kitorgs"] = {
        ["Index"] = "kitorgs",
        ["Name"] = "Kit Orgs",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 150000
    },  
    ["kitfaclavagem"] = {
        ["Index"] = "kitfaclavagem",
        ["Name"] = "Kit Fac Lavagem",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 150000
    },  
    ["kitfacmaconha"] = {
        ["Index"] = "kitfacmaconha",
        ["Name"] = "Kit Fac Conha",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 150000
    },  
    ["kitfaccoca"] = {
        ["Index"] = "kitfaccoca",
        ["Name"] = "Kit Fac Coca",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 150000
    },  
    ["kitfacmeta"] = {
        ["Index"] = "kitfacmeta",
        ["Name"] = "Kit Fac Meta",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 150000
    },  
    ["kitfacmunicao"] = {
        ["Index"] = "kitfacmunicao",
        ["Name"] = "Kit Fac Municao",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 150000
    },  
    ["kitfacdesmanche"] = {
        ["Index"] = "kitfacdesmanche",
        ["Name"] = "Kit Fac Desmanche",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 150000
    },
    ["kitfacarmas"] = {
        ["Index"] = "kitfacarmas",
        ["Name"] = "Kit Fac Armas",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 150000
    },  
    ["kitblack2"] = {
        ["Index"] = "kitblack2",
        ["Name"] = "Kit Black2",
        ["Description"] = "Item da loja vip.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["Economy"] = 150000
    },
    ["kitarmas1"] = {
        ["Index"] = "kitarma",
        ["Name"] = "Kit Armas",
        ["Description"] = "Item da loja vip.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 150000
    },
    ["kitarmas2"] = {
        ["Index"] = "kitarma",
        ["Name"] = "Kit Armas",
        ["Description"] = "Item da loja vip.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 150000
    },
    ["kitarmas3"] = {
        ["Index"] = "kitarma",
        ["Name"] = "Kit Armas",
        ["Description"] = "Item da loja vip.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 150000
    },
    ["kitarmas4"] = {
        ["Index"] = "kitarma",
        ["Name"] = "Kit Armas",
        ["Description"] = "Item da loja vip.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 150000
    },
    ["kitarmas5"] = {
        ["Index"] = "kitarma",
        ["Name"] = "Kit Armas",
        ["Description"] = "Item da loja vip.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 150000
    },
    ["kitarmas6"] = {
        ["Index"] = "kitarma",
        ["Name"] = "Kit Armas",
        ["Description"] = "Item da loja vip.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 150000
    },
    ["kitarmas7"] = {
        ["Index"] = "kitarma",
        ["Name"] = "Kit Armas VIP Black 30 Dias",
        ["Description"] = "Item da loja VIP Black de 30 dias.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 150000
    },
    ["kitdosraul"] = {
        ["Index"] = "kitdosraul",
        ["Name"] = "Kit dos Raul",
        ["Description"] = "Item da loja vip.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 150000
    },
    ["kitboqueta"] = {
        ["Index"] = "kitboqueta",
        ["Name"] = "Kit Boqueta",
        ["Description"] = "Item da loja vip.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 150000
    },
    ["kitmafioso"] = {
        ["Index"] = "kitmafioso",
        ["Name"] = "Kit Mafioso",
        ["Description"] = "Item da loja vip.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 150000
    },
    ["kitcriminal"] = {
        ["Index"] = "kitcriminal",
        ["Name"] = "Kit Criminal",
        ["Description"] = "Item da loja vip.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 150000
    },
    ["kitfogueteiro"] = {
        ["Index"] = "kitfogueteiro",
        ["Name"] = "Kit Fogueteiro",
        ["Description"] = "Item da loja vip.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 150000
    },
    ["premiumplate"] = {
        ["Index"] = "platepremium",
        ["Name"] = "Placa Personalizada",
        ["Type"] = "Usável",
        ["Description"] = "Personaliza a placa do veículo.",
                ["Weight"] = 0.75,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 100000
    },
    ["phonechange"] = {
        ["Index"] = "phonechange",
        ["Name"] = "Número Personalizada",
        ["Type"] = "Usável",
        ["Description"] = "Personaliza a número de telefone.",
                ["Weight"] = 0.75,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 100000
    },
    ["newchars"] = {
        ["Index"] = "newchars",
        ["Name"] = "+1 Personagem",
        ["Type"] = "Usável",
        ["Description"] = "Limite de personagem em +1.",
        ["Weight"] = 0.25,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 150000
    },
    ["profilepicture"] = {
        ["Index"] = "namechange",
        ["Name"] = "Foto de Perfil",
        ["Type"] = "Usável",
        ["Description"] = "Troca a foto de perfil do personagem.",
        ["Weight"] = 0.0,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
    },
    ["namechange"] = {
        ["Index"] = "namechange",
        ["Name"] = "Troca de Nome",
        ["Type"] = "Usável",
        ["Description"] = "Troca o nome do personagem.",
        ["Weight"] = 0.25,
        ["Class"] = "Premium",
        ["Block"] = false,
        ["Economy"] = 100000,
        ["Block"] = true,
        ["BlockChest"] = true,
["Max"] = 1,
    },
    ["passportchange11to20"] = {
        ["Index"] = "passportchange11to20",
        ["Name"] = "Troca de ID 11 - 20",
        ["Type"] = "Usável",
        ["Description"] = "Permite escolher um ID livre entre 11 e 20.",
        ["Weight"] = 0.25,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Max"] = 1,
    },
    ["passportchange21to50"] = {
        ["Index"] = "passportchange21to50",
        ["Name"] = "Troca de ID 21 - 50",
        ["Type"] = "Usável",
        ["Description"] = "Permite escolher um ID livre entre 21 e 50.",
        ["Weight"] = 0.25,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Max"] = 1,
    },
    ["passportchange51to100"] = {
        ["Index"] = "passportchange51to100",
        ["Name"] = "Troca de ID 51 - 100",
        ["Type"] = "Usável",
        ["Description"] = "Permite escolher um ID livre entre 51 e 100.",
        ["Weight"] = 0.25,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Max"] = 1,
    },
    ["passportchange101to500"] = {
        ["Index"] = "passportchange101to500",
        ["Name"] = "Troca de ID 101 - 500",
        ["Type"] = "Usável",
        ["Description"] = "Permite escolher um ID livre entre 101 e 500.",
        ["Weight"] = 0.25,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Max"] = 1,
    },
    ["passportchange501to999"] = {
        ["Index"] = "passportchange501to999",
        ["Name"] = "Troca de ID 501 - 999",
        ["Type"] = "Usável",
        ["Description"] = "Permite escolher um ID livre entre 501 e 999.",
        ["Weight"] = 0.25,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Max"] = 1,
    },
    ["passportchangeemblematic"] = {
        ["Index"] = "passportchangeemblematic",
        ["Name"] = "Ids Emblematicos",
        ["Type"] = "Usável",
        ["Description"] = "Permite escolher um ID emblemático livre.",
        ["Weight"] = 0.25,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Max"] = 1,
    },
    ["milkbottle"] = {
        ["Index"] = "milkbottle",
        ["Name"] = "Garrafa de Leite",
        ["Description"] = "Garrafa com leite de Boi.",
        ["Type"] = "Usável",
        ["Weight"] = 0.25,
        ["Class"] = "Comida",
        ["Max"] = 5,
        ["Economy"] = 35
    },
    ["guarananatural"] = {
        ["Index"] = "guarananatural",
        ["Name"] = "Guaraná Natural",
        ["Description"] = "Guarana, item liquido.",
        ["Type"] = "Usável",
        ["Weight"] = 0.25,
        ["Class"] = "Comida",
        ["Max"] = 3,
        ["Economy"] = 100
    },
    ["energetico"] = {
        ["Index"] = "energetico",
        ["Name"] = "Energético ",
        ["Description"] = "Item que aumenta velocidade do movimento.",
        ["Type"] = "Usável",
        ["Durability"] = 15,
        ["Class"] = "Comida",
        ["Weight"] = 0.25,
        ["Economy"] = 1000
    },
    ["graos"] = {
        ["Index"] = "graos",
        ["Name"] = "Graos ",
        ["Type"] = "Usável",
        ["Class"] = "Comida",
        ["Weight"] = 0.25,
        ["Economy"] = 1000
    },
    ["cereais"] = {
        ["Index"] = "cereais",
        ["Name"] = "Cereais ",
        ["Type"] = "Usável",
        ["Class"] = "Comida",
        ["Weight"] = 0.25,
        ["Economy"] = 100
    },
    ["attachments"] = {
        ["Index"] = "attachsCrosshair",
        ["Name"] = "Modificador de Arma ",
        ["Description"] = "Item que para melhoria de armamento.",
        ["Type"] = "Usável",
        ["Durability"] = 15,
        ["Weight"] = 0.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 100
    },
    ["gamebooster"] = {
        ["Index"] = "gamebooster",
        ["Name"] = "Game booster",
        ["Description"] = "Item que aumenta velocidade do movimento.",
        ["Type"] = "Usável",
        ["Durability"] = 15,
        ["Weight"] = 0.25,
        ["Class"] = "Comida",
        ["Max"] = 3,
        ["Economy"] = 100
    },
    ["gamebooster1"] = {
        ["Index"] = "gamebooster",
        ["Name"] = "Game booster",
        ["Description"] = "Item que aumenta velocidade do movimento.",
        ["Type"] = "Usável",
        ["Durability"] = 10,
        ["Weight"] = 0.25,
        ["Class"] = "Comida",
        ["Max"] = 3,
        ["Economy"] = 100
    },
    ["water"] = {
        ["Index"] = "water",
        ["Name"] = "Água",
        ["Description"] = "Item liquido, alimento.",
        ["Type"] = "Usável",
        ["Weight"] = 0.25,
        ["Class"] = "Comida",
        ["Max"] = 3,
        ["Economy"] = 30
    },
    ["emptybottle"] = {
        ["Index"] = "emptybottle",
        ["Name"] = "Garrafa Vazia",
        ["Type"] = "Comum",
        ["Weight"] = 0.15,
        ["Class"] = "Utilitarios",
        ["Max"] = 5,
        ["Economy"] = 30
    },
    ["coffee"] = {
        ["Index"] = "coffee",
        ["Name"] = "Copo de Café",
        ["Description"] = "Item liquido, alimento.",
        ["Type"] = "Usável",
        ["Weight"] = 0.25,
        ["Class"] = "Comida",
        ["Max"] = 3,
        ["Economy"] = 20
    },
    ["coffeemilk"] = {
        ["Index"] = "coffeemilk",
        ["Name"] = "Café com Leite",
        ["Type"] = "Usável",
        ["Weight"] = 0.35,
        ["Class"] = "Comida",
        ["Max"] = 3,
        ["Economy"] = 95
    },
    ["cola"] = {
        ["Index"] = "cola",
        ["Name"] = "Cola",
        ["Type"] = "Usável",
        ["Weight"] = 0.25,
        ["Class"] = "Comida",
        ["Max"] = 3,
        ["Economy"] = 15
    },
    ["tacos"] = {
        ["Index"] = "tacos",
        ["Name"] = "Tacos",
        ["Type"] = "Usável",
        ["Weight"] = 0.25,
        ["Class"] = "Comida",
        ["Max"] = 3,
        ["Economy"] = 25
    },
    ["fries"] = {
        ["Index"] = "fries",
        ["Name"] = "Fritas",
        ["Type"] = "Usável",
        ["Weight"] = 0.25,
        ["Class"] = "Comida",
        ["Max"] = 3,
        ["Economy"] = 125
    },
    ["soda"] = {
        ["Index"] = "soda",
        ["Name"] = "Sprunk",
        ["Type"] = "Usável",
        ["Weight"] = 0.25,
        ["Class"] = "Comida",
        ["Max"] = 3,
        ["Economy"] = 15
    },
    ["apple"] = {
        ["Index"] = "apple",
        ["Name"] = "Maça",
        ["Type"] = "Usável",
        ["Weight"] = 0.25,
        ["Class"] = "Comida",
        ["Economy"] = 10
    },
    ["orange"] = {
        ["Index"] = "orange",
        ["Name"] = "Laranja",
        ["Type"] = "Usável",
        ["Weight"] = 0.25,
        ["Class"] = "Comida",
        ["Economy"] = 10
    },
    ["strawberry"] = {
        ["Index"] = "strawberry",
        ["Name"] = "Morango",
        ["Type"] = "Usável",
        ["Weight"] = 0.25,
        ["Class"] = "Comida",
        ["Economy"] = 10
    },
    ["coffee2"] = {
        ["Index"] = "coffee2",
        ["Name"] = "Grão de Café",
        ["Type"] = "Usável",
        ["Weight"] = 0.25,
        ["Class"] = "Comida",
        ["Economy"] = 10
    },
    ["grape"] = {
        ["Index"] = "grape",
        ["Name"] = "Uva",
        ["Type"] = "Usável",
        ["Weight"] = 0.25,
        ["Class"] = "Comida",
        ["Economy"] = 10
    },
    ["tange"] = {
        ["Index"] = "tange",
        ["Name"] = "Tangerina",
        ["Type"] = "Usável",
        ["Weight"] = 0.25,
        ["Class"] = "Comida",
        ["Economy"] = 10
    },
    ["banana"] = {
        ["Index"] = "banana",
        ["Name"] = "Banana",
        ["Type"] = "Usável",
        ["Weight"] = 0.25,
        ["Class"] = "Comida",
        ["Economy"] = 10
    },
    ["guarana"] = {
        ["Index"] = "guarana",
        ["Name"] = "Guaraná",
        ["Type"] = "Usável",
        ["Weight"] = 0.25,
        ["Class"] = "Comida",
        ["Economy"] = 10
    },
    ["acerola"] = {
        ["Index"] = "acerola",
        ["Name"] = "Acerola",
        ["Type"] = "Usável",
        ["Weight"] = 0.25,
        ["Class"] = "Comida",
        ["Economy"] = 10
    },
    ["passion"] = {
        ["Index"] = "passion",
        ["Name"] = "Maracujá",
        ["Type"] = "Usável",
        ["Weight"] = 0.25,
        ["Class"] = "Comida",
        ["Economy"] = 10
    },
    ["tomato"] = {
        ["Index"] = "tomato",
        ["Name"] = "Tomate",
        ["Type"] = "Usável",
        ["Weight"] = 0.25,
        ["Class"] = "Comida",
        ["Economy"] = 10
    },
    ["mushroom"] = {
        ["Index"] = "mushroom",
        ["Name"] = "Cogumelo",
        ["Type"] = "Usável",
        ["Weight"] = 0.25,
        ["Class"] = "Comida",
        ["Economy"] = 10
    },
    ["sugar"] = {
        ["Index"] = "sugar",
        ["Name"] = "Açucar",
        ["Type"] = "Comum",
        ["Weight"] = 0.15,
        ["Class"] = "Comida",
        ["Economy"] = 5
    },
    ["cookies"] = {
        ["Index"] = "cookies",
        ["Name"] = "Cookies",
        ["Type"] = "Usável",
        ["Weight"] = 0.25,
        ["Class"] = "Comida",
        ["Max"] = 3,
        ["Economy"] = 60
    },
    ["orangejuice"] = {
        ["Index"] = "orangejuice",
        ["Name"] = "Suco de Laranja",
        ["Type"] = "Usável",
                ["Weight"] = 0.75,
        ["Class"] = "Comida",
        ["Max"] = 3,
        ["Economy"] = 100
    },
    ["tangejuice"] = {
        ["Index"] = "tangejuice",
        ["Name"] = "Suco de Tangerina",
        ["Type"] = "Usável",
                ["Weight"] = 0.75,
        ["Class"] = "Comida",
        ["Max"] = 3,
        ["Economy"] = 100
    },
    ["grapejuice"] = {
        ["Index"] = "grapejuice",
        ["Name"] = "Suco de Uva",
        ["Type"] = "Usável",
                ["Weight"] = 0.75,
        ["Class"] = "Comida",
        ["Max"] = 3,
        ["Economy"] = 100
    },
    ["strawberryjuice"] = {
        ["Index"] = "strawberryjuice",
        ["Name"] = "Suco de Morango",
        ["Type"] = "Usável",
                ["Weight"] = 0.75,
        ["Class"] = "Comida",
        ["Max"] = 3,
        ["Economy"] = 100
    },
    ["bananajuice"] = {
        ["Index"] = "bananajuice",
        ["Name"] = "Suco de Banana",
        ["Type"] = "Usável",
                ["Weight"] = 0.75,
        ["Class"] = "Comida",
        ["Max"] = 3,
        ["Economy"] = 100
    },
    ["acerolajuice"] = {
        ["Index"] = "acerolajuice",
        ["Name"] = "Suco de Acerola",
        ["Type"] = "Usável",
                ["Weight"] = 0.75,
        ["Class"] = "Comida",
        ["Max"] = 3,
        ["Economy"] = 100
    },
    ["passionjuice"] = {
        ["Index"] = "passionjuice",
        ["Name"] = "Suco de Maracujá",
        ["Type"] = "Usável",
                ["Weight"] = 0.75,
        ["Class"] = "Comida",
        ["Max"] = 3,
        ["Economy"] = 100
    },
    ["bread"] = {
        ["Index"] = "bread",
        ["Name"] = "Pão",
        ["Type"] = "Comum",
        ["Weight"] = 0.25,
        ["Class"] = "Comida",
        ["Economy"] = 5
    },
    ["ketchup"] = {
        ["Index"] = "ketchup",
        ["Name"] = "Ketchup",
        ["Type"] = "Comum",
                ["Weight"] = 0.75,
        ["Class"] = "Comida",
        ["Economy"] = 75
    },
    ["cannedsoup"] = {
        ["Index"] = "cannedsoup",
        ["Name"] = "Sopa em Lata",
        ["Type"] = "Usável",
                ["Weight"] = 0.75,
        ["Class"] = "Comida",
        ["Economy"] = 55
    },
    ["canofbeans"] = {
        ["Index"] = "canofbeans",
        ["Name"] = "Lata de Feijão",
        ["Type"] = "Usável",
                ["Weight"] = 0.75,
        ["Class"] = "Comida",
        ["Economy"] = 55
    },
    ["fishfillet"] = {
        ["Index"] = "fishfillet",
        ["Name"] = "Filé de Peixe",
        ["Type"] = "Comum",
                ["Weight"] = 0.75,
        ["Class"] = "Comida",
        ["Economy"] = 10
    },
    ["marshmallow"] = {
        ["Index"] = "marshmallow",
        ["Name"] = "Marshmallow",
        ["Type"] = "Usável",
        ["Weight"] = 0.25,
        ["Class"] = "Comida",
        ["Max"] = 3,
        ["Economy"] = 35
    },
    ["cookedfishfillet"] = {
        ["Index"] = "cookedfishfillet",
        ["Name"] = "Filé de Peixe Cozido",
        ["Type"] = "Usável",
        ["Weight"] = 0.55,
        ["Class"] = "Comida",
        ["Max"] = 3,
        ["Economy"] = 35
    },
    ["hamburger"] = {
        ["Index"] = "hamburger",
        ["Name"] = "Hambúrguer",
        ["Type"] = "Usável",
        ["Weight"] = 0.55,
        ["Class"] = "Comida",
        ["Max"] = 3,
        ["Economy"] = 25
    },    
    ["hamburger2"] = {
        ["Index"] = "hamburger2",
        ["Name"] = "Hambúrguer Artesanal",
        ["Type"] = "Usável",
                ["Weight"] = 0.75,
        ["Class"] = "Comida",
        ["Max"] = 3,
        ["Economy"] = 125
    },
    ["hamburger3"] = {
        ["Index"] = "hamburger",
        ["Name"] = "Hambúrguer",
        ["Type"] = "Usável",
        ["Weight"] = 0.55,
        ["Class"] = "Comida",
        ["Max"] = 3,
        ["Economy"] = 25
    },
    ["onionrings"] = {
        ["Index"] = "onionrings",
        ["Name"] = "Anéis de Cebola",
        ["Type"] = "Usável",
        ["Weight"] = 0.55,
        ["Class"] = "Comida",
        ["Max"] = 3,
        ["Economy"] = 70
    },
    ["chickenfries"] = {
        ["Index"] = "chickenfries",
        ["Name"] = "Frango Frito",
        ["Type"] = "Usável",
                ["Weight"] = 0.75,
        ["Class"] = "Comida",
        ["Max"] = 3,
        ["Economy"] = 125
    },
    ["pizzamozzarella"] = {
        ["Index"] = "pizzamozzarella",
        ["Name"] = "Pizza de Muçarela",
        ["Type"] = "Usável",
                ["Weight"] = 0.75,
        ["Class"] = "Comida",
        ["Max"] = 3,
        ["Economy"] = 150
    },
    ["pizzamushroom"] = {
        ["Index"] = "pizzamushroom",
        ["Name"] = "Pizza de Cogumelo",
        ["Type"] = "Usável",
                ["Weight"] = 0.75,
        ["Class"] = "Comida",
        ["Max"] = 3,
        ["Economy"] = 150
    },
    ["pizzabanana"] = {
        ["Index"] = "pizzabanana",
        ["Name"] = "Pizza de Banana",
        ["Type"] = "Usável",
                ["Weight"] = 0.75,
        ["Class"] = "Comida",
        ["Max"] = 3,
        ["Economy"] = 150
    },
    ["pizzachocolate"] = {
        ["Index"] = "pizzachocolate",
        ["Name"] = "Pizza de Chocolate",
        ["Type"] = "Usável",
                ["Weight"] = 0.75,
        ["Class"] = "Comida",
        ["Max"] = 3,
        ["Economy"] = 150
    },
    ["calzone"] = {
        ["Index"] = "calzone",
        ["Name"] = "Calzone",
        ["Type"] = "Usável",
        ["Weight"] = 0.55,
        ["Class"] = "Comida",
        ["Max"] = 3,
        ["Economy"] = 150
    },
    ["hotdog"] = {
        ["Index"] = "hotdog",
        ["Name"] = "Cachorro-Quente",
        ["Type"] = "Usável",
        ["Weight"] = 0.45,
        ["Class"] = "Comida",
        ["Max"] = 3,
        ["Economy"] = 15
    },
    ["donut"] = {
        ["Index"] = "donut",
        ["Name"] = "Rosquinha",
        ["Type"] = "Usável",
        ["Weight"] = 0.25,
        ["Class"] = "Comida",
        ["Max"] = 3,
        ["Economy"] = 15
    },
    ["plate"] = {
        ["Index"] = "plate",
        ["Name"] = "Placa",
        ["Type"] = "Comum",
                ["Weight"] = 0.75,
        ["Block"] = true,
["Class"] = "Utilitarios",
        ["Economy"] = 525
    },
    ["lockpick"] = {
        ["Index"] = "lockpick",
        ["Name"] = "Lockpick de Alumínio",
        ["Repair"] = "repairkit01",
        ["Type"] = "Usável",
        ["Weight"] = 1.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 425
    },
    ["chavemestra"] = {
        ["Index"] = "chavemestra",
        ["Name"] = "Chave Mestra",
        ["Repair"] = "repairkit01",
        ["Type"] = "Usável",
        ["Weight"] = 1.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 425
    },
    ["toolbox"] = {
        ["Index"] = "toolbox",
        ["Name"] = "Ferramentas Básicas",
        ["Type"] = "Usável",
        ["Weight"] = 1.25,
        ["Class"] = "Utilitarios",
        ["Max"] = 2,
        ["Economy"] = 625
    },
    ["advtoolbox"] = {
        ["Index"] = "toolbox",
        ["Name"] = "Kit de Reparo - Usado para reparar veículos quebrados.",
        ["Type"] = "Usável",
        ["Weight"] = 1.25,
        ["Class"] = "Utilitarios",
        ["Max"] = 1,
        ["Economy"] = 1525
    },
    ["toolbox1"] = {
        ["Index"] = "toolbox1",
        ["Name"] = "Kit de Reparo Comum",
        ["Description"] = "Kit simples para reparar a lataria dos veículos quebrados.",
        ["Type"] = "Usável",
        ["Weight"] = 1.25,
        ["Class"] = "Utilitarios",
        ["Max"] = 2,
        ["Economy"] = 625
    },
    ["toolbox2"] = {
        ["Index"] = "toolbox2",
        ["Name"] = "Kit de Reparo Profissional",
        ["Description"] = "Kit profissional para reparar a lataria de veículos danificados, de uso exclusivo dos mecânicos. Cada kit possui 3 usos.",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 1.25,
        ["Charges"] = 3,
        ["Class"] = "Utilitarios",
        ["Max"] = 4,
        ["Economy"] = 1525
    },
    ["notepad"] = {
        ["Index"] = "notepad",
        ["Name"] = "Bloco de Notas",
        ["Type"] = "Usável",
        ["Weight"] = 0.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 10
    },
    ["tyres"] = {
        ["Index"] = "tyres",
        ["Name"] = "Pneu",
        ["Type"] = "Usável",
        ["Weight"] = 1.75,
        ["Class"] = "Utilitarios",
        ["Max"] = 8,
        ["Scape"] = {
            ["Mechanic"] = {
                {
                    ["Level"] = 5,
                    ["Amount"] = 8
                }
            }
        },
        ["Economy"] = 225
    },
    ["cellphone"] = {
        ["Index"] = "cellphone",
        ["Name"] = "Celular",
        ["Description"] = "Aparelho telefonico, utilizado para comunicação e acesso a apps",
        ["Repair"] = "repairkit01",
        ["Type"] = "Comum",
                ["Weight"] = 0.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 300
    },
    ["scuba"] = {
        ["Index"] = "scuba",
        ["Name"] = "Roupa de Mergulho",
        ["Type"] = "Usável",
        ["Weight"] = 4.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 975
    },
    
    ["penaareia"] = {
        ["Index"] = "penaareia",
        ["Name"] = "Pena de Areia",
        ["Type"] = "Usável",
        ["Weight"] = 15.0,
        ["Block"] = false,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["handcuff"] = {
        ["Index"] = "handcuff",
        ["Name"] = "Algemas",
        ["Description"] = "item utilizado por bandidos e policial, para prender um player",
        ["Repair"] = "repairkit02",
        ["Type"] = "Usável",
        ["Weight"] = 1.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 5750
    },
    ["attachs"] = {
        ["Index"] = "attachs",
        ["Name"] = "Kit de Attachs",
        ["Description"] = "Kit completo de acessórios para personalizar sua arma. Inclui miras, lanternas, empunhaduras e carregadores estendidos.",
        ["Repair"] = "repairkit01",
        ["Type"] = "Usável",
        ["Weight"] = 0.55,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["caixadepresente"] = {
        ["Index"] = "caixadepresente",
        ["Name"] = "Caixa de Presente",
        ["Type"] = "Usável",
        ["Weight"] = 0.1,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["lovebox"] = {
        ["Index"] = "lovebox",
        ["Name"] = "Caixa do Amor",
        ["Type"] = "Usável",
        ["Weight"] = 0.1,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["loveletter"] = {
        ["Index"] = "loveletter",
        ["Name"] = "Carta de Amor",
        ["Type"] = "Usável",
        ["Weight"] = 0.1,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["firework_common"] = {
        ["Index"] = "firework_common",
        ["Name"] = "Fogos Comuns",
        ["Type"] = "Usável",
        ["Weight"] = 0.1,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["saquinhofolia"] = {
        ["Index"] = "saquinhofolia",
        ["Name"] = "Confete Festivo",
        ["Type"] = "Usável",
        ["Weight"] = 0.1,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["fantasia_abada"] = {
        ["Index"] = "fantasia_abada",
        ["Name"] = "Fantasia Abadá",
        ["Type"] = "Usável",
        ["Weight"] = 0.5,
        ["Class"] = "Utilitarios",
        ["Durability"] = 30,
        ["Economy"] = 0
    },
    ["firework_rare"] = {
        ["Index"] = "firework_rare",
        ["Name"] = "Fogos Raros",
        ["Type"] = "Usável",
        ["Weight"] = 0.1,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["firework_special"] = {
        ["Index"] = "firework_special",
        ["Name"] = "Fogos Especiais",
        ["Type"] = "Usável",
        ["Weight"] = 0.1,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },
    ["hood"] = {
        ["Index"] = "hood",
        ["Name"] = "Capuz",
        ["Description"] = "Capuz, item utilizado para vendar todas as pessoas, utilizado em sequestro",
        ["Repair"] = "repairkit01",
        ["Type"] = "Usável",
        ["Weight"] = 1.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 5750
    },
    ["plastic"] = {
        ["Index"] = "plastic",
        ["Name"] = "Plástico",
        ["Type"] = "Comum",
        ["Weight"] = 0.065,
        ["Class"] = "Utilitarios",
        ["Economy"] = 20
    },
    ["glass"] = {
        ["Index"] = "glass",
        ["Name"] = "Vidro",
        ["Type"] = "Comum",
        ["Weight"] = 0.065,
        ["Class"] = "Utilitarios",
        ["Economy"] = 20
    },
    ["rubber"] = {
        ["Index"] = "rubber",
        ["Name"] = "Borracha",
        ["Type"] = "Comum",
        ["Weight"] = 0.050,
        ["Class"] = "Utilitarios",
        ["Economy"] = 20
    },
    ["aluminum"] = {
        ["Index"] = "aluminum",
        ["Name"] = "Alumínio",
        ["Type"] = "Comum",
        ["Weight"] = 0.075,
        ["Class"] = "Utilitarios",
        ["Economy"] = 30
    },
    ["copper"] = {
        ["Index"] = "copper",
        ["Name"] = "Cobre",
        ["Type"] = "Comum",
        ["Weight"] = 0.095,
        ["Class"] = "Utilitarios",
        ["Economy"] = 30
    },
    ["ritmoneury"] = {
        ["Index"] = "ritmoneury",
        ["Name"] = "Ritmoneury",
        ["Type"] = "Usável",
                ["Weight"] = 0.75,
        ["Class"] = "Utilitarios",
        ["Max"] = 2,
        ["Economy"] = 475
    },
    ["sinkalmy"] = {
        ["Index"] = "sinkalmy",
        ["Name"] = "Sinkalmy",
        ["Type"] = "Usável",
                ["Weight"] = 0.75,
        ["Class"] = "Utilitarios",
        ["Max"] = 2,
        ["Economy"] = 375
    },
    ["cigarette"] = {
        ["Index"] = "cigarette",
        ["Name"] = "Cigarro",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Utilitarios",
        ["Max"] = 5,
        ["Economy"] = 10
    },
    ["lighter"] = {
        ["Index"] = "lighter",
        ["Name"] = "Isqueiro",
        ["Repair"] = "repairkit01",
        ["Type"] = "Comum",
        ["Weight"] = 0.55,
        ["Class"] = "Utilitarios",
        ["Economy"] = 175
    },
    ["vape"] = {
        ["Index"] = "vape",
        ["Name"] = "Vape",
        ["Repair"] = "repairkit01",
        ["Type"] = "Usável",
                ["Weight"] = 0.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 4750
    },
    ["dollars"] = {
        ["Index"] = "dollars",
        ["Name"] = "Dólares",
        ["Type"] = "Comum",
        ["Weight"] = 0.0,
        ["Class"] = "Utilitarios",
        ["Economy"] = 1
    },
    ["battery"] = {
        ["Index"] = "battery",
        ["Name"] = "Pilhas",
        ["Type"] = "Comum",
        ["Weight"] = 0.35,
        ["Class"] = "Utilitarios",
        ["Economy"] = 90
    },
    ["elastic"] = {
        ["Index"] = "elastic",
        ["Name"] = "Elástico",
        ["Type"] = "Comum",
        ["Weight"] = 0.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 60
    },
    ["plasticbottle"] = {
        ["Index"] = "plasticbottle",
        ["Name"] = "Garrafa Plástica",
        ["Type"] = "Comum",
        ["Weight"] = 0.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 60
    },
    ["glassbottle"] = {
        ["Index"] = "glassbottle",
        ["Name"] = "Garrafa de Vidro",
        ["Type"] = "Comum",
        ["Weight"] = 0.45,
        ["Class"] = "Utilitarios",
        ["Economy"] = 60
    },
    ["metalcan"] = {
        ["Index"] = "metalcan",
        ["Name"] = "Lata de Metal",
        ["Type"] = "Comum",
        ["Weight"] = 0.55,
        ["Class"] = "Utilitarios",
        ["Economy"] = 90
    },
    ["chocolate"] = {
        ["Index"] = "chocolate",
        ["Name"] = "Chocolate",
        ["Description"] = "Alimento",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Comida",
        ["Max"] = 3,
        ["Economy"] = 15
    },
    ["sandwich"] = {
        ["Index"] = "sandwich",
        ["Name"] = "Sanduiche",
        ["Description"] = "Alimento",
        ["Type"] = "Usável",
        ["Weight"] = 0.25,
        ["Class"] = "Comida",
        ["Max"] = 3,
        ["Economy"] = 15
    },
    ["rose"] = {
        ["Index"] = "rose",
        ["Name"] = "Rosa",
        ["Description"] = "Flor, rosa",
        ["Type"] = "Usável",
        ["Weight"] = 0.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 25
    },
    ["teddy"] = {
        ["Index"] = "teddy",
        ["Name"] = "Teddy",
        ["Type"] = "Usável",
        ["Weight"] = 1.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 75
    },
    ["absolut"] = {
        ["Index"] = "absolut",
        ["Name"] = "Vodka",
        ["Description"] = "bebida alcoólica",
        ["Type"] = "Usável",
        ["Weight"] = 0.55,
        ["Class"] = "Comida",
        ["Economy"] = 15
    },
    ["chandon"] = {
        ["Index"] = "chandon",
        ["Name"] = "Espumante",
        ["Description"] = "bebida alcoólica",
        ["Type"] = "Usável",
        ["Weight"] = 0.55,
        ["Class"] = "Comida",
        ["Economy"] = 15
    },
    ["dewars"] = {
        ["Index"] = "dewars",
        ["Name"] = "Whisky",
        ["Type"] = "Usável",
        ["Weight"] = 0.55,
        ["Class"] = "Comida",
        ["Economy"] = 15
    },
    ["hennessy"] = {
        ["Index"] = "hennessy",
        ["Name"] = "Conhaque",
        ["Type"] = "Usável",
        ["Weight"] = 0.55,
        ["Class"] = "Comida",
        ["Economy"] = 15
    },
    ["goldbar"] = {
        ["Index"] = "goldbar",
        ["Name"] = "Barra de Ouro",
        ["Description"] = "Barra de Ouro",
        ["Type"] = "Comum",
                ["Weight"] = 0.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 525
    },
    ["binoculars"] = {
        ["Index"] = "binoculars",
        ["Name"] = "Binóculos",
        ["Description"] = "item para observar coisas há longa distância",
        ["Type"] = "Usável",
                ["Weight"] = 0.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 275
    },
    ["camera"] = {
        ["Index"] = "camera",
        ["Name"] = "Câmera",
        ["Description"] = "Câmera fotografica",
        ["Type"] = "Usável",
        ["Weight"] = 1.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 275
    },
    ["WEAPON_HATCHET"] = {
        ["Index"] = "hatchet",
        ["Description"] = "Armamento branco, Machado",
        ["Name"] = "Machado",
        ["Type"] = "Armamento",
        ["Repair"] = "repairkit01",
        ["Weight"] = 1.75,
        ["Class"] = "Armas",
        ["Economy"] = 15000
    },
    ["WEAPON_BAT"] = {
        ["Index"] = "bat",
        ["Name"] = "Bastão de Beisebol",
        ["Description"] = "Armamento branco, Bastão de Beisebol",
        ["Repair"] = "repairkit01",
        ["Type"] = "Armamento",
        ["Weight"] = 1.75,
        ["Class"] = "Armas",
        ["Economy"] = 15000
    },
    ["WEAPON_KATANA"] = {
        ["Index"] = "katana",
        ["Name"] = "Katana",
        ["Description"] = "Armamento branco, Katana",
        ["Type"] = "Armamento",
        ["Repair"] = "repairkit01",
        ["Weight"] = 1.75,
        ["Class"] = "Armas",
        ["Economy"] = 75000
    },
    ["WEAPON_KATANA_CENOURA"] = {
        ["Index"] = "katana_cenoura",
        ["Name"] = "Katana Cenoura",
        ["Description"] = "Armamento branco, Katana Cenoura",
        ["Type"] = "Armamento",
        ["Repair"] = "repairkit01",
        ["Weight"] = 1.75,
        ["Block"] = true,
        ["BlockChest"] = true,
["Class"] = "Armas",
        ["Economy"] = 75000
    },
    ["WEAPON_CENOURA"] = {
        ["Index"] = "cenoura",
        ["Name"] = "Cenoura",
        ["Description"] = "Armamento branco, Cenoura",
        ["Type"] = "Armamento",
        ["Repair"] = "repairkit01",
        ["Weight"] = 1.75,
        ["Class"] = "Armas",
        ["Economy"] = 75000
    },
    ["WEAPON_KARAMBIT"] = {
        ["Index"] = "karambit",
        ["Name"] = "Karambit",
        ["Description"] = "Armamento branco, Karambit",
        ["Type"] = "Armamento",
        ["Repair"] = "repairkit01",
        ["Weight"] = 1.25,
        ["Class"] = "Armas",
        ["Economy"] = 75000
    },
    ["WEAPON_CANDYCANE"] = {
        ["Index"] = "WEAPON_CANDYCANE",
        ["Name"] = "Candy Cane",
        ["Description"] = "Armamento branco, Candy Cane",
        ["Type"] = "Armamento",
        ["Repair"] = "repairkit01",
        ["Weight"] = 1.25,
        ["Class"] = "Armas",
        ["Economy"] = 75000
    },
    ["WEAPON_BATTLEAXE"] = {
        ["Index"] = "battleaxe",
        ["Name"] = "Machado de Batalha",
        ["Description"] = "Armamento branco, Machado de Batalha",
        ["Repair"] = "repairkit01",
        ["Type"] = "Armamento",
        ["Weight"] = 1.75,
        ["Class"] = "Armas",
        ["Economy"] = 15000
    },
    ["WEAPON_CROWBAR"] = {
        ["Index"] = "crowbar",
        ["Name"] = "Pé de Cabra",
        ["Description"] = "Armamento branco, Pé de Cabra",
        ["Repair"] = "repairkit01",
        ["Type"] = "Armamento",
        ["Weight"] = 1.35,
        ["Class"] = "Armas",
        ["Economy"] = 725
    },
    ["WEAPON_GOLFCLUB"] = {
        ["Index"] = "golfclub",
        ["Name"] = "Taco de Golf",
        ["Description"] = "Armamento branco, taco de golf",
        ["Repair"] = "repairkit01",
        ["Type"] = "Armamento",
        ["Weight"] = 1.65,
        ["Class"] = "Armas",
        ["Economy"] = 15000
    },
    ["WEAPON_HAMMER"] = {
        ["Index"] = "hammer",
        ["Name"] = "Martelo",
        ["Description"] = "Armamento branco, Martelo",
        ["Repair"] = "repairkit01",
        ["Type"] = "Armamento",
        ["Weight"] = 1.45,
        ["Class"] = "Armas",
        ["Economy"] = 15000
    },
    ["WEAPON_MACHETE"] = {
        ["Index"] = "machete",
        ["Name"] = "Facão",
        ["Description"] = "Armamento branco, Facão",
        ["Repair"] = "repairkit01",
        ["Type"] = "Armamento",
        ["Weight"] = 1.35,
        ["Class"] = "Armas",
        ["Economy"] = 15000
    },
    ["WEAPON_POOLCUE"] = {
        ["Index"] = "poolcue",
        ["Name"] = "Taco de Sinuca",
        ["Description"] = "Armamento branco, Taco de Sinuca",
        ["Repair"] = "repairkit01",
        ["Type"] = "Armamento",
        ["Weight"] = 1.25,
        ["Class"] = "Armas",
        ["Economy"] = 15000
    },
    ["WEAPON_STONE_HATCHET"] = {
        ["Index"] = "stonehatchet",
        ["Name"] = "Machado de Pedra",
        ["Description"] = "Armemento branco, Machado de Pedra",
        ["Repair"] = "repairkit01",
        ["Type"] = "Armamento",
        ["Weight"] = 1.55,
        ["Class"] = "Armas",
        ["Economy"] = 15000
    },
    ["WEAPON_WRENCH"] = {
        ["Index"] = "wrench",
        ["Name"] = "Chave Inglesa",
        ["Description"] = "Armemento branco, soco inglês",
        ["Repair"] = "repairkit01",
        ["Type"] = "Armamento",
        ["Weight"] = 1.45,
        ["Class"] = "Armas",
        ["Economy"] = 725
    },
    ["WEAPON_KNUCKLE"] = {
        ["Index"] = "knuckle",
        ["Name"] = "Soco Inglês",
        ["Description"] = "Armemento branco, soco inglês",
        ["Repair"] = "repairkit01",
        ["Type"] = "Armamento",
        ["Weight"] = 1.15,
        ["Class"] = "Armas",
        ["Economy"] = 15000
    },
    ["WEAPON_FLASHLIGHT"] = {
        ["Index"] = "flashlight",
        ["Name"] = "Lanterna",
        ["Description"] = "Lanterna, item para melhoria do armamento",
        ["Repair"] = "repairkit01",
        ["Type"] = "Armamento",
        ["Weight"] = 1.15,
        ["Class"] = "Armas",
        ["Economy"] = 15000
    },
    ["WEAPON_NIGHTSTICK"] = {
        ["Index"] = "nightstick",
        ["Description"] = "Arma branca cassetete, armamento de policial",
        ["Name"] = "Cassetete",
        ["Repair"] = "repairkit01",
        ["Type"] = "Armamento",
        ["Weight"] = 1.15,
        ["Class"] = "Armas",
        ["Economy"] = 125
    },
    ["WEAPON_PISTOL"] = {
        ["Index"] = "m1911",
        ["Name"] = "Pistol",
        ["Description"] = "Armamento Pistol",
        ["Repair"] = "repairkit02",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_PISTOL_AMMO",
        ["Vehicle"] = true,
        ["Weight"] = 1,
        ["Class"] = "Armas",
        ["Economy"] = 100000
    },
    ["WEAPON_PISTOL_MK2"] = {
        ["Index"] = "fiveseven",
        ["Name"] = "Pistol Mk II",
        ["Description"] = "Armamento Pistol Mk II",
        ["Repair"] = "repairkit02",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_PISTOL_AMMO",
        ["Vehicle"] = true,
        ["Weight"] = 1,
        ["Class"] = "Armas",
        ["Economy"] = 130000
    },
    ["WEAPON_GADGETPISTOL"] = {
        ["Index"] = "WEAPON_GADGETPISTOL",
        ["Name"] = "WEAPON_GADGETPISTOL",
        ["Description"] = "Armento pistola Five Seven",
        ["Repair"] = "repairkit02",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_PISTOL_AMMO",
        ["Vehicle"] = true,
        ["Weight"] = 1,
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 130000
    },
    ["WEAPON_RAIJIN"] = {
        ["Index"] = "WEAPON_RAIJIN",
        ["Name"] = "Raijin",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_PISTOL_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_APPISTOL_SHOCKVOLT"] = {
        ["Index"] = "WEAPON_APPISTOL_SHOCKVOLT",
        ["Name"] = "Appistol Shockvolt",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_PISTOL_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_APPISTOL_DARKMATTER"] = {
        ["Index"] = "WEAPON_APPISTOL_DARKMATTER",
        ["Name"] = "Appistol Darkmatter",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_PISTOL_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_APPISTOL_SNAGDRAGON"] = {
        ["Index"] = "WEAPON_APPISTOL_SNAGDRAGON",
        ["Name"] = "Appistol Snagdragon",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_PISTOL_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_TIGER_PISTOL"] = {
        ["Index"] = "WEAPON_TIGER_PISTOL",
        ["Name"] = "Tiger Pistol",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_PISTOL_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_PABSS"] = {
        ["Index"] = "WEAPON_PABSS",
        ["Name"] = "Pabss",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_PISTOL_AMMO",
        ["Weight"] = 1,
        ["Block"] = true,
        ["BlockChest"] = true,
["Class"] = "Armas",
        ["Economy"] = 130000
    },
    ["WEAPON_COMPACTRIFLE"] = {
        ["Index"] = "akcompact",
        ["Name"] = "Compact Rifle",
        ["Description"] = "Armamento Compact Rifle",
        ["Repair"] = "repairkit03",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 2,
        ["Class"] = "Armas",
        ["Economy"] = 250000
    },
    ["WEAPON_APPISTOL"] = {
        ["Index"] = "kochvp9",
        ["Name"] = "AP Pistol",
        ["Description"] = "Armamento AP Pistol",
        ["Repair"] = "repairkit02",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_PISTOL_AMMO",
        ["Vehicle"] = true,
        ["Weight"] = 1,
        ["Class"] = "Armas",
        ["Economy"] = 125000
    },
    ["WEAPON_CARROT"] = {
        ["Index"] = "carrot",
        ["Name"] = "Cenoura",
        ["Description"] = "Uma cenoura como arma. Evento de Páscoa",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_PISTOL_AMMO",
        ["Weight"] = 0.5,
        ["Block"] = true,
        ["BlockChest"] = true,
["Class"] = "Armas",
        ["Economy"] = 0
    },
    ["WEAPON_KATANA_CENOURA"] = {
        ["Index"] = "katanacenoura",
        ["Name"] = "Katana Cenoura",
        ["Description"] = "Uma katana feita de cenoura. Evento de Páscoa",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_KATANA_CENOURA_AMMO",
        ["Weight"] = 1,
        ["Block"] = true,
        ["BlockChest"] = true,
["Class"] = "Armas",
        ["Economy"] = 0
    },
    ["WEAPON_HEAVYPISTOL"] = {
        ["Index"] = "atifx45",
        ["Name"] = "Heavy Pistol",
        ["Description"] = "Armamento Heavy Pistol",
        ["Repair"] = "repairkit02",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_PISTOL_AMMO",
        ["Vehicle"] = true,
        ["Weight"] = 2,
        ["Class"] = "Armas",
        ["Economy"] = 125000
    },
    ["WEAPON_MACHINEPISTOL"] = {
        ["Index"] = "tec9",
        ["Name"] = "Machine Pistol",
        ["Description"] = "Armamento Machine Pistol",
        ["Type"] = "Armamento",
        ["Repair"] = "repairkit03",
        ["Ammo"] = "WEAPON_SMG_AMMO",
        ["Vehicle"] = true,
        ["Weight"] = 1,
        ["Class"] = "Armas",
        ["Economy"] = 190000
    },
    ["WEAPON_MICROSMG"] = {
        ["Index"] = "uzi",
        ["Name"] = "Micro SMG",
        ["Description"] = "Armamento Micro SMG",
        ["Type"] = "Armamento",
        ["Repair"] = "repairkit03",
        ["Ammo"] = "WEAPON_SMG_AMMO",
        ["Vehicle"] = true,
        ["Weight"] = 1,
        ["Class"] = "Armas",
        ["Economy"] = 140000
    },
    ["WEAPON_NAILGUN"] = {
        ["Index"] = "nailgun",
        ["Name"] = "Nailgun",
        ["Description"] = "Armamento Nailgun",
        ["Repair"] = "repairkit01",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_NAIL_AMMO",
        ["Vehicle"] = false,
        ["Weight"] = 1,
        ["Class"] = "Armas",
        ["Economy"] = 3250
    },
    ["WEAPON_MINISMG"] = {
        ["Index"] = "skorpionv61",
        ["Name"] = "Mini SMG",
        ["Repair"] = "repairkit03",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_SMG_AMMO",
        ["Vehicle"] = true,
        ["Weight"] = 1,
        ["Class"] = "Armas",
        ["Economy"] = 190000
    },
    ["WEAPON_TECPISTOL"] = {
        ["Index"] = "tecm31",
        ["Name"] = "Tec M31",
        ["Repair"] = "repairkit03",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_SMG_AMMO",
        ["Vehicle"] = true,
        ["Weight"] = 1,
        ["Class"] = "Armas",
        ["Economy"] = 170000
    },
    ["WEAPON_SCORPIONEVO"] = {
        ["Index"] = "skorpionv61",
        ["Name"] = "Scorpion Evo",
        ["Description"] = "Armamento SMG Scorpion EVO",
        ["Repair"] = "repairkit03",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_SMG_AMMO",
        ["Vehicle"] = true,
        ["Weight"] = 1,
        ["Class"] = "Armas",
        ["Economy"] = 190000
    },
    ["WEAPON_MP5K"] = {
        ["Index"] = "skorpionv61",
        ["Name"] = "MP5K",
        ["Description"] = "Armamento SMG mp5k",
        ["Repair"] = "repairkit03",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_SMG_AMMO",
        ["Vehicle"] = true,
        ["Weight"] = 1,
        ["Class"] = "Armas",
        ["Economy"] = 190000
    },
    ["WEAPON_MP9"] = {
        ["Index"] = "skorpionv61",
        ["Name"] = "MP9",
        ["Description"] = "Armamento SMG MP9",
        ["Repair"] = "repairkit03",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_SMG_AMMO",
        ["Vehicle"] = true,
        ["Weight"] = 1,
        ["Class"] = "Armas",
        ["Economy"] = 190000
    },
    ["WEAPON_M9A3"] = {
        ["Index"] = "amt380",
        ["Name"] = "M9A3",
        ["Description"] = "Armamento pistola m9a3",
        ["Repair"] = "repairkit02",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_PISTOL_AMMO",
        ["Vehicle"] = true,
        ["Weight"] = 1,
        ["Class"] = "Armas",
        ["Economy"] = 125000
    },
    ["WEAPON_SNSPISTOL"] = {
        ["Index"] = "amt380",
        ["Name"] = "SNS Pistol",
        ["Description"] = "Armamento pistola SNS Pistol",
        ["Repair"] = "repairkit02",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_PISTOL_AMMO",
        ["Vehicle"] = true,
        ["Weight"] = 1,
        ["Class"] = "Armas",
        ["Economy"] = 125000
    },
    ["WEAPON_SNSPISTOL_MK2"] = {
        ["Index"] = "hkp7m10",
        ["Name"] = "SNS Pistol Mk II",
        ["Description"] = "Armamento pistola SNS Pistol Mk II",
        ["Repair"] = "repairkit02",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_PISTOL_AMMO",
        ["Vehicle"] = true,
        ["Weight"] = 1,
        ["Class"] = "Armas",
        ["Economy"] = 125000
    },
    ["WEAPON_VINTAGEPISTOL"] = {
        ["Index"] = "m1922",
        ["Name"] = "Vintage Pistol",
        ["Description"] = "Armamento pistola Vintage Pistol",
        ["Repair"] = "repairkit02",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_PISTOL_AMMO",
        ["Vehicle"] = true,
        ["Weight"] = 1,
        ["Class"] = "Armas",
        ["Economy"] = 125000
    },
    ["WEAPON_PISTOL50"] = {
        ["Index"] = "desert",
        ["Name"] = "Pistol .50",
        ["Description"] = "Armamento pistola Pistol .50",
        ["Repair"] = "repairkit03",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_PISTOL_AMMO",
        ["Vehicle"] = true,
        ["Weight"] = 5,
        ["Class"] = "Armas",
        ["Economy"] = 1000000
    },
    ["WEAPON_REVOLVER"] = {
        ["Index"] = "magnum",
        ["Name"] = "Revolver",
        ["Description"] = "Armamento pistola Revolver",
        ["Repair"] = "repairkit03",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_PISTOL_AMMO",
        ["Vehicle"] = true,
        ["Weight"] = 5,
        ["Class"] = "Armas",
        ["Economy"] = 125000
    },
    ["WEAPON_COMBATPISTOL"] = {
        ["Index"] = "glock",
        ["Name"] = "Combat Pistol",
        ["Description"] = "Armamento pistola Combat Pistol",
        ["Repair"] = "repairkit02",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_PISTOL_AMMO",
        ["Vehicle"] = true,
        ["Weight"] = 1,
        ["Class"] = "Armas",
        ["Economy"] = 125000
    },
    ["WEAPON_SCARH"] = {
        ["Index"] = "fnfal",
        ["Name"] = "Scar-H",
        ["Description"] = "Armamento fuzil Scar-H",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 2,
        ["Class"] = "Armas",
        ["Economy"] = 250000
    },
    ["WEAPON_NAVYCARBINE"] = {
        ["Index"] = "m4a1",
        ["Name"] = "Navy Carbine",
        ["Description"] = "Armamento fuzil Navy Carbine",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 2,
        ["Class"] = "Armas",
        ["Economy"] = 250000
    },
    ["WEAPON_BATTLECARBINE"] = {
        ["Index"] = "coltxm177",
        ["Name"] = "Battle Carbine",
        ["Description"] = "Armamento fuzil Battle Carbine",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 2,
        ["Class"] = "Armas",
        ["Economy"] = 250000
    },
    ["WEAPON_NSR"] = {
        ["Index"] = "m4a1",
        ["Name"] = "NSR",
        ["Description"] = "Armamento fuzil NSR",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 2,
        ["Class"] = "Armas",
        ["Economy"] = 250000
    },
    ["WEAPON_CARBINERIFLE"] = {
        ["Index"] = "m4a1",
        ["Name"] = "Carbine Rifle",
        ["Description"] = "Armamento fuzil Carbine Rifle",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 2,
        ["Class"] = "Armas",
        ["Economy"] = 250000
    },
    ["WEAPON_CARBINERIFLE_MK2"] = {
        ["Index"] = "m4a4",
        ["Name"] = "Carbine Rifle Mk II",
        ["Repair"] = "repairkit04",
        ["Description"] = "Armamento fuzil Carbine Rifle Mk II",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 2,
        ["Class"] = "Armas",
        ["Economy"] = 250000
    },
    ["WEAPON_ADVANCEDRIFLE"] = {
        ["Index"] = "tar21",
        ["Name"] = "Advanced Rifle",
        ["Description"] = "Armamento fuzil Advanced Rifle",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 2,
        ["Class"] = "Armas",
        ["Economy"] = 250000
    },
    ["WEAPON_BULLPUPRIFLE"] = {
        ["Index"] = "qbz95",
        ["Name"] = "Bullpup Rifle",
        ["Description"] = "Armamento fuzil Bullpup Rifle",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 2,
        ["Class"] = "Armas",
        ["Economy"] = 200000
    },
    ["WEAPON_BULLPUPRIFLE_MK2"] = {
        ["Index"] = "l85",
        ["Name"] = "Bullpup Rifle Mk II",
        ["Repair"] = "repairkit04",
        ["Description"] = "Armamento fuzil Bullpup Rifle Mk II",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 2,
        ["Class"] = "Armas",
        ["Economy"] = 250000
    },
    ["WEAPON_SPECIALCARBINE"] = {
        ["Index"] = "g36c",
        ["Name"] = "Special Carbine",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 2,
        ["Class"] = "Armas",
        ["Economy"] = 260000
    },
    ["WEAPON_BULLPUP_ANIME"] = {
        ["Index"] = "Rifle Anime",
        ["Name"] = "Rifle Anime",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_PINKFIRE"] = {
        ["Index"] = "Rifle Pinkfire",
        ["Name"] = "Rifle Pinkfire",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_SPECIALCARBINE_TOXIC"] = {
        ["Index"] = "Rifle Toxic",
        ["Name"] = "Rifle Toxic",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_PL_PENHASHOP_G3_PCJ_V2"] = {
        ["Index"] = "G3 MK2 PCJ",
        ["Name"] = "G3 MK2 PCJ",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_SKORPION"] = {
        ["Index"] = "Skorpion",
        ["Name"] = "Skorpion",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_SPECIALCARBINE_MK2_MISTICDRAGON"] = {
        ["Index"] = "WEAPON_SPECIALCARBINE_MK2_MISTICDRAGON",
        ["Name"] = "Special Carbine MK2 Mistic Dragon",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_APPISTOL_MISTICDRAGON"] = {
        ["Index"] = "WEAPON_APPISTOL_MISTICDRAGON",
        ["Name"] = "Appistol Mistic Dragon",
        ["Repair"] = "repairkit02",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_PISTOL_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_SNIPER_MISTICDRAGON"] = {
        ["Index"] = "WEAPON_SNIPER_MISTICDRAGON",
        ["Name"] = "Sniper Mistic Dragon",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_SNIPER_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 230000
    },
    ["WEAPON_KNIFE_MISTICDRAGON"] = {
        ["Index"] = "WEAPON_KNIFE_MISTICDRAGON",
        ["Name"] = "Knife Mistic Dragon",
        ["Repair"] = "repairkit01",
        ["Type"] = "Armamento",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_SPECIALCARBINE_MK2_ZEUS"] = {
        ["Index"] = "WEAPON_SPECIALCARBINE_MK2_ZEUS",
        ["Name"] = "Special Carbine MK2 Zeus",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_APPISTOL_ZEUS"] = {
        ["Index"] = "WEAPON_APPISTOL_ZEUS",
        ["Name"] = "Appistol Zeus",
        ["Repair"] = "repairkit02",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_PISTOL_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_BAT_ZEUS"] = {
        ["Index"] = "WEAPON_BAT_ZEUS",
        ["Name"] = "Bastão Zeus",
        ["Repair"] = "repairkit01",
        ["Type"] = "Armamento",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_KARAMBIT_ZEUS"] = {
        ["Index"] = "WEAPON_KARAMBIT_ZEUS",
        ["Name"] = "Karambit Zeus",
        ["Repair"] = "repairkit01",
        ["Type"] = "Armamento",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_GGSPURPLEVVS"] = {
        ["Index"] = "WEAPON_GGSPURPLEVVS",
        ["Name"] = "Koch VP9 Purple",
        ["Repair"] = "repairkit02",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_PISTOL_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_GGSGREYVVS"] = {
        ["Index"] = "WEAPON_GGSGREYVVS",
        ["Name"] = "Koch VP9 Grey",
        ["Repair"] = "repairkit02",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_PISTOL_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_GGSBLUEVVS"] = {
        ["Index"] = "WEAPON_GGSBLUEVVS",
        ["Name"] = "Koch VP9 Blue",
        ["Repair"] = "repairkit02",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_PISTOL_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_GGSWHITEVVS"] = {
        ["Index"] = "WEAPON_GGSWHITEVVS",
        ["Name"] = "Koch VP9 White",
        ["Repair"] = "repairkit02",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_PISTOL_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_GGSREDVVS"] = {
        ["Index"] = "WEAPON_GGSREDVVS",
        ["Name"] = "Koch VP9 Red",
        ["Repair"] = "repairkit02",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_PISTOL_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_CARBINERIFLE_MK2_RETROPIXEL_BLUE"] = {
        ["Index"] = "WEAPON_CARBINERIFLE_MK2_RETROPIXEL_BLUE",
        ["Name"] = "Carbine Rifle MK2 Retropixel Blue",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_CARBINERIFLE_MK2_RETROPIXEL_PURPLE"] = {
        ["Index"] = "WEAPON_CARBINERIFLE_MK2_RETROPIXEL_PURPLE",
        ["Name"] = "Carbine Rifle MK2 Retropixel Purple",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_CARBINERIFLE_MK2_RETROPIXEL_RED"] = {
        ["Index"] = "WEAPON_CARBINERIFLE_MK2_RETROPIXEL_RED",
        ["Name"] = "Carbine Rifle MK2 Retropixel Red",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_CARBINERIFLE_MK2_RETROPIXEL_WHITE"] = {
        ["Index"] = "WEAPON_CARBINERIFLE_MK2_RETROPIXEL_WHITE",
        ["Name"] = "Carbine Rifle MK2 Retropixel White",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_SPECIALCARBINE_MK2_RETROPIXEL_BLUE"] = {
        ["Index"] = "WEAPON_SPECIALCARBINE_MK2_RETROPIXEL_BLUE",
        ["Name"] = "Special Carbine MK2 Retropixel Blue",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_SPECIALCARBINE_MK2_RETROPIXEL_PURPLE"] = {
        ["Index"] = "WEAPON_SPECIALCARBINE_MK2_RETROPIXEL_PURPLE",
        ["Name"] = "Special Carbine MK2 Retropixel Purple",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_SPECIALCARBINE_MK2_RETROPIXEL_RED"] = {
        ["Index"] = "WEAPON_SPECIALCARBINE_MK2_RETROPIXEL_RED",
        ["Name"] = "Special Carbine MK2 Retropixel Red",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_SPECIALCARBINE_MK2_RETROPIXEL_WHITE"] = {
        ["Index"] = "WEAPON_SPECIALCARBINE_MK2_RETROPIXEL_WHITE",
        ["Name"] = "Special Carbine MK2 Retropixel White",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_BULLPUPMK2_RETROPIXEL_BLUE"] = {
        ["Index"] = "WEAPON_BULLPUPMK2_RETROPIXEL_BLUE",
        ["Name"] = "Bullpup MK2 Retropixel Blue",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_BULLPUPMK2_RETROPIXEL_PURPLE"] = {
        ["Index"] = "WEAPON_BULLPUPMK2_RETROPIXEL_PURPLE",
        ["Name"] = "Bullpup MK2 Retropixel Purple",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_BULLPUPMK2_RETROPIXEL_RED"] = {
        ["Index"] = "WEAPON_BULLPUPMK2_RETROPIXEL_RED",
        ["Name"] = "Bullpup MK2 Retropixel Red",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_BULLPUPMK2_RETROPIXEL_WHITE"] = {
        ["Index"] = "WEAPON_BULLPUPMK2_RETROPIXEL_WHITE",
        ["Name"] = "Bullpup MK2 Retropixel White",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_ASSAULTSMG_RETROPIXEL_BLUE"] = {
        ["Index"] = "WEAPON_ASSAULTSMG_RETROPIXEL_BLUE",
        ["Name"] = "Assault SMG Retropixel Blue",
        ["Repair"] = "repairkit03",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_SMG_AMMO",
        ["Weight"] = 1,
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_ASSAULTSMG_RETROPIXEL_PURPLE"] = {
        ["Index"] = "WEAPON_ASSAULTSMG_RETROPIXEL_PURPLE",
        ["Name"] = "Assault SMG Retropixel Purple",
        ["Repair"] = "repairkit03",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_SMG_AMMO",
        ["Weight"] = 1,
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_ASSAULTSMG_RETROPIXEL_RED"] = {
        ["Index"] = "WEAPON_ASSAULTSMG_RETROPIXEL_RED",
        ["Name"] = "Assault SMG Retropixel Red",
        ["Repair"] = "repairkit03",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_SMG_AMMO",
        ["Weight"] = 1,
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_ASSAULTSMG_RETROPIXEL_WHITE"] = {
        ["Index"] = "WEAPON_ASSAULTSMG_RETROPIXEL_WHITE",
        ["Name"] = "Assault SMG Retropixel White",
        ["Repair"] = "repairkit03",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_SMG_AMMO",
        ["Weight"] = 1,
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_APPISTOL_RETROPIXEL_BLUE"] = {
        ["Index"] = "WEAPON_APPISTOL_RETROPIXEL_BLUE",
        ["Name"] = "Appistol Retropixel Blue",
        ["Repair"] = "repairkit02",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_PISTOL_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_APPISTOL_RETROPIXEL_PURPLE"] = {
        ["Index"] = "WEAPON_APPISTOL_RETROPIXEL_PURPLE",
        ["Name"] = "Appistol Retropixel Purple",
        ["Repair"] = "repairkit02",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_PISTOL_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_APPISTOL_RETROPIXEL_RED"] = {
        ["Index"] = "WEAPON_APPISTOL_RETROPIXEL_RED",
        ["Name"] = "Appistol Retropixel Red",
        ["Repair"] = "repairkit02",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_PISTOL_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_APPISTOL_RETROPIXEL_WHITE"] = {
        ["Index"] = "WEAPON_APPISTOL_RETROPIXEL_WHITE",
        ["Name"] = "Appistol Retropixel White",
        ["Repair"] = "repairkit02",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_PISTOL_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_MACHETTE_RETROPIXEL_BLUE"] = {
        ["Index"] = "WEAPON_MACHETTE_RETROPIXEL_BLUE",
        ["Name"] = "Machette Retropixel Blue",
        ["Repair"] = "repairkit01",
        ["Type"] = "Armamento",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_MACHETTE_RETROPIXEL_PURPLE"] = {
        ["Index"] = "WEAPON_MACHETTE_RETROPIXEL_PURPLE",
        ["Name"] = "Machette Retropixel Purple",
        ["Repair"] = "repairkit01",
        ["Type"] = "Armamento",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_MACHETTE_RETROPIXEL_RED"] = {
        ["Index"] = "WEAPON_MACHETTE_RETROPIXEL_RED",
        ["Name"] = "Machette Retropixel Red",
        ["Repair"] = "repairkit01",
        ["Type"] = "Armamento",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_MACHETTE_RETROPIXEL_WHITE"] = {
        ["Index"] = "WEAPON_MACHETTE_RETROPIXEL_WHITE",
        ["Name"] = "Machette Retropixel White",
        ["Repair"] = "repairkit01",
        ["Type"] = "Armamento",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_CARBINERIFLE_MK2_STEAMPUNK"] = {
        ["Index"] = "WEAPON_CARBINERIFLE_MK2_STEAMPUNK",
        ["Name"] = "Carbine Rifle MK2 Steampunk",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_SPECIALCARBINE_MK2_WINTERFLOWER"] = {
        ["Index"] = "WEAPON_SPECIALCARBINE_MK2_WINTERFLOWER",
        ["Name"] = "Special Carbine MK2 Winterflower",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_SNIPER_DRAGONREDRUSTIC"] = {
        ["Index"] = "WEAPON_SNIPER_DRAGONREDRUSTIC",
        ["Name"] = "Sniper Dragonred Rustic",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_SNIPER_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_SPECIALCARBINE_MK2_DRAGONREDRUSTIC"] = {
        ["Index"] = "WEAPON_SPECIALCARBINE_MK2_DRAGONREDRUSTIC",
        ["Name"] = "Special Carbine MK2 Dragonred Rustic",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_KATANA_DRAGONREDRUSTIC"] = {
        ["Index"] = "WEAPON_KATANA_DRAGONREDRUSTIC",
        ["Name"] = "Katana Dragonred Rustic",
        ["Repair"] = "repairkit01",
        ["Type"] = "Armamento",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_APPISTOL_DRAGONREDRUSTIC"] = {
        ["Index"] = "WEAPON_APPISTOL_DRAGONREDRUSTIC",
        ["Name"] = "Appistol Dragonred Rustic",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_PISTOL_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_APPISTOL_OUTLAW"] = {
        ["Index"] = "WEAPON_APPISTOL_OUTLAW",
        ["Name"] = "Appistol Outlaw",
        ["Repair"] = "repairkit02",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_PISTOL_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_APPISTOL_GRAVEYARD"] = {
        ["Index"] = "WEAPON_APPISTOL_GRAVEYARD",
        ["Name"] = "Appistol Graveyard",
        ["Repair"] = "repairkit02",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_PISTOL_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_APPISTOLPINK"] = {
        ["Index"] = "WEAPON_APPISTOLPINK",
        ["Name"] = "Appistol Pink",
        ["Repair"] = "repairkit02",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_PISTOL_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_APPISTOL_CHROME"] = {
        ["Index"] = "WEAPON_APPISTOL_CHROME",
        ["Name"] = "Appistol Chrome",
        ["Repair"] = "repairkit02",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_PISTOL_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_APPISTOL_CROSSDIAMOND"] = {
        ["Index"] = "WEAPON_APPISTOL_CROSSDIAMOND",
        ["Name"] = "Appistol Crossdiamond",
        ["Repair"] = "repairkit02",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_PISTOL_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_APPISTOL_STEAMPUNK"] = {
        ["Index"] = "WEAPON_APPISTOL_STEAMPUNK",
        ["Name"] = "Koch VP9 Steampunk",
        ["Repair"] = "repairkit02",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_PISTOL_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_APPISTOL_IRONDUST"] = {
        ["Index"] = "WEAPON_APPISTOL_IRONDUST",
        ["Name"] = "Koch VP9 Irondust",
        ["Repair"] = "repairkit02",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_PISTOL_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_BATTLEAXE_GRAVEYARD"] = {
        ["Index"] = "WEAPON_BATTLEAXE_GRAVEYARD",
        ["Name"] = "Battleaxe Graveyard",
        ["Repair"] = "repairkit01",
        ["Type"] = "Armamento",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_CARBINERIFLE_MK2_GRAVEYARD"] = {
        ["Index"] = "WEAPON_CARBINERIFLE_MK2_GRAVEYARD",
        ["Name"] = "Carbine Rifle Mk2 Graveyard",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_SPECIALCARBINE_MK2_GRAVEYARD"] = {
        ["Index"] = "WEAPON_SPECIALCARBINE_MK2_GRAVEYARD",
        ["Name"] = "Special Carbine Mk2 Graveyard",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_SPECIALCARBINE_MK2_KAWAI"] = {
        ["Index"] = "WEAPON_SPECIALCARBINE_MK2_KAWAI",
        ["Name"] = "Special Carbine MK2 Kawai",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_APPISTOL_KAWAI"] = {
        ["Index"] = "WEAPON_APPISTOL_KAWAI",
        ["Name"] = "Appistol Kawai",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_PISTOL_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_PISTOLMK2_KAWAI"] = {
        ["Index"] = "WEAPON_PISTOLMK2_KAWAI",
        ["Name"] = "Pistol MK2 Kawai",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_PISTOL_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_PISTOL50_KAWAI"] = {
        ["Index"] = "WEAPON_PISTOL50_KAWAI",
        ["Name"] = "Pistol .50 Kawai",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_PISTOL_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_BULLPUPMK2_KAWAI"] = {
        ["Index"] = "WEAPON_BULLPUPMK2_KAWAI",
        ["Name"] = "Bullpup MK2 Kawai",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_SWITCHBLADE_KAWAI"] = {
        ["Index"] = "WEAPON_SWITCHBLADE_KAWAI",
        ["Name"] = "Switchblade Kawai",
        ["Repair"] = "repairkit01",
        ["Type"] = "Armamento",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_KNIFE_VORTEX"] = {
        ["Index"] = "WEAPON_KNIFE_VORTEX",
        ["Name"] = "Knife Vortex",
        ["Repair"] = "repairkit01",
        ["Type"] = "Armamento",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_ASSAULTRIFLE_MK2_KAWAI"] = {
        ["Index"] = "WEAPON_ASSAULTRIFLE_MK2_KAWAI",
        ["Name"] = "Assault Rifle MK2 Kawai",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_CARBINERIFLE_MK2_KAWAI"] = {
        ["Index"] = "WEAPON_CARBINERIFLE_MK2_KAWAI",
        ["Name"] = "Carbine Rifle MK2 Kawai",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_COMBATPDW_KAWAI"] = {
        ["Index"] = "WEAPON_COMBATPDW_KAWAI",
        ["Name"] = "Combat PDW Kawai",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_APPISTOL_GRAVEYARD"] = {
        ["Index"] = "WEAPON_APPISTOL_GRAVEYARD",
        ["Name"] = "Appistol Graveyard",
        ["Repair"] = "repairkit02",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_PISTOL_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_BATTLEAXE_GRAVEYARD"] = {
        ["Index"] = "WEAPON_BATTLEAXE_GRAVEYARD",
        ["Name"] = "Battleaxe Graveyard",
        ["Repair"] = "repairkit01",
        ["Type"] = "Armamento",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_BAT_KAWAI"] = {
        ["Index"] = "WEAPON_BAT_KAWAI",
        ["Name"] = "Bastão Kawai",
        ["Repair"] = "repairkit01",
        ["Type"] = "Armamento",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_CARBINERIFLE_MK2_GRAVEYARD"] = {
        ["Index"] = "WEAPON_CARBINERIFLE_MK2_GRAVEYARD",
        ["Name"] = "Carbine Rifle Mk2 Graveyard",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_SPECIALCARBINE_MK2_GRAVEYARD"] = {
        ["Index"] = "WEAPON_SPECIALCARBINE_MK2_GRAVEYARD",
        ["Name"] = "Special Carbine Mk2 Graveyard",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_BLACKSNAKE"] = {
        ["Index"] = "WEAPON_BLACKSNAKE",
        ["Name"] = "Blacksnake",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_BULLPUPRIFLE_MK2_LOBO"] = {
        ["Index"] = "WEAPON_BULLPUPRIFLE_MK2_LOBO",
        ["Name"] = "Lobo",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_WOLFSTORM"] = {
        ["Index"] = "Wolfstorm",
        ["Name"] = "WolfStorm",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_G3LCHELLFIRE"] = {
        ["Index"] = "G3 Chellfire",
        ["Name"] = "WEAPON_G3LCHELLFIRE",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
["Class"] = "Armas",
        ["Economy"] = 775
    },
    ["WEAPON_ONI"] = {
        ["Index"] = "WEAPON_ONI",
        ["Name"] = "Oni",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
["Class"] = "Armas",
        ["Economy"] = 230000
    },
    ["WEAPON_BATTLERIFLE"] = {
        ["Index"] = "Parafal",
        ["Name"] = "Battle Rifle",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 3.75,
        ["Class"] = "Armas",
        ["Economy"] = 230000
    },
    ["WEAPON_TIGER"] = {
        ["Index"] = "WEAPON_TIGER",
        ["Name"] = "Tiger",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
["Class"] = "Armas",
        ["Economy"] = 230000
    },
    ["WEAPON_ABISSAL"] = {
        ["Index"] = "Abissal",
        ["Name"] = "Abissal",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
["Class"] = "Armas",
        ["Economy"] = 230000
    },
    ["WEAPON_SHINIGAMI"] = {
        ["Index"] = "WEAPON_SHINIGAMI",
        ["Name"] = "Shinigami",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_SNIPER_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
["Class"] = "Armas",
        ["Economy"] = 230000
    },
    ["WEAPON_SKORPION_SNIPER"] = {
        ["Index"] = "WEAPON_SKORPION_SNIPER",
        ["Name"] = "Skorpion Sniper",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_SNIPER_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
["Class"] = "Armas",
        ["Economy"] = 230000
    },
    ["WEAPON_SHOCKVOLT_SNIPER"] = {
        ["Index"] = "WEAPON_SHOCKVOLT_SNIPER",
        ["Name"] = "Shockvolt Sniper",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_SNIPER_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
["Class"] = "Armas",
        ["Economy"] = 230000
    },
    ["WEAPON_SNIPERRIFLE_CYBERTRIBAL"] = {
        ["Index"] = "WEAPON_SNIPERRIFLE_CYBERTRIBAL",
        ["Name"] = "Cyber Tribal Sniper",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_SNIPER_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["Class"] = "Armas",
        ["Economy"] = 230000
    },
    ["WEAPON_DRAGONRED_SNIPER"] = {
        ["Index"] = "WEAPON_DRAGONRED_SNIPER",
        ["Name"] = "Dragonred Sniper",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_SNIPER_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
["Class"] = "Armas",
        ["Economy"] = 230000
    },
    ["WEAPON_HEAVYSNIPER_MK2_LOBO"] = {
        ["Index"] = "WEAPON_HEAVYSNIPER_MK2_LOBO",
        ["Name"] = "Heavy Sniper Mk2 Lobo",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_SNIPER_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
["Class"] = "Armas",
        ["Economy"] = 230000
    },
    ["WEAPON_THYZUK_SNIPER"] = {
        ["Index"] = "WEAPON_THYZUK_SNIPER",
        ["Name"] = "Tyzuk Sniper",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_SNIPER_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
["Class"] = "Armas",
        ["Economy"] = 230000
    },
    ["WEAPON_COMBATMG_MK2_GRAVEYARD"] = {
        ["Index"] = "WEAPON_COMBATMG_MK2_GRAVEYARD",
        ["Name"] = "Combat MG Graveyard",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
["Class"] = "Armas",
        ["Economy"] = 230000
    },
    ["WEAPON_TIGER_SNIPER"] = {
        ["Index"] = "WEAPON_TIGER_SNIPER",
        ["Name"] = "Tiger Sniper",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_SNIPER_AMMO",
        ["Weight"] = 3.75,
        ["Block"] = true,
        ["BlockChest"] = true,
["Class"] = "Armas",
        ["Economy"] = 230000
    },
    ["WEAPON_SNIPERRIFLE"] = {
        ["Index"] = "awmmagnum",
        ["Name"] = "Sniper Rifle",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_SNIPER_AMMO",
        ["Weight"] = 5,
        ["Class"] = "Armas",
        ["Economy"] = 3000000
    },
    ["WEAPON_COMBATMG_MK2"] = {
        ["Index"] = "m249",
        ["Name"] = "Combat MG Mk II",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 5,
        ["Class"] = "Armas",
        ["Economy"] = 2000000
    },
    ["WEAPON_MILITARYRIFLE"] = {
        ["Index"] = "mtar-21",
        ["Name"] = "MTAR-21",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 2,
        ["Class"] = "Armas",
        ["Economy"] = 300000
    },
    ["WEAPON_TACTICALRIFLE"] = {
        ["Index"] = "m16",
        ["Name"] = "Tactical Rifle",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 5,
        ["Class"] = "Armas",
        ["Economy"] = 400000
    },
    ["WEAPON_SPECIALCARBINE_MK2"] = {
        ["Index"] = "sigsauer556",
        ["Name"] = "Special Carbine Mk II",
        ["Description"] = "Armamento fuzil Special Carbine Mk II",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 2,
        ["Class"] = "Armas",
        ["Economy"] = 230000
    },
    ["WEAPON_PUMPSHOTGUN"] = {
        ["Index"] = "mossberg590",
        ["Name"] = "Pump Shotgun",
        ["Description"] = "Armamento Pump Shotgun",
        ["Repair"] = "repairkit03",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_SHOTGUN_AMMO",
        ["Weight"] = 5,
        ["Class"] = "Armas",
        ["Economy"] = 500000
    },
    ["WEAPON_PUMPSHOTGUN_MK2"] = {
        ["Index"] = "mossberg590a1",
        ["Name"] = "Pump Shotgun Mk II",
        ["Description"] = "Armamento Pump Shotgun Mk II",
        ["Repair"] = "repairkit04",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_SHOTGUN_AMMO",
        ["Weight"] = 5,
        ["Class"] = "Armas",
        ["Economy"] = 250000
    },
    ["WEAPON_MUSKET"] = {
        ["Index"] = "winchester",
        ["Name"] = "Musket",
        ["Description"] = "Armamento Musket",
        ["Repair"] = "repairkit02",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_MUSKET_AMMO",
        ["Weight"] = 2,
        ["Class"] = "Armas",
        ["Economy"] = 3250
    },
    ["WEAPON_SAWNOFFSHOTGUN"] = {
        ["Index"] = "mossberg500",
        ["Name"] = "Sawed-Off Shotgun",
        ["Repair"] = "repairkit03",
        ["Description"] = "Armamento Sawed-Off Shotgun",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_SHOTGUN_AMMO",
        ["Weight"] = 2,
        ["Class"] = "Armas",
        ["Economy"] = 550000
    },
    ["WEAPON_SMG"] = {
        ["Index"] = "mp5",
        ["Name"] = "SMG",
        ["Repair"] = "repairkit03",
        ["Description"] = "Armamento SMG",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_SMG_AMMO",
        ["Weight"] = 1,
        ["Class"] = "Armas",
        ["Economy"] = 190000
    },
    ["WEAPON_SMG_MK2"] = {
        ["Index"] = "evo3",
        ["Name"] = "SMG Mk II",
        ["Repair"] = "repairkit03",
        ["Description"] = "Armamento SMG Mk II",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_SMG_AMMO",
        ["Vehicle"] = true,
        ["Weight"] = 1,
        ["Class"] = "Armas",
        ["Economy"] = 190000
    },
    ["WEAPON_ASSAULTRIFLE"] = {
        ["Index"] = "ak103",
        ["Name"] = "Assault Rifle",
        ["Repair"] = "repairkit04",
        ["Description"] = "Armamento Assault Rifle",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 2,
        ["Class"] = "Armas",
        ["Economy"] = 250000
    },
    ["WEAPON_ASSAULTRIFLE_MK2"] = {
        ["Index"] = "ak74",
        ["Name"] = "Assault Rifle Mk II",
        ["Repair"] = "repairkit04",
        ["Description"] = "Armamento Assault Rifle Mk II",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 2,
        ["Class"] = "Armas",
        ["Economy"] = 230000
    },
    ["WEAPON_ASSAULTSMG"] = {
        ["Index"] = "steyraug",
        ["Name"] = "Assault SMG",
        ["Repair"] = "repairkit03",
        ["Description"] = "Armamento Assault SMG",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_RIFLE_AMMO",
        ["Weight"] = 2,
        ["Class"] = "Armas",
        ["Economy"] = 180000
    },
    ["WEAPON_GUSENBERG"] = {
        ["Index"] = "thompson",
        ["Name"] = "Gusenberg Sweeper",
        ["Repair"] = "repairkit03",
        ["Description"] = "Armamento Gusenberg Sweeper",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_SMG_AMMO",
        ["Weight"] = 2,
        ["Class"] = "Armas",
        ["Economy"] = 250000
    },
    ["WEAPON_PETROLCAN"] = {
        ["Index"] = "gallon",
        ["Name"] = "Galão",
        ["Type"] = "Armamento",
        ["Ammo"] = "WEAPON_PETROLCAN_AMMO",
        ["Weight"] = 1,
        ["Class"] = "Armas",
        ["Economy"] = 50
    },
    ["GADGET_PARACHUTE"] = {
        ["Index"] = "parachute",
        ["Name"] = "Paraquedas",
        ["Description"] = "Item para pular de paraquedas",
        ["Type"] = "Usável",
        ["Weight"] = 1.25,
        ["Class"] = "Armas",
        ["Economy"] = 1000
    },
    ["WEAPON_STUNGUN"] = {
        ["Index"] = "stungun",
        ["Name"] = "Stun Gun",
        ["Repair"] = "repairkit02",
        ["Type"] = "Armamento",
                ["Weight"] = 0.75,
        ["Class"] = "Armas",
        ["Economy"] = 525
    },
    ["WEAPON_NAIL_AMMO"] = {
        ["Index"] = "nails",
        ["Name"] = "M. Pregos",
        ["Description"] = "Munição de grampeador, prego",
        ["Type"] = "Munição",
        ["Weight"] = 0.004,
        ["Class"] = "Armas",
        ["Economy"] = 2
    },
    ["WEAPON_PISTOL_AMMO"] = {
        ["Index"] = "pistolammo",
        ["Name"] = "M. Pistola",
        ["Description"] = "Munição de armamento, Pistolas",
        ["Type"] = "Munição",
        ["Weight"] = 0.03,
        ["Class"] = "Armas",
        ["Economy"] = 50
    },
    ["WEAPON_SMG_AMMO"] = {
        ["Index"] = "smgammo",
        ["Name"] = "M. Sub",
        ["Description"] = "Munição de armamento, Submetralhadora",
        ["Type"] = "Munição",
        ["Weight"] = 0.03,
        ["Class"] = "Armas",
        ["Economy"] = 60
    },
    ["WEAPON_RIFLE_AMMO"] = {
        ["Index"] = "rifleammo",
        ["Name"] = "M. Rifle",
        ["Type"] = "Munição",
        ["Weight"] = 0.03,
        ["Class"] = "Armas",
        ["Economy"] = 75
    },
    ["WEAPON_SNIPER_AMMO"] = {
        ["Index"] = "sniperammo",
        ["Name"] = "M. Sniper",
        ["Type"] = "Munição",
        ["Weight"] = 0.03,
        ["Class"] = "Armas",
        ["Economy"] = 120
    },
    ["WEAPON_SHOTGUN_AMMO"] = {
        ["Index"] = "shotgunammo",
        ["Name"] = "M. Escopeta",
        ["Description"] = "Munição de armamento, 12 Shotgunn",
        ["Type"] = "Munição",
        ["Weight"] = 0.03,
        ["Class"] = "Armas",
        ["Economy"] = 75
    },
    ["WEAPON_MUSKET_AMMO"] = {
        ["Index"] = "musketammo",
        ["Name"] = "M. Mosquete",
        ["Description"] = "Munição de armamento. Mosquete",
        ["Type"] = "Munição",
        ["Weight"] = 0.03,
        ["Class"] = "Armas",
        ["Economy"] = 7
    },
    ["WEAPON_PETROLCAN_AMMO"] = {
        ["Index"] = "fuel",
        ["Name"] = "Combustível",
        ["Description"] = "Combustível, item para encher o tanque do veiculo",
        ["Type"] = "Munição",
        ["Weight"] = 0.00,
        ["Class"] = "Armas",
        ["Economy"] = 0
    },
    ["WEAPON_BRICK"] = {
        ["Index"] = "brick",
        ["Name"] = "Tijolo",
        ["Description"] = "item de pedra feito para tacar nos outros ou construir algo",
        ["Type"] = "Throwing",
        ["Vehicle"] = true,
                ["Weight"] = 0.75,
        ["Class"] = "Armas",
        ["Economy"] = 25
    },
    ["WEAPON_SNOWBALL"] = {
        ["Index"] = "snowball",
        ["Name"] = "Bola de Neve",
        ["Description"] = "item feito com gelo/neve",
        ["Type"] = "Throwing",
        ["Vehicle"] = true,
        ["Weight"] = 0.55,
        ["Class"] = "Armas",
        ["Economy"] = 6
    },
    ["WEAPON_SHOES"] = {
        ["Index"] = "shoes",
        ["Name"] = "Tênis",
        ["Type"] = "Throwing",
        ["Description"] = "Tênis, item de vestimenta",
        ["Vehicle"] = true,
        ["Weight"] = 0.755,
        ["Class"] = "Armas",
        ["Economy"] = 25
    },
    ["WEAPON_MOLOTOV"] = {
        ["Index"] = "molotov",
        ["Name"] = "Coquetel Molotov",
        ["Type"] = "Throwing",
        ["Vehicle"] = true,
        ["Weight"] = 0.95,
        ["Class"] = "Armas",
        ["Economy"] = 225,
        ["Max"] = 3
    },
     ["WEAPON_PROXMINE"] = {
        ["Index"] = "proxmine",
        ["Name"] = "Claymore",
        ["Type"] = "Throwing",
        ["Vehicle"] = true,
        ["Weight"] = 0.95,
        ["Class"] = "Armas",
        ["Economy"] = 225,
        ["Max"] = 3
    },
    ["WEAPON_SMOKEGRENADE"] = {
        ["Index"] = "smokegrenade",
        ["Name"] = "Granada de Fumaça",
        ["Description"] = "Granada de fumaça, item utilizado em guerras",
        ["Type"] = "Throwing",
        ["Vehicle"] = true,
        ["Weight"] = 0.95,
        ["Class"] = "Armas",
        ["Economy"] = 225,
        ["Max"] = 3
    },
    ["pager"] = {
        ["Index"] = "pager",
        ["Name"] = "Pager",
        ["Type"] = "Usável",
        ["Weight"] = 1.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 125
    },
    ["firecracker"] = {
        ["Index"] = "firecracker",
        ["Name"] = "Fogos de Artificio",
        ["Type"] = "Usável",
        ["Weight"] = 1.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 100
    },
    ["analgesic"] = {
        ["Index"] = "analgesic",
        ["Name"] = "Analgésico",
        ["Description"] = "Analgesico, Item médico para cura de um ferimento",
        ["Type"] = "Usável",
        ["Weight"] = 0.25,
        ["Class"] = "Medicamentos",
        ["Max"] = 5,
        ["Economy"] = 10000
    },
    ["oxy"] = {
        ["Index"] = "analgesic",
        ["Name"] = "Oxy",
        ["Type"] = "Usável",
        ["Weight"] = 0.25,
        ["Class"] = "Medicamentos",
        ["Max"] = 5,
        ["Economy"] = 35
    },
    ["gauze"] = {
        ["Index"] = "gauze",
        ["Name"] = "Ataduras",
        ["Description"] = "Atadura, Item médico para cura de um ferimento",
        ["Type"] = "Usável",
        ["Weight"] = 0.25,
        ["Class"] = "Medicamentos",
        ["Max"] = 5,
        ["Economy"] = 10000
    },
    ["gsrkit"] = {
        ["Index"] = "gsrkit",
        ["Name"] = "Kit Residual",
        ["Type"] = "Usável",
                ["Weight"] = 0.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 20
    },
    ["gdtkit"] = {
        ["Index"] = "gdtkit",
        ["Name"] = "Kit Químico",
        ["Type"] = "Usável",
                ["Weight"] = 0.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 20
    },
    ["emerald"] = {
        ["Index"] = "emerald",
        ["Name"] = "Esmeralda",
        ["Description"] = "Esmeralda, pedra preciosa de grande valor",
        ["Type"] = "Comum",
        ["Weight"] = 0.95,
        ["Class"] = "Utilitarios",
        ["Economy"] = 85
    },
    ["diamond"] = {
        ["Index"] = "diamond",
        ["Name"] = "Diamante",
        ["Description"] = "Diamante, pedra preciosa de grande valor",
        ["Type"] = "Comum",
        ["Weight"] = 0.95,
        ["Class"] = "Utilitarios",
        ["Economy"] = 75
    },
    ["ruby"] = {
        ["Index"] = "ruby",
        ["Name"] = "Rubi",
        ["Description"] = "Rubi, pedra preciosa de grande valor",
        ["Type"] = "Comum",
        ["Weight"] = 0.85,
        ["Class"] = "Utilitarios",
        ["Economy"] = 55
    },
    ["sapphire"] = {
        ["Index"] = "sapphire",
        ["Name"] = "Safira",
        ["Description"] = "Safira, pedra preciosa de grande valor",
        ["Type"] = "Comum",
        ["Weight"] = 0.85,
        ["Class"] = "Utilitarios",
        ["Economy"] = 45
    },
    ["amethyst"] = {
        ["Index"] = "amethyst",
        ["Name"] = "Ametista",
        ["Type"] = "Comum",
                ["Weight"] = 0.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 35
    },
    ["amber"] = {
        ["Index"] = "amber",
        ["Name"] = "Âmbar",
        ["Type"] = "Comum",
                ["Weight"] = 0.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 25
    },
    ["turquoise"] = {
        ["Index"] = "turquoise",
        ["Name"] = "Turquesa",
        ["Type"] = "Comum",
        ["Weight"] = 0.65,
        ["Class"] = "Utilitarios",
        ["Economy"] = 15
    },
    ["keyboard"] = {
        ["Index"] = "keyboard",
        ["Name"] = "Teclado",
        ["Description"] = "Teclado, periferico do cumputador",
        ["Type"] = "Comum",
                ["Weight"] = 0.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 75
    },
    ["mouse"] = {
        ["Index"] = "mouse",
        ["Name"] = "Mouse",
        ["Description"] = "Mouse, periferico do cumputador",
        ["Type"] = "Comum",
        ["Weight"] = 0.55,
        ["Class"] = "Utilitarios",
        ["Economy"] = 75
    },
    ["silverring"] = {
        ["Index"] = "silverring",
        ["Name"] = "Anel de Prata",
        ["Description"] = "Anel de prata, produto de embeleze pessoal",
        ["Type"] = "Comum",
        ["Weight"] = 0.35,
        ["Class"] = "Utilitarios",
        ["Economy"] = 75
    },
    ["goldring"] = {
        ["Index"] = "goldring",
        ["Name"] = "Anel de Ouro",
        ["Description"] = "Anel de ouro, produto de embeleze pessoal",
        ["Type"] = "Comum",
        ["Weight"] = 0.45,
        ["Class"] = "Utilitarios",
        ["Economy"] = 100
    },
    ["silvercoin"] = {
        ["Index"] = "silvercoin",
        ["Name"] = "Moeda de Prata",
        ["Description"] = "Moeda de prata, item de valor, dinheiro",
        ["Type"] = "Usável",
        ["Weight"] = 0.05,
        ["Class"] = "Utilitarios",
        ["Economy"] = 20
    },
    ["goldcoin"] = {
        ["Index"] = "goldcoin",
        ["Name"] = "Moeda de Ouro",
        ["Description"] = "Moeda de Ouro, item de valor, dinheiro",
        ["Type"] = "Usável",
        ["Weight"] = 0.05,
        ["Class"] = "Utilitarios",
        ["Economy"] = 40
    },
    ["watch"] = {
        ["Index"] = "watch",
        ["Name"] = "Relógio",
        ["Description"] = "Bracelete, produto de enfeite pessoal",
        ["Type"] = "Comum",
                ["Weight"] = 0.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 75
    },
    ["bracelet"] = {
        ["Index"] = "bracelet",
        ["Name"] = "Bracelete",
        ["Description"] = "Bracelete, produto de enfeite pessoal",
        ["Type"] = "Comum",
        ["Weight"] = 0.55,
        ["Class"] = "Utilitarios",
        ["Economy"] = 75
    },
    ["spray01"] = {
        ["Index"] = "spray01",
        ["Name"] = "Desodorante 24hrs",
        ["Description"] = "Desodorante, produto de higiene pessoal",
        ["Type"] = "Comum",
        ["Weight"] = 0.35,
        ["Class"] = "Utilitarios",
        ["Economy"] = 75
    },
    ["spray02"] = {
        ["Index"] = "spray02",
        ["Name"] = "Antisséptico",
        ["Description"] = "Antisséptico, produto de higiene pessoal",
        ["Type"] = "Comum",
        ["Weight"] = 0.35,
        ["Class"] = "Utilitarios",
        ["Economy"] = 75
    },
    ["spray03"] = {
        ["Index"] = "spray03",
        ["Name"] = "Desodorante 48hrs",
        ["Description"] = "Desodorante, produto de higiene pessoal",
        ["Type"] = "Comum",
        ["Weight"] = 0.35,
        ["Class"] = "Utilitarios",
        ["Economy"] = 75
    },
    ["spray04"] = {
        ["Index"] = "spray04",
        ["Name"] = "Desodorante 72hrs",
        ["Description"] = "Desodorante, produto de higiene pessoal",
        ["Type"] = "Comum",
        ["Weight"] = 0.35,
        ["Class"] = "Utilitarios",
        ["Economy"] = 75
    },
    ["dices"] = {
        ["Index"] = "dices",
        ["Name"] = "Dados",
        ["Description"] = "Dado, item feito para jogos",
        ["Type"] = "Usável",
        ["Weight"] = 0.35,
        ["Class"] = "Utilitarios",
        ["Economy"] = 45
    },
    ["dish"] = {
        ["Index"] = "dish",
        ["Name"] = "Prato",
        ["Description"] = "Prato, item de cozinha para fazer suas refeições",
        ["Type"] = "Comum",
        ["Weight"] = 0.55,
        ["Class"] = "Utilitarios",
        ["Economy"] = 75
    },
    ["pan"] = {
        ["Index"] = "pan",
        ["Name"] = "Panela",
        ["Description"] = "Panela, item de cozinha para fazer alimentos",
        ["Type"] = "Usável",
        ["Weight"] = 0.55,
        ["Class"] = "Utilitarios",
        ["Economy"] = 100
    },
    ["fan"] = {
        ["Index"] = "fan",
        ["Name"] = "Ventilador",
        ["Description"] = "Ventilador",
        ["Type"] = "Comum",
        ["Weight"] = 1.15,
        ["Class"] = "Utilitarios",
        ["Economy"] = 75
    },
    ["rimel"] = {
        ["Index"] = "rimel",
        ["Name"] = "Rímel",
        ["Description"] = "Item de maquiagem",
        ["Type"] = "Comum",
        ["Weight"] = 0.35,
        ["Class"] = "Utilitarios",
        ["Economy"] = 75
    },
    ["blender"] = {
        ["Index"] = "blender",
        ["Name"] = "Liquidificador",
        ["Description"] = "Liquidificador, item sem função",
        ["Type"] = "Usável",
                ["Weight"] = 0.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 75
    },
    ["switch"] = {
        ["Index"] = "switch",
        ["Name"] = "Interruptor",
        ["Description"] = "Interruptor de tomara, item sem função",
        ["Type"] = "Comum",
        ["Weight"] = 0.35,
        ["Class"] = "Utilitarios",
        ["Economy"] = 45
    },
    ["horseshoe"] = {
        ["Index"] = "horseshoe",
        ["Name"] = "Ferradura",
        ["Description"] = "Ferradura, item sem função",
        ["Type"] = "Comum",
        ["Weight"] = 0.45,
        ["Class"] = "Utilitarios",
        ["Economy"] = 75
    },
    ["brush"] = {
        ["Index"] = "brush",
        ["Name"] = "Escova",
        ["Description"] = "Escova de cabeço",
        ["Type"] = "Comum",
        ["Weight"] = 0.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 75
    },
    ["domino"] = {
        ["Index"] = "domino",
        ["Name"] = "Dominó",
        ["Description"] = "Item de jogo,item sem função",
        ["Type"] = "Comum",
        ["Weight"] = 0.15,
        ["Class"] = "Utilitarios",
        ["Economy"] = 45
    },
    ["floppy"] = {
        ["Index"] = "floppy",
        ["Name"] = "Disquete",
        ["Description"] = "Item de informatica, item sem função",
        ["Type"] = "Comum",
        ["Weight"] = 0.15,
        ["Class"] = "Utilitarios",
        ["Economy"] = 45
    },
    ["cup"] = {
        ["Index"] = "cup",
        ["Name"] = "Cálice",
        ["Description"] = "Cálice, item sem função",
        ["Type"] = "Comum",
        ["Weight"] = 0.45,
        ["Class"] = "Utilitarios",
        ["Economy"] = 100
    },
    ["deck"] = {
        ["Index"] = "deck",
        ["Name"] = "Baralho",
        ["Description"] = "Item de jogo, baralho, carta, item sem função",
        ["Type"] = "Usável",
        ["Weight"] = 0.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 75
    },
    ["eraser"] = {
        ["Index"] = "eraser",
        ["Name"] = "Apagador",
        ["Description"] = "Item escolar",
        ["Type"] = "Comum",
        ["Weight"] = 0.15,
        ["Class"] = "Utilitarios",
        ["Economy"] = 75
    },
    ["pliers"] = {
        ["Index"] = "pliers",
        ["Name"] = "Alicate",
        ["Description"] = "Ferramenta",
        ["Type"] = "Comum",
                ["Weight"] = 0.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 55
    },
    ["lampshade"] = {
        ["Index"] = "lampshade",
        ["Name"] = "Abajur",
        ["Description"] = "Item de iluminação",
        ["Type"] = "Comum",
                ["Weight"] = 0.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 75
    },
    ["soap"] = {
        ["Index"] = "soap",
        ["Name"] = "Sabonete",
        ["Description"] = "Item de banho",
        ["Type"] = "Usável",
        ["Weight"] = 0.25,
        ["Class"] = "Utilitarios",
        ["Economy"] = 75
    },
    ["slipper"] = {
        ["Index"] = "slipper",
        ["Name"] = "Chinelo",
        ["Description"] = "Item de calçado",
        ["Type"] = "Comum",
        ["Weight"] = 0.35,
        ["Class"] = "Utilitarios",
        ["Economy"] = 75
    },
    ["pendrive"] = {
        ["Index"] = "pendrive",
        ["Name"] = "Pendrive",
        ["Description"] = "Para efeturar roubo de lojinhas",
        ["Repair"] = "repairkit01",
        ["Type"] = "Comum",
                ["Weight"] = 0.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 325
    },
    ["backpack1"] = {
        ["Index"] = "backpack1",
        ["Name"] = "Mochila 20kg",
        ["Description"] = "Para carregar mais tralhas",
        ["Repair"] = "repairkit01",
        ["Type"] = "Comum",
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Weight"] = 0.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 3000
    },
    ["backpack2"] = {
        ["Index"] = "backpack2",
        ["Name"] = "Mochila 80kg",
        ["Description"] = "Para carregar mais tralhas",
        ["Repair"] = "repairkit01",
        ["Type"] = "Comum",
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Weight"] = 0.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 3000
    },
    ["backpack3"] = {
        ["Index"] = "backpack3",
        ["Name"] = "Mochila 120kg",
        ["Description"] = "Para carregar mais tralhas",
        ["Repair"] = "repairkit01",
        ["Type"] = "Comum",
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Weight"] = 0.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 3000
    },
    ["backpack4"] = {
        ["Index"] = "backpack4",
        ["Name"] = "Mochila 150kg",
        ["Description"] = "Para carregar mais tralhas",
        ["Repair"] = "repairkit01",
        ["Type"] = "Comum",
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Weight"] = 0.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 3000
    },
    ["backpack5"] = {
        ["Index"] = "backpack5",
        ["Name"] = "Mochila 200kg",
        ["Description"] = "Para carregar mais tralhas",
        ["Repair"] = "repairkit01",
        ["Type"] = "Comum",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 1.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 3000
    },
    ["backpack6"] = {
        ["Index"] = "backpack6",
        ["Name"] = "Mochila 400kg",
        ["Description"] = "Para carregar mais tralhas",
        ["Repair"] = "repairkit01",
        ["Type"] = "Comum",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 1.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 3000
    },
    ["backpack7"] = {
        ["Index"] = "backpack7",
        ["Name"] = "Mochila 50kg",
        ["Description"] = "Para carregar mais tralhas",
        ["Repair"] = "repairkit01",
        ["Type"] = "Comum",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 1.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 3000
    },
    ["backpack8"] = {
        ["Index"] = "backpack8",
        ["Name"] = "Mochila 10kg",
        ["Description"] = "Para carregar mais tralhas",
        ["Repair"] = "repairkit01",
        ["Type"] = "Comum",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 1.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 3000
    },
    ["verificado1"] = {
        ["Index"] = "verificado1",
        ["Name"] = "Fotogram Verificado",
        -- ["Description"] = "Para carregar mais tralhas",
        ["Repair"] = "repairkit01",
        ["Type"] = "Comum",
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Weight"] = 0.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 3000
    },
    ["fans1"] = {
        ["Index"] = "fans1",
        ["Name"] = "Fotogram 500 ",
        -- ["Description"] = "Para carregar mais tralhas",
        ["Repair"] = "repairkit01",
        ["Type"] = "Comum",
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Weight"] = 0.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 3000
    },
    ["fans100"] = {
        ["Index"] = "fans1",
        ["Name"] = "Fotogram Seguidores",
        ["Repair"] = "repairkit01",
        ["Type"] = "Comum",
        ["Block"] = true,
        ["BlockChest"] = true,
        ["BlockRemove"] = true,
        ["Weight"] = 0.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 3000
    },
    ["fans200"] = {
        ["Index"] = "fans1",
        ["Name"] = "Fotogram Seguidores",
        ["Repair"] = "repairkit01",
        ["Type"] = "Comum",
        ["Block"] = true,
        ["BlockChest"] = true,
        ["BlockRemove"] = true,
        ["Weight"] = 0.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 3000
    },
    ["fans300"] = {
        ["Index"] = "fans1",
        ["Name"] = "Fotogram Seguidores",
        ["Repair"] = "repairkit01",
        ["Type"] = "Comum",
        ["Block"] = true,
        ["BlockChest"] = true,
        ["BlockRemove"] = true,
        ["Weight"] = 0.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 3000
    },
    ["fans500"] = {
        ["Index"] = "fans1",
        ["Name"] = "Fotogram Seguidores",
        ["Repair"] = "repairkit01",
        ["Type"] = "Comum",
        ["Block"] = true,
        ["BlockChest"] = true,
        ["BlockRemove"] = true,
        ["Weight"] = 0.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 3000
    },
    ["fans1000"] = {
        ["Index"] = "fans1",
        ["Name"] = "Fotogram Seguidores",
        ["Repair"] = "repairkit01",
        ["Type"] = "Comum",
        ["Block"] = true,
        ["BlockChest"] = true,
        ["BlockRemove"] = true,
        ["Weight"] = 0.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 3000
    },
    ["fans2000"] = {
        ["Index"] = "fans1",
        ["Name"] = "Fotogram Seguidores",
        ["Repair"] = "repairkit01",
        ["Type"] = "Comum",
        ["Block"] = true,
        ["BlockChest"] = true,
        ["BlockRemove"] = true,
        ["Weight"] = 0.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 3000
    },
    ["fans5000"] = {
        ["Index"] = "fans1",
        ["Name"] = "Fotogram Seguidores",
        ["Repair"] = "repairkit01",
        ["Type"] = "Comum",
        ["Block"] = true,
        ["BlockChest"] = true,
        ["BlockRemove"] = true,
        ["Weight"] = 0.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 3000
    },
    ["fans10000"] = {
        ["Index"] = "fans1",
        ["Name"] = "Fotogram Seguidores",
        ["Repair"] = "repairkit01",
        ["Type"] = "Comum",
        ["Block"] = true,
        ["BlockChest"] = true,
        ["BlockRemove"] = true,
        ["Weight"] = 0.75,
        ["Class"] = "Utilitarios",
        ["Economy"] = 3000
    },
    -- # Casino
    ["blackjack_table"] = {
        ["Index"] = "blackjack_table",
        ["Name"] = "Blackjack Table",
        ["Description"] = "Blackjack Table, item de jogo",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["Weight"] = 1.25,
    },
    ["baccarat_table"] = {
        ["Index"] = "baccarat_table",
        ["Name"] = "Baccarat Table",
        ["Description"] = "Baccarat Table, item de jogo",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["Weight"] = 1.25,
    },
    ["roulette_table"] = {
        ["Index"] = "roulette_table",
        ["Name"] = "Roulette Table",
        ["Description"] = "Roulette Table, item de jogo",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["Weight"] = 1.25,
    },
    ["thunder_roulette_table"] = {
        ["Index"] = "thunder_roulette_table",
        ["Name"] = "Thunder Roulette Table",
        ["Description"] = "Thunder Roulette Table, item de jogo",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["Weight"] = 1.25,
    },
    ["poker_table"] = {
        ["Index"] = "poker_table",
        ["Name"] = "Poker Table",
        ["Description"] = "Poker Table, item de jogo",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["Weight"] = 1.25,
    },
    ["horseracing_machine"] = {
        ["Index"] = "horseracing_machine",
        ["Name"] = "Horse Racing Machine",
        ["Description"] = "Horse Racing Machine, item de jogo",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["Weight"] = 1.25,
    },
    ["slot_machine"] = {
        ["Index"] = "slot_machine",
        ["Name"] = "Slot Machine",
        ["Description"] = "Slot Machine, item de jogo",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["Weight"] = 1.25,
    },
    ["wheel_machine"] = {
        ["Index"] = "wheel_machine",
        ["Name"] = "Wheel Machine",
        ["Description"] = "Wheel Machine, item de jogo",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["Weight"] = 1.25,
    },
    ["chips"] = {
        ["Index"] = "chips",
        ["Name"] = "Cassino Chips",
        ["Description"] = "Cassino Chips, item de jogo",
        ["Type"] = "Usável",
        ["Weight"] = 1.25,
    },
    ["crab"] = {
        ["Index"] = "crab",
        ["Name"] = "Caranguejo Travesso",
        ["Description"] = "Colecionável exclusivo do VIP Pé Na Areia. Um caranguejo divertido que simboliza a vida marinha e o espírito descontraído da praia.",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"] = 325,
    },
    ["santa2"] = {
        ["Index"] = "santa",
        ["Name"] = "Letra A Angelical",
        ["Description"] = "Colecionável exclusivo do VIP Pé Na Areia. Uma letra angelical com auréola dourada que transmite pureza e boas energias do verão.",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"] = 300,
    },
    ["sun"] = {
        ["Index"] = "sun",
        ["Name"] = "Sol Radiante",
        ["Description"] = "Colecionável exclusivo do VIP Pé Na Areia. Um sol sorridente que simboliza calor, alegria e a vibe positiva do litoral.",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"] = 400,
    },    
    ["surfboard"] = {
        ["Index"] = "surfboard",
        ["Name"] = "Prancha de Surf",
        ["Description"] = "Colecionável exclusivo do VIP Pé Na Areia. Uma prancha estilizada que simboliza liberdade, estilo de vida praiano e ostentação única.",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["faquinha"] = {
        ["Index"] = "faquinha",
        ["Name"] = "Faquinha",
        ["Description"] = "Colecionável exclusivo do VIP Pé Na Areia. Uma prancha estilizada que simboliza liberdade, estilo de vida praiano e ostentação única.",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["maozinhaaddams"] = {
        ["Index"] = "maozinhaaddams",
        ["Name"] = "Maozinha",
        ["Description"] = "Colecionável exclusivo do VIP Pé Na Areia. Uma prancha estilizada que simboliza liberdade, estilo de vida praiano e ostentação única.",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["gatinhoabobora"] = {
        ["Index"] = "gatinhoabobora",
        ["Name"] = "Gatinhoabobora",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["morceguinho"] = {
        ["Index"] = "morceguinho",
        ["Name"] = "Morceguinho",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["foice"] = {
        ["Index"] = "foice",
        ["Name"] = "Foice",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["dragao"] = {
        ["Index"] = "dragao",
        ["Name"] = "Dragao",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["fantasminha"] = {
        ["Index"] = "fantasminha",
        ["Name"] = "Fantasminha",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["bruxinha"] = {
        ["Index"] = "bruxinha",
        ["Name"] = "Bruxinha",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["bananacat"] = {
        ["Index"] = "bananacat",
        ["Name"] = "Banana Cat",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["santa25"] = {
        ["Index"] = "santa25",
        ["Name"] = "Papai Noel",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["elf25"] = {
        ["Index"] = "elf25",
        ["Name"] = "Duende",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["ren25"] = {
        ["Index"] = "ren25",
        ["Name"] = "Rena",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["snow25"] = {
        ["Index"] = "snow25",
        ["Name"] = "Boneco de Neve",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["green25"] = {
        ["Index"] = "green25",
        ["Name"] = "Green",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["gift25"] = {
        ["Index"] = "gift25",
        ["Name"] = "Caixa de Presente",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["plumascarnaval"] = {
        ["Index"] = "plumascarnaval",
        ["Name"] = "Plumas de Carnaval",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["coroacarnaval"] = {
        ["Index"] = "coroacarnaval",
        ["Name"] = "Coroa de Plumas",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["confetecarnaval"] = {
        ["Index"] = "confetecarnaval",
        ["Name"] = "Confete de Carnaval",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["spraycarnaval"] = {
        ["Index"] = "spraycarnaval",
        ["Name"] = "Spray de Carnaval",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["tiaracarnaval"] = {
        ["Index"] = "tiaracarnaval",
        ["Name"] = "Tiara de Carnaval",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["tiaracarnaval2"] = {
        ["Index"] = "tiaracarnaval2",
        ["Name"] = "Tiara de Carnavrau",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["frevocarnaval"] = {
        ["Index"] = "frevocarnaval",
        ["Name"] = "Chapéu de Frevo",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["calangocarnaval"] = {
        ["Index"] = "calangocarnaval",
        ["Name"] = "Mascote Calango",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["macacocarnaval"] = {
        ["Index"] = "macacocarnaval",
        ["Name"] = "Macaco Folião",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["placabeijo"] = {
        ["Index"] = "placabeijo",
        ["Name"] = "Plaquinha Beija ou Passa?",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["placajuizo"] = {
        ["Index"] = "placajuizo",
        ["Name"] = "Plaquinha Juízo!",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["placajuizo2"] = {
        ["Index"] = "placajuizo2",
        ["Name"] = "Plaquinha Procura-se Juízo!",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["placagolpe2"] = {
        ["Index"] = "placagolpe2",
        ["Name"] = "Plaquinha Cai no Golpe!",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["placagolpe"] = {
        ["Index"] = "placagolpe",
        ["Name"] = "Plaquinha Golpe!",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["coolercarnaval"] = {
        ["Index"] = "coolercarnaval",
        ["Name"] = "Cooler da Folia",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["tree25"] = {
        ["Index"] = "tree25",
        ["Name"] = "Árvore de Natal",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["camaleao"] = {
        ["Index"] = "camaleao",
        ["Name"] = "Pintura Camaleão",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 500,
    },
    ["ovodepascoa"] = {
        ["Index"] = "ovodepascoa",
        ["Name"] = "Ovo de Páscoa",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["teddybear"] = {
        ["Index"] = "teddybear",
        ["Name"] = "Ursinho de Pelúcia",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["girls_pinkbe"] = {
        ["Index"] = "girls_pinkbe",
        ["Name"] = "Colecionável Urso",
        ["Description"] = "Um urso colecionável da coleção Girls.",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"] = 425,
    },
    ["pet_monkey"] = { ["Index"] = "pet_monkey", ["Name"] = "Macaco", ["Description"] = "Um macaco colecionável da coleção Pets.", ["Type"] = "Usável", ["Block"] = true, ["BlockChest"] = true, ["Weight"] = 0.00, ["Class"] = "Utilitarios", ["Economy"] = 425 },
    ["pet_cat_spotted"] = { ["Index"] = "pet_cat_spotted", ["Name"] = "Gato Manchado", ["Description"] = "Um gato manchado colecionável da coleção Pets.", ["Type"] = "Usável", ["Block"] = true, ["BlockChest"] = true, ["Weight"] = 0.00, ["Class"] = "Utilitarios", ["Economy"] = 425 },
    ["pet_cat_white"] = { ["Index"] = "pet_cat_white", ["Name"] = "Gato Branco", ["Description"] = "Um gato branco colecionável da coleção Pets.", ["Type"] = "Usável", ["Block"] = true, ["BlockChest"] = true, ["Weight"] = 0.00, ["Class"] = "Utilitarios", ["Economy"] = 425 },
    ["pet_cat_orange"] = { ["Index"] = "pet_cat_orange", ["Name"] = "Gato Laranja", ["Description"] = "Um gato laranja colecionável da coleção Pets.", ["Type"] = "Usável", ["Block"] = true, ["BlockChest"] = true, ["Weight"] = 0.00, ["Class"] = "Utilitarios", ["Economy"] = 425 },
    ["pet_butterfly_pink"] = { ["Index"] = "pet_butterfly_pink", ["Name"] = "Borboleta Rosa", ["Description"] = "Uma borboleta rosa colecionável da coleção Pets.", ["Type"] = "Usável", ["Block"] = true, ["BlockChest"] = true, ["Weight"] = 0.00, ["Class"] = "Utilitarios", ["Economy"] = 425 },
    ["pet_butterfly_blue"] = { ["Index"] = "pet_butterfly_blue", ["Name"] = "Borboleta Azul", ["Description"] = "Uma borboleta azul colecionável da coleção Pets.", ["Type"] = "Usável", ["Block"] = true, ["BlockChest"] = true, ["Weight"] = 0.00, ["Class"] = "Utilitarios", ["Economy"] = 425 },
    ["pet_butterfly_orange"] = { ["Index"] = "pet_butterfly_orange", ["Name"] = "Borboleta Laranja", ["Description"] = "Uma borboleta laranja colecionável da coleção Pets.", ["Type"] = "Usável", ["Block"] = true, ["BlockChest"] = true, ["Weight"] = 0.00, ["Class"] = "Utilitarios", ["Economy"] = 425 },
    ["pet_crow"] = { ["Index"] = "pet_crow", ["Name"] = "Corvo", ["Description"] = "Um corvo colecionável da coleção Pets.", ["Type"] = "Usável", ["Block"] = true, ["BlockChest"] = true, ["Weight"] = 0.00, ["Class"] = "Utilitarios", ["Economy"] = 425 },
    ["pet_labrador"] = { ["Index"] = "pet_labrador", ["Name"] = "Labrador", ["Description"] = "Um labrador colecionável da coleção Pets.", ["Type"] = "Usável", ["Block"] = true, ["BlockChest"] = true, ["Weight"] = 0.00, ["Class"] = "Utilitarios", ["Economy"] = 425 },
    ["pet_pinscher"] = { ["Index"] = "pet_pinscher", ["Name"] = "Pinscher", ["Description"] = "Um pinscher colecionável da coleção Pets.", ["Type"] = "Usável", ["Block"] = true, ["BlockChest"] = true, ["Weight"] = 0.00, ["Class"] = "Utilitarios", ["Economy"] = 425 },
    ["pet_seal"] = { ["Index"] = "pet_seal", ["Name"] = "Foca", ["Description"] = "Uma foca colecionável da coleção Pets.", ["Type"] = "Usável", ["Block"] = true, ["BlockChest"] = true, ["Weight"] = 0.00, ["Class"] = "Utilitarios", ["Economy"] = 425 },
    ["pet_chicken"] = { ["Index"] = "pet_chicken", ["Name"] = "Galinha", ["Description"] = "Uma galinha colecionável da coleção Pets.", ["Type"] = "Usável", ["Block"] = true, ["BlockChest"] = true, ["Weight"] = 0.00, ["Class"] = "Utilitarios", ["Economy"] = 425 },
    ["pet_sloth"] = { ["Index"] = "pet_sloth", ["Name"] = "Preguiça", ["Description"] = "Uma preguiça colecionável da coleção Pets.", ["Type"] = "Usável", ["Block"] = true, ["BlockChest"] = true, ["Weight"] = 0.00, ["Class"] = "Utilitarios", ["Economy"] = 425 },
    ["pet_spider"] = { ["Index"] = "pet_spider", ["Name"] = "Aranha", ["Description"] = "Uma aranha de Halloween colecionável da coleção Pets.", ["Type"] = "Usável", ["Block"] = true, ["BlockChest"] = true, ["Weight"] = 0.00, ["Class"] = "Utilitarios", ["Economy"] = 425 },
    ["pet_rat_brown"] = { ["Index"] = "pet_rat_brown", ["Name"] = "Rato Marrom", ["Description"] = "Um rato marrom colecionável da coleção Pets.", ["Type"] = "Usável", ["Block"] = true, ["BlockChest"] = true, ["Weight"] = 0.00, ["Class"] = "Utilitarios", ["Economy"] = 425 },
    ["pet_rat_white"] = { ["Index"] = "pet_rat_white", ["Name"] = "Rato Branco", ["Description"] = "Um rato branco colecionável da coleção Pets.", ["Type"] = "Usável", ["Block"] = true, ["BlockChest"] = true, ["Weight"] = 0.00, ["Class"] = "Utilitarios", ["Economy"] = 425 },
    ["pet_rat_black"] = { ["Index"] = "pet_rat_black", ["Name"] = "Rato Preto", ["Description"] = "Um rato preto colecionável da coleção Pets.", ["Type"] = "Usável", ["Block"] = true, ["BlockChest"] = true, ["Weight"] = 0.00, ["Class"] = "Utilitarios", ["Economy"] = 425 },
    ["pet_eagle"] = { ["Index"] = "pet_eagle", ["Name"] = "Águia", ["Description"] = "Uma águia colecionável da coleção Pets.", ["Type"] = "Usável", ["Block"] = true, ["BlockChest"] = true, ["Weight"] = 0.00, ["Class"] = "Utilitarios", ["Economy"] = 425 },
    ["pet_owl"] = { ["Index"] = "pet_owl", ["Name"] = "Coruja", ["Description"] = "Uma coruja colecionável da coleção Pets.", ["Type"] = "Usável", ["Block"] = true, ["BlockChest"] = true, ["Weight"] = 0.00, ["Class"] = "Utilitarios", ["Economy"] = 425 },
    ["icedout_grillsred"] = {
        ["Index"] = "icedout_grillsred",
        ["Name"] = "Grills Red",
        ["Description"] = "Um grill colecionável da coleção Iced Out.",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"] = 425,
    },
    ["icedout_grillssilver"] = {
        ["Index"] = "icedout_grillssilver",
        ["Name"] = "Grills Silver",
        ["Description"] = "Um grill colecionável da coleção Iced Out.",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"] = 425,
    },
    ["icedout_grillsgold"] = {
        ["Index"] = "icedout_grillsgold",
        ["Name"] = "Grills Gold",
        ["Description"] = "Um grill colecionável da coleção Iced Out.",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"] = 425,
    },
    ["icedout_grillsgreen"] = {
        ["Index"] = "icedout_grillsgreen",
        ["Name"] = "Grills Green",
        ["Description"] = "Um grill colecionável da coleção Iced Out.",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"] = 425,
    },
    ["icedout_grillsblue"] = {
        ["Index"] = "icedout_grillsblue",
        ["Name"] = "Grills Blue",
        ["Description"] = "Um grill colecionável da coleção Iced Out.",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"] = 425,
    },
    ["girls_pinkcat"] = {
        ["Index"] = "girls_pinkcat",
        ["Name"] = "Bolsa Gatinha Glamourosa",
        ["Description"] = "Uma bolsa colecionável da coleção Girls.",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"] = 425,
    },
    ["girls_doglaco"] = {
        ["Index"] = "girls_doglaco",
        ["Name"] = "Bolsa Cachorrinho com Laço",
        ["Description"] = "Uma bolsa colecionável da coleção Girls.",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"] = 425,
    },
    ["girls_dogoculos"] = {
        ["Index"] = "girls_dogoculos",
        ["Name"] = "Bolsa Cachorrinho Estiloso",
        ["Description"] = "Uma bolsa colecionável da coleção Girls.",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"] = 425,
    },
    ["balloon"] = {
        ["Index"] = "balloon",
        ["Name"] = "Balão de Ano Novo",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["bananacat"] = {
        ["Index"] = "bananacat",
        ["Name"] = "Banana Cat",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["partyhat"] = {
        ["Index"] = "partyhat",
        ["Name"] = "Chapéu de Festa",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["cupidheart"] = {
        ["Index"] = "cupidheart",
        ["Name"] = "Coração do Cupido",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["loveletter"] = {
        ["Index"] = "loveletter",
        ["Name"] = "Carta de Amor",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["cupidarrow"] = {
        ["Index"] = "cupidarrow",
        ["Name"] = "Flecha de Coração",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["cupid"] = {
        ["Index"] = "cupid",
        ["Name"] = "Anjo no Ombro",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["balaopascoam"] = {
        ["Index"] = "balaopascoam",
        ["Name"] = "Balão de Coelhinho Masculino",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["balaopascoaf"] = {
        ["Index"] = "balaopascoaf",
        ["Name"] = "Balão de Coelhinho Feminino",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["mochilacenoura"] = {
        ["Index"] = "mochilacenoura",
        ["Name"] = "Mochila de Cenoura",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["mochilacoelhof"] = {
        ["Index"] = "mochilacoelhof",
        ["Name"] = "Mochila de Coelho Feminino",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["mochilacoelhom"] = {
        ["Index"] = "mochilacoelhom",
        ["Name"] = "Mochila de Coelho Masculino",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["cestapascoa"] = {
        ["Index"] = "cestapascoa",
        ["Name"] = "Cesta de Ovos de Páscoa",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["coelhinhof"] = {
        ["Index"] = "coelhinhof",
        ["Name"] = "Pet Coelhinho de Páscoa Feminino",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["coelhinhom"] = {
        ["Index"] = "coelhinhom",
        ["Name"] = "Pet Coelhinho de Páscoa Masculino",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["pintinhopascoa"] = {
        ["Index"] = "pintinhopascoa",
        ["Name"] = "Pintinho no Ovo de Páscoa",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["peluciacenoura"] = {
        ["Index"] = "peluciacenoura",
        ["Name"] = "Pelúcia Cenoura Surpresa",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["faixapascoa"] = {
        ["Index"] = "faixapascoa",
        ["Name"] = "Faixa de Evento Páscoa",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["orelhapascoaf"] = {
        ["Index"] = "orelhapascoaf",
        ["Name"] = "Tiara de Orelhas de Páscoa Feminino",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["orelhapascoam"] = {
        ["Index"] = "orelhapascoam",
        ["Name"] = "Tiara de Orelhas de Páscoa Masculino",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["ovodecoradopascoa"] = {
        ["Index"] = "ovodecoradopascoa",
        ["Name"] = "Ovo Gigante Decorado Páscoa",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["ovodouradopascoa"] = {
        ["Index"] = "ovodouradopascoa",
        ["Name"] = "Ovo Gigante Dourado de Páscoa",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["pirulitopascoa"] = {
        ["Index"] = "pirulitopascoa",
        ["Name"] = "Pirulito Páscoa",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["freezefigure"] = {
        ["Index"] = "freezefigure",
        ["Name"] = "Miniatura SubZ",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["flamefigure"] = {
        ["Index"] = "flamefigure",
        ["Name"] = "Miniatura Skorpy",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["windfigure"] = {
        ["Index"] = "windfigure",
        ["Name"] = "Miniatura Kynara",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["lightningfigure"] = {
        ["Index"] = "lightningfigure",
        ["Name"] = "Miniatura Raidon",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["flamemask"] = {
        ["Index"] = "flamemask",
        ["Name"] = "Máscara Skorpy",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["stormhat"] = {
        ["Index"] = "stormhat",
        ["Name"] = "Chapéu do Raidon",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["freezemask"] = {
        ["Index"] = "freezemask",
        ["Name"] = "Máscara SubZ",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["windfans"] = {
        ["Index"] = "windfans",
        ["Name"] = "Leque cortante da Kynara",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["romanticrose"] = {
        ["Index"] = "romanticrose",
        ["Name"] = "Rosa Romântica",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["cottoncandy"] = {
        ["Index"] = "cottoncandy",
        ["Name"] = "Algodão Doce de Coração",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["bouquet"] = {
        ["Index"] = "bouquet",
        ["Name"] = "Buquê de Flores",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["goldstar"] = {
        ["Index"] = "goldstar",
        ["Name"] = "Estrela Dourada",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["sparkle"] = {
        ["Index"] = "sparkle",
        ["Name"] = "Faísca Festiva",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["crown"] = {
        ["Index"] = "crown",
        ["Name"] = "Coroa",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["champagne"] = {
        ["Index"] = "champagne",
        ["Name"] = "Garrafa de Champanhe",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["greenbeer"] = {
        ["Index"] = "greenbeer",
        ["Name"] = "Cerveja Verde",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"] = 425,
    },
    ["fichacassino"] = {
        ["Index"] = "fichacassino",
        ["Name"] = "Ficha de Cassino Nº 7",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["leprechaun"] = {
        ["Index"] = "leprechaun",
        ["Name"] = "Mascote Leprechaun",
        ["Economy"]= 500,
    },
    ["maletadinheiro"] = {
        ["Index"] = "maletadinheiro",
        ["Name"] = "Maleta de Dinheiro",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["patrickhat"] = {
        ["Index"] = "patrickhat",
        ["Name"] = "Chapéu de St. Patrick",
        ["Economy"]= 500,
    },
    ["moneygun"] = {
        ["Index"] = "moneygun",
        ["Name"] = "Gold Moneygun",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["clover"] = {
        ["Index"] = "clover",
        ["Name"] = "Trevo de Quatro Folhas",
        ["Economy"]= 500,
    },
    ["dados"] = {
        ["Index"] = "dados",
        ["Name"] = "Dados de Cassino",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["potofgold"] = {
        ["Index"] = "potofgold",
        ["Name"] = "Pote de Ouro",
        ["Economy"]= 500,
    },
    ["baralho"] = {
        ["Index"] = "baralho",
        ["Name"] = "Cartas de Baralho",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["midnightcarblue"] = {
        ["Index"] = "midnightcarblue",
        ["Name"] = "Miniatura Midnight Azul",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["midnightcarblack"] = {
        ["Index"] = "midnightcarblack",
        ["Name"] = "Miniatura Midnight Preta",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["flagmidnight"] = {
        ["Index"] = "flagmidnight",
        ["Name"] = "Bandeira Midnight",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["midnightcrown"] = {
        ["Index"] = "midnightcrown",
        ["Name"] = "Coroa Midnight",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["worldcup_goldenball2"] = {
        ["Index"] = "worldcup_goldenball2",
        ["Name"] = "Bola de Ouro",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["worldcup_flagarabia"] = {
        ["Index"] = "worldcup_flagarabia",
        ["Name"] = "Bandeira Arábia Saudita",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["worldcup_flagbrasil"] = {
        ["Index"] = "worldcup_flagbrasil",
        ["Name"] = "Bandeira Brasil",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["worldcup_flagespanha"] = {
        ["Index"] = "worldcup_flagespanha",
        ["Name"] = "Bandeira Espanha",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["worldcup_flaginglaterra"] = {
        ["Index"] = "worldcup_flaginglaterra",
        ["Name"] = "Bandeira Inglaterra",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["worldcup_flagportugal"] = {
        ["Index"] = "worldcup_flagportugal",
        ["Name"] = "Bandeira Portugal",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["cuptrophy_brasil"] = {
        ["Index"] = "cuptrophy_brasil",
        ["Name"] = "Taça do Hexa",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["cuptrophy_portugal"] = {
        ["Index"] = "cuptrophy_portugal",
        ["Name"] = "Troféu do Campeão",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["cuptrophy_saudiarabia"] = {
        ["Index"] = "cuptrophy_saudiarabia",
        ["Name"] = "Troféu do Campeão",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["cuptrophy_espana"] = {
        ["Index"] = "cuptrophy_espana",
        ["Name"] = "Troféu do Campeão",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["cuptrophy_england"] = {
        ["Index"] = "cuptrophy_england",
        ["Name"] = "Troféu do Campeão",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["cupmascot_brasil"] = {
        ["Index"] = "cupmascot_brasil",
        ["Name"] = "Mascote Canaro",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["cupmascot_portuga"] = {
        ["Index"] = "cupmascot_portuga",
        ["Name"] = "Mascote Galo",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["cupmascot_saudiarabia"] = {
        ["Index"] = "cupmascot_saudiarabia",
        ["Name"] = "Mascote Águia",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["cupmascot_espana"] = {
        ["Index"] = "cupmascot_espana",
        ["Name"] = "Mascote Touro",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["cupmascot_england"] = {
        ["Index"] = "cupmascot_england",
        ["Name"] = "Mascote Leão",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["playtime_cowgirl"] = {
        ["Index"] = "playtime_cowgirl",
        ["Name"] = "Cowgirl",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["playtime_cowboy"] = {
        ["Index"] = "playtime_cowboy",
        ["Name"] = "Cowboy",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["playtime_astronaut"] = {
        ["Index"] = "playtime_astronaut",
        ["Name"] = "Astronauta",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["playtime_dinosaur"] = {
        ["Index"] = "playtime_dinosaur",
        ["Name"] = "Dinossauro",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["nobrakes_dronegt"] = {
        ["Index"] = "nobrakes_dronegt",
        ["Name"] = "Drone de corrida",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["nobrakes_helmetgt"] = {
        ["Index"] = "nobrakes_helmetgt",
        ["Name"] = "Capacete Animado",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["nobrakes_glassesgt"] = {
        ["Index"] = "nobrakes_glassesgt",
        ["Name"] = "Óculos Animado",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["nobrakes_shoesgt"] = {
        ["Index"] = "nobrakes_shoesgt",
        ["Name"] = "Sapato Temático",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["halloween26_ghostboo"] = {
        ["Index"] = "halloween26_ghostboo",
        ["Name"] = "Fantasma Boo!",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"] = 425,
    },
    ["halloween26_wingsshadow"] = {
        ["Index"] = "halloween26_wingsshadow",
        ["Name"] = "Asas Sombrias",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"] = 425,
    },
    ["halloween26_batcrown"] = {
        ["Index"] = "halloween26_batcrown",
        ["Name"] = "Coroa de Morcegos",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"] = 425,
    },
    ["bigboss_cigar"] = {
        ["Index"] = "bigboss_cigar",
        ["Name"] = "Charuto",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"] = 425,
    },
    ["bigboss_kitflapper"] = {
        ["Index"] = "bigboss_kitflapper",
        ["Name"] = "Tiara Flapper e Cigarrete",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"] = 425,
    },
    ["bigboss_cane"] = {
        ["Index"] = "bigboss_cane",
        ["Name"] = "Bengala Dourada",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"] = 425,
    },
    ["bigboss_coin"] = {
        ["Index"] = "bigboss_coin",
        ["Name"] = "Cara ou Coroa?",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
        ["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"] = 425,
    },
    ["irishflag"] = {
        ["Index"] = "irishflag",
        ["Name"] = "Bandeira Irlandesa",
        ["Economy"]= 500,
    },
    ["taçadados"] = {
        ["Index"] = "taçadados",
        ["Name"] = "Taça de Dados",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"] = 500,
    },
    ["maletafichas"] = {
        ["Index"] = "maletafichas",
        ["Name"] = "Maleta de Fichas de Cassino",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 500,
    },
    ["roleta"] = {
        ["Index"] = "roleta",
        ["Name"] = "Roleta de Cassino",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 500,
    },
    ["flag"] = {
        ["Index"] = "flag",
        ["Name"] = "Bandeira",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["trophygold"] = {
        ["Index"] = "trophygold",
        ["Name"] = "Troféu de Ouro",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["trophybronze"] = {
        ["Index"] = "trophybronze",
        ["Name"] = "Troféu de Bronze",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["trophysilver"] = {
        ["Index"] = "trophysilver",
        ["Name"] = "Troféu de Prata",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["steeringwheel"] = {
        ["Index"] = "steeringwheel",
        ["Name"] = "Volante",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["nitro"] = {
        ["Index"] = "nitro",
        ["Name"] = "Nitro",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["lobinho"] = {
        ["Index"    ] = "lobinho",
        ["Name"     ] = "Lobinho",
        ["Type"     ] = "Usável",
        ["Block"    ] = true,
        ["Weight"   ] = 0.00,
        ["Class"    ] = "Utilitarios",
        ["Economy"  ] = 425,
    },
    ["dragao"] = {
        ["Index"] = "dragao",
        ["Name"] = "Dragao",
        ["Description"] = "Colecionável exclusivo do VIP Pé Na Areia. Uma prancha estilizada que simboliza liberdade, estilo de vida praiano e ostentação única.",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },
    ["lobinho"] = {
        ["Index"] = "lobinho",
        ["Name"] = "Lobinho",
        ["Description"] = "Colecionável exclusivo do VIP Pé Na Areia. Uma prancha estilizada que simboliza liberdade, estilo de vida praiano e ostentação única.",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.00,
        ["Class"] = "Utilitarios",
        ["Economy"]= 425,
    },

    -- 🎃 ITENS DO HALLOWEEN 🎃
    
    -- 🌑 Ultra Raro
    ["peluciamaonombo"] = {
        ["Index"] = "peluciamaonombo",
        ["Name"] = "Pelúcia – Mão no Ombro",
        ["Description"] = "Item colecionável ultra raro do Halloween. Uma pelúcia misteriosa que traz sorte.",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.0,
        ["Class"] = "Halloween",
        ["Economy"] = 0
    },

    -- 🧪 Poções Boas
    ["pocaovitalidade"] = {
        ["Index"] = "pocaovitalidade",
        ["Name"] = "Poção da Vitalidade",
        ["Description"] = "Uma poção mágica que restaura completamente sua energia vital.",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.0,
        ["Class"] = "Halloween",
        ["Economy"] = 0
    },

    ["pocaoguardiao"] = {
        ["Index"] = "pocaoguardiao",
        ["Name"] = "Poção do Guardião",
        ["Description"] = "Poção encantada que fortalece sua proteção contra danos.",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.0,
        ["Class"] = "Halloween",
        ["Economy"] = 0
    },

    ["pocaoagilidade"] = {
        ["Index"] = "pocaoagilidade",
        ["Name"] = "Poção da Agilidade",
        ["Description"] = "Elixir que aumenta temporariamente sua velocidade e reflexos.",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.0,
        ["Class"] = "Halloween",
        ["Economy"] = 0
    },

    -- 🥴 Poções de Travessura
    ["pocaodesmaio"] = {
        ["Index"] = "pocaodesmaio",
        ["Name"] = "Poção do Desmaio",
        ["Description"] = "Poção perigosa que pode causar tontura e desorientação.",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.0,
        ["Class"] = "Halloween",
        ["Economy"] = 0
    },

    ["pocaopanico"] = {
        ["Index"] = "pocaopanico",
        ["Name"] = "Poção do Pânico",
        ["Description"] = "Elixir amaldiçoado que induz um estado de pânico incontrolável.",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.0,
        ["Class"] = "Halloween",
        ["Economy"] = 0
    },

    ["pocaoqueda"] = {
        ["Index"] = "pocaoqueda",
        ["Name"] = "Poção da Queda",
        ["Description"] = "Poção misteriosa que pode transportar você para lugares inesperados.",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.0,
        ["Class"] = "Halloween",
        ["Economy"] = 0
    },

    ["pocaogirolouco"] = {
        ["Index"] = "pocaogirolouco",
        ["Name"] = "Poção do Giro Louco",
        ["Description"] = "Bebida encantada que faz o mundo girar ao seu redor.",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.0,
        ["Class"] = "Halloween",
        ["Economy"] = 0
    },

    ["pocaomiopia"] = {
        ["Index"] = "pocaomiopia",
        ["Name"] = "Poção da Miopia",
        ["Description"] = "Poção que temporariamente afeta sua visão de forma peculiar.",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.0,
        ["Class"] = "Halloween",
        ["Economy"] = 0
    },

    ["pocaovozdoalem"] = {
        ["Index"] = "pocaovozdoalem",
        ["Name"] = "Poção da Voz do Além",
        ["Description"] = "Elixir sobrenatural que modifica sua voz de forma assombrada.",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.0,
        ["Class"] = "Halloween",
        ["Economy"] = 0
    },

    ["pocaocongelada"] = {
        ["Index"] = "pocaocongelada",
        ["Name"] = "Poção da Congelada",
        ["Description"] = "Poção gelada que pode paralisar temporariamente seus movimentos.",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.0,
        ["Class"] = "Halloween",
        ["Economy"] = 0
    },

    ["pocaoteleporte"] = {
        ["Index"] = "pocaoteleporte",
        ["Name"] = "Poção do Teleporte",
        ["Description"] = "Poção mágica que pode transportá-lo instantaneamente para locais aleatórios.",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.0,
        ["Class"] = "Halloween",
        ["Economy"] = 0
    },

    ["pocaopulo"] = {
        ["Index"] = "pocaopulo",
        ["Name"] = "Poção do Pulo",
        ["Description"] = "Poção mágica que pode fazer você pular mais alto.",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.0,
        ["Class"] = "Halloween",
        ["Economy"] = 0
    },

    ["pocaoabobora"] = {
        ["Index"] = "pocaoabobora",
        ["Name"] = "Poção da Abóbora",
        ["Description"] = "Poção mágica que pode fazer você ficar com uma abóbora em cima da cabeça.",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.0,
        ["Class"] = "Halloween",
        ["Economy"] = 0
    },

    -- -- 🍬 Itens Temáticos Comuns
    -- ["doceabobora"] = {
    --     ["Index"] = "doceabobora",
    --     ["Name"] = "Doce de Abóbora",
    --     ["Description"] = "Delicioso doce temático de Halloween feito com abóboras especiais.",
    --     ["Type"] = "Usável",
    --     ["Weight"] = 0.0,
    --     ["Class"] = "Halloween",
    --     ["Economy"] = 0
    -- },

    -- ["balaacida"] = {
    --     ["Index"] = "balaacida",
    --     ["Name"] = "Bala Ácida",
    --     ["Description"] = "Bala colorida e ácida que proporciona uma experiência visual única.",
    --     ["Type"] = "Usável",
    --     ["Weight"] = 0.0,
    --     ["Class"] = "Halloween",
    --     ["Economy"] = 0
    -- },

    -- ["cupcakesombrio"] = {
    --     ["Index"] = "cupcakesombrio",
    --     ["Name"] = "Cupcake Sombrio",
    --     ["Description"] = "Cupcake de Halloween com ingredientes que causam efeitos divertidos.",
    --     ["Type"] = "Usável",
    --     ["Weight"] = 0.0,
    --     ["Class"] = "Halloween",
    --     ["Economy"] = 0
    -- },

    -- ["pirulitocaveira"] = {
    --     ["Index"] = "pirulitocaveira",
    --     ["Name"] = "Pirulito de Caveira",
    --     ["Description"] = "Pirulito em formato de caveira que brilha de forma sobrenatural.",
    --     ["Type"] = "Usável",
    --     ["Weight"] = 0.0,
    --     ["Class"] = "Halloween",
    --     ["Economy"] = 0
    -- },

    -- ["chicleteassombrado"] = {
    --     ["Index"] = "chicleteassombrado",
    --     ["Name"] = "Chiclete Assombrado",
    --     ["Description"] = "Chiclete especial que modifica temporariamente sua voz.",
    --     ["Type"] = "Usável",
    --     ["Weight"] = 0.0,
    --     ["Class"] = "Halloween",
    --     ["Economy"] = 0
    -- },

    -- -- 🪙 Item Colecionável
    -- ["moedaabobora"] = {
    --     ["Index"] = "moedaabobora",
    --     ["Name"] = "Moeda de Abóbora",
    --     ["Description"] = "Moeda colecionável especial do evento de Halloween.",
    --     ["Type"] = "Usável",
    --     ["Weight"] = 0.0,
    --     ["Class"] = "Halloween",
    --     ["Economy"] = 0
    -- },

    ["skateboard"] = {
        ["Index"] = "skateboard",
        ["Name"] = "Skateboard",
        ["Description"] = "Um skate estiloso para você mostrar suas habilidades.",
        ["Type"] = "Usável",
        ["Block"] = true,
        ["BlockChest"] = true,
["Weight"] = 0.0,
        ["Class"] = "Utilitarios",
        ["Economy"] = 0
    },

    ['wallpaper1'] = {
        ["Index"] = "wallpaper1",
        ["Name"] = "Wallpaper Branco",
        ["Description"] = "Item para mudar a cor do papel de parede do penthouse.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 200000
    },

    ['wallpaper2'] = {
        ["Index"] = "wallpaper2",
        ["Name"] = "Wallpaper Vermelho",
        ["Description"] = "Item para mudar a cor do papel de parede do penthouse.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 200000
    },

    ['wallpaper3'] = {
        ["Index"] = "wallpaper3",
        ["Name"] = "Wallpaper Azul",
        ["Description"] = "Item para mudar a cor do papel de parede do penthouse.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 200000
    },

    ['wallpaper4'] = {
        ["Index"] = "wallpaper4",
        ["Name"] = "Wallpaper Laranja",
        ["Description"] = "Item para mudar a cor do papel de parede do penthouse.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 200000
    },

    ['wallpaper5'] = {
        ["Index"] = "wallpaper5",
        ["Name"] = "Wallpaper Amarelo",
        ["Description"] = "Item para mudar a cor do papel de parede do penthouse.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 200000
    },

    ['wallpaper6'] = {
        ["Index"] = "wallpaper6",
        ["Name"] = "Wallpaper Verde",
        ["Description"] = "Item para mudar a cor do papel de parede do penthouse.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 200000
    },

    ['wallpaper7'] = {
        ["Index"] = "wallpaper7",
        ["Name"] = "Wallpaper Rosa",
        ["Description"] = "Item para mudar a cor do papel de parede do penthouse.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 200000
    },

    ['wallpaper8'] = {
        ["Index"] = "wallpaper8",
        ["Name"] = "Wallpaper Turquesa",
        ["Description"] = "Item para mudar a cor do papel de parede do penthouse.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
       ["BlockChest"] = true,
 ["BlockChest"] = true,
        ["Economy"] = 200000
    },

    ['wallpaper9'] = {
        ["Index"] = "wallpaper9",
        ["Name"] = "Wallpaper Cinza",
        ["Description"] = "Item para mudar a cor do papel de parede do penthouse.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 200000
    },

    ['wallpaper10'] = {
        ["Index"] = "wallpaper10",
        ["Name"] = "Wallpaper Preto",
        ["Description"] = "Item para mudar a cor do papel de parede do penthouse.",
        ["Type"] = "Usável",
        ["Weight"] = 0.15,
        ["Class"] = "Premium",
        ["Block"] = true,
        ["BlockChest"] = true,
["Economy"] = 200000
    },
}
-----------------------------------------------------------------------------------------------------------------------------------------
--- Translate the item list to the specified language
---@param List table
---@param lang string
itemsTranslations = itemsTranslations or {}
function ItemListTranslate(List, lang)
    if not itemsTranslations or not lang or not itemsTranslations[lang] then return end
    if not itemsTranslations[lang] then
        print("Language not supported.")
        return
    end

    -- Iterate through each item in the List
    for index, item in pairs(List) do
        -- Create the display name and description keys
        local displayNameKey = itemsTranslations[lang][ ( 'item:%s.displayName' ):format( index ) ]
        local descriptionKey = itemsTranslations[lang][ ( 'item:%s.description' ):format( index ) ]

        -- if not displayNameKey or not descriptionKey then
        --     print( ( "Missing translation for item %s in language %s" ):format( index, lang ) )
        -- end

        List[index]["Name"] = displayNameKey or item["Name"]
        List[index]["Description"] = descriptionKey or item["Description"]
    end
end
CreateThread(function()
    Wait(250)
    ItemListTranslate(List, lang)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMBODY
-----------------------------------------------------------------------------------------------------------------------------------------
function itemBody(Item)
	local Split = splitString(Item,"-")
	local Item = Split[1]

	if List[Item] then
		return List[Item]
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMINDEX
-----------------------------------------------------------------------------------------------------------------------------------------
function itemIndex(Item)
	local Split = splitString(Item,"-")
	local Item = Split[1]

	if List[Item] and List[Item]["Index"] then
		return List[Item]["Index"]
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMNAME
-----------------------------------------------------------------------------------------------------------------------------------------
function itemName(Item)
	local Split = splitString(Item,"-")
	local Item = Split[1]

	if List[Item] and List[Item]["Name"] then
		return List[Item]["Name"]
	end

	return "Deletado"
end

exports('GetItemName', itemName)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMTYPE
-----------------------------------------------------------------------------------------------------------------------------------------
function itemType(Item)
	local Split = splitString(Item,"-")
	local Item = Split[1]

	if List[Item] and List[Item]["Type"] then
		return List[Item]["Type"]
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMCLASS
-----------------------------------------------------------------------------------------------------------------------------------------
function itemClass(Item)
	local Split = splitString(Item,"-")
	local Item = Split[1]

	if List[Item] and List[Item]["Class"] then
		return List[Item]["Class"]
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMAMMO
-----------------------------------------------------------------------------------------------------------------------------------------
--[[

    TODO: Feito essa table temporaria
    pois precisa melhorar o fluxo
    do inventario na parte do 
    Inventory.UseItem( ):1250

    -@TkzDev
]]

local IGNORE_AMMO_CHECK = { 
    [ 'WEAPON_STUNGUN' ] = true,
    [ 'WEAPON_BATTLEAXE_GRAVEYARD' ] = true,
    [ 'WEAPON_MACHETTE_RETROPIXEL_BLUE' ] = true,
    [ 'WEAPON_MACHETTE_RETROPIXEL_PURPLE' ] = true,
    [ 'WEAPON_MACHETTE_RETROPIXEL_RED' ] = true,
    [ 'WEAPON_MACHETTE_RETROPIXEL_WHITE' ] = true,
    [ 'WEAPON_KATANA_DRAGONREDRUSTIC' ] = true,
    [ 'WEAPON_BAT_KAWAI' ] = true,
    [ 'WEAPON_SWITCHBLADE_KAWAI' ] = true,
    [ 'WEAPON_KNIFE_MISTICDRAGON' ] = true,
    [ 'WEAPON_KARAMBIT_ZEUS' ] = true,
    [ 'WEAPON_BAT_ZEUS' ] = true,
    [ 'WEAPON_KNIFE_VORTEX' ] = true,
    [ 'WEAPON_SNOWBALL' ] = true,
    [ 'WEAPON_BAT' ] = true,
    [ 'WEAPON_NIGHTSTICK' ] = true,
    [ 'WEAPON_POOLCUE' ] = true,
    [ 'WEAPON_HATCHET' ] = true,
    [ 'WEAPON_KATANA'  ] = true,
    [ 'WEAPON_KATANA_CENOURA' ] = true,
    [ 'WEAPON_CENOURA' ] = true,
    [ 'WEAPON_KARAMBIT' ] = true,
    [ 'WEAPON_BATTLEAXE' ] = true,
    [ 'WEAPON_CROWBAR' ] = true,
    [ 'WEAPON_GOLFCLUB' ] = true,
    [ 'WEAPON_HAMMER' ] = true,
    [ 'WEAPON_MACHETE' ] = true,
    [ 'WEAPON_POOLCUE' ] = true,
    [ 'WEAPON_STONE_HATCHET' ] = true,
    [ 'WEAPON_WRENCH' ] = true,
    [ 'WEAPON_KNUCKLE' ] = true,
    [ 'WEAPON_FLASHLIGHT' ] = true, 
    [ 'WEAPON_NIGHTSTICK'] = true,
    [ 'WEAPON_PROXMINE' ] = true,
    [ 'WEAPON_CANDYCANE' ] = true,
}

function itemAmmo( itemIdWeird )
	local Split = splitString(itemIdWeird,"-")
	local itemId = Split[1]

    if IGNORE_AMMO_CHECK[ itemId ] then
        return itemId
    end

    local item = List[itemId]

    if not item then
        return false
    end

    -- Arremessáveis (WEAPON_SHOES, WEAPON_SNOWBALL...) não têm munição; callers tratam false como "sem munição".
    return item['Ammo'] or false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function itemVehicle(Item)
	local Split = splitString(Item,"-")
	local Item = Split[1]

	if List[Item] and List[Item]["Vehicle"] then
		return List[Item]["Vehicle"]
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMWEIGHT
-----------------------------------------------------------------------------------------------------------------------------------------
function itemWeight(Item)
	local Split = splitString(Item,"-")
	local Item = Split[1]

	if List[Item] and List[Item]["Weight"] then
		return List[Item]["Weight"]
	end

	return 0.0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMMAXAMOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
function itemMaxAmount(Item)
	local Split = splitString(Item,"-")
	local Item = Split[1]

	if List[Item] and List[Item]["Max"] then
		return List[Item]["Max"]
	end

	return nil
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMSCAPEAMOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
function itemScapeAmount(Item)
	local Split = splitString(Item,"-")
	local Item = Split[1]

	if List[Item] and List[Item]["Scape"] then
		return List[Item]["Scape"]
	end

	return nil
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMDESCRIPTION
-----------------------------------------------------------------------------------------------------------------------------------------
function itemDescription(Item)
	local Split = splitString(Item,"-")
	local Item = Split[1]

	if List[Item] and List[Item]["Description"] then
		return List[Item]["Description"]
	end

	return nil
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMDURABILITY
-----------------------------------------------------------------------------------------------------------------------------------------
function itemDurability(Item)
	local Split = splitString(Item,"-")

	if Split[3] then
		return tonumber(Split[3])
	end

	local baseItem = Split[1]
	if List[baseItem] and List[baseItem]["Durability"] then
		return List[baseItem]["Durability"]
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMCHARGES
-----------------------------------------------------------------------------------------------------------------------------------------
function itemCharges(Item)
	local Split = splitString(Item,"-")
	local Item = Split[1]

	if List[Item] and List[Item]["Charges"] then
		return List[Item]["Charges"]
	end

	return nil
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMECONOMY
-----------------------------------------------------------------------------------------------------------------------------------------
function itemEconomy(Item)
	local Split = splitString(Item,"-")
	local Item = Split[1]

	if List[Item] and List[Item]["Economy"] then
		return List[Item]["Economy"]
	end

	return nil
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMBLOCK
-----------------------------------------------------------------------------------------------------------------------------------------
function itemBlock(Item)
	local Split = splitString(Item,"-")
	local Item = Split[1]

	if List[Item] and List[Item]["Block"] then
		return List[Item]["Block"]
	end

	return nil
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMBLOCKREMOVE
-----------------------------------------------------------------------------------------------------------------------------------------
---@param item string
---@return boolean
function ItemBlockRemove(item)

    local baseItem = splitString(item, "-")[1]

    return List[baseItem] and List[baseItem]["BlockRemove"] == true or false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMBLOCKCHEST
-----------------------------------------------------------------------------------------------------------------------------------------
function itemBlockChest(Item)
	local Split = splitString(Item,"-")
	local Item = Split[1]

	if List[Item] and List[Item]["BlockChest"] then
		return List[Item]["BlockChest"]
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMREPAIR
-----------------------------------------------------------------------------------------------------------------------------------------
function itemRepair(Item)
	local Split = splitString(Item,"-")
	local Item = Split[1]

	if List[Item] and List[Item]["Repair"] then
		return List[Item]["Repair"]
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEM LIST
-----------------------------------------------------------------------------------------------------------------------------------------
function itemList()
    return List
end

InventoryHelpers = { }

function InventoryHelpers.ChestWeight(Data)
	local Weight = 0

	for _,v in pairs(Data) do
		if itemBody(v["item"]) then
			Weight = Weight + itemWeight(v["item"]) * v["amount"]
		end
	end

	return Weight
end
