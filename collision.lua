require("components")
module("collision", package.seeall)


local function checkBottomBoundary(collisionBox, position, velocity, x1, y1, x2, y2, dt)
  if position.x + collisionBox:right() > x1
      and position.x + collisionBox:left() < x2
      and position.y + collisionBox:bottom() + velocity.y*dt > y1
      and position.y + collisionBox:center() < y2 then
    velocity.y = 0
    position.y = y1
  end
end


local function checkTopBoundary(collisionBox, position, velocity, x1, y1, x2, y2, dt)
  if position.x + collisionBox:right() > x1
      and position.x + collisionBox:left() < x2
      and position.y + collisionBox:top() + velocity.y*dt < y2
      and position.y + collisionBox:bottom() > y1 then
    velocity.y = 0
    position.y = y2 + collisionBox.height
  end
end


local function checkLeftBoundary(collisionBox, position, velocity, x1, y1, x2, y2, dt)
  if (position.x + collisionBox:left() + velocity.x*dt < x2
      and position.x + collisionBox:right() > x1
      and position.y + collisionBox:top() < y2
      and position.y + collisionBox:bottom() > y1
      and not collisionBox.onSlope) then
      --[[or (collisionBox.onSlope and collisionBox.x + velocity.x*dt < x2
      and collisionBox.x > x1
      and collisionBox:top() < y2 and collisionBox:bottom() > y1) then]]
    velocity.x = 0
    position.x = x2 + collisionBox.width/2
  end
end


local function checkRightBoundary(collisionBox, position, velocity, x1, y1, x2, y2, dt)
  if position.x + collisionBox:right() + velocity.x*dt > x1
      and position.x + collisionBox:left() < x2
      and position.y + collisionBox:top() < y2
      and position.y + collisionBox:bottom() > y1 
      and not collisionBox.onSlope then
    velocity.x = 0
    position.x = x1 - collisionBox.width/2
  end
end

-- Right angle side (acts like a wall)
local function checkRightAngleSideSlope(collisionBox, position, velocity, x1, x2, yTop, yBottom, dt)
  if position.y + collisionBox:bottom() > yTop
      and position.y + collisionBox:top() < yBottom then
    
    if x1 > x2 and position.x + collisionBox:right() <= x2
        and position.x + collisionBox:right() + velocity.x*dt > x2 then
      velocity.x = 0
      position.x = x2 - collisionBox.width/2
    
    elseif x1 < x2 and position.x + collisionBox:left() >= x2
        and position.x + collisionBox:left() + velocity.x*dt < x2 then
      velocity.x = 0
      position.x = x2 + collisionBox.width/2
    end
  end
end

-- Sharp corner (acts like a wall)
local function checkSharpCornerSlope(collisionBox, position, velocity, x1, y1, x2, y2, dt)
  if x1 > x2 and position.x + collisionBox:right() > x1
      and position.x + collisionBox:left() + velocity.x*dt < x1 then
    
    if (y1 > y2 and position.y + collisionBox:bottom() > y1
        and position.y + collisionBox:top() < y1) or (y1 < y2
        and position.y + collisionBox:bottom() > y1
        and position.y + collisionBox:top() < y1) then
      velocity.x = 0
      position.x = x1 + collisionBox.width/2
    end

  elseif x1 < x2 and position.x + collisionBox:left() < x1
      and position.x + collisionBox:right() + velocity.x*dt > x1 then
    
    if (y1 > y2 and position.y + collisionBox:bottom() > y1
        and position.y + collisionBox:top() < y1) or (y1 < y2
        and position.y + collisionBox:bottom() > y1
        and position.y + collisionBox:top() < y1) then
      velocity.x = 0
      position.x = x1 - collisionBox.width/2
    end
  end
end

