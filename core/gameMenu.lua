local gameMenu = {}

function gameMenu.load()
  local gameRates = {
    {'Pause', 0},
    {'Slow', 1},
    {'Normal', 2},
    {'Fast', 10},
    {'Faster', 100},
  }

  for i, gameRate in ipairs(gameRates) do
    local name, rate = gameRate[1], gameRate[2]
    -- TODO create under frame
    local button = loveframes.Create('button')
    local width = 50
    button:SetWidth(width)
    button:SetText(name)
    button:SetPos(100 + width * (i - 1), 10)
    button.OnClick = function() game.updateRate(rate) end
    button.groupIndex = 1
    button.checked = (game.rate == rate)
  end
end

return gameMenu
