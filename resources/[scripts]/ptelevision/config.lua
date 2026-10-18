Config = {}

Config.Models = { -- Any TV Models used on the map or in locations must be defined here.
    [`v_ilev_cin_screen`] = {
        DefaultVolume = 0.5,
        Range = 50.0,
        Target = "cinscreen", -- Only use if prop has render-target name.
        Scale = 0.085, 
        Offset = vector3(-1.02, -0.055, 1.04)
    },
    [`prop_huge_display_01`] = {
        DefaultVolume = 0.5,
        Range = 50.0,
        -- Target = "cinscreen", -- Only use if prop has render-target name.
        Scale = 0.45, 
        Offset = vector3(-5.12, -0.055, 3.90)
    },
    [`prop_huge_display_02`] = {
        DefaultVolume = 0.5,
        Range = 50.0,
        -- Target = "cinscreen", -- Only use if prop has render-target name.
        Scale = 0.45, -- Backward compatibility fallback.
        ScaleX = 0.34, -- Horizontal size (grows to the right).
        ScaleY = 0.20, -- Vertical size (grows downward from Offset.z).
        Offset = vector3(-4.25, -0.065, 2.44)
    },
    [`faraostore_prop_cinescreen`] = {
        DefaultVolume = 0.5,
        Range = 50.0,
        -- Target = "cinscreen", -- Only use if prop has render-target name.
        Scale = 0.24, -- Backward compatibility fallback.
        ScaleX = 0.24, -- Horizontal size.
        ScaleY = 0.110, -- Vertical size only (reduce overflow on bottom/top).
        Offset = vector3(-0.38, 2.90, 1.30),
        rotation = 90
    },
}

Config.Locations = { -- REMOVE ALL IF NOT USING ONESYNC, OR IT SHALL BREAK.
    {
        Model = `prop_tv_flat_01`,
        Position = vector4(144.3038, -1037.4647, 29.4173, 70.81),
    },
}

Config.Channels = { -- These channels are default channels and cannot be overriden.
    {name = "Twitch", url = "twitch.tv/twitch"},
}

Config.BannedWords = {
    "google",
}

Config.Events = { -- Events for approving broadcasts / interactions (due to popular demand).
    ScreenInteract = function(source, data, key, value, cb) -- cb() to approve. 

        local passport = vRP.Passport( tonumber( source ) )

        if not passport then
            return
        end

        if not exports['player']:HasTvPermissionsNearPos( passport, data.coords ) then
            return
        end

        if value.url then 
            for i=1, #Config.BannedWords do 
                if string.find(value.url, Config.BannedWords[i]) then 
                    return
                end
            end

            local url = url.parse( value.url )

            -- DUI não aceita outros schemas, se não, o jogo crasha!
            if url.scheme ~= 'http' and url.scheme ~= 'https' then
                return
            end
        end
        cb()
    end,    
    Broadcast = function(source, data, cb)  -- cb() to approve. 
        cb()
    end,
}
