require("outline.drawings")
require("outline.display")

--- Debug module
-- I could not name this module "debug" because there is already a library
-- named "debug" in lua.
module("outline", package.seeall)


function draw(componentsTable, terrain)
  local r, g, b = love.graphics.getColor()

  local translated
  for entity, camera in pairs(componentsTable.cameras) do  -- BEAUTIFY THIS
    local position = componentsTable.positions[entity]
    components.assertExistence(entity, "camera", {position, "position"})

    -- Translate boundaries
    translated = {}
    for i, boundary in ipairs(terrain.boundaries or {}) do
      translated[#translated + 1] = {
        boundary[1] - position.x, boundary[2] + position.y,
        boundary[3] - position.x, boundary[4] + position.y
      }
    end
    drawings.boundaries(translated)

    -- Translate clouds
    translated = {}
    for i, cloud in ipairs(terrain.clouds or {}) do
      translated[#translated + 1] = {
        cloud[1] - position.x, cloud[2] + position.y,
        cloud[3] - position.x
      }
    end
    drawings.clouds(translated)

    -- Translate slopes
    translated = {}
    for i, slope in ipairs(terrain.slopes or {}) do
      translated[#translated + 1] = {
        slope[1] - position.x, slope[2] + position.y,
        slope[3] - position.x, slope[4] + position.y
      }
    end
    drawings.slopes(translated)

    -- Translate boxes
    translated = {}
    for otherEntity, otherPosition in pairs(componentsTable.positions) do
      if (otherEntity ~= entity) then
        translated[otherEntity] = {
          x = otherPosition.x - position.x,
          y = otherPosition.y + position.y
        }
      end
    end
    drawings.collisionBoxes(componentsTable.collisionBoxes, translated)
    drawings.goals(componentsTable.goals, translated)
    drawings.medkits(componentsTable.healing, translated)
    drawings.pomodori(componentsTable.experienceEffect, translated)
  end

  -- Reset drawing color
  love.graphics.setColor(r, g, b)
end


function debug(componentsTable)
  local r, g, b = love.graphics.getColor()

  display.add(
    "mouse",
    function ()
      return love.mouse.getX() .. ", " .. love.mouse.getY()
    end,
    nil,
    1, 1, 1
  )
  display.add(
    "player",
    function (position)
      return math.floor(position.x) .. "," .. math.floor(position.y)
    end,
    componentsTable.positions.megasapi,
    1, 1, 0
  )
  display.add(
    "health",
    function (value)
      return tostring(value)
    end,
    componentsTable.living.megasapi.health,
    1, 0, 0
  )
  display.add(
    "experience",
    function (value)
      return tostring(value)
    end,
    componentsTable.players.megasapi.experience,
    0.5, 0.5, 0.5
  )
  display.add(
    "stamina",
    function (value)
      return tostring(value)
    end,
    componentsTable.living.megasapi.stamina,
    0, 1, 0
  )

  -- Reset drawing color
  love.graphics.setColor(r, g, b)
end
