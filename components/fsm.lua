--- Finite state machine.
local M = {}


--[[--
 Create a machine and initialize it with the given state.

 Use the `setState` method of the machine to change its state.
 @tparam string currentState initialize the machine in this state.
]]
function M.FiniteStateMachine(currentState)
  local newComponent = {
    currentState = currentState,
    stateTime = 0
  }

  function newComponent:setState(newState, time)
    self.currentState = newState
    self.stateTime = time or 0
  end

  return newComponent
end

return M
