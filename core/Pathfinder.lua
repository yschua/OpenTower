local Queue = require 'objects.Queue'
local BinaryHeap = require 'libraries.Binary-Heaps.binary_heap'

local Pathfinder = class('Pathfinder')

function Pathfinder:initialize(map, movers)
  self._map = map
  self._movers = movers
  self._heuristic = function(startNode, endNode)
    if startNode:isMover() or endNode:isMover() then
      return 0
    end
    -- Manhattan distance
    local dx = math.abs(startNode.coord.x - endNode.coord.x)
    local dy = math.abs(startNode.coord.y - endNode.coord.y)
    return dx + dy
  end
  self._nodesToClear = {}
end

function Pathfinder:getMapBlock(coord)
  if coord.x < 1 or coord.y < 1 then
    return nil
  end
  return self._map[coord.y][coord.x]
end

function Pathfinder:computeCost(fromNode, toNode)
  if fromNode:isMover() == toNode:isMover() then
    assert(not fromNode:isMover())
  end

  -- both nodes are not movers
  if not fromNode:isMover() and not toNode:isMover() then
    local fromBlock = self:getMapBlock(fromNode.coord)
    local toBlock = self:getMapBlock(toNode.coord)
    assert(fromBlock.cost == toBlock.cost)
    return fromBlock.cost
  end

  -- one of the nodes is a mover
  local moverNode = fromNode:isMover() and fromNode or toNode
  local mover = self._movers[moverNode.moverId]
  return mover.cost
end

local function isWalkable(mapBlock)
  return mapBlock.cost ~= 0
end

function Pathfinder:getNeighbors(node)
  local neighbors = {}
  if node:isMover() then
    -- handle mover node
    local mover = self._movers[node.moverId]
    -- add all connecting mapBlocks
    for _, coord in ipairs(mover:getConnectingCoords()) do
      table.insert(neighbors, self:getMapBlock(coord).node)
    end
  else
    -- handle mapBlock node
    local mapBlock = self:getMapBlock(node.coord)
    -- add any movers
    if mapBlock.moverId ~= 0 then
      table.insert(neighbors, self._movers[mapBlock.moverId].node)
    end
    -- add adjacent blocks
    for _, coord in ipairs{node.coord:left(), node.coord:right()} do
      local adjacentBlock = self:getMapBlock(coord)
      if adjacentBlock and isWalkable(adjacentBlock) then
        table.insert(neighbors, self:getMapBlock(coord).node)
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

  local startNode = self:getMapBlock(startCoord).node
  local endNode = self:getMapBlock(endCoord).node
  local openSet = BinaryHeap()
  startNode.g = 0
  startNode.f = startNode.g + self._heuristic(startNode, endNode)
  insert(openSet, startNode)
  self._nodesToClear = {startNode}

  while not openSet:empty() do
    local currentNode = pop(openSet)

    if currentNode == endNode then
      -- path found, reconstruct the path and return
      local path = Queue()
      repeat
        local isNotIntermediaryNode = currentNode == startNode or currentNode == endNode or
          currentNode:isMover() or path:peekleft():isMover() or currentNode.cameFrom:isMover()
        if isNotIntermediaryNode then
          path:pushleft(currentNode)
        end
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
