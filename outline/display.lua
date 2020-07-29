--- Utility for debugging that displays text on screen.
local place = require "place"

local M = {}


local addedCount = 0
local textList = {}

--[[--
 Add text to display on screen.

 @param id an object, preferably a string, that should not be repeated
 @param textFunction it must return a string from the given `args`
 @param args `textFunction` will be called with this argument, it may be anything
 @param red float between 0 and 1
 @param green float between 0 and 1
 @param blue float between 0 and 1

 @usage
  display.add(  -- Add mouse position to the display
    "mouse",
    function ()
      return love.mouse.getX() .. ", " .. love.mouse.getY()
    end,
    nil,  -- args is nil because textFunction has no arguments in this case
    1, 1, 1
  )
  display.add(  -- Add virtual camera position
    "vcam",
    function (position)
      return math.floor(position.x) .. "," .. math.floor(position.y)
    end,
    componentsTable.positions.vcam,  -- table with two fields, x and y, which are used by the textFunction
    0.556863, 0.333333, 0.556863
  )
]]
function M.add(id, textFunction, args, red, green, blue)
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

return M
