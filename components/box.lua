--[[--
 Boxes that have geometry and some other properties.

 Contains a base `Box` class and its subclasses.
 The box objects relate to several components that appear on the game, such as
 collision and item boxes.
]]
local M = {}


--[[--
 Base class.

 @tfield number x horizontal position coordinate
 @tfield number y vertical position coordinate
 @field new Constructor prototype.

  `x`, `y`, `width`, `height`, as well as custom properties, may be specified when using
  this method to create a subclass or to create objects from that subclass.
 @field left return left horizontal coordinate of the box
 @field right return right horizontal coordinate of the box
 @field top return top vertical coordinate of the box
 @field bottom return bottom vertical coordinate of the box
 @field center return central vertical coordinate of the box
 @field intersects return true when intersecting the given box, false otherwise
 @field translated static method.
  It should be called from the subclass in order to create an extended, custom
  `translated` method for the subclass.


 @usage
  MySpecialBox = Box:new{
    width = 5,
    height = 8,
    myCoolField = "default value"
  }

  mySpecialInstance = MySpecialBox:new{
    x = 374,
    y = 219,
    myCoolField = "yowsup"
  }

  print(mySpecialInstance:center())  --> 215


  BoxWithOffset = Box:new{
    translated = function(self, position, offset)
      local box = Box.translated(self, position)
      box.x = box.x + offset.x
      box.y = box.y + offset.y

      return box
    end
  }
]]
M.Box = {
  x = 0,
  y = 0,

  width = nil,
  height = nil,

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

---  A box with an `effectAmount`.
-- @table ItemBox
M.ItemBox = M.Box:new{
  width = 10,
  height = 10,

  effectAmount = 0,
}

--[[--
 A box with a `nextLevel` and a `translated` method, extended from its superclass.

 @table GoalBox
 @field nextLevel name of the next level.
  It must be a field of the `levels` table, which is defined in `levels.lua`.
 @field translated return a translated copy of the box
]]
M.GoalBox = M.Box:new{
  nextLevel = nil,  -- constructor argument

  width = 100,
  height = 100,

  -- Extended method
  translated = function (self, position)
    return M.Box.translated(self, position)
  end,
}

--[[--
 A box that interacts with the level terrain.

 @table CollisionBox
 @tfield number slopeId an unique number for the slope this box is on.

  This number is used by the `systems.terrain` module to let the box pass through
  a boundary, given that the box is coming from an adjacent slope.
 @tfield bool reactingWithClouds whether this box lands on clouds or pass
  through them.
]]
M.CollisionBox = M.Box:new{
  slopeId = nil,
  reactingWithClouds = true
}


--[[--
 A box with a custom `translated` method that depends on an `animationClip`.

 @table AttackBox
]]
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
