sx.client.stats = { }
sx.client.stats.v2 = { }

---@param name string
---@param value number
function sx.client.stats.v2.set( name, value )

    TriggerServerEvent( 'net.stats_v2.set', name, value, exports.sx:unix_time_milli() )
end

---@param name string
---@param value number
function sx.client.stats.v2.increment( name, value )

    TriggerServerEvent( 'net.stats_v2.increment', name, value, exports.sx:unix_time_milli() )
end