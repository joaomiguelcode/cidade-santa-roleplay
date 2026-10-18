game.menuEntries["animations"] = {
    {
        icon = 'smile',
        id = 'open_sentimentals',
        label = _t("open_sentimentals"),
        menu = "sentimentals",
        isEnabled = function( pEntity )
            return true
        end
    },
    {
        icon = 'smile',
        id = 'open_carry',
        label = _t("open_carry"),
        menu = "carry",
        isEnabled = function( pEntity )
            return true
        end
    }, 
    {
        icon = 'smile',
        id = 'open_dance',
        label = _t("open_dance"),
        menu = "dance",
        isEnabled = function( pEntity )
            return true
        end
    },
    {
        icon = 'smile',
        id = 'open_couple',
        label = _t("open_couple"),
        menu = "couple",
        isEnabled = function( pEntity )
            return true
        end
    }

}
game.menuEntries["sentimentals"] = {
    {
        id = "kiss",
        label = _t("kiss"),
        icon = 'smile',
        onSelect = function( currentMenu, itemIndex, pEntity )
            ExecuteCommand("beijar")
        end,
        isEnabled = function( pEntity ) 
            return true
        end
    },
    {
        id = "abraco",
        label = _t("abraco"),
        icon = 'smile',
        onSelect = function( currentMenu, itemIndex, pEntity )
            ExecuteCommand("abraco")
        end,
        isEnabled = function( pEntity ) 
            return true
        end
    },
    {
        id = "abracocintura",
        label = _t("abracocintura"),
        icon = 'smile',
        onSelect = function( currentMenu, itemIndex, pEntity )
            ExecuteCommand("abracocintura")
        end,
        isEnabled = function( pEntity ) 
            return true
        end
    },
    {
        id = "cavalinho",
        label = _t("cavalinho"),
        icon = 'smile',
        onSelect = function( currentMenu, itemIndex, pEntity )
            ExecuteCommand("cavalinho")
        end,
        isEnabled = function( pEntity ) 
            return true
        end
    }
}   
-- Sentimentais
-- beijar
-- abraco
-- abracocintura
-- cavalinho

-- Carregar
-- ombro
-- carregar
-- carregar4
-- carregar2

-- Dançar
-- dancinha1
-- dancinha2
-- dancinha3
-- dancinha4

-- Casal
-- massagemcosta
-- massagemperna
-- maosdadas2
-- maosdadas3


game.menuEntries["carry"] = {
    {
        id = "ombro",
        label = _t("ombro"),
        icon = 'smile',
        onSelect = function( currentMenu, itemIndex, pEntity )
            ExecuteCommand("ombro")
        end,
        isEnabled = function( pEntity ) 
            return true
        end
    },
    {
        id = "carregar",
        label = _t("carregar"),
        icon = 'smile',
        onSelect = function( currentMenu, itemIndex, pEntity )
            ExecuteCommand("carregar")
        end,
        isEnabled = function( pEntity ) 
            return true
        end
    },
    {
        id = "carregar4",
        label = _t("carregar4"),
        icon = 'smile',
        onSelect = function( currentMenu, itemIndex, pEntity )
            ExecuteCommand("carregar4")
        end,
        isEnabled = function( pEntity ) 
            return true
        end
    },
    {
        id = "carregar2",
        label = _t("carregar2"),
        icon = 'smile',
        onSelect = function( currentMenu, itemIndex, pEntity )
            ExecuteCommand("carregar2")
        end,
        isEnabled = function( pEntity ) 
            return true
        end
    }
}

game.menuEntries["dance"] = {
    {
        id = "dancinha1",
        label = _t("dancinha1"),
        icon = 'smile',
        onSelect = function( currentMenu, itemIndex, pEntity )
            ExecuteCommand("dancinha1")
            TriggerServerEvent("missions:server:danceWithPlayer")
        end,
        isEnabled = function( pEntity )
            return true
        end
    },
    {
        id = "dancinha2",
        label = _t("dancinha2"),
        icon = 'smile',
        onSelect = function( currentMenu, itemIndex, pEntity )
            ExecuteCommand("dancinha2")
            TriggerServerEvent("missions:server:danceWithPlayer")
        end,
        isEnabled = function( pEntity )
            return true
        end
    },
    {
        id = "dancinha3",
        label = _t("dancinha3"),
        icon = 'smile',
        onSelect = function( currentMenu, itemIndex, pEntity )
            ExecuteCommand("dancinha3")
            TriggerServerEvent("missions:server:danceWithPlayer")
        end,
        isEnabled = function( pEntity )
            return true
        end
    },
    {
        id = "dancinha4",
        label = _t("dancinha4"),
        icon = 'smile',
        onSelect = function( currentMenu, itemIndex, pEntity )
            ExecuteCommand("dancinha4")
            TriggerServerEvent("missions:server:danceWithPlayer")
        end,
        isEnabled = function( pEntity )
            return true
        end
    }
}
game.menuEntries["couple"] = {
    {
        id = "massagemcosta",
        label = _t("massagemcosta"),
        icon = 'smile',
        onSelect = function( currentMenu, itemIndex, pEntity )
            ExecuteCommand("massagemcosta")
        end,
        isEnabled = function( pEntity ) 
            return true
        end
    },
    {
        id = "massagemperna",
        label = _t("massagemperna"),
        icon = 'smile',
        onSelect = function( currentMenu, itemIndex, pEntity )
            ExecuteCommand("massagemperna")
        end,
        isEnabled = function( pEntity ) 
            return true
        end
    },
    {
        id = "maosdadas2",
        label = _t("maosdadas2"),
        icon = 'smile',
        onSelect = function( currentMenu, itemIndex, pEntity )
            ExecuteCommand("maosdadas2")
        end,
        isEnabled = function( pEntity ) 
            return true
        end
    },
    {
        id = "maosdadas3",
        label = _t("maosdadas3"),
        icon = 'smile',
        onSelect = function( currentMenu, itemIndex, pEntity )
            ExecuteCommand("maosdadas3")
        end,
        isEnabled = function( pEntity ) 
            return true
        end
    }
}   
