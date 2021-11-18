require 'globals'
local Coord = require 'objects.Coord'
local PathNode = require 'objects.PathNode'
local Stair = require 'objects.Stair'
local Elevator = require 'objects.Elevator'
local Pathfinder = require 'Pathfinder'

describe("pathfinder module", function()
  setup(function()
    c.GROUND_BLOCK_HEIGHT = 0
  end)

  local function createRooms(costMap)
    local rooms = {}
    for y = 1, #costMap do
      rooms[y] = {}
      for x = 1, #costMap[y] do
        rooms[y][x] = {cost = costMap[y][x], moverIds = {}, node = PathNode:Room(x, y)}
      end
    end
    return rooms
  end

  local function createMovers(moverList)
    local movers = {}
    for _, mover in ipairs(moverList) do
      movers[mover.id] = mover
    end
    return movers
  end

  local function linkRoomsToMovers(rooms, movers)
    for id, mover in pairs(movers) do
      for _, coord in ipairs(mover:getConnectingCoords()) do
        local room = rooms[coord.y][coord.x]
        table.insert(room.moverIds, id)
      end
    end
  end

  local function areSamePath(expectedPath, actualPath)
    assert.are.equal(#expectedPath, #actualPath)
    for i = 1, #expectedPath do
      local a = expectedPath[i]
      local b = actualPath[i]
      assert.are.equal(a.class, b.class, PathNode)
      if a:isMover() then
        assert.are.equal(a.moverId, b.moverId)
      else
        assert.are.same(a.roomCoord, b.roomCoord)
      end
    end
  end

  it("single stair", function()
    local rooms = createRooms{
      {0, 1, 1, 1, 1, 1, 0},
      {0, 1, 1, 1, 1, 1, 0},
    }
    local stair = Stair(4, 2 - 1)
    local movers = createMovers{stair}
    linkRoomsToMovers(rooms, movers)
    local finder = Pathfinder(rooms, movers)
    do
      -- same floor
      local path = finder:getPath(Coord(6, 1), Coord(2, 1))
      areSamePath({
        PathNode:Room(6, 1),
        PathNode:Room(5, 1),
        PathNode:Room(4, 1),
        PathNode:Room(3, 1),
        PathNode:Room(2, 1),
      }, path)
    end
    do
      -- floor 1 to 2
      local path = finder:getPath(Coord(2, 1), Coord(6, 2))
      areSamePath({
        PathNode:Room(2, 1),
        PathNode:Room(3, 1),
        PathNode:Room(4, 1),
        stair.node,
        PathNode:Room(4, 2),
        PathNode:Room(5, 2),
        PathNode:Room(6, 2),
      }, path)
    end
  end)

  it("single elevator", function()
    local rooms = createRooms{
      {0, 1, 1, 1, 1, 1, 0},
      {0, 1, 1, 1, 1, 1, 0},
      {0, 1, 1, 1, 1, 1, 0},
    }
    local elevator = Elevator(5, 1 - 1):connect(2):connect(3)
    local movers = createMovers{elevator}
    linkRoomsToMovers(rooms, movers)
    local finder = Pathfinder(rooms, movers)
    do
      -- floor 1 to 3
      local path = finder:getPath(Coord(2, 1), Coord(2, 3))
      areSamePath({
        PathNode:Room(2, 1),
        PathNode:Room(3, 1),
        PathNode:Room(4, 1),
        PathNode:Room(5, 1),
        elevator.node,
        PathNode:Room(5, 3),
        PathNode:Room(4, 3),
        PathNode:Room(3, 3),
        PathNode:Room(2, 3),
      }, path)
    end
    do
      -- floor 3 to 2
      local path = finder:getPath(Coord(6, 3), Coord(6, 2))
      areSamePath({
        PathNode:Room(6, 3),
        PathNode:Room(5, 3),
        elevator.node,
        PathNode:Room(5, 2),
        PathNode:Room(6, 2),
      }, path)
    end
  end)

end)
