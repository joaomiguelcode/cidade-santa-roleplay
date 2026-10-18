-- enterprise core class
Enterprise = class()

function Enterprise:__init(id, data)
    self.id = id
    self.data = data or {}
    self.members = {}
    self.balance = data.balance or 0
end
