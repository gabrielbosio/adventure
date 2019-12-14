module("Timeline", package.seeall)

require("keyframe")


function Timeline:new()
  local object = setmetatable({}, self)
  self.__index = self
  object.keyFrames = {}
  object:play()

  return object
end


function Timeline:play()
  self.time = 0
  self.keyFramesPlayed = {}
end


function Timeline:addKeyFrame(time, event)
  local keyFrame = KeyFrame:new(time, event)
  table.insert(self.keyFrames, keyFrame)
end


function Timeline:update(dt)

  for i = #self.keyFrames, 1, -1 do
    local keyFrame = self.keyFrames[i]

    if self.time >= keyFrame.time and self.keyFramesPlayed[i] == nil then
      keyFrame.event()
      self.keyFramesPlayed[i] = keyFrame
    end
  end

  self.time = self.time + dt
end
