local environment = {}

local currentSky
local nextSky
local nextSkyOpacity = 1
local transitionDuration = 0

local drawGround

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
  -- set up sky
  local skies = {
    ['night'] = createGradient('1F2336', '212F42'),
    ['dawn'] = createGradient('3F5182', 'AD5637'),
    ['day'] = createGradient('316AAF', '7DAACE'),
    ['dusk'] = createGradient('8290CC', 'DD92A0'),
  }

  currentSky = skies['night']
  nextSky = currentSky

  game.addEvent(utils.time(5, 30), function() startTransition(skies['dawn'], 90) end)
  game.addEvent(utils.time(7, 0), function() startTransition(skies['day'], 60) end)
  game.addEvent(utils.time(17, 30), function() startTransition(skies['dusk'], 90) end)
  game.addEvent(utils.time(19, 30), function() startTransition(skies['night'], 60) end)

  -- set up ground
  local groundImage = love.graphics.newImage("assets/ground.png")
  local tileSize = 32
  local groundUnder = love.graphics.newQuad(0, 0, tileSize, tileSize, groundImage:getDimensions())
  local groundTop = love.graphics.newQuad(tileSize, 0, tileSize, tileSize, groundImage:getDimensions())
  drawGround = function(x, y, width, height)
    love.graphics.setColor(1, 1, 1, 1)
    for iy = y, (y + height - tileSize), tileSize do
      for ix = x, (x + width - tileSize), tileSize do
        love.graphics.draw(groundImage, (iy == y) and groundTop or groundUnder, ix, iy)
      end
    end
  end
end

function environment.update(dt)
  if nextSkyOpacity < 1 then
    nextSkyOpacity = (nextSkyOpacity + dt * game.rate / transitionDuration)
    nextSkyOpacity = math.min(nextSkyOpacity, 1)
  end
end

function environment.draw()
  local worldX = -256
  local worldWidth = 1024
  local skyHeight = 1024
  local groundHeight = 256

  -- draw sky
  local skyDimensions = function()
    return worldX, -skyHeight, 0, (worldWidth / currentSky:getWidth()), (skyHeight / currentSky:getHeight())
  end
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(currentSky, skyDimensions())
  love.graphics.setColor(1, 1, 1, nextSkyOpacity)
  love.graphics.draw(nextSky, skyDimensions())

  drawGround(worldX, 0, worldWidth, groundHeight)
end

return environment
