module("components", package.seeall)


function assertDependency(componentsTable, dependentComponentName, ...)
  if componentsTable[dependentComponentName] ~= nil then
    for _, nameToAssert in ipairs{...} do
      if componentsTable[nameToAssert] == nil then
        error([[Unsatisfied dependency in componentsTable.
          There is at least one component inside "]] .. dependentComponentName
          ..  '" but no component inside "' .. nameToAssert .. '".')
      end
    end
  end
end


function assertExistence(entity, existingComponentName, ...)
  for _, pairToAssert in ipairs{...} do
    componentToAssert, nameToAssert = pairToAssert[1], pairToAssert[2]
    assert(componentToAssert ~= nil,
            "Entity " .. entity .. " has " .. existingComponentName ..
            " component but has not " .. nameToAssert .. " component")
  end
end
