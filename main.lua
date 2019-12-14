require("animation")
require("animationplayer")
require("player")
require("timeline")
require("place")

function love.load()
  meterUnitInPx = 250
  love.physics.setMeter(meterUnitInPx)
  world = love.physics.newWorld(0, 9.80665*meterUnitInPx)

  local width, height, _ = love.window.getMode()
  physicalObjects = {
    ground = {
      -- Bodies are "static" by default
      body = love.physics.newBody(world, width/2, height-120),
      shape = love.physics.newRectangleShape(width, 100),
    },
    ball = {
      body = love.physics.newBody(world, width/2, 0, "dynamic"),
      shape = love.physics.newCircleShape(20),
    }
  }
  physicalObjects.ground.fixture = love.physics.newFixture(
    physicalObjects.ground.body, physicalObjects.ground.shape)
  physicalObjects.ball.fixture = love.physics.newFixture(
    physicalObjects.ball.body, physicalObjects.ball.shape)
  physicalObjects.ball.fixture:setRestitution(0.7)

  player1 = Player:new(400, 300)
  player2 = Player:new(100, 300)
  timeline = Timeline:new()
  timeline:addKeyFrame(2, function () player1:walk(5, true) end)
  timeline:addKeyFrame(3, function () player2:walk(8, true) end)
  timeline:addKeyFrame(4, function () player1:walk(3) end)
end

function love.update(dt)
  player1:update(dt)
  player2:update(dt)
  timeline:update(dt)

  world:update(dt)
end

function love.draw()
  love.graphics.setColor(1, 1, 1)
  player1:draw()
  player2:draw()

  -- Physics test
  love.graphics.setColor(0, 0.5, 0)
  love.graphics.polygon("fill", physicalObjects.ground.body:getWorldPoints(
    physicalObjects.ground.shape:getPoints()))
  love.graphics.setColor(1, 1, 0)
  love.graphics.circle("fill", physicalObjects.ball.body:getX(),
    physicalObjects.ball.body:getY(), physicalObjects.ball.shape:getRadius())

  -- Text placement example
  local x = 200
  local anchors = {"north", "center", "south west", "east"}
  for j, anchor in ipairs(anchors) do
	  local y = (190*j-200+10*#anchors) / (#anchors-1)
    love.graphics.setColor(1, 1, 1)
	  place.textByAnchor("Testing " .. anchor .. " anchor", x, y, anchor)
    love.graphics.setColor(1, 0, 0)
    love.graphics.circle("fill", x, y, 2);
  end
end
