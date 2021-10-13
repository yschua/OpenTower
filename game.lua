local Event = require 'Event'

local game = {}

local accumulator
local events
local TIME_IN_DAY = 60 * 24

function game.init()
  game.time = TIME_IN_DAY - 1
  game.day = 0
  game.rate = 2

  accumulator = 0
  events = {}
end

function game.addEvent(time, func)
  if not events[time] then events[time] = {} end
  local event = Event(func)
  table.insert(events[time], event)
  return event.id
end

function game.removeEvent(id)
  -- TODO don't do full search
  for _, eventsAtTime in pairs(events) do
    for i, event in pairs(eventsAtTime) do
      if event.id == id then
        table.remove(eventsAtTime, i)
        return
      end
    end
  end
  error("event id does not exist: " .. id)
end

local function updateGameTime(dt)
  if game.rate <= 0 then return end

  accumulator = accumulator + dt
  local period = 1 / game.rate

  while accumulator >= period do
    accumulator = accumulator - period
    game.time = game.time + 1

    if game.time == TIME_IN_DAY then
      game.day = game.day + 1
      game.time = game.time - TIME_IN_DAY
    end

    -- trigger events
    if events[game.time] then
      for _, event in ipairs(events[game.time]) do
        event.func()
      end
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
