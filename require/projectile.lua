local Projectile = core.Class(core.GameObj)

function Projectile:init(dir, speed)
  self:base("init")

  self.dir = dir
  self.speed = speed

  self.sprite = assets.entities.bullet
  self.sprite:setOffsetPreset("center", "center")

  self.hitbox = core.DetectorBox {
    anchor = self,
    w = 3, h = 3,
    mask = {"env"}
  }

  self.zIndex = 10
end

function Projectile:update(dt)
  self.x = self.x + math.cos(self.dir) * self.speed * dt
  self.y = self.y + math.sin(self.dir) * self.speed * dt

  for obj, box in self.hitbox:iterColliding() do
    if box:isInLayer("env") then
      core.objs:remove(self)
    end

    -- if obj.takeDamage then
    --   obj:takeDamage()
    -- end
  end
end

function Projectile:draw()
  self.sprite:draw(self.x, self.y, self.dir)
end

return Projectile
