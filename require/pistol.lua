local Gun = require("require.gun")
local Projectile = require("require.projectile")
local controls = require("controls")

local Pistol = core.Class(Gun)

function Pistol:init(boundObj)
  self:base("init", boundObj)
  self.sprite = assets.entities.moe_gun
end

function Pistol:onMousePressed(x, y, button, isTouch, presses)
  local mx, my = core.viewport.getMousePosition("main")
  local angle = core.math.angle(mx - self.x, my - self.y)
  local proj = Projectile(angle, 400)
  proj.x = self.x + math.cos(angle) * 5
  proj.y = self.y + math.sin(angle) * 5

  core.objs:add(proj)

  self.offsetx = self.offsetx + math.cos(angle + math.pi) * 5
  self.offsety = self.offsety + math.sin(angle + math.pi) * 5
end

return Pistol
