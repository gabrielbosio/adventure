local drawings = require "outline.drawings"
local display = require "outline.display"

--- Debug module
-- I could not name this module "debug" because there is already a library
-- named "debug" in lua.
local M = {}


function M.draw(componentsTable, positions)
  local r, g, b = love.graphics.getColor()

    -- Move terrain
    position = positions.terrain
    drawings.boundaries(position.boundaries)
    drawings.clouds(position.clouds)
    drawings.slopes(position.slopes)

    -- Move boxes
    position = positions.components
    drawings.collisionBoxes(componentsTable.collisionBoxes, position)
    drawings.attackBoxes(componentsTable.animationClips, position)
    drawings.goals(componentsTable.goals, position)
    drawings.medkits(componentsTable.healing, position)
    drawings.pomodori(componentsTable.experienceEffect, position)

  -- Reset drawing color
  love.graphics.setColor(r, g, b)
end


function M.debug(componentsTable)
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
  display.add(
    "vcam",
    function (position)
      return math.floor(position.x) .. "," .. math.floor(position.y)
    end,
    componentsTable.positions.vcam,
    0.556863, 0.333333, 0.556863
  )

  -- Reset drawing color
  love.graphics.setColor(r, g, b)
end

return M
