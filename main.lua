require("collision")
require("components")
require("levels")
require("mruv")
require("control")
require("outline")


function love.load()
  -- Level data loading
  currentLevel = levels.level[levels.first]
  control.currentLevel = currentLevel  -- there must be something better

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
      megasapi = {
        x = currentLevel.entitiesData.player[1],
        y = currentLevel.entitiesData.player[2]
      }
    },
    velocities = {
      megasapi = {x = 0, y = 0, xSpeed = 500, jumpImpulseSpeed = 1400}
    },
    goals = {},
    animationClips = {
      megasapi = components.animationClip(animations.megasapi, "standing")
    },
    living = {
      megasapi = {health = 10, stamina = 100, deathType = nil}
    },
    healing = {}
  }

  local goalData = currentLevel.entitiesData.goals
  for goalIndex, goalData in pairs(goalData) do
    local id = "goal" .. tostring(goalIndex)
    componentsTable.positions[id] = {x = goalData[1], y = goalData[2]}
    componentsTable.goals[id] = goalData[3]
  end

  local medkitsData = currentLevel.entitiesData.medkits
  for medkitIndex, medkitData in pairs(medkitsData) do
    local id = "medkit" .. tostring(medkitIndex)
    componentsTable.positions[id] = {x = medkitData[1], y = medkitData[2]}
    componentsTable.healing[id] = 1  -- some healing amount
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
  outline.drawMedkits(componentsTable.healing, componentsTable.positions)
  outline.drawPlayerCollisionBox(playerPosition, playerBox)
  outline.drawPlayerPosition(playerPosition, true)
  outline.displayMouseCoordinates()
  outline.displayPlayerHealth(componentsTable.living.megasapi.health)
end
