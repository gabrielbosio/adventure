require("animation")
require("animationplayer")
require("player")
require("timeline")
require("place")

function love.load()
  world = love.physics.newWorld(0, 980.665)
  body = love.physics.newBody(world, 400, 0, "dynamic")

  player1 = Player:new(400, 300)
  player2 = Player:new(100, 300)
  timeline = Timeline:new()
  timeline:addKeyFrame(2, function () player1:walk(5, true) end)
  timeline:addKeyFrame(3, function () player2:walk(8, true) end)
  timeline:addKeyFrame(4, function () player1:walk(3) end)
end

function love.update(dt)
  player1:update(dt)
  player2:update(dt)
  timeline:update(dt)

  world:update(dt)
end

function love.draw()
  player1:draw()
  player2:draw()

  -- Physics test
  love.graphics.circle("fill", body:getX(), body:getY(), 2)

  -- Text placement example
  local x = 200
  local anchors = {"north", "center", "south west", "east"}
  for j, anchor in ipairs(anchors) do
	  local y = (190*j-200+10*#anchors) / (#anchors-1)
	  place.textByAnchor("Testing " .. anchor .. " anchor", x, y, anchor)
    love.graphics.circle("fill", x, y, 2);
  end
end
