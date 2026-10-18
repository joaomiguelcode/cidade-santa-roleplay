MinigameMatch = class()

function MinigameMatch:__init(id, mode, bucket)
    self.id = id
    self.mode = mode
    self.bucket = bucket or (9500 + id)
    self.players = {}
    self.state = 'waiting'
end
