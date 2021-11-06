local Room = class('Room')

Room.static.nextId = 1
Room.static.allRooms = {}

function Room:initialize(type, blockX, blockY)
  self.type = type
  self.blockX = blockX
  self.blockY = blockY
  self.blockWidth = 3
  self.id = Room.static.nextId
  Room.static.nextId = Room.static.nextId + 1
  Room.static.allRooms[self.id] = self
end

function Room:draw()
  local x = utils.toWorldX(self.blockX)
  local y = utils.toWorldY(self.blockY)
  local width = self.blockWidth * c.BLOCK_SIZE
  local height = c.BLOCK_SIZE

  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle('fill', x, y, width, height)
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle('line', x, y, width, height)
  love.graphics.print(self.type, x + 2, y + 2)
end

return Room
