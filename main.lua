require("collision")
require("components")
require("levels")
require("mruv")
require("control")
require("place")
require("outline")


function love.load()
  -- Level data loading
  currentLevel = levels.level[levels.first]
  control.currentLevel = currentLevel  -- there must be something better
  local goalData = currentLevel.entitiesData.goals

  dofile("animations.lua")

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
      megasapi = {x = 0, y = 0, xSpeed = 500, jumpImpulseSpeed = 1400}
    },
    goals = {},
    animationClips = {
      megasapi = components.animationClip(animations.megasapi, "standing")
    }
  }

  for goalIndex, goalData in pairs(goalData) do
    local id = "goal" .. tostring(goalIndex)
    componentsTable.positions[id] = {x = goalData[1], y = goalData[2]}
    componentsTable.goals[id] = goalData[3]
  end
end


function love.update(dt)
  control.playerController(componentsTable, currentLevel)
  currentLevel = control.currentLevel  -- there must be something better

  mruv.gravity(componentsTable, dt)
  collision.terrainCollision(componentsTable, currentLevel.terrain, dt)
  mruv.movement(componentsTable, dt)
end

function love.draw()
  local playerPosition = componentsTable.positions.megasapi
  local playerBox = componentsTable.collisionBoxes.megasapi

  outline.drawTerrainOutline(currentLevel)
  outline.drawGoals(componentsTable.goals, componentsTable.positions)
  outline.drawPlayerCollisionBox(playerPosition, playerBox)
  outline.drawPlayerPosition(playerPosition, true)
  outline.displayMouseCoordinates()
end
