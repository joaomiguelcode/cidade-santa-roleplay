---Sistema de traduções do Murder
---Define as traduções e cria a classe via TranslationManager

---Traduções disponíveis
local translations = {
    ['en-us'] = {
        -- Conversation / NPC UI
        ['conversation_name'] = 'Detective',
        ['conversation_tag'] = 'DETECTIVE',
        ['conversation_esc_text'] = 'to close',
        ['conversation_description'] = 'Ready to face a new case?',
        ['btn_play'] = 'Play Murder',
        ['btn_ranking'] = 'Open Ranking',

        -- Queue notifications
        ['queue_left'] = 'You left the Murder queue',
        ['queue_timeout'] = 'The Murder queue expired due to time limit',

        -- Match notifications
        ['match_started'] = 'Match started!',
        ['match_ended'] = 'Match ended',
        ['match_left'] = 'You left the Murder match',
        ['round_started'] = 'Round started',
        ['round_ended'] = 'Round ended',

        -- Role notifications
        ['role_assassin'] = 'You are the Assassin! Eliminate all survivors',
        ['role_detective'] = 'You are the Detective! Find and stop the Assassin',
        ['role_innocent'] = 'You are Innocent! Survive and help find the Assassin',

        -- Death notifications
        ['you_died'] = 'You died',
        ['player_eliminated'] = 'Player eliminated',

        -- Victory notifications
        ['assassin_win'] = 'Assassins won!',
        ['innocents_win'] = 'Innocents won!',
        ['detective_win'] = 'Detective won!',

        -- Weapon notifications
        ['weapon_pickup'] = 'Weapon picked up',
        ['weapon_dropped'] = 'Weapon dropped',

        -- General
        ['waiting_players'] = 'Waiting for players...',
        ['match_starting'] = 'Match starting in %s seconds',
        ['players_remaining'] = '%s players remaining',

        -- Notification messages
        ['new_assassin_action'] = 'A new Assassin has entered the Action.',
        ['promoted_to_assassin'] = 'You have been promoted to Assassin.',
        ['detective_weapon_dropped'] = 'The Detective\'s weapon has been dropped.',
        ['new_detective_assigned'] = 'A new Detective has been assigned to the case.',
        ['promoted_to_detective'] = 'You have been promoted to Detective.',
        ['detective_weapon_pickup'] = 'You picked up the Detective\'s weapon!',


        -- Scoreboard / time formatting
        ['time_hours'] = ' hours',
        ['time_min'] = ' min',
        ['time_seconds'] = ' s',
        ['player_fallback'] = 'Player ',
    },

    ['es-es'] = {
        -- Conversation / NPC UI
        ['conversation_name'] = 'Detective',
        ['conversation_tag'] = 'DETECTIVE',
        ['conversation_esc_text'] = 'para cerrar',
        ['conversation_description'] = '¿Listo para enfrentar un nuevo caso?',
        ['btn_play'] = 'Jugar Murder',
        ['btn_ranking'] = 'Abrir Ranking',

        -- Queue notifications
        ['queue_left'] = 'Saliste de la cola de Murder',
        ['queue_timeout'] = 'La cola de Murder expiró por límite de tiempo',

        -- Match notifications
        ['match_started'] = '¡Partida iniciada!',
        ['match_ended'] = 'Partida finalizada',
        ['match_left'] = 'Dejaste la partida de Murder',
        ['round_started'] = 'Ronda iniciada',
        ['round_ended'] = 'Ronda finalizada',

        -- Role notifications
        ['role_assassin'] = '¡Eres el Asesino! Elimina a todos los supervivientes',
        ['role_detective'] = '¡Eres el Detective! Encuentra y detén al Asesino',
        ['role_innocent'] = '¡Eres Inocente! Sobrevive y ayuda a encontrar al Asesino',

        -- Death notifications
        ['you_died'] = 'Has muerto',
        ['player_eliminated'] = 'Jugador eliminado',

        -- Victory notifications
        ['assassin_win'] = '¡Los Asesinos ganaron!',
        ['innocents_win'] = '¡Los Inocentes ganaron!',
        ['detective_win'] = '¡El Detective ganó!',

        -- Weapon notifications
        ['weapon_pickup'] = 'Arma recogida',
        ['weapon_dropped'] = 'Arma soltada',

        -- General
        ['waiting_players'] = 'Esperando jugadores...',
        ['match_starting'] = 'Partida comienza en %s segundos',
        ['players_remaining'] = '%s jugadores restantes',

        -- Notification messages
        ['new_assassin_action'] = 'Un nuevo Asesino ha entrado en Acción.',
        ['promoted_to_assassin'] = 'Has sido promovido a Asesino.',
        ['detective_weapon_dropped'] = 'El arma del Detective ha sido dejada en el suelo.',
        ['new_detective_assigned'] = 'Un nuevo Detective ha sido asignado al caso.',
        ['promoted_to_detective'] = 'Has sido promovido a Detective.',
        ['detective_weapon_pickup'] = '¡Has recogido el arma del Detective!',


        -- Scoreboard / time formatting
        ['time_hours'] = ' horas',
        ['time_min'] = ' min',
        ['time_seconds'] = ' s',
        ['player_fallback'] = 'Jugador ',
    },

    ['pt-br'] = {
        -- Conversation / NPC UI
        ['conversation_name'] = 'Detetive',
        ['conversation_tag'] = 'DETETIVE',
        ['conversation_esc_text'] = 'para fechar',
        ['conversation_description'] = 'Pronto para encarar um novo caso?',
        ['btn_play'] = 'Jogar Murder',
        ['btn_ranking'] = 'Abrir Ranking',

        -- Queue notifications
        ['queue_left'] = 'Você saiu da fila do Murder',
        ['queue_timeout'] = 'A fila do Murder expirou por tempo limite',

        -- Match notifications
        ['match_started'] = 'Partida iniciada!',
        ['match_ended'] = 'Partida encerrada',
        ['match_left'] = 'Você deixou a partida do Murder Game',
        ['round_started'] = 'Rodada iniciada',
        ['round_ended'] = 'Rodada encerrada',

        -- Role notifications
        ['role_assassin'] = 'Você é o Assassino! Elimine todos os sobreviventes',
        ['role_detective'] = 'Você é o Detetive! Encontre e pare o Assassino',
        ['role_innocent'] = 'Você é Inocente! Sobreviva e ajude a encontrar o Assassino',

        -- Death notifications
        ['you_died'] = 'Você morreu',
        ['player_eliminated'] = 'Jogador eliminado',

        -- Victory notifications
        ['assassin_win'] = 'Assassinos venceram!',
        ['innocents_win'] = 'Inocentes venceram!',
        ['detective_win'] = 'Detetive venceu!',

        -- Weapon notifications
        ['weapon_pickup'] = 'Arma coletada',
        ['weapon_dropped'] = 'Arma largada',

        -- General
        ['waiting_players'] = 'Aguardando jogadores...',
        ['match_starting'] = 'Partida começa em %s segundos',
        ['players_remaining'] = '%s jogadores restantes',

        -- Notification messages
        ['new_assassin_action'] = 'Um novo Assassino entrou em Ação.',
        ['promoted_to_assassin'] = 'Você foi promovido a Assassino.',
        ['detective_weapon_dropped'] = 'A arma do Detetive foi deixada no chão.',
        ['new_detective_assigned'] = 'Um novo Detetive foi designado para o caso.',
        ['promoted_to_detective'] = 'Você foi promovido a Detetive.',
        ['detective_weapon_pickup'] = 'Você pegou a arma do Detetive!',


        -- Scoreboard / time formatting
        ['time_hours'] = ' horas',
        ['time_min'] = ' min',
        ['time_seconds'] = ' s',
        ['player_fallback'] = 'Jogador ',
    },

    ['fr-fr'] = {
        -- Conversation / NPC UI
        ['conversation_name'] = 'Détective',
        ['conversation_tag'] = 'DÉTECTIVE',
        ['conversation_esc_text'] = 'pour fermer',
        ['conversation_description'] = 'Prêt à affronter une nouvelle affaire ?',
        ['btn_play'] = 'Jouer au Murder',
        ['btn_ranking'] = 'Ouvrir le classement',

        -- Queue notifications
        ['queue_left'] = 'Vous avez quitté la file du Murder',
        ['queue_timeout'] = 'La file du Murder a expiré (temps limite)',

        -- Match notifications
        ['match_started'] = 'Partie commencée !',
        ['match_ended'] = 'Partie terminée',
        ['match_left'] = 'Vous avez quitté la partie Murder',
        ['round_started'] = 'Round commencé',
        ['round_ended'] = 'Round terminé',

        -- Role notifications
        ['role_assassin'] = 'Vous êtes l\'Assassin ! Éliminez tous les survivants',
        ['role_detective'] = 'Vous êtes le Détective ! Trouvez et stoppez l\'Assassin',
        ['role_innocent'] = 'Vous êtes Innocent ! Survivez et aidez à trouver l\'Assassin',

        -- Death notifications
        ['you_died'] = 'Vous êtes mort',
        ['player_eliminated'] = 'Joueur éliminé',

        -- Victory notifications
        ['assassin_win'] = 'Les Assassins ont gagné !',
        ['innocents_win'] = 'Les Innocents ont gagné !',
        ['detective_win'] = 'Le Détective a gagné !',

        -- Weapon notifications
        ['weapon_pickup'] = 'Arme ramassée',
        ['weapon_dropped'] = 'Arme lâchée',

        -- General
        ['waiting_players'] = 'En attente de joueurs...',
        ['match_starting'] = 'Partie dans %s secondes',
        ['players_remaining'] = '%s joueurs restants',

        -- Notification messages
        ['new_assassin_action'] = 'Un nouvel Assassin est entré en action.',
        ['promoted_to_assassin'] = 'Vous avez été promu Assassin.',
        ['detective_weapon_dropped'] = 'L\'arme du Détective a été lâchée.',
        ['new_detective_assigned'] = 'Un nouveau Détective a été assigné à l\'affaire.',
        ['promoted_to_detective'] = 'Vous avez été promu Détective.',
        ['detective_weapon_pickup'] = 'Vous avez ramassé l\'arme du Détective !',

        -- Scoreboard / time formatting
        ['time_hours'] = ' h',
        ['time_min'] = ' min',
        ['time_seconds'] = ' s',
        ['player_fallback'] = 'Joueur ',
    },

    ['pt-pt'] = {
        -- Conversation / NPC UI
        ['conversation_name'] = 'Detetive',
        ['conversation_tag'] = 'DETETIVE',
        ['conversation_esc_text'] = 'para fechar',
        ['conversation_description'] = 'Pronto para enfrentar um novo caso?',
        ['btn_play'] = 'Jogar Murder',
        ['btn_ranking'] = 'Abrir Ranking',

        -- Queue notifications
        ['queue_left'] = 'Saíste da fila do Murder',
        ['queue_timeout'] = 'A fila do Murder expirou por limite de tempo',

        -- Match notifications
        ['match_started'] = 'Partida iniciada!',
        ['match_ended'] = 'Partida terminada',
        ['match_left'] = 'Deixaste a partida de Murder',
        ['round_started'] = 'Ronda iniciada',
        ['round_ended'] = 'Ronda terminada',

        -- Role notifications
        ['role_assassin'] = 'És o Assassino! Elimina todos os sobreviventes',
        ['role_detective'] = 'És o Detective! Encontra e pára o Assassino',
        ['role_innocent'] = 'És Inocente! Sobrevive e ajuda a encontrar o Assassino',

        -- Death notifications
        ['you_died'] = 'Morreste',
        ['player_eliminated'] = 'Jogador eliminado',

        -- Victory notifications
        ['assassin_win'] = 'Assassinos venceram!',
        ['innocents_win'] = 'Inocentes venceram!',
        ['detective_win'] = 'Detective venceu!',

        -- Weapon notifications
        ['weapon_pickup'] = 'Arma apanhada',
        ['weapon_dropped'] = 'Arma largada',

        -- General
        ['waiting_players'] = 'A aguardar jogadores...',
        ['match_starting'] = 'Partida começa em %s segundos',
        ['match_starting'] = 'Partida começa em %s segundos',
        ['players_remaining'] = '%s jogadores restantes',

        -- Notification messages
        ['new_assassin_action'] = 'Um novo Assassino entrou em Ação.',
        ['promoted_to_assassin'] = 'Foste promovido a Assassino.',
        ['detective_weapon_dropped'] = 'A arma do Detective foi deixada no chão.',
        ['new_detective_assigned'] = 'Um novo Detective foi designado para o caso.',
        ['promoted_to_detective'] = 'Foste promovido a Detective.',
        ['detective_weapon_pickup'] = 'Apanhaste a arma do Detective!',

        -- Scoreboard / time formatting
        ['time_hours'] = ' horas',
        ['time_min'] = ' min',
        ['time_seconds'] = ' s',
        ['player_fallback'] = 'Jogador ',
    },

    ['de-de'] = {
        ['conversation_name'] = 'Detektiv',
        ['conversation_tag'] = 'DETEKTIV',
        ['conversation_esc_text'] = 'zum Schließen',
        ['conversation_description'] = 'Bereit für einen neuen Fall?',
        ['btn_play'] = 'Murder spielen',
        ['btn_ranking'] = 'Ranking öffnen',
        ['queue_left'] = 'Du hast die Murder-Warteschlange verlassen',
        ['queue_timeout'] = 'Die Murder-Warteschlange ist abgelaufen',
        ['match_started'] = 'Spiel gestartet!',
        ['match_ended'] = 'Spiel beendet',
        ['match_left'] = 'Du hast das Murder-Spiel verlassen',
        ['round_started'] = 'Runde gestartet',
        ['round_ended'] = 'Runde beendet',
        ['role_assassin'] = 'Du bist der Attentäter! Eliminiere alle Überlebenden',
        ['role_detective'] = 'Du bist der Detektiv! Finde und stoppe den Attentäter',
        ['role_innocent'] = 'Du bist Unschuldig! Überlebe und hilf, den Attentäter zu finden',
        ['you_died'] = 'Du bist gestorben',
        ['player_eliminated'] = 'Spieler eliminiert',
        ['assassin_win'] = 'Attentäter gewinnen!',
        ['innocents_win'] = 'Unschuldige gewinnen!',
        ['detective_win'] = 'Detektiv gewinnt!',
        ['weapon_pickup'] = 'Waffe aufgenommen',
        ['weapon_dropped'] = 'Waffe fallengelassen',
        ['waiting_players'] = 'Warte auf Spieler...',
        ['match_starting'] = 'Spiel startet in %s Sekunden',
        ['players_remaining'] = '%s Spieler übrig',
        ['new_assassin_action'] = 'Ein neuer Attentäter ist in Aktion.',
        ['promoted_to_assassin'] = 'Du wurdest zum Attentäter befördert.',
        ['detective_weapon_dropped'] = 'Die Waffe des Detektivs wurde fallengelassen.',
        ['new_detective_assigned'] = 'Ein neuer Detektiv wurde dem Fall zugewiesen.',
        ['promoted_to_detective'] = 'Du wurdest zum Detektiv befördert.',
        ['detective_weapon_pickup'] = 'Du hast die Waffe des Detektivs aufgenommen!',
        ['time_hours'] = ' Std.',
        ['time_min'] = ' Min',
        ['time_seconds'] = ' s',
        ['player_fallback'] = 'Spieler ',
    },

    ['ar-sa'] = {
        ['conversation_name'] = 'المحقق',
        ['conversation_tag'] = 'المحقق',
        ['conversation_esc_text'] = 'للإغلاق',
        ['conversation_description'] = 'مستعد لمواجهة قضية جديدة؟',
        ['btn_play'] = 'العب Murder',
        ['btn_ranking'] = 'فتح التصنيف',
        ['queue_left'] = 'لقد غادرت قائمة انتظار Murder',
        ['queue_timeout'] = 'انتهت قائمة انتظار Murder بسبب تجاوز الوقت',
        ['match_started'] = 'بدأت المباراة!',
        ['match_ended'] = 'انتهت المباراة',
        ['match_left'] = 'لقد غادرت مباراة Murder',
        ['round_started'] = 'بدأت الجولة',
        ['round_ended'] = 'انتهت الجولة',
        ['role_assassin'] = 'أنت القاتل! قم بإزالة جميع الناجين',
        ['role_detective'] = 'أنت المحقق! اعثر على القاتل وأوقفه',
        ['role_innocent'] = 'أنت بريء! انج وأعثر على القاتل',
        ['you_died'] = 'لقد مت',
        ['player_eliminated'] = 'تم إقصاء اللاعب',
        ['assassin_win'] = 'فاز القاتلون!',
        ['innocents_win'] = 'فاز الأبرياء!',
        ['detective_win'] = 'فاز المحقق!',
        ['weapon_pickup'] = 'تم التقاط السلاح',
        ['weapon_dropped'] = 'تم إسقاط السلاح',
        ['waiting_players'] = 'في انتظار اللاعبين...',
        ['match_starting'] = 'تبدأ المباراة خلال %s ثانية',
        ['players_remaining'] = '%s لاعبين متبقيين',
        ['new_assassin_action'] = 'دخل قاتل جديد إلى العمل.',
        ['promoted_to_assassin'] = 'تمت ترقيتك إلى قاتل.',
        ['detective_weapon_dropped'] = 'تم إسقاط سلاح المحقق.',
        ['new_detective_assigned'] = 'تم تعيين محقق جديد للقضية.',
        ['promoted_to_detective'] = 'تمت ترقيتك إلى محقق.',
        ['detective_weapon_pickup'] = 'لقد التقطت سلاح المحقق!',
        ['time_hours'] = ' ساعات',
        ['time_min'] = ' دقيقة',
        ['time_seconds'] = ' ثانية',
        ['player_fallback'] = 'لاعب ',
    },
}

-- Cria a classe de traduções (registra automaticamente e retorna métodos helper)
---@class MurderTranslations
MurderTranslations = TranslationManager.createTranslationClass('murder', translations)
