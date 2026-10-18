-- ENG-3934: mesma regra para a rotina e a consulta Em risco.
TicketCleanupRules = {}

---@param permission string
---@return boolean
function TicketCleanupRules.IsTicketGroup( permission )

    local name = tostring( permission or '' ):lower():match( '^%s*(.-)%s*$' )

    return name == 'chamados' or name:match( '^ch_' ) ~= nil
end

---@param completed number
---@param rated number
---@param promoters number
---@param detractors number
---@param config table
---@return string? reason
---@return number? nps
function TicketCleanupRules.Evaluate( completed, rated, promoters, detractors, config )

    assert( completed >= 0 and rated >= 0 and rated <= completed, 'Invalid ticket counts' )
    assert( promoters >= 0 and detractors >= 0 and promoters + detractors <= rated,
        'Invalid ticket ratings' )

    local nps = rated > 0 and ( promoters - detractors ) * 100 / rated or nil

    if completed < config.minimumTickets then
        return 'ticketsLowActivity', nps
    end

    if rated >= config.minimumRated and nps < config.minimumNps then
        return 'ticketsLowQuality', nps
    end

    return nil, nps
end
