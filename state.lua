module("state", package.seeall)

function finiteStateMachineRunner(componentsTable, dt)
  for entity, finiteStateMachine in pairs(componentsTable.finiteStateMachines or {}) do
    finiteStateMachine.stateTime = math.max(0, finiteStateMachine.stateTime - dt)
  end
end