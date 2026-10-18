-- =============================================================================
-- PvP HUD — Comandos de teste / dev
-- -----------------------------------------------------------------------------
-- Cada comando dispara um `pvp.hud:<event>` para validar o NUI sem precisar
-- iniciar uma partida real. Tudo passa pela ponte em `pvp.lua`, então testa
-- também o relay.
--
-- Use `/pvphud help` em-jogo para listar tudo.
-- =============================================================================

local AVATAR = 'https://i.pravatar.cc/150?u=pvphud-dev'

local function fire( action, payload )
    TriggerEvent( 'pvp.hud:' .. action, payload )
end

local function toNumber( v, default )
    return tonumber( v ) or default
end

local function toBool( v )
    return v == 'true' or v == '1' or v == 'yes'
end

-- =============================================
-- HUD básico
-- =============================================

RegisterCommand( 'pvphud_show',  function() fire( 'showHud' ) end, false )
RegisterCommand( 'pvphud_hide',  function() fire( 'hideHud' ) end, false )

RegisterCommand( 'pvphud_mode', function( _, args )
    local mode = args[1] or 'TEAM_DEATHMATCH'
    fire( 'setHudMode', { mode = mode } )
    print( ('[pvphud] setHudMode -> %s'):format( mode ) )
end, false )

RegisterCommand( 'pvphud_score', function( _, args )
    local a = toNumber( args[1], 0 )
    local b = toNumber( args[2], 0 )
    fire( 'updateHudScore', {
        team1     = a,
        team2     = b,
        team1Name = args[3] or 'TeamA',
        team2Name = args[4] or 'TeamB',
    } )
    print( ('[pvphud] updateHudScore -> %d x %d'):format( a, b ) )
end, false )

RegisterCommand( 'pvphud_status', function( _, args )
    local hp    = toNumber( args[1], 100 )
    local armor = toNumber( args[2], 50 )
    fire( 'updateHudStatus', { health = hp, armor = armor } )
    print( ('[pvphud] updateHudStatus -> hp=%d armor=%d'):format( hp, armor ) )
end, false )

RegisterCommand( 'pvphud_weapon', function( _, args )
    if args[1] == 'null' or args[1] == 'nil' or args[1] == 'clear' then
        fire( 'updateHudWeapon', nil )
        print( '[pvphud] updateHudWeapon -> null' )
        return
    end
    local payload = {
        name    = args[1] or 'G3',
        ammo    = toNumber( args[2], 30 ),
        maxAmmo = toNumber( args[3], 30 ),
    }
    fire( 'updateHudWeapon', payload )
    print( ('[pvphud] updateHudWeapon -> %s %d/%d'):format( payload.name, payload.ammo, payload.maxAmmo ) )
end, false )

RegisterCommand( 'pvphud_slots', function()
    fire( 'updateHudSlotItems', {
        { slot = 1, name = 'G3',     image = '', active = true  },
        { slot = 2, name = 'Pistol', image = '', active = false },
        { slot = 3, name = 'Knife',  image = '', active = false },
    } )
    print( '[pvphud] updateHudSlotItems -> 3 itens' )
end, false )

-- =============================================
-- Kill feed
-- =============================================

local killFeedCounter = 0
RegisterCommand( 'pvphud_kill', function( _, args )
    killFeedCounter = killFeedCounter + 1
    fire( 'addKillFeedItem', {
        id            = 'dev-' .. killFeedCounter,
        killer        = args[1] or 'Killer',
        victim        = args[2] or 'Victim',
        weapon        = args[3] or 'rifle',
        isHeadshot    = toBool( args[4] ),
        killerTeamStr = 'blue',
        victimTeamStr = 'red',
    } )
    print( ('[pvphud] addKillFeedItem -> %s killed %s'):format( args[1] or 'Killer', args[2] or 'Victim' ) )
end, false )

RegisterCommand( 'pvphud_clearkill', function() fire( 'clearKillFeed' ) end, false )

-- =============================================
-- Kill notification (popup destaque)
-- =============================================

