module("components", package.seeall)


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


function animationClip(animations, currentAnimation)
  return {
    animations = animations,
    currentAnimation = currentAnimation,
    playing = true
  }
end


function assertDependency(componentsTable, dependentComponentName,
                                    ...)
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
