local environment = {}

local currentSky
local nextSky
local nextSkyOpacity = 1
local transitionDuration = 0

local function createGradient(hexTop, hexBot)
  local imageData = love.image.newImageData(1, 2)
  imageData:setPixel(0, 0, utils.hexToColor(hexTop))
  imageData:setPixel(0, 1, utils.hexToColor(hexBot))

  local image = love.graphics.newImage(imageData)
  image:setFilter('linear', 'linear')
  return image
end

local function startTransition(sky, duration)
  currentSky = nextSky
  nextSky = sky
  nextSkyOpacity = 0
  transitionDuration = duration
end

-- TODO load at a given time
function environment.load()
  local skies = {
    ['night'] = createGradient('1F2336', '212F42'),
    ['dawn'] = createGradient('3C444C', 'E07714'),
    ['day'] = createGradient('3D84DB', 'ADCFDB'),
    ['dusk'] = createGradient('8290CC', 'E23650'),
  }

  currentSky = skies['night']
  nextSky = currentSky

  game.addEvent(utils.time(5, 30), function() startTransition(skies['dawn'], 90) end)
  game.addEvent(utils.time(7, 0), function() startTransition(skies['day'], 60) end)
  game.addEvent(utils.time(17, 30), function() startTransition(skies['dusk'], 90) end)
  game.addEvent(utils.time(19, 0), function() startTransition(skies['night'], 60) end)
end

function environment.update(dt)
  if nextSkyOpacity < 1 then
    nextSkyOpacity = (nextSkyOpacity + dt * game.rate / transitionDuration)
    nextSkyOpacity = math.min(nextSkyOpacity, 1)
  end
end

function environment.draw()
  love.graphics.draw(currentSky, 0, 0, 0, love.graphics.getDimensions())
  love.graphics.setColor(1, 1, 1, nextSkyOpacity)
  love.graphics.draw(nextSky, 0, 0, 0, love.graphics.getDimensions())
end

return environment