-- Ceiling (leaning)
local function checkCeilingOfTopSlope(collisionBox, position, velocity, m, x1, y1, x2, y2, dt)
  if position.y + collisionBox:top() >= y1
      and position.y + collisionBox:top() <= y2 then
    collisionBox.slopeX = x1 + (position.y + collisionBox:top() - y1)/m

    if x1 > x2 and position.x + collisionBox:left() >= collisionBox.slopeX
        and position.x + collisionBox:left() + velocity.x*dt < collisionBox.slopeX
        then
      velocity.x = 0
      position.x = collisionBox.slopeX + collisionBox.width/2
    elseif x1 < x2 and position.x + collisionBox:right() <= collisionBox.slopeX
        and position.x + collisionBox:right() + velocity.x*dt > collisionBox.slopeX
        then
      velocity.x = 0
      position.x = collisionBox.slopeX - collisionBox.width/2
    end
  end

  local slopeY = y1 + m*(collisionBox.x-x1)

  if position.y + collisionBox:top() >= slopeY
      and position.y + collisionBox:top() + velocity.y*dt < slopeY
      then
    velocity.y = 0
    position.y = slopeY + collisionBox.height
  end
end

-- Floor (flat)
local function checkFloorOfTopSlope(collisionBox, position, velocity, y1, dt)
  if position.y + collisionBox:bottom() + velocity.y*dt > y1
      and position.y + collisionBox:bottom() <= y1 then
    velocity.y = 0
    position.y = y1
  end
end

-- Ceiling (flat)
local function checkCeilingOfBottomSlope(collisionBox, position, velocity, y1, dt)
  if velocity.y < 0 and position.y + collisionBox:top() >= y1
      and position.y + collisionBox:top() + velocity.y*dt < y1 then
    velocity.y = 0
    position.y = y1 + collisionBox.height
  end
end

-- Floor (leaning)
local function checkFloorOfBottomSlope(collisionBox, position, velocity, m, x1, y1, x2, y2, dt)
  local slopeY = y1 + m*(position.x + collisionBox.x - x1)

  if position.y + collisionBox:bottom() <= math.max(y2, slopeY)
      and position.y + collisionBox:bottom() + velocity.y*dt > math.max(y2, slopeY) then
    velocity.y = 0

    -- Prevent floating character at slope corner
    if (position.x + collisionBox.x - x1)*(position.x + collisionBox.x - x2) < 0 then
      position.y = slopeY
    else
      position.y = y2
    end
  end

  if position.y + collisionBox:bottom() <= y1 and position.y + collisionBox:bottom() > math.max(y2, slopeY)
      and ((x1 > x2 and position.x + collisionBox:left() <= x1
      and position.x + collisionBox:right() >= x2)
      or (x1 < x2 and position.x + collisionBox:right() >= x1
      and position.x + collisionBox:left() <= x2)) then
    velocity.y = 0
    position.y = slopeY
    collisionBox.onSlope = true
  end
end


local function checkBoundaries(collisionBox, position, velocity, terrain, dt)
  for i in pairs(terrain.boundaries) do
    local boundaries = terrain.boundaries[i]
    local x1 = math.min(boundaries[1], boundaries[3])
    local y1 = math.min(boundaries[2], boundaries[4])
    local x2 = math.max(boundaries[1], boundaries[3])
    local y2 = math.max(boundaries[2], boundaries[4])

    checkBottomBoundary(collisionBox, position, velocity, x1, y1, x2, y2, dt)
    checkTopBoundary(collisionBox, position, velocity, x1, y1, x2, y2, dt)
    checkLeftBoundary(collisionBox, position, velocity, x1, y1, x2, y2, dt)
    checkRightBoundary(collisionBox, position, velocity, x1, y1, x2, y2, dt)
  end
end


local function checkSlopes(collisionBox, position, velocity, terrain, dt)
  collisionBox.onSlope = false

  for i in pairs(terrain.slopes or {}) do
    local x1, y1, x2, y2 = unpack(terrain.slopes[i])
    local yTop, yBottom = math.min(y1, y2), math.max(y1, y2)

    checkRightAngleSideSlope(collisionBox, position, velocity, x1, x2, yTop, yBottom, dt)
    checkSharpCornerSlope(collisionBox, position, velocity, x1, y1, x2, y2, dt)

    -- Top and bottom
    if position.x + collisionBox:right() > math.min(x1, x2)
        and position.x + collisionBox:left() < math.max(x1, x2) then
      local m = (y2-y1) / (x2-x1)

      if y1 < y2 then
        checkCeilingOfTopSlope(collisionBox, position, velocity, m, x1, y1, x2, y2, dt)
        checkFloorOfTopSlope(collisionBox, position, velocity, y1, dt)
      else
        checkCeilingOfBottomSlope(collisionBox, position, velocity, y1, dt)
        checkFloorOfBottomSlope(collisionBox, position, velocity, m, x1, y1, x2, y2, dt)
      end
    end
  end 
