local Mover = require 'objects.Mover'
local Queue = require 'objects.Queue'
local lume = require 'libraries.lume.lume'

local Elevator = class('Elevator', Mover)

function Elevator:initialize(x, y)
  Mover.initialize(self, x, y)
  self.cost = 20
  self.connectedY[self.y] = true
  self.topY = self.y
  self.bottomY = self.y
  self.wx, self.wy = utils.toWorldCoords(x, y)
  -- self.level = utils.toBlockY(y)
  -- self.direction = 'up' -- stop, up, down
  self.directionUp = true
  self.stopped = true
  self.destToPersons = {}
  self.personsQueue = {}
  self.personsQueue[self.y] = Queue()
  self.destToGo = {}
  self.currentDest = nil
end

-- states: stopped, moving
-- destination: queued?

function Elevator:connect(y)
  if y > self.topY or y < self.bottomY then
    error("elevator connect out of range")
  end
  self.connectedY[y] = true
  self.personsQueue[y] = Queue()
  return self
end

local function tablesize(t)
  local count = 0
  for _, _ in pairs(t) do
      count = count + 1
  end
  return count
end

-- The elevator algorithm, a simple algorithm by which a single elevator can
-- decide where to stop, is summarized as follows:
-- - Continue travelling in the same direction while there are remaining requests
--   in that same direction.
-- - If there are no further requests in that direction, then stop and become idle,
--   or change direction if there are requests in the opposite direction.

function Elevator:getNextDestination(currentY, directionUp)
  if tablesize(self.destToGo) == 0 then return nil end

  local startY = currentY
  local endY = directionUp and self.topY or self.bottomY
  for y = startY, endY do
    if self.connectedY[y] then
      local isDestination = self.destToPersons[y] and (tablesize(self.destToPersons[y]) > 0)
      local hasPerson = not self.personsQueue[y]:empty()
      if (isDestination or hasPerson) and self.destToGo[y] then
        return y
      end
    end
  end
  return nil
end

function Elevator:changeDirection()
  self.directionUp = not self.directionUp
  -- self.direction = (self.direction == 'up') and 'down' or 'up'
end

function Elevator:update(dt)
  if self.stopped then
    local y = utils.toBlockY(self.wy)

    -- unload persons

    -- check persons queue
    -- load person and return
    local personsQueue = self.personsQueue[y]
    if not personsQueue:empty() then
      local personDestPair = personsQueue:popright()
      local person = personDestPair[1]
      local dest = personDestPair[2]
      self.destToPersons[dest] = person
      person.isInElevator = true
      self.destToGo[dest] = true
      return
    end

    -- get next destination
    self.currentDest = self:getNextDestination(y, self.directionUp)

    if self.currentDest == nil then
      self.currentDest = self:getNextDestination(y, not self.directionUp)
      if self.currentDest == nil then return end
      self.directionUp = not self.directionUp
    end

    -- there is destination, set stopped to false
    self.stopped = false
  else
    local speed = 32
    local disp = utils.toWorldY(self.currentDest) - self.wy
    if disp == 0 then
      self.destToGo[self.currentDest] = nil
      self.currentDest = nil
      self.stopped = true
      return
    end
    local dy = math.min(speed * dt, math.abs(disp)) * lume.sign(disp)
    self.wy = lume.round(self.wy + dy)
    -- update position
    -- set to stopped when reached destination, remove from destToGo
  end
end

function Elevator:draw()
  love.graphics.setColor(0, 1, 0)
  love.graphics.rectangle('line', self.wx, self.wy, c.BLOCK_SIZE, c.BLOCK_SIZE)
end

function Elevator:queuePerson(person, dest)
  local y = utils.toBlockY(person.wy)
  self.personsQueue[y]:pushleft({person, dest})
  self.destToGo[y] = true
end

function Elevator:loadPerson(dest, person)
  if not self.stopped or utils.toBlockY(person.wy) ~= utils.toBlockY(self.wy) then return end

  person.isInElevator = true
  self.destToPersons[dest] = person -- TODO suport more than one person
  self.destToGo[dest] = true
end

return Elevator
