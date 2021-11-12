local Mover = class('Mover')

Mover.static.nextId = 1

function Mover:initialize(type, blockX, level)
  self.type = type
  self.cost = 5
  self.blockX = blockX
  self.bottomLevel = level
  self.topLevel = level + 1
  self.id = Mover.static.nextId
  Mover.static.nextId = Mover.static.nextId + 1
end

return Mover
