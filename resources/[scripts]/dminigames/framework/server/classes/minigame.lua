Minigame = class()

function Minigame:__init(name, config)
    self.name = name
    self.config = config or {}
    self.matches = {}
end
