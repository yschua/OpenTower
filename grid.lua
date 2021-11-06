local editgrid = require 'libraries.editgrid.editgrid'

local grid = {}

local _camera
local _gridLines
local _showGridLines

function grid.load(camera)
  _camera = camera
  _gridLines = editgrid.grid(camera, {hideOrigin = true})
  _showGridLines = false
end

function grid.draw()
  if _showGridLines then _gridLines:draw() end

  -- block indicator
  local blockX, blockY = utils.toBlockCoords(_camera:worldCoords(love.mouse.getPosition()))
  love.graphics.setColor(0, 1, 1)
  _camera:draw(function()
    love.graphics.rectangle(
      'line',
      utils.toWorldX(blockX),
      utils.toWorldY(blockY),
      c.BLOCK_SIZE,
      c.BLOCK_SIZE)
    end)
  love.graphics.setColor(1, 1, 1)
  love.graphics.printf(
    ("(%d, %d)"):format(blockX, blockY),
    love.graphics.getWidth() - 60,
    love.graphics.getHeight() - 20,
    50,
    'right')
end

function grid.toggleGridLines()
  _showGridLines = not _showGridLines
end

return grid
