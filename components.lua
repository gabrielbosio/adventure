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


function assertComponentsDependency(componentsTable, dependentComponentName,
                                    ...)
  if componentsTable[dependentComponentName] ~= nil then
    for i, nameToAssert in ipairs{...} do
      if componentsTable[nameToAssert] == nil then
        error([[Unsatisfied dependency:
          there is at least one]] .. dependentComponentName ..
          " component but no" .. nameToAssert .. " component was found.")
      end
    end
  end
end


function assertComponentsExistence(entity, existingComponentName, ...)
  for i, pairToAssert in ipairs{...} do
    componentToAssert, nameToAssert = pairToAssert[1], pairToAssert[2]
    assert(componentToAssert ~= nil,
            "Entity " .. entity .. " has " .. existingComponentName ..
            " component but has not " .. nameToAssert .. " component")
  end
end