RegisterCommand( 'pvphud_killnotif', function( _, args )
    fire( 'showKillNotification', {
        killer     = args[1] or 'You',
        victim     = args[2] or 'Enemy',
        isHeadshot = toBool( args[3] ),
    } )
    print( '[pvphud] showKillNotification' )
end, false )

RegisterCommand( 'pvphud_hidekillnotif', function() fire( 'hideKillNotification' ) end, false )

-- =============================================
-- Countdown
-- =============================================

RegisterCommand( 'pvphud_count', function( _, args )
    local n     = toNumber( args[1], 5 )
    local label = args[2] or 'Round 1'
    fire( 'showCountdown', { count = n, label = label } )
    print( ('[pvphud] showCountdown -> %d "%s"'):format( n, label ) )
end, false )

RegisterCommand( 'pvphud_countdown', function( _, args )
    local n = toNumber( args[1], 5 )
    fire( 'updateCountdown', n )
    print( ('[pvphud] updateCountdown -> %d'):format( n ) )
end, false )

RegisterCommand( 'pvphud_hidecount', function() fire( 'hideCountdown' ) end, false )

-- Sequência countdown realista: conta de 5 -> 1
RegisterCommand( 'pvphud_countseq', function( _, args )
    local label = args[1] or 'Round 1'
    CreateThread( function()
        for i = 5, 1, -1 do
            fire( 'showCountdown', { count = i, label = label } )
            Wait( 1000 )
        end
        fire( 'hideCountdown' )
    end )
end, false )

-- =============================================
-- Match start / result
-- =============================================

local function mockTeam( name, players )
    local out = { name = name, players = {} }
    for i = 1, players do
        out.players[i] = {
            name   = ('%s P%d'):format( name, i ),
            level  = math.random( 1, 50 ),
            avatar = AVATAR,
            isVip  = i == 1,
        }
    end
    return out
end

RegisterCommand( 'pvphud_matchstart', function( _, args )
    local mode    = args[1] or 'TEAM_DEATHMATCH'
    local mapName = args[2] or 'Arena PVP'
    fire( 'openMatchStart', {
        team1   = mockTeam( 'TeamA', 5 ),
        team2   = mockTeam( 'TeamB', 5 ),
        mapName = mapName,
        mode    = mode,
    } )
    print( ('[pvphud] openMatchStart -> %s @ %s'):format( mode, mapName ) )
end, false )

RegisterCommand( 'pvphud_matchstart_close', function() fire( 'closeMatchStart' ) end, false )

RegisterCommand( 'pvphud_matchresult', function( _, args )
    local victory = toBool( args[1] or 'true' )
    fire( 'openMatchResult', {
        stats = {
            kills     = 12,
            deaths    = 7,
            assists   = 4,
            headshots = 5,
            points    = victory and 70 or -50,
            level     = 14,
            currentXp = 740,
            maxXp     = 1000,
            isVictory = victory,
            mode      = 'TEAM_DEATHMATCH',
            victory   = victory,
        },
        topPlayers = {
            { rank = 1, name = 'MVP',      avatar = AVATAR, kills = 18, deaths = 4, team = 'TeamA' },
            { rank = 2, name = 'Player B', avatar = AVATAR, kills = 12, deaths = 7, team = 'TeamA' },
            { rank = 3, name = 'Player C', avatar = AVATAR, kills = 9,  deaths = 8, team = 'TeamB' },
        },
    } )
    print( ('[pvphud] openMatchResult -> victory=%s'):format( tostring( victory ) ) )
end, false )

RegisterCommand( 'pvphud_matchresult_close', function() fire( 'closeMatchResult' ) end, false )

-- =============================================
-- Level up
-- =============================================

RegisterCommand( 'pvphud_levelup', function( _, args )
    local level = toNumber( args[1], 10 )
    fire( 'openLevelUp', { level = level, previousLevel = level - 1 } )
    print( ('[pvphud] openLevelUp -> %d'):format( level ) )
end, false )

RegisterCommand( 'pvphud_levelup_close', function() fire( 'closeLevelUp' ) end, false )

-- =============================================
-- Map vote
-- =============================================

