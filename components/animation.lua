require("box")
module("animation", package.seeall)
dofile("resources/sprites.lua")


-- Constants
scale = 0.5


-- Animation Clip
local function createAnimationsTable(animations, spriteSheet)
  local animationsTable = {}

  for animationName, animation in pairs(animations) do
    animationsTable[animationName] = {
      frames = {},
      looping = animation[2]
    }
    local newAnimation = animationsTable[animationName]

    for _, frame in ipairs(animation[1]) do
      local x, y, width, height, originX, originY = unpack(sprites[frame[1]])
      local attackBox = frame[3]

      newAnimation.frames[#newAnimation.frames + 1] = {
        quad = love.graphics.newQuad(x, y, width, height, spriteSheet:getDimensions()),
        origin = {x = -originX*scale, y = -originY*scale},
        duration = frame[2],
        attackBox = attackBox and box.AttackBox:new{
          x = attackBox[1]*scale,
          y = attackBox[2]*scale,
          width = attackBox[3]*scale,
          height = attackBox[4]*scale
        }
      }
    end

    function newAnimation:duration()
      local result = 0
      for _, frame in ipairs(self.frames) do
        result = result + frame.duration
      end
      return result
    end
  end

  return animationsTable
end

function AnimationClip(animations, nameOfCurrentAnimation, spriteSheet)
  local newComponent = {
    animations = createAnimationsTable(animations, spriteSheet),
    nameOfCurrentAnimation = nameOfCurrentAnimation,
    currentTime = 0,
    facingRight = true,
    playing = true,
    done = false
  }

  function newComponent:currentFrameNumber()
    local timeSpent = 0
    local currentAnimation = self.animations[self.nameOfCurrentAnimation]
    for frameNumber, frame in ipairs(currentAnimation.frames) do
      timeSpent = timeSpent + frame.duration
      if timeSpent > self.currentTime then
        return frameNumber
      end
    end
    return #currentAnimation.frames
  end

  function newComponent:setAnimation(animationName)
    if self.animations[animationName] ~= nil
        and self.nameOfCurrentAnimation ~= animationName then
      self.nameOfCurrentAnimation = animationName
      self.currentTime = 0
      self.playing = true
      self.done = false
    end
  end

  return newComponent
end


