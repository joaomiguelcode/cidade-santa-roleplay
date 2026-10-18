lang = GetConvar("language", "pt-br") or "pt-br"

local FALLBACK_LANG = "pt-br"

translations = {
    ["pt-br"] = {
        ["audience.all_players"] = "Todos jogadores",
        ["error.invalid_world"] = "Escolha um mundo válido para este anúncio.",
        ["world.affiliated"] = "Afiliado",
        ["world.default"] = "Padrão",
        ["world.primary"] = "Mundo primário",
        ["world.secondary"] = "Mundo secundário",
        ["world.tertiary"] = "Mundo terciário",
        ["world.event"] = "Evento",
        ["world.royale"] = "Royale",
        ["world.war"] = "Guerra",

        ["error.invalid_payload"] = "Dados do agendamento inválidos.",
        ["error.permission"] = "Você não tem permissão para agendar áudios.",
        ["error.invalid_type"] = "Tipo de anúncio inválido.",
        ["error.invalid_audience"] = "Escolha quem vai ouvir este anúncio.",
        ["error.invalid_url"] = "Cole um link válido do cdn.santagroup.gg.",
        ["error.invalid_duration"] = "A duração deve ficar entre %d e %d segundos.",
        ["error.invalid_frequency"] = "Escolha se o áudio toca uma vez ou todos os dias.",
        ["error.invalid_date"] = "Data inválida.",
        ["error.invalid_time"] = "Horário inválido.",
        ["error.past_slot"] = "Esse horário já passou. Escolha outro.",
        ["error.slot_taken"] = "Esse horário acabou de ser reservado. Escolha outro.",
        ["error.save_failed"] = "Não foi possível salvar o agendamento. Tente novamente.",
        ["error.too_fast"] = "Aguarde um instante antes de tentar de novo.",
        ["error.audio_playing"] = "Já existe um áudio tocando ou reservado para esse público. Tente de novo em %d segundos.",

        ["remove.not_found"] = "Agendamento #%d não encontrado.",
        ["remove.invalid_id"] = "Agendamento inválido.",
        ["remove.failed"] = "Não foi possível cancelar o agendamento #%d.",

        ["when.once"] = "%s às %s",
        ["when.daily"] = "Todos os dias às %s",
        ["when.instant"] = "Agora",

        ["type.rules"] = "Regras da cidade",
        ["type.culture"] = "Cultura",
        ["type.operation"] = "Operação",
        ["type.actions"] = "Ações",
        ["type.free_factions"] = "Facções livres",
        ["type.sales"] = "Comercial",
        ["type.vip_launch"] = "Lançamento VIP",
        ["type.event"] = "Evento",

        ["audience.new_players"] = "Jogadores novos",
        ["audience.veterans"] = "Jogadores veteranos",
        ["audience.primary"] = "Mundo primário",
        ["audience.secondary"] = "Mundo secundário",
        ["audience.tertiary"] = "Mundo terciário",
        ["audience.event"] = "Evento",
        ["audience.royale"] = "Royale",
        ["audience.war"] = "Guerra",

        ["webhook.created"] = "Áudio agendado",
        ["webhook.removed"] = "Agendamento cancelado",
        ["webhook.played_now"] = "Áudio instantâneo tocado",
    },
    ["pt-pt"] = {
        ["audience.all_players"] = "Todos os jogadores",
        ["error.invalid_world"] = "Escolhe um mundo válido para este anúncio.",
        ["world.affiliated"] = "Afiliado",
        ["world.default"] = "Padrão",
        ["world.primary"] = "Mundo primário",
        ["world.secondary"] = "Mundo secundário",
        ["world.tertiary"] = "Mundo terciário",
        ["world.event"] = "Evento",
        ["world.royale"] = "Royale",
        ["world.war"] = "Guerra",

        ["error.invalid_payload"] = "Dados do agendamento inválidos.",
        ["error.permission"] = "Não tens permissão para agendar áudios.",
        ["error.invalid_type"] = "Tipo de anúncio inválido.",
        ["error.invalid_audience"] = "Escolhe quem vai ouvir este anúncio.",
        ["error.invalid_url"] = "Cola uma ligação válida do cdn.santagroup.gg.",
        ["error.invalid_duration"] = "A duração deve ficar entre %d e %d segundos.",
        ["error.invalid_frequency"] = "Escolhe se o áudio toca uma vez ou todos os dias.",
        ["error.invalid_date"] = "Data inválida.",
        ["error.invalid_time"] = "Horário inválido.",
        ["error.past_slot"] = "Esse horário já passou. Escolhe outro.",
        ["error.slot_taken"] = "Esse horário acabou de ser reservado. Escolhe outro.",
        ["error.save_failed"] = "Não foi possível guardar o agendamento. Tenta novamente.",
        ["error.too_fast"] = "Aguarda um instante antes de tentar de novo.",
        ["error.audio_playing"] = "Já existe um áudio a tocar ou reservado para este público. Tenta de novo daqui a %d segundos.",

        ["remove.not_found"] = "Agendamento #%d não encontrado.",
        ["remove.invalid_id"] = "Agendamento inválido.",
        ["remove.failed"] = "Não foi possível cancelar o agendamento #%d.",

        ["when.once"] = "%s às %s",
        ["when.daily"] = "Todos os dias às %s",
        ["when.instant"] = "Agora",

        ["type.rules"] = "Regras da cidade",
        ["type.culture"] = "Cultura",
        ["type.operation"] = "Operação",
        ["type.actions"] = "Ações",
        ["type.free_factions"] = "Fações livres",
        ["type.sales"] = "Comercial",
        ["type.vip_launch"] = "Lançamento VIP",
        ["type.event"] = "Evento",

        ["audience.new_players"] = "Jogadores novos",
        ["audience.veterans"] = "Jogadores veteranos",
        ["audience.primary"] = "Mundo primário",
        ["audience.secondary"] = "Mundo secundário",
        ["audience.tertiary"] = "Mundo terciário",
        ["audience.event"] = "Evento",
        ["audience.royale"] = "Royale",
        ["audience.war"] = "Guerra",

        ["webhook.created"] = "Áudio agendado",
        ["webhook.removed"] = "Agendamento cancelado",
        ["webhook.played_now"] = "Áudio instantâneo tocado",
    },
    ["en-us"] = {
        ["audience.all_players"] = "All players",
        ["error.invalid_world"] = "Choose a valid world for this announcement.",
        ["world.affiliated"] = "Affiliate",
        ["world.default"] = "Default",
        ["world.primary"] = "Primary world",
        ["world.secondary"] = "Secondary world",
        ["world.tertiary"] = "Tertiary world",
        ["world.event"] = "Event",
        ["world.royale"] = "Royale",
        ["world.war"] = "War",

        ["error.invalid_payload"] = "Invalid schedule data.",
        ["error.permission"] = "You are not allowed to schedule audios.",
        ["error.invalid_type"] = "Invalid announcement type.",
        ["error.invalid_audience"] = "Choose who will hear this announcement.",
        ["error.invalid_url"] = "Paste a valid cdn.santagroup.gg link.",
        ["error.invalid_duration"] = "Duration must be between %d and %d seconds.",
        ["error.invalid_frequency"] = "Choose whether the audio plays once or every day.",
        ["error.invalid_date"] = "Invalid date.",
        ["error.invalid_time"] = "Invalid time.",
        ["error.past_slot"] = "That time has already passed. Pick another one.",
        ["error.slot_taken"] = "That time was just booked. Pick another one.",
        ["error.save_failed"] = "Could not save the schedule. Please try again.",
        ["error.too_fast"] = "Wait a moment before trying again.",
        ["error.audio_playing"] = "An audio is already playing or queued for this audience. Try again in %d seconds.",

        ["remove.not_found"] = "Schedule #%d not found.",
        ["remove.invalid_id"] = "Invalid schedule.",
        ["remove.failed"] = "Could not cancel schedule #%d.",

        ["when.once"] = "%s at %s",
        ["when.daily"] = "Every day at %s",
        ["when.instant"] = "Now",

        ["type.rules"] = "City rules",
        ["type.culture"] = "Culture",
        ["type.operation"] = "Operation",
        ["type.actions"] = "Actions",
        ["type.free_factions"] = "Free factions",
        ["type.sales"] = "Commercial",
        ["type.vip_launch"] = "VIP launch",
        ["type.event"] = "Event",

        ["audience.new_players"] = "New players",
        ["audience.veterans"] = "Veteran players",
        ["audience.primary"] = "Primary world",
        ["audience.secondary"] = "Secondary world",
        ["audience.tertiary"] = "Tertiary world",
        ["audience.event"] = "Event",
        ["audience.royale"] = "Royale",
        ["audience.war"] = "War",

        ["webhook.created"] = "Audio scheduled",
        ["webhook.removed"] = "Schedule cancelled",
        ["webhook.played_now"] = "Instant audio played",
    },
    ["es-es"] = {
        ["audience.all_players"] = "Todos los jugadores",
        ["error.invalid_world"] = "Elige un mundo válido para este anuncio.",
        ["world.affiliated"] = "Afiliado",
        ["world.default"] = "Predeterminado",
        ["world.primary"] = "Mundo primario",
        ["world.secondary"] = "Mundo secundario",
        ["world.tertiary"] = "Mundo terciario",
        ["world.event"] = "Evento",
        ["world.royale"] = "Royale",
        ["world.war"] = "Guerra",

        ["error.invalid_payload"] = "Datos de la programación inválidos.",
        ["error.permission"] = "No tienes permiso para programar audios.",
        ["error.invalid_type"] = "Tipo de anuncio inválido.",
        ["error.invalid_audience"] = "Elige quién escuchará este anuncio.",
        ["error.invalid_url"] = "Pega un enlace válido de cdn.santagroup.gg.",
        ["error.invalid_duration"] = "La duración debe estar entre %d y %d segundos.",
        ["error.invalid_frequency"] = "Elige si el audio suena una vez o todos los días.",
        ["error.invalid_date"] = "Fecha inválida.",
        ["error.invalid_time"] = "Horario inválido.",
        ["error.past_slot"] = "Ese horario ya pasó. Elige otro.",
        ["error.slot_taken"] = "Ese horario acaba de ser reservado. Elige otro.",
        ["error.save_failed"] = "No se pudo guardar la programación. Inténtalo de nuevo.",
        ["error.too_fast"] = "Espera un momento antes de intentarlo de nuevo.",
        ["error.audio_playing"] = "Ya hay un audio sonando o reservado para este público. Inténtalo de nuevo en %d segundos.",

        ["remove.not_found"] = "Programación #%d no encontrada.",
        ["remove.invalid_id"] = "Programación inválida.",
        ["remove.failed"] = "No se pudo cancelar la programación #%d.",

        ["when.once"] = "%s a las %s",
        ["when.daily"] = "Todos los días a las %s",
        ["when.instant"] = "Ahora",

        ["type.rules"] = "Reglas de la ciudad",
        ["type.culture"] = "Cultura",
        ["type.operation"] = "Operación",
        ["type.actions"] = "Acciones",
        ["type.free_factions"] = "Facciones libres",
        ["type.sales"] = "Comercial",
        ["type.vip_launch"] = "Lanzamiento VIP",
        ["type.event"] = "Evento",

        ["audience.new_players"] = "Jugadores nuevos",
        ["audience.veterans"] = "Jugadores veteranos",
        ["audience.primary"] = "Mundo primario",
        ["audience.secondary"] = "Mundo secundario",
        ["audience.tertiary"] = "Mundo terciario",
        ["audience.event"] = "Evento",
        ["audience.royale"] = "Royale",
        ["audience.war"] = "Guerra",

        ["webhook.created"] = "Audio programado",
        ["webhook.removed"] = "Programación cancelada",
        ["webhook.played_now"] = "Audio instantáneo reproducido",
    },
    ["fr-fr"] = {
        ["audience.all_players"] = "Tous les joueurs",
        ["error.invalid_world"] = "Choisissez un monde valide pour cette annonce.",
        ["world.affiliated"] = "Affilié",
        ["world.default"] = "Par défaut",
        ["world.primary"] = "Monde primaire",
        ["world.secondary"] = "Monde secondaire",
        ["world.tertiary"] = "Monde tertiaire",
        ["world.event"] = "Événement",
        ["world.royale"] = "Royale",
        ["world.war"] = "Guerre",

        ["error.invalid_payload"] = "Données de programmation invalides.",
        ["error.permission"] = "Vous n'avez pas la permission de programmer des audios.",
        ["error.invalid_type"] = "Type d'annonce invalide.",
        ["error.invalid_audience"] = "Choisissez qui entendra cette annonce.",
        ["error.invalid_url"] = "Collez un lien cdn.santagroup.gg valide.",
        ["error.invalid_duration"] = "La durée doit être comprise entre %d et %d secondes.",
        ["error.invalid_frequency"] = "Choisissez si l'audio est joué une fois ou tous les jours.",
        ["error.invalid_date"] = "Date invalide.",
        ["error.invalid_time"] = "Horaire invalide.",
        ["error.past_slot"] = "Cet horaire est déjà passé. Choisissez-en un autre.",
        ["error.slot_taken"] = "Cet horaire vient d'être réservé. Choisissez-en un autre.",
        ["error.save_failed"] = "Impossible d'enregistrer la programmation. Réessayez.",
        ["error.too_fast"] = "Patientez un instant avant de réessayer.",
        ["error.audio_playing"] = "Un audio est déjà en cours ou réservé pour ce public. Réessayez dans %d secondes.",

        ["remove.not_found"] = "Programmation #%d introuvable.",
        ["remove.invalid_id"] = "Programmation invalide.",
        ["remove.failed"] = "Impossible d'annuler la programmation #%d.",

        ["when.once"] = "%s à %s",
        ["when.daily"] = "Tous les jours à %s",
        ["when.instant"] = "Maintenant",

        ["type.rules"] = "Règles de la ville",
        ["type.culture"] = "Culture",
        ["type.operation"] = "Opération",
        ["type.actions"] = "Actions",
        ["type.free_factions"] = "Factions libres",
        ["type.sales"] = "Publicité",
        ["type.vip_launch"] = "Lancement VIP",
        ["type.event"] = "Événement",

        ["audience.new_players"] = "Nouveaux joueurs",
        ["audience.veterans"] = "Joueurs vétérans",
        ["audience.primary"] = "Monde primaire",
        ["audience.secondary"] = "Monde secondaire",
        ["audience.tertiary"] = "Monde tertiaire",
        ["audience.event"] = "Événement",
        ["audience.royale"] = "Royale",
        ["audience.war"] = "Guerre",

        ["webhook.created"] = "Audio programmé",
        ["webhook.removed"] = "Programmation annulée",
        ["webhook.played_now"] = "Audio instantané joué",
    },
    ["ar-sa"] = {
        ["audience.all_players"] = "جميع اللاعبين",
        ["error.invalid_world"] = "اختر عالماً صالحاً لهذا الإعلان.",
        ["world.affiliated"] = "المنتسب",
        ["world.default"] = "الافتراضي",
        ["world.primary"] = "العالم الأساسي",
        ["world.secondary"] = "العالم الثانوي",
        ["world.tertiary"] = "العالم الثالث",
        ["world.event"] = "فعالية",
        ["world.royale"] = "رويال",
        ["world.war"] = "حرب",

        ["error.invalid_payload"] = "بيانات الجدولة غير صالحة.",
        ["error.permission"] = "ليس لديك صلاحية لجدولة المقاطع الصوتية.",
        ["error.invalid_type"] = "نوع الإعلان غير صالح.",
        ["error.invalid_audience"] = "اختر من سيستمع إلى هذا الإعلان.",
        ["error.invalid_url"] = "الصق رابطًا صالحًا من cdn.santagroup.gg.",
        ["error.invalid_duration"] = "يجب أن تكون المدة بين %d و %d ثانية.",
        ["error.invalid_frequency"] = "اختر ما إذا كان الصوت سيُشغَّل مرة واحدة أو كل يوم.",
        ["error.invalid_date"] = "تاريخ غير صالح.",
        ["error.invalid_time"] = "وقت غير صالح.",
        ["error.past_slot"] = "هذا الوقت قد مضى. اختر وقتًا آخر.",
        ["error.slot_taken"] = "تم حجز هذا الوقت للتو. اختر وقتًا آخر.",
        ["error.save_failed"] = "تعذر حفظ الجدولة. حاول مرة أخرى.",
        ["error.too_fast"] = "انتظر لحظة قبل المحاولة مرة أخرى.",
        ["error.audio_playing"] = "يوجد صوت قيد التشغيل أو محجوز لهذا الجمهور. حاول مرة أخرى بعد %d ثانية.",

        ["remove.not_found"] = "الجدولة #%d غير موجودة.",
        ["remove.invalid_id"] = "جدولة غير صالحة.",
        ["remove.failed"] = "تعذر إلغاء الجدولة #%d.",

        ["when.once"] = "%s الساعة %s",
        ["when.daily"] = "كل يوم الساعة %s",
        ["when.instant"] = "الآن",

        ["type.rules"] = "قواعد المدينة",
        ["type.culture"] = "الثقافة",
        ["type.operation"] = "عملية",
        ["type.actions"] = "إجراءات",
        ["type.free_factions"] = "فصائل حرة",
        ["type.sales"] = "إعلان تجاري",
        ["type.vip_launch"] = "إطلاق VIP",
        ["type.event"] = "فعالية",

        ["audience.new_players"] = "لاعبون جدد",
        ["audience.veterans"] = "لاعبون قدامى",
        ["audience.primary"] = "العالم الأساسي",
        ["audience.secondary"] = "العالم الثانوي",
        ["audience.tertiary"] = "العالم الثالث",
        ["audience.event"] = "فعالية",
        ["audience.royale"] = "رويال",
        ["audience.war"] = "حرب",

        ["webhook.created"] = "تمت جدولة الصوت",
        ["webhook.removed"] = "تم إلغاء الجدولة",
        ["webhook.played_now"] = "تم تشغيل صوت فوري",
    },
}

---@param key string
---@return boolean
function CheckTranslation(key)

    local locale = translations[lang] or translations[FALLBACK_LANG]

    if locale[key] then
        return true
    end

    sx.logger:debug(('[translations] Translation not found for key: %s - Lang: %s'):format(key, lang))

    return false
end

---@param key string
---@return string
function _t(key)

    if CheckTranslation(key) then
        return (translations[lang] or translations[FALLBACK_LANG])[key]
    end

    return ('Translation not found for key: %s - Lang: %s'):format(key, lang)
end
