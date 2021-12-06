local Event = require 'objects.Event'

local game = {}

local accumulator
local events
local nextRate

function game.init()
  game.time = c.TIME_IN_DAY - 1
  game.day = 0
  game.rate = 2

  accumulator = 0
  events = {}
end

function game.updateRate(rate)
  nextRate = rate
end

function game.addEvent(time, func, runOnce)
  -- TODO logging
  if time < 0 or time >= c.TIME_IN_DAY then
    error("invalid event time")
  end
  if not events[time] then events[time] = {} end
  local event = Event(func, runOnce)
  table.insert(events[time], event)
  return event.id
end

function game.removeEvent(id)
  -- TODO logging
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

local function triggerEvents()
  local currentEvents = events[game.time]
  if not currentEvents or #currentEvents == 0 then return end
  local eventIdsToRemove = {}

  for _, event in ipairs(currentEvents) do
    event.func()
    if event.runOnce then
      table.insert(eventIdsToRemove, event.id)
    end
  end

  for _, eventId in ipairs(eventIdsToRemove) do
    game.removeEvent(eventId)
  end
end

local function updateGameTime(dt)
  if game.rate <= 0 then return end

  accumulator = accumulator + dt
  local period = 1 / game.rate

  while accumulator >= period do
    accumulator = accumulator - period
    game.time = game.time + 1

    if game.time == c.TIME_IN_DAY then
      game.day = game.day + 1
      game.time = game.time - c.TIME_IN_DAY
    end

    if nextRate then
      game.rate = nextRate
      nextRate = nil
    end

    triggerEvents()
  end
end

function game.update(dt)
  updateGameTime(dt)
end

return game
