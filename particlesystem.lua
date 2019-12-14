module("ParticleSystem", package.seeall)


function ParticleSystem:new()
  local object = setmetatable({}, self)
  self.__index = self
  object.particles = {}

  return object
end


function ParticleSystem:createDust(x, y)
  table.insert(self.particles, {x = x, y = y, size = 2, time = 0.15})
end


function ParticleSystem:update(dt)
  for i = #self.particles, 1, -1 do
    local particle = self.particles[i]
    particle.size = particle.size + 1
    particle.time = particle.time - dt

    if particle.time <= 0 then
      table.remove(self.particles, i)
    end
  end
end


function ParticleSystem:draw()
  love.graphics.setColor(0.8, 0.8, 0.8, 0.5)
  for _, particle in ipairs(self.particles) do
    love.graphics.circle("fill", particle.x, particle.y, particle.size)
  end
  love.graphics.setColor(1, 1, 1)
end
