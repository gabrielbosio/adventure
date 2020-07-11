local components = require "components"

local M = {}

function M.collision(componentsTable)
	components.assertDependency(componentsTable, "animationClips", "positions")

  for attacker, animationClip in pairs(componentsTable.animationClips or {}) do
    local attackerPosition = componentsTable.positions[attacker]
    components.assertExistence(attacker, "animationClip", {attackerPosition, "position"})
    local currentAnimation = animationClip.animations[animationClip.nameOfCurrentAnimation]
    local attackBox = currentAnimation.frames[animationClip:currentFrameNumber()].attackBox

    if attackBox ~= nil then
      components.assertDependency(componentsTable, "collisionBoxes", "positions")

      for attackee, collisionBox in pairs(componentsTable.collisionBoxes or {}) do
        local attackeePosition = componentsTable.positions[attackee]
        components.assertExistence(attackee, "collisionBox", {attackeePosition, "position"})
        if attackee ~= attacker then
          local translatedAttackBox = attackBox:translated(attackerPosition, animationClip)
          local translatedCollisionBox = collisionBox:translated(attackeePosition)

          if translatedAttackBox:intersects(translatedCollisionBox) then
            local direction = attackerPosition.x <= attackeePosition.x and 1 or -1
            componentsTable.velocities[attackee].x = 100 * direction
          end
        end
      end
    end
  end
end

return M
