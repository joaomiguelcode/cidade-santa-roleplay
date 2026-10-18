---@class WorldClock
---@field syncedHours   number
---@field syncedMinutes number
---@field syncedAt      number

---@class WorldDate
---@field day   number
---@field month number

---@alias WorldWeatherIndex number

EVENTNAME_WORLDSTATESYNC = 'worldstate'

---@enum eWorldStateSyncFlags
---@diagnostic disable-next-line: lowercase-global
eWorldStateSyncFlags =
{
    NONE        = 0,
    CLOCK       = 1 << 0,
    WEATHER     = 1 << 1,
    ALL         =   1 << 0 |
                    1 << 1,
}