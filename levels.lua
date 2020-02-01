module("levels", package.seeall)


level = {
  ["test"] = {
    terrain = {
      boundaries = {
        -- {x1, y1, x2, y2}

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
      player = {46, 250},  -- {x, y}
      goals = {  -- {x, y, newLevelID}
        --{740, 430, "another level"},
        {740, 20, "secret"},
      },
      medkits = {  -- {x, y}
        {45, 50},
        {280, 260},
      },
      pomodori = {
        {230, 500},
        {270, 500},
        {310, 500},
        {350, 500},
        {390, 500},
        {430, 500},
        {470, 500},
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

  ["secret"] = {
    terrain = {
      boundaries = {
        {300, 200, 500, 300}
      }
    },
    entitiesData = {
      player = {400, 100},
      goals = {
        {555, 200, "test"}
      }
    }
  },
}

first = "test"  -- the game loads this level at start
