
describe("game module", function()
  setup(function()
    require 'globals'
  end)

  before_each(function()
    game.init()
    game.rate = 1
  end)

  it("updates the game time", function()
    game.update(1)
    assert.are.equal(0, game.time)
    game.update(60 * 24)
    assert.are.equal(0, game.time)
    game.update(0.6)
    assert.are.equal(0, game.time)
    game.update(0.6)
    assert.are.equal(1, game.time)
    game.update(2.8)
    assert.are.equal(4, game.time)
  end)

  it("triggers events on time", function()
    local event1 = spy.new(function() end)
    local event2 = spy.new(function() end)

    assert.is_equal(1, game.addEvent(0, event1))
    assert.is_equal(2, game.addEvent(4, event2))

    game.update(1)
    assert.spy(event1).was.called()
    assert.spy(event2).was_not.called()

    game.update(4)
    assert.spy(event2).was.called()
  end)

  it("removes the correct events", function()
    local event1 = spy.new(function() end)
    local event2 = spy.new(function() end)
    local event3 = spy.new(function() end)

    game.addEvent(2, event1)
    local idToRemove = game.addEvent(2, event2)
    game.addEvent(3, event3)

    game.update(1)
    game.removeEvent(idToRemove)
    game.update(5)

    assert.spy(event1).was.called()
    assert.spy(event2).was_not.called()
    assert.spy(event3).was.called()

    -- event already removed
    assert.has.errors(function() game.removeEvent(idToRemove) end)
  end)
end)
