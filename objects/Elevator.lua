local Mover = require 'objects.Mover'

local Elevator = class('Elevator', Mover)

function Elevator:initialize(blockX, level)
  Mover.initialize(self, blockX, level)
  self.cost = 10
  self.connectedLevelsY = {self.y}
end

function Elevator:connect(y)
  table.insert(self.connectedLevelsY, y)
  return self
end

-- TODO some functions for modifying connectedLevelsY

return Elevator
