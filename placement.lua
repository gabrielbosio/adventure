module("placement", package.seeall)


-- Place center of text on x, y unless a different anchor (n, w, s) is given.
-- Anchors are defined by the moveBy table, see below.
function place(text, x, y, anchor, font)
	local anchor = anchor or "center"  -- "center" anchor by default

	local font = font or love.graphics.getFont()

	-- Calls the coordinate transformation depending on the anchor
	local newX, newY = moveBy[anchor](x, y, font:getWidth(text),
					  font:getHeight(text))

	love.graphics.print(text, newX, newY)
end


-- Assigns anchor names to functions 
local moveBy = {
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
