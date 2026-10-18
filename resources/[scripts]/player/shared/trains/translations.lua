local trainTranslations = {
    ['pt-br'] = {
        ['trains_station_label'] = 'Trem para Los Santos',
        ['trains_dui_boarding'] = 'Embarque finalizando em',
        ['trains_dui_departing'] = 'PARTINDO',
        ['trains_called'] = 'Trem chamado! Aguarde na plataforma.',
        ['trains_boarded'] = 'Você embarcou. Boa viagem!',
        ['trains_arrived_city'] = 'Você chegou em Los Santos.',
        ['trains_far'] = 'Chegue mais perto da estação.',
        ['trains_cooldown'] = 'Aguarde um pouco antes de chamar outro trem.',
        ['trains_full'] = 'O trem está cheio.',
        ['trains_disabled'] = 'O trem não está operando agora.',
        ['trains_error'] = 'Não foi possível pegar o trem agora.'
    },
    ['en-us'] = {
        ['trains_station_label'] = 'Train to Los Santos',
        ['trains_dui_boarding'] = 'Boarding closes in',
        ['trains_dui_departing'] = 'DEPARTING',
        ['trains_called'] = 'Train called! Wait on the platform.',
        ['trains_boarded'] = 'You boarded. Enjoy the ride!',
        ['trains_arrived_city'] = 'You arrived in Los Santos.',
        ['trains_far'] = 'Get closer to the station.',
        ['trains_cooldown'] = 'Wait a moment before calling another train.',
        ['trains_full'] = 'The train is full.',
        ['trains_disabled'] = 'The train is not operating right now.',
        ['trains_error'] = 'Could not take the train right now.'
    },
    ['fr-fr'] = {
        ['trains_station_label'] = 'Train pour Los Santos',
        ['trains_dui_boarding'] = 'Embarquement termine dans',
        ['trains_dui_departing'] = 'DEPART',
        ['trains_called'] = 'Train appelé ! Attendez sur le quai.',
        ['trains_boarded'] = 'Vous êtes monté. Bon voyage !',
        ['trains_arrived_city'] = 'Vous êtes arrivé à Los Santos.',
        ['trains_far'] = 'Rapprochez-vous de la gare.',
        ['trains_cooldown'] = 'Attendez un peu avant d\'appeler un autre train.',
        ['trains_full'] = 'Le train est complet.',
        ['trains_disabled'] = 'Le train ne circule pas pour le moment.',
        ['trains_error'] = 'Impossible de prendre le train maintenant.'
    },
    ['pt-pt'] = {
        ['trains_station_label'] = 'Comboio para Los Santos',
        ['trains_dui_boarding'] = 'Embarque termina em',
        ['trains_dui_departing'] = 'A PARTIR',
        ['trains_called'] = 'Comboio chamado! Aguarde na plataforma.',
        ['trains_boarded'] = 'Entrou no comboio. Boa viagem!',
        ['trains_arrived_city'] = 'Chegou a Los Santos.',
        ['trains_far'] = 'Aproxime-se da estação.',
        ['trains_cooldown'] = 'Aguarde um pouco antes de chamar outro comboio.',
        ['trains_full'] = 'O comboio está cheio.',
        ['trains_disabled'] = 'O comboio não está a operar agora.',
        ['trains_error'] = 'Não foi possível apanhar o comboio agora.'
    },
    ['es-es'] = {
        ['trains_station_label'] = 'Tren a Los Santos',
        ['trains_dui_boarding'] = 'Embarque finaliza en',
        ['trains_dui_departing'] = 'SALIENDO',
        ['trains_called'] = '¡Tren llamado! Espera en el andén.',
        ['trains_boarded'] = 'Has subido. ¡Buen viaje!',
        ['trains_arrived_city'] = 'Has llegado a Los Santos.',
        ['trains_far'] = 'Acércate a la estación.',
        ['trains_cooldown'] = 'Espera un poco antes de llamar a otro tren.',
        ['trains_full'] = 'El tren está lleno.',
        ['trains_disabled'] = 'El tren no está funcionando ahora.',
        ['trains_error'] = 'No se pudo tomar el tren ahora.'
    },
    ['de-de'] = {
        ['trains_station_label'] = 'Zug nach Los Santos',
        ['trains_dui_boarding'] = 'Einstieg endet in',
        ['trains_dui_departing'] = 'ABFAHRT',
        ['trains_called'] = 'Zug gerufen! Warte am Bahnsteig.',
        ['trains_boarded'] = 'Du bist eingestiegen. Gute Fahrt!',
        ['trains_arrived_city'] = 'Du bist in Los Santos angekommen.',
        ['trains_far'] = 'Komm näher zum Bahnhof.',
        ['trains_cooldown'] = 'Warte kurz, bevor du einen weiteren Zug rufst.',
        ['trains_full'] = 'Der Zug ist voll.',
        ['trains_disabled'] = 'Der Zug fährt gerade nicht.',
        ['trains_error'] = 'Du kannst den Zug gerade nicht nehmen.'
    },
    ['ar-sa'] = {
        ['trains_station_label'] = 'قطار إلى لوس سانتوس',
        ['trains_dui_boarding'] = 'ينتهي الصعود خلال',
        ['trains_dui_departing'] = 'يغادر',
        ['trains_called'] = 'تم استدعاء القطار! انتظر على الرصيف.',
        ['trains_boarded'] = 'لقد ركبت القطار. رحلة سعيدة!',
        ['trains_arrived_city'] = 'وصلت إلى لوس سانتوس.',
        ['trains_far'] = 'اقترب من المحطة.',
        ['trains_cooldown'] = 'انتظر قليلاً قبل استدعاء قطار آخر.',
        ['trains_full'] = 'القطار ممتلئ.',
        ['trains_disabled'] = 'القطار لا يعمل الآن.',
        ['trains_error'] = 'لا يمكن ركوب القطار الآن.'
    }
}

for language, keys in pairs(trainTranslations) do
    translations[language] = translations[language] or {}
    for key, text in pairs(keys) do
        translations[language][key] = text
    end
end
