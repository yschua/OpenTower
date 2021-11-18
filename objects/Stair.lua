local Mover = require 'objects.Mover'

local Stair = class('Stair', Mover)

function Stair:initialize(blockX, level)
  Mover.initialize(self, blockX, level)
  self.connectedLevelsY = {self.y, self.y - 1}
  self.cost = 5
end

return Stair
