module("components", package.seeall)


function collisionBox(x, y, width, height)
  local component = {
    x = x,
    y = y,
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
