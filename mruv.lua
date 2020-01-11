require("components")
module("mruv", package.seeall)


function gravity(componentsTable, dt)
  local gravity = 5000

  components.assertComponentsDependency(componentsTable.weights, componentsTable.velocities,
                                        "weight", "velocity")

  for entity, weight in pairs(componentsTable.weights or {}) do
    local velocity = componentsTable.velocities[entity]
    components.assertComponentExistence(velocity, "weight", "velocity", entity)
    
    velocity.y = velocity.y + gravity*dt
  end
end


function movement(componentsTable, dt)

  components.assertComponentsDependency(componentsTable.velocities, componentsTable.positions,
                                        "velocity", "position")
  
  for entity, velocity in pairs(componentsTable.velocities or {}) do
    local position = componentsTable.positions[entity]
    local winWidth, winHeight = love.window.getMode()
    components.assertComponentExistence(position, "velocity", "position", entity)
    
    position.x = (position.x + velocity.x*dt)
    position.y = (position.y + velocity.y*dt)
  end
end
