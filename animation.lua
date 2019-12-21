module("Animation", package.seeall)

require("place")
require("timeline")


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

-- If last frame is negative, sets loop flag and removes last frame.
local function checkIfLoops(self)
  if self.frames[#self.frames] < 0 then
    self.loop = false
    self.frames[#self.frames] = nil
  else
    self.loop = true
  end
end

-- Creates a new animation using a spriteSheet. Duration is 1 if not specified.
function Animation:new(spriteSheet, width, height, frames, duration)
  local object = setmetatable({}, self)
  self.__index = self
  object.spriteSheet = spriteSheet
  object.frames = frames
  object.duration = duration or 1
  object.currentTime = 0
  
  checkIfLoops(object)

  object.quads = createQuads(spriteSheet, width, height, frames)
  object.currentQuad = object.quads[1]
  object.timeline = Timeline:new()

  return object
end


function Animation:addKeyFrames(frames, event)
  for _, frame in ipairs(frames) do
    self.timeline:addKeyFrame(frame / #self.frames * self.duration, event)
  end
end

-- Updates the current time of the animation
function Animation:update(dt)
  self.timeline:update(dt)
  local quadNumber = math.floor(self.currentTime / self.duration * #self.quads) + 1
  self.currentQuad = self.quads[quadNumber]
  
  if self.currentTime >= self.duration then
    
    if self.loop then
      self.currentTime = self.currentTime - self.duration
      self.currentQuad = self.quads[1]
      self.timeline:play()
    else
      self.currentTime = self.duration - dt
      self.currentQuad = self.quads[#self.quads]
    end
    
  else
    self.currentTime = self.currentTime + dt
  end
end

-- Draws the current frame of the animation
function Animation:draw(x, y, isFacingRight)
  local scaleFactor = 0.5
  local directionFactor = isFacingRight and 1 or -1
  local transform = love.math.newTransform(x, y)
  transform:scale(scaleFactor * directionFactor, scaleFactor)

  place.quadByAnchor(self.spriteSheet, self.currentQuad, transform, "south")
end
