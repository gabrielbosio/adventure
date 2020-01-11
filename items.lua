require("components")
module("items", package.seeall)


function healthSupply(componentsTable)
  -- healing depends on living and player
  components.assertComponentsDependency(componentsTable, "healing", "living", "player")

  for entity, player in pairs(componentsTable.players) do
  end
end
