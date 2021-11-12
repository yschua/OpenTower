local Grid = require 'libraries.Jumper.jumper.grid'
local Pathfinder = require 'libraries.Jumper.jumper.pathfinder'
local PathNode = require 'objects.PathNode'

local pathfinder = {}

local _map
local _movers
local _finder

local ROOM_COST = 1

function pathfinder.load(map, movers)
  _map = map
  _movers = movers

  local walkable = function(value) return value > 0 end
  _finder = Pathfinder(Grid({{0}}), 'ASTAR', walkable)
  _finder:setMode('ORTHOGONAL')
end

local function getMoverCost(id)
  return (id == 0) and 0 or _movers[id].cost;
end

local function roomToPath(y)
  return y * 2 - 1
end

local function moverToPath(y)
  return y * 2
end

function pathfinder.regenerate()
  local pathMap = {}

  for y = 1, #_map do
    local roomY = roomToPath(y)
    local moverY = moverToPath(y)
    pathMap[roomY] = {}
    pathMap[moverY] = {}
    for x = 1, #_map[y] do
      pathMap[roomY][x] = ROOM_COST
      pathMap[moverY][x] = getMoverCost(_map[y][x].moverId)
    end
  end

  local grid = Grid(pathMap)
  _finder:setGrid(grid)
end

-- x, y in block coordinates
function pathfinder.getPath(startX, startY, endX, endY)
  -- start and end can only be rooms
  local path = _finder:getPath(startX, roomToPath(startY), endX, roomToPath(endY))
  local towerPath = {}
  for node, _ in path:nodes() do
    local x, y = node:getPos()
    local isMover = (y % 2 == 0)
    local blockY = math.ceil(y / 2)
    table.insert(towerPath, PathNode(x, blockY, isMover))
  end
  return towerPath
end

return pathfinder
