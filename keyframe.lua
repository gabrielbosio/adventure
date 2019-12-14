module("KeyFrame", package.seeall)


function KeyFrame:new(time, event)
  local object = setmetatable({}, self)
  self.__index = self
  self.time = time
  self.event = event

  return object
end
