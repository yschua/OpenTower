local PathNode = require 'objects.PathNode'
local Coord = require 'objects.Coord'

local Mover = class('Mover')

Mover.static.nextId = 1

function Mover:initialize(blockX, level)
  -- TODO get x, y direct from parameters
  self.x = blockX
  -- y is the top block of the mover
  self.y = level + c.GROUND_BLOCK_HEIGHT + 1
  self.connectedLevelsY = {}

  self.blockX = blockX
  self.bottomLevel = level
  self.topLevel = level + 1

  self.id = Mover.static.nextId
  Mover.static.nextId = Mover.static.nextId + 1

  self.node = PathNode:Mover(self.id)
end

function Mover:getLevel()
  return self.y - c.GROUND_BLOCK_HEIGHT - 1
end

function Mover:getConnectingCoords()
  local coords = {}
  for _, y in ipairs(self.connectedLevelsY) do
    table.insert(coords, Coord(self.x, y))
  end
  return coords
end

return Mover
