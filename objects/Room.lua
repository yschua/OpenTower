local Room = class('Room')

Room.static.nextId = 1

-- TODO rename to FloorSpace

function Room:initialize(type, x, y)
  self.type = type
  self.x = x
  self.y = y
  self.blockWidth = 3
  self.id = Room.static.nextId
  Room.static.nextId = Room.static.nextId + 1
end

function Room:draw()
  local wx = utils.toWorldX(self.x)
  local wy = utils.toWorldY(self.y)
  local width = self.blockWidth * c.BLOCK_SIZE
  local height = c.BLOCK_SIZE

  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle('fill', wx, wy, width, height)
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle('line', wx, wy, width, height)
  love.graphics.print(self.type, wx + 2, wy + 2)
end

return Room
