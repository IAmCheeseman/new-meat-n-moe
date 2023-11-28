local decal = require("autoload.decal")

local Corpse = core.Class(core.GameObj)

function Corpse:init(vx, vy, sprite)
  self:base("init")

  self.sprite = sprite
  self.sprite.modulate = {0.3, 0.3, 0.3}

  self.vx, self.vy = vx, vy
  self.frict = 5

  self.box = core.ResolverBox {
    anchor = self,
    x = -sprite.offsetx,
    y = -sprite.offsety,
    w = sprite.width,
    h = sprite.height,
    layers = {"none"},
    mask = {"env"},
  }
end

function Corpse:update(dt)
  self.vx = core.math.lerp(self.vx, 0, self.frict * dt)
  self.vy = core.math.lerp(self.vy, 0, self.frict * dt)

  self.vx, self.vy = self.box:moveAndCollide(self.vx, self.vy, dt)

  self.zIndex = self.y

  if core.math.length(self.vx, self.vy) < 1 then
    decal.draw(function()
      self:draw()
    end)
    core.objs:remove(self)
  end
end

function Corpse:draw()
  self.sprite:draw(self.x, self.y)
end

return Corpse
