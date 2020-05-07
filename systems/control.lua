require("components")
module("control", package.seeall)


local holdingJumpKey

local statesLogic = {
  idle = function (_, _, finiteStateMachine, input, velocity, animationClip, _)
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
        animationClip:setAnimation("startingJump")
        holdingJumpKey = true
      elseif not love.keyboard.isDown("k") and holdingJumpKey then
        holdingJumpKey = false
      end

      if love.keyboard.isDown("j") then
        finiteStateMachine:setState("hurt")
      end

      if love.keyboard.isDown("s") then
        finiteStateMachine:setState("descend")
      end
  end,

  startingJump = function (_, _, finiteStateMachine, _, velocity, animationClip, _)
    if animationClip.done then
      finiteStateMachine:setState("idle")
      animationClip:setAnimation("jumping")
      velocity.y = -velocity.jumpImpulseSpeed
    end
  end,

  hurt = function (componentsTable, entity, finiteStateMachine, _, velocity,
                   animationClip, living)
    living.health = living.health - 1
    living.stamina = math.max(0, living.stamina - 25)
    if living.health == 0 or living.stamina == 0 then
      finiteStateMachine:setState("flyingHurt")
      animationClip:setAnimation("flyingHurt")
      componentsTable.collectors[entity] = nil
      velocity.x = (animationClip.facingRight and -1 or 1) * velocity.xSpeed
      velocity.y = -velocity.jumpImpulseSpeed
    else
      finiteStateMachine:setState("hit")
      animationClip:setAnimation("hitByHighPunch")
    end
  end,

  hit = function (_, _, finiteStateMachine, _, velocity, animationClip, _)
    --velocity.x must be set to a property value from another component
    velocity.x = (animationClip.facingRight and -1 or 1) * velocity.xSpeed / 3
    if animationClip.done then
      finiteStateMachine:setState("idle")
    end
  end,

  flyingHurt = function (_, _, finiteStateMachine, _, velocity, animationClip, _)
    if velocity.y == 0 then
      velocity.x = 0
      finiteStateMachine:setState("lyingDown", 1)
      animationClip:setAnimation("lyingDown")
    elseif velocity.y > 5000 then
      love.load()
    end
  end,

  lyingDown = function (_, _, finiteStateMachine, _, _, animationClip, living)
    if finiteStateMachine.stateTime == 0 then
      if living.health == 0 then
        love.load()
      else
        finiteStateMachine:setState("gettingUp")
        animationClip:setAnimation("gettingUp")
        living.stamina = 100
      end
    end
  end,

  gettingUp = function (_, _, finiteStateMachine, _, _, animationClip, _)
    if animationClip.done then
      finiteStateMachine:setState("idle")
    end
  end,

  descend = function(componentsTable, entity, finiteStateMachine, _, _, _, _)
    componentsTable.collisionBoxes[entity].reactingWithClouds = false
    finiteStateMachine:setState("idle")
  end,
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
      local living = componentsTable.living[entity]
      components.assertExistence(entity, "player", {velocity, "velocity",
                                 {animationClip, "animationClip"},
                                 {finiteStateMachine, "finiteStateMachine"},
                                 {living, "living"}})
      local runStateLogic = statesLogic[finiteStateMachine.currentState]
      runStateLogic(componentsTable, entity, finiteStateMachine, input, velocity,
                    animationClip, living)
    end 
  end
end


function playerAfterTerrainCollisionChecking(componentsTable)
  components.assertDependency(componentsTable, "players", "velocities")

  -- This for loop could be avoided if there is only one entity with a "player"
  -- component.
  for entity, player in pairs(componentsTable.players or {}) do
    local velocity = componentsTable.velocities[entity]
    local animationClip = componentsTable.animationClips[entity]
    local finiteStateMachine = componentsTable.finiteStateMachines[entity]
    components.assertExistence(entity, "player", {velocity, "velocity",
                               {animationClip, "animationClip"},
                               {finiteStateMachine, "finiteStateMachine"}})
    if finiteStateMachine.currentState == "idle" and velocity.x == 0 and
       velocity.y == 0 then
      animationClip:setAnimation("standing")
    end
  end
end
