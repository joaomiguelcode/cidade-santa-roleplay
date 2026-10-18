local pvpPanelConversation = ConversationManager()

local function getPvpPanelNpcPedData( options )
    options = options or {}

    local defaultAnimationStages = {
        {
            dict = 'amb@world_human_stand_impatient@female@idle_a',
            anim = 'idle_a',
            timeout = 10000,
        },
        {
            dict = 'amb@world_human_stand_impatient@female@idle_a',
            anim = 'idle_a',
            timeout = 60000,
        },
    }

    return {
        model = options.model or 's_m_m_ciasec_01',
        animationStages = defaultAnimationStages,
    }
end

local function addPvpPanelNpc( coords, options )
    options = options or {}

    local entrySource = options.entrySource or 'npc'
    local openPanelOptions = options.openPanelOptions
    local buttons = {
        {
            label = PvpTranslations.get( 'npc_open_button' ),
            icon = 'FaGamepad',
            enabled = true,
            onCallback = function()
                pvpPanelConversation:closeConversation()
                TriggerServerEvent( 'pvp.server:openPanel', entrySource, openPanelOptions )
            end,
        },
    }

    if options.includeDogtag ~= false then
        buttons[ #buttons + 1 ] = {
            label = PvpTranslations.get( 'npc_sell_dogtag_button' ),
            icon = 'FaInfo',
            enabled = true,
            onCallback = function()
                pvpPanelConversation:closeConversation()
                TriggerEvent( 'shops:openSystem:NPC', 'SellDogtag' )
            end,
        }
    end

    pvpPanelConversation:addConversation({
        name = PvpTranslations.get( options.nameKey or 'npc_name' ),
        tag = PvpTranslations.get( 'npc_tag' ),
        visible = true,
        escText = PvpTranslations.get( 'npc_esc_text' ),
        description = PvpTranslations.get( 'npc_description' ),
        coords = coords,
        icon = 'gamepad',
        renderDistance = 3.0,
        activeDistance = 1.8,
        buckets = {
            [1] = true,
        },
        ped = getPvpPanelNpcPedData( options ),
        buttons = buttons,
    })
end

addPvpPanelNpc( PVP_NPC_COORDS )
addPvpPanelNpc( PVP_NPC_SECONDARY_COORDS )

if PvpIsKngCity and PvpIsKngCity() then
    local guardNameKeys = {
        'ffa_rifle_name',
        'ffa_pistol_name',
    }

    for index, coords in ipairs( PVP_KNG_FFA_GUARD_COORDS or {} ) do
        addPvpPanelNpc( coords, {
            model = PVP_KNG_FFA_GUARD_PED_MODEL,
            nameKey = guardNameKeys[ index ],
            openPanelOptions = {
                activeTab = 'pvp',
            },
            includeDogtag = false,
        })
    end
end
