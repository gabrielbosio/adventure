require("place")

module("display", package.seeall)


local addedCount = 0
local textList = {}

--- Add text to display on screen
-- @param id a string that should not be repeated
-- @param textFunction it must return a string from args
-- @args textFunction will be called with this argument, it may be anything
-- @red float between 0 and 1
-- @green float between 0 and 1
-- @blue float between 0 and 1
function add(id, textFunction, args, red, green, blue)
  local i = textList[id]
  if i then
    love.graphics.setColor(red, green, blue)
    local text = id .. ": " .. textFunction(args)
    local height = love.graphics.getFont():getHeight(text)
    place.textByAnchor(text, 0, height*i, "nw")
  else
    textList[id] = addedCount
    addedCount = addedCount + 1
  end
end
