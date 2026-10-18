---@type MinigameDef[]
MINIGAME_DEF_DATABASE = { }

---@type table<string, MinigameDef>
MINIGAME_DEF_DATABASE_DEF_BY_NAME = { }

---@type MinigameVolumeDef[]
gMinigameVolumeDefs = { }

---@param name string
---@return fun( data: fsMinigameDef )
function DEFINE_MINIGAME( name )

    ---@param def fsMinigameDef
    return function( data )

        assert( data.duration, 'duration is required!' )

        ---@type MinigameDef
        local def =
        {
            index = #MINIGAME_DEF_DATABASE + 1,

            name = name,

            minigamePreset = data.minigamePreset,

            displayName = data.displayName,

            flags = data.flags or eMinigameDefFlags.MDF_NONE,

            allowsVipFarmBuff = data.allowsVipFarmBuff,

            activeFarmRewardMultiplier = data.activeFarmRewardMultiplier,

            duration = data.duration,

            protectionActivationDelay = data.protectionActivationDelay,

            volumes = { },

            distance = data.distance or DEFAULT_MINIGAME_POINT_MAX_DISTANCE,

            isAllowed = data.isAllowed,

            requirements = data.requirements or { },

            scriptedInteractionName = data.scriptedInteractionName,

            rewards = table.type( data.rewards ) == 'array' and data.rewards or { data.rewards },

            hooks = data.hooks or { },
        }

        table.insert( MINIGAME_DEF_DATABASE, def )

        MINIGAME_DEF_DATABASE_DEF_BY_NAME[ name ] = def

        ---@param volumeDef MinigameVolumeDef
        local function AddVolumeDef( volumeDef )

            -- Adiciona campos de referência global/local
            volumeDef.minigameDefIndex = def.index
            volumeDef.localIndex = #def.volumes + 1
            volumeDef.index = #gMinigameVolumeDefs + 1

            table.insert( def.volumes, volumeDef )

            table.insert(gMinigameVolumeDefs, volumeDef)

            volumeDef.volume = CreateMinigameVolume( def, volumeDef )
        end

        for _, pointDef in ipairs( data.points or { } ) do

            ---@type SphereMinigameVolumeDef
            local sphereVolumeDef =
            {
                type = eMinigameVolumeType.Sphere,
                coords = pointDef,
                radius = data.distance,
            }

            AddVolumeDef( sphereVolumeDef )
        end

        for _, fsVolumeDef in ipairs( data.volumes or { } ) do

            local fsVolumeType = fsVolumeDef[ 1 ]

            ---@type MinigameVolumeDef
            local volumeDef =
            {
            }

            if      fsVolumeType == 'sphere' then

                ---@cast fsVolumeDef fsSphereMinigameVolumeDef

                volumeDef.type = eMinigameVolumeType.Sphere

                volumeDef.coords = assert( fsVolumeDef[ 2 ], 'fsSphereMinigameVolumeDef.coords is required!' )
                volumeDef.radius = assert( fsVolumeDef[ 3 ], 'fsSphereMinigameVolumeDef.radius is required!' )

            elseif  fsVolumeType == 'polygon' then

                ---@cast fsVolumeDef fsPolygonMinigameVolumeDef

                volumeDef.type = eMinigameVolumeType.Polygon

                assert( fsVolumeDef[ 2 ], 'fsPolygonMinigameVolumeDef.vertices is required!' )
                volumeDef.vertices = table.map( fsVolumeDef[ 2 ], function( vertex )

                    return vec3( vertex.x, vertex.y, 0.0 )
                end)
            else

                error( ('Invalid volume type: %s !'):format( json.encode( fsVolumeDef ) ) )
            end

            AddVolumeDef( volumeDef )
        end

        for _, rewardLootTableDef in ipairs( def.rewards ) do

            rewardLootTableDef.computedChanceWeightSum = nil

            for _, rewardDef in ipairs( rewardLootTableDef.item or { } ) do

                if rewardDef.chanceWeight then

                    rewardLootTableDef.computedChanceWeightSum =  rewardLootTableDef.computedChanceWeightSum or 0

                    rewardLootTableDef.computedChanceWeightSum += rewardDef.chanceWeight
                end
            end
        end

        -- Ordenars as loottables que possuem "when" primeiro na lista
        -- para processarmos essas e depois as que não possuem condições
        table.sort( def.rewards, function( a, b )

            return a.when and not b.when
        end)

        if IS_CLIENT then

            ---@param minigameDef MinigameDef
            function OnMinigameDefCreated( minigameDef )

                for minigameVolumeDefIndex, volumeDef in ipairs( minigameDef.volumes ) do

                    if HookMinigameVolume then

                        HookMinigameVolume(volumeDef.volume, volumeDef)
                    end
                end
            end

            OnMinigameDefCreated( def )
        end
    end
end

-- duplicado de sx.table.join porque o sx demora a carregar
function table_join( tA, tB )

    for _, v in each( tB or {} ) do

        table.insert( tA, v )
    end

    return tA
end
