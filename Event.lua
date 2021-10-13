local Event = class('Event')

Event.static.nextId = 1

function Event:initialize(func)
  self.func = func
  self.id = Event.static.nextId
  Event.static.nextId = Event.static.nextId + 1
end

return Event
