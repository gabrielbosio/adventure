require("components")
require("items")
module("control", package.seeall)


local holdingJumpKey

local fsm = {
  idle = function (componentsTable, entity, finiteStateMachine, input, velocity,
                   animationClip)
    -- X Movement Input
      if love.keyboard.isDown("a") and not love.keyboard.isDown("d") then
        velocity.x = -velocity.xSpeed
        animationClip.facingRight = false
        
        if velocity.y == 0 then
          animationClip:setAnimation("walking")
        end
      elseif not love.keyboard.isDown("a") and love.keyboard.isDown("d") then
        velocity.x = velocity.xSpeed
        animationClip.facingRight = true

        if velocity.y == 0 then
          animationClip:setAnimation("walking")
        end
      elseif velocity.y == 0 then
        velocity.x = 0
        animationClip:setAnimation("standing")
      end

      if velocity.y ~= 0 then
        animationClip:setAnimation("jumping")
      end

      -- Y Movement Input

      if love.keyboard.isDown("k") and velocity.y == 0 and not holdingJumpKey then
        finiteStateMachine:setState("startingJump")
        velocity.x = 0
        animationClip:setAnimation("startingJump", function ()
          finiteStateMachine:setState("idle")
          velocity.y = -velocity.jumpImpulseSpeed
          animationClip:setAnimation("jumping")
        end)
        holdingJumpKey = true
      elseif not love.keyboard.isDown("k") and holdingJumpKey then
        holdingJumpKey = false
      end

      if love.keyboard.isDown("j") then
        finiteStateMachine:setState("hurt")
        componentsTable.collectors[entity] = nil
        velocity.x = (animationClip.facingRight and -1 or 1) * velocity.xSpeed
        velocity.y = -velocity.jumpImpulseSpeed
        animationClip:setAnimation("flyingHurt")
      end
  end,

  startingJump = function () end,

  hurt = function (componentsTable, _, _, _, velocity, animationClip)
    if velocity.y == 0 then
      velocity.x = 0
      animationClip:setAnimation("lyingDown")
    end
  end
}


function playerController(componentsTable)
  -- players depend on velocities and positions
  components.assertDependency(componentsTable, "players", "velocities", "positions")

  -- This for loop could be avoided if there is only one entity with a "player"
  -- component.
  for entity, player in pairs(componentsTable.players or {}) do
    local input = componentsTable.inputs[entity]

    if input ~= nil then
      local velocity = componentsTable.velocities[entity]
      local animationClip = componentsTable.animationClips[entity]
      local finiteStateMachine = componentsTable.finiteStateMachines[entity]
      components.assertExistence(entity, "player", {velocity, "velocity",
                                 {animationClip, "animationClip"},
                                 {finiteStateMachine, "finiteStateMachine"}})  
      fsm[finiteStateMachine.currentState](componentsTable, entity, finiteStateMachine,
                                           input, velocity, animationClip)
    end 
  end
end
