--[[
     This file was automatically generated by genlvl.
     Edit *.lua files in "resources/levels".  
     Don't edit this one: any change you make here will be overwritten.
  ]]
module("levels", package.seeall)


level = {
  ["another level"] = {
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
  },

  ["secret"] = {
    terrain = {
      boundaries = {
        {300, 200, 500, 300}
      },
    },
    entitiesData = {
      player = {400, 200},
      goals = {
        {555, 200, "test"}
      }
    }
  },

  ["test"] = {
    terrain = {
      boundaries = {
        -- {x1, y1, x2, y2}
  
        -- Main (level delimiters)
        {-5, -100, 5, 605},     -- left
        {-5, 530, 805, 605},	  -- bottom
        {795, -100, 805, 605}, 	-- right
  
        -- Platforms
        {660, 216, 740, 250},
        {120, 165, 206, 186},
  
        -- Slope extension
        {5, 505, 90, 530},
        {630, 430, 795, 605}
      },
      clouds = {
        {326, 120, 400},
        {392, 260, 480},
        {392, 360, 480},
      },
      slopes = {
        {500, 530, 630, 430},
        {200, 530, 90, 505},
      }
    },
    entitiesData = {
      player = {46, 250},  -- {x, y}
      goals = {  -- {x, y, newLevelID}
        {700, 15, "secret"},
        {163, 166, "another level"},
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

}

first = "test"