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
      goals = {
        {740, 430, "another level"},
        {740, 20, "secret level"},
      }
    }
  },

  ["another level"] = {
    terrain = {
      boundaries = {
        {0, 500, 800, 600}
      }
    },
    entitiesData = {
      player = {400, 450}
    }
  },

  ["secret level"] = {
    terrain = {
      boundaries = {
        {300, 200, 500, 300}
      }
    },
    entitiesData = {
      player = {400, 100}
    }
  },
}

first = "test"  -- the game loads this level at start
