local Weapon = require("weapon")
local Projectile = require("projectile")
local controls = require("controls")

local Pistol = core.Class(Weapon)

function Pistol:init(boundObj)
  self:base("init", boundObj)
  self.sprite = assets.entities.moe_gun

  self.targetoffsety = 0

  core.event.connect("mousePressed", self.onMousePressed, self)
end

function Pistol:update(dt)
  self:base("update", dt)

  local mx, my = core.viewport.getMousePosition("main")
  self.rotation = core.math.angleBetween(self.x, self.y, mx, my)

  self.scaley = 1
  if self.x > mx then
    self.scaley = -1
  end

  self.zIndex = math.floor(self.y)
end

function Pistol:onMousePressed(x, y, button, isTouch, presses)
  if button == controls.mouse.weapon1 then
    local mx, my = core.viewport.getMousePosition("main")
    local proj = Projectile(core.math.angle(mx - self.x, my - self.y), 200)
    proj.x = self.x
    proj.y = self.y

    core.objs:add(proj)
  end
end

function Pistol:draw()
  self.sprite:draw(self.x, self.y, self.rotation, 1, self.scaley)
end

return Pistol
