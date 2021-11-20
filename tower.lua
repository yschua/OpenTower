local Floor = require 'objects.Floor'
local Room = require 'objects.Room'
local Stair = require 'objects.Stair'
local Elevator = require 'objects.Elevator'

local tower = {}

local _floors = {}
local _map = {}
local _rooms = {}
local _movers = {}

function tower.load()
  for y = 1, c.WORLD_BLOCK_HEIGHT do
    _map[y] = {}
    for x = 1, c.WORLD_BLOCK_WIDTH do
      _map[y][x] = {roomId = 0, moverId = 0}
    end
  end

  -- TODO temp hard coded build
  local leftX = 4
  local rightX = 15
  for y = 11, 14 do
    _floors[y] = Floor(y, leftX, rightX)
  end
  tower.buildRoom('office', 5, 12)
  tower.buildRoom('office', 8, 12)
  tower.buildRoom('office', 12, 12)
  tower.buildMover(Stair(6, 11))
  local elevator = Elevator(11, 11)
  tower.buildMover(elevator)
  tower.setElevatorRange(elevator.id, 11, 13)
  -- TODO also need to actually connect the elevator
end

function tower.buildRoom(type, x, y)
  local room = Room(type, x, y)
  _rooms[room.id] = room
  _floors[y]:add(room)
  for ix = x, x + room.blockWidth - 1 do
    _map[y][ix].roomId = room.id
  end
  return room.id
end

function tower.buildMover(mover)
  assert(mover.class.super.name == 'Mover')
  _movers[mover.id] = mover
  _map[mover.y][mover.x].moverId = mover.id
end

function tower.setElevatorRange(id, bottomY, topY)
  local mover = _movers[id]
  assert(mover.class == Elevator)
  for y = mover.bottomY, mover.topY do
    _map[y][mover.x].moverId = 0
  end
  mover.bottomY = bottomY
  mover.topY = topY
  for y = mover.bottomY, mover.topY do
    _map[y][mover.x].moverId = mover.id
  end
end

function tower.update(dt)

end

function tower.draw()
  for _, floor in pairs(_floors) do
    floor:draw()
  end

  for y, row in ipairs(_map) do
    for x, block in ipairs(row) do
      if block.roomId ~= 0 then
        local font = love.graphics.getFont()
        local textWidth = font:getWidth(block.roomId)
        local textHeight = font:getHeight()
        love.graphics.setColor(0, 0, 0)
        love.graphics.print(
          block.roomId,
          utils.toWorldX(x) + c.BLOCK_SIZE / 2,
          utils.toWorldY(y) + c.BLOCK_SIZE / 2,
          0, 1, 1,
          textWidth / 2,
          textHeight / 2)
      end

      if block.moverId ~= 0 then
        local font = love.graphics.getFont()
        local textWidth = font:getWidth(block.roomId)
        local textHeight = font:getHeight()
        local wx = utils.toWorldX(x) + c.BLOCK_SIZE / 2
        local wy = utils.toWorldY(y)
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle('fill', wx - textWidth / 2, wy - textHeight / 2, textWidth, textHeight)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(block.moverId, wx, wy, 0, 1, 1, textWidth / 2, textHeight / 2)
      end
    end
  end
end

return tower
