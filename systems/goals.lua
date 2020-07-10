require("components")
require("components.box")
module("goals", package.seeall)


function load(componentsTable, currentLevel)
  components.assertDependency(componentsTable, "goals", "positions")

  for goalIndex, goalData in pairs(currentLevel.entitiesData.goals or {}) do
    local id = "goal" .. tostring(goalIndex)
    componentsTable.positions[id] = {x = goalData[1], y = goalData[2]}
    componentsTable.goals[id] = box.GoalBox:new{
      width = 110,
      height = 110,
      nextLevel = goalData[3]
    }
  end
end


function update(componentsTable, currentLevel)
  local nextLevel = currentLevel

  for entity, player in pairs(componentsTable.players or {}) do
    local collector = componentsTable.collectors[entity]

    if collector then
      local position = componentsTable.positions[entity]
      local velocity = componentsTable.velocities[entity]
      local collisionBox = componentsTable.collisionBoxes[entity]
      components.assertExistence(entity, "player", {position, "position"},
                                  {collisionBox, "collisionBox"}, {velocity, "velocity"})

      local box = collisionBox:translated(position)

      for goalEntity, goalBox in pairs(componentsTable.goals or {}) do
        local goalPosition = componentsTable.positions[goalEntity]

        if goalBox:translated(goalPosition):intersects(box) then
          nextLevel = levels.level[goalBox.nextLevel]

          -- Player position loading and movement restore
          position.x = nextLevel.entitiesData.player[1][1]
          position.y = nextLevel.entitiesData.player[1][2]
          velocity.x = 0
          velocity.y = 0

          -- Reload goals and items
          items.reload(componentsTable, nextLevel)

          for _id in pairs(componentsTable.goals) do
            componentsTable.positions[_id] = nil
            componentsTable.goals[_id] = nil
          end

          if nextLevel.entitiesData.goals then
            goals.load(componentsTable, nextLevel)
          end

          break
        end
      end -- for goalEntity
    end

  end -- for entity, player

  return nextLevel
end
