MinigameSpawnpoint = class()

function MinigameSpawnpoint:__init(coords, heading)
    self.coords = coords
    self.heading = heading or 0.0
end
