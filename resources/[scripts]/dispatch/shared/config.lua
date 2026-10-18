config = {}

-- if a group is here he will not receive any report
config.groupBlacklist = {}

-- if a player shoots more than this number of times in a short period, he will be reported
config.shotThreshold = 5

-- groups that will receive reports
config.receiverGroups = {
    ['Militar'] = true,
    ['Policia'] = true,
    ['Civil'] = true,
    ['Federal'] = true,
    ['Exercito'] = true,
    ['Tatica'] = true,
    ['Prf'] = true
}

config.receiveShotCalls = false

---@type table
---@field type string
---@field title string
---@field code string
---@field action string
---@field cooldown number
---@field isPoliceOption boolean | if the call type is police option, it will be shown in the action buttons
config.callTypes = {
    ['DEFAULT'] = {
        [1] = {
            type = 'Disparos',
            title = 'Arma de fogo',
            code = 'QRU',
            action = '[F2] - Abrir',
            cooldown = 30000,
            isPoliceOption = true
        },
        [2] = {
            type = 'Apoio',
            title = 'Solicitando Apoio',
            code = 'QTH',
            action = '[F2] - Abrir',
            cooldown = 30000,
            isPoliceOption = true
        },
        [3] = {
            type = 'Roubo de loja',
            title = 'Roubo de loja',
            code = 'QTH',
            action = '[F2] - Abrir',
            cooldown = 30000,
            isPoliceOption = false
        },
        [4] = {
            type = 'Roubo de casa',
            title = 'Roubo de casa',
            code = 'QTH',
            action = '[F2] - Abrir',
            cooldown = 30000,
            isPoliceOption = false
        },
        [5] = {
            type = 'Roubo de caixa eletronico',
            title = 'Roubo de caixa eletronico',
            code = 'QTH',
            action = '[F2] - Abrir',
            cooldown = 30000,
            isPoliceOption = false
        },
        [6] = {
            type = 'Corrida em andamento',
            title = 'Corrida em andamento',
            code = 'QTH',
            action = '[F2] - Abrir',
            cooldown = 30000,
            isPoliceOption = false
        },
        [7] = {
            type = 'Roubo de veiculo',
            title = 'Roubo de veiculo',
            code = 'QTH',
            action = '[F2] - Abrir',
            cooldown = 30000,
            isPoliceOption = false
        }
    },
    ['pt-br'] = {
        [1] = {
            type = 'Disparos',
            title = 'Arma de fogo',
            code = 'QRU',
            action = '[F2] - Abrir',
            cooldown = 30000,
            isPoliceOption = true
        },
        [2] = {
            type = 'Apoio',
            title = 'Solicitando Apoio',
            code = 'QTH',
            action = '[F2] - Abrir',
            cooldown = 30000,
            isPoliceOption = true
        },
        [3] = {
            type = 'Roubo de loja',
            title = 'Roubo de loja',
            code = 'QTH',
            action = '[F2] - Abrir',
            cooldown = 30000,
            isPoliceOption = false
        },
        [4] = {
            type = 'Roubo de casa',
            title = 'Roubo de casa',
            code = 'QTH',
            action = '[F2] - Abrir',
            cooldown = 30000,
            isPoliceOption = false
        },
        [5] = {
            type = 'Roubo de caixa eletronico',
            title = 'Roubo de caixa eletronico',
            code = 'QTH',
            action = '[F2] - Abrir',
            cooldown = 30000,
            isPoliceOption = false
        },
        [6] = {
            type = 'Corrida em andamento',
            title = 'Corrida em andamento',
            code = 'QTH',
            action = '[F2] - Abrir',
            cooldown = 30000,
            isPoliceOption = false
        },
        [7] = {
            type = 'Roubo de veiculo',
            title = 'Roubo de veiculo',
            code = 'QTH',
            action = '[F2] - Abrir',
            cooldown = 30000,
            isPoliceOption = false
        }
    },
    ['pt-pt'] = {
        [1] = {
            type = 'Disparos',
            title = 'Arma de fogo',
            code = 'QRU',
            action = '[F2] - Abrir',
            cooldown = 30000,
            isPoliceOption = true
        },
        [2] = {
            type = 'Apoio',
            title = 'Solicitando Apoio',
            code = 'QTH',
            action = '[F2] - Abrir',
            cooldown = 30000,
            isPoliceOption = true
        },
        [3] = {
            type = 'Roubo de loja',
            title = 'Roubo de loja',
            code = 'QTH',
            action = '[F2] - Abrir',
            cooldown = 30000,
            isPoliceOption = false
        },
        [4] = {
            type = 'Roubo de casa',
            title = 'Roubo de casa',
            code = 'QTH',
            action = '[F2] - Abrir',
            cooldown = 30000,
            isPoliceOption = false
        },
        [5] = {
            type = 'Roubo de caixa eletronico',
            title = 'Roubo de caixa eletronico',
            code = 'QTH',
            action = '[F2] - Abrir',
            cooldown = 30000,
            isPoliceOption = false
        },
        [6] = {
            type = 'Corrida em andamento',
            title = 'Corrida em andamento',
            code = 'QTH',
            action = '[F2] - Abrir',
            cooldown = 30000,
            isPoliceOption = false
        },
        [7] = {
            type = 'Roubo de veiculo',
            title = 'Roubo de veiculo',
            code = 'QTH',
            action = '[F2] - Abrir',
            cooldown = 30000,
            isPoliceOption = false
        }
    },
    ['en-us'] = {
        [1] = {
            type = 'Shots fired',
            title = 'Firearm discharge',
            code = '10-71',
            action = '[F2] - Open',
            cooldown = 30000,
            isPoliceOption = true
        },
        [2] = {
            type = 'Backup',
            title = 'Requesting backup',
            code = '10-33',
            action = '[F2] - Open',
            cooldown = 30000,
            isPoliceOption = true
        },
        [3] = {
            type = 'Store robbery',
            title = 'Store robbery',
            code = '10-31',
            action = '[F2] - Open',
            cooldown = 30000,
            isPoliceOption = false
        },
        [4] = {
            type = 'House robbery',
            title = 'House robbery',
            code = '10-31',
            action = '[F2] - Open',
            cooldown = 30000,
            isPoliceOption = false
        },
        [5] = {
            type = 'ATM robbery',
            title = 'ATM robbery',
            code = '10-31',
            action = '[F2] - Open',
            cooldown = 30000,
            isPoliceOption = false
        },
        [6] = {
            type = 'Race in progress',
            title = 'Race in progress',
            code = '10-50',
            action = '[F2] - Open',
            cooldown = 30000,
            isPoliceOption = false
        },
        [7] = {
            type = 'Vehicle theft',
            title = 'Vehicle theft',
            code = '10-65',
            action = '[F2] - Open',
            cooldown = 30000,
            isPoliceOption = false
        }
    },
    ['es-es'] = {
        [1] = {
            type = 'Disparos',
            title = 'Arma de fuego',
            code = 'QRU',
            action = '[F2] - Abrir',
            cooldown = 30000,
            isPoliceOption = true
        },
        [2] = {
            type = 'Apoyo',
            title = 'Solicitando apoyo',
            code = 'QTH',
            action = '[F2] - Abrir',
            cooldown = 30000,
            isPoliceOption = true
        },
        [3] = {
            type = 'Robo de tienda',
            title = 'Robo de tienda',
            code = 'QTH',
            action = '[F2] - Abrir',
            cooldown = 30000,
            isPoliceOption = false
        },
        [4] = {
            type = 'Robo de casa',
            title = 'Robo de casa',
            code = 'QTH',
            action = '[F2] - Abrir',
            cooldown = 30000,
            isPoliceOption = false
        },
        [5] = {
            type = 'Robo de caja electrónica',
            title = 'Robo de caja electrónica',
            code = 'QTH',
            action = '[F2] - Abrir',
            cooldown = 30000,
            isPoliceOption = false
        },
        [6] = {
            type = 'Carrera en curso',
            title = 'Carrera en curso',
            code = 'QTH',
            action = '[F2] - Abrir',
            cooldown = 30000,
            isPoliceOption = false
        },
        [7] = {
            type = 'Robo de vehiculo',
            title = 'Robo de vehiculo',
            code = 'QTH',
            action = '[F2] - Abrir',
            cooldown = 30000,
            isPoliceOption = false
        }
    },
    ['fr-fr'] = {
        [1] = {
            type = 'Tirs',
            title = 'Arme à feu',
            code = 'QRU',
            action = '[F2] - Ouvrir',
            cooldown = 30000,
            isPoliceOption = true
        },
        [2] = {
            type = 'Aide',
            title = 'Demande d\'aide',
            code = 'QTH',
            action = '[F2] - Ouvrir',
            cooldown = 30000,
            isPoliceOption = true
        },
        [3] = {
            type = 'Vol de magasin',
            title = 'Vol de magasin',
            code = 'QTH',
            action = '[F2] - Ouvrir',
            cooldown = 30000,
            isPoliceOption = false
        },
        [4] = {
            type = 'Vol de maison',
            title = 'Vol de maison',
            code = 'QTH',
            action = '[F2] - Ouvrir',
            cooldown = 30000,
            isPoliceOption = false
        },
        [5] = {
            type = 'Vol de distributeur',
            title = 'Vol de distributeur automatique',
            code = 'QTH',
            action = '[F2] - Ouvrir',
            cooldown = 30000,
            isPoliceOption = false
        },
        [6] = {
            type = 'Course en cours',
            title = 'Course en cours',
            code = 'QTH',
            action = '[F2] - Ouvrir',
            cooldown = 30000,
            isPoliceOption = false
        },
        [7] = {
            type = 'Vol de véhicule',
            title = 'Vol de véhicule',
            code = 'QTH',
            action = '[F2] - Ouvrir',
            cooldown = 30000,
            isPoliceOption = false
        }
    },
    ['ar-sa'] = {
        [1] = {
            type = 'إطلاق نار',
            title = 'سلاح ناري',
            code = 'QRU',
            action = '[F2] - فتح',
            cooldown = 30000,
            isPoliceOption = true
        },
        [2] = {
            type = 'دعم',
            title = 'طلب دعم',
            code = 'QTH',
            action = '[F2] - فتح',
            cooldown = 30000,
            isPoliceOption = true
        },
        [3] = {
            type = 'سطو على متجر',
            title = 'سطو على متجر',
            code = 'QTH',
            action = '[F2] - فتح',
            cooldown = 30000,
            isPoliceOption = false
        },
        [4] = {
            type = 'سطو على منزل',
            title = 'سطو على منزل',
            code = 'QTH',
            action = '[F2] - فتح',
            cooldown = 30000,
            isPoliceOption = false
        },
        [5] = {
            type = 'سطو على صراف آلي',
            title = 'سطو على صراف آلي',
            code = 'QTH',
            action = '[F2] - فتح',
            cooldown = 30000,
            isPoliceOption = false
        },
        [6] = {
            type = 'سباق جاري',
            title = 'سباق جاري',
            code = 'QTH',
            action = '[F2] - فتح',
            cooldown = 30000,
            isPoliceOption = false
        },
        [7] = {
            type = 'سرقة مركبة',
            title = 'سرقة مركبة',
            code = 'QTH',
            action = '[F2] - فتح',
            cooldown = 30000,
            isPoliceOption = false
        }
    }
}



