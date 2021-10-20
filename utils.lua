local utils = {}

utils.TIME_IN_DAY = 60 * 24

function utils.time(hour, minute)
  return hour * 60 + minute
end

function utils.timeToString(time)
  local minute = time % 60
  local hour = math.floor(time / 60)
  return ("%02d:%02d"):format(hour, minute)
end

function utils.rawToColor(r, g, b, a)
  if type(r) == 'table' then
    r, g, b, a = unpack(r)
  end
  return r / 255, g / 255, b / 255, a and a / 255 or 1
end

function utils.hexToColor(hex, a)
  if type(hex) == 'string' then
    hex = tonumber(hex, 16)
  end
  local r = bit.band(bit.rshift(hex, 16), 0xff)
  local g = bit.band(bit.rshift(hex, 8), 0xff)
  local b = bit.band(hex, 0xff)
  return utils.rawToColor(r, g, b, a)
end

return utils
