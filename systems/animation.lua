module("animation", package.seeall)


function animator(componentsTable, dt)
  for entity, animationClip in pairs(componentsTable.animationClips or {}) do
    local currentAnimation = animationClip.animations[animationClip.nameOfCurrentAnimation]
    local currentAnimationDuration = currentAnimation:duration()

    if animationClip.currentTime >= currentAnimationDuration then
      
      if currentAnimation.looping then
        animationClip.currentTime = animationClip.currentTime - currentAnimationDuration
      else
        animationClip.currentTime = currentAnimationDuration - dt
        animationClip.done = true
      end
      
    else
      animationClip.currentTime = animationClip.currentTime + dt
    end
  end
end


function animationRenderer(componentsTable, spriteSheet)
  components.assertDependency(componentsTable, "animationClips", "positions")

  for entity, animationClip in pairs(componentsTable.animationClips or {}) do
    local position
    for camEntity, camera in pairs(componentsTable.cameras) do  -- BEAUTIFY
      if camEntity ~= entity then
        position = componentsTable.positions[entity]
        components.assertExistence(entity, "animationClip",
                                   {position, "position"})
        local camPosition = componentsTable.positions[camEntity]
        components.assertExistence(entity, "camera",
                                   {camPosition, "camPosition"})
        position = {
          x = position.x - camPosition.x,
          y = position.y + camPosition.y
        }
      end
    end
    
    local scale = 0.5
    local currentAnimation = animationClip.animations[animationClip.nameOfCurrentAnimation]
    local currentFrame = currentAnimation.frames[animationClip:currentFrameNumber()]
    local __, __, width, height = currentFrame.quad:getViewport()
    local directionFactor = animationClip.facingRight and 1 or -1
    local offsetX = (animationClip.facingRight and 1 or -1)*currentFrame.origin.x*scale
    local transform = love.math.newTransform(position.x, position.y)

    transform:translate(offsetX,
                        currentFrame.origin.y + height*scale)
    transform:scale(scale * directionFactor, scale)
    love.graphics.draw(spriteSheet, currentFrame.quad, transform)
  end
end
