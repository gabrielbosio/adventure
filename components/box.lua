local M = {}


-- Abstract class
M.Box = {
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
    if position then
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
M.ItemBox = M.Box:new{
  width = 10,
  height = 10,

  effectAmount = 0,
}

M.GoalBox = M.Box:new{
  nextLevel = nil,  -- constructor argument

  width = 100,
  height = 100,

  -- Extended method
  translated = function (self, position)
    return M.Box.translated(self, position)
  end,
}

M.CollisionBox = M.Box:new{
  slopeId = nil,
  reactingWithClouds = true
}

M.AttackBox = M.Box:new{
  -- Extended method
  translated = function (self, position, animationClip)
    local currentAnimation = animationClip.animations[animationClip.nameOfCurrentAnimation]
    local currentFrame = currentAnimation.frames[animationClip:currentFrameNumber()]
    local frameAttackBox = currentFrame.attackBox
    local offsetX = (animationClip.facingRight and 1 or -1)* frameAttackBox.x
    local box = M.Box.translated(self, position)
    box.x = box.x + offsetX
    box.y = box.y + frameAttackBox.y

    return box
  end,
}

return M
