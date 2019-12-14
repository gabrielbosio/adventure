local Animation = setmetatable({}, {
  __call = function (class, ...) return class.new (...) end
})

Animation.__index = Animation
Animation.__call = function (self) return Animation.new(self) end

-- Creates a new animation using a spritesheet
function Animation.new(image, width, height, duration)
	local self = setmetatable({}, Animation)
  self.spriteSheet = image
  self.quads = {}
 
  for y = 1, image:getHeight() - 1, height + 2 do
    for x = 1, image:getWidth() - 1, width + 2 do
      newQuad = love.graphics.newQuad(x, y, width, height, image:getDimensions())
      table.insert(self.quads, newQuad)
    end
  end

  self.duration = duration or 1
  self.currentTime = 0

  return self
end

-- Updates the current time of the animation
function Animation:update(dt)
  self.currentTime = self.currentTime + dt
  
  if self.currentTime >= self.duration then
    self.currentTime = self.currentTime - self.duration
  end
end

-- Draws the current frame of the animation
function Animation:draw()
  local spriteNumber = math.floor(self.currentTime / self.duration * #self.quads) + 1
  love.graphics.draw(self.spriteSheet, self.quads[spriteNumber])
end


return Animation
