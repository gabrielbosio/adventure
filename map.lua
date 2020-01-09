module("map", package.seeall)

terrain = {
  boundaries = {
    {-5, -100, 5, 605},			-- left
    --{-5, -5, 805, 5},		  -- top
    {-5, 530, 805, 605},	-- bottom
    {795, -100, 805, 605}, 	-- right
    -- Platforms
    --{5, 249, 123, 300},
    {620, 216, 740, 250},
    {120, 165, 206, 186},
    -- slope extension
    {5, 505, 90, 530},
    {630, 430, 795, 605}
  },
  clouds = {
    {326, 120, 400},
    {392, 260, 480},
  },
  slopes = {
    --{75, 35, 0, 0},
    {500, 530, 630, 430},
    {200, 530, 90, 505},
    --{230, 380, 280, 450},
    --{460, 420, 400, 500},
    --{720, 90, 795, 0},
  }
}

function draw()
  love.graphics.setColor(0, 0.5, 0)
  for i in pairs(terrain.boundaries) do
    local boundaries = terrain.boundaries[i]
    love.graphics.polygon("fill", boundaries[1], boundaries[2], boundaries[3],
      boundaries[2], boundaries[3], boundaries[4], boundaries[1], boundaries[4])
  end

  for i in pairs(terrain.slopes) do
    local slopes = terrain.slopes[i]
    love.graphics.polygon("fill", slopes[1], slopes[2], slopes[3], slopes[2],
      slopes[3], slopes[4])
  end

  love.graphics.setColor(0.3, 0.6, 1)
  for i in pairs(terrain.clouds) do
    local clouds = terrain.clouds[i]
    love.graphics.polygon("fill", clouds[1], clouds[2], clouds[3], clouds[2],
      clouds[3], clouds[2] + cloudHeightDisplay, clouds[1],
      clouds[2] + cloudHeightDisplay)
  end
end
