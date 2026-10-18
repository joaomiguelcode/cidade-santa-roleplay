-- ponytail: debug temporário pra caçar CTD no fluxo DecibelSpawn (Fronteira/Krown); remover quando o crash for identificado.
-- Embrulha os nativos do fluxo de spawn e loga cada chamada com args, contador e origem (arquivo:linha).
-- Leitura do crash: no CitizenFX.log do player, a última linha "[nsdbg] ->" SEM o "<-" correspondente
-- é o nativo que derrubou o client.
-- Desligar sem deploy: setr newspawn_debug "0"

local city = GetConvar( 'cityName', '' )
local enabled = ( city == 'Fronteira' or city == 'Krown' ) and GetConvar( 'newspawn_debug', '1' ) ~= '0'

-- Logger global usado por todos os arquivos do resource. O @sx/linker.lua yielda (Wait) durante o
-- load, então `sx` pode não existir ainda quando os client scripts rodam top-level — fallback pra print.
if not enabled then
    function NsDbgLog() end
    return
end

function NsDbgLog( msg )
    if sx and sx.logger then
        sx.logger:debug( msg )
    else
        print( msg )
    end
end

-- true = nativo chamado em loop de polling; loga no máximo 1x/segundo pra não inundar o log
local TRACKED = {
    -- streaming / load scene / focus
    ['NewLoadSceneStart']                        = false,
    ['NewLoadSceneStartSphere']                  = false,
    ['NewLoadSceneStop']                         = false,
    ['IsNewLoadSceneLoaded']                     = true,
    ['IsNewLoadSceneActive']                     = true,
    ['SetFocusArea']                             = false,
    ['SetFocusPosAndVel']                        = true,
    ['ClearFocus']                               = false,
    ['RequestCollisionAtCoord']                  = false,
    ['HasCollisionLoadedAroundEntity']           = true,
    -- interior
    ['GetInteriorAtCoords']                      = false,
    ['RefreshInterior']                          = false,
    ['PinInteriorInMemory']                      = false,
    ['IsInteriorReady']                          = true,
    -- área / mundo
    ['ClearAreaOfEverything']                    = false,
    -- models / anims
    ['RequestModel']                             = true,
    ['HasModelLoaded']                           = true,
    ['IsModelValid']                             = false,
    ['SetModelAsNoLongerNeeded']                 = false,
    ['RequestAnimDict']                          = true,
    ['HasAnimDictLoaded']                        = true,
    ['RemoveAnimDict']                           = false,
    -- peds / entidades
    ['CreatePed']                                = false,
    ['DeleteEntity']                             = false,
    ['DoesEntityExist']                          = true,
    ['SetEntityCoords']                          = false,
    ['SetEntityCoordsNoOffset']                  = false,
    ['SetEntityHeading']                         = false,
    ['SetEntityCollision']                       = false,
    ['SetEntityInvincible']                      = false,
    ['SetEntityVisible']                         = false,
    ['SetEntityAlpha']                           = false,
    ['SetEntityHealth']                          = false,
    ['FreezeEntityPosition']                     = false,
    ['SetBlockingOfNonTemporaryEvents']          = false,
    ['SetPedArmour']                             = false,
    ['SetPedDefaultComponentVariation']          = false,
    ['SetPlayerModel']                           = false,
    ['SetPlayerControl']                         = false,
    ['ClearPedTasksImmediately']                 = false,
    ['TaskPlayAnim']                             = false,
    ['TaskStartScenarioInPlace']                 = false,
    ['GetPedBoneCoords']                         = false,
    ['GetEntityForwardVector']                   = false,
    ['GetEntityHeading']                         = false,
    ['GetOffsetFromCoordAndHeadingInWorldCoords'] = false,
    ['GetOffsetFromEntityInWorldCoords']         = false,
    -- câmeras
    ['CreateCam']                                = false,
    ['CreateCamWithParams']                      = false,
    ['DestroyCam']                               = false,
    ['DestroyAllCams']                           = false,
    ['DoesCamExist']                             = true,
    ['SetCamActive']                             = false,
    ['SetCamActiveWithInterp']                   = false,
    ['IsCamActive']                              = true,
    ['IsCamRendering']                           = false,
    ['RenderScriptCams']                         = false,
    ['SetCamFov']                                = false,
    ['SetCamCoord']                              = true,
    ['SetCamRot']                                = false,
    ['GetCamCoord']                              = true,
    ['GetCamRot']                                = true,
    ['GetCamFov']                                = true,
    ['PointCamAtCoord']                          = false,
    ['PointCamAtEntity']                         = false,
    ['StopCamPointing']                          = false,
    ['AddCamSplineNode']                         = false,
    ['SetCamSplineSmoothingStyle']               = false,
    ['SetCamSplinePhase']                        = false,
    ['GetCamSplinePhase']                        = true,
    ['InterpolateCamWithParams']                 = false,
    ['ShakeCam']                                 = true,
    ['SetGameplayCamRelativeHeading']            = false,
    ['SetCamUseShallowDofMode']                  = false,
    ['SetCamNearDof']                            = false,
    ['SetCamFarDof']                             = false,
    ['SetCamDofStrength']                        = false,
    ['SetUseHiDof']                              = true,
    -- tela / UI
    ['DoScreenFadeIn']                           = false,
    ['DoScreenFadeOut']                          = false,
    ['IsScreenFadedOut']                         = true,
    ['DisplayRadar']                             = false,
    ['ShutdownLoadingScreen']                    = false,
    ['GetIsLoadingScreenActive']                 = true,
    ['SetNuiFocus']                              = false,
    -- threads
    ['TerminateThread']                          = false,
}

