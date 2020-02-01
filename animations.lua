-- Animation = {frames, loop}
-- Frame = {sprite, duration}

animations = {
  megasapi = {
    standing = {{{1, 0.4}, {2, 0.4}}, true},
    walking = {{{3, 0.05}, {4, 0.05}, {5, 0.05}, {6, 0.05}, {7, 0.05}, {8, 0.05}, {9, 0.05},
				{10, 0.05}, {11, 0.05}, {12, 0.05}, {13, 0.05}}, true},
	startingJump = {{{2, 0.08}, {14, 0.03}}, false},
	jumping = {{{15, 1}}, false}
  }
}
