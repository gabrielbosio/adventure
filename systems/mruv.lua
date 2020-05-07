require("components")
module("mruv", package.seeall)


function gravity(componentsTable, dt)
  local gravity = 5000

  -- weight depends on velocity
  components.assertDependency(componentsTable, "weight", "velocity")

  for entity, weight in pairs(componentsTable.weights or {}) do
    local velocity = componentsTable.velocities[entity]
    components.assertExistence(entity, "weight", {velocity, "velocity"})
    
    velocity.y = velocity.y + gravity*dt
  end
end


function movement(componentsTable, dt)

  components.assertDependency(componentsTable, "velocities", "positions")
  
  for entity, velocity in pairs(componentsTable.velocities or {}) do
    local position = componentsTable.positions[entity]
    local winWidth, winHeight = love.window.getMode()
    components.assertExistence(entity, "velocity", {position, "position"})

    position.x = position.x + velocity.x*dt
    position.y = position.y + velocity.y*dt
  end
end
