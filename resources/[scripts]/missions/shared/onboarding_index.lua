ONBOARDING_TRAIL = {
    "seja_voce",
    "nova_familia",
    "primeiras_rodas",
    "documento_na_mao",
    "em_casa",
    "cara_conhecida",
    -- "boa_impressao",
    -- "role_pela_cidade",
}

ONBOARDING_RAMO_IDS = {
    ramo_primeiro_roubo = true,
    ramo_primeira_patrulha = true,
    ramo_primeiro_conserto = true,
    ramo_primeiro_socorro = true,
    ramo_primeiro_negocio = true,
    ramo_primeiro_show = true,
}

ONBOARDING_RAMO_INDEX = #ONBOARDING_TRAIL + 1
ONBOARDING_TOTAL_SLOTS = ONBOARDING_RAMO_INDEX

local indexById = {}
for i, id in ipairs( ONBOARDING_TRAIL ) do
    indexById[ id ] = i
end
for id in pairs( ONBOARDING_RAMO_IDS ) do
    indexById[ id ] = ONBOARDING_RAMO_INDEX
end

function GetOnboardingIndex( missionId )
    return indexById[ missionId ]
end

function IsOnboardingMission( missionId )
    return indexById[ missionId ] ~= nil
end

function GetOnboardingTotal()
    return ONBOARDING_TOTAL_SLOTS
end

FAC_TRACK_GROUPS = {
    "criminal",
}

local facTrackPriority = {}
for i, id in ipairs( FAC_TRACK_GROUPS ) do
    facTrackPriority[ id ] = i
end

function IsFacTrackGroup( groupId )
    return groupId ~= nil and facTrackPriority[ groupId ] ~= nil
end

function GetFacTrackPriority( groupId )
    if not groupId then return nil end
    return facTrackPriority[ groupId ]
end
