module("tweening", package.seeall)


--- Move camera to target with infinite speed
-- @param vcamPosition a table reference to the camera position
-- @param targetPosition a table reference to the target position
function none(vcamPosition, targetPosition)
  local width, height = love.window.getMode()

  -- No tweening, just center the target on screen
  vcamPosition.x = targetPosition.x - width/2
  vcamPosition.y = -targetPosition.y + height/2
end

--- Move camera to target with constant finite speed
-- @param vcamPosition a table reference to the camera position
-- @param targetPosition a table reference to the target position
-- @param dt the time delta provided by love.update
-- @param parameters a table with two keys: multiplier and threshold
function linear(vcamPosition, targetPosition, dt, parameters)
  local width, height = love.window.getMode()
  local diff = {
    x = vcamPosition.x - targetPosition.x + width/2,
    y = vcamPosition.y + targetPosition.y - height/2
  }
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