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
      end
      
    else
      animationClip.currentTime = animationClip.currentTime + dt
    end
  end
end


function animationRenderer(componentsTable, spriteSheet)
  components.assertComponentsDependency(componentsTable.animationClips,
                                        componentsTable.positions, "animationClip",
                                        "position")

  for entity, animationClip in pairs(componentsTable.animationClips or {}) do
    local position = componentsTable.positions[entity]
    components.assertComponentExistence(position, "animationClip", "position", entity)
    
    local scale = 0.5
    local currentAnimation = animationClip.animations[animationClip.nameOfCurrentAnimation]
    local currentFrame = currentAnimation.frames[animationClip:currentFrameNumber()]
    local __, __, width, height = currentFrame.quad:getViewport()
    print(currentFrame.quad:getViewport())
    local directionFactor = animationClip.facingRight and 1 or -1
    local offsetX = ((animationClip.facingRight and 0 or width) + width/2)
    local transform = love.math.newTransform(position.x, position.y)

    transform:translate(currentFrame.origin.x + offsetX*scale,
                        currentFrame.origin.y + height*scale)
    transform:scale(scale * directionFactor, scale)
    love.graphics.draw(spriteSheet, currentFrame.quad, transform)
  end
end
