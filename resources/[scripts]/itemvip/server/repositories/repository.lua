-- itemvip repository
ItemVipRepository = {}

function ItemVipRepository.logRedeem(passport, selections)
    MySQL.query([[
        INSERT INTO log_itemvip (passport, selections, created_at)
        VALUES (@passport, @selections, NOW())
    ]], { passport = passport, selections = json.encode(selections) })
end
