local box = require "components.box"
local animation = require "components.animation"
local renderer = require "systems.animation".animationRenderer
local fsm = require "components.fsm"
local levels = require "levels"
local systems = require "systems"
local camera = require "systems.camera"
local control = require "systems.control"
local goals = require "systems.goals"
local items = require "systems.items"
local outline = require "outline"


local currentLevel, spriteSheet, componentsTable

function love.load()
  -- Level data loading
  currentLevel = levels.level[levels.first]
--  control.currentLevel = currentLevel
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
    shake = {
      vcam = 5
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
        x = -400,
        y = 300
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
  -- TEST
  componentsTable.shake.vcam = love.keyboard.isDown("h") and 10 or 0

  currentLevel = systems.update(componentsTable, currentLevel, dt)
end

function love.draw()
  local positions = camera.positions(componentsTable, currentLevel.terrain)
  -- Shapes
  outline.draw(componentsTable, positions)
  renderer(componentsTable, spriteSheet, positions.components)
  -- Text
  outline.debug(componentsTable)
end
