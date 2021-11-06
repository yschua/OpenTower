local Floor = require 'objects.Floor'
local Room = require 'objects.Room'

local tower = {}

local _floors = {}
local _blocks = {}

local function toBlockLevel(level)
  return level + c.GROUND_BLOCK_HEIGHT + 1
end

function tower.load()
  for h = 1, c.WORLD_BLOCK_HEIGHT do
    _blocks[h] = {}
    for w = 1, c.WORLD_BLOCK_WIDTH do
      _blocks[h][w] = 0
    end
  end

  -- TODO temp hard coded build
  local blockLeft = 4
  local blockRight = 15
  for level = 0, 3 do
    local blockLevel = toBlockLevel(level)
    _floors[blockLevel] = Floor(blockLevel, blockLeft, blockRight)
  end
  tower.buildRoom('office', 5, 1)
  tower.buildRoom('office', 8, 1)
  tower.buildRoom('office', 12, 1)
end

function tower.buildRoom(type, blockX, level)
  local blockLevel = toBlockLevel(level)
  local room = Room(type, blockX, blockLevel)
  _floors[blockLevel]:add(room)
  for x = blockX, blockX + room.blockWidth - 1 do
    _blocks[blockLevel][x] = room.id
  end
end

function tower.update(dt)

end

function tower.draw()
  for _, floor in pairs(_floors) do
    floor:draw()
  end

  love.graphics.setColor(0, 0, 0)
  for y, row in ipairs(_blocks) do
    for x, id in ipairs(row) do
      if id ~= 0 then
        local font       = love.graphics.getFont()
        local textWidth  = font:getWidth(id)
        local textHeight = font:getHeight()
        love.graphics.print(
          id,
          utils.toWorldX(x) + c.BLOCK_SIZE / 2,
          utils.toWorldY(y) + c.BLOCK_SIZE / 2,
          0, 1, 1,
          textWidth / 2,
          textHeight / 2)
      end
    end
  end
end

return tower
