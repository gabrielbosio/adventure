require("collision")
require("components")
require("levels")
require("mruv")
require("control")
require("place")

function love.load()
  -- Movement constants. For now, they are used by the player only.
  -- They could be used by the enemies too.
  -- The enemies could also define their own constants in some module.
  

  componentsTable = {
    players = {  -- or maybe "player", there is just one...
      megasapi = {experience = 0, stunned = false}
    },
    collisionBoxes = {
      megasapi = components.collisionBox(50, 100)
    },
    solids = {
      megasapi = true
    },
    weights = {
      megasapi = true
    },
    positions = {
      megasapi = {x = 46, y = 142}
    },
    velocities = {
      megasapi = {x = 0, y = 0}
    }
  }
end


function love.update(dt)
  control.playerController(componentsTable)

  mruv.gravity(componentsTable, dt)
  collision.terrainCollision(componentsTable, levels.level["test"].terrain, dt)
  mruv.movement(componentsTable, dt, xSpeed, jumpImpulseSpeed)
end

function love.draw()
  local playerPosition = componentsTable.positions.megasapi
  local playerBox = componentsTable.collisionBoxes.megasapi
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