-- nativos cujo 1º argumento é entity/ped: loga também se a entity ainda existe.
-- "exists=false" numa chamada = handle velho (ex.: ped capturado antes de SetPlayerModel).
local ENTITY_ARG = {
    ['SetEntityCoords'] = true, ['SetEntityCoordsNoOffset'] = true, ['SetEntityHeading'] = true,
    ['SetEntityCollision'] = true, ['SetEntityInvincible'] = true, ['SetEntityVisible'] = true,
    ['SetEntityAlpha'] = true, ['SetEntityHealth'] = true, ['FreezeEntityPosition'] = true,
    ['SetBlockingOfNonTemporaryEvents'] = true, ['SetPedArmour'] = true,
    ['SetPedDefaultComponentVariation'] = true, ['ClearPedTasksImmediately'] = true,
    ['TaskPlayAnim'] = true, ['TaskStartScenarioInPlace'] = true,
    ['GetPedBoneCoords'] = true, ['GetEntityForwardVector'] = true, ['GetEntityHeading'] = true,
    ['DeleteEntity'] = true, ['HasCollisionLoadedAroundEntity'] = true,
}

local counters = {}
local origDoesEntityExist = DoesEntityExist

local function fmtVarArgs(...)
    local n = select( '#', ... )
    local parts = {}
    for i = 1, n do
        parts[i] = tostring( ( select( i, ... ) ) )
    end
    return table.concat( parts, ', ' )
end

for name, throttled in pairs( TRACKED ) do
    local orig = _G[name]
    if type( orig ) == 'function' then
        counters[name] = { count = 0, lastLog = 0 }
        _G[name] = function(...)
            local c = counters[name]
            c.count = c.count + 1

            local shouldLog = true
            if throttled then
                local now = GetGameTimer()
                shouldLog = now - c.lastLog >= 1000
                if shouldLog then c.lastLog = now end
            end

            if shouldLog then
                local extra = ''
                if ENTITY_ARG[name] then
                    local ent = ...
                    local exists = type( ent ) == 'number' and ent ~= 0 and origDoesEntityExist( ent )
                    extra = (' exists=%s'):format( tostring( exists ) )
                elseif name == 'SetPlayerModel' then
                    extra = (' pedBefore=%s'):format( PlayerPedId() )
                end
                local info = debug.getinfo( 2, 'Sl' )
                local src = info and ('%s:%s'):format( info.short_src, info.currentline or '?' ) or '?'
                NsDbgLog( ('[nsdbg] -> %s(%s)%s #%d @ %s'):format( name, fmtVarArgs(...), extra, c.count, src ) )
            end

            local ret = table.pack( orig(...) )

            if shouldLog then
                local extra = name == 'SetPlayerModel' and (' pedAfter=%s'):format( PlayerPedId() ) or ''
                NsDbgLog( ('[nsdbg] <- %s = %s%s'):format( name, fmtVarArgs( table.unpack( ret, 1, ret.n ) ), extra ) )
            end

            return table.unpack( ret, 1, ret.n )
        end
    end
end

-- monitora troca do handle do ped do player (SetPlayerModel invalida o handle antigo):
-- correlaciona "PlayerPedId mudou X -> Y" com nativos chamados depois usando X (exists=false)
CreateThread(function()
    local last = PlayerPedId()
    while true do
        local cur = PlayerPedId()
        if cur ~= last then
            NsDbgLog( ('[nsdbg] PlayerPedId mudou %s -> %s (model=%s)'):format( last, cur, GetEntityModel( cur ) ) )
            last = cur
        end
        Wait(100)
    end
end)

NsDbgLog( ('[nsdbg] native tracer ativo city=%s'):format( city ) )
