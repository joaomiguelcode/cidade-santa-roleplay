MinigameQueue = class()

function MinigameQueue:__init(mode)
    self.mode = mode
    self.players = {}
end

function MinigameQueue:add(passport)
    table.insert(self.players, passport)
end

function MinigameQueue:remove(passport)
    for i, p in ipairs(self.players) do
        if p == passport then
            table.remove(self.players, i)
            break
        end
    end
end