RegisterCommand( 'pvphud_mapvote', function( _, args )
    local duration = toNumber( args[1], 30000 )
    fire( 'openMapVote', {
        maps = {
            { id = 'arena',   name = 'Arena PVP',    image = AVATAR, votes = 0 },
            { id = 'desert',  name = 'Deserto',      image = AVATAR, votes = 0 },
            { id = 'urban',   name = 'Cidade',       image = AVATAR, votes = 0 },
        },
        duration = duration,
    } )
    print( ('[pvphud] openMapVote -> duration=%dms'):format( duration ) )
end, false )

RegisterCommand( 'pvphud_mapvote_update', function()
    fire( 'updateMapVotes', {
        { mapId = 'arena',  votes = math.random( 0, 5 ) },
        { mapId = 'desert', votes = math.random( 0, 5 ) },
        { mapId = 'urban',  votes = math.random( 0, 5 ) },
    } )
    print( '[pvphud] updateMapVotes' )
end, false )

RegisterCommand( 'pvphud_mapvote_close', function() fire( 'closeMapVote' ) end, false )

-- =============================================
-- Team selection
-- =============================================

RegisterCommand( 'pvphud_teamselect',       function() fire( 'openTeamSelection' ) end, false )
RegisterCommand( 'pvphud_teamselect_close', function() fire( 'closeTeamSelection' ) end, false )

-- =============================================
-- Scoreboard
-- =============================================

RegisterCommand( 'pvphud_scoreboard', function()
    fire( 'openScoreboard', {
        { rank = 1, name = 'Player A', avatar = AVATAR, kills = 18, deaths = 4,  assists = 3, level = 28, team = 'TeamA' },
        { rank = 2, name = 'Player B', avatar = AVATAR, kills = 12, deaths = 7,  assists = 5, level = 22, team = 'TeamA' },
        { rank = 3, name = 'Player C', avatar = AVATAR, kills = 9,  deaths = 8,  assists = 2, level = 19, team = 'TeamB' },
        { rank = 4, name = 'Player D', avatar = AVATAR, kills = 6,  deaths = 11, assists = 1, level = 14, team = 'TeamB' },
    } )
    print( '[pvphud] openScoreboard' )
end, false )

RegisterCommand( 'pvphud_scoreboard_close', function() fire( 'closeScoreboard' ) end, false )

-- =============================================
-- Gun Game ranking lateral
-- =============================================

RegisterCommand( 'pvphud_gungame', function()
    fire( 'updateGunGameRankings', {
        { rank = 1, name = 'Player 1', level = 30, avatar = AVATAR, isCurrentPlayer = false },
        { rank = 2, name = 'Player 2', level = 28, avatar = AVATAR, isCurrentPlayer = true  },
        { rank = 3, name = 'Player 3', level = 20, avatar = AVATAR, isCurrentPlayer = false },
        { rank = 4, name = 'Player 4', level = 16, avatar = AVATAR, isCurrentPlayer = false },
    } )
    print( '[pvphud] updateGunGameRankings' )
end, false )

-- =============================================
-- Catch-all
-- =============================================

RegisterCommand( 'pvphud_hideall', function() fire( 'hideAllPvP' ) end, false )

-- =============================================
-- Demo orquestrado: simula uma partida do início ao fim
-- =============================================

