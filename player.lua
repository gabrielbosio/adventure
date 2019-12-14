module("Player", package.seeall)


function Player:new(x, y, animation)
  local object = setmetatable({}, self)
  self.__index = self
  self.x = x
  self.y = y
  self.animation = animation

  return object
end


function Player:update(dt)
  self.animation:update(dt)
end


function Player:draw()
  self.animation:draw(self.x, self.y)
end
