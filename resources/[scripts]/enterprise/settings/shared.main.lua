SHARED_SETTINGS = {}
SHARED_SETTINGS.MAX_PASSIVE_INCOME = 100000
PAYMENT_PER_DELIVERY_POINT = 10000 -- dinheiro que vai ser dado por entregar ( limpo por player ao entregar)

---@class enterprises.WorkflowInfo
---@field index?            number Injected by DEFINE_WORKFLOWINFO
---@field key?              enterprises.WorkflowKey Injected by DEFINE_WORKFLOWINFO
---@field label             string
---@field interactionName   string
---@field description       string
---@field isPremium?        boolean

---@type enterprises.WorkflowInfo[]
WORKFLOWINFODATABASE = {}
---@type table<enterprises.WorkflowKey, enterprises.WorkflowInfo>
WORKFLOWINFODATABASE_INFO_BY_KEY = {}

---@type IEnterPrise.VipInfo[]
SHARED_SETTINGS.VIPS = {}

---@alias enterprises.WorkflowKey string

---@param key          enterprises.WorkflowKey
---@return fun( workflowInfo: enterprises.WorkflowInfo ): enterprises.WorkflowInfo
function DEFINE_WORKFLOWINFO(key)
    return function(workflowInfo)
        local index                           = #WORKFLOWINFODATABASE + 1

        workflowInfo.index                    = index
        workflowInfo.key                      = key

        WORKFLOWINFODATABASE[index]           = workflowInfo
        WORKFLOWINFODATABASE_INFO_BY_KEY[key] = workflowInfo

        return workflowInfo
    end
end

WORKFLOW__FARM = DEFINE_WORKFLOWINFO 'farm' {
    label           = _t('farm_normal_label'),
    interactionName = _t('farm_normal_interaction_name'),
    description     = _t('farm_normal_desc'),
}

WORKFLOW__DELIVERY = DEFINE_WORKFLOWINFO 'delivery' {
    label           = _t('delivery_label'),
    interactionName = _t('delivery_interaction_name'),
    description     = _t('farm_afk_desc'),
}

WORKFLOW__PREMIUM_FARM = DEFINE_WORKFLOWINFO 'premium_farm' {
    label           = _t('farm_afk_label'),
    interactionName = _t('farm_afk_interaction_name'),
    description     = _t('farm_afk_desc'),
    isPremium       = true,
}

---@param key IEnterPrise.VipInfoKey
---@return fun(data: IEnterPrise.VipInfo): IEnterPrise.VipInfo
function DEFINE_VIPINFO(key)
    return function(data)
        local index = #SHARED_SETTINGS.VIPS + 1

        data.id = key
        SHARED_SETTINGS.VIPS[index] = data

        return data
    end
end

DEFINE_VIPINFO 'vip_gold' {
    name = 'Vip Ouro',
    description = _t('vip_duration_desc'),
    commands_to_give = {
        "GiveGroup {passport} VipWpp 1 7",
        "GiveGroup {passport} Spotify 1 7",
        "GiveItem {passport} WEAPON_SPECIALCARBINE_MK2 1",
        "GiveItem {passport} WEAPON_PISTOL_MK2 2",
        "GiveItem {passport} WEAPON_RIFLE_AMMO 100",
        "GiveItem {passport} WEAPON_PISTOL_AMMO 150",
        "GiveVehicleDays {passport} vectre 7",
    }
}

DEFINE_VIPINFO 'vip_silver' {
    name = 'Vip Prata',
    description = _t('vip_duration_desc'),
    commands_to_give = {
        "GiveGroup {passport} VipWpp 1 7",
        "GiveGroup {passport} Spotify 1 7",
        "GiveItem {passport} WEAPON_SPECIALCARBINE_MK2 1",
        "GiveItem {passport} WEAPON_PISTOL_MK2 2",
        "GiveItem {passport} WEAPON_RIFLE_AMMO 100",
        "GiveItem {passport} WEAPON_PISTOL_AMMO 150",
        "GiveVehicleDays {passport} vectre 7",
    }
}

