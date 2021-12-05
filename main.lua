-- TODO parse command line arguments properly
-- switch for VS Code
if arg[2] == '--debug' then
  require("lldebugger").start()
end
-- switch for ZeroBrane
if arg[#arg] == '-debug' then
  require("mobdebug").start()
end

require 'globals'

local gameMenu = require 'gameMenu'
local environment = require 'environment'
local grid = require 'grid'
local tower = require 'tower'
local sprites = require 'sprites'

local Camera = require 'libraries.hump.camera'

local camera = Camera()

local function resetCamera()
  camera:lookAt(utils.toWorldCoords(math.floor(c.WORLD_BLOCK_WIDTH / 2), c.GROUND_BLOCK_HEIGHT))
  camera:zoomTo(1)
end

function love.load()
  game.init()
  gameMenu.load()
  grid.load(camera)
  environment.load()
  tower.load()
  sprites.load(tower.people)

  -- TODO load from save, scale to screen
  resetCamera()
end

function love.update(dt)
  game.update(dt)
  local rateAdjustedDt = dt * game.rate
  environment.update(rateAdjustedDt)
  tower.update(rateAdjustedDt)
  loveframes.update(dt)
end

function love.draw()
  camera:draw(function()
    environment.draw()
    tower.draw()
    sprites.draw()
  end)

  grid.draw()

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
  if key == 'g' then grid.toggleGridLines() end
  if key == 'r' then resetCamera() end

  loveframes.keypressed(key, isrepeat)
end

function love.keyreleased(key)
  loveframes.keyreleased(key)
end

function love.textinput(text)
  loveframes.textinput(text)
end
