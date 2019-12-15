require("animation")
require("animationplayer")
require("player")
require("timeline")
require("place")

function love.load()
  player1 = Player:new(400, 300)
  player2 = Player:new(100, 300)
  timeline = Timeline:new()
  timeline:addKeyFrame(2, function () player1:walk(5, true) end)
  timeline:addKeyFrame(3, function () player2:walk(8, true) end)
  timeline:addKeyFrame(4, function () player1:walk(3) end)

  -- Physics test
  gravity = 1000

  playerBox = {x = 400, y = 0, vx = 0, vy = 0, width = 100, height = 50}

  terrain = {
    floor = {
      {0, 400, 600, 500},
      {600, 300, 800, 500},
      {-5, -5, 5, 400},
      {800, -5, 805, 400},
    },
    slopes = {
      {500, 400, 600, 300},
    }
  }
end

function love.update(dt)
  player1:update(dt)
  player2:update(dt)
  timeline:update(dt)

  -- Physics test
  local touchingFloor = false

  for i in pairs(terrain.floor) do
    local floor = terrain.floor[i]

    if playerBox.x > floor[1] and playerBox.x < floor[3] and playerBox.y > floor[2] then 
      while playerBox.y > floor[2] do
        playerBox.y = playerBox.y - 1
      end
      touchingFloor = true
      break
    end
  end

  if touchingFloor then
    playerBox.vy = 0
  else
    playerBox.vy = playerBox.vy + gravity*dt
  end

  playerBox.y = playerBox.y + playerBox.vy*dt
end

function love.draw()
  love.graphics.setColor(1, 1, 1)
  player1:draw()
  player2:draw()

  -- Text placement example
  local x = 200
  local anchors = {"north", "center", "south west", "east"}
  for j, anchor in ipairs(anchors) do
	  local y = (190*j-200+10*#anchors) / (#anchors-1)
    love.graphics.setColor(1, 1, 1)
	  place.textByAnchor("Testing " .. anchor .. " anchor", x, y, anchor)
    love.graphics.setColor(1, 0, 0)
    love.graphics.circle("fill", x, y, 2);
  end

  -- Physics test
  love.graphics.setColor(0, 0.5, 0)
  for i in pairs(terrain.floor) do
    local floor = terrain.floor[i]
      love.graphics.rectangle("fill", unpack(floor))
  end

  love.graphics.setColor(0, 0, 1)
  love.graphics.rectangle("fill", playerBox.x-playerBox.width/2, playerBox.y-playerBox.height, 
    playerBox.width, playerBox.height)
  love.graphics.setColor(1, 1, 0)
  love.graphics.circle("fill", playerBox.x, playerBox.y, 2)
end
