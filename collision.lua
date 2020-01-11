require("components")
module("collision", package.seeall)


local function checkBottomBoundaryCollision(collisionBox, position, velocity, x1, y1, x2, y2, dt)
  if position.x + collisionBox:right() > x1
      and position.x + collisionBox:left() < x2
      and position.y + collisionBox:bottom() + velocity.y*dt > y1
      and position.y + collisionBox:center() < y2 then
    velocity.y = 0
    position.y = y1
  end
end


local function checkTopBoundaryCollision(collisionBox, position, velocity, x1, y1, x2, y2, dt)
  if position.x + collisionBox:right() > x1
      and position.x + collisionBox:left() < x2
      and position.y + collisionBox:top() + velocity.y*dt < y2
      and position.y + collisionBox:bottom() > y1 then
    velocity.y = 0
    position.y = y2 + collisionBox.height
  end
end


local function checkLeftBoundaryCollision(collisionBox, position, velocity, x1, y1, x2, y2, dt)
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


local function checkRightBoundaryCollision(collisionBox, position, velocity, x1, y1, x2, y2, dt)
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
local function checkRightAngleSideSlopeCollision(collisionBox, position, velocity, x1, x2, yTop, yBottom, dt)
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
local function checkSharpCornerSlopeCollision(collisionBox, position, velocity, x1, y1, x2, y2, dt)
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
local function checkCeilingOfTopSlopeCollision(collisionBox, position, velocity, m, x1, y1, x2, y2, dt)
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
local function checkFloorOfTopSlopeCollision(collisionBox, position, velocity, y1, dt)
  if position.y + collisionBox:bottom() + velocity.y*dt > y1
      and position.y + collisionBox:bottom() <= y1 then
    velocity.y = 0
    position.y = y1
  end
end

-- Ceiling (flat)
local function checkCeilingOfBottomSlopeCollision(collisionBox, position, velocity, y1, dt)
  if velocity.y < 0 and position.y + collisionBox:top() >= y1
      and position.y + collisionBox:top() + velocity.y*dt < y1 then
    velocity.y = 0
    position.y = y1 + collisionBox.height
  end
end

-- Floor (leaning)
local function checkFloorOfBottomSlopeCollision(collisionBox, position, velocity, m, x1, y1, x2, y2, dt)
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


local function checkBoundariesCollision(collisionBox, position, velocity, terrain, dt)
  for i in pairs(terrain.boundaries) do
    local boundaries = terrain.boundaries[i]
    local x1 = math.min(boundaries[1], boundaries[3])
    local y1 = math.min(boundaries[2], boundaries[4])
    local x2 = math.max(boundaries[1], boundaries[3])
    local y2 = math.max(boundaries[2], boundaries[4])

    checkBottomBoundaryCollision(collisionBox, position, velocity, x1, y1, x2, y2, dt)
    checkTopBoundaryCollision(collisionBox, position, velocity, x1, y1, x2, y2, dt)
    checkLeftBoundaryCollision(collisionBox, position, velocity, x1, y1, x2, y2, dt)
    checkRightBoundaryCollision(collisionBox, position, velocity, x1, y1, x2, y2, dt)
  end
end


local function checkSlopesCollision(collisionBox, position, velocity, terrain, dt)
  collisionBox.onSlope = false

  for i in pairs(terrain.slopes or {}) do
    local x1, y1, x2, y2 = unpack(terrain.slopes[i])
    local yTop, yBottom = math.min(y1, y2), math.max(y1, y2)

    checkRightAngleSideSlopeCollision(collisionBox, position, velocity, x1, x2, yTop, yBottom, dt)
    checkSharpCornerSlopeCollision(collisionBox, position, velocity, x1, y1, x2, y2, dt)

    -- Top and bottom
    if position.x + collisionBox:right() > math.min(x1, x2)
        and position.x + collisionBox:left() < math.max(x1, x2) then
      local m = (y2-y1) / (x2-x1)

      if y1 < y2 then
        checkCeilingOfTopSlopeCollision(collisionBox, position, velocity, m, x1, y1, x2, y2, dt)
        checkFloorOfTopSlopeCollision(collisionBox, position, velocity, y1, dt)
      else
        checkCeilingOfBottomSlopeCollision(collisionBox, position, velocity, y1, dt)
        checkFloorOfBottomSlopeCollision(collisionBox, position, velocity, m, x1, y1, x2, y2, dt)
      end
    end
  end 
end


local function checkCloudsCollision(collisionBox, position, velocity, terrain, dt)
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


function terrainCollision(componentsTable, terrain, dt)
  -- solid depends on collisionBox, position and velocity
  components.assertComponentsDependency(componentsTable, "solids",
                                        "collisionBoxes", "positions",
                                        "velocities")

  for entity, solidComponent in pairs(componentsTable.solids or {}) do
    local collisionBox = componentsTable.collisionBoxes[entity]
    local position = componentsTable.positions[entity]
    local velocity = componentsTable.velocities[entity]
    components.assertComponentExistence(collisionBox, "solid", "collisionBox", entity)
    components.assertComponentExistence(position, "solid", "position", entity)
    components.assertComponentExistence(velocity, "solid", "velocity", entity)

    checkBoundariesCollision(collisionBox, position, velocity, terrain, dt)
    checkSlopesCollision(collisionBox, position, velocity, terrain, dt)
    checkCloudsCollision(collisionBox, position, velocity, terrain, dt)
  end
end
