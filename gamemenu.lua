loveframes = require 'libraries.loveframes.loveframes'
game = require 'game'

local gamemenu = {}

function gamemenu.load()
  local gameSpeeds = {
    {'Pause', 0},
    {'Slow', 1},
    {'Normal', 2},
    {'Fast', 10},
    {'Faster', 100},
  }

  for i, gameSpeed in ipairs(gameSpeeds) do
    local name, speed = gameSpeed[1], gameSpeed[2]
    -- TODO create under frame
    local button = loveframes.Create('button')
    local width = 50
    button:SetWidth(width)
    button:SetText(name)
    button:SetPos(100 + width * (i - 1), 10)
    button.OnClick = function() game.rate = speed end
    button.groupIndex = 1
    button.checked = (game.rate == speed)
  end
end

return gamemenu