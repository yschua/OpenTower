local Queue = class('Queue')

function Queue:initialize()
  self.first = 0
  self.last = -1
end

function Queue:pushleft(value)
  local first = self.first - 1
  self.first = first
  self[first] = value
end

function Queue:pushright(value)
  local last = self.last + 1
  self.last = last
  self[last] = value
end

function Queue:popleft()
  local first = self.first
  if first > self.last then error("queue is empty") end
  local value = self[first]
  self[first] = nil
  self.first = first + 1
  return value
end

function Queue:popright()
  local last = self.last
  if self.first > last then error("queue is empty") end
  local value = self[last]
  self[last] = nil
  self.last = last - 1
  return value
end

function Queue:size()
  return (self.first > self.last) and 0 or (self.last - self.first + 1)
end

return Queue
