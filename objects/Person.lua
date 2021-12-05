local Coord = require 'objects.Coord'
local Queue = require 'objects.Queue'
local lume = require 'libraries.lume.lume'

local Person = class('Person')

function Person:initialize(wx, wy)
  self.wx = wx
  self.wy = wy
  self.path = Queue()
end

function Person:currentCoord()
  return Coord(utils.toBlockCoords(self.wx, self.wy))
end

function Person:update(dt, movers)
  local nextNode = self.path:peekleft()
  if not nextNode then return end

  if nextNode:isMover() then
    local mover = movers[nextNode.moverId]
    local dest = self.path:peekleft(1)

    if mover.name == 'Elevator' then
      -- TODO
    else
      local disp = utils.toWorldY(dest.coord.y) - self.wy
      if disp == 0 then
        self.path:popleft()
        return
      end
      local speed = 32
      local dy = math.min(speed * dt, math.abs(disp)) * lume.sign(disp)
      self.wy = lume.round(self.wy + dy)
    end
  else
    local disp = utils.toWorldX(nextNode.coord.x) - self.wx
    if disp == 0 then
      self.path:popleft()
      return
    end
    local speed = 32
    local dx = math.min(speed * dt, math.abs(disp)) * lume.sign(disp)
    self.wx = lume.round(self.wx + dx)
  end
end

return Person
