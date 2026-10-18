-- GRW-188: classificacao explicita; texto livre nunca define categoria.
StaffTicketRules = {}

function StaffTicketRules.IsStaffType(ticketType)
    return ticketType == 'admin' or ticketType == 'developers' or ticketType == 'rdm'
end

function StaffTicketRules.IsChannel(channel)
    return channel == 'ticket' or channel == 'f5'
end

function StaffTicketRules.SurveyMetadata(ticketType, ticketId, ticketInfo)
    local helper = tonumber(ticketInfo.helper)
    local id = tonumber(ticketId)
    if not StaffTicketRules.IsStaffType(ticketType) or ticketInfo.type ~= ticketType
        or not helper or helper <= 0 or not id or id <= 0 then
        return nil
    end

    return { staff_id = helper, ticket_id = id }
end

function StaffTicketRules.CanRateLegacy(ticketInfo, passport, rating, description)
    return ticketInfo ~= nil and not StaffTicketRules.IsStaffType(ticketInfo.type)
        and tonumber(ticketInfo.player) == tonumber(passport)
        and tonumber(ticketInfo.status) == 2
        and type(rating) == 'number' and rating >= 0 and rating <= 10 and rating % 1 == 0
        and (description == nil or (type(description) == 'string' and #description <= 250))
end
