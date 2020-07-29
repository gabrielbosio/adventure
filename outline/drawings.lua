--- Utility for debugging that draws coloured shapes on screen.
local M = {}


-- Subroutines
local function box(corners)
  love.graphics.polygon("fill", corners.x1, corners.y1, corners.x2, corners.y1,
                        corners.x2, corners.y2, corners.x1, corners.y2)
end

local function rightTriangle(corners)
  -- Horizontal side first
  love.graphics.polygon("fill", corners.x1, corners.y1, corners.x2, corners.y1,
                        corners.x2, corners.y2)
end

local function terrainShape(cornersArray, subroutine, red, green, blue)
  love.graphics.setColor(red, green, blue)

  for _, corners in ipairs(cornersArray or {}) do
    subroutine(corners)
  end
end

local function boxShape(boxes, positions, red, green, blue)
  love.graphics.setColor(red, green, blue)

  for entity, box in pairs(boxes or {}) do
    local position = positions[entity]
    local translatedBox = box:translated(position)

    love.graphics.rectangle("fill", translatedBox:left(), translatedBox:top(),
                            translatedBox.width, translatedBox.height)
  end
end


--- Draw green coloured rectangles that represent terrain boundaries.
-- @tparam table cornersArray the corners of the rectangle (`x1`, `y1`, `x2`, `y2`)
function M.boundaries(cornersArray)
  terrainShape(cornersArray,
    function (corners)
      box{x1 = corners[1], y1 = corners[2], x2 = corners[3], y2 = corners[4]}
    end, 0, 0.3, 0)
end

--- Draw light blue lines that represent cloud-like platforms.
-- @tparam table cornersArray the corners of the line (`x1`, `y1`, `x2`)
function M.clouds(cornersArray)
  terrainShape(cornersArray,
    function (corners)
      local cloudHeightDisplay = 10
      box{x1 = corners[1], y1 = corners[2], x2 = corners[3],
          y2 = corners[2] + cloudHeightDisplay}
    end, 0.3, 0.6, 1)
end

--- Draw green coloured triangles that represent terrain boundaries.
-- @tparam table cornersArray the corners of the triangle (`x1`, `y1`, `x2`, `y2`)
function M.slopes(cornersArray)
  terrainShape(cornersArray,
    function (corners)
      rightTriangle{x1 = corners[1], y1 = corners[2], x2 = corners[3],
        y2 = corners[4]}
    end, 0, 0.3, 0)
end

--[[--
 Draw blue coloured boxes that represent collision boxes.

 A little yellow point is also drawn.
 Each point is the position of the corresponding box, as used in `main.lua`.

 @tparam table boxes reference to the main collisionBoxes table
 @tparam table positions reference to the main positions table
]]
function M.collisionBoxes(boxes, positions)
  boxShape(boxes, positions, 0, 0, 1)  -- draw collision boxes

  -- Origin
  love.graphics.setColor(1, 1, 0)
  for entity, _ in pairs(boxes or {}) do
    local position = positions[entity]
    love.graphics.circle("fill", position.x, position.y, 2)
  end
end

--[[--
 Draw red coloured boxes that represent attack boxes.

 @tparam table animationClips reference to the main animationClips table
 @tparam table positions reference to the main positions table
]]
function M.attackBoxes(animationClips, positions)

  for entity, animationClip in pairs(animationClips) do
    local currentAnimation = animationClip.animations[animationClip.nameOfCurrentAnimation]
    local attackBox = currentAnimation.frames[animationClip:currentFrameNumber()].attackBox

    if attackBox ~= nil then
      local position = positions[entity]
      local translatedBox = attackBox:translated(position, animationClip)
      -- Box
      love.graphics.setColor(1, 0, 0)
      love.graphics.rectangle("fill", translatedBox:left(), translatedBox:top(),
                              translatedBox.width, translatedBox.height)
    end
  end
end

--[[--
 Draw coloured boxes that represent goals.

 @tparam table goals reference to the main goals table
 @tparam table positions reference to the main positions table
]]
function M.goals(goals, positions)
  boxShape(goals, positions, 0.5, 1, 0.5)
end

--[[--
 Draw coloured boxes that represent medkit items.

 Medkits heal the player when collected.

 @tparam table medkits reference to the main medkits table
 @tparam table positions reference to the main positions table
]]
function M.medkits(medkits, positions)
  boxShape(medkits, positions, 1, 0, 0)
end

--[[--
 Draw coloured boxes that represent pomodoro items.

 Pomodori give experience when collected.

 @tparam table pomodori reference to the main pomodori table
 @tparam table positions reference to the main positions table
]]
function M.pomodori(pomodori, positions)
  boxShape(pomodori, positions, 0.5, 0.5, 0.5)
end

return M
