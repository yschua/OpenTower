local PathNode = class('PathNode')

function PathNode:initialize(x, y, takeMover)
  self.x = x
  self.y = y
  self.takeMover = (takeMover ~= nil) and takeMover or false
end

return PathNode
