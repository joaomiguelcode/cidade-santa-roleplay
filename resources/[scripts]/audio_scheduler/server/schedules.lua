-- audio_scheduler schedules
lib.callback.register('audio_scheduler:getSchedules', function(source)
    return AudioRepository.listSchedules()
end)

lib.callback.register('audio_scheduler:getAvailability', function(source, frequency, month, audioType, audience, world)
    return { fullDays = {}, busy = {} }
end)

lib.callback.register('audio_scheduler:schedule', function(source, data)
    local passport = vRP.Passport(source)
    if not vRP.hasPermission(passport, 'Admin') then return false, 'Sem permissão' end
    data.passport = passport
    AudioRepository.createSchedule(data)
    return true
end)

lib.callback.register('audio_scheduler:cancel', function(source, id)
    local passport = vRP.Passport(source)
    if not vRP.hasPermission(passport, 'Admin') then return false, 'Sem permissão' end
    AudioRepository.cancelSchedule(id)
    return true
end)
