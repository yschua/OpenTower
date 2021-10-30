local grid = {}

local editgrid = require 'libraries.editgrid.editgrid'

local gridLines
local showGridLines

function grid.load(camera)
  gridLines = editgrid.grid(camera, {hideOrigin = true})
  showGridLines = true
end

function grid.draw()
  if showGridLines then gridLines:draw() end
end

function grid.toggleGridLines()
  showGridLines = not showGridLines
end

return grid
