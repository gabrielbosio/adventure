Animation = require("animation")

function love.load()
  playerImage = love.graphics.newImage("sprites/player.png")
  playerAnimation = Animation(playerImage, 128, 256)
end

function love.update(dt)
  playerAnimation:update(dt)
end

function love.draw()
  playerAnimation:draw()
end
