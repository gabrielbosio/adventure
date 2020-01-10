module("components", package.seeall)


function collisionBox(x, y, width, height)
  return {
    x = x,
    y = y,
    width = width,
    height = height,
    vx = 0,
    vy = 0,
    onSlope = false,
    slopeX = 0
  }
end
