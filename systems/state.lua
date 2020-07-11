local M = {}

function M.finiteStateMachineRunner(componentsTable, dt)
  for entity, finiteStateMachine in pairs(componentsTable.finiteStateMachines or {}) do
    finiteStateMachine.stateTime = math.max(0, finiteStateMachine.stateTime - dt)
  end
end

return M
