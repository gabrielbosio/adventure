module("levels", package.seeall)

levels = {
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
    entities = {
      player = {46, 142}
    }
  },

  ["another level"] = {
    terrain = {
      boundaries = {
        {0, 500, 800, 600}
      }
    },
    entities = {
      player = {400, 300}
    }
  }
}

cloudHeightDisplay = 10


function drawBoxes()
  love.graphics.setColor(0, 0.5, 0)
  for i in pairs(levels["test"].terrain.boundaries) do
    local boundaries = levels["test"].terrain.boundaries[i]
    love.graphics.polygon("fill", boundaries[1], boundaries[2], boundaries[3],
      boundaries[2], boundaries[3], boundaries[4], boundaries[1], boundaries[4])
  end

  for i in pairs(levels["test"].terrain.slopes) do
    local slopes = levels["test"].terrain.slopes[i]
    love.graphics.polygon("fill", slopes[1], slopes[2], slopes[3], slopes[2],
      slopes[3], slopes[4])
  end

  love.graphics.setColor(0.3, 0.6, 1)
  for i in pairs(levels["test"].terrain.clouds) do
    local clouds = levels["test"].terrain.clouds[i]
    love.graphics.polygon("fill", clouds[1], clouds[2], clouds[3], clouds[2],
      clouds[3], clouds[2] + cloudHeightDisplay, clouds[1],
      clouds[2] + cloudHeightDisplay)
  end
end
