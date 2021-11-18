local BinaryHeap = require 'libraries.Binary-Heaps.binary_heap'

local Pathfinder = class('Pathfinder')

-- rooms is a 2d array consisting of tower rooms containing its travel cost and moverIds fields
--   * cost = 0 : non-walkable room
-- movers is a adjacency list mapping a moverId to room coordinates
-- * rooms and movers also have their associating path node object
function Pathfinder:initialize(rooms, movers)
  self._rooms = rooms
  self._movers = movers
  self._heuristic = function() return 0 end -- TODO
  self._nodesToClear = {}
end

function Pathfinder:getRoom(coord)
  if coord.x < 1 or coord.y < 1 then
    return nil
  end
  return self._rooms[coord.y][coord.x]
end

function Pathfinder:computeCost(fromNode, toNode)
  if fromNode:isMover() == toNode:isMover() then
    assert(not fromNode:isMover())
  end

  -- both nodes are rooms
  if not fromNode:isMover() and not toNode:isMover() then
    local fromRoom = self:getRoom(fromNode.roomCoord)
    local toRoom = self:getRoom(toNode.roomCoord)
    assert(fromRoom.cost == toRoom.cost)
    return fromRoom.cost
  end

  -- one of the nodes is a mover
  local moverNode = fromNode:isMover() and fromNode or toNode
  local mover = self._movers[moverNode.moverId]
  return mover.cost
end

local function isWalkable(room)
  return room.cost ~= 0
end

function Pathfinder:getNeighbors(node)
  local neighbors = {}
  if node:isMover() then
    -- handle mover node
    local mover = self._movers[node.moverId]
    -- add all connecting rooms
    for _, coord in ipairs(mover:getConnectingCoords()) do
      table.insert(neighbors, self:getRoom(coord).node)
    end
  else
    -- handle room node
    local room = self:getRoom(node.roomCoord)
    -- add any movers
    for _, id in ipairs(room.moverIds) do
      table.insert(neighbors, self._movers[id].node)
    end
    -- add adjacent rooms
    for _, coord in ipairs{node.roomCoord:left(), node.roomCoord:right()} do
      local adjacentRoom = self:getRoom(coord)
      if adjacentRoom and isWalkable(adjacentRoom) then
        table.insert(neighbors, self:getRoom(coord).node)
      end
    end
  end
  return neighbors
end

local function insert(openSet, node)
  node.isInOpenSet = true
  openSet:insert(node)
end

local function pop(openSet)
  local node = openSet:pop()
  node.isInOpenSet = false
  return node
end

function Pathfinder:getPath(startCoord, endCoord)
  -- clear 'dirty' nodes from last search
  for _, node in ipairs(self._nodesToClear) do
    node:clear()
  end

  local startNode = self:getRoom(startCoord).node
  local endNode = self:getRoom(endCoord).node
  local openSet = BinaryHeap()
  startNode.g = 0
  startNode.f = startNode.g + self._heuristic(startNode, endNode)
  insert(openSet, startNode)
  self._nodesToClear = {startNode}

  while not openSet:empty() do
    local currentNode = pop(openSet)

    if currentNode == endNode then
      -- path found, reconstruct the path and return
      local path = {}
      repeat
        table.insert(path, 1, currentNode)
        currentNode = currentNode.cameFrom
      until currentNode == nil
      return path
    end

    for _, neighborNode in ipairs(self:getNeighbors(currentNode)) do
      local tentativeG = currentNode.g + self:computeCost(currentNode, neighborNode)

      if tentativeG < neighborNode.g then
        table.insert(self._nodesToClear, neighborNode)
        neighborNode.cameFrom = currentNode
        neighborNode.g = tentativeG
        neighborNode.f = neighborNode.g + self._heuristic(neighborNode, endNode)
        if not neighborNode.isInOpenSet then
          insert(openSet, neighborNode)
        end
      end
    end
  end

  return nil
end

return Pathfinder
