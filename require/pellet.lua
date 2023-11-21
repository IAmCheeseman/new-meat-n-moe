local Projectile = require("require.projectile")

local Pellet = core.Class(Projectile)

function Pellet:init(dir, speed)
  self:base("init", dir, speed)

  self.totalTime = 0.2 + love.math.random() * 0.2
  self.time = self.totalTime
  self.maxSpeed = self.speed
end

function Pellet:update(dt)
  self:base("update", dt)

  self.time = self.time - dt
  self.speed = self.maxSpeed * (self.time / self.totalTime)
  if self.time <= 0 then
    core.objs:remove(self)
  end
end

function Pellet:draw()
  self.sprite:draw(self.x, self.y, self.dir, self.time / self.totalTime, 1.5)
end

return Pellet
