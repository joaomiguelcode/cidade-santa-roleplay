RegisterCommand('banir', function(source, args)
    local passport = vRP.Passport(source)
    if passport and (vRP.HasGroup(passport, 'Admin') or source == 0) then
        local target = tonumber(args[1])
        local reason = table.concat(args, ' ', 2)
        if target then
            local expires = os.time() + (86400 * 30)
            exports.oxmysql:executeSync('INSERT INTO dashboard_bans (passport, staff_passport, reason, expires_at) VALUES (?, ?, ?, ?)', { target, passport, reason, expires })
            local tSrc = vRP.Source(target)
            if tSrc then DropPlayer(tSrc, 'Você foi banido: ' .. reason) end
        end
    end
end)
