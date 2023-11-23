local path = (...):gsub("%.state_machine$", "")
local Class = require(path .. ".class")

local StateMachine = Class()

function StateMachine:init(obj)
  self.obj = obj
  self.states = {}
end

function StateMachine:setState(name)
  if self.current and self.states[self.current].exit then
    self.states[self.current].exit(self.obj)
  end
  self.current = name

  if self.states[self.current].enter then
    self.states[self.current].enter(self.obj)
  end
  return self
end

function StateMachine:getState(name)
  return self.current
end

function StateMachine:addState(name, callbacks)
  self.states[name] = callbacks
  return self
end

function StateMachine:update(dt)
  self.states[self.current].update(self.obj, dt)
end

function StateMachine:draw()
  self.states[self.current].draw(self.obj)
end

return StateMachine
