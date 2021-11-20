local PathNode = require 'objects.PathNode'

local MapBlock = class('MapBlock')

function MapBlock:initialize(x, y)
  self.roomId = 0
  self.moverId = 0
  self.cost = 0
  self.node = PathNode:MapBlock(x, y)
end

return MapBlock
