module("place", package.seeall)


-- Subroutine
local function check(anchor)
  assert(moveBy[anchor] ~= nil, 'moveBy received an invalid anchor ("' ..
    tostring(anchor) .. '")\n\nCheck for typos!')
end


--- Display text on screen
-- Places center of text on x, y unless a different anchor (n, w, s) is given.
-- Anchors are defined by the moveBy table, see below.
-- @param string text content
-- @param x horizontal coordinate
-- @param y horizontal coordinate
-- @param anchor a string like "north", "east", "north east", "ne", "center"...
--        (default: "center")
function textByAnchor(string, x, y, anchor, font)
  -- "center" anchor by default
  local anchor = anchor or "center"

  assert(type(string) == "string",
      "first argument of function textByAnchor must be string")

  local font = font or love.graphics.getFont()

  -- Calls the coordinate transformation depending on the anchor
  check(anchor)
  local newX, newY = moveBy[anchor](x, y, font:getWidth(string),
            font:getHeight(string))

  love.graphics.print(string, newX, newY)
end

--- Places texture according to the given inputs.
--[[
    Inputs:
      Texture texture
      Quad quad
      Transform transform
      string anchor

  Possible anchor values = "north", "east", "south west", "n", "e", "sw", etc.

  local __, __, width, height = quad:getViewport()
--]]
function quadByAnchor(texture, quad, transform, anchor)
  -- "center" anchor by default
  local anchor = anchor or "center"

  local matrix = {transform:getMatrix()}
  local x, y = matrix[4], matrix[8]

  check(anchor)
  local newX, newY = moveBy[anchor](x, y, width, height)

  transform = transform:translate(newX - x, newY - y)

  love.graphics.draw(texture, quad, transform)
end


--- Table of coordinate transformations
-- Each one of its entries is a different translation.
-- They calculate and return a position based on
--  * the chosen table entry
--  * position coordinates (x, y)
--  * dimensions (width, height)
-- @usage Call any of them using the signature
--  moveBy[anchor](x, y, w, h)
--
-- Examples:
--  moveBy["south east"](20, 35, 250, 137)
--  moveBy["center"](20, 35, 250, 137)
--  moveBy["nw"](20, 35, 250, 137)
moveBy = {
  ["center"] = function (x, y, w, h) return x - w/2, y - h/2 end,
  ["north"] = function (x, y, w, h) return x - w/2, y end,
  ["east"] = function (x, y, w, h) return x - w, y - h/2 end,
  ["south"] = function (x, y, w, h) return x - w/2, y - h end,
  ["west"] = function (x, y, w, h) return x, y - h/2 end,
  ["north east"] = function (x, y, w, h) return x - w, y end,
  ["north west"] = function (x, y, w, h) return x, y end,
  ["south west"] = function (x, y, w, h) return x, y - h end,
  ["south east"] = function (x, y, w, h) return x - w, y - h end
}

-- Declare aliases for each anchor
for anchor, aliases in pairs{
  ["center"] = {"c"},
  ["north"] = {"n"},
  ["east"] = {"e"},
  ["south"] = {"s"},
  ["west"] = {"w"},
  ["north east"] = {"ne", "en"},
  ["north west"] = {"nw", "wn"},
  ["south west"] = {"sw", "ws"},
  ["south east"] = {"se", "es"}
} do
  for i, alias in ipairs(aliases) do
    moveBy[alias] = moveBy[anchor]
  end
end
