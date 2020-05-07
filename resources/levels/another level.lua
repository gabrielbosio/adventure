{
  terrain = {
    boundaries = {
      -- {x1, y1, x2, y2}

      -- Main (level delimiters)
      {-5, 580, 805, 605},
      {-5, -50, 5, 605},
      {795, -50, 805, 605},

      -- Slope extensions
      {480, 480, 805, 605},
      {100, 300, 320, 140},

      -- Flying platforms
      {100, 300, 620, 320},
    },

    clouds = {
      {620, 300, 805, 320},
    },

    slopes = {
      {320, 580, 480, 480},
      {480, 300, 320, 140}
    },
  },
  entitiesData = {
    player = {55, 425},  -- {x, y}
    goals = {
      {50, 290, "test"}
    }
  },
}
