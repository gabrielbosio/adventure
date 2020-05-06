module("components", package.seeall)
dofile("resources/sprites.lua")

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


-- Abstract class
Box = {
  x = 0,
  y = 0,

  -- Constructor arguments
  width = nil,
  height = nil,

  -- Constructor
  new = function (self, o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    return o
  end,

  -- Object methods
  left = function (self)
    return self.x - self.width/2
  end,
  right = function (self)
    return self.x + self.width/2
  end,
	top = function (self)
    return self.y - self.height
  end,
	bottom = function (self)
    return self.y
  end,
	center = function (self)
    return self.y - self.height/2
  end,
	intersects = function (self, box)
    return self:left() <= box:right() and self:right() >= box:left()
      and self:top() <= box:bottom() and self:bottom() >= box:top()
  end,


  -- Static method
  translated = function (o, position) 
    if position ~= nil then
      x, y = position.x, position.y
    else
      x, y = 0, 0
    end

    local attributes = {}
    for k, v in pairs(o) do
      attributes[k] = v
    end
    attributes.x = x
    attributes.y = y

    return o:new(attributes)
  end,
}

-- Inherited classes
ItemBox = Box:new{
  width = 10,
  height = 10,

  effectAmount = 0,
}
GoalBox = Box:new{
  nextLevel = nil,  -- constructor argument

  width = 100,
  height = 100,

  -- Extended method
  translated = function (self, position, nextLevel)
    local box = Box.translated(self, position)
    box.nextLevel = nextLevel

    return box
  end,
}
CollisionBox = Box:new{
  slopeId = nil,
  reactingWithClouds = true,

  -- Extended method
  translated = function (self, position)
    return Box.translated(self, position)
  end,
}


function FiniteStateMachine(currentState)
  local newComponent = {
    currentState = currentState,
    stateTime = 0
  }

  function newComponent:setState(newState, time)
    self.currentState = newState
    self.stateTime = time or 0
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
