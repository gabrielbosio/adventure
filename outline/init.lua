--[[--
 Debug module.

 I could not name this module "debug" because there is already
 [a library named <code>debug</code> in <code>lua</code>.](https://www.lua.org/manual/5.4/manual.html#6.10)

 This module loads `outline.drawings` and `outline.display` for local use.
]]

local drawings = require "outline.drawings"
local display = require "outline.display"


local M = {}


--[[--
 Draw shapes that represent components and terrain properties on screen.

 @tparam table componentsTable a reference to the components table
 @tparam table positions it must have the `terrain` and `components` fields.

  This table may be generated particularly by the `systems.camera.positions`
  function.
]]
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

--[[--
 Display text with information for debugging on screen.

 @tparam table componentsTable a reference to the components table
]]
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
