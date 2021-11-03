-- constants
c = {
  TIME_IN_DAY = 60 * 24,
  BLOCK_SIZE = 64,
  WORLD_BLOCK_WIDTH = 25,
  WORLD_BLOCK_HEIGHT = 40,
  GROUND_BLOCK_HEIGHT = 10,
}

class = require 'libraries.middleclass.middleclass'
utils = require 'utils'
game = require 'game'

if love then
  loveframes = require 'libraries.LoveFrames.loveframes'
end
