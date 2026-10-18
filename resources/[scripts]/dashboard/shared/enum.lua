---@class enum
---@field ticket_status number
enum = {}

---@enum ticket_status
enum.ticket_status = {
    ["open"] = 0,
    ["answered"] = 1,
    ["finished"] = 2,
    ["cancelled"] = 3,
}


enum.chat_custom = {
    ["admin_ticket"] = {
        background = "rgba(159, 108, 0,.70)",
    }
}