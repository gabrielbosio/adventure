require("animation")
require("collision")
require("components")
require("levels")
require("mruv")
require("control")
require("items")
require("outline")
require("state")


function love.load()
  -- Level data loading
  currentLevel = levels.level[levels.first]
  control.currentLevel = currentLevel
  dofile("animations.lua")
  spriteSheet = love.graphics.newImage("sprites/megasapi.png")

  componentsTable = {
    players = {  -- or maybe "player", there is just one...
      megasapi = {experience = 0, stunned = false}
    },
    collisionBoxes = {
      megasapi = components.CollisionBox(50, 100)
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
      megasapi = components.AnimationClip(animations.megasapi, "standing", spriteSheet)
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
      megasapi = components.FiniteStateMachine("idle")
    }
  }

  components.assertDependency(componentsTable, "goals", "positions")
  for goalIndex, goalData in pairs(currentLevel.entitiesData.goals) do
    local id = "goal" .. tostring(goalIndex)
    componentsTable.positions[id] = {x = goalData[1], y = goalData[2]}
    componentsTable.goals[id] = goalData[3]
  end

  items.load(componentsTable, currentLevel, "medkits", "pomodori")
end


function love.update(dt)
  items.healthSupply(componentsTable)
  items.experienceSupply(componentsTable)

  control.playerController(componentsTable)
  currentLevel = collision.goal(componentsTable, currentLevel)

  mruv.gravity(componentsTable, dt)
  collision.terrain(componentsTable, currentLevel.terrain, dt)
  mruv.movement(componentsTable, dt)
  animation.animator(componentsTable, dt)
  state.finiteStateMachineRunner(componentsTable, dt)
end

function love.draw()
  -- Shapes
  outline.draw(componentsTable, currentLevel.terrain)
  animation.animationRenderer(componentsTable, spriteSheet)
  -- Text
  outline.debug(componentsTable)
end
