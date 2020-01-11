module("components", package.seeall)


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


function animationClip(animations, currentAnimation)
  return {
    animations = animations,
    currentAnimation = currentAnimation,
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
