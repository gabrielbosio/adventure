Animation = require("animation")
Player = require("player")

function love.load()
  local playerImage = love.graphics.newImage("sprites/player.png")
  local playerAnimation = Animation(playerImage, 128, 2000)
  local playerX = 400
  local playerY = 300
  player = Player(playerX, playerY, playerAnimation)
end

function love.update(dt)
  player:update(dt)
end

function love.draw()
  player:draw()
end
