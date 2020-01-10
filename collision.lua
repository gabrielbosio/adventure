module("collision", package.seeall)


function terrainCollision(components, terrain, dt)
  local gravity = 5000
  
  for entity, solidComponent in pairs(components.solids) do
    local collisionBox = components.collisionBoxes[entity]
    local position = components.positions[entity]
    collisionBox.vy = collisionBox.vy + gravity*dt

    for i in pairs(terrain.boundaries) do
      local boundaries = terrain.boundaries[i]
      local x1 = math.min(boundaries[1], boundaries[3])
      local y1 = math.min(boundaries[2], boundaries[4])
      local x2 = math.max(boundaries[1], boundaries[3])
      local y2 = math.max(boundaries[2], boundaries[4])

      -- Bottom
      if position.x + collisionBox.x + collisionBox.width/2 > x1
          and position.x + collisionBox.x - collisionBox.width/2 < x2
          and position.y + collisionBox.y + collisionBox.vy*dt > y1
          and position.y + collisionBox.y - collisionBox.height/2 < y2 then
        collisionBox.vy = 0
        position.y = y1
      end

      -- Top
      if position.x + collisionBox.x + collisionBox.width/2 > x1
          and position.x + collisionBox.x - collisionBox.width/2 < x2
          and position.y + collisionBox.y - collisionBox.height + collisionBox.vy*dt < y2
          and position.y + collisionBox.y > y1 then
        collisionBox.vy = 0
        position.y = y2 + collisionBox.height
      end

      -- Left
      if (position.x + collisionBox.x - collisionBox.width/2 + collisionBox.vx*dt < x2
          and position.x + collisionBox.x + collisionBox.width/2 > x1
          and position.y + collisionBox.y - collisionBox.height < y2
          and position.y  + collisionBox.y > y1
          and not collisionBox.onSlope) then
          --[[or (collisionBox.onSlope and collisionBox.x + collisionBox.vx*dt < x2
          and collisionBox.x > x1
          and collisionBox.y - collisionBox.height < y2 and collisionBox.y > y1) then]]
        collisionBox.vx = 0
        position.x = x2 + collisionBox.width/2
      end

      -- Right
      if position.x + collisionBox.x + collisionBox.width/2 + collisionBox.vx*dt > x1
          and position.x + collisionBox.x - collisionBox.width/2 < x2
          and position.y + collisionBox.y - collisionBox.height < y2
          and position.y + collisionBox.y > y1 
          and not collisionBox.onSlope then
        collisionBox.vx = 0
        position.x = x1 - collisionBox.width/2
      end
    end

    -- Slopes
    collisionBox.onSlope = false

    for i in pairs(terrain.slopes) do
      local x1, y1, x2, y2 = unpack(terrain.slopes[i])
      local yTop, yBottom = math.min(y1, y2), math.max(y1, y2)

      -- Right angle side (acts like a wall)
      if position.y + collisionBox.y > yTop
          and position.y + collisionBox.y - collisionBox.height < yBottom then
        
        if x1 > x2 and position.x + collisionBox.x + collisionBox.width/2 <= x2
            and position.x + collisionBox.x + collisionBox.width/2 + collisionBox.vx*dt > x2 then
          collisionBox.vx = 0
          position.x = x2 - collisionBox.width/2
        
        elseif x1 < x2 and position.x + collisionBox.x - collisionBox.width/2 >= x2
            and position.x + collisionBox.x - collisionBox.width/2 + collisionBox.vx*dt < x2 then
          collisionBox.vx = 0
          position.x = x2 + collisionBox.width/2
        end
      end

      -- Sharp corner (acts like a wall)
      if x1 > x2 and position.x + collisionBox.x + collisionBox.width/2 > x1
          and position.x + collisionBox.x - collisionBox.width/2 + collisionBox.vx*dt < x1 then
        
        if (y1 > y2 and position.y + collisionBox.y > y1
            and position.y + collisionBox.y - collisionBox.height < y1) or (y1 < y2
            and position.y + collisionBox.y > y1
            and position.y + collisionBox.y - collisionBox.height < y1) then
          collisionBox.vx = 0
          position.x = x1 + collisionBox.width/2
        end

      elseif x1 < x2 and position.x + collisionBox.x - collisionBox.width/2 < x1
          and position.x + collisionBox.x + collisionBox.width/2 + collisionBox.vx*dt > x1 then
        
        if (y1 > y2 and position.y + collisionBox.y > y1
            and position.y + collisionBox.y - collisionBox.height < y1) or (y1 < y2
            and position.y + collisionBox.y > y1
            and position.y + collisionBox.y - collisionBox.height < y1) then
          collisionBox.vx = 0
          position.x = x1 - collisionBox.width/2
        end
      end

      -- Top and bottom
      if position.x + collisionBox.x + collisionBox.width/2 > math.min(x1, x2)
          and position.x + collisionBox.x - collisionBox.width/2 < math.max(x1, x2) then
        local m = (y2-y1) / (x2-x1)

        if y1 < y2 then
          -- Ceiling (leaning)
          if position.y + collisionBox.y - collisionBox.height >= y1
              and position.y + collisionBox.y - collisionBox.height <= y2 then
            slopeX = x1 + (position.y + collisionBox.y - collisionBox.height - y1)/m

            if x1 > x2 and position.x + collisionBox.x - collisionBox.width/2 >= slopeX
                and position.x + collisionBox.x - collisionBox.width/2 + collisionBox.vx*dt < slopeX
                then
              collisionBox.vx = 0
              position.x = slopeX + collisionBox.width/2
            elseif x1 < x2 and position.x + collisionBox.x + collisionBox.width/2 <= slopeX
                and position.x + collisionBox.x + collisionBox.width/2 + collisionBox.vx*dt > slopeX
                then
              collisionBox.vx = 0
              position.x = slopeX - collisionBox.width/2
            end
          end

          local slopeY = y1 + m*(collisionBox.x-x1)

          if position.y + collisionBox.y - collisionBox.height >= slopeY
              and position.y + collisionBox.y - collisionBox.height + collisionBox.vy*dt < slopeY
              then
            collisionBox.vy = 0
            position.y = slopeY + collisionBox.height
          end

          -- Floor (flat)
          if position.y + collisionBox.y + collisionBox.vy*dt > y1
              and position.y + collisionBox.y <= y1 then
            collisionBox.vy = 0
            position.y = y1
          end

        else  -- (y1 >= y2)

          -- Ceiling (flat) 
          if collisionBox.vy < 0 and position.y + collisionBox.y - collisionBox.height >= y1
              and position.y + collisionBox.y - collisionBox.height + collisionBox.vy*dt < y1 then
            collisionBox.vy = 0
            position.y = y1 + collisionBox.height
          end

          -- Floor (leaning)
          local slopeY = y1 + m*(position.x + collisionBox.x - x1)

          if position.y + collisionBox.y <= math.max(y2, slopeY)
              and position.y + collisionBox.y + collisionBox.vy*dt > math.max(y2, slopeY) then
            collisionBox.vy = 0

            -- Prevent floating character at slope corner
            if (position.x + collisionBox.x - x1)*(position.x + collisionBox.x - x2) < 0 then
              position.y = slopeY
            else
              position.y = y2
            end
          end

          if position.y + collisionBox.y <= y1 and position.y + collisionBox.y > math.max(y2, slopeY)
              and ((x1 > x2 and position.y + collisionBox.x - collisionBox.width/2 <= x1
              and position.y + collisionBox.x + collisionBox.width/2 >= x2)
              or (x1 < x2 and position.y + collisionBox.x + collisionBox.width/2 >= x1
              and position.y + collisionBox.x - collisionBox.width/2 <= x2)) then
            collisionBox.vy = 0
            position.y = slopeY
            collisionBox.onSlope = true
          end


        end -- if y1 < y2
      end -- if collisionBox.x + collisionBox.width/2 > math.min(x1, x2)

    end  -- for i

    -- Clouds
    for i in pairs(terrain.clouds) do
      local clouds = terrain.clouds[i]
      local x1 = math.min(clouds[1], clouds[3])
      local y1 = clouds[2]
      local x2 = math.max(clouds[1], clouds[3])

      if position.x + collisionBox.x + collisionBox.width/2 > x1
          and position.x + collisionBox.x - collisionBox.width/2 < x2
          and position.y + collisionBox.y + collisionBox.vy*dt > y1
          and position.y + collisionBox.y <= y1
          and collisionBox.vy > 0 then
        collisionBox.vy = 0
        position.y = y1
      end
    end

    local winWidth, winHeight = love.window.getMode()
    position.x = (position.x+collisionBox.vx*dt)
    position.y = (position.y+collisionBox.vy*dt)
  end
end
