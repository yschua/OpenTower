require 'globals'

describe("game module test", function()
  setup(function()
    game.init()
    game.rate = 1
  end)

  it("updates the game time", function()
    game.update(1)
    assert.are.equal(1, game.time)
    game.update(0.6)
    assert.are.equal(1, game.time)
    game.update(0.6)
    assert.are.equal(2, game.time)
    game.update(3)
    assert.are.equal(5, game.time)
  end)
end)