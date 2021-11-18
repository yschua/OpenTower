local PathNode = require 'objects.PathNode'
local Coord = require 'objects.Coord'

local Mover = class('Mover')

Mover.static.nextId = 1

function Mover:initialize(x, y)
  self.x = x
  -- y is the top block of the mover
  self.y = y
  self.connectedY = {}
  self.id = Mover.static.nextId
  Mover.static.nextId = Mover.static.nextId + 1
  self.node = PathNode:Mover(self.id)
end

function Mover:getLevel()
  return self.y - c.GROUND_BLOCK_HEIGHT - 1
end

function Mover:getConnectingCoords()
  local coords = {}
  for _, y in ipairs(self.connectedY) do
    table.insert(coords, Coord(self.x, y))
  end
  return coords
end

return Mover
