require("collision")
require("levels")
require("place")

function love.load()
  -- Physics test
  xSpeed = 500
  jumpImpulseSpeed = 1400

  components = {
    collisionBoxes = {
      megasapi = {x = 46, y = 142, vx = 0, vy = 0, width = 50, height = 100, onSlope = false}
    },
    solids = {
      megasapi = {}
    }
  }

  cloudHeightDisplay = 10 
end

-- Input test - callbacks seem good for prevent bunny hops
-- not good for horizontal movement though: one need keyboard.isDown anyway
function love.keypressed(key, isrepeat)
  local playerBox = components.collisionBoxes.megasapi
  -- Y Movement Input
  if key == "w" and playerBox.vy == 0 then
    playerBox.vy = -jumpImpulseSpeed
  end
end

function love.update(dt)
  local playerBox = components.collisionBoxes.megasapi

  -- X Movement Input (far simpler than the callback approach)
  if love.keyboard.isDown("a") and not love.keyboard.isDown("d") then
    playerBox.vx = -xSpeed
  elseif love.keyboard.isDown("d") and not love.keyboard.isDown("a") then
    playerBox.vx = xSpeed
  else
    playerBox.vx = 0
  end

  collision.terrainCollision(components, levels.level["test"].terrain, dt)
end

function love.draw()
  local playerBox = components.collisionBoxes.megasapi
  love.graphics.setColor(1, 1, 1)

  -- Physics test
  levels.drawTerrainOutline()

  -- Player collision box
  love.graphics.setColor(0, 0, 1)
  love.graphics.rectangle("fill", playerBox.x-playerBox.width/2,
    playerBox.y-playerBox.height, playerBox.width, playerBox.height)

  -- Cursor position
  love.graphics.setColor(1, 1, 1)
  place.textByAnchor(love.mouse.getX() .. ", " .. love.mouse.getY(), 0, 0,
    "north west")

  -- Player position
  love.graphics.setColor(1, 1, 0)
  love.graphics.circle("fill", playerBox.x, playerBox.y, 2)
  local playerPositionText = math.floor(playerBox.x) .. ", " ..
    math.floor(playerBox.y)
  place.textByAnchor(playerPositionText, 0,
    love.graphics.getFont():getHeight(playerPositionText), "north west")
end