RegisterCommand( 'pvphud_demo', function()
    print( '[pvphud] demo iniciado' )
    CreateThread( function()
        fire( 'setHudMode', { mode = 'TEAM_DEATHMATCH' } )
        fire( 'openMatchStart', {
            team1   = mockTeam( 'TeamA', 5 ),
            team2   = mockTeam( 'TeamB', 5 ),
            mapName = 'Arena PVP',
            mode    = 'TEAM_DEATHMATCH',
        } )
        Wait( 4000 )
        fire( 'closeMatchStart' )

        fire( 'showHud' )
        fire( 'updateHudScore', { team1 = 0, team2 = 0, team1Name = 'TeamA', team2Name = 'TeamB' } )
        fire( 'updateHudStatus', { health = 100, armor = 100 } )
        fire( 'updateHudWeapon', { name = 'G3', ammo = 30, maxAmmo = 30 } )

        for i = 5, 1, -1 do
            fire( 'showCountdown', { count = i, label = 'Round 1' } )
            Wait( 1000 )
        end
        fire( 'hideCountdown' )

        for i = 1, 4 do
            killFeedCounter = killFeedCounter + 1
            fire( 'addKillFeedItem', {
                id            = 'demo-' .. killFeedCounter,
                killer        = 'Player A',
                victim        = 'Enemy ' .. i,
                weapon        = 'rifle',
                isHeadshot    = i % 2 == 0,
                killerTeamStr = 'blue',
                victimTeamStr = 'red',
            } )
            fire( 'updateHudScore', { team1 = i, team2 = i - 1, team1Name = 'TeamA', team2Name = 'TeamB' } )
            fire( 'updateHudStatus', { health = math.max( 10, 100 - i * 15 ), armor = math.max( 0, 100 - i * 20 ) } )
            fire( 'updateHudWeapon', { name = 'G3', ammo = 30 - i * 4, maxAmmo = 30 } )
            if i == 2 then
                fire( 'showKillNotification', { killer = 'You', victim = 'Enemy 2', isHeadshot = true } )
                Wait( 800 )
                fire( 'hideKillNotification' )
            end
            Wait( 1500 )
        end

        fire( 'hideHud' )
        Wait( 500 )
        fire( 'openMatchResult', {
            stats = {
                kills     = 4,
                deaths    = 1,
                assists   = 0,
                headshots = 2,
                points    = 70,
                level     = 14,
                currentXp = 740,
                maxXp     = 1000,
                isVictory = true,
                victory   = true,
                mode      = 'TEAM_DEATHMATCH',
            },
            topPlayers = {
                { rank = 1, name = 'You',      avatar = AVATAR, kills = 4, deaths = 1, team = 'TeamA' },
                { rank = 2, name = 'Player B', avatar = AVATAR, kills = 3, deaths = 2, team = 'TeamA' },
                { rank = 3, name = 'Player C', avatar = AVATAR, kills = 2, deaths = 3, team = 'TeamB' },
            },
        } )
        Wait( 6000 )
        fire( 'closeMatchResult' )
        fire( 'hideAllPvP' )
        print( '[pvphud] demo finalizado' )
    end )
end, false )

-- =============================================
-- Help
-- =============================================

RegisterCommand( 'pvphud', function( _, args )
    if args[1] ~= 'help' and args[1] ~= nil then return end
    print( '[pvphud] comandos disponíveis:' )
    print( '  /pvphud_show | /pvphud_hide | /pvphud_hideall' )
    print( '  /pvphud_mode <TEAM_DEATHMATCH|GUN_GAME|ROUND_TIMER|DESCE_QUEBRA>' )
    print( '  /pvphud_score <a> <b> [nameA] [nameB]' )
    print( '  /pvphud_status <hp> <armor>' )
    print( '  /pvphud_weapon <name> <ammo> <max>   (use "clear" para null)' )
    print( '  /pvphud_slots' )
    print( '  /pvphud_kill <killer> <victim> <weapon> [hs]' )
    print( '  /pvphud_clearkill' )
    print( '  /pvphud_killnotif <killer> <victim> [hs] | /pvphud_hidekillnotif' )
    print( '  /pvphud_count <n> <label> | /pvphud_countdown <n> | /pvphud_hidecount | /pvphud_countseq <label>' )
    print( '  /pvphud_matchstart [mode] [mapName] | /pvphud_matchstart_close' )
    print( '  /pvphud_matchresult [victory=true|false] | /pvphud_matchresult_close' )
    print( '  /pvphud_levelup <level> | /pvphud_levelup_close' )
    print( '  /pvphud_mapvote [durationMs] | /pvphud_mapvote_update | /pvphud_mapvote_close' )
    print( '  /pvphud_teamselect | /pvphud_teamselect_close' )
    print( '  /pvphud_scoreboard | /pvphud_scoreboard_close' )
    print( '  /pvphud_gungame' )
    print( '  /pvphud_demo  (simula partida completa)' )
end, false )
