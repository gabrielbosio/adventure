module("drawings", package.seeall)


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

  for i, corners in ipairs(cornersArray or {}) do
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


-- Shapes
function boundaries(cornersArray)
  terrainShape(cornersArray,
    function (corners)
      box{x1 = corners[1], y1 = corners[2], x2 = corners[3], y2 = corners[4]}
    end, 0, 0.3, 0)
end

function clouds(cornersArray)
  terrainShape(cornersArray,
    function (corners)
      local cloudHeightDisplay = 10
      box{x1 = corners[1], y1 = corners[2], x2 = corners[3],
          y2 = corners[2] + cloudHeightDisplay}
    end, 0.3, 0.6, 1)
end

function slopes(cornersArray)
  terrainShape(cornersArray,
    function (corners)
      rightTriangle{x1 = corners[1], y1 = corners[2], x2 = corners[3],
        y2 = corners[4]}
    end, 0, 0.3, 0)
end

function collisionBoxes(boxes, positions)
  -- Player box
  boxShape(boxes, positions, 0, 0, 1)

  -- Origin
  love.graphics.setColor(1, 1, 0)

  for entity, box in pairs(boxes or {}) do
    local position = positions[entity]
    love.graphics.circle("fill", position.x, position.y, 2)
  end
end

function attackBoxes(animationClips, positions)

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

      -- Origin
      love.graphics.setColor(1, 1, 0)
      love.graphics.circle("fill", position.x, position.y, 2)
    end
  end
end

function goals(goals, positions)
  boxShape(goals, positions, 0.5, 1, 0.5)
end

function medkits(medkits, positions)
  boxShape(medkits, positions, 1, 0, 0)
end

function pomodori(pomodori, positions)
  boxShape(pomodori, positions, 0.5, 0.5, 0.5)
end
