---Traduções do framework compartilhadas entre todos os minigames
---Define as traduções e cria a classe via TranslationManager

---Traduções disponíveis
local translations = {
    ['en-us'] = {
        -- Ghost mode
        ['ghost_mode_active'] = 'You are a ghost, wait until the start of the next round.',
    },

    ['es-es'] = {
        -- Ghost mode
        ['ghost_mode_active'] = 'Eres un fantasma, espera hasta el inicio de la próxima ronda.',
    },

    ['pt-br'] = {
        -- Ghost mode
        ['ghost_mode_active'] = 'Você é um fantasma, aguarde até o início da próxima rodada.',

        -- Boundary check
        ['boundary_title'] = 'Área de Jogo',
        ['boundary_near_limit'] = 'Você está se aproximando do limite da área!',
        ['boundary_outside'] = 'Você está fora da área! Retorne ou será teleportado.',
        ['boundary_return_seconds'] = 'Retorne à área em %ds!',
        ['boundary_teleported_back'] = 'Você foi teleportado de volta à área!',
        ['boundary_returned'] = 'Você voltou para a área segura!',

        -- State descriptions
        ['state_none'] = 'Nenhum estado ativo',
        ['state_queue'] = 'Na fila de matchmaking',
        ['state_match_intro'] = 'Introdução da partida',
        ['state_match_gameplay'] = 'Jogando',
        ['state_match_spectator'] = 'Espectador (morto)',
        ['state_match_ended'] = 'Partida finalizada',
        ['state_starting'] = 'Iniciando',
        ['state_in_progress'] = 'Em andamento',
        ['state_ended'] = 'Finalizado',
        ['state_waiting'] = 'Aguardando',
        ['state_unknown'] = 'Desconhecido',

        -- Framework errors
        ['player_manager_missing_source_userid'] = 'Source e userId são obrigatórios',
        ['player_manager_already_in_match'] = 'Jogador já está no match',
        ['player_manager_already_waiting'] = 'Jogador já está em waitingPlayers',
        ['queue_full_max'] = 'Fila cheia (limite máximo)',
        ['queue_full'] = 'Fila cheia',
        ['queue_match_already_started'] = 'Partida já iniciada',
        ['queue_match_full'] = 'Partida cheia',
        ['queue_full_limit'] = 'Fila cheia (limite atingido)',
        ['queue_match_full_late_join'] = 'Partida cheia (late join bloqueado)',
        ['queue_add_match_failed'] = 'Falha ao adicionar jogador à partida',
        ['minigame_matchmaking_not_configured'] = 'Matchmaking não configurado para este minigame',
        ['minigame_player_already_in_queue'] = 'Jogador já está em uma fila',
        ['minigame_create_queue_failed'] = 'Não foi possível criar uma nova fila',
        ['minigame_player_not_in_queue'] = 'Jogador não está em nenhuma fila',
        ['minigame_player_not_in_match'] = 'Jogador não está em nenhuma partida',
        ['minigame_no_match_in_progress'] = 'Nenhuma partida em progresso encontrada',
    },

    ['fr-fr'] = {
        -- Ghost mode
        ['ghost_mode_active'] = 'Vous êtes un fantôme, attendez le début du prochain round.',
    },

    ['pt-pt'] = {
        -- Ghost mode
        ['ghost_mode_active'] = 'És um fantasma, aguarda até ao início da próxima ronda.',
    },

    ['de-de'] = {
        ['ghost_mode_active'] = 'Du bist ein Geist, warte bis zur nächsten Runde.',
    },

    ['ar-sa'] = {
        ['ghost_mode_active'] = 'أنت شبح، انتظر حتى بداية الجولة التالية.',
    },
}

---@class FrameworkTranslations
FrameworkTranslations = TranslationManager.createTranslationClass('framework', translations)
