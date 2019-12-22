module("Enemy", package.seeall)


local function createAnimationPlayer(self, particleSystem)
  local spriteSheet = love.graphics.newImage("sprites/enemy.png")
  local standingAnimation = Animation:new(spriteSheet, 256, 256, {1})
  local walkingAnimation = Animation:new(spriteSheet, 256, 256, {2, 4, 5, 4}, 0.3)
  local attackingAnimation = Animation:new(spriteSheet, 256, 256, {3, 6, 6, 7, 1, -1}, 0.2)
  local animationPlayer = AnimationPlayer:new()
  
  walkingAnimation:addKeyFrames({1, 3}, function ()
    local dustX = self.x - 8 * (self.isFacingRight and 1 or -1)
    particleSystem:createDust(dustX, self.y - 12)
  end)

  attackingAnimation:addKeyFrames({6}, function ()
    self.attackBox = {0, -192, 128, -128}
  end)
  attackingAnimation:addKeyFrames({8}, function ()
    self.attackBox = nil
  end)

  animationPlayer:addAnimation("standing", standingAnimation)
  animationPlayer:addAnimation("walking", walkingAnimation)
  animationPlayer:addAnimation("attacking", attackingAnimation)

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
  object.isAttacking = false
  object.attackingTime = 0
  object.isFacingRight = true
  object.walkingDistanceLeft = 0
  object.animationPlayer = createAnimationPlayer(object, particleSystem)
  object.hitBox = {-48, -224, 48, 0}

  return object
end


function Enemy:walk(numberOfSteps, isWalkingRight)
  assert(numberOfSteps > 0, "Enemy cannot walk " .. numberOfSteps .. " steps.")
  self.isWalking = true
  self.isFacingRight = isWalkingRight
  self.walkingDistanceLeft = numberOfSteps * self.stepDistance
end


function Enemy:attack()
  self.isAttacking = true
  self.attackingTime = 2
end


function Enemy:attackBoxInOrigin()
  local attackBoxInOrigin = nil

  if self.attackBox ~= nil then
    attackBoxInOrigin = {self.x + self.attackBox[1], self.y + self.attackBox[2],
                         self.x + self.attackBox[3], self.y + self.attackBox[4]}
  end

  return attackBoxInOrigin
end


function Enemy:update(dt)
  self.animationPlayer:update(dt)

  if self.isAttacking then
    self.animationPlayer:setAnimation("attacking")
    self.attackingTime = self.attackingTime - dt

    if self.attackingTime <= 0 then
      self.isAttacking = false
    end

  elseif self.isWalking then
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
