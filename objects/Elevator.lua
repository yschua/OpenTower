local Mover = require 'objects.Mover'

local Elevator = class('Elevator', Mover)

function Elevator:initialize(x, y)
  Mover.initialize(self, x, y)
  self.cost = 20
  self.connectedY = {self.y}
  self.topY = self.y
  self.bottomY = self.y
end

function Elevator:connect(y)
  if y > self.topY or y < self.bottomY then
    error("elevator connect out of range")
  end
  table.insert(self.connectedY, y)
  return self
end

return Elevator
