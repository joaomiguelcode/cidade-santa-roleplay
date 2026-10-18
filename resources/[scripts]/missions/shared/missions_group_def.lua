-- DEFINE_GROUP "tutorial" {
--     index = 1,
--     name = _t("group.tutorial.name"),
--     description = _t("group.tutorial.description"),
--     icon = "https://santaimagens.roleplayrp.com/img/imagens_variadas/new_hub/45bedff2aec46881570c8e3f6e368fb5929f1fcc.png",
--     rewardsIcons = {
--         "https://santaimagens.roleplayrp.com/img/imagens_variadas/new_hub/c10e6a8e56bd9a6a3bfe82861bfd203c2986daa7.png",
--         "https://santaimagens.roleplayrp.com/img/imagens_variadas/new_hub/62340bdd2d644e812c390dd3b38f0da7fd1b11c8.png",
--         "https://santaimagens.roleplayrp.com/img/imagens_variadas/new_hub/cd4e2fd5810ada12da01750f0d354b55ca4840d2.png"
--     },
--     checkpoint = 0,
--     order = "linear",
--     requires_citizenship = false,
--     requires_fac = false,
--     rewards = {},
--     locked = true, -- temporary locked
-- }

DEFINE_GROUP "connect" {
    index = 2,
    name = _t("group.connect.name"),
    description = _t("group.connect.description"),
    icon = "https://cdn.santagroup.gg/08894d09-85d7-46b0-a0cd-6f8289d1821f-bemvindo.png",
    rewardsIcons = {
        {
            icon = "https://cdn.santagroup.gg/onboarding/xpa.webp",
            tooltip = _t("reward.tooltip.xp_skills")
        },
        {
            icon = "https://cdn.santagroup.gg/onboarding/emblemas.webp",
            tooltip = _t("reward.tooltip.emblemas")
        }
    },
    checkpoint = 2,
    order = "partial",
    requires_citizenship = false,
    requires_fac = false,
    auto_activate = true,
    rewards = {
        title = "Cidadao",
        money = 5000,
    },
}

DEFINE_GROUP "criminal" {
    index = 3,
    name = _t("group.criminal.name"),
    description = _t("group.criminal.description"),
    icon = "https://cdn.santagroup.gg/160582b0-8460-48e1-a9cf-8fc9dd114acb-criminal3.png",
    rewardsIcons = {
        {
            icon = "https://cdn.santagroup.gg/onboarding/farm2.webp",
            tooltip = _t("reward.tooltip.farm_3000")
        },
        {
            icon = "https://cdn.santagroup.gg/onboarding/xpa.webp",
            tooltip = _t("reward.tooltip.xp_skills")
        },
        {
            icon = "https://cdn.santagroup.gg/onboarding/emblemas.webp",
            tooltip = _t("reward.tooltip.emblemas")
        }
    },
    checkpoint = 0,
    order = "linear",
    requires_citizenship = false,
    requires_fac = false,
    auto_activate = true,
    rewards = {
        farm = 3000,
        skills = { crime = 1000 },
        title = _t("group.criminal.reward.title"),
    },
}

DEFINE_GROUP "social" {
    index = 4,
    name = _t("group.social.name"),
    description = _t("group.social.description"),
    icon = "https://cdn.santagroup.gg/onboarding/nova_fam_lia.svg",
    rewardsIcons = {
        {
            icon = "https://cdn.santagroup.gg/onboarding/xpa.webp",
            tooltip = _t("reward.tooltip.xp_skills")
        }
    },
    checkpoint = 0,
    order = "partial",
    requires_citizenship = false,
    requires_fac = false,
    auto_activate = true,
    rewards = {},
    hideHub = true,
}

-- DEFINE_GROUP "ramo" {
--     index = 3,
--     name = _t("group.ramo.name"),
--     description = _t("group.ramo.description"),
--     icon = "https://cdn.santagroup.gg/6aa09679-3ce7-4755-8dd2-d83ecd676c4a-missao.png",
--     rewardsIcons = {
--         "https://cdn.santagroup.gg/onboarding/xpa.webp",
--         "https://cdn.santagroup.gg/onboarding/emblemas.webp"
--     },
--     checkpoint = 0,
--     order = "linear",
--     requires_citizenship = false,
--     requires_fac = false,
--     auto_activate = true,
--     rewards = {},
-- }