config.reportBlips = {
    [1] = {
        timeToDelete = 60000,       -- time in milliseconds to delete the blip
        handler = function(x, y, z) -- editable function to handle the blip creation
            local blip = AddBlipForRadius(x, y, z, 100.0)
            SetBlipColour(blip, 1)
            SetBlipAlpha(blip, 100)
            return blip
        end
    },
    [2] = {
        timeToDelete = 60000,     -- time in milliseconds to delete the blip
        handler = function(x, y, z) -- editable function to handle the blip creation
            local blip = AddBlipForCoord(x, y, z)
            SetBlipColour(blip, 1)
            return blip
        end
    },
    [3] = {
        timeToDelete = 60000,     -- time in milliseconds to delete the blip
        handler = function(x, y, z) -- editable function to handle the blip creation
            local blip = AddBlipForCoord(x, y, z)
            SetBlipColour(blip, 1)
            return blip
        end
    },
    [4] = {
        timeToDelete = 60000,     -- time in milliseconds to delete the blip
        handler = function(x, y, z) -- editable function to handle the blip creation
            local blip = AddBlipForCoord(x, y, z)
            SetBlipColour(blip, 1)
            return blip
        end
    },
    [5] = {
        timeToDelete = 60000,     -- time in milliseconds to delete the blip
        handler = function(x, y, z) -- editable function to handle the blip creation
            local blip = AddBlipForCoord(x, y, z)
            SetBlipColour(blip, 1)
            return blip
        end
    },
    [6] = {
        timeToDelete = 60000,     -- time in milliseconds to delete the blip
        handler = function(x, y, z) -- editable function to handle the blip creation
            local blip = AddBlipForCoord(x, y, z)
            SetBlipColour(blip, 1)
            return blip
        end
    },
    [7] = {
        timeToDelete = 60000,     -- time in milliseconds to delete the blip
        handler = function(x, y, z) -- editable function to handle the blip creation
            local blip = AddBlipForCoord(x, y, z)
            SetBlipColour(blip, 1)
            return blip
        end
    }
}
