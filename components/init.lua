--- Helper functions for component assertions.
local M = {}


--[[--
 Define a component dependency and check that it can be satisfied.

 Raise an error when the dependent component exists but the components this one
 depends on do not exist.

 @tparam table componentsTable look for components in this table
 @tparam string dependentComponentName the name of the dependent component
 @param ... names of the components the `dependentComponentName` depends on

 @usage
  -- "healing" component depends on "living", "players" and "positions"
  assertDependency(componentsTable, "healing", "living", "players", "positions")
]]
function M.assertDependency(componentsTable, dependentComponentName, ...)
  if componentsTable[dependentComponentName] then
    for _, nameToAssert in ipairs{...} do
      if not componentsTable[nameToAssert] then
        error([[Unsatisfied dependency in componentsTable.
          There is at least one component inside "]] .. dependentComponentName
          ..  '" but no component inside "' .. nameToAssert .. '".')
      end
    end
  end
end


--[[--
 Check that some components exist.

 @tparam string entity the entity, i. e., an existing field of the `componentsTable`
 @tparam string existingComponentName `existingComponentName[entity]` should exist
 @param ... ordered pairs (`{component, name}`) to check.

  This function iterates through each pair and checks if `component` is not `nil`.
  If one of them is `nil`, the function raises an error and uses all the given
  arguments to display a message with the precise location of the fault.

 @usage
  assertExistence(entity, "player", {position, "position"},
                  {collisionBox, "collisionBox"}, {velocity, "velocity"})
]]
function M.assertExistence(entity, existingComponentName, ...)
  for _, pairToAssert in ipairs{...} do
    componentToAssert, nameToAssert = pairToAssert[1], pairToAssert[2]
    assert(componentToAssert,
            "Entity " .. entity .. " has " .. existingComponentName ..
            " component but has not " .. nameToAssert .. " component")
  end
end

return M
