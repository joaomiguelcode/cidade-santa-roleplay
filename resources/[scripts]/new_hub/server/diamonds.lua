Diamonds = {}

function GetDiamonds(passport)
    local rows = exports.oxmysql:executeSync('SELECT diamonds FROM characters WHERE id = ?', { passport })
    return rows and rows[1] and rows[1].diamonds or 0
end

function AddDiamonds(passport, amount)
    exports.oxmysql:executeSync('UPDATE characters SET diamonds = diamonds + ? WHERE id = ?', { amount, passport })
end
