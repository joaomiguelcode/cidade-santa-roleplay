local citiesSteps = {
    ["Maresia"] = {
        "tos",
        "playerdata",
        "discord"
    },
    ["Grande"] = {
        "tos",
        -- "app",
        "playerdata",
        "discord"
    },
    ["Orizon"] = {},
    -- ["Kingdom"] = {
    --     "tos",
    --     -- "playerdata",
    --     "discord"
    -- },
    -- ["Krown"] = {
    --     "tos",
    --     -- "playerdata",
    --     "discord"
    -- },
    ["District99"] = {
        "tos",
        "discord"
    },
    ["Liberty99"] = {
        "discord_invite"
    },
    ["Krown"] = {
        "discord_invite"
    }
}

citySteps = citiesSteps[GetConvar("cityName", "")] or {
    "tos",
    "playerdata",
    "discord",
}

function CheckIfInLastStep(currentStep)
    local lastStep = citySteps[#citySteps]

    -- print('CheckIfInLastStep::', currentStep, lastStep, json.encode(citySteps))

    return currentStep == lastStep
end

function GetNextStep(currentStep)
    local currentIndex = 1
    for i=1, #citySteps do
        if citySteps[i] == currentStep then
            currentIndex = i
            break
        end
    end
    local nextStep = citySteps[currentIndex + 1]
    -- sx.logger:debug( ('GetNextStep:: current="%s" next="%s" steps=%s'):format( tostring(currentStep), tostring(nextStep), json.encode(citySteps) ) )
    return nextStep
end

function RequiresDiscordLink()
    return CheckValidStep("discord") or CheckValidStep("discord_invite")
end
exports("RequiresDiscordLink", RequiresDiscordLink)

function CheckValidStep(step)
    for i = 1, #citySteps do
        if citySteps[i] == step then
            return true
        end
    end
    return false
end
exports("CheckValidStep",CheckValidStep)

function GetFirstStep()
    return citySteps[1]
end
