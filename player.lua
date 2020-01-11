module("Player", package.seeall)

require("animation")
require("animationplayer")


local function createAnimationPlayer(self, particleSystem)
  local spriteSheet = love.graphics.newImage("sprites/player.png")
  local standingAnimation = Animation:new(spriteSheet, 192, 256, {1, 2, 3, 2})

  local walkingAnimation = Animation:new(spriteSheet, 192, 256, {5, 6, 7, 4, 8, 9, 10, 4},
                                         0.5)
  
  walkingAnimation:addKeyFrames({3, 7}, function ()
    local dustX = self.x - 8 * (self.isFacingRight and 1 or -1)
    particleSystem:createDust(dustX, self.y - 12)
  end)

  local animationPlayer = AnimationPlayer:new()
  animationPlayer:addAnimation("standing", standingAnimation)
  animationPlayer:addAnimation("walking", walkingAnimation)

  return animationPlayer
end


local function isColliding(self, otherAttackBox)
  if otherAttackBox == nil then
    return false
  end

  local hitBoxInOrigin = {self.x + self.hitBox[1], self.y + self.hitBox[2],
                          self.x + self.hitBox[3], self.y + self.hitBox[4]}
  
  return hitBoxInOrigin[1] < otherAttackBox[3] and hitBoxInOrigin[2] < otherAttackBox[4] and
         hitBoxInOrigin[3] > otherAttackBox[1] and hitBoxInOrigin[4] > otherAttackBox[2]
end


function Player:new(x, y, particleSystem)
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
  object.hitBox = {-48, -224, 48, 0}

  return object
end


function Player:setEnemies(enemies)
  assert(type(enemies) == "table", "enemies must be a table")
  self.enemies = enemies
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

  for _, enemy in ipairs(self.enemies) do
    if isColliding(self, enemy:attackBoxInOrigin()) then
      print("Player says: 'OUCH'")
    end
  end
end


function Player:draw()
  self.animationPlayer:draw(self.x, self.y, self.isFacingRight)
end
