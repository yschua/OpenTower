local Coord = require 'objects.Coord'

local PathNode = class('PathNode')

function PathNode:initialize(roomCoord, moverId)
  assert(utils.xor(roomCoord, moverId))
  self.roomCoord = roomCoord
  self.moverId = moverId
  self:clear()
end

function PathNode.static:Room(x, y)
  local coord = (type(x) == 'table' and x.class == Coord) and x or Coord(x, y)
  return self(coord, nil)
end

function PathNode.static:Mover(id)
  return self(nil, id)
end

-- comparator for A* min heap
function PathNode.__lt(a, b)
  return a.f < b.f
end

-- cached temporaries for A*
function PathNode:clear()
  self.g = math.huge
  self.f = math.huge
  self.cameFrom = nil
  self.isInOpenSet = false
end

function PathNode:isMover()
  return self.moverId ~= nil
end

return PathNode
