require("components")
module("items", package.seeall)


function load(componentsTable, currentLevel, ...)
  local amount = 1 -- currentLevel.entitiesData could store this

  local componentGroup = {
    ["medkits"] = "healing",
    ["pomodori"] = "experienceEffect"
  }

  for i, itemGroupName in ipairs{...} do
    local group = componentsTable[componentGroup[itemGroupName]]

    for itemIndex, itemData in pairs(currentLevel.entitiesData[itemGroupName]) do
      local id = itemGroupName .. tostring(itemIndex)
      componentsTable.positions[id] = {x = itemData[1], y = itemData[2]}
      -- if type(componentGroup[itemGroupName]) ~= "table"  -- several effects
      group[id] = amount
    end
  end
end

function healthSupply(componentsTable)
  -- healing depends on living, player and position
  components.assertDependency(componentsTable, "healing", "living",
                                        "players", "positions")

  for entity, player in pairs(componentsTable.players) do
    local position = componentsTable.positions[entity]
    local collisionBox = componentsTable.collisionBoxes[entity]
    local livingEntities = componentsTable.living[entity]
    components.assertExistence(entity, "player", {position, "position"},
                               {collisionBox, "collisionBox"},
                               {livingEntities, "living"})
    local health = componentsTable.living[entity].health
    components.assertExistence(entity, "player", {health, "health"})
    
    for itemEntity, amount in pairs(componentsTable.healing or {}) do
      local itemPosition = componentsTable.positions[itemEntity]

    end
  end
end
