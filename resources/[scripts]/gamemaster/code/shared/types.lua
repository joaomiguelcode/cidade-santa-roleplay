---@class gamemaster.SpectatorData
---@field [ 1 ]:  'small' | 'large'          -- menuType
---@field [ 2 ]:  number                     -- currentPlayerId
---@field [ 3 ]:  Source                     -- source
---@field [ 4 ]:  string                     -- name
---@field [ 5 ]:  string                     -- avatar
---@field [ 6 ]:  number                     -- kdRatio
---@field [ 7 ]:  string?                    -- discordId
---@field [ 8 ]:  string                     -- suspectStatus
---@field [ 9 ]:  number                     -- staffCount
---@field [ 10 ]:  string|nil?                -- playerRestrict
---@field [ 11 ]:  boolean                    -- targetsByGroup
---@field [ 12 ]:  string                     -- customId
---@field [ 13 ]:  boolean                    -- staffOnDuty (ENG-3714)

---@class gamemaster.SpectatorStaffInfo
---@field source Source
---@field name string
---@field group string
---@field level number
---@field hierarchy string

---@class gamemaster.SpectatorFinancialData
---@field bankBalance number
---@field cashInHand number
---@field totalAssets number
---@field totalSpent number

---@class gamemaster.SpectatorGroupData
---@field group string
---@field level number

---@class gamemaster.SpectatorInventoryData
---@field items table[]
---@field weight number
---@field maxWeight number

---@class gamemaster.SpectatorLoginHistory
---@field action string
---@field date string

---@class gamemaster.SpectatorBanHistory
---@field action string
---@field date string
---@field responsible table
---@field status string

---@class gamemaster.MenuActionArgs
---@field targetId? number
---@field permission? table<string, number>
---@field level? number
---@field location? string
---@field health? number
---@field reason? string
---@field duration? number
---@field item? table<string, number>

---@enum eChangePlayerInSpectator
eChangePlayerInSpectator = 
{
    nextPlayer = 0,

    previousPlayer = 1,
}