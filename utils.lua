local utils = {}

-- time

function utils.time(hour, minute)
  return hour * 60 + minute
end

function utils.timeToString(time)
  local minute = time % 60
  local hour = math.floor(time / 60)
  return ("%02d:%02d"):format(hour, minute)
end

-- color

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

-- block

function utils.toBlockCoords(worldX, worldY)
  return utils.toBlockX(worldX), utils.toBlockY(worldY)
end

function utils.toBlockX(worldX)
  return math.floor(worldX / c.BLOCK_SIZE) + 1
end

function utils.toBlockY(worldY)
  return -math.floor(worldY / c.BLOCK_SIZE)
end

function utils.toWorldCoords(blockX, blockY)
  return utils.toWorldX(blockX), utils.toWorldY(blockY)
end

function utils.toWorldX(blockX)
  return (blockX - 1) * c.BLOCK_SIZE
end

function utils.toWorldY(blockY)
  return -blockY * c.BLOCK_SIZE
end

return utils
