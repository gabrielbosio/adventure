require("components.box")
require("components.animation")
require("components.fsm")
require("levels")
require("systems")
require("outline")


function love.load()
  -- Level data loading
  currentLevel = levels.level[levels.first]
  control.currentLevel = currentLevel
  dofile("resources/animations.lua")
  spriteSheet = love.graphics.newImage("resources/sprites/megasapi.png")

  componentsTable = {
    players = {  -- or maybe "player", there is just one...
      megasapi = {experience = 0, stunned = false}
    },
    collisionBoxes = {
      megasapi = box.CollisionBox:new{width = 50, height = 100},
      bag = box.CollisionBox:new{width = 50, height = 100}
    },
    solids = {
      megasapi = true,
      bag = true
    },
    weights = {
      megasapi = true,
      bag = true
    },
    cameras = {  -- or maybe "camera", there is just one...
      vcam = true
    },
    cameraTargets = {  -- or maybe "target", there is just one...
      megasapi = true
    },
    positions = {
      megasapi = {
        x = currentLevel.entitiesData.player[1][1],
        y = currentLevel.entitiesData.player[1][2]
      },
      bag = {
        x = 140,
        y = 500
      },
      vcam = {
        x = 0,
        y = 0
      }
    },
    velocities = {
      megasapi = {x = 0, y = 0, xSpeed = 500, jumpImpulseSpeed = 1400},
      bag = {x = 0, y = 0}
    },
    goals = {},
    animationClips = {
      megasapi = animation.AnimationClip(animations.megasapi, "standing", spriteSheet)
    },
    living = {
      megasapi = {health = 10, stamina = 100, deathType = nil}
    },
    healing = {},
    experienceEffect = {},
    itemBoxes = {},
    inputs = {
      megasapi = true
    },
    collectors = {
      megasapi = true
    },
    finiteStateMachines = {
      megasapi = fsm.FiniteStateMachine("idle")
    }
  }

  goals.load(componentsTable, currentLevel)
  items.load(componentsTable, currentLevel)
end


function love.update(dt)
  -- vCam test
  for vcamEntity, isVcam in pairs(componentsTable.cameras) do
    if isVcam then
      for targetEntity, isTarget in pairs(componentsTable.cameraTargets) do
        if isTarget then
          local vcamPosition = componentsTable.positions[vcamEntity]
          local targetPosition = componentsTable.positions[targetEntity]
          local width, height = love.window.getMode()

          vcamPosition.x = targetPosition.x - width/2
          vcamPosition.y = -targetPosition.y + height/2
        end
      end
    end
  end

  currentLevel = systems.update(collisionTable, currentLevel, dt)
end

function love.draw()
  -- Shapes
  outline.draw(componentsTable, currentLevel.terrain)
  animation.animationRenderer(componentsTable, spriteSheet)
  -- Text
  outline.debug(componentsTable)
end
