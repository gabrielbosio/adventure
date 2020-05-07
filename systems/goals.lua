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
