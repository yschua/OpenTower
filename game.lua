local game = {}


local accumulator
local TIME_IN_DAY = 60 * 24

function game.init()
  game.time = 0
  game.day = 1
  game.rate = 2

  accumulator = 0
end

local function updateGameTime(dt)
  if game.rate <= 0 then return end

  accumulator = accumulator + dt
  local period = 1 / game.rate

  while accumulator >= period do
    accumulator = accumulator - period
    game.time = game.time + 1

    if game.time > TIME_IN_DAY then
      game.day = game.day + 1
      game.time = game.time - TIME_IN_DAY
    end
  end
end

function game.update(dt)
  updateGameTime(dt)
end

function game.dayTimeStr()
  local min = game.time % 60
  local hour = math.floor(game.time / 60)
  return ("Day %d\n%02d:%02d"):format(game.day, hour, min)
end

return game
