local Person = require 'objects.Person'
local Coord = require 'objects.Coord'

local people = {}

function people.load(pathfinder)
  -- TODO temp hard coded people
  local startCoord = Coord(4, 11)
  local endCoord = Coord(4, 14)
  local person = Person(utils.toWorldCoords(startCoord.x, startCoord.y))
  person:setPath(pathfinder:getPath(person:currentCoord(), endCoord))
  table.insert(people, person)
end

function people.update(dt, movers)
  for _, person in ipairs(people) do
    person:update(dt, movers)
  end
end

return people
