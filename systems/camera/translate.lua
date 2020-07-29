--- Calculation of translated positions for display.
local components = require "components"

local M = {}


--- Return a table with the translated positions of all components
-- @param positions a table with the original positions of the components
-- @param vcamEntity key of the componentsTable that refers to a camera
-- @param vcamPosition a table that refers to the vcamEntity position
function M.boxes(positions, vcamEntity, vcamPosition)
  local translatedPositions = {}

  for entity, position in pairs(positions or {}) do
    if vcamEntity ~= entity then
      components.assertExistence(vcamEntity, "camera",
                                 {vcamPosition, "position"})
      translatedPositions[entity] = {
        x = position.x - vcamPosition.x,
        y = position.y + vcamPosition.y
      }
    end
  end

  return translatedPositions
end

--- Return a table with the translated positions of all the terrain elements
-- @param positions a table with the original positions of the elements
-- @param vcamPosition a table that refers to a vcamEntity position
function M.terrain(positions, vcamPosition)
  local translatedPositions = {
    boundaries = {},
    clouds = {},
    slopes = {}
  }

  for _, boundary in ipairs(positions.boundaries or {}) do
    table.insert(translatedPositions.boundaries, {
      boundary[1] - vcamPosition.x, boundary[2] + vcamPosition.y,
      boundary[3] - vcamPosition.x, boundary[4] + vcamPosition.y
    })
  end

  for _, cloud in ipairs(positions.clouds or {}) do
    table.insert(translatedPositions.clouds, {
      cloud[1] - vcamPosition.x, cloud[2] + vcamPosition.y,
      cloud[3] - vcamPosition.x
    })
  end

  for _, slope in ipairs(positions.slopes or {}) do
    table.insert(translatedPositions.slopes, {
      slope[1] - vcamPosition.x, slope[2] + vcamPosition.y,
      slope[3] - vcamPosition.x, slope[4] + vcamPosition.y
    })
  end

  return translatedPositions
end

return M
