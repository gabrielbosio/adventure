require("systems.animation")
require("systems.terrain")
require("systems.mruv")
require("systems.control")
require("systems.items")
require("systems.goals")
require("systems.state")
require("systems.living")

module("systems", package.seeall)


function update(collisionTable, currentLevel, dt)
  items.update(componentsTable)

  control.player(componentsTable)
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