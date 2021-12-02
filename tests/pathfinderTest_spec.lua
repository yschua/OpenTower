require 'globals'
local Coord = require 'objects.Coord'
local PathNode = require 'objects.PathNode'
local Stair = require 'objects.Stair'
local Elevator = require 'objects.Elevator'
local MapBlock = require 'objects.MapBlock'
local Pathfinder = require 'Pathfinder'

describe("pathfinder module", function()
  setup(function()
    c.GROUND_BLOCK_HEIGHT = 0
  end)

  local function createMap(costMap)
    local map = {}
    for y = 1, #costMap do
      map[y] = {}
      for x = 1, #costMap[y] do
        local mapBlock = MapBlock(x, y)
        mapBlock.cost = costMap[y][x]
        map[y][x] = mapBlock
      end
    end
    return map
  end

  local function createMovers(moverList)
    local movers = {}
    for _, mover in ipairs(moverList) do
      movers[mover.id] = mover
    end
    return movers
  end

  local function addMoversToMap(map, movers)
    for id, mover in pairs(movers) do
      for _, coord in ipairs(mover:getConnectingCoords()) do
        map[coord.y][coord.x].moverId = id
      end
    end
  end

  local function areSamePath(expectedPath, actualPath)
    assert.are.equal(#expectedPath, actualPath:size())
    for i = 1, #expectedPath do
      local a = expectedPath[i]
      local b = actualPath[i + actualPath.first - 1]
      assert.are.equal(a.class, b.class, PathNode)
      if a:isMover() then
        assert.are.equal(a.moverId, b.moverId)
      else
        assert.are.same(a.coord, b.coord)
      end
    end
  end

  it("single stair", function()
    local map = createMap{
      {0, 1, 1, 1, 1, 1, 0},
      {0, 1, 1, 1, 1, 1, 0},
    }
    local stair = Stair(4, 1)
    local movers = createMovers{stair}
    addMoversToMap(map, movers)
    local finder = Pathfinder(map, movers)
    do
      -- same floor
      local path = finder:getPath(Coord(6, 1), Coord(2, 1))
      areSamePath({
        PathNode:MapBlock(6, 1),
        PathNode:MapBlock(5, 1),
        PathNode:MapBlock(4, 1),
        PathNode:MapBlock(3, 1),
        PathNode:MapBlock(2, 1),
      }, path)
    end
    do
      -- floor 1 to 2
      local path = finder:getPath(Coord(2, 1), Coord(6, 2))
      areSamePath({
        PathNode:MapBlock(2, 1),
        PathNode:MapBlock(3, 1),
        PathNode:MapBlock(4, 1),
        stair.node,
        PathNode:MapBlock(4, 2),
        PathNode:MapBlock(5, 2),
        PathNode:MapBlock(6, 2),
      }, path)
    end
  end)

  it("single elevator", function()
    local map = createMap{
      {0, 1, 1, 1, 1, 1, 0},
      {0, 1, 1, 1, 1, 1, 0},
      {0, 1, 1, 1, 1, 1, 0},
    }
    local elevator = Elevator(5, 1)
    elevator.topY = 3
    elevator:connect(2):connect(3)
    local movers = createMovers{elevator}
    addMoversToMap(map, movers)
    local finder = Pathfinder(map, movers)
    do
      -- floor 1 to 3
      local path = finder:getPath(Coord(2, 1), Coord(2, 3))
      areSamePath({
        PathNode:MapBlock(2, 1),
        PathNode:MapBlock(3, 1),
        PathNode:MapBlock(4, 1),
        PathNode:MapBlock(5, 1),
        elevator.node,
        PathNode:MapBlock(5, 3),
        PathNode:MapBlock(4, 3),
        PathNode:MapBlock(3, 3),
        PathNode:MapBlock(2, 3),
      }, path)
    end
    do
      -- floor 3 to 2
      local path = finder:getPath(Coord(6, 3), Coord(6, 2))
      areSamePath({
        PathNode:MapBlock(6, 3),
        PathNode:MapBlock(5, 3),
        elevator.node,
        PathNode:MapBlock(5, 2),
        PathNode:MapBlock(6, 2),
      }, path)
    end
  end)

  it("stair and elevator", function()
    local map = createMap{
      {0, 1, 1, 1, 1, 1, 0},
      {0, 1, 1, 1, 1, 1, 0},
      {0, 1, 1, 1, 1, 1, 0},
      {0, 1, 1, 1, 1, 1, 0},
      {0, 1, 1, 1, 1, 1, 0},
    }
    local elevator = Elevator(3, 1)
    elevator.topY = 5
    elevator:connect(2):connect(3):connect(4):connect(5)
    local stair1 = Stair(4, 1)
    local stair2 = Stair(4, 2)
    local stair3 = Stair(4, 3)
    local stair4 = Stair(4, 4)
    local movers = createMovers{elevator, stair1, stair2, stair3, stair4}
    addMoversToMap(map, movers)
    local finder = Pathfinder(map, movers)
    do
      -- prefer stair for floor distance = 1
      local path = finder:getPath(Coord(2, 1), Coord(2, 2))
      areSamePath({
        PathNode:MapBlock(2, 1),
        PathNode:MapBlock(3, 1),
        PathNode:MapBlock(4, 1),
        stair1.node,
        PathNode:MapBlock(4, 2),
        PathNode:MapBlock(3, 2),
        PathNode:MapBlock(2, 2),
      }, path)
    end
    do
      -- prefer stairs for floor distance <= 3
      local path = finder:getPath(Coord(2, 1), Coord(2, 4))
      areSamePath({
        PathNode:MapBlock(2, 1),
        PathNode:MapBlock(3, 1),
        PathNode:MapBlock(4, 1),
        stair1.node,
        PathNode:MapBlock(4, 2),
        stair2.node,
        PathNode:MapBlock(4, 3),
        stair3.node,
        PathNode:MapBlock(4, 4),
        PathNode:MapBlock(3, 4),
        PathNode:MapBlock(2, 4),
      }, path)
    end
    do
      -- prefer elevator for floor distance > 3
      local path = finder:getPath(Coord(2, 1), Coord(2, 5))
      areSamePath({
        PathNode:MapBlock(2, 1),
        PathNode:MapBlock(3, 1),
        elevator.node,
        PathNode:MapBlock(3, 5),
        PathNode:MapBlock(2, 5),
      }, path)
    end
  end)
end)
