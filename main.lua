require("enemy")
require("particlesystem")
require("place")
require("player")
require("timeline")

function createTimeline()
  timeline = Timeline:new()
  timeline:addKeyFrame(2, function () player:walk(5, true) end)
  timeline:addKeyFrame(3, function () enemy:walk(5, true) end)
  timeline:addKeyFrame(4, function () player:walk(5) end)
  timeline:addKeyFrame(4.6, function () enemy:attack() end)
  timeline:addKeyFrame(7, function () timeline:play() end)
end

function love.load()
  particleSystem = ParticleSystem:new()
  player = Player:new(400, 300, particleSystem)
  enemy = Enemy:new(100, 300, particleSystem)
  createTimeline()
end

function love.update(dt)
  player:update(dt)
  enemy:update(dt)
  particleSystem:update(dt)
  timeline:update(dt)
end

function love.draw()
  player:draw()
  enemy:draw()
  particleSystem:draw()

  --Text placement example
  local x = 200
  local anchors = {"north", "center", "south west", "east"}
  for j, anchor in ipairs(anchors) do
	  local y = (190*j-200+10*#anchors) / (#anchors-1)
	  place.textByAnchor("Testing " .. anchor .. " anchor", x, y, anchor)
    love.graphics.circle("fill", x, y, 2);
  end
end
