module("components", package.seeall)
dofile("sprites.lua")


function collisionBox(width, height)
  local component = {
    x = 0,
    y = 0,
    width = width,
    height = height,
    onSlope = false,
    slopeX = 0
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


function animationClip(animations, nameOfCurrentAnimation, spriteSheet)
  local animationsTable = {}

  for animationName, animation in pairs(animations) do
    animationsTable[animationName] = {
      frames = {},
      loop = animation[2]
    }
    local newAnimation = animationsTable[animationName]

    for _, frame in ipairs(animation[1]) do
      local x, y, width, height = unpack(sprites[frame[1]])

      newAnimation.frames[#newAnimation.frames + 1] = {
        quad = love.graphics.newQuad(x, y, width, height, spriteSheet:getDimensions()),
        origin = {x = frame[2][1], y = frame[2][2]},
        duration = frame[3]
      }
    end
  end

  return {
    animations = animationsTable,
    nameOfCurrentAnimation = nameOfCurrentAnimation,
    currentFrameNumber = 1,
    playing = true
  }
end


function assertComponentsDependency(existingComponents, componentsToAssert,
                                    existingComponentName, nameToAssert)
  if existingComponents ~= nil and componentsToAssert == nil then
    error("There are " .. existingComponentName .. " components but no " ..
          nameToAssert .. " components")
  end
end


function assertComponentExistence(componentToAssert, existingComponentName, nameToAssert,
                                  entity)
  assert(componentToAssert ~= nil,
          "Entity " .. entity .. " has " .. existingComponentName ..
          " component but has not " .. nameToAssert .. " component")
end
