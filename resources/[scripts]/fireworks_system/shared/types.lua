---@alias firework.rarity "common" | "rare" | "special"

---@alias firework.lootItemType "item" | "colecionavel" | "vip"

---@class firework.lootItemConfig
---@field item string
---@field type firework.lootItemType
---@field chance number
---@field quantity number | { min: number, max: number } | function(): number

---@class firework.lootItem: firework.lootItemConfig
---@field quantity number

---@class firework.benefitCommand
---@field command string
---@field args string[]


---@class firework.benefitPermissionItem
---@field permission string
---@field level number
---@field mode string?
---@field recruiter number?
---@field days number?
---@field ignoreVIP boolean?

---@class firework.benefit
---@field commands table<string, firework.benefitCommand>
---@field permissions table<string, {}>
