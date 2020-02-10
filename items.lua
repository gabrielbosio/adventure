require("components")
module("items", package.seeall)


function load(componentsTable, currentLevel, ...)
  local amount = 1 -- currentLevel.entitiesData could store this

  local componentGroup = {
    ["medkits"] = "healing",
    ["pomodori"] = "experienceEffect"
  }

  for i, itemGroupName in ipairs{...} do
    componentsTable[componentGroup[itemGroupName]] = {}
    local group = componentsTable[componentGroup[itemGroupName]]

    for itemIndex, itemData in pairs(currentLevel.entitiesData[itemGroupName] or {}) do
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
    local collector = componentsTable.collectors[entity]

    if collector ~= nil then
      local position = componentsTable.positions[entity]
      local collisionBox = componentsTable.collisionBoxes[entity]
      local livingEntities = componentsTable.living[entity]
      components.assertExistence(entity, "player", {position, "position"},
                                 {collisionBox, "collisionBox"},
                                 {livingEntities, "living"})
      local parameter = componentsTable.living[entity].health
      components.assertExistence(entity, "player", {parameter, "health"})

      for itemEntity, amount in pairs(componentsTable.healing or {}) do
        local itemPosition = componentsTable.positions[itemEntity]

        local ITEM_SIZE = 10  -- maybe access it from outline.lua?

        if position.x + collisionBox.width/2 >= itemPosition.x - ITEM_SIZE/2
            and position.x - collisionBox.width/2 <= itemPosition.x + ITEM_SIZE/2
            and position.y >= itemPosition.y - ITEM_SIZE
            and position.y - collisionBox.height <= itemPosition.y then
          livingEntities.health = parameter + amount
          positions = nil
          componentsTable.healing[itemEntity] = nil
        end

      end
    end -- if collector ~= nil
  end
end



function experienceSupply(componentsTable)
  -- experienceEffect depends on player and position
  components.assertDependency(componentsTable, "experienceEffect", "players",
                              "positions")

  for entity, player in pairs(componentsTable.players) do
    local collector = componentsTable.collectors[entity]

    if collector ~= nil then
      local position = componentsTable.positions[entity]
      local collisionBox = componentsTable.collisionBoxes[entity]
      components.assertExistence(entity, "player", {position, "position"},
                                 {collisionBox, "collisionBox"})
      local parameter = player.experience

      for itemEntity, amount in pairs(componentsTable.experienceEffect or {}) do
        local itemPosition = componentsTable.positions[itemEntity]

        local ITEM_SIZE = 10  -- maybe access it from outline.lua?

        if position.x + collisionBox.width/2 >= itemPosition.x - ITEM_SIZE/2
            and position.x - collisionBox.width/2 <= itemPosition.x + ITEM_SIZE/2
            and position.y >= itemPosition.y - ITEM_SIZE
            and position.y - collisionBox.height <= itemPosition.y then
          player.experience = parameter + amount
          positions = nil
          componentsTable.experienceEffect[itemEntity] = nil
        end

      end
    end
  end
end
