module("components", package.seeall)
dofile("sprites.lua")

local function Box(width, height)
  local component = {
    x = 0,
    y = 0,
    width = width,
    height = height
  }

  function component:left()
    return self.x - self.width/2
  end
  
  function component:right()
    return self.x + self.width/2
  end

  function component:top()
    return self.y - self.height
  end
  
  function component:bottom()
    return self.y
  end

  function component:center()
    return self.y - self.height/2
  end

  return component
end

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

      newAnimation.frames[#newAnimation.frames + 1] = {
        quad = love.graphics.newQuad(x, y, width, height, spriteSheet:getDimensions()),
        origin = {x = -originX, y = -originY},
        duration = frame[2]
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


function animationClip(animations, nameOfCurrentAnimation, spriteSheet)
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

function itemBox(width, height)
  local component = Box(width, height)

  return component
end


function collisionBox(width, height)
  local component = Box(width, height)

  component.onSlope = false
  component.slopeX = 0

  return component
end


function finiteStateMachine(currentState)
  local newComponent = {
    currentState = currentState,
    time = 0
  }

  function newComponent:setState(newState, time)
    self.currentState = newState
    self.time = time or 0
  end

  return newComponent
end


function assertDependency(componentsTable, dependentComponentName, ...)
  if componentsTable[dependentComponentName] ~= nil then
    for i, nameToAssert in ipairs{...} do
      if componentsTable[nameToAssert] == nil then
        error([[Unsatisfied dependency in componentsTable.
          There is at least one component inside "]] .. dependentComponentName
          ..  '" but no component inside "' .. nameToAssert .. '".')
      end
    end
  end
end


function assertExistence(entity, existingComponentName, ...)
  for i, pairToAssert in ipairs{...} do
    componentToAssert, nameToAssert = pairToAssert[1], pairToAssert[2]
    assert(componentToAssert ~= nil,
            "Entity " .. entity .. " has " .. existingComponentName ..
            " component but has not " .. nameToAssert .. " component")
  end
end
