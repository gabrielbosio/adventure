module("class", package.seeall)

function class.declare()  
  local Class = setmetatable({}, {
    __call = function (class, ...) return class.new (...) end
  })

  Class.__index = Class

  return Class
end
