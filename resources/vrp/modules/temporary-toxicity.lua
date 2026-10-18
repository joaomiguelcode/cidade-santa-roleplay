-----------------------------------------------------------------------------------------------------------------------------------------
-- TEMPORARY TOXICITY MODULE
-----------------------------------------------------------------------------------------------------------------------------------------
local ToxicityMutes = {}
local ToxicityWarnings = {}

function vRP.setToxicityMute(Passport, minutes)
    local expire = os.time() + (minutes * 60)
    ToxicityMutes[Passport] = expire
    local source = vRP.Source(Passport)
    if source then
        Player(source).state:set("toxicityMuted", true, true)
    end
end

function vRP.removeToxicityMute(Passport)
    if ToxicityMutes[Passport] then
        ToxicityMutes[Passport] = nil
        local source = vRP.Source(Passport)
        if source then
            Player(source).state:set("toxicityMuted", false, true)
        end
        return true
    end
    return false
end

function vRP.isToxicityMuted(Passport)
    local expire = ToxicityMutes[Passport]
    if expire then
        if os.time() < expire then
            return true, math.ceil((expire - os.time()) / 60)
        else
            ToxicityMutes[Passport] = nil
            local source = vRP.Source(Passport)
            if source then
                Player(source).state:set("toxicityMuted", false, true)
            end
        end
    end
    return false, 0
end

function vRP.getToxicityStatus(Passport)
    local muted, remaining = vRP.isToxicityMuted(Passport)
    return {
        muted = muted,
        remainingMinutes = remaining,
        warnings = ToxicityWarnings[Passport] or 0
    }
end

AddEventHandler("vRP:playerSpawn", function(Passport, source, first_spawn)
    if vRP.isToxicityMuted(Passport) then
        Player(source).state:set("toxicityMuted", true, true)
    end
end)
