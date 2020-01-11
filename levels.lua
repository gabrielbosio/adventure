module("levels", package.seeall)


level = {
  ["test"] = {
    terrain = {
      boundaries = {
        -- Main (level delimiters)
        {-5, -100, 5, 605},			-- left
        {-5, 530, 805, 605},	-- bottom
        {795, -100, 805, 605}, 	-- right

        -- Platforms
        {620, 216, 740, 250},
        {120, 165, 206, 186},

        -- Slope extension
        {5, 505, 90, 530},
        {630, 430, 795, 605}
      },
      clouds = {
        {326, 120, 400},
        {392, 260, 480},
      },
      slopes = {
        {500, 530, 630, 430},
        {200, 530, 90, 505},
      }
    },
    entitiesData = {
      player = {46, 142},
      goal = {712, 430, "another level"}
    }
  },

  ["another level"] = {
    terrain = {
      boundaries = {
        {0, 500, 800, 600}
      }
    },
    entitiesData = {
      player = {400, 300}
    }
  }
}

first = "test"  -- the game loads this level at start


-- Outline drawing
cloudHeightDisplay = 10

function drawBox(corners)
  love.graphics.polygon("fill", corners.x1, corners.y1, corners.x2, corners.y1,
                        corners.x2, corners.y2, corners.x1, corners.y2)
end

function drawRightTriangle(corners)
  love.graphics.polygon("fill", corners.x1, corners.y1, corners.x2, corners.y1,
                        corners.x2, corners.y2)
end

-- We could move this to a "debug" module
function drawTerrainOutline()
  love.graphics.setColor(0, 0.5, 0)
  for i in pairs(levels.level["test"].terrain.boundaries) do
    local boundaries = levels.level["test"].terrain.boundaries[i]
    drawBox{x1 = boundaries[1], y1 = boundaries[2], x2 = boundaries[3],
            y2 = boundaries[4]}
  end

  for i in pairs(levels.level["test"].terrain.slopes) do
    local slopes = levels.level["test"].terrain.slopes[i]
    drawRightTriangle{x1 = slopes[1], y1 = slopes[2], x2 = slopes[3],
                      y2 = slopes[4]}
  end

  love.graphics.setColor(0.3, 0.6, 1)
  for i in pairs(levels.level["test"].terrain.clouds) do
    local clouds = levels.level["test"].terrain.clouds[i]
    drawBox{x1 = clouds[1], y1 = clouds[2], x2 = clouds[3],
            y2 = clouds[2] + cloudHeightDisplay}
  end
end
