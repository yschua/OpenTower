-- require("lldebugger").start()
loveframes = require 'libraries.loveframes.loveframes'
game = require 'game'

local font = love.graphics.newFont(16)

function love.load()
  local major, minor, revision, codename = love.getVersion()
  print(("LOVE Version %d.%d.%d - %s"):format(major, minor, revision, codename))
end

function love.update(dt)
  game.update(dt)
  loveframes.update(dt)
end

function love.draw()
  love.graphics.print(game.dayTimeStr(), font, 10, 10)
  love.graphics.printf(love.timer.getFPS(), love.graphics.getWidth() - 60, 10, 50, 'right')
  loveframes.draw()
end

function love.mousepressed(x, y, button)
  loveframes.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
  loveframes.mousereleased(x, y, button)
end

function love.keypressed(key, scancode, isrepeat)
  loveframes.keypressed(key, isrepeat)
end

function love.keyreleased(key)
  loveframes.keyreleased(key)
end

function love.textinput(text)
  loveframes.textinput(text)
end