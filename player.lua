module("Player", package.seeall)


function Player:new(x, y, animationPlayer)
  local object = setmetatable({}, self)
  self.__index = self
  object.x = x
  object.y = y
  object.speed = 100
  object.stepDistance = 20
  object.isWalking = false
  object.isFacingRight = true
  object.walkingDistanceLeft = 0
  object.animationPlayer = animationPlayer

  return object
end


function Player:walk(numberOfSteps, isWalkingRight)
  assert(numberOfSteps > 0, "Player cannot walk " .. numberOfSteps .. " steps.")
  self.isWalking = true
  self.isFacingRight = isWalkingRight
  self.walkingDistanceLeft = numberOfSteps * self.stepDistance
end


function Player:update(dt)
  self.animationPlayer:update(dt)

  if self.isWalking then
    local directionFactor = self.isFacingRight and 1 or -1
    self.x = self.x + self.speed * directionFactor * dt
    self.walkingDistanceLeft = self.walkingDistanceLeft - 1
    self.animationPlayer:setAnimation("walking")

    if self.walkingDistanceLeft == 0 then
      self.isWalking = false
    end

  else
    self.animationPlayer:setAnimation("standing")
  end
end


function Player:draw()
  self.animationPlayer:draw(self.x, self.y, self.isFacingRight)
end
