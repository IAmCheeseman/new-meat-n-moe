local Weapon = require("weapon")

local Pistol = core.Class(Weapon)

function Pistol:init(boundObj)
  self:base("init", boundObj)
  self.sprite = assets.entities.moe_gun

  self.targetoffsety = 0
end

function Pistol:update(dt)
  self:base("update", dt)

  local mx, my = core.viewport.getMousePosition("main")
  self.rotation = core.math.angleBetween(self.x, self.y, mx, my)

  self.scaley = 1
  if self.x > mx then
    self.scaley = -1
  end
end

function Pistol:draw()
  self.sprite:draw(self.x, self.y, self.rotation, 1, self.scaley)
end

return Pistol