DEFINE_VIPINFO 'vip_bronze' {
    name = 'Vip Bronze',
    description = _t('vip_duration_desc'),
    commands_to_give = {
        "GiveGroup {passport} VipWpp 1 7",
        "GiveGroup {passport} Spotify 1 7",
        "GiveItem {passport} WEAPON_SPECIALCARBINE_MK2 1",
        "GiveItem {passport} WEAPON_PISTOL_MK2 2",
        "GiveItem {passport} WEAPON_RIFLE_AMMO 100",
        "GiveItem {passport} WEAPON_PISTOL_AMMO 150",
        "GiveVehicleDays {passport} vectre 7",
    }
}

SHARED_SETTINGS.ENTERPRISE_TYPES = {
    ['gas-station'] = {
        label = 'Posto 24hrs',
        allowed_items = {
            ['refined_oil'] = true,
            ['industrial_oil'] = true,
            ['chemical_solvents'] = true,
        },
        meta_items = {
            ['refined_oil'] = true,
            ['industrial_oil'] = true,
            ['chemical_solvents'] = true,
        },
        reward_delivery_point = 1000,
        workflowsSettings = {
            [WORKFLOW__FARM] = {
                minigameName = 'enterprise__gas_station__production',
            },
            [WORKFLOW__DELIVERY] = {
                minigameName = 'enterprise__gas_station__distribution',
            },
            [WORKFLOW__PREMIUM_FARM] = {
                minigameName = 'enterprise__gas_station__production_premium',
            },
        }
    },
    ['restaurant'] = {
        label = 'Restaurante',
        allowed_items = {
            ['pizza'] = true,
            ['burger'] = true,
            ['french_fries'] = true,
            ['ice_cream'] = true,
            ['coffee'] = true,
            ['craft_beer'] = true,
            ['soda'] = true,
        },
        meta_items = {
            ['pizza'] = true,
            ['burger'] = true,
            ['french_fries'] = true,
            ['ice_cream'] = true,
            ['coffee'] = true,
            ['craft_beer'] = true,
            ['soda'] = true,
        },
        reward_delivery_point = 1000,
        workflowsSettings = {
            [WORKFLOW__FARM] = {
                minigameName = 'enterprise__restaurant_shop__production',
            },
            [WORKFLOW__DELIVERY] = {
                minigameName = 'enterprise__restaurant_shop__distribution',
            },
            [WORKFLOW__PREMIUM_FARM] = {
                minigameName = 'enterprise__restaurant_shop__production_premium',
            },
        }
    },
    ['nightclub'] = {
        label = 'Nightclub',
        allowed_items = {
            ['vodka'] = true,
            ['whisky'] = true,
            ['energy_drink'] = true,
            ['beer'] = true,
            ['soda'] = true,
            ['water'] = true,
            ['juice'] = true,
        },
        reward_delivery_point = 1000,
        meta_items = {
            ['vodka'] = true,
            ['whisky'] = true,
            ['energy_drink'] = true,
            ['beer'] = true,
            ['soda'] = true,
            ['water'] = true,
            ['juice'] = true,
        },

        workflowsSettings = {
            [WORKFLOW__FARM] = {
                minigameName = 'enterprise__nightclub__production',
            },
            [WORKFLOW__DELIVERY] = {
                minigameName = 'enterprise__nightclub__distribution',
            },
            [WORKFLOW__PREMIUM_FARM] = {
                minigameName = 'enterprise__nightclub__production_premium',
            },
        },
    },
}


SHARED_SETTINGS.ENTERPRISE_LIMITS = { -- ISSO SERVE PARA DEFINIR LIMITES EM UMA EMPRESA
    [1] = {
        chest_items = 200,
        members = 10,
    },
    [2] = {
        chest_items = 300,
        members = 15,
    },
    [3] = {
        chest_items = 600,
        members = 20,
    },
    [4] = {
        chest_items = 800,
        members = 25,
    },
    [5] = {
        chest_items = 1500,
        members = 30,
    },
}
--- SISTEMA DE PERMISSOES PARA CRIAR EMPRESA, DELETAR OU EDITAR
---@type table<string, number>
SHARED_SETTINGS.STAFF_ACTIONS_GROUPS = {
    ['Enterprise'] = 1,
}

--- TEMPO PADRÃO PARA FAZER PAGAMENTO AOS FUNCIONARIOS
SHARED_SETTINGS.NEXT_PAYOUT_ENTERPRISE = 30 -- PADRÃO DE 30 MINUTOS

