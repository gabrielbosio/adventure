require("components")
require("components.box")
module("items", package.seeall)


-- Link names in levels.lua to components in componentsTable
-- In other words, link each item name to its effect.
local componentGroup = {
  ["medkits"] = "healing",
  ["pomodori"] = "experienceEffect",
  -- ["my item"] = {"healing", "experienceEffect"}  -- several effects
}

function load(componentsTable, currentLevel)
  for itemGroupName, entity in pairs(componentGroup) do
    componentsTable[componentGroup[itemGroupName]] = {}
    local group = componentsTable[entity]

    for itemIndex, itemData in pairs(currentLevel.entitiesData[itemGroupName] or {}) do
      local id = itemGroupName .. tostring(itemIndex)
      componentsTable.positions[id] = {x = itemData[1], y = itemData[2]}
      -- if type(componentGroup[itemGroupName]) == "table"  -- several effects
      group[id] = box.ItemBox:new{effectAmount = 1}  -- hard-coded
    end
  end
end


function reload(componentsTable, nextLevel)
  -- Reload absolutely all components in the next level
  local names = {}

  -- Look for components in the componentGroup table
  for name in pairs(componentGroup) do
    names[#names + 1] = name
  end

  load(componentsTable, nextLevel, unpack(names))
end


local function healthSupply(componentsTable)
  -- healing depends on living, player and position
  components.assertDependency(componentsTable, "healing", "living",
                                        "players", "positions")

  for entity, player in pairs(componentsTable.players) do
    local collector = componentsTable.collectors[entity]

    if collector then
      local position = componentsTable.positions[entity]
      local collisionBox = componentsTable.collisionBoxes[entity]
      local livingEntities = componentsTable.living[entity]
      components.assertExistence(entity, "player", {position, "position"},
                                 {collisionBox, "collisionBox"},
                                 {livingEntities, "living"})
      local box = collisionBox:translated(position)

      local parameter = componentsTable.living[entity].health
      components.assertExistence(entity, "player", {parameter, "health"})

      for itemEntity, itemBox in pairs(componentsTable.healing or {}) do
        local itemPosition = componentsTable.positions[itemEntity]

        if itemBox:translated(itemPosition):intersects(box) then
          livingEntities.health = parameter + itemBox.effectAmount
          positions = nil
          componentsTable.healing[itemEntity] = nil
        end

      end
    end -- if collector
  end
end



local function experienceSupply(componentsTable)
  -- experienceEffect depends on player and position
  components.assertDependency(componentsTable, "experienceEffect", "players",
                              "positions")

  for entity, player in pairs(componentsTable.players) do
    local collector = componentsTable.collectors[entity]

    if collector then
      local position = componentsTable.positions[entity]
      local collisionBox = componentsTable.collisionBoxes[entity]
      components.assertExistence(entity, "player", {position, "position"},
                                 {collisionBox, "collisionBox"})
      local box = collisionBox:translated(position)

      local parameter = player.experience

      for itemEntity, itemBox in pairs(componentsTable.experienceEffect or {})
          do
        local itemPosition = componentsTable.positions[itemEntity]

        if itemBox:translated(itemPosition):intersects(box) then
          player.experience = parameter + itemBox.effectAmount
          positions = nil
          componentsTable.experienceEffect[itemEntity] = nil
        end

      end
    end
  end
end


function update(componentsTable)
  healthSupply(componentsTable)
  experienceSupply(componentsTable)
end
