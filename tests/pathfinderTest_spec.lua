require 'globals'
local Coord = require 'objects.Coord'
local PathNode = require 'objects.PathNode'
local Pathfinder = require 'Pathfinder'

describe("pathfinder module", function()
  setup(function()
  end)

  local function createRooms(map)
    local rooms = {}
    for y = 1, #map do
      rooms[y] = {}
      for x = 1, #map[y] do
        rooms[y][x] = {cost = map[y][x], moverIds = {}, node = PathNode:Room(x, y)}
      end
    end
    return rooms
  end

  local function createMover(rooms, movers, moverId, roomCoords)
    movers[moverId] = {cost = 10, roomCoords = roomCoords, node = PathNode:Mover(moverId)}
    for _, coord in ipairs(roomCoords) do
      local room = rooms[coord.y][coord.x]
      table.insert(room.moverIds, moverId)
    end
  end

  local function areSamePathNodes(a, b)
    assert.are.equal(a.class, b.class, PathNode)
    if a:isMover() then
      assert.are.equal(a.moverId, b.moverId)
    else
      assert.are.same(a.roomCoord, b.roomCoord)
    end
  end

  it("test", function()
    local rooms = createRooms{
      {0, 1, 1, 1, 1, 1, 0},
      {0, 1, 1, 1, 1, 1, 0}
    }
    local movers = {}
    createMover(rooms, movers, 1, {Coord(4, 1), Coord(4, 2)})
    local finder = Pathfinder(rooms, movers)
    local path = finder:getPath(Coord(2, 1), Coord(6, 2))
    areSamePathNodes(path[1], PathNode:Room(2, 1))
    areSamePathNodes(path[2], PathNode:Room(3, 1))
    areSamePathNodes(path[3], PathNode:Room(4, 1))
    areSamePathNodes(path[4], PathNode:Mover(1))
    areSamePathNodes(path[5], PathNode:Room(4, 2))
    areSamePathNodes(path[6], PathNode:Room(5, 2))
    areSamePathNodes(path[7], PathNode:Room(6, 2))
    assert.are.equal(#path, 7)
  end)

end)
