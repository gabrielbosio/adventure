require("collision")
require("components")
require("levels")
require("mruv")
require("control")
require("place")


function love.load()
  -- Level data loading
  currentLevel = levels.level[levels.first]
  local goalData = currentLevel.entitiesData.goal

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
      megasapi = {x = 46, y = 142},
      goal = {x = goalData[1], y = goalData[2]}
    },
    velocities = {
      megasapi = {x = 0, y = 0, xSpeed = 500, jumpImpulseSpeed = 1400}
    },
    goals = {
      goal = goalData[3]
    }
  }
end


function love.update(dt)
  control.playerController(componentsTable)

  mruv.gravity(componentsTable, dt)
  collision.terrainCollision(componentsTable, currentLevel.terrain, dt)
  mruv.movement(componentsTable, dt)
end

function love.draw()
  local playerPosition = componentsTable.positions.megasapi
  local playerBox = componentsTable.collisionBoxes.megasapi
  local goal = componentsTable.positions.goal
  love.graphics.setColor(1, 1, 1)
  levels.drawTerrainOutline()

  -- We could move this to a "debug" module
  -- Goal outline 
  local goalOutlineSize = 110
  love.graphics.setColor(1, 0.5, 0.5)
  love.graphics.rectangle("fill", goal.x - goalOutlineSize/2,
                          goal.y - goalOutlineSize, goalOutlineSize,
                          goalOutlineSize)

  -- We could move this to a "debug" module
  -- Player collision box
  love.graphics.setColor(0, 0, 1)
  love.graphics.rectangle("fill", playerPosition.x-playerBox.width/2,
    playerPosition.y-playerBox.height, playerBox.width, playerBox.height)

  -- We could move this to a "debug" module
  -- Cursor position
  love.graphics.setColor(1, 1, 1)
  place.textByAnchor(love.mouse.getX() .. ", " .. love.mouse.getY(), 0, 0,
    "north west")

  -- We could move this to a "debug" module
  -- Player position
  love.graphics.setColor(1, 1, 0)
  love.graphics.circle("fill", playerPosition.x, playerPosition.y, 2)
  local playerPositionText = math.floor(playerPosition.x) .. ", " ..
    math.floor(playerPosition.y)
  place.textByAnchor(playerPositionText, 0,
    love.graphics.getFont():getHeight(playerPositionText), "north west")
end
