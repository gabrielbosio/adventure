module("Timeline", package.seeall)

require("keyframe")


function Timeline:new()
  local object = setmetatable({}, self)
  self.__index = self
  self.time = 0
  self.keyFramesLeft = {}

  return object
end


function Timeline:addKeyFrame(time, event)
  table.insert(self.keyFramesLeft, KeyFrame:new(time, event))
end


function Timeline:update(dt)

  for i = #self.keyFramesLeft, 1, -1 do
    local keyFrame = self.keyFramesLeft[i]

    if self.time >= keyFrame.time then
      keyFrame.event()
      self.keyFramesLeft[i] = nil
    end
  end

  self.time = self.time + dt
end
