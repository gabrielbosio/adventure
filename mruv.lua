module("mruv", package.seeall)


function gravity(components, dt)
  local gravity = 5000
  
  for entity, weight in pairs(components.weights) do
    local velocity = components.velocities[entity]
    velocity.y = velocity.y + gravity*dt
  end
end


function movement(components, dt)
  for entity, velocity in pairs(components.velocities) do
    local position = components.positions[entity]
    local winWidth, winHeight = love.window.getMode()
    position.x = (position.x + velocity.x*dt)
    position.y = (position.y + velocity.y*dt)
  end
end
