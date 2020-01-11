module("animation", package.seeall)


function animator(componentsTable)
end


function animationRenderer(componentsTable, spriteSheet)
  components.assertComponentsDependency(componentsTable.animationClips,
                                        componentsTable.positions, "animationClip",
                                        "position")

  for entity, animationClip in pairs(componentsTable.animationClips or {}) do
    local position = componentsTable.positions[entity]
    components.assertComponentExistence(position, "animationClip", "position", entity)
    
    print(animationClip.nameOfCurrentAnimation)
    local scale = 0.5
    local currentAnimation = animationClip.animations[animationClip.nameOfCurrentAnimation]
    local currentFrame = currentAnimation.frames[animationClip.currentFrameNumber]
    local __, __, width, height = currentFrame.quad:getViewport()
    local transform = love.math.newTransform(position.x, position.y)

    transform:translate(currentFrame.origin.x + width/2*scale,
                        currentFrame.origin.y + height*scale)
    transform:scale(scale, scale)
    love.graphics.draw(spriteSheet, currentFrame.quad, transform)
  end
end
