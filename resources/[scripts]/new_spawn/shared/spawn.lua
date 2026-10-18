cityName = GetConvar("cityName","")
SpawnPedsCoords = {
    centralCoords = vector4(-791.40,334.38,210.83,180.50)
}

defaultSpawn = vector4(165.66,-999.42,29.34,0.0)

if cityName == "CidadeNobre" then
    SpawnPedsCoords.centralCoords = vector4(-791.40,334.38,210.83,180.50)
elseif cityName == "Santa" then
    SpawnPedsCoords.centralCoords = vector4(-791.40,334.38,210.83,180.50)
elseif cityName == "Maresia" then
    SpawnPedsCoords.centralCoords = vector4(-791.40,334.38,210.83,180.50)
elseif cityName == "Boomerang" then
    SpawnPedsCoords.centralCoords = vector4(-2008.72,-633.80,18.70,301.51)
elseif cityName == "Universo" then
    SpawnPedsCoords.centralCoords = vector4(-1609.71,-1046.25,14.12,300.48)
elseif cityName == "Royal" then
    SpawnPedsCoords.centralCoords = vector4(-1609.71,-1046.25,14.12,300.48)
end

function GetSpawnPedCoords()
    return SpawnPedsCoords
end
exports("GetSpawnPedCoords",GetSpawnPedCoords)

FirstSpawnPositions = {
    vector3(-1037.7,-2737.5,13.78),
    vector3(-1646.41,-1102.18,13.01),
}

if cityName == "Santa" then
    FirstSpawnPositions = {
        vector3(-1647.74,-1102.27,13.02),
    }
elseif cityName == "CidadeNobre" then
    FirstSpawnPositions = {
        vector3(-1647.74,-1102.27,13.02),
    }
elseif cityName == "Maresia" then
    FirstSpawnPositions = {
        vector3(1166.37,-1524.15,34.84),
        vector3(-1675.61,-1110.98,13.29),
        vector3(163.16,-975.03,29.76),
        vector3(-1072.12,-2061.33,13.28),
    }
elseif cityName == "Orizon" then
    FirstSpawnPositions = {
        vector3(1166.37,-1524.15,34.84),
        vector3(-1675.61,-1110.98,13.29),
        vector3(163.16,-975.03,29.76),
        vector3(-1072.12,-2061.33,13.28),
    }
elseif cityName == "Alexandria" then
    FirstSpawnPositions = {
        vector3(-1647.74,-1102.27,13.02),
    }
elseif cityName == "Boomerang" then
    FirstSpawnPositions = {
        vector3(-1647.74,-1102.27,13.02),
    }
elseif cityName == "Grande" then
    FirstSpawnPositions = {
        vector3(-1671.78,-1108.65,13.29),
    }
elseif cityName == "Fronteira" then
    FirstSpawnPositions = {
        vector3(-1647.74,-1102.27,13.02),
    }
elseif cityName == "Malta" then
    FirstSpawnPositions = {
        vector3(-1646.59,-1103.76,13.01),
    }
elseif cityName == "Kingdom" then
    FirstSpawnPositions = {
        vector3(-1646.83,-1102.9,13.01),
    }
elseif cityName == "Imperium" then
    FirstSpawnPositions = {
        vector3(-1646.83,-1102.9,13.01),
    }
elseif cityName == "GoatRP" then
    FirstSpawnPositions = {
        vector3(-1646.83,-1102.9,13.01),
    }
elseif cityName == "District99" then
    FirstSpawnPositions = {
        vector3(-1646.83,-1102.9,13.01),
    }
elseif cityName == "Krown" then
    FirstSpawnPositions = {
        vector3(-1646.83,-1102.9,13.01),
    }
elseif cityName == "Orizon" then
    FirstSpawnPositions = {
        vector3(-1646.83,-1102.9,13.01),
    }
elseif cityName == "Liberty99" then
    FirstSpawnPositions = {
        vector3(-1646.83,-1102.9,13.01),
    }
elseif cityName == "Royal" then
    FirstSpawnPositions = {
        vector3(-1667.69,-1100.82,13.28),
    }
elseif cityName == "Real" then
    FirstSpawnPositions = {
        vector3(-1646.83,-1102.9,13.01),
    }
elseif cityName == "Prime" then
    FirstSpawnPositions = {
        vector3(-1646.83,-1102.9,13.01),
    }
elseif cityName == "Universo" then
    FirstSpawnPositions = {
        vector3(-1675.61,-1110.98,13.29),
    }
end

exports('IsOutsideFirstSpawnArea', function(source, radius)

    if not IsDuplicityVersion() then return false end
    local ped = GetPlayerPed(source)
    if ped == 0 then return false end
    local coords = GetEntityCoords(ped)
    local limit = tonumber(radius) or 120.0

    for _, spawn in ipairs(FirstSpawnPositions) do
        if #(coords - spawn) <= limit then return false end
    end

    return true
end)

