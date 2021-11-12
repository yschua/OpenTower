require 'globals'
local Mover = require 'objects.Mover'
local PathNode = require 'objects.PathNode'
local pathfinder = require 'pathfinder'

describe("pathfinder module", function()
  setup(function()
  end)

  local function createMap(moverMap)
    local map = {}
    for y = 1, #moverMap do
      map[y] = {}
      for x = 1, #moverMap[y] do
        map[y][x] = {moverId = moverMap[y][x]}
      end
    end
    return map
  end

  it("finds path with single stair", function()
    local stair = Mover('stair', 3, 0)
    local movers = {[stair.id] = stair}
    local map = createMap({
      {0, 0, stair.id, 0, 0},
      {0, 0, 0, 0, 0},
    })
    pathfinder.load(map, movers)
    pathfinder.regenerate()
    local path = pathfinder.getPath(1, 1, 5, 2)
    assert.are.equal(#path, 7)
    assert.same(path[1], PathNode(1, 1))
    assert.same(path[2], PathNode(2, 1))
    assert.same(path[3], PathNode(3, 1))
    assert.same(path[4], PathNode(3, 1, true))
    assert.same(path[5], PathNode(3, 2))
    assert.same(path[6], PathNode(4, 2))
    assert.same(path[7], PathNode(5, 2))
  end)

end)
