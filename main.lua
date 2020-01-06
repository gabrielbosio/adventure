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
      --{5, 249, 123, 300},
      {620, 216, 740, 250},
      {120, 165, 206, 186},
      -- slope extension
      {5, 505, 90, 530},
      {630, 430, 795, 605}
    },
    clouds = {
      {326, 120, 400},
      {392, 260, 480},
    },
    slopes = {
      --{75, 35, 0, 0},
      {500, 530, 630, 430},
      {200, 530, 90, 505},
      --{230, 380, 280, 450},
      --{460, 420, 400, 500},
      --{720, 90, 795, 0},
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
    if (playerBox.x - playerBox.width/2 + playerBox.vx*dt < x2
        and playerBox.x + playerBox.width/2 > x1
        and playerBox.y - playerBox.height < y2 and playerBox.y > y1 
        and not guyOnSlope) then
        --[[or (guyOnSlope and playerBox.x + playerBox.vx*dt < x2
        and playerBox.x > x1
        and playerBox.y - playerBox.height < y2 and playerBox.y > y1) then]]
      playerBox.vx = 0
      playerBox.x = x2 + playerBox.width/2
    end

    -- Right
    if playerBox.x + playerBox.width/2 + playerBox.vx*dt > x1
        and playerBox.x - playerBox.width/2 < x2
        and playerBox.y - playerBox.height < y2 and playerBox.y > y1 
        and not guyOnSlope then
      playerBox.vx = 0
      playerBox.x = x1 - playerBox.width/2
    end
  end

  -- Slopes
  guyOnSlope = false

  for i in pairs(terrain.slopes) do
    local x1, y1, x2, y2 = unpack(terrain.slopes[i])
    local yTop, yBottom = math.min(y1, y2), math.max(y1, y2)

    -- Right angle side (acts like a wall)
    if playerBox.y > yTop and playerBox.y - playerBox.height < yBottom then
      if x1 > x2 and playerBox.x + playerBox.width/2 <= x2
          and playerBox.x + playerBox.width/2 + playerBox.vx*dt > x2 then
        playerBox.vx = 0
        playerBox.x = x2 - playerBox.width/2
      elseif x1 < x2 and playerBox.x - playerBox.width/2 >= x2
          and playerBox.x - playerBox.width/2 + playerBox.vx*dt < x2 then
        playerBox.vx = 0
        playerBox.x = x2 + playerBox.width/2
      end
    end

    -- Sharp corner (acts like a wall)
    if x1 > x2 and playerBox.x + playerBox.width/2 > x1
        and playerBox.x - playerBox.width/2 + playerBox.vx*dt < x1 then
      if (y1 > y2 and playerBox.y > y1
          and playerBox.y - playerBox.height < y1) or (y1 < y2
          and playerBox.y > y1 and playerBox.y - playerBox.height < y1) then
        playerBox.vx = 0
        playerBox.x = x1 + playerBox.width/2
      end
    elseif x1 < x2 and playerBox.x - playerBox.width/2 < x1
        and playerBox.x + playerBox.width/2 + playerBox.vx*dt > x1 then
      if (y1 > y2 and playerBox.y > y1
          and playerBox.y - playerBox.height < y1) or (y1 < y2
          and playerBox.y > y1 and playerBox.y - playerBox.height < y1) then
        playerBox.vx = 0
        playerBox.x = x1 - playerBox.width/2
      end
    end

    -- Top and bottom
    if playerBox.x + playerBox.width/2 > math.min(x1, x2)
        and playerBox.x - playerBox.width/2 < math.max(x1, x2) then
      local m = (y2-y1) / (x2-x1)

      if y1 < y2 then
        -- Ceiling (leaning)
        if playerBox.y - playerBox.height >= y1
            and playerBox.y - playerBox.height <= y2 then
          slopeX = x1 + (playerBox.y-playerBox.height-y1)/m

          if x1 > x2 and playerBox.x - playerBox.width/2 >= slopeX
              and playerBox.x - playerBox.width/2 + playerBox.vx*dt < slopeX
              then
            playerBox.vx = 0
            playerBox.x = slopeX + playerBox.width/2
          elseif x1 < x2 and playerBox.x + playerBox.width/2 <= slopeX
              and playerBox.x + playerBox.width/2 + playerBox.vx*dt > slopeX
              then
            playerBox.vx = 0
            playerBox.x = slopeX - playerBox.width/2
          end
        end

        local slopeY = y1 + m*(playerBox.x-x1)

        if playerBox.y - playerBox.height >= slopeY
            and playerBox.y - playerBox.height + playerBox.vy*dt < slopeY
            then
          playerBox.vy = 0
          playerBox.y = slopeY + playerBox.height
        end

        -- Floor (flat)
        if playerBox.y + playerBox.vy*dt > y1 and playerBox.y <= y1 then
          playerBox.vy = 0
          playerBox.y = y1
        end

      else  -- (y1 >= y2)

        -- Ceiling (flat) 
        if playerBox.vy < 0 and playerBox.y - playerBox.height >= y1
            and playerBox.y - playerBox.height + playerBox.vy*dt < y1 then
          playerBox.vy = 0
          playerBox.y = y1 + playerBox.height
        end

        -- Floor (leaning)
        local slopeY = y1 + m*(playerBox.x-x1)
        if playerBox.y <= math.max(y2, slopeY)
            and playerBox.y + playerBox.vy*dt > math.max(y2, slopeY) then
          playerBox.vy = 0

          -- Prevent floating character at slope corner
          if (playerBox.x-x1)*(playerBox.x-x2) < 0 then
            playerBox.y = slopeY
          else
            playerBox.y = y2
          end
        end

        if playerBox.y <= y1 and playerBox.y > math.max(y2, slopeY)
            and ((x1 > x2 and playerBox.x - playerBox.width/2 <= x1
                 and playerBox.x + playerBox.width/2 >= x2)
                 or (x1 < x2 and playerBox.x + playerBox.width/2 >= x1
                 and playerBox.x - playerBox.width/2 <= x2)) then
          playerBox.vy = 0
          playerBox.y = slopeY
          guyOnSlope = true
        end


      end -- if y1 < y2
    end -- if playerBox.x + playerBox.width/2 > math.min(x1, x2)

  end  -- for i

  -- Clouds
  for i in pairs(terrain.clouds) do
    local clouds = terrain.clouds[i]
    local x1 = math.min(clouds[1], clouds[3])
    local y1 = clouds[2]
    local x2 = math.max(clouds[1], clouds[3])

    if playerBox.x + playerBox.width/2 > x1 and playerBox.x - playerBox.width/2 < x2
        and playerBox.y + playerBox.vy*dt > y1 and playerBox.y <= y1
        and playerBox.vy > 0 then
      playerBox.vy = 0
      playerBox.y = y1
    end
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

  -- Player collision box
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
