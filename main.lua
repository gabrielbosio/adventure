require("animation")
require("player")
require("timeline")

function love.load()
  local playerImage = love.graphics.newImage("sprites/player.png")
  local playerAnimation = Animation:new(playerImage, 128, 256)
  local playerX = 400
  local playerY = 300
  player = Player:new(playerX, playerY, playerAnimation)
  timeline = Timeline:new()
  timeline:addKeyFrame(3, function () player:walk(5) end)
end

function love.update(dt)
  player:update(dt)
  timeline:update(dt)
end

function love.draw()
  player:draw()
end
