-- Animation = {frames, loop}
-- Frame = {sprite, duration, attackBox}
-- AttackBox = {x, y, width, height}

animations = {
  megasapi = {
    standing = {{{1, 0.4}, {2, 0.4}}, true},
    walking = {{{3, 0.05}, {4, 0.05}, {5, 0.05}, {6, 0.05}, {7, 0.05}, {8, 0.05},
    			{9, 0.05}, {10, 0.05}, {11, 0.05}, {12, 0.05}, {13, 0.05}}, true},
	startingJump = {{{2, 0.03}, {14, 0.01}}, false},
	jumping = {{{15, 1}}, false},
	flyingHurt = {{{16, 0.08}, {17, 1}}, false},
	lyingDown = {{{18, 1}}, false},
	gettingUp = {{{19, 0.05}, {20, 0.03}}, false},
	hitByHighPunch = {{{22, 0.05}, {21, 0.05}}, false},
	punching = {{{23, 0.05}, {24, 0.2, {98, -163, 177, 78}}, {25, 0.1}}, false}
  }
}
