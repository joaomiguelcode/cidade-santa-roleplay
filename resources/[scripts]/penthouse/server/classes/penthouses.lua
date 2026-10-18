PenthouseManager = class()

function PenthouseManager:__init(propertyId, data)
    self.propertyId = propertyId
    self.data = data or {}
    self.visitors = {}
    self.bucket = 8000 + math.random(1, 999)
end
