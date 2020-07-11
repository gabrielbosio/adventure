local animation = require "systems.animation"
local camera = require "systems.camera"
local terrain = require "systems.terrain"
local mruv = require "systems.mruv"
local control = require "systems.control"
local items = require "systems.items"
local goals = require "systems.goals"
local state = require "systems.state"
local living = require "systems.living"
local attack = require "systems.attack"


local M = {}

function M.update(componentsTable, currentLevel, dt)
  camera.update(componentsTable, dt)

  items.update(componentsTable)

  control.player(componentsTable)
  attack.collision(componentsTable)
  currentLevel = goals.update(componentsTable, currentLevel)

  mruv.gravity(componentsTable, dt)
  terrain.collision(componentsTable, currentLevel.terrain, dt)
  control.playerAfterTerrainCollisionChecking(componentsTable)
  mruv.movement(componentsTable, dt)
  living.staminaSupply(componentsTable, dt)
  animation.animator(componentsTable, dt)
  state.finiteStateMachineRunner(componentsTable, dt)

  return currentLevel
end

return M
