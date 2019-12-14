module("Animation", package.seeall)

-- Creates a new animation using a spritesheet. If duration is 1 if not specified.
function Animation:new(spritesheet, width, height, duration)
  local object = setmetatable({}, self)
  self.__index = self
  object.spriteSheet = spritesheet
  object.quads = {}
 
  for y = 1, spritesheet:getHeight() - 1, height + 2 do
    for x = 1, spritesheet:getWidth() - 1, width + 2 do
      newQuad = love.graphics.newQuad(x, y, width, height, spritesheet:getDimensions())
      table.insert(object.quads, newQuad)
    end
  end

  object.duration = duration or 1
  object.currentTime = 0

  return object
end

-- Updates the current time of the animation
function Animation:update(dt)
  self.currentTime = self.currentTime + dt
  
  if self.currentTime >= self.duration then
    self.currentTime = self.currentTime - self.duration
  end
end

-- Draws the current frame of the animation
function Animation:draw(x, y, isFacingRight)
  local spriteNumber = math.floor(self.currentTime / self.duration * #self.quads) + 1
  local currentQuad = self.quads[spriteNumber]
  local scaleFactor = 0.5
  local directionFactor = isFacingRight and 1 or -1
  local _, _, quadViewportWidth = currentQuad:getViewport()
  local offsetX = isFacingRight and 0 or quadViewportWidth / 2
  love.graphics.draw(self.spriteSheet, currentQuad, x + offsetX, y, 0,
                     scaleFactor * directionFactor, scaleFactor)
end
