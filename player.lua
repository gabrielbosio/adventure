module("Player", package.seeall)


local function createAnimationPlayer()
  local spriteSheet = love.graphics.newImage("sprites/player.png")
  local standingAnimation = Animation:new(spriteSheet, 192, 256, {1, 2})
  local walkingAnimation = Animation:new(spriteSheet, 192, 256, {3, 4, 5, 4})
  local animationPlayer = AnimationPlayer:new()
  animationPlayer:addAnimation("standing", standingAnimation)
  animationPlayer:addAnimation("walking", walkingAnimation)

  return animationPlayer
end


function Player:new(x, y)
  local object = setmetatable({}, self)
  self.__index = self
  object.x = x
  object.y = y
  object.speed = 100
  object.stepDistance = 20
  object.isWalking = false
  object.isFacingRight = true
  object.walkingDistanceLeft = 0
  object.animationPlayer = createAnimationPlayer()

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
