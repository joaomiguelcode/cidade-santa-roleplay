---@alias garages.LiveryItem table<string, table<string, number>>

---@type table<string, garages.LiveryItem>
local LIST_LIVERIES_BY_CITIES = {}

LIST_LIVERIES_BY_CITIES["Prime"] = {
    ["VipLegalExercito"] = {
        ["gstetrk5polng"] = 3,
        ["gsts128polng"] = 3,
        ["gstcns3polng"] = 3,
    },
    ["VipLegalPrf"] = {
        ["gstetrk5polng"] = 8,
        ["gsts128polng"] = 8,
        ["gstcns3polng"] = 8,
    },
    ["VipLegalBombeiros"] = {
        ["gstetrk5polng"] = 7,
        ["gsts128polng"] = 7,
        ["gstcns3polng"] = 7,
    },
    ["VipLegalParamedic"] = {
        ["gstetrk5polng"] = 6,
        ["gsts128polng"] = 6,
        ["gstcns3polng"] = 6,
    },
    ["VipLegalMechanic"] = {
        ["gstetrk5polng"] = 4,
        ["gsts128polng"] = 4,
        ["gstcns3polng"] = 4,
    },
    ["VipLegalJuridico"] = {
        ["gstetrk5polng"] = 5,
        ["gsts128polng"] = 5,
        ["gstcns3polng"] = 5,
    },
    ["VipLegalTatica"] = {
        ["gstetrk5polng"] = 2,
        ["gsts128polng"] = 2,
        ["gstcns3polng"] = 2,
    },
    ["VipLegalCivil"] = {
        ["gstetrk5polng"] = 1,
        ["gsts128polng"] = 1,
        ["gstcns3polng"] = 1,
    },
    ["VipLegalMilitar"] = {
        ["gstetrk5polng"] = 0,
        ["gsts128polng"] = 0,
        ["gstcns3polng"] = 0,
    },
    ["Bombeiros"] = {
        ["rvfiretrukbomb"] = 7,
        ["rvverusbomb"] = 7,
        ["rvjoggerall"] = 7,
        ["rvpolmavall"] = 7,
        ["rvcaracaraall"] = 7,
        ["sg1150all"] = 7,
    },
    ["BombeirosHeli"] = {
        ["rvpolmavall"] = 7,
    },
    ["Policia"] = {
        ["rvpolmavall"] = 1,
    },
    ["Exercito"] = {
        ["rvpolmavall"] = 3,
        ["rvcaracaraall"] = 3,
        ["sg1150all"] = 3,
        ["rvaleutianpol"] = 3,
        ["rvkomodapol"] = 3,
        ["rvsugoipol"] = 3,
        ["rvbf400pol"] = 3,
        ["rvgrangerpol"] = 3,
        ["rvterminuspol"] = 3,
    },
    ["Paramedic"] = {
        ["rvpolmavall"] = 6,
        ["rvjoggerall"] = 6,
        ["sg1150all"] = 6,
        ["rvoutlawhp"] = 6,
        ["emsscout"] = 6,
        ["rvbuffalohp"] = 6,
    },
    ["Mechanic"] = {
        ["rvcaracaramec"] = 4,
        ["dlbisontow"] = 4,
        ["rvoutlawmec"] = 4,
        ["rveveronmec"] = 4,
    },
    ["Juridico"] = {
        ["rvvstrjur"] = 5,
        ["rvballerjur"] = 5,
        ["KHeliJuri"] = 5,
    },
    ["Tatica"] = {
        ["rvpolmavall"] = 2,
        ["sg1150all"] = 2,
        ["rvaleutianpol"] = 2,
        ["rvkomodapol"] = 2,
        ["rvsugoipol"] = 2,
    },
    ["Civil"] = {
        ["rvpolmavall"] = 1,
        ["rvcaracaraall"] = 1,
        ["sg1150all"] = 1,
        ["rvaleutianpol"] = 1,
        ["rvkomodapol"] = 1,
        ["rvsugoipol"] = 1,
    },
    ["Militar"] = {
        ["rvpolmavall"] = 0,
        ["rvcaracaraall"] = 0,
        ["sg1150all"] = 0,
        ["rvaleutianpol"] = 0,
        ["rvkomodapol"] = 0,
        ["rvsugoipol"] = 0,
    }
}
LIST_LIVERIES_BY_CITIES["Boomerang"] = {
    -- ["Bombeiros"] = {
    --     ["firetruk"] = 7,
    --     ["rvverusbomb"] = 7,
    --     ["rvjoggerall"] = 7,
    --     ["rvpolmavall"] = 7,
    --     ["rvcaracaraall"] = 7,
    --     ["sg1150all"] = 7,
    -- },
    -- ["BombeirosHeli"] = {
    --     ["rvpolmavall"] = 7,
    -- },
    -- ["Policia"] = {
    --     ["rvpolmavall"] = 1,
    -- },
    -- ["Exercito"] = {
    --     ["rvpolmavall"] = 3,
    --     ["rvcaracaraall"] = 3,
    --     ["sg1150all"] = 3,
    --     ["rvaleutianpol"] = 3,
    --     ["rvkomodapol"] = 3,
    --     ["rvsugoipol"] = 3,
    --     ["rvbf400pol"] = 3,
    --     ["rvgrangerpol"] = 3,
    --     ["rvterminuspol"] = 3,
    -- },
    -- ["Paramedic"] = {
    --     ["rvpolmavall"] = 6,
    --     ["rvjoggerall"] = 6,
    --     ["sg1150all"] = 6,
    --     ["rvoutlawhp"] = 6,
    --     ["emsscout"] = 6,
    --     ["rvbuffalohp"] = 6,
    -- },
    -- ["Mechanic"] = {
    --     ["rvcaracaramec"] = 4,
    --     ["dlbisontow"] = 4,
    --     ["rvoutlawmec"] = 4,
    --     ["rveveronmec"] = 4,
    -- },
    ["Juridico"] = {
        ["rvvstrjur"] = 5,
        ["rvballerjur"] = 5,
        ["KHeliJuri"] = 5,
    }
    -- ["Tatica"] = {
    --     ["rvpolmavall"] = 2,
    --     ["sg1150all"] = 2,
    --     ["rvaleutianpol"] = 2,
    --     ["rvkomodapol"] = 2,
    --     ["rvsugoipol"] = 2,
    -- },
    -- ["Civil"] = {
    --     ["rvpolmavall"] = 1,
    --     ["rvcaracaraall"] = 1,
    --     ["sg1150all"] = 1,
    --     ["rvaleutianpol"] = 1,
    --     ["rvkomodapol"] = 1,
    --     ["rvsugoipol"] = 1,
    -- },
    -- ["Militar"] = {
    --     ["rvpolmavall"] = 0,
    --     ["rvcaracaraall"] = 0,
    --     ["sg1150all"] = 0,
    --     ["rvaleutianpol"] = 0,
    --     ["rvkomodapol"] = 0,
    --     ["rvsugoipol"] = 0,
    -- }
}
LIST_LIVERIES_BY_CITIES["GoatRP"] = {
    ["Bombeiros"] = {
        ["firetruk"] = 7,
        ["rvverusbomb"] = 7,
        ["rvjoggerall"] = 7,
        ["rvpolmavall"] = 7,
        ["rvcaracaraall"] = 7,
        ["sg1150all"] = 7,
    },
    ["BombeirosHeli"] = {
        ["rvpolmavall"] = 7,
    },
    ["Policia"] = {
        ["rvpolmavall"] = 1,
    },
    ["Exercito"] = {
        ["rvpolmavall"] = 3,
        ["rvcaracaraall"] = 3,
        ["sg1150all"] = 3,
        ["rvaleutianpol"] = 3,
        ["rvkomodapol"] = 3,
        ["rvsugoipol"] = 3,
        ["rvbf400pol"] = 3,
        ["rvgrangerpol"] = 3,
        ["rvterminuspol"] = 3,
    },
    ["Paramedic"] = {
        ["rvpolmavall"] = 6,
        ["rvjoggerall"] = 6,
        ["sg1150all"] = 6,
        ["rvoutlawhp"] = 6,
        ["emsscout"] = 6,
        ["rvbuffalohp"] = 6,
    },
    ["Mechanic"] = {
        ["rvcaracaramec"] = 4,
        ["dlbisontow"] = 4,
        ["rvoutlawmec"] = 4,
        ["rveveronmec"] = 4,
    },
    ["Juridico"] = {
        ["rvvstrjur"] = 5,
        ["rvballerjur"] = 5,
        ["KHeliJuri"] = 5,
    },
    ["Tatica"] = {
        ["rvpolmavall"] = 2,
        ["sg1150all"] = 2,
        ["rvaleutianpol"] = 2,
        ["rvkomodapol"] = 2,
        ["rvsugoipol"] = 2,
    },
    ["Civil"] = {
        ["rvpolmavall"] = 1,
        ["rvcaracaraall"] = 1,
        ["sg1150all"] = 1,
        ["rvaleutianpol"] = 1,
        ["rvkomodapol"] = 1,
        ["rvsugoipol"] = 1,
    },
    ["Militar"] = {
        ["rvpolmavall"] = 0,
        ["rvcaracaraall"] = 0,
        ["sg1150all"] = 0,
        ["rvaleutianpol"] = 0,
        ["rvkomodapol"] = 0,
        ["rvsugoipol"] = 0,
    }
}
LIST_LIVERIES_BY_CITIES["Grande"] = {
    ["VipLegalExercito"] = {
        ["gstetrk5polng"] = 3,
        ["gsts128polng"] = 3,
        ["gstcns3polng"] = 3,
    },
    ["VipLegalPrf"] = {
        ["gstetrk5polng"] = 8,
        ["gsts128polng"] = 8,
        ["gstcns3polng"] = 8,
    },
    ["VipLegalBombeiros"] = {
        ["gstetrk5polng"] = 7,
        ["gsts128polng"] = 7,
        ["gstcns3polng"] = 7,
    },
    ["VipLegalParamedic"] = {
        ["gstetrk5polng"] = 6,
        ["gsts128polng"] = 6,
        ["gstcns3polng"] = 6,
    },
    ["VipLegalMechanic"] = {
        ["gstetrk5polng"] = 4,
        ["gsts128polng"] = 4,
        ["gstcns3polng"] = 4,
    },
    ["VipLegalJuridico"] = {
        ["gstetrk5polng"] = 5,
        ["gsts128polng"] = 5,
        ["gstcns3polng"] = 5,
    },
    ["VipLegalTatica"] = {
        ["gstetrk5polng"] = 2,
        ["gsts128polng"] = 2,
        ["gstcns3polng"] = 2,
    },
    ["VipLegalCivil"] = {
        ["gstetrk5polng"] = 1,
        ["gsts128polng"] = 1,
        ["gstcns3polng"] = 1,
    },
    ["VipLegalMilitar"] = {
        ["gstetrk5polng"] = 0,
        ["gsts128polng"] = 0,
        ["gstcns3polng"] = 0,
    },
    ["Prf"] = {
        ["rvkomodapol"] = 8,
        ["sg1150all"] = 8,
        ["rvsugoipol"] = 8,
        ["rvaleutianpol"] = 8,
        ["rvpolmavall"] = 8,
        ["rvcaracaraall"] = 8,
        ["rvgrangerpol"] = 8,
    },
    ["Bombeiros"] = {
        ["firetruk"] = 7,
        ["rvjoggerall"] = 7,
        ["sg1150all"] = 7,
        ["rvpolmavall"] = 7,
        ["rvverusbomb"] = 7,
        ["rvcaracaraall"] = 7,
        ["rvfiretrukbomb"] = 7,
        ["polmav"] = 1,
    },
    ["BombeirosHeli"] = {
        ["rvpolmavall"] = 7,
    },
    ["Policia"] = {
        ["rvpolmavall"] = 1,
    },
    ["Exercito"] = {
        ["rvkomodapol"] = 3,
        ["sg1150all"] = 3,
        ["rvsugoipol"] = 3,
        ["rvaleutianpol"] = 3,
        ["rvpolmavall"] = 3,
        ["rvcaracaraall"] = 3,
        ["rvgrangerpol"] = 3,
        ["rvterminuspol"] = 3,
        ["titan"] = 3,
    },
    ["Paramedic"] = {
        ["rvjoggerall"] = 6,
        ["rvoutlawhp"] = 6,
        ["rvpolmavall"] = 6,
        ["sg1150all"] = 6,
        ["emsscout"] = 6,
        ["rvbuffalohp"] = 6,
    },
    ["Mechanic"] = {
        ["rvcaracaramec"] = 4,
        ["dlbisontow"] = 4,
        ["rvoutlawmec"] = 4,
        ["rveveronmec"] = 4,
    },
    ["Juridico"] = {
        ["rvvstrjur"] = 5,
        ["rvballerjur"] = 5,
        ["KHeliJuri"] = 5,
    },
    ["Tatica"] = {
        ["rvkomodapol"] = 2,
        ["sg1150all"] = 2,
        ["rvsugoipol"] = 2,
        ["rvaleutianpol"] = 2,
        ["rvpolmavall"] = 2,
        ["rvcaracara6x6pol"] = 2,
    },
    ["Civil"] = {
        ["rvkomodapol"] = 1,
        ["sg1150all"] = 1,
        ["rvsugoipol"] = 1,
        ["rvaleutianpol"] = 1,
        ["rvpolmavall"] = 1,
        ["rvcaracaraall"] = 1,
        ["rvcavalcadepol"] = 1,
        ["rvdeitypol"] = 1,
    },
    ["Militar"] = {
        ["rvkomodapol"] = 0,
        ["sg1150all"] = 0,
        ["rvsugoipol"] = 0,
        ["rvaleutianpol"] = 0,
        ["rvpolmavall"] = 0,
        ["rvcoquettepol"] = 0,
        ["rvcaracaraall"] = 0,
        ["rvriotpol"] = 0,
        ["rvsentinelpol"] = 0,
    }
}
LIST_LIVERIES_BY_CITIES["CidadeNobre"] = {
    ["VipLegalExercito"] = {
        ["gstetrk5polng"] = 3,
        ["gsts128polng"] = 3,
        ["gstcns3polng"] = 3,
    },
    ["VipLegalPrf"] = {
        ["gstetrk5polng"] = 8,
        ["gsts128polng"] = 8,
        ["gstcns3polng"] = 8,
    },
    ["VipLegalBombeiros"] = {
        ["gstetrk5polng"] = 7,
        ["gsts128polng"] = 7,
        ["gstcns3polng"] = 7,
    },
    ["VipLegalParamedic"] = {
        ["gstetrk5polng"] = 6,
        ["gsts128polng"] = 6,
        ["gstcns3polng"] = 6,
    },
    ["VipLegalMechanic"] = {
        ["gstetrk5polng"] = 4,
        ["gsts128polng"] = 4,
        ["gstcns3polng"] = 4,
    },
    ["VipLegalJuridico"] = {
        ["gstetrk5polng"] = 5,
        ["gsts128polng"] = 5,
        ["gstcns3polng"] = 5,
    },
    ["VipLegalTatica"] = {
        ["gstetrk5polng"] = 2,
        ["gsts128polng"] = 2,
        ["gstcns3polng"] = 2,
    },
    ["VipLegalCivil"] = {
        ["gstetrk5polng"] = 1,
        ["gsts128polng"] = 1,
        ["gstcns3polng"] = 1,
    },
    ["VipLegalMilitar"] = {
        ["gstetrk5polng"] = 0,
        ["gsts128polng"] = 0,
        ["gstcns3polng"] = 0,
    },
    ["Prf"] = {
        ["rvkomodapol"] = 8,
        ["rvbf400pol"] = 8,
        ["rvsugoipol"] = 8,
        ["rvaleutianpol"] = 8,
        ["rvpolmavall"] = 8,
        ["rvcaracaraall"] = 8,
        ["rvgrangerpol"] = 8,
    },
    ["Bombeiros"] = {
        ["rvfiretrukbomb"] = 7,
        ["rvjoggerall"] = 7,
        ["rvbf400pol"] = 7,
        ["rvpolmavall"] = 7,
        ["rvverusbomb"] = 7,
        ["rvcaracaraall"] = 7,
    },
    ["BombeirosHeli"] = {
        ["rvpolmavall"] = 7,
    },
    ["Policia"] = {
        ["rvpolmavall"] = 1,
    },
    ["Exercito"] = {
        ["rvkomodapol"] = 3,
        ["rvbf400pol"] = 3,
        ["rvsugoipol"] = 3,
        ["rvaleutianpol"] = 3,
        ["rvpolmavall"] = 3,
        ["rvcaracaraall"] = 3,
        ["rvgrangerpol"] = 3,
        ["rvterminuspol"] = 3,
    },
    ["Paramedic"] = {
        ["rvjoggerall"] = 6,
        ["rvoutlawhp"] = 6,
        ["rvpolmavall"] = 6,
        ["rvbf400pol"] = 6,
        ["emsscout"] = 6,
        ["rvbuffalohp"] = 6,
    },
    ["Mechanic"] = {
        ["rvcaracaramec"] = 4,
        ["dlbisontow"] = 4,
        ["rvoutlawmec"] = 4,
        ["rveveronmec"] = 4,
    },
    ["Juridico"] = {
        ["rvvstrjur"] = 5,
        ["rvballerjur"] = 5,
        ["KHeliJuri"] = 5,
    },
    ["Tatica"] = {
        ["rvkomodapol"] = 2,
        ["rvbf400pol"] = 2,
        ["rvsugoipol"] = 2,
        ["rvaleutianpol"] = 2,
        ["rvpolmavall"] = 2,
        ["rvcaracara6x6pol"] = 2,
    },
    ["Civil"] = {
        ["rvkomodapol"] = 1,
        ["rvbf400pol"] = 1,
        ["rvsugoipol"] = 1,
        ["rvaleutianpol"] = 1,
        ["rvpolmavall"] = 1,
        ["rvcaracaraall"] = 1,
        ["rvcavalcadepol"] = 1,
        ["rvdeitypol"] = 1,
    },
    ["Militar"] = {
        ["rvkomodapol"] = 0,
        ["rvbf400pol"] = 0,
        ["rvsugoipol"] = 0,
        ["rvaleutianpol"] = 0,
        ["rvpolmavall"] = 0,
        ["rvcoquettepol"] = 0,
        ["rvcaracaraall"] = 0,
        ["rvriotpol"] = 0,
        ["rvsentinelpol"] = 0,
    }
}
LIST_LIVERIES_BY_CITIES["Santa"] = {

    ["VipLegalExercito"] = {
        ["gstetrk5polng"] = 3,
        ["gsts128polng"] = 3,
        ["gstcns3polng"] = 3,
    },
    ["VipLegalPrf"] = {
        ["gstetrk5polng"] = 8,
        ["gsts128polng"] = 8,
        ["gstcns3polng"] = 8,
    },
    ["VipLegalBombeiros"] = {
        ["gstetrk5polng"] = 7,
        ["gsts128polng"] = 7,
        ["gstcns3polng"] = 7,
    },
    ["VipLegalParamedic"] = {
        ["gstetrk5polng"] = 6,
        ["gsts128polng"] = 6,
        ["gstcns3polng"] = 6,
    },
    ["VipLegalMechanic"] = {
        ["gstetrk5polng"] = 4,
        ["gsts128polng"] = 4,
        ["gstcns3polng"] = 4,
    },
    ["VipLegalJuridico"] = {
        ["gstetrk5polng"] = 5,
        ["gsts128polng"] = 5,
        ["gstcns3polng"] = 5,
    },
    ["VipLegalTatica"] = {
        ["gstetrk5polng"] = 2,
        ["gsts128polng"] = 2,
        ["gstcns3polng"] = 2,
    },
    ["VipLegalCivil"] = {
        ["gstetrk5polng"] = 1,
        ["gsts128polng"] = 1,
        ["gstcns3polng"] = 1,
    },
    ["VipLegalMilitar"] = {
        ["gstetrk5polng"] = 0,
        ["gsts128polng"] = 0,
        ["gstcns3polng"] = 0,
    },
    ["Prf"] = {
        ["rvkomodapol"] = 8,
        ["rvbf400pol"] = 8,
        ["rvsugoipol"] = 8,
        ["rvaleutianpol"] = 8,
        ["rvpolmavall"] = 8,
        ["rvcaracaraall"] = 8,
        ["rvgrangerpol"] = 8,
    },
    ["Bombeiros"] = {
        ["firetruk"] = 7,
        ["rvjoggerall"] = 7,
        ["rvbf400pol"] = 7,
        ["rvpolmavall"] = 7,
        ["rvverusbomb"] = 7,
        ["rvcaracaraall"] = 7,
        ["rvfiretrukbomb"] = 7,
        ["polmav"] = 1,
    },
    ["BombeirosHeli"] = {
        ["rvpolmavall"] = 7,
    },
    ["Policia"] = {
        ["rvpolmavall"] = 1,
    },
    ["Exercito"] = {
        ["rvkomodapol"] = 3,
        ["rvbf400pol"] = 3,
        ["rvsugoipol"] = 3,
        ["rvaleutianpol"] = 3,
        ["rvpolmavall"] = 3,
        ["rvcaracaraall"] = 3,
        ["rvgrangerpol"] = 3,
        ["rvterminuspol"] = 3,
        ["titan"] = 3,
    },
    ["Paramedic"] = {
        ["rvjoggerall"] = 6,
        ["rvoutlawhp"] = 6,
        ["rvpolmavall"] = 6,
        ["rvbf400pol"] = 6,
        ["emsscout"] = 6,
        ["rvbuffalohp"] = 6,
    },
    ["Mechanic"] = {
        ["rvcaracaramec"] = 4,
        ["dlbisontow"] = 4,
        ["rvoutlawmec"] = 4,
        ["rveveronmec"] = 4,
    },
    ["Juridico"] = {
        ["rvvstrjur"] = 5,
        ["rvballerjur"] = 5,
        ["KHeliJuri"] = 5,
    },
    ["Tatica"] = {
        ["rvkomodapol"] = 2,
        ["rvbf400pol"] = 2,
        ["rvsugoipol"] = 2,
        ["rvaleutianpol"] = 2,
        ["rvpolmavall"] = 2,
        ["rvcaracara6x6pol"] = 2,
    },
    ["Civil"] = {
        ["rvkomodapol"] = 1,
        ["rvbf400pol"] = 1,
        ["rvsugoipol"] = 1,
        ["rvaleutianpol"] = 1,
        ["rvpolmavall"] = 1,
        ["rvcaracaraall"] = 1,
        ["rvcavalcadepol"] = 1,
        ["rvdeitypol"] = 1,
    },
    ["Militar"] = {
        ["rvkomodapol"] = 0,
        ["rvbf400pol"] = 0,
        ["rvsugoipol"] = 0,
        ["rvaleutianpol"] = 0,
        ["rvpolmavall"] = 0,
        ["rvcoquettepol"] = 0,
        ["rvcaracaraall"] = 0,
        ["rvriotpol"] = 0,
        ["rvsentinelpol"] = 0,
    },
    ["PoliciaPrisional"] = {
        ["rvkomodapol"] = 0, 
        ["sg1150all"] = 0, 
        ["rvsugoipol"] = 0,
        ["rvaleutianpol"] = 0,
        ["rvpolmavall"] = 0,
        ["rvcoquettepol"] = 0,
        ["rvcaracaraall"] = 0,
        ["rvriotpol"] = 0,
        ["rvbf400pol"] = 0,
    }
}
LIST_LIVERIES_BY_CITIES["District99"] = {
    ["Bombeiros"] = {
        ["firetruk"] = 7,
        ["rvjoggerall"] = 7,
        ["sg1150all"] = 7,
        ["rvpolmavall"] = 7,
        ["rvverusbomb"] = 7,
        ["rvcaracaraall"] = 7,
        ["rvfiretrukbomb"] = 7,
        ["polmav"] = 1,
    },
    ["BombeirosHeli"] = {
        ["rvpolmavall"] = 7,
    },
    ["Policia"] = {
        ["rvpolmavall"] = 1,
    },
    ["Exercito"] = {
        ["rvpolmavall"] = 3,
        ["rvcaracaraall"] = 3,
        ["sg1150all"] = 3,
        ["rvaleutianpol"] = 3,
        ["rvkomodapol"] = 3,
        ["rvsugoipol"] = 3,
    },
    ["Paramedic"] = {
        ["rvjoggerall"] = 6,
        ["rvoutlawhp"] = 6,
        -- ["rvpolmavall"] = 6,
        ["sg1150all"] = 6,
        ["emsscout"] = 6,
        ["rvbuffalohp"] = 6,
    },
    ["Mechanic"] = {
        ["rvcaracaramec"] = 4,
        ["dlbisontow"] = 4,
        ["rvoutlawmec"] = 4,
        ["rveveronmec"] = 4,
    },
    ["Juridico"] = {
        ["rvvstrjur"] = 5,
        ["rvballerjur"] = 5,
        ["KHeliJuri"] = 5,
    },
    ["Tatica"] = {
        ["rvpolmavall"] = 2,
        ["sg1150all"] = 2,
        ["rvaleutianpol"] = 2,
        ["rvkomodapol"] = 2,
        ["rvsugoipol"] = 2,
    },
    ["Civil"] = {
        ["rvpolmavall"] = 1,
        ["rvcaracaraall"] = 1,
        ["sg1150all"] = 1,
        ["rvaleutianpol"] = 1,
        ["rvkomodapol"] = 1,
        ["rvsugoipol"] = 1,
    },
    ["Militar"] = {
        ["rvpolmavall"] = 0,
        ["rvcaracaraall"] = 0,
        ["sg1150all"] = 0,
        ["rvaleutianpol"] = 0,
        ["rvkomodapol"] = 0,
        ["rvsugoipol"] = 0,
    }
}
LIST_LIVERIES_BY_CITIES["Krown"] = {
    ["Bombeiros"] = {
        ["firetruk"] = 7,
        ["rvjoggerall"] = 7,
        ["rvbf400pol"] = 7,
        ["rvpolmavall"] = 7,
        ["rvverusbomb"] = 7,
        ["rvcaracaraall"] = 7,
        ["rvfiretrukbomb"] = 7,
        ["polmav"] = 1,
    },
    ["BombeirosHeli"] = {
        ["rvpolmavall"] = 7,
    },
    ["Policia"] = {
        ["rvpolmavall"] = 1,
    },
    ["Exercito"] = {
        ["rvpolmavall"] = 3,
        ["rvcaracaraall"] = 3,
        ["rvbf400pol"] = 3,
        ["rvaleutianpol"] = 3,
        ["rvkomodapol"] = 3,
        ["rvsugoipol"] = 3,
    },
    ["Paramedic"] = {
        ["rvjoggerall"] = 6,
        ["rvoutlawhp"] = 6,
        -- ["rvpolmavall"] = 6,
        ["rvbf400pol"] = 6,
        ["emsscout"] = 6,
        ["rvbuffalohp"] = 6,
    },
    ["Mechanic"] = {
        ["rvcaracaramec"] = 4,
        ["dlbisontow"] = 4,
        ["rvoutlawmec"] = 4,
        ["rveveronmec"] = 4,
    },
    ["Juridico"] = {
        ["rvvstrjur"] = 5,
        ["rvballerjur"] = 5,
        ["KHeliJuri"] = 5,
    },
    ["Tatica"] = {
        ["rvpolmavall"] = 2,
        ["rvbf400pol"] = 2,
        ["rvaleutianpol"] = 2,
        ["rvkomodapol"] = 2,
        ["rvsugoipol"] = 2,
    },
    ["Civil"] = {
        ["rvpolmavall"] = 1,
        ["rvcaracaraall"] = 1,
        ["rvbf400pol"] = 1,
        ["rvaleutianpol"] = 1,
        ["rvkomodapol"] = 1,
        ["rvsugoipol"] = 1,
    },
    ["Militar"] = {
        ["rvpolmavall"] = 0,
        ["rvcaracaraall"] = 0,
        ["rvbf400pol"] = 0,
        ["rvaleutianpol"] = 0,
        ["rvkomodapol"] = 0,
        ["rvsugoipol"] = 0,
    },
    ["ParamedicHeli"] = {
        ["rvpolmavall"] = 6,
    },
}
LIST_LIVERIES_BY_CITIES["Kingdom"] = {
    ["Bombeiros"] = {
        ["firetruk"] = 7,
        ["rvjoggerall"] = 7,
        ["rvbf400pol"] = 7,
        ["rvpolmavall"] = 7,
        ["rvverusbomb"] = 7,
        ["rvcaracaraall"] = 7,
        ["rvfiretrukbomb"] = 7,
        ["rvbuffalohp"] = 7,
        ["polmav"] = 1,
    },
    ["BombeirosHeli"] = {
        ["rvpolmavall"] = 7,
        ["polmav"] = 7,
    },
    ["Policia"] = {
        ["rvpolmavall"] = 1,
    },
    ["Exercito"] = {
        ["rvpolmavall"] = 3,
        ["rvcaracaraall"] = 3,
        ["rvbf400pol"] = 3,
        ["rvaleutianpol"] = 3,
        ["rvkomodapol"] = 3,
        ["rvsugoipol"] = 3,
    },
    ["Paramedic"] = {
        ["rvjoggerall"] = 6,
        ["rvoutlawhp"] = 6,
        ["rvpolmavall"] = 6,
        ["rvbf400pol"] = 6,
        ["emsscout"] = 6,
        ["rvbuffalohp"] = 6,
    },
    ["Mechanic"] = {
        ["rvcaracaramec"] = 4,
        ["dlbisontow"] = 4,
        ["rvoutlawmec"] = 4,
        ["rveveronmec"] = 4,
    },
    ["Juridico"] = {
        ["rvvstrjur"] = 5,
        ["rvballerjur"] = 5,
        ["KHeliJuri"] = 5,
    },
    ["Tatica"] = {
        ["rvpolmavall"] = 2,
        ["rvbf400pol"] = 2,
        ["rvaleutianpol"] = 2,
        ["rvkomodapol"] = 2,
        ["rvsugoipol"] = 2,
    },
    ["Civil"] = {
        ["rvpolmavall"] = 1,
        ["rvcaracaraall"] = 1,
        ["rvbf400pol"] = 1,
        ["rvaleutianpol"] = 1,
        ["rvkomodapol"] = 1,
        ["rvsugoipol"] = 1,
    },
    ["Militar"] = {
        ["rvpolmavall"] = 0,
        ["rvcaracaraall"] = 0,
        ["rvbf400pol"] = 0,
        ["rvaleutianpol"] = 0,
        ["rvkomodapol"] = 0,
        ["rvsugoipol"] = 0,
    }
}
LIST_LIVERIES_BY_CITIES["Royal"] = {
    ["VipLegalExercito"] = {
        ["gstetrk5polng"] = 3,
        ["gsts128polng"] = 3,
        ["gstcns3polng"] = 3,
    },
    ["VipLegalPrf"] = {
        ["gstetrk5polng"] = 8,
        ["gsts128polng"] = 8,
        ["gstcns3polng"] = 8,
    },
    ["VipLegalBombeiros"] = {
        ["gstetrk5polng"] = 7,
        ["gsts128polng"] = 7,
        ["gstcns3polng"] = 7,
    },
    ["VipLegalParamedic"] = {
        ["gstetrk5polng"] = 6,
        ["gsts128polng"] = 6,
        ["gstcns3polng"] = 6,
    },
    ["VipLegalMechanic"] = {
        ["gstetrk5polng"] = 4,
        ["gsts128polng"] = 4,
        ["gstcns3polng"] = 4,
    },
    ["VipLegalJuridico"] = {
        ["gstetrk5polng"] = 5,
        ["gsts128polng"] = 5,
        ["gstcns3polng"] = 5,
    },
    ["VipLegalTatica"] = {
        ["gstetrk5polng"] = 2,
        ["gsts128polng"] = 2,
        ["gstcns3polng"] = 2,
    },
    ["VipLegalCivil"] = {
        ["gstetrk5polng"] = 1,
        ["gsts128polng"] = 1,
        ["gstcns3polng"] = 1,
    },
    ["VipLegalMilitar"] = {
        ["gstetrk5polng"] = 0,
        ["gsts128polng"] = 0,
        ["gstcns3polng"] = 0,
    },
    ["Prf"] = {
        ["rvkomodapol"] = 8,
        ["rvbf400pol"] = 8,
        ["rvsugoipol"] = 8,
        ["rvaleutianpol"] = 8,
        ["rvpolmavall"] = 8,
        ["rvcaracaraall"] = 8,
        ["rvgrangerpol"] = 8,
    },
    ["Bombeiros"] = {
        ["firetruk"] = 7,
        ["rvjoggerall"] = 7,
        ["rvbf400pol"] = 7,
        ["sg1150all"] = 7,
        ["rvpolmavall"] = 7,
        ["rvverusbomb"] = 7,
        ["rvcaracaraall"] = 7,
        ["rvfiretrukbomb"] = 7,
        ["rvbuffalohp"] = 7,
        ["polmav"] = 1,
    },
    ["BombeirosHeli"] = {
        ["rvpolmavall"] = 7,
        ["polmav"] = 7,
    },
    ["Policia"] = {
        ["rvpolmavall"] = 1,
    },
    ["Exercito"] = {
        ["rvpolmavall"] = 3,
        ["rvcaracaraall"] = 3,
        ["rvbf400pol"] = 3,
        ["rvaleutianpol"] = 3,
        ["rvkomodapol"] = 3,
        ["rvsugoipol"] = 3,
        ["rvgrangerpol"] = 3,
        ["rvterminuspol"] = 3,
        ["titan"] = 3,
    },
    ["Paramedic"] = {
        ["rvjoggerall"] = 6,
        ["rvoutlawhp"] = 6,
        ["rvpolmavall"] = 6,
        ["rvbf400pol"] = 6,
        ["emsscout"] = 6,
        ["rvbuffalohp"] = 6,
    },
    ["Mechanic"] = {
        ["rvcaracaramec"] = 4,
        ["dlbisontow"] = 4,
        ["rvoutlawmec"] = 4,
        ["rveveronmec"] = 4,
    },
    ["Juridico"] = {
        ["rvvstrjur"] = 5,
        ["rvballerjur"] = 5,
        ["KHeliJuri"] = 5,
    },
    ["Tatica"] = {
        ["rvpolmavall"] = 2,
        ["rvbf400pol"] = 2,
        ["rvaleutianpol"] = 2,
        ["rvkomodapol"] = 2,
        ["rvsugoipol"] = 2,
        ["rvcaracara6x6pol"] = 2,
    },
    ["Civil"] = {
        ["rvpolmavall"] = 1,
        ["rvcaracaraall"] = 1,
        ["rvbf400pol"] = 1,
        ["rvaleutianpol"] = 1,
        ["rvkomodapol"] = 1,
        ["rvsugoipol"] = 1,
        ["rvcavalcadepol"] = 1,
        ["rvdeitypol"] = 1,
    },
    ["Militar"] = {
        ["rvpolmavall"] = 0,
        ["rvcaracaraall"] = 0,
        ["rvbf400pol"] = 0,
        ["rvaleutianpol"] = 0,
        ["rvkomodapol"] = 0,
        ["rvsugoipol"] = 0,
        ["rvcoquettepol"] = 0,
        ["rvriotpol"] = 0,
    }
}
LIST_LIVERIES_BY_CITIES["Malta"] = {
    ["VipLegalExercito"] = {
        ["gstetrk5polng"] = 3,
        ["gsts128polng"] = 3,
        ["gstcns3polng"] = 3,
    },
    ["VipLegalPrf"] = {
        ["gstetrk5polng"] = 8,
        ["gsts128polng"] = 8,
        ["gstcns3polng"] = 8,
    },
    ["VipLegalBombeiros"] = {
        ["gstetrk5polng"] = 7,
        ["gsts128polng"] = 7,
        ["gstcns3polng"] = 7,
    },
    ["VipLegalParamedic"] = {
        ["gstetrk5polng"] = 6,
        ["gsts128polng"] = 6,
        ["gstcns3polng"] = 6,
    },
    ["VipLegalMechanic"] = {
        ["gstetrk5polng"] = 4,
        ["gsts128polng"] = 4,
        ["gstcns3polng"] = 4,
    },
    ["VipLegalJuridico"] = {
        ["gstetrk5polng"] = 5,
        ["gsts128polng"] = 5,
        ["gstcns3polng"] = 5,
    },
    ["VipLegalTatica"] = {
        ["gstetrk5polng"] = 2,
        ["gsts128polng"] = 2,
        ["gstcns3polng"] = 2,
    },
    ["VipLegalCivil"] = {
        ["gstetrk5polng"] = 1,
        ["gsts128polng"] = 1,
        ["gstcns3polng"] = 1,
    },
    ["VipLegalMilitar"] = {
        ["gstetrk5polng"] = 0,
        ["gsts128polng"] = 0,
        ["gstcns3polng"] = 0,
    },
    ["Prf"] = {
        ["rvkomodapol"] = 8,
        ["rvbf400pol"] = 8,
        ["rvsugoipol"] = 8,
        ["rvaleutianpol"] = 8,
        ["rvpolmavall"] = 8,
        ["rvcaracaraall"] = 8,
        ["rvgrangerpol"] = 8,
    },
    ["Bombeiros"] = {
        ["rvfiretrukbomb"] = 7,
        ["rvjoggerall"] = 7,
        ["sg1150all"] = 7,
        ["rvpolmavall"] = 7,
        ["rvverusbomb"] = 7,
        ["rvcaracaraall"] = 7,
        ["rvbuffalohp"] = 7,
    },
    ["BombeirosHeli"] = {
        ["rvpolmavall"] = 7,
        ["polmav"] = 7,
    },
    ["Policia"] = {
        ["rvpolmavall"] = 1,
    },
    ["Exercito"] = {
        ["rvpolmavall"] = 3,
        ["rvcaracaraall"] = 3,
        ["rvbf400pol"] = 3,
        ["rvaleutianpol"] = 3,
        ["rvkomodapol"] = 3,
        ["rvsugoipol"] = 3,
    },
    ["Paramedic"] = {
        ["rvjoggerall"] = 6,
        ["rvoutlawhp"] = 6,
        ["rvpolmavall"] = 6,
        ["rvbf400pol"] = 6,
        ["emsscout"] = 6,
        ["rvbuffalohp"] = 6,
    },
    ["Mechanic"] = {
        ["rvcaracaramec"] = 4,
        ["dlbisontow"] = 4,
        ["rvoutlawmec"] = 4,
        ["rveveronmec"] = 4,
    },
    ["Juridico"] = {
        ["rvvstrjur"] = 5,
        ["rvballerjur"] = 5,
        ["KHeliJuri"] = 5,
    },
    ["Tatica"] = {
        ["rvpolmavall"] = 2,
        ["rvbf400pol"] = 2,
        ["rvaleutianpol"] = 2,
        ["rvkomodapol"] = 2,
        ["rvsugoipol"] = 2,
    },
    ["Civil"] = {
        ["rvpolmavall"] = 1,
        ["rvcaracaraall"] = 1,
        ["rvbf400pol"] = 1,
        ["rvaleutianpol"] = 1,
        ["rvkomodapol"] = 1,
        ["rvsugoipol"] = 1,
    },
    ["Militar"] = {
        ["rvpolmavall"] = 0,
        ["rvcaracaraall"] = 0,
        ["rvbf400pol"] = 0,
        ["rvaleutianpol"] = 0,
        ["rvkomodapol"] = 0,
        ["rvsugoipol"] = 0,
    }
}
LIST_LIVERIES_BY_CITIES["Orizon"] = {
    ["VipLegalExercito"] = {
        ["gstetrk5polng"] = 3,
        ["gsts128polng"] = 3,
        ["gstcns3polng"] = 3,
    },
    ["VipLegalPrf"] = {
        ["gstetrk5polng"] = 8,
        ["gsts128polng"] = 8,
        ["gstcns3polng"] = 8,
    },
    ["VipLegalBombeiros"] = {
        ["gstetrk5polng"] = 7,
        ["gsts128polng"] = 7,
        ["gstcns3polng"] = 7,
    },
    ["VipLegalParamedic"] = {
        ["gstetrk5polng"] = 6,
        ["gsts128polng"] = 6,
        ["gstcns3polng"] = 6,
    },
    ["VipLegalMechanic"] = {
        ["gstetrk5polng"] = 4,
        ["gsts128polng"] = 4,
        ["gstcns3polng"] = 4,
    },
    ["VipLegalJuridico"] = {
        ["gstetrk5polng"] = 5,
        ["gsts128polng"] = 5,
        ["gstcns3polng"] = 5,
    },
    ["VipLegalTatica"] = {
        ["gstetrk5polng"] = 2,
        ["gsts128polng"] = 2,
        ["gstcns3polng"] = 2,
    },
    ["VipLegalCivil"] = {
        ["gstetrk5polng"] = 1,
        ["gsts128polng"] = 1,
        ["gstcns3polng"] = 1,
    },
    ["VipLegalMilitar"] = {
        ["gstetrk5polng"] = 0,
        ["gsts128polng"] = 0,
        ["gstcns3polng"] = 0,
    },
    ["Prf"] = {
        ["rvkomodapol"] = 8,
        ["sg1150all"] = 8,
        ["rvsugoipol"] = 8,
        ["rvaleutianpol"] = 8,
        ["rvpolmavall"] = 8,
        ["rvcaracaraall"] = 8,
        ["rvgrangerpol"] = 8,
    },
    ["Bombeiros"] = {
        ["rvjoggerall"] = 7,
        ["sg1150all"] = 7,
        ["rvpolmavall"] = 7,
        ["rvverusbomb"] = 7,
        ["rvcaracaraall"] = 7,
        ["rvfiretrukbomb"] = 7,
        ["polmav"] = 1,
    },
    ["BombeirosHeli"] = {
        ["rvpolmavall"] = 7,
    },
    ["Policia"] = {
        ["rvpolmavall"] = 1,
    },
    ["Exercito"] = {
        ["rvkomodapol"] = 3,
        ["rvbf400pol"] = 3,
        ["rvsugoipol"] = 3,
        ["rvaleutianpol"] = 3,
        ["rvpolmavall"] = 3,
        ["rvcaracaraall"] = 3,
        ["rvgrangerpol"] = 3,
        ["rvterminuspol"] = 3,
        ["titan"] = 3,
    },
    ["Paramedic"] = {
        ["rvjoggerall"] = 6,
        ["rvoutlawhp"] = 6,
        -- ["rvpolmavall"] = 6,
        ["sg1150all"] = 6,
        ["emsscout"] = 6,
        ["rvbuffalohp"] = 6,
    },
    ["ParamedicHeli"] = {
        ["rvpolmavall"] = 6,
    },
    ["Mechanic"] = {
        ["rvcaracaramec"] = 4,
        ["dlbisontow"] = 4,
        ["rvoutlawmec"] = 4,
        ["rveveronmec"] = 4,
    },
    ["Juridico"] = {
        ["rvvstrjur"] = 5,
        ["rvballerjur"] = 5,
        ["KHeliJuri"] = 5,
    },
    ["Tatica"] = {
        ["rvkomodapol"] = 2,
        ["sg1150all"] = 2,
        ["rvsugoipol"] = 2,
        ["rvaleutianpol"] = 2,
        ["rvpolmavall"] = 2,
        ["rvcaracara6x6pol"] = 2,
    },
    ["Civil"] = {
        ["rvkomodapol"] = 1,
        ["sg1150all"] = 1,
        ["rvsugoipol"] = 1,
        ["rvaleutianpol"] = 1,
        ["rvpolmavall"] = 1,
        ["rvcaracaraall"] = 1,
        ["rvcavalcadepol"] = 1,
        ["rvdeitypol"] = 1,
    },
    ["Militar"] = {
        ["rvkomodapol"] = 0,
        ["sg1150all"] = 0,
        ["rvsugoipol"] = 0,
        ["rvaleutianpol"] = 0,
        ["rvpolmavall"] = 0,
        ["rvcoquettepol"] = 0,
        ["rvcaracaraall"] = 0,
        ["rvriotpol"] = 0,
        ["rvsentinelpol"] = 0,
    }
}
LIST_LIVERIES_BY_CITIES["Liberty99"] = {
    ["VipLegalExercito"] = {
        ["gstetrk5polng"] = 3,
        ["gsts128polng"] = 3,
        ["gstcns3polng"] = 3,
    },
    ["VipLegalPrf"] = {
        ["gstetrk5polng"] = 8,
        ["gsts128polng"] = 8,
        ["gstcns3polng"] = 8,
    },
    ["VipLegalBombeiros"] = {
        ["gstetrk5polng"] = 7,
        ["gsts128polng"] = 7,
        ["gstcns3polng"] = 7,
    },
    ["VipLegalParamedic"] = {
        ["gstetrk5polng"] = 6,
        ["gsts128polng"] = 6,
        ["gstcns3polng"] = 6,
    },
    ["VipLegalMechanic"] = {
        ["gstetrk5polng"] = 4,
        ["gsts128polng"] = 4,
        ["gstcns3polng"] = 4,
    },
    ["VipLegalJuridico"] = {
        ["gstetrk5polng"] = 5,
        ["gsts128polng"] = 5,
        ["gstcns3polng"] = 5,
    },
    ["VipLegalTatica"] = {
        ["gstetrk5polng"] = 2,
        ["gsts128polng"] = 2,
        ["gstcns3polng"] = 2,
    },
    ["VipLegalCivil"] = {
        ["gstetrk5polng"] = 1,
        ["gsts128polng"] = 1,
        ["gstcns3polng"] = 1,
    },
    ["VipLegalMilitar"] = {
        ["gstetrk5polng"] = 0,
        ["gsts128polng"] = 0,
        ["gstcns3polng"] = 0,
    },
    ["Prf"] = {
        ["rvkomodapol"] = 8,
        ["sg1150all"] = 8,
        ["rvsugoipol"] = 8,
        ["rvaleutianpol"] = 8,
        ["rvpolmavall"] = 8,
        ["rvcaracaraall"] = 8,
        ["rvgrangerpol"] = 8,
    },
    ["Bombeiros"] = {
        ["rvjoggerall"] = 7,
        ["sg1150all"] = 7,
        ["rvpolmavall"] = 7,
        ["rvverusbomb"] = 7,
        ["rvcaracaraall"] = 7,
        ["rvfiretrukbomb"] = 7,
        ["polmav"] = 1,
    },
    ["BombeirosHeli"] = {
        ["rvpolmavall"] = 7,
    },
    ["Policia"] = {
        ["rvpolmavall"] = 1,
    },
    ["Exercito"] = {
        ["rvkomodapol"] = 3,
        ["rvbf400pol"] = 3,
        ["rvsugoipol"] = 3,
        ["rvaleutianpol"] = 3,
        ["rvpolmavall"] = 3,
        ["rvcaracaraall"] = 3,
        ["rvgrangerpol"] = 3,
        ["rvterminuspol"] = 3,
        ["titan"] = 3,
    },
    ["Paramedic"] = {
        ["rvjoggerall"] = 6,
        ["rvoutlawhp"] = 6,
        -- ["rvpolmavall"] = 6,
        ["sg1150all"] = 6,
        ["emsscout"] = 6,
        ["rvbuffalohp"] = 6,
    },
    ["ParamedicHeli"] = {
        ["rvpolmavall"] = 6,
    },
    ["Mechanic"] = {
        ["rvcaracaramec"] = 4,
        ["dlbisontow"] = 4,
        ["rvoutlawmec"] = 4,
        ["rveveronmec"] = 4,
    },
    ["Juridico"] = {
        ["rvvstrjur"] = 5,
        ["rvballerjur"] = 5,
        ["KHeliJuri"] = 5,
    },
    ["Tatica"] = {
        ["rvkomodapol"] = 2,
        ["sg1150all"] = 2,
        ["rvsugoipol"] = 2,
        ["rvaleutianpol"] = 2,
        ["rvpolmavall"] = 2,
        ["rvcaracara6x6pol"] = 2,
    },
    ["Civil"] = {
        ["rvkomodapol"] = 1,
        ["sg1150all"] = 1,
        ["rvsugoipol"] = 1,
        ["rvaleutianpol"] = 1,
        ["rvpolmavall"] = 1,
        ["rvcaracaraall"] = 1,
        ["rvcavalcadepol"] = 1,
        ["rvdeitypol"] = 1,
    },
    ["Militar"] = {
        ["rvkomodapol"] = 0,
        ["sg1150all"] = 0,
        ["rvsugoipol"] = 0,
        ["rvaleutianpol"] = 0,
        ["rvpolmavall"] = 0,
        ["rvcoquettepol"] = 0,
        ["rvcaracaraall"] = 0,
        ["rvriotpol"] = 0,
        ["rvsentinelpol"] = 0,
    }
}

---@param garageType string
---@param vehicleName string
---@return number?
function GetLiveryVehicleByGarageType(garageType, vehicleName)
    local data = LIST_LIVERIES_BY_CITIES[cityName]

    if not data then 
        return
    end

    return (data[garageType] or {})[vehicleName]
end

---@param garageId string
---@param vehicleName string
---@return number?
function GetLiveryVehicleByGarage(garageId, vehicleName)
    local data = Garages[garageId]

    if not (data and data['VehiclesLiveries']) then 
        return
    end

    return data['VehiclesLiveries'][vehicleName]
end