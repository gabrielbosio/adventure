require("animation")
require("player")
require("timeline")
require("placement")

function love.load()
  local playerImage = love.graphics.newImage("sprites/player.png")
  local playerAnimation = Animation:new(playerImage, 128, 256)
  local playerX = 400
  local playerY = 300
  player = Player:new(playerX, playerY, playerAnimation)
  timeline = Timeline:new()
  timeline:addKeyFrame(3, function () player:walk(5) end)
end

function love.update(dt)
  player:update(dt)
  timeline:update(dt)
end

function love.draw()
  player:draw()

  -- Text placement example
  local x = 200
  local anchors = {"north", "center", "south west", "east"}
  for j, anchor in ipairs(anchors) do
	  local y = (190*j-200+10*#anchors) / (#anchors-1)
	  placement.place("Testing " .. anchor .. " anchor", x, y, anchor)
	  love.graphics.circle("fill", x, y, 2);
  end
end