end


local function checkClouds(collisionBox, position, velocity, terrain, dt)
  for i in pairs(terrain.clouds or {}) do
    local clouds = terrain.clouds[i]
    local x1 = math.min(clouds[1], clouds[3])
    local y1 = clouds[2]
    local x2 = math.max(clouds[1], clouds[3])

    if position.x + collisionBox:right() > x1
        and position.x + collisionBox:left() < x2
        and position.y + collisionBox:bottom() + velocity.y*dt > y1
        and position.y + collisionBox:bottom() <= y1
        and velocity.y > 0 then
      velocity.y = 0
      position.y = y1
    end
  end
end


function terrain(componentsTable, terrain, dt)
  -- solid depends on collisionBox, position and velocity
  components.assertDependency(componentsTable, "solids", "collisionBoxes",
                              "positions", "velocities")

  for entity, solidComponent in pairs(componentsTable.solids or {}) do
    local collisionBox = componentsTable.collisionBoxes[entity]
    local position = componentsTable.positions[entity]
    local velocity = componentsTable.velocities[entity]
    components.assertExistence(entity, "solid", {collisionBox, "collisionBox"},
                               {position, "position"}, {velocity, "velocity"})

    checkBoundaries(collisionBox, position, velocity, terrain, dt)
    checkSlopes(collisionBox, position, velocity, terrain, dt)
    checkClouds(collisionBox, position, velocity, terrain, dt)
  end
end


function playerTouchingEntity(playerPosition, playerCollisionBox)
end


function goal(componentsTable, currentLevel)
  local nextLevel = currentLevel

  for entity, player in pairs(componentsTable.players or {}) do
    local collector = componentsTable.collectors[entity]

    if collector ~= nil then
      local position = componentsTable.positions[entity]
      local velocity = componentsTable.velocities[entity]
      local collisionBox = componentsTable.collisionBoxes[entity]
      components.assertExistence(entity, "player", {position, "position"},
                                  {collisionBox, "collisionBox"}, {velocity, "velocity"})

      for goalEntity, nextLevelID in pairs(componentsTable.goals or {}) do
        local goalPosition = componentsTable.positions[goalEntity]

        local GOAL_SIZE = 110  -- store this variable somewhere else
        -- (variable repeated in outline.lua)

        if position.x + collisionBox.width/2 >= goalPosition.x - GOAL_SIZE/2
            and position.x - collisionBox.width/2 <= goalPosition.x + GOAL_SIZE/2
            and position.y >= goalPosition.y - GOAL_SIZE
            and position.y - collisionBox.height <= goalPosition.y then
          nextLevel = levels.level[nextLevelID]  -- changes module variable

          -- Player position loading and movement restore
          position.x = nextLevel.entitiesData.player[1]
          position.y = nextLevel.entitiesData.player[2]
          velocity.x = 0
          velocity.y = 0

          -- Reload goals and items
          -- This should actually load ANY entity in the new level
          items.load(componentsTable, nextLevel, "medkits", "pomodori")

          for _id in pairs(componentsTable.goals) do
            componentsTable.positions[_id] = nil
            componentsTable.goals[_id] = nil
          end

          local currentGoals = nextLevel.entitiesData.goals

          if currentGoals ~= nil then
            for goalIndex, goalData in pairs(nextLevel.entitiesData.goals) do
              local id = "goal" .. tostring(goalIndex)
              componentsTable.positions[id] = {x = goalData[1], y = goalData[2]}
              componentsTable.goals[id] = goalData[3]
            end
          end

          break
        end
      end
    end -- for entity, player
  end

  return nextLevel
end
