local Floor = class('Floor')

function Floor:initialize(blockHeight, blockLeft, blockRight)
  self.blockHeight = blockHeight
  self.blockLeft = blockLeft
  self.blockRight = blockRight
  self.rooms = {}
end

function Floor:add(room)
  -- TODO check bounds
  table.insert(self.rooms, room)
end

function Floor:draw()
  love.graphics.setColor(utils.rawToColor(100, 100, 100, 100))
  love.graphics.rectangle(
    'fill',
    utils.toWorldX(self.blockLeft),
    utils.toWorldY(self.blockHeight),
    utils.toWorldX(self.blockRight + 1) - utils.toWorldX(self.blockLeft),
    c.BLOCK_SIZE)

  for _, room in pairs(self.rooms) do
    room:draw()
  end
end

return Floor
