-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
Whitelisted = GetConvar("Whitelist", "false")
if Whitelisted == "true" then
    Whitelisted = true
else
    Whitelisted = false
end
SpawnCoords = vec3(-28.08,-145.96,56.99)
cityName = GetConvar("cityName", "")
-----------------------------------------------------------------------------------------------------------------------------------------
-- ARENA (Itens recebidos ao entrar na arena)
-----------------------------------------------------------------------------------------------------------------------------------------
ArenaItens = {
    ["Pistol"] = {
        { ["WEAPON_COMBATPISTOL"] = 1 },
        { ["WEAPON_PISTOL_MK2"] = 1} ,
        { ["WEAPON_PISTOL_AMMO"] = 1000 }
    },
    ["DropKill"] = {
        { ["WEAPON_ASSAULTRIFLE_MK2"] = 1 },
        { ["WEAPON_SPECIALCARBINE_MK2"] = 1 },
        { ["WEAPON_PISTOL_MK2"] =  1 },
        { ["WEAPON_PISTOL_AMMO"] = 250 },
        { ["WEAPON_RIFLE_AMMO"] = 250 },
    },
    ["FFAPistola"] = {
        { ["WEAPON_PISTOL_MK2"] = 1 },
        { ["WEAPON_COMBATPISTOL"] = 1 },
        { ["WEAPON_PISTOL_AMMO"] = 500 }
    },
    ["event_pistola"] = {
        { ["WEAPON_PISTOL_MK2"] = 1 },
        { ["WEAPON_PISTOL_AMMO"] = 500 },
        { ["radio"] = 1 },
    },
    ["event_rifle"] = {
        { ["WEAPON_SPECIALCARBINE_MK2"] = 1 },
        { ["WEAPON_RIFLE_AMMO"] = 500 },
        { ["radio"] = 1 },
    },
    ["event_rifle_estrelinha"] = {
        { ["WEAPON_TIGOR"] = 1 },
        { ["WEAPON_RIFLE_AMMO"] = 500 },
        { ["radio"] = 1 },
    },
    ["FFAFuzil"] = {
        { ["WEAPON_ASSAULTRIFLE_MK2"] = 1 },
        { ["WEAPON_SPECIALCARBINE_MK2"] = 1 },
        { ["WEAPON_RIFLE_AMMO"] = 500 }
    },
    ["AimNPC"] = {
        { ["WEAPON_PISTOL_MK2"] = 1 },
        { ["WEAPON_PISTOL_AMMO"] = 1000 }
    },
    ["AimLabs"] = {
        { ["WEAPON_PISTOL_MK2"] = 1 },
        { ["WEAPON_PISTOL_AMMO"] = 1000 }
    },
    ["InvasaoFuzil"] = {
        { ["WEAPON_SPECIALCARBINE_MK2"] = 1 },
        { ["WEAPON_ASSAULTRIFLE_MK2"] = 1 },
        { ["WEAPON_RIFLE_AMMO"] = 15000 },
        { ["cocaine"] = 20 },
        { ["bandage"] = 20 },
        { ["joint"] = 20 },
    },
    ["WorldPVP"] = {
        { ["WEAPON_SPECIALCARBINE_MK2"] = 1 },
        { ["WEAPON_ASSAULTRIFLE_MK2"] = 1 },
        { ["WEAPON_PISTOL_MK2"] = 1 },
        { ["WEAPON_COMBATPISTOL"] = 1 },
        { ["WEAPON_RIFLE_AMMO"] = 15000 },
        { ["WEAPON_PISTOL_AMMO"] = 15000 },
        { ["cocaine"] = 100 },
        { ["bandage"] = 100 },
        { ["joint"] = 100 },
    },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHARACTERITENS (Itens recebidos ao criar o personagem)
-----------------------------------------------------------------------------------------------------------------------------------------
CharacterItens = {
    {"cellphone",1},
    {"dollars",25000},
    {"creator",2},
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUPBLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
GroupBlips = {
	["Paramedic"] = true,
    ["Policia"] = true,
    ["Tatica"] = true,
    ["Civil"] = true,
    ["Exercito"] = true,
    ["Prf"] = true,
    ["Militar"] = true,
    ["Federal"] = true
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLIENTSTATE
-----------------------------------------------------------------------------------------------------------------------------------------
ClientState = {
    ["Admin"] = true,
    ["Developers"] = true,
    ["Afiliado"] = true,
    ["Policia"] = true,
    ["Bombeiros"] = true,
    ["Mechanic"] = true,
    ["Paramedic"] = true,
    ["Barragem"] = true,
    ["Gang9"] = true,
    ["Banzas"] = true,
    ["Dixavas"] = true,
    ["Gang4"] = true,
    ["Sindicato"] = true,
    ["Vagos"] = true,
    ["Umbrella"] = true,
    ["Metgala"] = true,
    ["Afetados"] = true,
    ["Pinkmans"] = true,
    ["Hollywood"] = true,
    ["Azuis"] = true,
    ["Vermelhos"] = true,
    ["Amarelos"] = true,
    ["AlcateiaHsT"] = true,
    ["Verdes"] = true,
    ["Roxos"] = true,
    ["LosAztecas"] = true,
    ["Laranjas"] = true,
    ["Brancos"] = true,
    ["Marrons"] = true,
    ["Cinzas"] = true,
    ["Rosas"] = true,
    ["Ballas"] = true,
    ["Bellagio"] = true,
    ["Lavajato"] = true,
    ["Putaria"] = true,
    ["Tequilas"] = true,
    ["Arcade"] = true,
    ["Callisto"] = true,
    ["Bahamas"] = true,
    ["Palazzo"] = true,
    ["Luxor"] = true,
    ["Groove"] = true,
    ["TopGear"] = true,
    ["FerroVelho"] = true,
    ["Morro-do-Sacola"] = true,
    ["CarClube"] = true,
    ["Virtude"] = true,
    ["Big"] = true,
    ["Kraken"] = true,
    ["Redline"] = true,
    ["Bennys"] = true,
    ["DriftKing"] = true,
    ["Forza"] = true,
    ["Overdrive"] = true,
    ["Anonymous"] = true,
    ["Gang2"] = true,
    ["Tropadu7"] = true,
    ["Tribo"] = true,
    ["Gang6"] = true,
    ["Outlaws"] = true,
    ["SonsofAnarchy"] = true,
    ["Fazendinha"] = true,
    ["Gang3"] = true,
    ["Gang8"] = true,
    ["Gang7"] = true,
    ["Gang5"] = true,
    ["Warlocks"] = true,
    ["Gang1"] = true,
    ["Mercenarios"] = true,
    ["LosTugas"] = true,
    ["Caribe"] = true,
    ["Japao"] = true,
    ["Inglaterra"] = true,
    ["Noxus"] = true,
    ["LaMafia"] = true,
    ["Gringa"] = true,
    ["Franca"] = true,
    ["Italia"] = true,
    ["Russia"] = true,
    ["Israel"] = true,
    ["Jamakeikos"] = true,
    ["Playboy"] = true,
    ["Mexico"] = true,
    ["China"] = true,
    ["Tatica"] = true,
    ["Civil"] = true,
    ["Exercito"] = true,
    ["Militar"] = true,
    ["Federal"] = true,
    ["Prf"] = true,
    ["gestaoinfluencer"] = true,
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- INITIAL
-----------------------------------------------------------------------------------------------------------------------------------------
Initial = { -- preset inicial do personagem
    [1] = {
        ["skinshop"] = {
            [0] = { -- masculino
                ["pants"] = { item = 4, texture = 2 }, -- calças
                ["arms"] = { item = 11, texture = 0 }, -- mãos
                ["tshirt"] = { item = 15, texture = 0 }, -- blusa
                ["torso"] = { item = 22, texture = 0 }, -- jaqueta
                ["vest"] = { item = 0, texture = 0 }, -- colete
                ["shoes"] = { item = 12, texture = 6 }, -- sapatos
                ["mask"] = { item = 0, texture = 0 }, -- mascara
                ["backpack"] = { item = 0, texture = 0 }, -- mochila
                ["hat"] = { item = -1, texture = 0 },
                ["glass"] = { item = 0, texture = 0 },
                ["ear"] = { item = -1, texture = 0 },
                ["watch"] = { item = -1, texture = 0 },
                ["bracelet"] = { item = -1, texture = 0 },
                ["accessory"] = { item = 0, texture = 0 },
                ["decals"] = { item = 0, texture = 0 }
            },
            [1] = { -- feminino
                ["pants"] = { item = 14, texture = 6 }, -- calças
                ["arms"] = { item = 14, texture = 0 }, -- mãos
                ["tshirt"] = { item = 9, texture = 0 }, -- blusa
                ["torso"] = { item = 23, texture = 0 }, -- jaqueta
                ["vest"] = { item = 0, texture = 0 }, -- colete
                ["shoes"] = { item = 3, texture = 0 }, -- sapatos
                ["mask"] = { item = 0, texture = 0 }, -- mascara
                ["backpack"] = { item = 0, texture = 0 }, -- mochila
                ["hat"] = { item = -1, texture = 0 }, -- chapeu
                ["glass"] = { item = 0, texture = 0 }, 
                ["ear"] = { item = -1, texture = 0 },
                ["watch"] = { item = -1, texture = 0 },
                ["bracelet"] = { item = -1, texture = 0 },
                ["accessory"] = { item = 0, texture = 0 },
                ["decals"] = { item = 0, texture = 0 }
            }
        },
        ["barbershop"] = {
            [0] = { 0,0,0.65,2,12,0,-1,4,-1,45,29,29,0,0,0,0,0,0,30,0.99,0,1,0.88,0,-1,0,0,-1,0.84,0.72,0.46,0,0,0.3,-0.3,0,-0.58,-0.72,-0.52,0.21,0.37,0.79,0.6,0.71,0.43,-0.7,0 },
            [1] = { 3,6,1,0,12,0,-1,-1,-1,74,0,4,0,0,2,0,0,0,2,0.99,26,0,0,0,0,0,0,-1,-1,-0.94,-0.31,0.24,0.25,-0.1,-0.79,-0.72,-1,-0.32,-0.61,-0.25,0,-1,0,-0.38,-0.65,-1,1,0,0,0 }
        }
    },
    [2] = {
        ["skinshop"] = {
            [0] = { -- masculino
                ["pants"] = { item = 4, texture = 2 }, -- calças
                ["arms"] = { item = 11, texture = 0 }, -- mãos
                ["tshirt"] = { item = 15, texture = 0 }, -- blusa
                ["torso"] = { item = 22, texture = 0 }, -- jaqueta
                ["vest"] = { item = 0, texture = 0 }, -- colete
                ["shoes"] = { item = 12, texture = 6 }, -- sapatos
                ["mask"] = { item = 0, texture = 0 }, -- mascara
                ["backpack"] = { item = 0, texture = 0 }, -- mochila
                ["hat"] = { item = -1, texture = 0 },
                ["glass"] = { item = 0, texture = 0 },
                ["ear"] = { item = -1, texture = 0 },
                ["watch"] = { item = -1, texture = 0 },
                ["bracelet"] = { item = -1, texture = 0 },
                ["accessory"] = { item = 0, texture = 0 },
                ["decals"] = { item = 0, texture = 0 }
            },
            [1] = { -- feminino
                ["pants"] = { item = 14, texture = 6 }, -- calças
                ["arms"] = { item = 14, texture = 0 }, -- mãos
                ["tshirt"] = { item = 9, texture = 0 }, -- blusa
                ["torso"] = { item = 23, texture = 0 }, -- jaqueta
                ["vest"] = { item = 0, texture = 0 }, -- colete
                ["shoes"] = { item = 3, texture = 0 }, -- sapatos
                ["mask"] = { item = 0, texture = 0 }, -- mascara
                ["backpack"] = { item = 0, texture = 0 }, -- mochila
                ["hat"] = { item = -1, texture = 0 }, -- chapeu
                ["glass"] = { item = 0, texture = 0 }, 
                ["ear"] = { item = -1, texture = 0 },
                ["watch"] = { item = -1, texture = 0 },
                ["bracelet"] = { item = -1, texture = 0 },
                ["accessory"] = { item = 0, texture = 0 },
                ["decals"] = { item = 0, texture = 0 }
            }
        },
        ["barbershop"] = {
            [0] = { 0,8,0.5,0,3,0,-1,4,-1,73,0,0,0,0,0,0,0,0,30,0.99,0,1,0.88,0,-1,0,0,-1,0.84,0.72,0.46,0,0,0.3,-0.3,0,-0.58,-0.72,-0.52,0.21,0.37,0.79,0.6,0.71,0.43,-0.7 },
            [1] = { 3,6,1,0,12,0,-1,-1,-1,74,0,4,0,0,2,0,0,0,2,0.99,26,0,0,0,0,0,0,-1,-1,-0.94,-0.31,0.24,0.25,-0.1,-0.79,-0.72,-1,-0.32,-0.61,-0.25,0,-1,0,-0.38,-0.65,-1,1,0,0,0 }
        }
    },
}
if cityName == "Maresia" or cityName == "Orizon" or cityName == "Liberty99" or cityName == "CidadeNobre" then
    Initial = {
        [1] = {
            ["skinshop"] = {
                [0] = { -- masculino
                    ["pants"] = { item = 4, texture = 2 }, -- calças
                    ["arms"] = { item = 11, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 15, texture = 0 }, -- blusa
                    ["torso"] = { item = 22, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 12, texture = 6 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 },
                    ["glass"] = { item = 0, texture = 0 },
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                },
                [1] = { -- feminino
                    ["pants"] = { item = 14, texture = 6 }, -- calças
                    ["arms"] = { item = 9, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 9, texture = 0 }, -- blusa
                    ["torso"] = { item = 23, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 3, texture = 0 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 }, -- chapeu
                    ["glass"] = { item = 0, texture = 0 }, 
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                }
            },
            ["barbershop"] = {
                [0] = { 0,0,0.65,2,12,0,-1,4,-1,45,29,29,0,0,0,0,0,0,30,0.99,0,1,0.88,0,-1,0,0,-1,0.84,0.72,0.46,0,0,0.3,-0.3,0,-0.58,-0.72,-0.52,0.21,0.37,0.79,0.6,0.71,0.43,-0.7,0 },
                [1] = { 3,6,1,0,12,0,-1,-1,-1,74,0,4,0,0,2,0,0,0,2,0.99,26,0,0,0,0,0,0,-1,-1,-0.94,-0.31,0.24,0.25,-0.1,-0.79,-0.72,-1,-0.32,-0.61,-0.25,0,-1,0,-0.38,-0.65,-1,1,0,0,0 }
            }
        },
        [2] = {
            ["skinshop"] = {
                [0] = { -- masculino
                    ["pants"] = { item = 4, texture = 2 }, -- calças
                    ["arms"] = { item = 11, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 15, texture = 0 }, -- blusa
                    ["torso"] = { item = 22, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 12, texture = 6 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 },
                    ["glass"] = { item = 0, texture = 0 },
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                },
                [1] = { -- feminino
                    ["pants"] = { item = 14, texture = 6 }, -- calças
                    ["arms"] = { item = 9, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 9, texture = 0 }, -- blusa
                    ["torso"] = { item = 23, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 3, texture = 0 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 }, -- chapeu
                    ["glass"] = { item = 0, texture = 0 }, 
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                }
            },
            ["barbershop"] = {
                [0] = { 0,8,0.5,0,3,0,-1,4,-1,73,0,0,0,0,0,0,0,0,30,0.99,0,1,0.88,0,-1,0,0,-1,0.84,0.72,0.46,0,0,0.3,-0.3,0,-0.58,-0.72,-0.52,0.21,0.37,0.79,0.6,0.71,0.43,-0.7 },
                [1] = { 3,6,1,0,12,0,-1,-1,-1,74,0,4,0,0,2,0,0,0,2,0.99,26,0,0,0,0,0,0,-1,-1,-0.94,-0.31,0.24,0.25,-0.1,-0.79,-0.72,-1,-0.32,-0.61,-0.25,0,-1,0,-0.38,-0.65,-1,1,0,0,0 }
            }
        },
    }
elseif cityName == "Santa" then
    Initial = {
        [1] = {
            ["skinshop"] = {
                [0] = { -- masculino
                    ["pants"] = { item = 4, texture = 2 }, -- calças
                    ["arms"] = { item = 11, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 15, texture = 0 }, -- blusa
                    ["torso"] = { item = 22, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 12, texture = 6 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 },
                    ["glass"] = { item = 0, texture = 0 },
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                },
                [1] = { -- feminino
                    ["pants"] = { item = 14, texture = 6 }, -- calças
                    ["arms"] = { item = 9, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 9, texture = 0 }, -- blusa
                    ["torso"] = { item = 23, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 3, texture = 0 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 }, -- chapeu
                    ["glass"] = { item = 0, texture = 0 }, 
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                }
            },
            ["barbershop"] = {
                [0] = { 0,0,0.65,2,12,0,-1,4,-1,45,29,29,0,0,0,0,0,0,30,0.99,0,1,0.88,0,-1,0,0,-1,0.84,0.72,0.46,0,0,0.3,-0.3,0,-0.58,-0.72,-0.52,0.21,0.37,0.79,0.6,0.71,0.43,-0.7,0 },
                [1] = { 3,6,1,0,12,0,-1,-1,-1,74,0,4,0,0,2,0,0,0,2,0.99,26,0,0,0,0,0,0,-1,-1,-0.94,-0.31,0.24,0.25,-0.1,-0.79,-0.72,-1,-0.32,-0.61,-0.25,0,-1,0,-0.38,-0.65,-1,1,0,0,0 }
            }
        },
        [2] = {
            ["skinshop"] = {
                [0] = { -- masculino
                    ["pants"] = { item = 4, texture = 2 }, -- calças
                    ["arms"] = { item = 11, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 15, texture = 0 }, -- blusa
                    ["torso"] = { item = 22, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 12, texture = 6 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 },
                    ["glass"] = { item = 0, texture = 0 },
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                },
                [1] = { -- feminino
                    ["pants"] = { item = 14, texture = 6 }, -- calças
                    ["arms"] = { item = 9, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 9, texture = 0 }, -- blusa
                    ["torso"] = { item = 23, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 3, texture = 0 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 }, -- chapeu
                    ["glass"] = { item = 0, texture = 0 }, 
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                }
            },
            ["barbershop"] = {
                [0] = { 0,8,0.5,0,3,0,-1,4,-1,73,0,0,0,0,0,0,0,0,30,0.99,0,1,0.88,0,-1,0,0,-1,0.84,0.72,0.46,0,0,0.3,-0.3,0,-0.58,-0.72,-0.52,0.21,0.37,0.79,0.6,0.71,0.43,-0.7 },
                [1] = { 3,6,1,0,12,0,-1,-1,-1,74,0,4,0,0,2,0,0,0,2,0.99,26,0,0,0,0,0,0,-1,-1,-0.94,-0.31,0.24,0.25,-0.1,-0.79,-0.72,-1,-0.32,-0.61,-0.25,0,-1,0,-0.38,-0.65,-1,1,0,0,0 }
            }
        },
    }
elseif cityName == "Kingdom" then
    Initial = {
        [1] = {
            ["skinshop"] = {
                [0] = { -- masculino
                    ["pants"] = { item = 4, texture = 2 }, -- calças
                    ["arms"] = { item = 11, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 15, texture = 0 }, -- blusa
                    ["torso"] = { item = 22, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 12, texture = 6 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 },
                    ["glass"] = { item = 0, texture = 0 },
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                },
                [1] = { -- feminino
                    ["pants"] = { item = 14, texture = 6 }, -- calças
                    ["arms"] = { item = 14, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 9, texture = 0 }, -- blusa
                    ["torso"] = { item = 23, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 3, texture = 0 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 }, -- chapeu
                    ["glass"] = { item = 0, texture = 0 }, 
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                }
            },
            ["barbershop"] = {
                [0] = { 0,0,0.65,2,12,0,-1,4,-1,45,29,29,0,0,0,0,0,0,30,0.99,0,1,0.88,0,-1,0,0,-1,0.84,0.72,0.46,0,0,0.3,-0.3,0,-0.58,-0.72,-0.52,0.21,0.37,0.79,0.6,0.71,0.43,-0.7,0 },
                [1] = { 3,6,1,0,12,0,-1,-1,-1,74,0,4,0,0,2,0,0,0,2,0.99,26,0,0,0,0,0,0,-1,-1,-0.94,-0.31,0.24,0.25,-0.1,-0.79,-0.72,-1,-0.32,-0.61,-0.25,0,-1,0,-0.38,-0.65,-1,1,0,0,0 }
            }
        },
        [2] = {
            ["skinshop"] = {
                [0] = { -- masculino
                    ["pants"] = { item = 4, texture = 2 }, -- calças
                    ["arms"] = { item = 11, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 15, texture = 0 }, -- blusa
                    ["torso"] = { item = 22, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 12, texture = 6 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 },
                    ["glass"] = { item = 0, texture = 0 },
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                },
                [1] = { -- feminino
                    ["pants"] = { item = 14, texture = 6 }, -- calças
                    ["arms"] = { item = 14, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 9, texture = 0 }, -- blusa
                    ["torso"] = { item = 23, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 3, texture = 0 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 }, -- chapeu
                    ["glass"] = { item = 0, texture = 0 }, 
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                }
            },
            ["barbershop"] = {
                [0] = { 0,8,0.5,0,3,0,-1,4,-1,73,0,0,0,0,0,0,0,0,30,0.99,0,1,0.88,0,-1,0,0,-1,0.84,0.72,0.46,0,0,0.3,-0.3,0,-0.58,-0.72,-0.52,0.21,0.37,0.79,0.6,0.71,0.43,-0.7 },
                [1] = { 3,6,1,0,12,0,-1,-1,-1,74,0,4,0,0,2,0,0,0,2,0.99,26,0,0,0,0,0,0,-1,-1,-0.94,-0.31,0.24,0.25,-0.1,-0.79,-0.72,-1,-0.32,-0.61,-0.25,0,-1,0,-0.38,-0.65,-1,1,0,0,0 }
            }
        },
    }
elseif cityName == "Imperium" then
    Initial = {
        [1] = {
            ["skinshop"] = {
                [0] = { -- masculino
                    ["pants"] = { item = 4, texture = 2 }, -- calças
                    ["arms"] = { item = 11, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 15, texture = 0 }, -- blusa
                    ["torso"] = { item = 22, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 12, texture = 6 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 },
                    ["glass"] = { item = 0, texture = 0 },
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                },
                [1] = { -- feminino
                    ["pants"] = { item = 14, texture = 6 }, -- calças
                    ["arms"] = { item = 14, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 9, texture = 0 }, -- blusa
                    ["torso"] = { item = 23, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 3, texture = 0 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 }, -- chapeu
                    ["glass"] = { item = 0, texture = 0 }, 
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                }
            },
            ["barbershop"] = {
                [0] = { 0,0,0.65,2,12,0,-1,4,-1,45,29,29,0,0,0,0,0,0,30,0.99,0,1,0.88,0,-1,0,0,-1,0.84,0.72,0.46,0,0,0.3,-0.3,0,-0.58,-0.72,-0.52,0.21,0.37,0.79,0.6,0.71,0.43,-0.7,0 },
                [1] = { 3,6,1,0,12,0,-1,-1,-1,74,0,4,0,0,2,0,0,0,2,0.99,26,0,0,0,0,0,0,-1,-1,-0.94,-0.31,0.24,0.25,-0.1,-0.79,-0.72,-1,-0.32,-0.61,-0.25,0,-1,0,-0.38,-0.65,-1,1,0,0,0 }
            }
        },
        [2] = {
            ["skinshop"] = {
                [0] = { -- masculino
                    ["pants"] = { item = 4, texture = 2 }, -- calças
                    ["arms"] = { item = 11, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 15, texture = 0 }, -- blusa
                    ["torso"] = { item = 22, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 12, texture = 6 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 },
                    ["glass"] = { item = 0, texture = 0 },
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                },
                [1] = { -- feminino
                    ["pants"] = { item = 14, texture = 6 }, -- calças
                    ["arms"] = { item = 14, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 9, texture = 0 }, -- blusa
                    ["torso"] = { item = 23, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 3, texture = 0 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 }, -- chapeu
                    ["glass"] = { item = 0, texture = 0 }, 
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                }
            },
            ["barbershop"] = {
                [0] = { 0,8,0.5,0,3,0,-1,4,-1,73,0,0,0,0,0,0,0,0,30,0.99,0,1,0.88,0,-1,0,0,-1,0.84,0.72,0.46,0,0,0.3,-0.3,0,-0.58,-0.72,-0.52,0.21,0.37,0.79,0.6,0.71,0.43,-0.7 },
                [1] = { 3,6,1,0,12,0,-1,-1,-1,74,0,4,0,0,2,0,0,0,2,0.99,26,0,0,0,0,0,0,-1,-1,-0.94,-0.31,0.24,0.25,-0.1,-0.79,-0.72,-1,-0.32,-0.61,-0.25,0,-1,0,-0.38,-0.65,-1,1,0,0,0 }
            }
        },
    }
elseif cityName == "GoatRP" then
    Initial = {
        [1] = {
            ["skinshop"] = {
                [0] = { -- masculino
                    ["pants"] = { item = 4, texture = 2 }, -- calças
                    ["arms"] = { item = 11, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 15, texture = 0 }, -- blusa
                    ["torso"] = { item = 22, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 12, texture = 6 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 },
                    ["glass"] = { item = 0, texture = 0 },
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                },
                [1] = { -- feminino
                    ["pants"] = { item = 14, texture = 6 }, -- calças
                    ["arms"] = { item = 14, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 9, texture = 0 }, -- blusa
                    ["torso"] = { item = 23, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 3, texture = 0 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 }, -- chapeu
                    ["glass"] = { item = 0, texture = 0 }, 
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                }
            },
            ["barbershop"] = {
                [0] = { 0,0,0.65,2,12,0,-1,4,-1,45,29,29,0,0,0,0,0,0,30,0.99,0,1,0.88,0,-1,0,0,-1,0.84,0.72,0.46,0,0,0.3,-0.3,0,-0.58,-0.72,-0.52,0.21,0.37,0.79,0.6,0.71,0.43,-0.7,0 },
                [1] = { 3,6,1,0,12,0,-1,-1,-1,74,0,4,0,0,2,0,0,0,2,0.99,26,0,0,0,0,0,0,-1,-1,-0.94,-0.31,0.24,0.25,-0.1,-0.79,-0.72,-1,-0.32,-0.61,-0.25,0,-1,0,-0.38,-0.65,-1,1,0,0,0 }
            }
        },
        [2] = {
            ["skinshop"] = {
                [0] = { -- masculino
                    ["pants"] = { item = 4, texture = 2 }, -- calças
                    ["arms"] = { item = 11, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 15, texture = 0 }, -- blusa
                    ["torso"] = { item = 22, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 12, texture = 6 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 },
                    ["glass"] = { item = 0, texture = 0 },
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                },
                [1] = { -- feminino
                    ["pants"] = { item = 14, texture = 6 }, -- calças
                    ["arms"] = { item = 14, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 9, texture = 0 }, -- blusa
                    ["torso"] = { item = 23, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 3, texture = 0 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 }, -- chapeu
                    ["glass"] = { item = 0, texture = 0 }, 
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                }
            },
            ["barbershop"] = {
                [0] = { 0,8,0.5,0,3,0,-1,4,-1,73,0,0,0,0,0,0,0,0,30,0.99,0,1,0.88,0,-1,0,0,-1,0.84,0.72,0.46,0,0,0.3,-0.3,0,-0.58,-0.72,-0.52,0.21,0.37,0.79,0.6,0.71,0.43,-0.7 },
                [1] = { 3,6,1,0,12,0,-1,-1,-1,74,0,4,0,0,2,0,0,0,2,0.99,26,0,0,0,0,0,0,-1,-1,-0.94,-0.31,0.24,0.25,-0.1,-0.79,-0.72,-1,-0.32,-0.61,-0.25,0,-1,0,-0.38,-0.65,-1,1,0,0,0 }
            }
        },
    }
elseif cityName == "District99" then
    Initial = {
        [1] = {
            ["skinshop"] = {
                [0] = { -- masculino
                    ["pants"] = { item = 4, texture = 2 }, -- calças
                    ["arms"] = { item = 11, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 15, texture = 0 }, -- blusa
                    ["torso"] = { item = 22, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 12, texture = 6 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 },
                    ["glass"] = { item = 0, texture = 0 },
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                },
                [1] = { -- feminino
                    ["pants"] = { item = 14, texture = 6 }, -- calças
                    ["arms"] = { item = 14, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 9, texture = 0 }, -- blusa
                    ["torso"] = { item = 23, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 3, texture = 0 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 }, -- chapeu
                    ["glass"] = { item = 0, texture = 0 }, 
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                }
            },
            ["barbershop"] = {
                [0] = { 0,0,0.65,2,12,0,-1,4,-1,45,29,29,0,0,0,0,0,0,30,0.99,0,1,0.88,0,-1,0,0,-1,0.84,0.72,0.46,0,0,0.3,-0.3,0,-0.58,-0.72,-0.52,0.21,0.37,0.79,0.6,0.71,0.43,-0.7,0 },
                [1] = { 3,6,1,0,12,0,-1,-1,-1,74,0,4,0,0,2,0,0,0,2,0.99,26,0,0,0,0,0,0,-1,-1,-0.94,-0.31,0.24,0.25,-0.1,-0.79,-0.72,-1,-0.32,-0.61,-0.25,0,-1,0,-0.38,-0.65,-1,1,0,0,0 }
            }
        },
        [2] = {
            ["skinshop"] = {
                [0] = { -- masculino
                    ["pants"] = { item = 4, texture = 2 }, -- calças
                    ["arms"] = { item = 11, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 15, texture = 0 }, -- blusa
                    ["torso"] = { item = 22, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 12, texture = 6 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 },
                    ["glass"] = { item = 0, texture = 0 },
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                },
                [1] = { -- feminino
                    ["pants"] = { item = 14, texture = 6 }, -- calças
                    ["arms"] = { item = 14, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 9, texture = 0 }, -- blusa
                    ["torso"] = { item = 23, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 3, texture = 0 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 }, -- chapeu
                    ["glass"] = { item = 0, texture = 0 }, 
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                }
            },
            ["barbershop"] = {
                [0] = { 0,8,0.5,0,3,0,-1,4,-1,73,0,0,0,0,0,0,0,0,30,0.99,0,1,0.88,0,-1,0,0,-1,0.84,0.72,0.46,0,0,0.3,-0.3,0,-0.58,-0.72,-0.52,0.21,0.37,0.79,0.6,0.71,0.43,-0.7 },
                [1] = { 3,6,1,0,12,0,-1,-1,-1,74,0,4,0,0,2,0,0,0,2,0.99,26,0,0,0,0,0,0,-1,-1,-0.94,-0.31,0.24,0.25,-0.1,-0.79,-0.72,-1,-0.32,-0.61,-0.25,0,-1,0,-0.38,-0.65,-1,1,0,0,0 }
            }
        },
    }
elseif cityName == "Krown" then
    Initial = {
        [1] = {
            ["skinshop"] = {
                [0] = { -- masculino
                    ["pants"] = { item = 4, texture = 2 }, -- calças
                    ["arms"] = { item = 11, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 15, texture = 0 }, -- blusa
                    ["torso"] = { item = 22, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 12, texture = 6 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 },
                    ["glass"] = { item = 0, texture = 0 },
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                },
                [1] = { -- feminino
                    ["pants"] = { item = 14, texture = 6 }, -- calças
                    ["arms"] = { item = 14, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 9, texture = 0 }, -- blusa
                    ["torso"] = { item = 23, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 3, texture = 0 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 }, -- chapeu
                    ["glass"] = { item = 0, texture = 0 }, 
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                }
            },
            ["barbershop"] = {
                [0] = { 0,0,0.65,2,12,0,-1,4,-1,45,29,29,0,0,0,0,0,0,30,0.99,0,1,0.88,0,-1,0,0,-1,0.84,0.72,0.46,0,0,0.3,-0.3,0,-0.58,-0.72,-0.52,0.21,0.37,0.79,0.6,0.71,0.43,-0.7,0 },
                [1] = { 3,6,1,0,12,0,-1,-1,-1,74,0,4,0,0,2,0,0,0,2,0.99,26,0,0,0,0,0,0,-1,-1,-0.94,-0.31,0.24,0.25,-0.1,-0.79,-0.72,-1,-0.32,-0.61,-0.25,0,-1,0,-0.38,-0.65,-1,1,0,0,0 }
            }
        },
        [2] = {
            ["skinshop"] = {
                [0] = { -- masculino
                    ["pants"] = { item = 4, texture = 2 }, -- calças
                    ["arms"] = { item = 11, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 15, texture = 0 }, -- blusa
                    ["torso"] = { item = 22, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 12, texture = 6 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 },
                    ["glass"] = { item = 0, texture = 0 },
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                },
                [1] = { -- feminino
                    ["pants"] = { item = 14, texture = 6 }, -- calças
                    ["arms"] = { item = 14, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 9, texture = 0 }, -- blusa
                    ["torso"] = { item = 23, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 3, texture = 0 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 }, -- chapeu
                    ["glass"] = { item = 0, texture = 0 }, 
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                }
            },
            ["barbershop"] = {
                [0] = { 0,8,0.5,0,3,0,-1,4,-1,73,0,0,0,0,0,0,0,0,30,0.99,0,1,0.88,0,-1,0,0,-1,0.84,0.72,0.46,0,0,0.3,-0.3,0,-0.58,-0.72,-0.52,0.21,0.37,0.79,0.6,0.71,0.43,-0.7 },
                [1] = { 3,6,1,0,12,0,-1,-1,-1,74,0,4,0,0,2,0,0,0,2,0.99,26,0,0,0,0,0,0,-1,-1,-0.94,-0.31,0.24,0.25,-0.1,-0.79,-0.72,-1,-0.32,-0.61,-0.25,0,-1,0,-0.38,-0.65,-1,1,0,0,0 }
            }
        },
    }
elseif cityName == "Orizon" then
    Initial = {
        [1] = {
            ["skinshop"] = {
                [0] = { -- masculino
                    ["pants"] = { item = 4, texture = 2 }, -- calças
                    ["arms"] = { item = 11, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 15, texture = 0 }, -- blusa
                    ["torso"] = { item = 22, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 12, texture = 6 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 },
                    ["glass"] = { item = 0, texture = 0 },
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                },
                [1] = { -- feminino
                    ["pants"] = { item = 14, texture = 6 }, -- calças
                    ["arms"] = { item = 14, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 9, texture = 0 }, -- blusa
                    ["torso"] = { item = 23, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 3, texture = 0 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 }, -- chapeu
                    ["glass"] = { item = 0, texture = 0 }, 
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                }
            },
            ["barbershop"] = {
                [0] = { 0,0,0.65,2,12,0,-1,4,-1,45,29,29,0,0,0,0,0,0,30,0.99,0,1,0.88,0,-1,0,0,-1,0.84,0.72,0.46,0,0,0.3,-0.3,0,-0.58,-0.72,-0.52,0.21,0.37,0.79,0.6,0.71,0.43,-0.7,0 },
                [1] = { 3,6,1,0,12,0,-1,-1,-1,74,0,4,0,0,2,0,0,0,2,0.99,26,0,0,0,0,0,0,-1,-1,-0.94,-0.31,0.24,0.25,-0.1,-0.79,-0.72,-1,-0.32,-0.61,-0.25,0,-1,0,-0.38,-0.65,-1,1,0,0,0 }
            }
        },
        [2] = {
            ["skinshop"] = {
                [0] = { -- masculino
                    ["pants"] = { item = 4, texture = 2 }, -- calças
                    ["arms"] = { item = 11, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 15, texture = 0 }, -- blusa
                    ["torso"] = { item = 22, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 12, texture = 6 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 },
                    ["glass"] = { item = 0, texture = 0 },
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                },
                [1] = { -- feminino
                    ["pants"] = { item = 14, texture = 6 }, -- calças
                    ["arms"] = { item = 14, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 9, texture = 0 }, -- blusa
                    ["torso"] = { item = 23, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 3, texture = 0 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 }, -- chapeu
                    ["glass"] = { item = 0, texture = 0 }, 
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                }
            },
            ["barbershop"] = {
                [0] = { 0,8,0.5,0,3,0,-1,4,-1,73,0,0,0,0,0,0,0,0,30,0.99,0,1,0.88,0,-1,0,0,-1,0.84,0.72,0.46,0,0,0.3,-0.3,0,-0.58,-0.72,-0.52,0.21,0.37,0.79,0.6,0.71,0.43,-0.7 },
                [1] = { 3,6,1,0,12,0,-1,-1,-1,74,0,4,0,0,2,0,0,0,2,0.99,26,0,0,0,0,0,0,-1,-1,-0.94,-0.31,0.24,0.25,-0.1,-0.79,-0.72,-1,-0.32,-0.61,-0.25,0,-1,0,-0.38,-0.65,-1,1,0,0,0 }
            }
        },
    }
elseif cityName == "Liberty99" then
    Initial = {
        [1] = {
            ["skinshop"] = {
                [0] = { -- masculino
                    ["pants"] = { item = 4, texture = 2 }, -- calças
                    ["arms"] = { item = 11, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 15, texture = 0 }, -- blusa
                    ["torso"] = { item = 22, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 12, texture = 6 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 },
                    ["glass"] = { item = 0, texture = 0 },
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                },
                [1] = { -- feminino
                    ["pants"] = { item = 14, texture = 6 }, -- calças
                    ["arms"] = { item = 14, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 9, texture = 0 }, -- blusa
                    ["torso"] = { item = 23, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 3, texture = 0 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 }, -- chapeu
                    ["glass"] = { item = 0, texture = 0 }, 
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                }
            },
            ["barbershop"] = {
                [0] = { 0,0,0.65,2,12,0,-1,4,-1,45,29,29,0,0,0,0,0,0,30,0.99,0,1,0.88,0,-1,0,0,-1,0.84,0.72,0.46,0,0,0.3,-0.3,0,-0.58,-0.72,-0.52,0.21,0.37,0.79,0.6,0.71,0.43,-0.7,0 },
                [1] = { 3,6,1,0,12,0,-1,-1,-1,74,0,4,0,0,2,0,0,0,2,0.99,26,0,0,0,0,0,0,-1,-1,-0.94,-0.31,0.24,0.25,-0.1,-0.79,-0.72,-1,-0.32,-0.61,-0.25,0,-1,0,-0.38,-0.65,-1,1,0,0,0 }
            }
        },
        [2] = {
            ["skinshop"] = {
                [0] = { -- masculino
                    ["pants"] = { item = 4, texture = 2 }, -- calças
                    ["arms"] = { item = 11, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 15, texture = 0 }, -- blusa
                    ["torso"] = { item = 22, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 12, texture = 6 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 },
                    ["glass"] = { item = 0, texture = 0 },
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                },
                [1] = { -- feminino
                    ["pants"] = { item = 14, texture = 6 }, -- calças
                    ["arms"] = { item = 14, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 9, texture = 0 }, -- blusa
                    ["torso"] = { item = 23, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 3, texture = 0 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 }, -- chapeu
                    ["glass"] = { item = 0, texture = 0 }, 
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                }
            },
            ["barbershop"] = {
                [0] = { 0,8,0.5,0,3,0,-1,4,-1,73,0,0,0,0,0,0,0,0,30,0.99,0,1,0.88,0,-1,0,0,-1,0.84,0.72,0.46,0,0,0.3,-0.3,0,-0.58,-0.72,-0.52,0.21,0.37,0.79,0.6,0.71,0.43,-0.7 },
                [1] = { 3,6,1,0,12,0,-1,-1,-1,74,0,4,0,0,2,0,0,0,2,0.99,26,0,0,0,0,0,0,-1,-1,-0.94,-0.31,0.24,0.25,-0.1,-0.79,-0.72,-1,-0.32,-0.61,-0.25,0,-1,0,-0.38,-0.65,-1,1,0,0,0 }
            }
        },
    }
elseif cityName == "Royal" then
    Initial = {
        [1] = {
            ["skinshop"] = {
                [0] = { -- masculino
                    ["pants"] = { item = 4, texture = 2 }, -- calças
                    ["arms"] = { item = 11, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 15, texture = 0 }, -- blusa
                    ["torso"] = { item = 22, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 12, texture = 6 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 },
                    ["glass"] = { item = 0, texture = 0 },
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                },
                [1] = { -- feminino
                    ["pants"] = { item = 14, texture = 6 }, -- calças
                    ["arms"] = { item = 9, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 9, texture = 0 }, -- blusa
                    ["torso"] = { item = 23, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 3, texture = 0 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 }, -- chapeu
                    ["glass"] = { item = 0, texture = 0 }, 
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                }
            },
            ["barbershop"] = {
                [0] = { 0,0,0.65,2,12,0,-1,4,-1,45,29,29,0,0,0,0,0,0,30,0.99,0,1,0.88,0,-1,0,0,-1,0.84,0.72,0.46,0,0,0.3,-0.3,0,-0.58,-0.72,-0.52,0.21,0.37,0.79,0.6,0.71,0.43,-0.7,0 },
                [1] = { 3,6,1,0,12,0,-1,-1,-1,74,0,4,0,0,2,0,0,0,2,0.99,26,0,0,0,0,0,0,-1,-1,-0.94,-0.31,0.24,0.25,-0.1,-0.79,-0.72,-1,-0.32,-0.61,-0.25,0,-1,0,-0.38,-0.65,-1,1,0,0,0 }
            }
        },
        [2] = {
            ["skinshop"] = {
                [0] = { -- masculino
                    ["pants"] = { item = 4, texture = 2 }, -- calças
                    ["arms"] = { item = 11, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 15, texture = 0 }, -- blusa
                    ["torso"] = { item = 22, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 12, texture = 6 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 },
                    ["glass"] = { item = 0, texture = 0 },
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                },
                [1] = { -- feminino
                    ["pants"] = { item = 14, texture = 6 }, -- calças
                    ["arms"] = { item = 9, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 9, texture = 0 }, -- blusa
                    ["torso"] = { item = 23, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 3, texture = 0 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 }, -- chapeu
                    ["glass"] = { item = 0, texture = 0 }, 
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                }
            },
            ["barbershop"] = {
                [0] = { 0,8,0.5,0,3,0,-1,4,-1,73,0,0,0,0,0,0,0,0,30,0.99,0,1,0.88,0,-1,0,0,-1,0.84,0.72,0.46,0,0,0.3,-0.3,0,-0.58,-0.72,-0.52,0.21,0.37,0.79,0.6,0.71,0.43,-0.7 },
                [1] = { 3,6,1,0,12,0,-1,-1,-1,74,0,4,0,0,2,0,0,0,2,0.99,26,0,0,0,0,0,0,-1,-1,-0.94,-0.31,0.24,0.25,-0.1,-0.79,-0.72,-1,-0.32,-0.61,-0.25,0,-1,0,-0.38,-0.65,-1,1,0,0,0 }
            }
        },
    }
elseif cityName == "Boomerang" then
    Initial = {
        [1] = {
            ["skinshop"] = {
                [0] = { -- masculino
                    ["pants"] = { item = 4, texture = 2 }, -- calças
                    ["arms"] = { item = 11, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 15, texture = 0 }, -- blusa
                    ["torso"] = { item = 22, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 12, texture = 6 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 },
                    ["glass"] = { item = 0, texture = 0 },
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                },
                [1] = { -- feminino
                    ["pants"] = { item = 14, texture = 6 }, -- calças
                    ["arms"] = { item = 9, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 9, texture = 0 }, -- blusa
                    ["torso"] = { item = 23, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 3, texture = 0 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 }, -- chapeu
                    ["glass"] = { item = 0, texture = 0 }, 
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                }
            },
            ["barbershop"] = {
                [0] = { 0,0,0.65,2,12,0,-1,4,-1,45,29,29,0,0,0,0,0,0,30,0.99,0,1,0.88,0,-1,0,0,-1,0.84,0.72,0.46,0,0,0.3,-0.3,0,-0.58,-0.72,-0.52,0.21,0.37,0.79,0.6,0.71,0.43,-0.7,0 },
                [1] = { 3,6,1,0,12,0,-1,-1,-1,74,0,4,0,0,2,0,0,0,2,0.99,26,0,0,0,0,0,0,-1,-1,-0.94,-0.31,0.24,0.25,-0.1,-0.79,-0.72,-1,-0.32,-0.61,-0.25,0,-1,0,-0.38,-0.65,-1,1,0,0,0 }
            }
        },
        [2] = {
            ["skinshop"] = {
                [0] = { -- masculino
                    ["pants"] = { item = 4, texture = 2 }, -- calças
                    ["arms"] = { item = 11, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 15, texture = 0 }, -- blusa
                    ["torso"] = { item = 22, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 12, texture = 6 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 },
                    ["glass"] = { item = 0, texture = 0 },
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                },
                [1] = { -- feminino
                    ["pants"] = { item = 14, texture = 6 }, -- calças
                    ["arms"] = { item = 9, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 9, texture = 0 }, -- blusa
                    ["torso"] = { item = 23, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 3, texture = 0 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 }, -- chapeu
                    ["glass"] = { item = 0, texture = 0 }, 
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                }
            },
            ["barbershop"] = {
                [0] = { 0,8,0.5,0,3,0,-1,4,-1,73,0,0,0,0,0,0,0,0,30,0.99,0,1,0.88,0,-1,0,0,-1,0.84,0.72,0.46,0,0,0.3,-0.3,0,-0.58,-0.72,-0.52,0.21,0.37,0.79,0.6,0.71,0.43,-0.7 },
                [1] = { 3,6,1,0,12,0,-1,-1,-1,74,0,4,0,0,2,0,0,0,2,0.99,26,0,0,0,0,0,0,-1,-1,-0.94,-0.31,0.24,0.25,-0.1,-0.79,-0.72,-1,-0.32,-0.61,-0.25,0,-1,0,-0.38,-0.65,-1,1,0,0,0 }
            }
        },
    }
elseif cityName == "Real" then
    Initial = {
        [1] = {
            ["skinshop"] = {
                [0] = { -- masculino
                    ["pants"] = { item = 4, texture = 2 }, -- calças
                    ["arms"] = { item = 11, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 15, texture = 0 }, -- blusa
                    ["torso"] = { item = 22, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 12, texture = 6 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 },
                    ["glass"] = { item = 0, texture = 0 },
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                },
                [1] = { -- feminino
                    ["pants"] = { item = 14, texture = 6 }, -- calças
                    ["arms"] = { item = 9, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 9, texture = 0 }, -- blusa
                    ["torso"] = { item = 23, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 3, texture = 0 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 }, -- chapeu
                    ["glass"] = { item = 0, texture = 0 }, 
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                }
            },
            ["barbershop"] = {
                [0] = { 0,0,0.65,2,12,0,-1,4,-1,45,29,29,0,0,0,0,0,0,30,0.99,0,1,0.88,0,-1,0,0,-1,0.84,0.72,0.46,0,0,0.3,-0.3,0,-0.58,-0.72,-0.52,0.21,0.37,0.79,0.6,0.71,0.43,-0.7,0 },
                [1] = { 3,6,1,0,12,0,-1,-1,-1,74,0,4,0,0,2,0,0,0,2,0.99,26,0,0,0,0,0,0,-1,-1,-0.94,-0.31,0.24,0.25,-0.1,-0.79,-0.72,-1,-0.32,-0.61,-0.25,0,-1,0,-0.38,-0.65,-1,1,0,0,0 }
            }
        },
        [2] = {
            ["skinshop"] = {
                [0] = { -- masculino
                    ["pants"] = { item = 4, texture = 2 }, -- calças
                    ["arms"] = { item = 11, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 15, texture = 0 }, -- blusa
                    ["torso"] = { item = 22, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 12, texture = 6 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 },
                    ["glass"] = { item = 0, texture = 0 },
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                },
                [1] = { -- feminino
                    ["pants"] = { item = 14, texture = 6 }, -- calças
                    ["arms"] = { item = 9, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 9, texture = 0 }, -- blusa
                    ["torso"] = { item = 23, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 3, texture = 0 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 }, -- chapeu
                    ["glass"] = { item = 0, texture = 0 }, 
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                }
            },
            ["barbershop"] = {
                [0] = { 0,8,0.5,0,3,0,-1,4,-1,73,0,0,0,0,0,0,0,0,30,0.99,0,1,0.88,0,-1,0,0,-1,0.84,0.72,0.46,0,0,0.3,-0.3,0,-0.58,-0.72,-0.52,0.21,0.37,0.79,0.6,0.71,0.43,-0.7 },
                [1] = { 3,6,1,0,12,0,-1,-1,-1,74,0,4,0,0,2,0,0,0,2,0.99,26,0,0,0,0,0,0,-1,-1,-0.94,-0.31,0.24,0.25,-0.1,-0.79,-0.72,-1,-0.32,-0.61,-0.25,0,-1,0,-0.38,-0.65,-1,1,0,0,0 }
            }
        },
    }
elseif cityName == "Prime" then
    Initial = {
        [1] = {
            ["skinshop"] = {
                [0] = { -- masculino
                    ["pants"] = { item = 4, texture = 2 }, -- calças
                    ["arms"] = { item = 11, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 15, texture = 0 }, -- blusa
                    ["torso"] = { item = 22, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 12, texture = 6 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 },
                    ["glass"] = { item = 0, texture = 0 },
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                },
                [1] = { -- feminino
                    ["pants"] = { item = 14, texture = 6 }, -- calças
                    ["arms"] = { item = 9, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 9, texture = 0 }, -- blusa
                    ["torso"] = { item = 23, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 3, texture = 0 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 }, -- chapeu
                    ["glass"] = { item = 0, texture = 0 }, 
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                }
            },
            ["barbershop"] = {
                [0] = { 0,0,0.65,2,12,0,-1,4,-1,45,29,29,0,0,0,0,0,0,30,0.99,0,1,0.88,0,-1,0,0,-1,0.84,0.72,0.46,0,0,0.3,-0.3,0,-0.58,-0.72,-0.52,0.21,0.37,0.79,0.6,0.71,0.43,-0.7,0 },
                [1] = { 3,6,1,0,12,0,-1,-1,-1,74,0,4,0,0,2,0,0,0,2,0.99,26,0,0,0,0,0,0,-1,-1,-0.94,-0.31,0.24,0.25,-0.1,-0.79,-0.72,-1,-0.32,-0.61,-0.25,0,-1,0,-0.38,-0.65,-1,1,0,0,0 }
            }
        },
        [2] = {
            ["skinshop"] = {
                [0] = { -- masculino
                    ["pants"] = { item = 4, texture = 2 }, -- calças
                    ["arms"] = { item = 11, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 15, texture = 0 }, -- blusa
                    ["torso"] = { item = 22, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 12, texture = 6 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 },
                    ["glass"] = { item = 0, texture = 0 },
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                },
                [1] = { -- feminino
                    ["pants"] = { item = 14, texture = 6 }, -- calças
                    ["arms"] = { item = 9, texture = 0 }, -- mãos
                    ["tshirt"] = { item = 9, texture = 0 }, -- blusa
                    ["torso"] = { item = 23, texture = 0 }, -- jaqueta
                    ["vest"] = { item = 0, texture = 0 }, -- colete
                    ["shoes"] = { item = 3, texture = 0 }, -- sapatos
                    ["mask"] = { item = 0, texture = 0 }, -- mascara
                    ["backpack"] = { item = 0, texture = 0 }, -- mochila
                    ["hat"] = { item = -1, texture = 0 }, -- chapeu
                    ["glass"] = { item = 0, texture = 0 }, 
                    ["ear"] = { item = -1, texture = 0 },
                    ["watch"] = { item = -1, texture = 0 },
                    ["bracelet"] = { item = -1, texture = 0 },
                    ["accessory"] = { item = 0, texture = 0 },
                    ["decals"] = { item = 0, texture = 0 }
                }
            },
            ["barbershop"] = {
                [0] = { 0,8,0.5,0,3,0,-1,4,-1,73,0,0,0,0,0,0,0,0,30,0.99,0,1,0.88,0,-1,0,0,-1,0.84,0.72,0.46,0,0,0.3,-0.3,0,-0.58,-0.72,-0.52,0.21,0.37,0.79,0.6,0.71,0.43,-0.7 },
                [1] = { 3,6,1,0,12,0,-1,-1,-1,74,0,4,0,0,2,0,0,0,2,0.99,26,0,0,0,0,0,0,-1,-1,-0.94,-0.31,0.24,0.25,-0.1,-0.79,-0.72,-1,-0.32,-0.61,-0.25,0,-1,0,-0.38,-0.65,-1,1,0,0,0 }
            }
        },
    }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICECLEANER
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITENS QUE SERÃO LIMPOS QUANDO O JOGADOR FOR REVISTADO DO REVISTAR
PoliceCleaner = {
    ["WEAPON_PISTOL"] = true,
    ["WEAPON_PISTOL_MK2"] = true,
    ["WEAPON_GADGETPISTOL"] = true,
    ["WEAPON_COMPACTRIFLE"] = true,
    ["WEAPON_APPISTOL"] = true,
    ["WEAPON_CARROT"] = true,
    ["WEAPON_KATANA_CENOURA"] = true,
    ["WEAPON_HEAVYPISTOL"] = true,
    ["WEAPON_MACHINEPISTOL"] = true,
    ["WEAPON_MICROSMG"] = true,
    ["WEAPON_NAILGUN"] = true,
    ["WEAPON_MINISMG"] = true,
    ["WEAPON_SNSPISTOL"] = true,
    ["WEAPON_SNSPISTOL_MK2"] = true,
    ["WEAPON_VINTAGEPISTOL"] = true,
    ["WEAPON_PISTOL50"] = true,
    ["WEAPON_REVOLVER"] = true,
    ["WEAPON_COMBATPISTOL"] = true,
    ["WEAPON_FNFAL"] = true,
    ["WEAPON_BATTLECARBINE"] = true,
    ["WEAPON_CARBINERIFLE"] = true,
    ["WEAPON_CARBINERIFLE_MK2"] = true,
    ["WEAPON_ADVANCEDRIFLE"] = true,
    ["WEAPON_BULLPUPRIFLE"] = true,
    ["WEAPON_BULLPUPRIFLE_MK2"] = true,
    ["WEAPON_SPECIALCARBINE"] = true,


    ["WEAPON_TACTICALRIFLE"] = true,
    ["WEAPON_MILITARYRIFLE"] = true,
    ["WEAPON_COMBATMG_MK2"] = true,
    ["WEAPON_TECPISTOL"] = true,
    ["WEAPON_SNIPERRIFLE"] = true,

    ["WEAPON_SPECIALCARBINE_MK2"] = true,
    ["WEAPON_BATTLERIFLE"] = true,
    ["WEAPON_PUMPSHOTGUN"] = true,
    ["WEAPON_PUMPSHOTGUN_MK2"] = true,
    ["WEAPON_MUSKET"] = true,
    ["WEAPON_SAWNOFFSHOTGUN"] = true,
    ["WEAPON_SMG"] = true,
    ["WEAPON_SMG_MK2"] = true,
    ["WEAPON_ASSAULTRIFLE"] = true,
    ["WEAPON_ASSAULTRIFLE_MK2"] = true,
    ["WEAPON_ASSAULTSMG"] = true,
    ["WEAPON_GUSENBERG"] = true,
    ["WEAPON_STUNGUN"] = true,
    ["WEAPON_MOLOTOV"] = true,
    ["WEAPON_SMOKEGRENADE"] = true,
    ["WEAPON_HATCHET"] = true,
    ["WEAPON_KATANA"] = true,
    ["WEAPON_KARAMBIT"] = true,
    ["WEAPON_BATTLEAXE"] = true,
    ["WEAPON_MACHETE"] = true,
    ["WEAPON_STONE_HATCHET"] = true,
    ["WEAPON_KNUCKLE"] = true,
    ["WEAPON_NIGHTSTICK"] = true,
    ["WEAPON_PISTOL_AMMO"] = true,
    ["WEAPON_NAIL_AMMO"] = true,
    ["WEAPON_SMG_AMMO"] = true,
    ["WEAPON_RIFLE_AMMO"] = true,
    ["WEAPON_SHOTGUN_AMMO"] = true,
    ["WEAPON_MUSKET_AMMO"] = true,
    ["dinheirosujo"] = true,
    ["cocaine"] = true,
    ["joint"] = true,
    ["meth"] = true,
    ["lockpick"] = true,
    ["c4"] = true,
    ["hood"] = true,
    ["handcuff"] = true
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- MECHANICCLEANER
-----------------------------------------------------------------------------------------------------------------------------------------
MechanicCleaner = {
    ["toolbox2"] = true
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- NOTCLEANGG
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITENS QUE NÃO SERÃO LIMPOS QUANDO O JOGADOR MORRER
NotCleanGG = {
    ["icedout_grillsred"] = true,
    ["icedout_grillssilver"] = true,
    ["icedout_grillsgold"] = true,
    ["icedout_grillsgreen"] = true,
    ["icedout_grillsblue"] = true,
    ["pet_monkey"] = true,
    ["pet_cat_spotted"] = true,
    ["pet_cat_white"] = true,
    ["pet_cat_orange"] = true,
    ["pet_butterfly_pink"] = true,
    ["pet_butterfly_blue"] = true,
    ["pet_butterfly_orange"] = true,
    ["pet_crow"] = true,
    ["pet_labrador"] = true,
    ["pet_pinscher"] = true,
    ["pet_seal"] = true,
    ["pet_chicken"] = true,
    ["pet_sloth"] = true,
    ["pet_spider"] = true,
    ["pet_rat_brown"] = true,
    ["pet_rat_white"] = true,
    ["pet_rat_black"] = true,
    ["pet_eagle"] = true,
    ["pet_owl"] = true,
    ["girls_pinkbe"] = true,
    ["girls_pinkcat"] = true,
    ["girls_doglaco"] = true,
    ["girls_dogoculos"] = true,
    ["premium01"] = true,
    ["premium02"] = true,
    ["premium03"] = true,
    ["premium04"] = true,
    ["premium05"] = true,
    ["setvehicles1"] = true,
    ["setvehicles2"] = true,
    ["vehicleselite"] = true,
    ["vehiclesstart"] = true,
    ["vehicles16t"] = true,
    ["vehicles16tpf"] = true,
    ["vehicles32t"] = true,
    ["vehiclesfull2k"] = true,
    ["vehiclesfull2500k"] = true,
    ["vehiclesfull3k"] = true,
    ["vehiclesfullabs"] = true,
    ["vipevento1"] = true,
    ["vipevento2"] = true,
    ["vipstaff"] = true,
    ["picole2"] = true,
    ["petretriever"] = true,
    ["petrottweiler"] = true,
    ["petwesty"] = true,
    ["petpug"] = true,
    ["petbulldog"] = true,
    ["petgreyhound"] = true,
    ["LoboSirius"] = true,
    ["Tigor"] = true,
    ["Rajah"] = true,
    ["pethusky"] = true,
    ["petshepherd"] = true,
    ["petpoodle"] = true,
    ["petovelha"] = true,
    ["pedretrom"] = true,
    ["pedretrof"] = true,
    ["petpanda"] = true,
    ["petjavali"] = true,
    ["dragaolcfr"] = true,
    ["petdragao1"] = true,
    ["petdragao2"] = true,
    ["petdragao3"] = true,
    ["petdragao4"] = true,
    ["petdragao5"] = true,
    ["petdragao6"] = true,
    ["petdragao7"] = true,
    ["petdragao8"] = true,
    ["petcanecorso"] = true,
    ["petdoberman"] = true,
    ["petcat"] = true,
    ["petsphynx"] = true,
    ["monkey"] = true,
    ["megaphone"] = true,
    ["kitblack2"] = true,
    ["kitarmas1"] = true,
    ["kitarmas2"] = true,
    ["kitarmas3"] = true,
    ["kitarmas4"] = true,
    ["kitarmas5"] = true,
    ["kitarmas6"] = true,
    ["kitarmas7"] = true,
    ["kitorgs"] = true,
    ["kitfaclavagem"] = true,
    ["kitfacmaconha"] = true,
    ["kitfaccoca"] = true,
    ["kitfacmeta"] = true,
    ["kitfacmunicao"] = true,
    ["kitfacdesmanche"] = true,
    ["kitfacarmas"] = true,
    ["postit"] = true,
    ["vipsorteio"] = true,
    ["kitfogueteiro"] = true,
    ["kitcriminal"] = true,
    ["kitmafioso"] = true,
    ["kitdosraul"] = true,
    ["kitboqueta"] = true,
	["gemstone"] = true,
    ["wardrobeslot"] = true,
    ["premiumplate"] = true,
    ["phonechange"] = true,
    ["newchars"] = true,
    ["creator"] = true,
    ["namechange"] = true,
    ["profilepicture"] = true,
    ["creditcard"] = true,
    ["vehkey"] = true,
    ["propertys"] = true,
    ["rolepass"] = true,
	["money1"] = true,
	["money2"] = true,
	["money3"] = true,
	["money4"] = true,
	["money5"] = true,
	["packbasic"] = true,
	["packelite"] = true,
	["packpremium"] = true,
    ["weedleaf"] = true,
    ["silk"] = true,
    ["cokeleaf"] = true,
    ["sulfuric"] = true,
    ["saline"] = true,
    ["acetone"] = true,
    ["aguadestilada"] = true,
    ["cloro"] = true,
    ["capsula"] = true,
    ["polvora"] = true,
    ["weaponbody"] = true,
    ["molas"] = true,
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
    ["WEAPON_KATANA_CENOURA"] = true,
    ["WEAPON_CENOURA"] = true,
    ["WEAPON_PL_PENHASHOP_G3_PCJ_V2"] = true,
    ["WEAPON_BLACKSNAKE"] = true,
    ["WEAPON_BULLPUP_ANIME"] = true,
    ["WEAPON_PINKFIRE"] = true,
    ["WEAPON_SPECIALCARBINE_TOXIC"] = true,
    ["WEAPON_BULLPUPRIFLE_MK2_LOBO"] = true,
    ["WEAPON_WOLFSTORM"] = true,
    ["WEAPON_G3LCHELLFIRE"] = true,
    ["WEAPON_RAIJIN"] = true,
    ["WEAPON_APPISTOL_SHOCKVOLT"] = true,
    ["WEAPON_APPISTOL_DARKMATTER"] = true,
    ["WEAPON_APPISTOL_SNAGDRAGON"] = true,
    ["WEAPON_TIGER_PISTOL"] = true,
    ["WEAPON_ONI"] = true,
    ["WEAPON_TIGER"] = true,
    ["WEAPON_ABISSAL"] = true,
    ["WEAPON_SHINIGAMI"] = true,
    ["WEAPON_SKORPION_SNIPER"] = true,
    ["WEAPON_SHOCKVOLT_SNIPER"] = true,
    ["WEAPON_SNIPERRIFLE_CYBERTRIBAL"] = true,
    ["WEAPON_DRAGONRED_SNIPER"] = true,
    ["WEAPON_HEAVYSNIPER_MK2_LOBO"] = true,
    ["WEAPON_THYZUK_SNIPER"] = true,
    ["WEAPON_TIGER_SNIPER"] = true,
    ["WEAPON_PABSS"] = true,
    ["voucher_property_emerald"] = true,
    ["voucher_property_diamond"] = true,
    ["voucher_property_ruby"] = true,
    ["voucher_property_sapphire"] = true,
    ["voucher_property_amethyst"] = true,
    ["voucher_property_amber"] = true,
    ["pent01"] = true,
    ["pent02"] = true,
    ["pent03"] = true,
    ["pent04"] = true,
    ["pent05"] = true,
    ["crab"] = true,
    ["plumascarnaval"] = true,
    ["coroacarnaval"] = true,
    ["confetecarnaval"] = true,
    ["spraycarnaval"] = true,
    ["tiaracarnaval"] = true,
    ["tiaracarnaval2"] = true,
    ["frevocarnaval"] = true,
    ["calangocarnaval"] = true,
    ["macacocarnaval"] = true,
    ["placabeijo"] = true,
    ["placajuizo"] = true,
    ["placajuizo2"] = true,
    ["placagolpe2"] = true,
    ["placagolpe"] = true,
    ["coolercarnaval"] = true,
    ["greenbeer"] = true,
    ["leprechaun"] = true,
    ["patrickhat"] = true,
    ["clover"] = true,
    ["potofgold"] = true,
    ["irishflag"] = true,
    ["santa2"] = true,
    ["sun"] = true,
    ["surfboard"] = true,
    ["faquinha"] = true,
    ["maozinhaaddams"] = true,
    ["lobinho"] = true,
    ["dragao"] = true,
    ["lobinho"] = true,
    ["gatinhoabobora"] = true,
    ["morceguinho"] = true,
    ["foice"] = true,
    ["dragao"] = true,
    ["fantasminha"] = true,
    ["bruxinha"] = true,
    ["santa25"] = true,
    ["elf25"] = true, 
    ["ren25"] = true,
    ["snow25"] = true,
    ["green25"] = true,
    ["gift25"] = true,
    ["tree25"] = true,
    ["balaopascoam"] = true,
    ["balaopascoaf"] = true,
    ["mochilacenoura"] = true,
    ["mochilacoelhof"] = true,
    ["mochilacoelhom"] = true,
    ["cestapascoa"] = true,
    ["coelhinhof"] = true,
    ["coelhinhom"] = true,
    ["pintinhopascoa"] = true,
    ["peluciacenoura"] = true,
    ["faixapascoa"] = true,
    ["orelhapascoaf"] = true,
    ["orelhapascoam"] = true,
    ["ovodecoradopascoa"] = true,
    ["ovodouradopascoa"] = true,
    ["pirulitopascoa"] = true,
    ["freezefigure"] = true,
    ["flamefigure"] = true,
    ["windfigure"] = true,
    ["lightningfigure"] = true,
    ["flamemask"] = true,
    ["stormhat"] = true,
    ["freezemask"] = true,
    ["windfans"] = true,
    ["ovodepascoa"] = true,
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
    ["verificado1"] = true,
    ["fichacassino"] = true,
    ["maletadinheiro"] = true,
    ["moneygun"] = true,
    ["dados"] = true,
    ["baralho"] = true,
    ["midnightcarblue"] = true,
    ["midnightcarblack"] = true,
    ["flagmidnight"] = true,
    ["midnightcrown"] = true,
    ["worldcup_goldenball2"] = true,
    ["worldcup_flagarabia"] = true,
    ["worldcup_flagbrasil"] = true,
    ["worldcup_flagespanha"] = true,
    ["worldcup_flaginglaterra"] = true,
    ["worldcup_flagportugal"] = true,
    ["cuptrophy_brasil"] = true,
    ["cuptrophy_portugal"] = true,
    ["cuptrophy_saudiarabia"] = true,
    ["cuptrophy_espana"] = true,
    ["cuptrophy_england"] = true,
    ["cupmascot_brasil"] = true,
    ["cupmascot_portuga"] = true,
    ["cupmascot_saudiarabia"] = true,
    ["cupmascot_espana"] = true,
    ["cupmascot_england"] = true,
    ["playtime_cowgirl"] = true,
    ["playtime_cowboy"] = true,
    ["playtime_astronaut"] = true,
    ["playtime_dinosaur"] = true,
    ["nobrakes_dronegt"] = true,
    ["nobrakes_helmetgt"] = true,
    ["nobrakes_glassesgt"] = true,
    ["nobrakes_shoesgt"] = true,
    ["halloween26_ghostboo"] = true,
    ["halloween26_wingsshadow"] = true,
    ["halloween26_batcrown"] = true,
    ["bigboss_cigar"] = true,
    ["bigboss_kitflapper"] = true,
    ["bigboss_cane"] = true,
    ["bigboss_coin"] = true,
    ["taçadados"] = true,
    ["maletafichas"] = true,
    ["roleta"] = true,
    ["camaleao"] = true,
    ["WEAPON_MOLOTOV"] = true,
    ["WEAPON_SMOKEGRENADE"] = true,
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- INICIANTE
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITENS QUE NÃO SERÃO LIMPOS QUANDO O JOGADOR FOR INICIANTE
InicianteItems = {
    ["WEAPON_PISTOL"] = true,
    ["WEAPON_PISTOL_MK2"] = true,
    ["WEAPON_COMPACTRIFLE"] = true,
    ["WEAPON_APPISTOL"] = true,
    ["WEAPON_CARROT"] = true,
    ["WEAPON_KATANA_CENOURA"] = true,
    ["WEAPON_HEAVYPISTOL"] = true,
    ["WEAPON_MACHINEPISTOL"] = true,
    ["WEAPON_MICROSMG"] = true,
    ["WEAPON_NAILGUN"] = true,
    ["WEAPON_MINISMG"] = true,
    ["WEAPON_SNSPISTOL"] = true,
    ["WEAPON_SNSPISTOL_MK2"] = true,
    ["WEAPON_VINTAGEPISTOL"] = true,
    ["WEAPON_PISTOL50"] = true,
    ["WEAPON_REVOLVER"] = true,
    ["WEAPON_COMBATPISTOL"] = true,
    ["WEAPON_FNFAL"] = true,
    ["WEAPON_BATTLECARBINE"] = true,
    ["WEAPON_CARBINERIFLE"] = true,
    ["WEAPON_CARBINERIFLE_MK2"] = true,
    ["WEAPON_ADVANCEDRIFLE"] = true,
    ["WEAPON_BULLPUPRIFLE"] = true,
    ["WEAPON_BULLPUPRIFLE_MK2"] = true,
    ["WEAPON_SPECIALCARBINE"] = true,
    ["WEAPON_SPECIALCARBINE_MK2"] = true,
    ["WEAPON_BATTLERIFLE"] = true,
    ["WEAPON_PUMPSHOTGUN"] = true,
    ["WEAPON_PUMPSHOTGUN_MK2"] = true,
    ["WEAPON_MUSKET"] = true,
    ["WEAPON_SAWNOFFSHOTGUN"] = true,
    ["WEAPON_SMG"] = true,
    ["WEAPON_SMG_MK2"] = true,
    ["WEAPON_ASSAULTRIFLE"] = true,
    ["WEAPON_ASSAULTRIFLE_MK2"] = true,
    ["WEAPON_ASSAULTSMG"] = true,
    ["WEAPON_GUSENBERG"] = true,
    ["WEAPON_STUNGUN"] = true,
    ["WEAPON_MOLOTOV"] = true,
    ["WEAPON_SMOKEGRENADE"] = true,
    ["WEAPON_HATCHET"] = true,
    ["WEAPON_KATANA"] = true,
    ["WEAPON_KARAMBIT"] = true,
    ["WEAPON_BATTLEAXE"] = true,
    ["WEAPON_MACHETE"] = true,
    ["WEAPON_STONE_HATCHET"] = true,
    ["WEAPON_KNUCKLE"] = true,
    ["WEAPON_NIGHTSTICK"] = true,
    ["WEAPON_PISTOL_AMMO"] = true,
    ["WEAPON_NAIL_AMMO"] = true,
    ["WEAPON_SMG_AMMO"] = true,
    ["WEAPON_RIFLE_AMMO"] = true,
    ["WEAPON_SHOTGUN_AMMO"] = true,
    ["WEAPON_MUSKET_AMMO"] = true,
    ["dinheirosujo"] = true,
    ["cocaine"] = true,
    ["joint"] = true,
    ["meth"] = true,
    ["lockpick"] = true,
    ["c4"] = true,
    ["hood"] = true,
    ["handcuff"] = true
}

StoreLink = {
    ["Santa"] = "https://loja.cidadesantarp.com/",
    ["Galaxy"] = "https://lojagalaxy.santagroup.gg/",
    ["Universo"] = "https://loja.universoroleplay.com/",
    ["CidadeNobre"] = "https://loja.cidadenobre.com/",
    ["Boomerang"] = "https://storee.boomerangroleplay.com/",
    ["Malta"] = "https://loja.maltarp.com/",
    ["Kingdom"] = "https://storee.kngestate.com/?currency=GBP",
    ["Imperium"] = "https://store.imperium.com/",
    ["GoatRP"] = "https://boutique.goatrp.gg/",
    ["District99"] = "https://store.district99.gg/",
    ["Krown"] = "https://store.krownrp.com/",
    ["Orizon"] = "https://store.orizonrp.gg/",
    ["Liberty99"] = "https://store.liberty99rp.com/",
    ["Royal"] = "https://storee.royalukrp.com/",
    ["Real"] = "https://tienda.realrp.es/",
    ["Prime"] = "https://tienda.primerp.gg/",
    ["Grande"] = "https://loja.cidadegrande.com/",
    ["Fronteira"] = "https://fronteirarp.hydrus.gg/",
    ["Alexandria"] = "https://loja.alexandriarp.com/",
    ["Maresia"] = "https://loja.maresiarp.com/",
    ["Gaules"] = "https://lojagaules.santagroup.gg/",
}

Logos = {
    ["Dev-Season3"] = "./assets/images/logo.webp",
    ["Santa"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/santanew.png",
	["Grande"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/grande2.png",
	["Alexandria"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/alexandria2.png",
	["Maresia"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/newmaresia.png",
	["Galaxy"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/galaxy.png",
    ["Universo"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/universo2.png",
    ["Gaules"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/santanew.png",
    ["Fronteira"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/fronteira.png",
    ["CidadeNobre"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/nobre_2.png",
    ["Boomerang"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/boomerang.webp",
    ["Malta"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/new_malta.png",
    ["Kingdom"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/knglogo.png",
    ["Imperium"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/imperium.png",
    ["GoatRP"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/goatrp.png",
    ["District99"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/District99.png",
    ["Krown"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/krown.png",
    ["Orizon"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/Orizon.png",
    ["Liberty99"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/Liberty99.png",
    ["Royal"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/new_royal.png",
    ["Real"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/real.webp",
    ["Prime"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/prime.png",
}

DiscordConv = {
    ["Dev-Season3"] = "./assets/images/logo.webp",
	["Santa"] = "",
	["Grande"] = "",
	["Alexandria"] = "",
	["Maresia"] = "",
	["Galaxy"] = "",
    ["Universo"] = "",
    ["Gaules"] = "",
    ["Fronteira"] = "",
    ["CidadeNobre"] = "",
    ["Boomerang"] = "",
    ["Malta"] = "",
    ["Kingdom"] = "",
    ["Imperium"] = "",
    ["GoatRP"] = "",
    ["District99"] = "",
    ["Krown"] = "",
    ["Orizon"] = "",
    ["Royal"] = "",
    ["Real"] = "",
    ["Prime"] = "",
}

function GetLogo(City)
    return Logos[City]
end

function GetDiscordConv(City)
    return DiscordConv[City]
end
