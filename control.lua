require("components")
module("control", package.seeall)


local holdingJumpKey
currentLevel = {}  -- modified by playerController system 


function playerController(componentsTable)
  -- players depend on velocities and positions
  components.assertComponentsDependency("players", "velocities", "positions")

  -- This for loop could be avoided if there is only one entity with a "player"
  -- component.
  for entity, player in pairs(componentsTable.players or {}) do
    local velocity = componentsTable.velocities[entity]
    components.assertComponentExistence(velocity, "player", "velocity", entity)

    -- X Movement Input
    if love.keyboard.isDown("a") and not love.keyboard.isDown("d") then
      velocity.x = -velocity.xSpeed
    elseif not love.keyboard.isDown("a") and love.keyboard.isDown("d") then
      velocity.x = velocity.xSpeed
    else
      velocity.x = 0
    end

    -- Y Movement Input
    if love.keyboard.isDown("k") and velocity.y == 0 and not holdingJumpKey then
      velocity.y = -velocity.jumpImpulseSpeed
      holdingJumpKey = true
    elseif not love.keyboard.isDown("k") and holdingJumpKey then
      holdingJumpKey = false
    end

    -- This could be moved to the collision module or something similar
    -- Goal control
    local position = componentsTable.positions[entity]
    components.assertComponentExistence(position, "player", "position", entity)
    local collisionBox = componentsTable.collisionBoxes[entity]
    components.assertComponentExistence(collisionBox, "player", "collisionBox", entity)

    for goalEntity, nextLevelID in pairs(componentsTable.goals or {}) do
      local goalPosition = componentsTable.positions[goalEntity]

      local GOAL_SIZE = 110  -- store this variable somewhere else
      -- (variable repeated in outline.lua)

      if position.x + collisionBox.width/2 >= goalPosition.x - GOAL_SIZE/2
          and position.x - collisionBox.width/2 <= goalPosition.x + GOAL_SIZE/2
          and position.y >= goalPosition.y - GOAL_SIZE
          and position.y - collisionBox.height <= goalPosition.y then
        currentLevel = levels.level[nextLevelID]  -- changes module variable

        -- Player position loading and movement restore
        position.x = currentLevel.entitiesData.player[1]
        position.y = currentLevel.entitiesData.player[2]
        velocity.x = 0
        velocity.y = 0

        -- Reload goals
        for _id in pairs(componentsTable.goals) do
          componentsTable.positions[_id] = nil
          componentsTable.goals[_id] = nil
        end

        local currentGoals = currentLevel.entitiesData.goals

        if currentGoals ~= nil then
          for goalIndex, goalData in pairs(currentLevel.entitiesData.goals) do
            local id = "goal" .. tostring(goalIndex)
            componentsTable.positions[id] = {x = goalData[1], y = goalData[2]}
            componentsTable.goals[id] = goalData[3]
          end
        end

        break
      end
    end
    
    -- This could be moved to the collision module or something similar
    if componentsTable.living ~= nil and componentsTable.living[entity] ~= nil
        then
      local health = componentsTable.living[entity].health

      for healingEntity, healingAmount in pairs(componentsTable.healing or {}) do
        local healingPosition = componentsTable.positions[healingEntity]
        local healingAmount = componentsTable.healing[healingEntity]

        local HEALING_SIZE = 10  -- store this variable somewhere else
      -- (variable repeated in outline.lua)

        if position.x + collisionBox.width/2 >= healingPosition.x - HEALING_SIZE/2
            and position.x - collisionBox.width/2 <= healingPosition.x + HEALING_SIZE/2
            and position.y >= healingPosition.y - HEALING_SIZE
            and position.y - collisionBox.height <= healingPosition.y then
          componentsTable.living[entity].health = health + healingAmount
          componentsTable.positions[healingEntity] = nil
          componentsTable.healing[healingEntity] = nil
        end
      end
    end  -- Too much repeated code

  end  -- for entity, player
end
