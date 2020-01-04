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

  playerBox = {x = 46, y = 142, vx = 0, vy = 0, width = 50, height = 100}

  terrain = {
    boundaries = {
      {-5, -100, 5, 605},			-- left
      --{-5, -5, 805, 5},		  -- top
      {-5, 530, 805, 605},	-- bottom
      {795, -100, 805, 605}, 	-- right
      -- Platforms
      {5, 249, 123, 300},
      {620, 216, 740, 250},
      {120, 165, 206, 186},
      -- slope extension
      {630, 430, 795, 605}
    },
    clouds = {
      {326, 120, 400},
      {392, 260, 480},
    },
    slopes = {
      {500, 530, 630, 430},
      {220, 530, 5, 425}
    }
  }

  cloudHeightDisplay = 10 
end

-- Input test - callbacks seem good for prevent bunny hops
-- not good for horizontal movement though: one need keyboard.isDown anyway
function love.keypressed(key, isrepeat)
  -- Y Movement Input
  if key == "w" and playerBox.vy == 0 then
    playerBox.vy = -jumpImpulseSpeed
  end
end

function love.update(dt)
  player1:update(dt)
  player2:update(dt)
  timeline:update(dt)

  -- X Movement Input (far simpler than the callback approach)
  if love.keyboard.isDown("a") and not love.keyboard.isDown("d") then
    playerBox.vx = -xSpeed
  elseif love.keyboard.isDown("d") and not love.keyboard.isDown("a") then
    playerBox.vx = xSpeed
  else
    playerBox.vx = 0
  end

  -- Physics test
  playerBox.vy = playerBox.vy + gravity*dt

  for i in pairs(terrain.boundaries) do
    local boundaries = terrain.boundaries[i]
    local x1 = math.min(boundaries[1], boundaries[3])
    local y1 = math.min(boundaries[2], boundaries[4])
    local x2 = math.max(boundaries[1], boundaries[3])
    local y2 = math.max(boundaries[2], boundaries[4])

    -- Bottom
    if playerBox.x + playerBox.width/2 > x1 and playerBox.x - playerBox.width/2 < x2
        and playerBox.y + playerBox.vy*dt > y1
        and playerBox.y - playerBox.height/2 < y2 then
      playerBox.vy = 0
      playerBox.y = y1
    end

    -- Top
    if playerBox.x + playerBox.width/2 > x1 and playerBox.x - playerBox.width/2 < x2
        and playerBox.y - playerBox.height + playerBox.vy*dt < y2
        and playerBox.y > y1 then
      playerBox.vy = 0
      playerBox.y = y2 + playerBox.height
    end

    -- Left
    if playerBox.x - playerBox.width/2 + playerBox.vx*dt < x2
        and playerBox.x + playerBox.width/2 > x1
        and playerBox.y - playerBox.height < y2 and playerBox.y > y1 then
      playerBox.vx = 0
      playerBox.x = x2 + playerBox.width/2
    end

    -- Right
    if playerBox.x + playerBox.width/2 + playerBox.vx*dt > x1
        and playerBox.x - playerBox.width/2 < x2
        and playerBox.y - playerBox.height < y2 and playerBox.y > y1 then
      playerBox.vx = 0
      playerBox.x = x1 - playerBox.width/2
    end
  end

  -- Slopes
  for i in pairs(terrain.slopes) do
    local slopes = terrain.slopes[i]
    local m = (slopes[4]-slopes[2]) / (slopes[3]-slopes[1])
    local x1 = math.min(slopes[1], slopes[3])
    local y1 = math.min(slopes[2], slopes[4])
    local x2 = math.max(slopes[1], slopes[3])
    local y2 = math.max(slopes[2], slopes[4])

    if playerBox.x + playerBox.width/2 > x1 and
      playerBox.x - playerBox.width/2 < x2 then
        local slopeX = playerBox.x
        local slopeY = slopes[2] + m*(slopeX-slopes[1])

        if playerBox.y <= slopeY and playerBox.y + playerBox.vy*dt > slopeY
          then
          playerBox.vy = 0
          playerBox.y = slopeY
        end

        if playerBox.y > slopeY and playerBox.y - playerBox.height < slopeY
          then
          playerBox.vy = 0
          playerBox.y = slopeY
        end
    end
  end

  -- Clouds
  for i in pairs(terrain.clouds) do
    local clouds = terrain.clouds[i]
    local x1 = math.min(clouds[1], clouds[3])
    local y1 = clouds[2]
    local x2 = math.max(clouds[1], clouds[3])

    -- Land
    if playerBox.x + playerBox.width/2 > x1 and playerBox.x - playerBox.width/2 < x2
        and playerBox.y + playerBox.vy*dt > y1
        and playerBox.y - playerBox.height/2 < y1 and playerBox.vy > 0 then
      playerBox.vy = 0
      playerBox.y = y1
    end

    -- Walk over
  end

  local winWidth, winHeight = love.window.getMode()
  playerBox.x = (playerBox.x+playerBox.vx*dt)
  playerBox.y = (playerBox.y+playerBox.vy*dt)
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
    love.graphics.polygon("fill", boundaries[1], boundaries[2], boundaries[3],
      boundaries[2], boundaries[3], boundaries[4], boundaries[1], boundaries[4])
  end

  for i in pairs(terrain.slopes) do
    local slopes = terrain.slopes[i]
    love.graphics.polygon("fill", slopes[1], slopes[2], slopes[3], slopes[2],
      slopes[3], slopes[4])
  end

  love.graphics.setColor(0.3, 0.6, 1)
  for i in pairs(terrain.clouds) do
    local clouds = terrain.clouds[i]
    love.graphics.polygon("fill", clouds[1], clouds[2], clouds[3], clouds[2],
      clouds[3], clouds[2] + cloudHeightDisplay, clouds[1],
      clouds[2] + cloudHeightDisplay)
  end

  love.graphics.setColor(0, 0, 1)
  love.graphics.rectangle("fill", playerBox.x-playerBox.width/2,
    playerBox.y-playerBox.height, playerBox.width, playerBox.height)

  -- Cursor position
  love.graphics.setColor(1, 1, 1)
  place.textByAnchor(love.mouse.getX() .. ", " .. love.mouse.getY(), 0, 0,
    "north west")

  -- Player position
  love.graphics.setColor(1, 1, 0)
  love.graphics.circle("fill", playerBox.x, playerBox.y, 2)
  local playerPositionText = math.floor(playerBox.x) .. ", " ..
    math.floor(playerBox.y)
  place.textByAnchor(playerPositionText, 0,
    love.graphics.getFont():getHeight(playerPositionText), "north west")
end
