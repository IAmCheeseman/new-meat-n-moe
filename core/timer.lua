local path = (...):gsub("%.timer$", "")
local Class = require(path .. ".class")

local Timer = Class()

function Timer:init(totalTime)
  self.totalTime = totalTime
  self.timeLeft = 0
  self.isOver = true
  self.justOver = false
  self.autoRestart = false
end

function Timer:start(time)
  self.totalTime = time or self.totalTime
  self.isOver = false

  if self.autoRestart then
    self.timeLeft = self.timeLeft + self.totalTime
  else
    self.timeLeft = self.totalTime
  end
end

function Timer:stop()
  self.timeLeft = 0
  self.isOver = true
  self.justOver = true
end

function Timer:update()
  local dt = love.timer.getDelta()

  self.timeLeft = self.timeLeft - dt
  self.justOver = false
  if self.timeLeft <= 0 then
    self.justOver = true
    self.isOver = true

    if self.autoRestart then
      self:start()
    end
  end
end

return Timer
