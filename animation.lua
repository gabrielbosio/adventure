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
    local currentAnimation = animationClip.animations[animationClip.nameOfCurrentAnimation]
    local currentFrame = currentAnimation.frames[animationClip.currentFrameNumber]
    local x = position.x + currentFrame.origin.x
    local y = position.y + currentFrame.origin.y
    love.graphics.draw(spriteSheet, currentFrame.quad, x, y)
  end
end
