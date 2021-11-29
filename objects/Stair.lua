local Mover = require 'objects.Mover'

local Stair = class('Stair', Mover)

function Stair:initialize(x, y)
  Mover.initialize(self, x, y)
  self.cost = 5
  self.connectedY[self.y] = true
  self.connectedY[self.y + 1] = true
end

return Stair
