local ptBrToEnglish = {
    ["Lista do FiveM"] = "FiveM List",
    ["Influencer"] = "Influencer",
    ["Indicação de amigo"] = "Friend Referral",
    ["Redes sociais"] = "Social Media",
    ["Outros"] = "Other",
    ["Instagram"] = "Instagram",
    ["Tiktok"] = "Tiktok",
    ["YouTube"] = "YouTube",
}

local enToEnglish = {
    ["FiveM List"] = "FiveM List",
    ["Influencer"] = "Influencer",
    ["Friend Referral"] = "Friend Referral",
    ["Social Media"] = "Social Media",
    ["Other"] = "Other",
    ["Instagram"] = "Instagram",
    ["Tiktok"] = "Tiktok",
    ["YouTube"] = "YouTube",
}

local esToEnglish = {
    ["Lista de FiveM"] = "FiveM List",
    ["Influencer"] = "Influencer",
    ["Recomendación de amigo"] = "Friend Referral",
    ["Redes sociales"] = "Social Media",
    ["Otros"] = "Other",
    ["Instagram"] = "Instagram",
    ["Tiktok"] = "Tiktok",
    ["YouTube"] = "YouTube",
}

local frToEnglish = {
    ["Liste FiveM"] = "FiveM List",
    ["Influenceur"] = "Influencer",
    ["Recommandation d'ami"] = "Friend Referral",
    ["Réseaux sociaux"] = "Social Media",
    ["Autres"] = "Other",
    ["Instagram"] = "Instagram",
    ["Tiktok"] = "Tiktok",
    ["YouTube"] = "YouTube",
}

recommendationConfig = {
    ["Santa"] = ptBrToEnglish,
    ["Galaxy"] = ptBrToEnglish,
    ["Universo"] = ptBrToEnglish,
    ["CidadeNobre"] = ptBrToEnglish,
    ["Boomerang"] = enToEnglish,
    ["Malta"] = ptBrToEnglish,
    ["Kingdom"] = enToEnglish,
    ["District99"] = enToEnglish,
    ["Krown"] = enToEnglish,
    ["Orizon"] = enToEnglish,
    ["Liberty99"] = enToEnglish,
    ["Royal"] = enToEnglish,
    ["Real"] = esToEnglish,
    ["Prime"] = esToEnglish,
    ["Grande"] = ptBrToEnglish,
    ["Fronteira"] = ptBrToEnglish,
    ["Maresia"] = ptBrToEnglish,
    ["Alexandria"] = ptBrToEnglish,
    ["GoatRP"] = frToEnglish,
    ["Base"] = ptBrToEnglish,
}

local recommendationTranslationKeys = {
    ["FiveM List"] = "fivem_list",
    ["Influencer"] = "influencer",
    ["Friend Referral"] = "friend_referral",
    ["Social Media"] = "social_media",
    ["Other"] = "other",
}

function getRecommendationTranslationKeys(city)
    local keys = {}
    for label, canonical in pairs(recommendationConfig[city] or {}) do
        keys[label] = recommendationTranslationKeys[canonical]
    end
    return keys
end
exports("getRecommendationTranslationKeys", getRecommendationTranslationKeys)

