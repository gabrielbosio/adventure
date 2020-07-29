--- Utilities for camera movement smoothing.
local M = {}


local function difference(vcamPosition, targetPosition)
  local width, height = love.window.getMode()

  return {
    x = vcamPosition.x - targetPosition.x + width/2,
    y = vcamPosition.y + targetPosition.y - height/2
  }
end

--- Move camera to target with infinite speed
-- @param vcamPosition a table reference to the camera position
-- @param targetPosition a table reference to the target position
function M.none(vcamPosition, targetPosition)
  local diff = difference(vcamPosition, targetPosition)

  -- No tweening, just center the target on screen
  vcamPosition.x = vcamPosition.x - diff.x
  vcamPosition.y = vcamPosition.y - diff.y
end

--- Move camera to target with constant finite speed
-- @param vcamPosition a table reference to the camera position
-- @param targetPosition a table reference to the target position
-- @param dt the time delta provided by love.update
-- @param[opt] parameters a table with two keys: multiplier and threshold.
--  Default parameters are `{threshold = 10, multiplier = 500}`.
function M.linear(vcamPosition, targetPosition, dt, parameters)
  local defaultParameters = {
    threshold = 10,
    multiplier = 500
  }
  local parameters = parameters ~= nil or defaultParameters

  local diff = difference(vcamPosition, targetPosition)
  local slope = {
    x = 0,
    y = 0
  }
  if (math.abs(diff.x) > parameters.threshold) then
    slope.x = -diff.x / math.abs(diff.x) * parameters.multiplier
  end
  if (math.abs(diff.y) > parameters.threshold) then
    slope.y = -diff.y / math.abs(diff.y) * parameters.multiplier
  end

  vcamPosition.x = vcamPosition.x + slope.x*dt
  vcamPosition.y = vcamPosition.y + slope.y*dt
end

--- Move camera to target with exponential speed
-- @param vcamPosition a table reference to the camera position
-- @param targetPosition a table reference to the target position
-- @param dt the time delta provided by love.update
-- @param[opt=50] ratio a number greater than 1
function M.exp(vcamPosition, targetPosition, dt, ratio)
  if ratio == nil or ratio <= 1 then
    ratio = 50
  end

  local diff = difference(vcamPosition, targetPosition)

  vcamPosition.x = vcamPosition.x - diff.x + diff.x/(ratio^dt)
  vcamPosition.y = vcamPosition.y - diff.y + diff.y/(ratio^dt)
end

return M
