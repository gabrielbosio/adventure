module("KeyFrame", package.seeall)


function KeyFrame:new(time, event)
  local object = setmetatable({}, self)
  self.__index = self
  object.time = time
  object.event = event

  return object
end
