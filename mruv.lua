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


function movement(componentsTable, dt, xSpeed, jumpImpulseSpeed)

  components.assertComponentsDependency(componentsTable.velocities, componentsTable.positions,
                                        "velocity", "position")
  
  for entity, velocity in pairs(componentsTable.velocities or {}) do
    local position = componentsTable.positions[entity]
    local winWidth, winHeight = love.window.getMode()
    components.assertComponentExistence(position, "velocity", "position", entity)

    if componentsTable.inputs ~= nil then
        input = componentsTable.inputs[entity]

        -- Change velocity if entity has an input component
        if input ~= nil then
          velocity.x = 0

          if input.left then
            velocity.x = -xSpeed
          end

          if input.right then
            velocity.x = xSpeed
          end

          if input.jump and velocity.y == 0 then
            velocity.y = -jumpImpulseSpeed
          end

        end
    end
    
    position.x = (position.x + velocity.x*dt)
    position.y = (position.y + velocity.y*dt)
  end
end
