require("place")

-- I could not name this module "debug" because there is already a library 
-- named "debug" in lua. 
module("outline", package.seeall)


-- Start of subroutines

local function drawBox(corners)
  love.graphics.polygon("fill", corners.x1, corners.y1, corners.x2, corners.y1,
                        corners.x2, corners.y2, corners.x1, corners.y2)
end

local function drawRightTriangle(corners)
  -- Horizontal side drawn first
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
    local slope = slopes[i]
    drawRightTriangle{x1 = slope[1], y1 = slope[2], x2 = slope[3],
                      y2 = slope[4]}
  end
end

local function drawCollisionBoxes(positions, boxes)

  for entity, box in pairs(boxes) do
    local position = positions[entity]
    -- Box
    love.graphics.setColor(0, 0, 1)
    love.graphics.rectangle("fill", position.x + box:left(),
      position.y + box:top(), box.width, box.height)

    -- Origin
    love.graphics.setColor(1, 1, 0)
    love.graphics.circle("fill", position.x, position.y, 2)
  end
end

local function drawGoals(goals, positions)
  love.graphics.setColor(0.5, 1, 0.5)

  for goal, goalBox in pairs(goals) do
    local position = positions[goal]
    local box = goalBox:translated(position)
    love.graphics.rectangle("fill", box:left(), box:top(), box.width,
                            box.height)
  end
end

local function drawMedkits(medkits, positions)
  love.graphics.setColor(1, 0, 0)

  for medkit, itemBox in pairs(medkits) do
    local position = positions[medkit]
    local width, height = itemBox.width, itemBox.height
    love.graphics.rectangle("fill", position.x-width/2, position.y-height,
    						width, height)
  end
end

local function drawPomodori(pomodori, positions)
  love.graphics.setColor(0.5, 0.5, 0.5)

  for pomodoro, itemBox in pairs(pomodori) do
    local position = positions[pomodoro]
    local width, height = itemBox.width, itemBox.height
    love.graphics.rectangle("fill", position.x-width/2, position.y-height,
    						width, height)
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

local function displayPlayerStamina(value)
  love.graphics.setColor(0, 1, 0)

  place.textByAnchor(tostring(value), 0,
                     4*love.graphics.getFont():getHeight(text), "north west")
end


-- End of subroutines


function draw(componentsTable, terrain)
  local r, g, b = love.graphics.getColor()

  local translated
  for entity, camera in pairs(componentsTable.cameras) do  -- BEAUTIFY THIS
    local position = componentsTable.positions[entity]
    components.assertExistence(entity, "camera", {position, "position"})

    -- Translate boundaries
    translated = {}
    for i, boundary in ipairs(terrain.boundaries or {}) do
      table.insert(translated, {
        boundary[1] - position.x, boundary[2] + position.y,
        boundary[3] - position.x, boundary[4] + position.y 
      })
    end
    drawBoundaries(translated)

    -- Translate clouds
    translated = {}
    for i, cloud in ipairs(terrain.clouds or {}) do
      table.insert(translated, {
        cloud[1] - position.x, cloud[2] + position.y,
        cloud[3] - position.x
      })
    end
    drawClouds(translated)

    -- Translate slopes
    translated = {}
    for i, slope in ipairs(terrain.slopes or {}) do
      table.insert(translated, {
        slope[1] - position.x, slope[2] + position.y,
        slope[3] - position.x, slope[4] + position.y 
      })
    end
    drawSlopes(translated)

    -- Translate boxes
    translated = {}
    for otherEntity, otherPosition in pairs(componentsTable.positions) do
      if (otherEntity ~= entity) then
        translated[otherEntity] = {
          x = otherPosition.x - position.x,
          y = otherPosition.y + position.y
        }
      end
    end
    drawGoals(componentsTable.goals, translated)
    drawCollisionBoxes(translated, componentsTable.collisionBoxes)
    drawMedkits(componentsTable.healing, translated)
    drawPomodori(componentsTable.experienceEffect, translated)
  end

  -- Reset drawing color
  love.graphics.setColor(r, g, b)
end


function debug(componentsTable)
  local r, g, b = love.graphics.getColor()

  displayPlayerPosition(componentsTable.positions.megasapi)
  displayMouseCoordinates()
  displayPlayerHealth(componentsTable.living.megasapi.health)
  displayPlayerExperience(componentsTable.players.megasapi.experience)
  displayPlayerStamina(componentsTable.living.megasapi.stamina)
  
  love.graphics.setColor(r, g, b)
end
