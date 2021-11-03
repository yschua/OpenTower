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
    game.update(c.TIME_IN_DAY)
    assert.are.equal(0, game.time)
    game.update(0.6)
    assert.are.equal(0, game.time)
    game.update(0.6)
    assert.are.equal(1, game.time)
    game.update(2.8)
    assert.are.equal(4, game.time)
  end)

  it("only updates rate on time tick", function()
    local initialRate = game.rate
    local expectedRate = 123
    game.updateRate(expectedRate)
    assert.are.equal(initialRate, game.rate)
    game.update(0.5)
    assert.are.equal(initialRate, game.rate)
    game.update(0.5)
    assert.are.equal(expectedRate, game.rate)
  end)

  it("creates events with unique IDs", function()
    local id = game.addEvent(0, function() end)
    assert.is_equal(id + 1, game.addEvent(0, function() end))
    assert.is_equal(id + 2, game.addEvent(0, function() end))
  end)

  it("adds and triggers events", function()
    local event1 = spy.new(function() end)
    local event2 = spy.new(function() end)

    game.addEvent(0, event1)
    game.addEvent(4, event2)

    game.update(1)
    assert.spy(event1).was.called()
    assert.spy(event2).was_not.called()

    game.update(4)
    assert.spy(event2).was.called()

    -- time outside range
    assert.has.errors(function() game.addEvent(-1, function() end) end)
    assert.has.errors(function() game.addEvent(c.TIME_IN_DAY, function() end) end)
  end)

  it("handles recurring and non-recurring events", function()
    local nonRecurringEvent = spy.new(function() end)
    local recurringEvent = spy.new(function() end)

    game.addEvent(500, nonRecurringEvent, true)
    game.addEvent(500, recurringEvent)

    game.update(c.TIME_IN_DAY)
    assert.spy(nonRecurringEvent).was.called(1)
    assert.spy(recurringEvent).was.called(1)

    game.update(c.TIME_IN_DAY)
    assert.spy(nonRecurringEvent).was.called(1)
    assert.spy(recurringEvent).was.called(2)
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
