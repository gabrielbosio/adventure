require("components")
require("items")
module("control", package.seeall)


local holdingJumpKey
currentLevel = {}  -- modified by playerController system 

local fsm = {
  idle = function (player, input, velocity, animationClip)
    -- X Movement Input
      if love.keyboard.isDown("a") and not love.keyboard.isDown("d") then
        velocity.x = -velocity.xSpeed
        animationClip.facingRight = false
        
        if velocity.y == 0 then
          animationClip:setAnimation("walking")
        end
      elseif not love.keyboard.isDown("a") and love.keyboard.isDown("d") then
        velocity.x = velocity.xSpeed
        animationClip.facingRight = true

        if velocity.y == 0 then
          animationClip:setAnimation("walking")
        end
      elseif velocity.y == 0 then
        velocity.x = 0
        animationClip:setAnimation("standing")
      end

      if velocity.y ~= 0 then
        animationClip:setAnimation("jumping")
      end

      -- Y Movement Input

      if love.keyboard.isDown("k") and velocity.y == 0 and not holdingJumpKey then
        player.state = "startingJump"
        velocity.x = 0
        animationClip:setAnimation("startingJump", function ()
          player.state = "idle"
          velocity.y = -velocity.jumpImpulseSpeed
          animationClip:setAnimation("jumping")
        end)
        holdingJumpKey = true
      elseif not love.keyboard.isDown("k") and holdingJumpKey then
        holdingJumpKey = false
      end

      if love.keyboard.isDown("j") then
        player.state = "flyingHurt"
        velocity.x = (animationClip.facingRight and -1 or 1) * velocity.xSpeed
        velocity.y = -velocity.jumpImpulseSpeed
        animationClip:setAnimation("flyingHurt")
      end
  end,

  startingJump = function () end,

  flyingHurt = function (player, input, velocity, animationClip)
    
    if velocity.y == 0 then
      velocity.x = 0
      animationClip:setAnimation("lyingDown")
    end
  end
}


function playerController(componentsTable)
  -- players depend on velocities and positions
  components.assertDependency(componentsTable, "players", "velocities", "positions")

  -- This for loop could be avoided if there is only one entity with a "player"
  -- component.
  for entity, player in pairs(componentsTable.players or {}) do
    local input = componentsTable.inputs[entity]

    if input ~= nil then
      local velocity = componentsTable.velocities[entity]
      local animationClip = componentsTable.animationClips[entity]
      components.assertExistence(entity, "player", {velocity, "velocity"})

      fsm[player.state](player, input, velocity, animationClip)

      -- This could be moved to the collision module or something similar
      -- Goal control
      local position = componentsTable.positions[entity]
      local collisionBox = componentsTable.collisionBoxes[entity]
      components.assertExistence(entity, "player", {position, "position"},
                                  {collisionBox, "collisionBox"})

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

          -- Reload goals and items
          -- This should actually load ANY entity in the new level
          items.load(componentsTable, currentLevel, "medkits", "pomodori")

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
    end -- if componentsTable.inputs[entity] ~= nil
  end  -- for entity, player
end
