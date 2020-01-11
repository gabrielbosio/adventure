-- I could not name this module "debug" because there is already a library 
-- named "debug" in lua. 
require("place")
module("outline", package.seeall)


function drawGoal(position)
  r, g, b = love.graphics.getColor()

  local size = 110
  love.graphics.setColor(1, 0.5, 0.5)
  love.graphics.rectangle("fill", position.x-size/2, position.y-size, size,
                          size)

  love.graphics.setColor(r, g, b)
end

function drawPlayerCollisionBox(position, box)
  r, g, b = love.graphics.getColor()

  love.graphics.setColor(0, 0, 1)
  love.graphics.rectangle("fill", position.x-box.width/2,
                          position.y-box.height, box.width, box.height)

  love.graphics.setColor(r, g, b)
end

function drawPlayerPosition(position, showCoordinates)
  r, g, b = love.graphics.getColor()

  love.graphics.setColor(1, 1, 0)
  love.graphics.circle("fill", position.x, position.y, 2)
  if showCoordinates then
    local text = math.floor(position.x) .. "," .. math.floor(position.y)
    place.textByAnchor(text, 0, love.graphics.getFont():getHeight(text), "nw")
  end

  love.graphics.setColor(r, g, b)
end

function displayMouseCoordinates()
  r, g, b = love.graphics.getColor()

  love.graphics.setColor(1, 1, 1)
  place.textByAnchor(love.mouse.getX() .. ", " .. love.mouse.getY(), 0, 0,
    "north west")

  love.graphics.setColor(r, g, b)
end


local function drawBox(corners)
  love.graphics.polygon("fill", corners.x1, corners.y1, corners.x2, corners.y1,
                        corners.x2, corners.y2, corners.x1, corners.y2)
end

local function drawRightTriangle(corners)
  love.graphics.polygon("fill", corners.x1, corners.y1, corners.x2, corners.y1,
                        corners.x2, corners.y2)
end

function drawTerrainOutline(currentLevel)
  r, g, b = love.graphics.getColor()

  local cloudHeightDisplay = 10
  love.graphics.setColor(0, 0.5, 0)
  for i in pairs(currentLevel.terrain.boundaries) do
    local boundaries = currentLevel.terrain.boundaries[i]
    drawBox{x1 = boundaries[1], y1 = boundaries[2], x2 = boundaries[3],
            y2 = boundaries[4]}
  end

  for i in pairs(currentLevel.terrain.slopes or {}) do
    local slopes = currentLevel.terrain.slopes[i]
    drawRightTriangle{x1 = slopes[1], y1 = slopes[2], x2 = slopes[3],
                      y2 = slopes[4]}
  end

  love.graphics.setColor(0.3, 0.6, 1)
  for i in pairs(currentLevel.terrain.clouds or {}) do
    local clouds = currentLevel.terrain.clouds[i]
    drawBox{x1 = clouds[1], y1 = clouds[2], x2 = clouds[3],
            y2 = clouds[2] + cloudHeightDisplay}
  end

  love.graphics.setColor(r, g, b)
end
