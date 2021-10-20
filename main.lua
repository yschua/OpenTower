local environment = require 'environment'

function love.load()
  -- TODO parse command line arguments properly
  if arg[2] == '--debug' then
    require("lldebugger").start()
  end

  require 'globals'

  game.init()
  gameMenu.load()
  environment.load()
end

function love.update(dt)
  game.update(dt)
  environment.update(dt)
  loveframes.update(dt)
end

function love.draw()
  environment.draw()

  -- day time display
  love.graphics.setColor(255, 255, 255)
  local font = love.graphics.newFont(16)
  local dayTimeStr = ("Day %d\n%s"):format(game.day, utils.timeToString(game.time))
  love.graphics.print(dayTimeStr, font, 10, 10)
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
