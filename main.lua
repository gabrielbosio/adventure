require("collision")
require("components")
require("levels")
require("mruv")
require("place")

function love.load()
  -- Physics test
  xSpeed = 500
  jumpImpulseSpeed = 1400

  components = {
    collisionBoxes = {
      megasapi = components.collisionBox(50, 100)
    },
    solids = {
      megasapi = {}
    },
    weights = {
      megasapi = {}
    },
    positions = {
      megasapi = {x = 46, y = 142}
    },
    velocities = {
      megasapi = {x = 0, y = 0}
    }
  }

  cloudHeightDisplay = 10 
end

-- Input test - callbacks seem good for prevent bunny hops
-- not good for horizontal movement though: one need keyboard.isDown anyway
function love.keypressed(key, isrepeat)
  local playerBox = components.collisionBoxes.megasapi
  local playerVelocity = components.velocities.megasapi
  -- Y Movement Input
  if key == "w" and playerVelocity.y == 0 then
    playerVelocity.y = -jumpImpulseSpeed
  end
end

function love.update(dt)
  local playerBox = components.collisionBoxes.megasapi
  local playerVelocity = components.velocities.megasapi

  -- X Movement Input (far simpler than the callback approach)
  -- Extract this into movement and playerController using input and velocity as components
  if love.keyboard.isDown("a") and not love.keyboard.isDown("d") then
    playerVelocity.x = -xSpeed
  elseif love.keyboard.isDown("d") and not love.keyboard.isDown("a") then
    playerVelocity.x = xSpeed
  else
    playerVelocity.x = 0
  end

  mruv.gravity(components, dt)
  collision.terrainCollision(components, levels.level["test"].terrain, dt)
  mruv.movement(components, dt)
end

function love.draw()
  local playerPosition = components.positions.megasapi
  local playerBox = components.collisionBoxes.megasapi
  love.graphics.setColor(1, 1, 1)

  -- Physics test
  levels.drawTerrainOutline()

  -- Player collision box
  love.graphics.setColor(0, 0, 1)
  love.graphics.rectangle("fill", playerPosition.x-playerBox.width/2,
    playerPosition.y-playerBox.height, playerBox.width, playerBox.height)

  -- Cursor position
  love.graphics.setColor(1, 1, 1)
  place.textByAnchor(love.mouse.getX() .. ", " .. love.mouse.getY(), 0, 0,
    "north west")

  -- Player position
  love.graphics.setColor(1, 1, 0)
  love.graphics.circle("fill", playerPosition.x, playerPosition.y, 2)
  local playerPositionText = math.floor(playerPosition.x) .. ", " ..
    math.floor(playerPosition.y)
  place.textByAnchor(playerPositionText, 0,
    love.graphics.getFont():getHeight(playerPositionText), "north west")
end
