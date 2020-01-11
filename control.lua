module("control", package.seeall)

-- TODO Add assertions


function playerController(componentsTable)
  -- This for loop could be avoided if there is only one entity with a "player"
  -- component.
  for entity, player in pairs(componentsTable.players) do
      local input = componentsTable.inputs[entity]

      -- X Movement Input
      input.left = love.keyboard.isDown("a") and not love.keyboard.isDown("d")
      input.right = not love.keyboard.isDown("a") and love.keyboard.isDown("d")


      -- Y Movement Input
      input.jump = false

      if love.keyboard.isDown("w") and not input.jump and not holdingJumpKey then
        input.jump = true
        holdingJumpKey = true
      elseif not love.keyboard.isDown("w") and holdingJumpKey then
        holdingJumpKey = false
      end
  end  -- for entity, player

end
