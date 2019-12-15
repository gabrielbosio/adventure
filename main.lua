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
  gravity = 5000
  xSpeed = 500
  jumpImpulseSpeed = 1400
  jumping = false

  playerBox = {x = 400, y = 0, vx = 0, vy = 0, width = 50, height = 100}

  terrain = {
    boundaries = {
      {0, 400, 600, 500},
      {600, 300, 805, 500},
      {-5, 5, 10, 400},
      {790, -5, 805, 400},
      {500, 140, 600, 145}
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

  -- Input
  if love.keyboard.isDown("a") then
    playerBox.vx = -xSpeed;
  elseif love.keyboard.isDown("d") then
    playerBox.vx = xSpeed;
  else
    playerBox.vx = 0;
  end

  if love.keyboard.isDown("w") and touchingFloor and not jumping then
    playerBox.vy = -jumpImpulseSpeed
    jumping = true
  elseif jumping and not love.keyboard.isDown("w") then
    jumping = false
  end

  -- Physics test
  touchingWall = false
  touchingFloor = false

  for i in pairs(terrain.boundaries) do
    local boundaries = terrain.boundaries[i]
    x1 = math.min(boundaries[1], boundaries[3])
    y1 = math.min(boundaries[2], boundaries[4])
    x2 = math.max(boundaries[1], boundaries[3])
    y2 = math.max(boundaries[2], boundaries[4])

    if playerBox.y - playerBox.height/2 > y1 and
        playerBox.y - playerBox.height/2 < y2 and
        playerBox.x + playerBox.width/2 > x1 and
        playerBox.x < x1 then

        while playerBox.x + playerBox.width/2 > x1 do
          playerBox.x = playerBox.x - 1
        end

        playerBox.vx = 0

        touchingWall = true
    elseif playerBox.y - playerBox.height/2 > y1 and
        playerBox.y - playerBox.height/2 < y2 and
        playerBox.x - playerBox.width/2 < x2 and
        playerBox.x > x2 then

        while playerBox.x - playerBox.width/2 < x2 do
          playerBox.x = playerBox.x + 1
        end

        playerBox.vx = 0
        touchingWall = true
    end

    if playerBox.x > x1 and playerBox.x < x2 and
        playerBox.y + playerBox.vy*dt > y1 and playerBox.y  < y2 then 

      while playerBox.y > y1 and playerBox.y < y2 do
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

  playerBox.x = playerBox.x + playerBox.vx*dt
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
  for i in pairs(terrain.boundaries) do
    local boundaries = terrain.boundaries[i]
      love.graphics.polygon("fill", boundaries[1], boundaries[2], boundaries[3], boundaries[2],
        boundaries[3], boundaries[4], boundaries[1], boundaries[4])
  end

  love.graphics.setColor(0, 0, 1)
  love.graphics.rectangle("fill", playerBox.x-playerBox.width/2, playerBox.y-playerBox.height, 
    playerBox.width, playerBox.height)
  love.graphics.setColor(1, 1, 0)
  love.graphics.circle("fill", playerBox.x, playerBox.y, 2)
  love.graphics.print(math.floor(playerBox.x) .. "," .. math.floor(playerBox.y), 0, 0)
end
