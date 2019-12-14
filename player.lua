require("class")

local Player = class.declare()


function Player.new(x, y, animation)
  local self = setmetatable({}, Player)
  self.x = x
  self.y = y
  self.animation = animation

  print(self.animation)
  return self
end


function Player:update(dt)
  self.animation:update(dt)
end


function Player:draw()
  self.animation:draw(self.x, self.y)
end

return Player