recommendationOrder = {
    ["Santa"] = {
        ["Recommendation"] = {
            "Lista do FiveM",
            "Influencer",
            "Indicação de amigo",
            "Redes sociais",
            "Outros"
        },

        ["SocialMedia"] = {
            "Instagram",
            "Tiktok",
            "YouTube",
        },
    },
    ["GoatRP"] = {
        ["Recommendation"] = {
            "Liste FiveM",
            "Influenceur",
            "Recommandation d'ami",
            "Réseaux sociaux",
            "Autres"
        },

        ["SocialMedia"] = {
            "Instagram",
            "Tiktok",
            "YouTube",
        },
    },
    ["Universo"] = {
        ["Recommendation"] = {
            "Lista do FiveM",
            "Influencer",
            "Indicação de amigo",
            "Redes sociais",
            "Outros"
        },

        ["SocialMedia"] = {
            "Instagram",
            "Tiktok",
            "YouTube",
        },
    },
    ["CidadeNobre"] = {
        ["Recommendation"] = {
            "Lista do FiveM",
            "Influencer",
            "Indicação de amigo",
            "Redes sociais",
            "Outros"
        },

        ["SocialMedia"] = {
            "Instagram",
            "Tiktok",
            "YouTube",
        },
    },
    ["Boomerang"] = {
        ["Recommendation"] = {
            "FiveM List",
            "Influencer",
            "Friend Referral",
            "Social Media",
            "Other"
        },

        ["SocialMedia"] = {
            "Instagram",
            "Tiktok",
            "YouTube",
        },
    },
    ["Malta"] = {
        ["Recommendation"] = {
            "Lista do FiveM",
            "Influencer",
            "Indicação de amigo",
            "Redes sociais",
            "Outros"
        },

        ["SocialMedia"] = {
            "Instagram",
            "Tiktok",
            "YouTube",
        },
    },
    ["Kingdom"] = {
        ["Recommendation"] = {
            "FiveM List",
            "Influencer",
            "Friend Referral",
            "Social Media",
            "Other"
        },

        ["SocialMedia"] = {
            "Instagram",
            "Tiktok",
            "YouTube",
        },
    },
    ["District99"] = {
        ["Recommendation"] = {
            "FiveM List",
            "Influencer",
            "Friend Referral",
            "Social Media",
            "Other"
        },

        ["SocialMedia"] = {
            "Instagram",
            "Tiktok",
            "YouTube",
        },
    },
    ["Krown"] = {
        ["Recommendation"] = {
            "FiveM List",
            "Influencer",
            "Friend Referral",
            "Social Media",
            "Other"
        },

        ["SocialMedia"] = {
            "Instagram",
            "Tiktok",
            "YouTube",
        },
    },
    ["Orizon"] = {
        ["Recommendation"] = {
            "FiveM List",
            "Influencer",
            "Friend Referral",
            "Social Media",
            "Other"
        },

        ["SocialMedia"] = {
            "Instagram",
            "Tiktok",
            "YouTube",
        },
    },
    ["Orizon"] = {
        ["Recommendation"] = {
            "FiveM List",
            "Influencer",
            "Friend Referral",
            "Social Media",
            "Other"
        },

        ["SocialMedia"] = {
            "Instagram",
            "Tiktok",
            "YouTube",
        },
    },
    ["Orizon"] = {
        ["Recommendation"] = {
            "FiveM List",
            "Influencer",
            "Friend Referral",
            "Social Media",
            "Other"
        },

        ["SocialMedia"] = {
            "Instagram",
            "Tiktok",
            "YouTube",
        },
    },
    ["Orizon"] = {
        ["Recommendation"] = {
            "FiveM List",
            "Influencer",
            "Friend Referral",
            "Social Media",
            "Other"
        },

        ["SocialMedia"] = {
            "Instagram",
            "Tiktok",
            "YouTube",
        },
    },
    ["Liberty99"] = {
        ["Recommendation"] = {
            "FiveM List",
            "Influencer",
            "Friend Referral",
            "Social Media",
            "Other"
        },

        ["SocialMedia"] = {
            "Instagram",
            "Tiktok",
            "YouTube",
        },
    },
    ["Royal"] = {
        ["Recommendation"] = {
            "FiveM List",
            "Influencer",
            "Friend Referral",
            "Social Media",
            "Other"
        },

        ["SocialMedia"] = {
            "Instagram",
            "Tiktok",
            "YouTube",
        },
    },
    ["Real"] = {
        ["Recommendation"] = {
            "Lista de FiveM",
            "Influencer",
            "Recomendación de amigo",
            "Redes sociales",
            "Otros"
        },

        ["SocialMedia"] = {
            "Instagram",
            "Tiktok",
            "YouTube",
        },
    },
    ["Prime"] = {
        ["Recommendation"] = {
            "Lista de FiveM",
            "Influencer",
            "Recomendación de amigo",
            "Redes sociales",
            "Otros"
        },

        ["SocialMedia"] = {
            "Instagram",
            "Tiktok",
            "YouTube",
        },
    },
    ["Grande"] = {
        ["Recommendation"] = {
            "Lista do FiveM",
            "Influencer",
            "Indicação de amigo",
            "Redes sociais",
            "Outros"
        },

        ["SocialMedia"] = {
            "Instagram",
            "Tiktok",
            "YouTube",
        },
    },
    ["Fronteira"] = {
        ["Recommendation"] = {
            "Lista do FiveM",
            "Influencer",
            "Indicação de amigo",
            "Redes sociais",
            "Outros"
        },

        ["SocialMedia"] = {
            "Instagram",
            "Tiktok",
            "YouTube",
        },
    },
    ["Maresia"] = {
        ["Recommendation"] = {
            "Lista do FiveM",
            "Influencer",
            "Indicação de amigo",
            "Redes sociais",
            "Outros"
        },

        ["SocialMedia"] = {
            "Instagram",
            "Tiktok",
            "YouTube",
        },
    },
}

---@param value any
---@return string | nil
local function trimRecommendationValue(value)

    if type(value) ~= "string" then
        return nil
    end

    return value:match("^%s*(.-)%s*$")
end

---@param cityConfig table<string, string>
---@return string
local function getFallbackRecommendation(cityConfig)

    local fallbackOptions = {
        "Other",
        "Outros",
        "Otros",
        "Autres",
    }

    for _, option in ipairs(fallbackOptions) do
        if cityConfig[option] then
            return cityConfig[option]
        end
    end

    return "Other"
end

---@param cityName string
---@param selectedRecommendation any
---@return string recommendation
---@return string | nil reason
function resolveRecommendation(cityName, selectedRecommendation)

    local cityConfig = recommendationConfig[cityName]
    local recommendation = trimRecommendationValue(selectedRecommendation)

    if not cityConfig then
        return recommendation and recommendation ~= "" and recommendation or "Outros", "city_not_configured"
    end

    if not recommendation or recommendation == "" then
        return getFallbackRecommendation(cityConfig), "missing"
    end

    if cityConfig[recommendation] then
        return cityConfig[recommendation], nil
    end

    for _, mappedRecommendation in pairs(cityConfig) do
        if recommendation == mappedRecommendation then
            return mappedRecommendation, nil
        end
    end

    local lowerRecommendation = string.lower(recommendation)

    for option, mappedRecommendation in pairs(cityConfig) do
        if string.lower(option) == lowerRecommendation then
            return mappedRecommendation, nil
        end
    end

    return recommendation, "unknown"
end
exports("resolveRecommendation", resolveRecommendation)

recommendationOrder["Base"] = recommendationOrder["Santa"]

function getRecommendation(cityName)
    local order = (cityName and recommendationOrder[cityName]) or recommendationOrder["Santa"] or recommendationOrder["Base"]
    return (order and order["Recommendation"]) or {
        "Lista do FiveM",
        "Influencer",
        "Indicação de amigo",
        "Redes sociais",
        "Outros"
    }
end
exports("getRecommendation", getRecommendation)

function getSocialMedia(cityName)
    local order = (cityName and recommendationOrder[cityName]) or recommendationOrder["Santa"] or recommendationOrder["Base"]
    return (order and order["SocialMedia"]) or {
        "Instagram",
        "Tiktok",
        "YouTube"
    }
end
exports("getSocialMedia", getSocialMedia)
