module("place", package.seeall)


-- Subroutine
local function check(anchor)
  assert(moveBy[anchor] ~= nil, 'moveBy received an invalid anchor ("' ..
    tostring(anchor) .. '")\n\nCheck for typos!')
end


-- Places center of text on x, y unless a different anchor (n, w, s) is given.
-- Anchors are defined by the moveBy table, see below.
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


--[[ Places texture according to the given inputs.

    Inputs:
      Texture texture
      Quad quad
      Transform transform
      string anchor

  Possible anchor values = "north", "east", "south west", "n", "e", "sw", etc.

--]]
function quadByAnchor(texture, quad, transform, anchor)
  -- "center" anchor by default
  local anchor = anchor or "center"

  local __, __, width, height = quad:getViewport()
  local matrix = {transform:getMatrix()}
  local x, y = matrix[4], matrix[8]

  check(anchor)
  local newX, newY = moveBy[anchor](x, y, width, height)

  transform = transform:translate(newX - x, newY - y)

  love.graphics.draw(texture, quad, transform)
end


-- Assigns anchor names to functions 
moveBy = {
  center = function (x, y, w, h) return x - w/2, y - h/2 end,

  north = function (x, y, w, h) return x - w/2, y end,

  east = function (x, y, w, h) return x - w, y - h/2 end,

  south = function (x, y, w, h) return x - w/2, y - h end,

  west = function (x, y, w, h) return x, y - h/2 end,

  ["north east"] = function (x, y, w, h) return x - w, y end,

  ["north west"] = function (x, y, w, h) return x, y end,

  ["south west"] = function (x, y, w, h) return x, y - h end,

  ["south east"] = function (x, y, w, h) return x - w, y - h end
}

-- Declares alias for each anchor
for alias, anchor in pairs{
  c = "center", n = "north", e = "east", s = "south", w = "west",
  nw = "north west", ne = "north east", sw = "south west",
  se = "south east"
} do
  moveBy[alias] = moveBy[anchor]
end
