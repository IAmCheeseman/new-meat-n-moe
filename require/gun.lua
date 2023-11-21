local Weapon = require("require.weapon")
local Projectile = require("require.projectile")
local controls = require("controls")

local Gun = core.Class(Weapon)

function Gun:init(boundObj, cooldown)
  self:base("init", boundObj)
  self.targetoffsety = 0

  self.offsetx = 0
  self.offsety = 0

  self.cooldown = core.Timer(cooldown)

  core.event.connect("mousePressed", self.onMousePressed, self)
end

function Gun:update(dt)
  self:base("update", dt)

  local mx, my = core.viewport.getMousePosition("main")
  self.rotation = core.math.angleBetween(self.x, self.y, mx, my)

  self.scaley = 1
  if self.x > mx then
    self.scaley = -1
  end

  self.zIndex = math.floor(self.y)

  self.offsetx = core.math.lerp(self.offsetx, 0, 10 * dt)
  self.offsety = core.math.lerp(self.offsety, 0, 10 * dt)

  self.cooldown:update(dt)
end

function Gun:onMousePressed(x, y, button, isTouch, presses)
  if button == controls.mouse.weapon1 and self.cooldown.isOver then
    local mx, my = core.viewport.getMousePosition("main")
    self:shoot(mx, my)
    self.cooldown:start()
  end
end

function Gun:draw()
  self.sprite:draw(self.x + self.offsetx, self.y + self.offsety, self.rotation, 1, self.scaley)
end

return Gun
