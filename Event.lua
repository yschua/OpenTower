local Event = class('Event')

Event.static.nextId = 1

function Event:initialize(func, runOnce)
  self.func = func
  self.runOnce = runOnce or false
  self.id = Event.static.nextId
  Event.static.nextId = Event.static.nextId + 1
end

return Event
