module("AnimationPlayer", package.seeall)

function AnimationPlayer:new()
  local object = setmetatable({}, self)
  self.__index = self
  object.animations = {}

  return object
end


function AnimationPlayer:addAnimation(name, animation)
  self.animations[name] = animation
  self.currentAnimation = self.currentAnimation or animation
end


function AnimationPlayer:setAnimation(name)
  self.currentAnimation = self.animations[name]
end


function AnimationPlayer:update(dt)
  if self.currentAnimation ~= nil then
    self.currentAnimation:update(dt)
  end
end


function AnimationPlayer:draw(x, y, isFacingRight)
  self.currentAnimation:draw(x, y, isFacingRight)
end
