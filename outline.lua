-- I could not name this module "debug" because there is already a library 
-- named "debug" in lua. 
require("place")
module("outline", package.seeall)


-- Start of subroutines

local function drawBox(corners)
  love.graphics.polygon("fill", corners.x1, corners.y1, corners.x2, corners.y1,
                        corners.x2, corners.y2, corners.x1, corners.y2)
end

local function drawRightTriangle(corners)
  love.graphics.polygon("fill", corners.x1, corners.y1, corners.x2, corners.y1,
                        corners.x2, corners.y2)
end

local function drawBoundaries(boundaries)
  love.graphics.setColor(0, 0.3, 0)

  for i in pairs(boundaries or {}) do
    local boundary = boundaries[i]
    drawBox{x1 = boundary[1], y1 = boundary[2], x2 = boundary[3],
            y2 = boundary[4]}
  end
end

local function drawClouds(clouds)
  local cloudHeightDisplay = 10
  love.graphics.setColor(0.3, 0.6, 1)

  for i in pairs(clouds or {}) do
    local cloud = clouds[i]
    drawBox{x1 = cloud[1], y1 = cloud[2], x2 = cloud[3],
            y2 = cloud[2] + cloudHeightDisplay}
  end
end

local function drawSlopes(slopes)
  love.graphics.setColor(0, 0.3, 0)

  for i in pairs(slopes or {}) do
    local slope = currentLevel.terrain.slopes[i]
    drawRightTriangle{x1 = slope[1], y1 = slope[2], x2 = slope[3],
                      y2 = slope[4]}
  end
end

local function drawPlayerCollisionBox(position, box)
  -- Box
  love.graphics.setColor(0, 0, 1)
  love.graphics.rectangle("fill",position.x + box:left(), position.y + box:top(), box.width, box.height)

  -- Origin
  love.graphics.setColor(1, 1, 0)
  love.graphics.circle("fill", position.x, position.y, 2)
end

local function drawGoals(goals, positions)
  local size = 110
  love.graphics.setColor(0.5, 1, 0.5)

  for goal in pairs(goals) do
    local position = positions[goal]
    love.graphics.rectangle("fill", position.x-size/2, position.y-size, size,
                            size)
  end
end

local function drawMedkits(medkits, positions)
  local size = 10
  love.graphics.setColor(1, 0, 0)

  for medkit in pairs(medkits) do
    local position = positions[medkit]
    love.graphics.rectangle("fill", position.x-size/2, position.y-size, size,
                            size)
  end
end

local function drawPomodori(pomodori, positions)
  local size = 10
  love.graphics.setColor(0.5, 0.5, 0.5)

  for pomodoro in pairs(pomodori) do
    local position = positions[pomodoro]
    love.graphics.rectangle("fill", position.x-size/2, position.y-size, size,
                            size)
  end
end

local function displayPlayerPosition(position)
  love.graphics.setColor(1, 1, 0)
  local text = math.floor(position.x) .. "," .. math.floor(position.y)

  place.textByAnchor(text, 0, love.graphics.getFont():getHeight(text), "nw")
end

local function displayMouseCoordinates()
  love.graphics.setColor(1, 1, 1)

  place.textByAnchor(love.mouse.getX() .. ", " .. love.mouse.getY(), 0, 0,
    "north west")
end

local function displayPlayerHealth(value)
  love.graphics.setColor(1, 0, 0)

  place.textByAnchor(tostring(value), 0,
                     2*love.graphics.getFont():getHeight(text), "north west")
end

local function displayPlayerExperience(value)
  love.graphics.setColor(0.5, 0.5, 0.5)

  place.textByAnchor(tostring(value), 0,
                     3*love.graphics.getFont():getHeight(text), "north west")
end


-- End of subroutines


function draw(componentsTable, terrain)
  local r, g, b = love.graphics.getColor()

  -- Shared data
  local positions = componentsTable.positions

  -- Terrain
  drawBoundaries(terrain.boundaries)
  drawClouds(terrain.clouds)
  --drawSlopes(terrain.slopes)

  -- Player
  drawPlayerCollisionBox(positions.megasapi,
                         componentsTable.collisionBoxes.megasapi)

  -- Goals
  drawGoals(componentsTable.goals, positions)

  -- Items
  drawMedkits(componentsTable.healing, positions)
  drawPomodori(componentsTable.experienceEffect, positions)

  -- Reset drawing color
  love.graphics.setColor(r, g, b)
end


function debug(componentsTable)
  local r, g, b = love.graphics.getColor()

  displayPlayerPosition(componentsTable.positions.megasapi)
  displayMouseCoordinates()
  displayPlayerHealth(componentsTable.living.megasapi.health)
  displayPlayerExperience(componentsTable.players.megasapi.experience)
  
  love.graphics.setColor(r, g, b)
end
