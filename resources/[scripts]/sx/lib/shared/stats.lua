sx.stats = { }

---@enum sx.stats.eStatChangeKind
eStatChangeKind =
{
    Increment = 0,
}

---@type sx.stats.StatChange[]
local gLocalStatChangesQueue = { }

---@class sx.stats.StatChange
---@field kind          sx.stats.eStatChangeKind
---@field uucid         sx.services.AchievementService.UUCID
---@field statName      string
---@field value         number
---@field defaultValue? number -- Usado temporáriamente para inserir valores passados que não existe no nosso banco de dados

---@param statChange sx.stats.StatChange
function sx.stats.append( statChange )

    if statChange.kind == eStatChangeKind.Increment then

        -- TODO: PERF: Enviar esses statChanges como batch para o sx/code?

        TriggerEvent( 'sx.stats.append', { statChange } )
    end
end

---@param now? boolean [false]
function sx.stats.flush( now )

    TriggerEvent( 'sx.stats.flush', now )
end