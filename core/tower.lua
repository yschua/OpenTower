local Floor = require 'objects.Floor'
local Room = require 'objects.Room'
local Stair = require 'objects.Stair'
local Elevator = require 'objects.Elevator'
local MapBlock = require 'objects.MapBlock'
local Pathfinder = require 'core.Pathfinder'
local people = require 'core.people'

local tower = {
  people = people
}

local _floors = {}
local _map = {}
local _rooms = {}
local _movers = {}

function tower.load()
  local pathfinder = Pathfinder(_map, _movers)

  for y = 1, c.WORLD_BLOCK_HEIGHT do
    _map[y] = {}
    for x = 1, c.WORLD_BLOCK_WIDTH do
      _map[y][x] = MapBlock(x, y)
    end
  end

  -- TODO temp hard coded build
  for y = 11, 14 do
    tower.buildFloor(y, 4, 15)
  end
  tower.buildRoom('office', 5, 12)
  tower.buildRoom('office', 8, 12)
  tower.buildRoom('office', 12, 12)
  tower.buildMover(Stair(6, 11))
  tower.buildMover(Stair(13, 12))
  local elevator = Elevator(11, 11)
  tower.buildMover(elevator)
  tower.setElevatorRange(elevator.id, 11, 14)
  elevator:connect(12):connect(13):connect(14)

  people.load(pathfinder)
end

function tower.buildFloor(y, leftX, rightX)
  _floors[y] = Floor(y, leftX, rightX)
  for x = leftX, rightX do
    _map[y][x].cost = 1
  end
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
  _map[mover.y + 1][mover.x].moverId = mover.id -- TODO this sucks
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
  people.update(dt, _movers)
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
          utils.toWorldX(x) + c.BLOCK_SIZE / 3,
          utils.toWorldY(y) + c.BLOCK_SIZE / 2,
          0, 1, 1,
          textWidth / 2,
          textHeight / 2)
      end

      if block.moverId ~= 0 then
        local font = love.graphics.getFont()
        local textWidth = font:getWidth(block.roomId)
        local textHeight = font:getHeight()
        local wx = utils.toWorldX(x) + 2 * c.BLOCK_SIZE / 3
        local wy = utils.toWorldY(y) + c.BLOCK_SIZE / 2
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle('fill', wx - textWidth / 2, wy - textHeight / 2, textWidth, textHeight)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(block.moverId, wx, wy, 0, 1, 1, textWidth / 2, textHeight / 2)
      end
    end
  end
end

return tower
