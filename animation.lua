module("Animation", package.seeall)


local function createQuads(spriteSheet, width, height, frames)
  local quadsInSpriteSheet = {}
  local animationQuads = {}
  local frameNumber = 1

  for y = 1, spriteSheet:getHeight() - 1, height + 2 do
    for x = 1, spriteSheet:getWidth() - 1, width + 2 do
      local isFrameInAnimation = false

      for _, animationFrame in ipairs(frames) do
        if animationFrame == frameNumber then
          isFrameInAnimation = true
        end
      end

      if isFrameInAnimation then
        newQuad = love.graphics.newQuad(x, y, width, height, spriteSheet:getDimensions())
        quadsInSpriteSheet[frameNumber] = newQuad
      end

      frameNumber = frameNumber + 1
    end
  end

  for i, frame in ipairs(frames) do
    animationQuads[i] = quadsInSpriteSheet[frame]
  end

  return animationQuads
end

-- Creates a new animation using a spriteSheet. Duration is 1 if not specified.
function Animation:new(spriteSheet, width, height, frames, duration)
  local object = setmetatable({}, self)
  self.__index = self
  object.spriteSheet = spriteSheet
  object.frames = frames
  object.duration = duration or 1
  object.currentTime = 0
  object.quads = createQuads(spriteSheet, width, height, frames)

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
