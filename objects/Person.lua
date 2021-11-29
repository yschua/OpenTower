local Coord = require 'objects.Coord'

local Person = class('Person')

function Person:initialize(wx, wy)
  self.wx = wx
  self.wy = wy
  self.target = nil
  self.path = nil
end

function Person:currentCoord()
  return Coord(utils.toBlockCoords(self.wx, self.wy))
end

return Person
