local sprites = {}

local _people
local drawMan

function sprites.load(people)
  _people = people

  local manImage = love.graphics.newImage("assets/sprite.png")
  local manHeight = 34
  local man = love.graphics.newQuad(49, 107, 20, manHeight, manImage:getDimensions())

  drawMan = function(x, y)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(manImage, man, x, y + c.BLOCK_SIZE - manHeight)
  end
end

function sprites.update(dt)
end

-- this isn't a sprite but ok
local function drawPath(points)
  if not points then return end
  love.graphics.setColor(1, 0, 1)
  if #points >= 4 then
    love.graphics.line(points)
  end
  if #points >= 2 then
    local destX = points[#points - 1]
    local destY = points[#points]
    love.graphics.circle('fill', destX, destY, 3)
  end
end

function sprites.draw()
  love.graphics.setColor(1, 1, 1)
  for _, person in ipairs(_people) do
    drawPath(person.pathPoints)
    drawMan(person.wx, person.wy)
  end
end

return sprites
