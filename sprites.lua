local sprites = {}

local _people
local drawMan

function sprites.load(people)
  _people = people

  local manImage = love.graphics.newImage("assets/sprite.png")
  local manHeight = 34
  local man = love.graphics.newQuad(49, 107, 20, manHeight, manImage:getDimensions())

  drawMan = function(x, y)
    love.graphics.draw(manImage, man, x, y + c.BLOCK_SIZE - manHeight)
  end
end

function sprites.update(dt)
end

-- this isn't a sprite but ok
local function drawPath(path)
  local points = {}
  for _, pathNode in ipairs(path) do
    if not pathNode:isMover() then
      local wx = utils.toWorldX(pathNode.coord.x) + c.BLOCK_SIZE / 2
      local wy = utils.toWorldY(pathNode.coord.y) + c.BLOCK_SIZE / 2
      table.insert(points, wx)
      table.insert(points, wy)
    end
  end
  love.graphics.setColor(1, 0, 1, 1)
  love.graphics.line(points)

  local destX = points[#points - 1]
  local destY = points[#points]
  love.graphics.circle('fill', destX, destY, 3)
end

function sprites.draw()
  for _, person in ipairs(_people) do
    drawMan(person.wx, person.wy)
    if person.path then
      drawPath(person.path)
    end
  end
end

return sprites
