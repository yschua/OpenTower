local Person = require 'objects.Person'
local Coord = require 'objects.Coord'

local people = {}

function people.load(pathfinder)
  -- TODO temp hard coded people
  local person = Person(utils.toWorldCoords(4, 11))
  person.target = Coord(9, 12)
  person.path = pathfinder:getPath(person:currentCoord(), person.target)
  table.insert(people, person)
end

function people.update(dt)
end

return people
