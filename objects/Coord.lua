local Coord = class('Coord')

function Coord:initialize(x, y)
  self.x = x
  self.y = y
end

function Coord:left()
  return Coord(self.x - 1, self.y)
end

function Coord:right()
  return Coord(self.x + 1, self.y)
end

return Coord
