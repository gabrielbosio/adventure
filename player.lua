module("Player", package.seeall)


function Player:new(x, y, animation)
  local object = setmetatable({}, self)
  self.__index = self
  self.x = x
  self.y = y
  self.speed = 100
  self.stepDistance = 20
  self.isWalking = false
  self.walkingDistanceLeft = 0
  self.animation = animation

  return object
end


function Player:walk(numberOfSteps)
  assert(numberOfSteps > 0, "Player cannot walk " .. numberOfSteps .. " steps.")
  self.isWalking = true
  self.walkingDistanceLeft = numberOfSteps * self.stepDistance
end


function Player:update(dt)
  self.animation:update(dt)

  if self.isWalking then
    self.x = self.x + self.speed * dt
    self.walkingDistanceLeft = self.walkingDistanceLeft - 1

    if self.walkingDistanceLeft == 0 then
      self.isWalking = false
    end
  end
end


function Player:draw()
  self.animation:draw(self.x, self.y)
end