SHARED_SETTINGS.RBAC_ROLES = {
    USERS_DEMOTE = "users.demote",                     -- rebaixar cargo
    USERS_PROMOTE = "users.promote",                   -- promover cargo
    USERS_KICK = "users.kick",                         -- expulsar funcionário
    USERS_CONTRACT = "users.contract",                 -- contratar funcionário
    CHANGE_METAS = "change.metas",                     -- alterar metas
    WITHDRAW_BANK = "withdraw.bank",                   -- sacar do banco da empresa
    CHANGE_PAYOUT = "change.payout",                   -- alterar divisão de lucros
    CHANGE_OUTFIT = "change.outfit",                   -- editar uniformes
    CHANGE_RADIO_FREQUENCY = "change.radio.frequency", -- alterar frequência do rádio
    CHANGE_ROLE = "change.role",                       -- alterar cargo individual
    MANAGEMENT_ENTERPRISE = "view.management",         -- acessar tela de gerenciamento
    USER_BAN = "view.banned.list",                     -- banir/desbanir + ver lista de banidos
    WITHDRAW_PROFIT = "withdraw.profit",               -- sacar lucros
    TRANSFER_PROFIT = "transfer.profit",               -- transferir lucros
    VIEW_PROFIT_BANK = "view.profit.bank",             -- ver saldo do banco
    CHANGE_ROLES = "change.roles",                     -- gerenciar cargos (hierarquia)
}

---@type table<number,IRole>
SHARED_SETTINGS.roles = {
    [1] = { -- Dono
        permissions = {
            SHARED_SETTINGS.RBAC_ROLES.CHANGE_METAS,
            SHARED_SETTINGS.RBAC_ROLES.WITHDRAW_BANK,
            SHARED_SETTINGS.RBAC_ROLES.USERS_DEMOTE,
            SHARED_SETTINGS.RBAC_ROLES.USERS_PROMOTE,
            SHARED_SETTINGS.RBAC_ROLES.USERS_KICK,
            SHARED_SETTINGS.RBAC_ROLES.USERS_CONTRACT,
            SHARED_SETTINGS.RBAC_ROLES.CHANGE_PAYOUT,
            SHARED_SETTINGS.RBAC_ROLES.CHANGE_OUTFIT,
            SHARED_SETTINGS.RBAC_ROLES.CHANGE_RADIO_FREQUENCY,
            SHARED_SETTINGS.RBAC_ROLES.CHANGE_ROLE,
            SHARED_SETTINGS.RBAC_ROLES.MANAGEMENT_ENTERPRISE,
            SHARED_SETTINGS.RBAC_ROLES.USER_BAN,
            SHARED_SETTINGS.RBAC_ROLES.WITHDRAW_PROFIT,
            SHARED_SETTINGS.RBAC_ROLES.TRANSFER_PROFIT,
            SHARED_SETTINGS.RBAC_ROLES.VIEW_PROFIT_BANK,
            SHARED_SETTINGS.RBAC_ROLES.CHANGE_ROLES,
        },
        title = _t('role_owner')
    },
    [2] = { -- Gerente
        permissions = {
            SHARED_SETTINGS.RBAC_ROLES.USERS_DEMOTE,
            SHARED_SETTINGS.RBAC_ROLES.USERS_PROMOTE,
            SHARED_SETTINGS.RBAC_ROLES.USERS_KICK,
            SHARED_SETTINGS.RBAC_ROLES.USERS_CONTRACT,
        },
        title = _t('role_manager')
    },
    [3] = { -- Supervisor
        permissions = {
            SHARED_SETTINGS.RBAC_ROLES.USERS_CONTRACT
        },
        title = _t('role_supervisor')
    },
    [4] = { -- Líder
        permissions = {},
        title = _t('role_leader')
    },
    [5] = { -- Membro
        permissions = {},
        title = _t('role_member')
    }
}

--- DETALHE DO VIP MENSAL
SHARED_SETTINGS.MONTHLY_VIP = {
    id = 'vip_gold',
    name = 'Vip Ouro',
    description = _t('vip_duration_desc'),
    icon = '🏆',
    storeLink = 'https://store.example.com/vip-gold'
}

---@class DefGoalItem
---@field reward number
---@field requirement number

---@type DefGoalItem[]
SHARED_SETTINGS.GOALS = {}

SHARED_SETTINGS.GOALS_REQUIREMENT = 50
SHARED_SETTINGS.GOALS_REWARDS = 5000
