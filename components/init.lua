module("components", package.seeall)


function assertDependency(componentsTable, dependentComponentName, ...)
  if componentsTable[dependentComponentName] then
    for i, nameToAssert in ipairs{...} do
      if not componentsTable[nameToAssert] then
        error([[Unsatisfied dependency in componentsTable.
          There is at least one component inside "]] .. dependentComponentName
          ..  '" but no component inside "' .. nameToAssert .. '".')
      end
    end
  end
end


function assertExistence(entity, existingComponentName, ...)
  for i, pairToAssert in ipairs{...} do
    componentToAssert, nameToAssert = pairToAssert[1], pairToAssert[2]
    assert(componentToAssert,
            "Entity " .. entity .. " has " .. existingComponentName ..
            " component but has not " .. nameToAssert .. " component")
  end
end
