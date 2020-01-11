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
    healing = {},
    experienceEffect = {}
  }

  for goalIndex, goalData in pairs(currentLevel.entitiesData.goals) do
    local id = "goal" .. tostring(goalIndex)
    componentsTable.positions[id] = {x = goalData[1], y = goalData[2]}
    componentsTable.goals[id] = goalData[3]
  end

  for medkitIndex, medkitData in pairs(currentLevel.entitiesData.medkits) do
    local id = "medkit" .. tostring(medkitIndex)
    componentsTable.positions[id] = {x = medkitData[1], y = medkitData[2]}
    componentsTable.healing[id] = 1  -- some healing amount
  end

  for pomodoroIndex, pomodoroData in pairs(currentLevel.entitiesData.pomodori)
      do
    local id = "pomodoro" .. tostring(pomodoroIndex)
    componentsTable.positions[id] = {x = pomodoroData[1], y = pomodoroData[2]}
    componentsTable.experienceEffect[id] = 1  -- some experience amount
  end

  -- Repeated code, do it better
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

  -- Maybe just one outline.draw would be better
  -- Another possibility is divide in two: Shapes and Text
  outline.drawTerrainOutline(currentLevel)
  outline.drawGoals(componentsTable.goals, componentsTable.positions)
  outline.drawMedkits(componentsTable.healing, componentsTable.positions)
  outline.drawPomodori(componentsTable.experienceEffect,
                       componentsTable.positions)
  outline.drawPlayerCollisionBox(playerPosition, playerBox)
  outline.drawPlayerPosition(playerPosition, true)
  outline.displayMouseCoordinates()
  outline.displayPlayerHealth(componentsTable.living.megasapi.health)
  outline.displayPlayerExperience(componentsTable.players.megasapi.experience)
end
