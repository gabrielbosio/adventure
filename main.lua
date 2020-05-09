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
      megasapi = box.CollisionBox:new{width = 50, height = 100}
    },
    solids = {
      megasapi = true
    },
    weights = {
      megasapi = true
    },
    positions = {
      megasapi = {
        x = currentLevel.entitiesData.player[1][1],
        y = currentLevel.entitiesData.player[1][2]
      }
    },
    velocities = {
      megasapi = {x = 0, y = 0, xSpeed = 500, jumpImpulseSpeed = 1400}
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
  currentLevel = systems.update(collisionTable, currentLevel, dt)
end

function love.draw()
  -- Shapes
  outline.draw(componentsTable, currentLevel.terrain)
  animation.animationRenderer(componentsTable, spriteSheet)
  -- Text
  outline.debug(componentsTable)
end
