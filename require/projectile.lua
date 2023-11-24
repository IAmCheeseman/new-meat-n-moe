local Projectile = core.Class(core.GameObj)

function Projectile:init(dir, speed)
  self:base("init")

  self.dir = dir
  self.speed = speed
  self.damage = 10

  self.sprite = assets.entities.bullet
  self.sprite:setOffsetPreset("center", "center")

  self.hitbox = core.DetectorBox {
    anchor = self,
    x = -1.5, y = -1.5,
    w = 3, h = 3,
    layers = {"bullet"},
    mask = {"env", "hurtbox"},
  }

  self.zIndex = 10
end

function Projectile:damageObj(obj)
  if obj:takeDamage(self.damage, self.dir, self.speed * 0.1) then
    core.objs:remove(self)
  end
end

function Projectile:update(dt)
  self.x = self.x + math.cos(self.dir) * self.speed * dt
  self.y = self.y + math.sin(self.dir) * self.speed * dt

  for obj, box in self.hitbox:iterColliding() do
    if box:isInLayer("env") then
      core.objs:remove(self)
      break
    elseif box:isInLayer("hurtbox") then
      if not obj.takeDamage then
        error("Object with hurtbox does not have `takeDamage` method.")
      end

      if self.damageMask and box:isInLayer(self.damageMask) then
        self:damageObj(obj)
      elseif not self.damageMask then
        self:damageObj(obj)
      end
    end
  end
end

function Projectile:draw()
  self.sprite:draw(self.x, self.y, self.dir)
end

return Projectile
