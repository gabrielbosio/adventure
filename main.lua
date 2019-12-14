require("animation")
require("animationplayer")
require("player")
require("timeline")
require("placement")

function love.load()
  local playerImage = love.graphics.newImage("sprites/player.png")
  local player1StandingAnimation = Animation:new(playerImage, 192, 256, {1, 2})
  local player1WalkingAnimation = Animation:new(playerImage, 192, 256, {3, 4, 5, 4})
  local player2StandingAnimation = Animation:new(playerImage, 192, 256, {1, 2})
  local player2WalkingAnimation = Animation:new(playerImage, 192, 256, {3, 4, 5, 4})
  local player1AnimationPlayer = AnimationPlayer:new()
  local player2AnimationPlayer = AnimationPlayer:new()
  player1AnimationPlayer:addAnimation("standing", player1StandingAnimation)
  player1AnimationPlayer:addAnimation("walking", player1WalkingAnimation)
  player2AnimationPlayer:addAnimation("standing", player2StandingAnimation)
  player2AnimationPlayer:addAnimation("walking", player2WalkingAnimation)
  player1 = Player:new(400, 300, player1AnimationPlayer)
  player2 = Player:new(100, 300, player2AnimationPlayer)
  timeline = Timeline:new()
  timeline:addKeyFrame(2, function () player1:walk(5, true) end)
  timeline:addKeyFrame(3, function () player2:walk(8, true) end)
  timeline:addKeyFrame(4, function () player1:walk(3) end)
end

function love.update(dt)
  player1:update(dt)
  player2:update(dt)
  timeline:update(dt)
end

function love.draw()
  player1:draw()
  player2:draw()

  -- Text placement example
  local x = 200
  local anchors = {"north", "center", "south west", "east"}
  for j, anchor in ipairs(anchors) do
	  local y = (190*j-200+10*#anchors) / (#anchors-1)
	  placement.place("Testing " .. anchor .. " anchor", x, y, anchor)
    love.graphics.circle("fill", x, y, 2);
  end
end
