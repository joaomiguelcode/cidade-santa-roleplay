---@class eLogLevel 'all'|'trace'|'debug'|'info'|'warn'|'error'|'fatal|'off'

local eLogLevel =
{
    all = 1,
    trace = 2,
    debug = 3,
    info = 4,
    warn = 5,
    error = 6,
    fatal = 7,
    off = 8,
}

local loggerMT = { }

function loggerMT.new(metadata)
    local self =
    {
        transports = { }
    }

    for key, value in pairs(metadata or { }) do
        self[key] = value
    end

    return setmetatable(self, { __index = loggerMT })
end

function loggerMT:_extractLogContext(info, args)
    local context = { }
    local isContextEmpty = true

    for argIndex, data in pairs(args) do
        if type(data) == 'table' then
            --[[ Remover o argumento sem mudar o tamanho da array ]]
            args[argIndex] = nil

            --[[ Mover uma nova entry de context para o nosso objeto de context ]]
            for key, value in pairs(data) do
                context[key] = value

                --[[ Avisa que o context possui informações, e que deve ser incluida no packet do log ]]
                isContextEmpty = false
            end
        end
    end

    if not isContextEmpty then
        info.context = context
    end

    return context
end

function loggerMT:_extractLogMessage(info, args)
    local message = nil -- table.concat(args, '    ')

    --[[ Concatenar manualmente porque o table.concat nao ignora entries nulas na array ]]
    for _, value in each(args) do
        value = tostring(value) or ''

        message = message and ( message .. ( '    ' .. value ) ) or value
    end

    info.message = message or ''

    return message
end

---@param level eLogLevel
---@vararg any|any[] - VarArg, vai fazer parte da mensagem de log
function loggerMT:log(level, ...)
    assert(eLogLevel[level], ('Level de log "%s" é invalido'):format(level))

    level = level or 'info'

    local dbginfo = debug.getinfo(3, 'Sl')

    assert(dbginfo)

    local path = string.match(dbginfo.short_src, '/(.+).lua' )

    local args = { ... }

    local info =
    {
        level = level,
        --[[ ISO8601 ]]
        timestamp = os and os.date('!%Y-%m-%dT%H:%M:%SZ') or GetGameTimer(),
    }

    for key, value in pairs(self) do
        info[key] = value
    end

    --[[ Remover os transports ]]
    info.transports = nil

    self:_extractLogContext(info, args)

    local message = self:_extractLogMessage(info, args)

    for _, transport in ipairs(self.transports) do
        if transport.log then
            transport.log(info)
        end
    end

    print( ('^2%s ^5(@%s/%s) ^7: %s'):format(level:upper(), GetCurrentResourceName(), path, message) )
end

function loggerMT:trace(...)
    self:log('trace', ...)
end

function loggerMT:debug(...)
    self:log('debug', ...)
end

function loggerMT:info(...)
    self:log('info', ...)
end

function loggerMT:warn(...)
    self:log('warn', ...)
end

function loggerMT:error(...)
    self:log('error', '^1', ... , '^7')
end

function loggerMT:fatal(...)
    self:log('fatal', ...)
end

function loggerMT:expect(expectation, ...)
    if not expectation then
        self:error('Expectation (%s) failed', expectation, ...)
    end
end

function loggerMT:child(metadataOverride)
    local child = loggerMT.new(self)

    for key, value in pairs(metadataOverride or { }) do
        child[key] = value
    end

    return child
end

function loggerMT:add(transport)
    table.insert(self.transports, transport)
end

sx.logger = loggerMT.new()

-- TODO: Diminuir o máximo a necessidade de usar "self" no logger
--- mainLogger:log('info', 'Hello, world!') -> mainLogger.log('info', 'Hello, world!')