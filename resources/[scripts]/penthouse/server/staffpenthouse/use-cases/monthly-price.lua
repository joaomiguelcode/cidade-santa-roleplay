StaffPenthouseMonthlyPriceUseCase = {}

function StaffPenthouseMonthlyPriceUseCase.Update(propertyId, price)
    exports.oxmysql:executeSync('UPDATE penthouses SET monthly_price = ? WHERE property_id = ?', { price, propertyId })
    return { success = true }
end
