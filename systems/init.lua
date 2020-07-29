--[[--
 System interconnection.

 Systems interact with components and make the game what it is.

 Systems are implemented here as functions that receive and modify references to
 one shared component table, defined in `main.lua`.
 Also, some of these functions interact with each other directly, where the
 output of a system becomes one input of other system.
 For example, the goal system gives information about the current level of the
 game to the terrain system, to handle collisions with box components properly.
]]
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

--[[--
 Share the game state among its systems and return the current level depending
 on it.

 @tparam table componentsTable a reference to the main component table
 @tparam table currentLevel a table that contains the information of the current
  level
 @tparam number dt time since last update, as stated in
  [the <code>love.update</code> documentation](https://love2d.org/wiki/love.update).
]]
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
