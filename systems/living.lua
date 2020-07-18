local M = {}

function M.staminaSupply(componentsTable, dt)  
  for entity, living in pairs(componentsTable.living) do
    if living.stamina > 0 and living.stamina < 100 then
      living.stamina = math.min(100, living.stamina + dt * 25)
    end
  end
end

return M
