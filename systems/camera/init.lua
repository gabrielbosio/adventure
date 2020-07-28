local components = require "components"
local translate = require "systems.camera.translate"
local tweening = require "systems.camera.tweening"

local M = {}

local shakeMoveTimeCount = 0
local shakeMoveTimeMax = 10 / 1000  -- ten milliseconds

--- Follow camera targets
-- Called in systems.update()
function M.update(componentsTable, dt)
  for vcamEntity, isVcam in pairs(componentsTable.cameras or {}) do
    if isVcam then
      for targetEntity, isTarget in pairs(componentsTable.cameraTargets) do
        if isTarget then
          local vcamPosition = componentsTable.positions[vcamEntity]
          local targetPosition = componentsTable.positions[targetEntity]
          components.assertExistence(vcamEntity, "camera",
                                     {vcamPosition, "vcamPosition"})
          components.assertExistence(targetEntity, "cameraTarget",
                                     {targetPosition, "targetPosition"})

          -- Movement constraints here
          tweening.exp(vcamPosition, targetPosition, dt, 25)
          -- tweening.linear(vcamPosition, targetPosition, dt)

          -- Camera shake
          local shake = componentsTable.shake[vcamEntity]
          components.assertExistence(vcamEntity, "camera",
                                     {shake, "shake"})
          shakeMoveTimeCount = shakeMoveTimeCount + dt
          if shakeMoveTimeCount > shakeMoveTimeMax then
            --math.randomseed(os.time())
            local angle = 2*math.pi*math.random()
            vcamPosition.x = vcamPosition.x + shake*math.cos(angle)
            vcamPosition.y = vcamPosition.y + shake*math.sin(angle)
            shakeMoveTimeCount = 0
          end
        end
      end
    end
  end
end


--- Return the results of applying coordinate translations
-- Called in love.draw()
function M.positions(componentsTable, terrain)
  local translated = {
    terrain = {},
    components = {}
  }

  -- Move
  for vcamEntity, isVcam in pairs(componentsTable.cameras or {}) do
    if isVcam then
      local vcamPosition = componentsTable.positions[vcamEntity]

      translated.components = translate.boxes(componentsTable.positions,
                                              vcamEntity, vcamPosition)
      translated.terrain = translate.terrain(terrain, vcamPosition)
    end
  end

  -- Done, now return a table with all the moved positions
  return translated
end


return M
