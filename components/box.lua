module("box", package.seeall)


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
  reactingWithClouds = true
}

AttackBox = Box:new{
  -- Extended method
  translated = function (self, position, animationClip)
    local currentAnimation = animationClip.animations[animationClip.nameOfCurrentAnimation]
    local currentFrame = currentAnimation.frames[animationClip:currentFrameNumber()]
    local frameAttackBox = currentFrame.attackBox
    local offsetX = (animationClip.facingRight and 1 or -1)* frameAttackBox.x
    local box = Box.translated(self, position)
    box.x = box.x + offsetX
    box.y = box.y + frameAttackBox.y

    return box
  end,
}
