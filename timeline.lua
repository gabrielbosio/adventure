module("Timeline", package.seeall)

require("keyframe")


function Timeline:new()
  local object = setmetatable({}, self)
  self.__index = self
  object.time = 0
  object.keyFramesLeft = {}

  return object
end


function Timeline:addKeyFrame(time, event)
  local keyFrame = KeyFrame:new(time, event)
  table.insert(self.keyFramesLeft, keyFrame)
end


function Timeline:update(dt)

  for i = #self.keyFramesLeft, 1, -1 do
    local keyFrame = self.keyFramesLeft[i]

    if self.time >= keyFrame.time then
      keyFrame.event()
      table.remove(self.keyFramesLeft, i)
    end
  end

  self.time = self.time + dt
end
