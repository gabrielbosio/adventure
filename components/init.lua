local M = {}


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


function M.assertExistence(entity, existingComponentName, ...)
  for _, pairToAssert in ipairs{...} do
    componentToAssert, nameToAssert = pairToAssert[1], pairToAssert[2]
    assert(componentToAssert,
            "Entity " .. entity .. " has " .. existingComponentName ..
            " component but has not " .. nameToAssert .. " component")
  end
end

return M