Spawns = {
    ["Santa"] = {
        {
            name = "PRAÇA",
            coords = {x = 165.66, y = -999.42, z = 29.34},
        },
        {
            name = "DP",
            coords = {x = 2489.42, y = -382.61, z = 93.74},
        },
        {
            name = "HP",
            coords = {x = -308.2, y = -598.1, z = 32.81},
        },
        {
            name = "PÍER",
            coords = {x = -1607.6, y = -1054.1, z = 13.02},
        }
    },
    ["CidadeNobre"] = {
        {
            name = "PRAÇA",
            coords = {x = 165.66, y = -999.42, z = 29.34},
        },
        {
            name = "DP",
            coords = {x = 2489.42, y = -382.61, z = 93.74},
        },
        {
            name = "HP",
            coords = {x = -938.86, y = -766.44, z = 18.92},
        },
        {
            name = "PÍER",
            coords = {x = -1607.6, y = -1054.1, z = 13.02},
        }
    },
    ["Boomerang"] = {
        {
            name = "SQUARE",
            coords = {x = 165.66, y = -999.42, z = 29.34},
        },
        {
            name = "POLICE STATION",
            coords = {x = 2489.42, y = -382.61, z = 93.74},
        },
        {
            name = "HP",
            coords = {x = 1152.08, y = -1527.17, z = 34.83},
        },
        {
            name = "PIER",
            coords = {x = -1607.6, y = -1054.1, z = 13.02},
        }
    },
    ["Grande"] = {
        {
            name = "PRAÇA",
            coords = {x = 165.66, y = -999.42, z = 29.34},
        },
        {
            name = "DP",
            coords = {x = 2489.42, y = -382.61, z = 93.74},
        },
        {
            name = "HP",
            coords = {x = -323.61, y = -610.78, z = 32.82},
        },
        {
            name = "PÍER",
            coords = {x = -1607.6, y = -1054.1, z = 13.02},
        }
    },
    ["Fronteira"] = {
        {
            name = "PRAÇA",
            coords = {x = 165.66, y = -999.42, z = 29.34},
        },
        {
            name = "DP",
            coords = {x = 2489.42, y = -382.61, z = 93.74},
        },
        {
            name = "HP",
            coords = {x = 1152.08, y = -1527.17, z = 34.83},
        },
        {
            name = "PÍER",
            coords = {x = -1607.6, y = -1054.1, z = 13.02},
        }
    },
    ["Maresia"] = {
        {
            name = "PRAÇA",
            coords = {x = 165.66, y = -999.42, z = 29.34},
        },
        {
            name = "DP",
            coords = {x = 2489.42, y = -382.61, z = 93.74},
        },
        {
            name = "HP",
            coords = {x = 1152.08, y = -1527.17, z = 34.83},
        },
        {
            name = "PÍER",
            coords = {x = -1607.6, y = -1054.1, z = 13.02},
        }
    },
    ["Universo"] = {
        {
            name = "PRAÇA",
            coords = {x = 165.66, y = -999.42, z = 29.34},
        },
        {
            name = "DP",
            coords = {x = -823.18, y = -1223.22, z = 7.33},
        },
        {
            name = "HP",
            coords = {x = 1152.08, y = -1527.17, z = 34.83},
        },
        {
            name = "PÍER",
            coords = {x = -1598.63, y = -1023.42, z = 13.26},
        }
    },
    ["Alexandria"] = {
        {
            name = "PRAÇA",
            coords = {x = 165.66, y = -999.42, z = 29.34},
        },
        {
            name = "DP",
            coords = {x = 2489.42, y = -382.61, z = 93.74},
        },
        {
            name = "HP",
            coords = {x = 1152.08, y = -1527.17, z = 34.83},
        },
        {
            name = "PÍER",
            coords = {x = -1607.6, y = -1054.1, z = 13.02},
        }
    },
    ["Malta"] = {
        {
            name = "PRAÇA",
            coords = {x = 165.66, y = -999.42, z = 29.34},
        },
        {
            name = "DP",
            coords = {x = 2489.42, y = -382.61, z = 93.74},
        },
        {
            name = "HP",
            coords = {x = -316.15, y = -603.36, z = 32.84},
        },
        {
            name = "PÍER",
            coords = {x = -1607.6, y = -1054.1, z = 13.02},
        }
    },
    ["Kingdom"] = {
        {
            name = "SQUARE",
            coords = {x = 165.66, y = -999.42, z = 29.34},
        },
        {
            name = "POLICE STATION",
            coords = {x = 2489.42, y = -382.61, z = 93.74},
        },
        {
            name = "HOSPITAL",
            coords = {x = -316.15, y = -603.36, z = 32.84},
        },
        {
            name = "PIER",
            coords = {x = -1607.6, y = -1054.1, z = 13.02},
        }
    },
    ["Imperium"] = {
        {
            name = "SQUARE",
            coords = {x = 165.66, y = -999.42, z = 29.34},
        },
        {
            name = "POLICE STATION",
            coords = {x = 2489.42, y = -382.61, z = 93.74},
        },
        {
            name = "HOSPITAL",
            coords = {x = 1152.08, y = -1527.17, z = 34.83},
        },
        {
            name = "PIER",
            coords = {x = -1607.6, y = -1054.1, z = 13.02},
        }
    },
    ["GoatRP"] = {
        {
            name = "PLACE",
            coords = {x = 165.66, y = -999.42, z = 29.34},
        },
        {
            name = "POLICE",
            coords = {x = 2489.42, y = -382.61, z = 93.74},
        },
        {
            name = "HÔPITAL",
            coords = {x = 1152.08, y = -1527.17, z = 34.83},
        },
        {
            name = "PIER",
            coords = {x = -1607.6, y = -1054.1, z = 13.02},
        }
    },
    ["District99"] = {
        {
            name = "SQUARE",
            coords = {x = 165.66, y = -999.42, z = 29.34},
        },
        {
            name = "POLICE STATION",
            coords = {x = 2489.42, y = -382.61, z = 93.74},
        },
        {
            name = "HOSPITAL",
            coords = {x = 1152.08, y = -1527.17, z = 34.83},
        },
        {
            name = "PIER",
            coords = {x = -1607.6, y = -1054.1, z = 13.02},
        }
    },
    ["Krown"] = {
        {
            name = "SQUARE",
            coords = {x = 165.66, y = -999.42, z = 29.34},
        },
        {
            name = "POLICE STATION",
            coords = {x = 2489.42, y = -382.61, z = 93.74},
        },
        {
            name = "HOSPITAL",
            coords = {x = -313.5, y = -606.06, z = 32.77},
        },
        {
            name = "PIER",
            coords = {x = -1607.6, y = -1054.1, z = 13.02},
        }
    },
    ["Orizon"] = {
        {
            name = "الملكية", -- square
            coords = {x = 165.66, y = -999.42, z = 29.34},
        },
        {
            name = "مركز الشرطة", -- police station
            coords = {x = 2489.42, y = -382.61, z = 93.74},
        },
        {
            name = "المستشفى", -- hospital
            coords = {x = 1152.08, y = -1527.17, z = 34.83},
        },
        {
            name = "الرصيف", -- pier
            coords = {x = -1607.6, y = -1054.1, z = 13.02},
        }
    },
    -- ["Orizon"] = {
    --     {
    --         name = "SQUARE",
    --         coords = {x = 165.66, y = -999.42, z = 29.34},
    --     },
    --     {
    --         name = "POLICE STATION",
    --         coords = {x = 2489.42, y = -382.61, z = 93.74},
    --     },
    --     {
    --         name = "HOSPITAL",
    --         coords = {x = 1152.08, y = -1527.17, z = 34.83},
    --     },
    --     {
    --         name = "PIER",
    --         coords = {x = -1607.6, y = -1054.1, z = 13.02},
    --     }
    -- },
    -- ["Orizon"] = {
    --     {
    --         name = "SQUARE",
    --         coords = {x = 165.66, y = -999.42, z = 29.34},
    --     },
    --     {
    --         name = "POLICE STATION",
    --         coords = {x = 2489.42, y = -382.61, z = 93.74},
    --     },
    --     {
    --         name = "HOSPITAL",
    --         coords = {x = 1152.08, y = -1527.17, z = 34.83},
    --     },
    --     {
    --         name = "PIER",
    --         coords = {x = -1607.6, y = -1054.1, z = 13.02},
    --     }
    -- },
    ["Liberty99"] = {
        {
            name = "SQUARE",
            coords = {x = 165.66, y = -999.42, z = 29.34},
        },
        {
            name = "POLICE STATION",
            coords = {x = 2489.42, y = -382.61, z = 93.74},
        },
        {
            name = "HOSPITAL",
            coords = {x = -313.5, y = -606.06, z = 32.77},
        },
        {
            name = "PIER",
            coords = {x = -1607.6, y = -1054.1, z = 13.02},
        }
    },
    ["Royal"] = {
        {
            name = "SQUARE",
            coords = {x = 165.66, y = -999.42, z = 29.34},
        },
        {
            name = "POLICE STATION",
            coords = {x = 2489.42, y = -382.61, z = 93.74},
        },
        {
            name = "HOSPITAL",
            coords = {x = -315.39, y = -603.53, z = 32.85},
        },
        {
            name = "PIER",
            coords = {x = -1607.6, y = -1054.1, z = 13.02},
        }
    },
    ["Real"] = {
        {
            name = "PLAZA",
            coords = {x = 165.66, y = -999.42, z = 29.34},
        },
        {
            name = "ESTACIÓN DE POLICÍA",
            coords = {x = 2489.42, y = -382.61, z = 93.74},
        },
        {
            name = "HOSPITAL",
            coords = {x = 1152.08, y = -1527.17, z = 34.83},
        },
        {
            name = "MUELLE",
            coords = {x = -1607.6, y = -1054.1, z = 13.02},
        }
    },
    ["Prime"] = {
        {
            name = "PLAZA",
            coords = {x = 165.66, y = -999.42, z = 29.34},
        },
        {
            name = "ESTACIÓN DE POLICÍA",
            coords = {x = 2489.42, y = -382.61, z = 93.74},
        },
        {
            name = "HOSPITAL",
            coords = {x = 1152.08, y = -1527.17, z = 34.83},
        },
        {
            name = "MUELLE",
            coords = {x = -1607.6, y = -1054.1, z = 13.02},
        }
    },
}
