local environment = require 'environment'
local Camera = require 'libraries.hump.camera'
local editgrid = require 'libraries.editgrid.editgrid'

local camera = Camera()
local grid = editgrid.grid(camera, {hideOrigin = true})
local showGrid = true

function love.load()
  -- TODO parse command line arguments properly
  if arg[2] == '--debug' then
    require("lldebugger").start()
  end

  require 'globals'

  game.init()
  gameMenu.load()
  environment.load()

  -- TODO load from save, scale to screen
  camera:lookAt(256, -128)
  camera:zoomTo(1.1)
end

function love.update(dt)
  game.update(dt)
  environment.update(dt)
  loveframes.update(dt)
end

function love.draw()
  camera:draw(function()
    environment.draw()
  end)

  if showGrid then grid:draw() end

  -- day time display
  love.graphics.setColor(255, 255, 255)
  local font = love.graphics.newFont(16)
  local dayTimeStr = ("Day %d\n%s"):format(game.day, utils.timeToString(game.time))
  love.graphics.print(dayTimeStr, font, 10, 10)
  love.graphics.printf(love.timer.getFPS(), love.graphics.getWidth() - 60, 10, 50, 'right')

  loveframes.draw()
end

function love.mousemoved(x, y, dx, dy, istouch)
  if love.mouse.isDown(2) then
    camera:move(-dx / camera.scale, -dy / camera.scale)
  end
end

function love.wheelmoved(x, y)
  if y ~= 0 then
    local scaleOffset = y > 0 and 0.1 or -0.1
    camera.scale = camera.scale + scaleOffset
    camera.scale = math.max(0.1, camera.scale)
  end
end

function love.mousepressed(x, y, button)
  loveframes.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
  loveframes.mousereleased(x, y, button)
end

function love.keypressed(key, scancode, isrepeat)
  if key == 'g' then
    showGrid = not showGrid
  end

  loveframes.keypressed(key, isrepeat)
end

function love.keyreleased(key)
  loveframes.keyreleased(key)
end

function love.textinput(text)
  loveframes.textinput(text)
end
