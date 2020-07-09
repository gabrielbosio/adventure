require("components")
module("camera", package.seeall)


local function snapToTarget(vcamPosition, targetPosition)
  local width, height = love.window.getMode()

  -- No tweening, just center the target on screen
  vcamPosition.x = targetPosition.x - width/2
  vcamPosition.y = -targetPosition.y + height/2
end

local function applyLinearTweening(vcamPosition, targetPosition, dt, parameters)
  local width, height = love.window.getMode()
  local diff = {
    x = vcamPosition.x - targetPosition.x + width/2,
    y = vcamPosition.y + targetPosition.y - height/2
  }
  local slope = {
    x = 0,
    y = 0
  }

  if (math.abs(diff.x) > parameters.threshold) then
    slope.x = -diff.x / math.abs(diff.x) * parameters.multiplier
  end
  if (math.abs(diff.y) > parameters.threshold) then
    slope.y = -diff.y / math.abs(diff.y) * parameters.multiplier
  end

  vcamPosition.x = vcamPosition.x + slope.x*dt
  vcamPosition.y = vcamPosition.y + slope.y*dt
end

--- Follow camera targets
function update(componentsTable, dt)
  for vcamEntity, isVcam in pairs(componentsTable.cameras or {}) do
    if isVcam then
      for targetEntity, isTarget in pairs(componentsTable.cameraTargets) do
        if isTarget then
          local vcamPosition = componentsTable.positions[vcamEntity]
          local targetPosition = componentsTable.positions[targetEntity]
          components.assertExistence(vcamEntity, "camera",
                                     {vcamPosition, "vcamPosition"})
          components.assertExistence(targetEntity, "cameraTarget",
                                     {targetPosition, "targetPosition"})

          applyLinearTweening(vcamPosition, targetPosition, dt,
            {
              multiplier = 500,
              threshold = 10
            })
        end
      end
    end
  end
end

--- Return the results of applying coordinate translations
function positions(componentsTable, terrain)
  local translated = {
    terrain = {
      boundaries = {},
      clouds = {},
      slopes = {}
    },
    components = {}
  }

  -- Move
  for vcamEntity, isVcam in pairs(componentsTable.cameras or {}) do

    if isVcam then
      local vcamPosition

      -- boxes first, to get the vcamPosition
      for entity, position in pairs(componentsTable.positions or {}) do
        if vcamEntity ~= entity then
          vcamPosition = componentsTable.positions[vcamEntity]
          components.assertExistence(vcamEntity, "camera",
                                     {vcamPosition, "position"})
          translated.components[entity] = {
            x = position.x - vcamPosition.x,
            y = position.y + vcamPosition.y
          }
        end
      end

      -- Now, move terrain
      -- boundaries
      for _, boundary in ipairs(terrain.boundaries or {}) do
        table.insert(translated.terrain.boundaries, {
          boundary[1] - vcamPosition.x, boundary[2] + vcamPosition.y,
          boundary[3] - vcamPosition.x, boundary[4] + vcamPosition.y
        })
      end

      -- clouds
      for _, cloud in ipairs(terrain.clouds or {}) do
        table.insert(translated.terrain.clouds, {
          cloud[1] - vcamPosition.x, cloud[2] + vcamPosition.y,
          cloud[3] - vcamPosition.x
        })
      end

      -- slopes
      for _, slope in ipairs(terrain.slopes or {}) do
        table.insert(translated.terrain.slopes, {
          slope[1] - vcamPosition.x, slope[2] + vcamPosition.y,
          slope[3] - vcamPosition.x, slope[4] + vcamPosition.y
        })
      end

    end
  end

  -- Done, now return a table with all the moved positions
  return translated
end
