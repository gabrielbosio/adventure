require("components")
module("control", package.seeall)

local holdingJumpKey
currentLevel = {}  -- GLOBAL VARIABLE WATCH OUT

function playerController(componentsTable)
  components.assertComponentsDependency(componentsTable.players, componentsTable.velocities,
                                        "player", "velocity")
  components.assertComponentsDependency(componentsTable.players, componentsTable.positions,
                                        "player", "position")

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

    -- Goal control
    local position = componentsTable.positions[entity]
    components.assertComponentExistence(position, "player", "position", entity)

    for goalEntity, nextLevelID in pairs(componentsTable.goals or {}) do
      local goalPosition = componentsTable.positions[goalEntity]

      local GOAL_SIZE = 110  -- Replace with some variable


      if position.x >= goalPosition.x - GOAL_SIZE/2
          and position.x <= goalPosition.x + GOAL_SIZE/2
          and position.y >= goalPosition.y - GOAL_SIZE
          and position.y <= goalPosition.y then
        currentLevel = levels.level[nextLevelID]  -- GLOBAL VARIABLE WATCH OUT
      end
    end

  end  -- for entity, player
end
