require("components")
module("control", package.seeall)

local holdingJumpKey

function playerController(componentsTable)
  components.assertComponentsDependency(componentsTable.players, componentsTable.velocities,
                                        "player", "velocity")

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

      if love.keyboard.isDown("w") and velocity.y == 0 and not holdingJumpKey then
        velocity.y = -velocity.jumpImpulseSpeed
        holdingJumpKey = true
      elseif not love.keyboard.isDown("w") and holdingJumpKey then
        holdingJumpKey = false
      end
  end  -- for entity, player
end
