sx.client.stats = { }

--[[
---@param name   string
---@param source Source
---@param value? number -- Default is 1
function sx.client.stats.increment( name, value )

    value = value or 1

    -- TODO: Melhorar?
    local passport = LocalPlayer.state[ 'Passport' ]

    assert( passport )

    local uucid = sx.services.achievements.passport2uucid( passport )

    -- local response = sx.services.achievements.stats.increment( uucid, name, value )

    -- if #response.data.result.data.achievementProgressesCompleted >= 1 then

    --     -- Temos mais de um progresso de achievement que foi completado pós adicionar esse stat?

    --     TriggerServerEvent( 'net.sx.on_achievement_progress_completed', response.data.result.data.achievementProgressesCompleted )
    -- end

    return sx.stats.append({
        kind = eStatChangeKind.Increment,
        uucid = uucid,
        name = name,
        value = value,
    })
end
--]]