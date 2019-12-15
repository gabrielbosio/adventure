module("Enemy", package.seeall)


local function createAnimationPlayer(self, particleSystem)
  local spriteSheet = love.graphics.newImage("sprites/enemy.png")
  local standingAnimation = Animation:new(spriteSheet, 192, 256, {1})
  local walkingAnimation = Animation:new(spriteSheet, 192, 256, {2, 3, 4, 3}, 0.3)
  local animationPlayer = AnimationPlayer:new()
  
  walkingAnimation:addKeyFrames({1, 3}, function ()
    local dustX = self.x - 8 * (self.isFacingRight and 1 or -1)
    particleSystem:createDust(dustX, self.y - 12)
  end)

  animationPlayer:addAnimation("standing", standingAnimation)
  animationPlayer:addAnimation("walking", walkingAnimation)

  return animationPlayer
end

function Enemy:new(x, y, particleSystem)
  local object = setmetatable({}, self)
  self.__index = self
  object.x = x
  object.y = y
  object.speed = 300
  object.stepDistance = 15
  object.isWalking = false
  object.isFacingRight = true
  object.walkingDistanceLeft = 0
  object.animationPlayer = createAnimationPlayer(object, particleSystem)

  return object
end


function Enemy:walk(numberOfSteps, isWalkingRight)
  assert(numberOfSteps > 0, "Enemy cannot walk " .. numberOfSteps .. " steps.")
  self.isWalking = true
  self.isFacingRight = isWalkingRight
  self.walkingDistanceLeft = numberOfSteps * self.stepDistance
end


function Enemy:update(dt)
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



function Enemy:draw()
  self.animationPlayer:draw(self.x, self.y, self.isFacingRight)
end
