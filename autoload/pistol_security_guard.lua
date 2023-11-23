local SecurityGuard = require("require.security_guard")

local PistolSecurityGuard = core.Class(SecurityGuard)

local animations = {
  idle = { from=1, to=2 },
  walk = { from=4, to=6 },
  aim  = { from=7, to=7 },
}
assets.entities.employee:initAnimation(3, 3, animations)
assets.entities.employee_bloody:initAnimation(3, 3, animations)

function PistolSecurityGuard:init()
  self:base("init")

  self.gunOffsetX = 3
  self.gunOffsetY = -6

  self.sprite = assets.entities.employee
  self.gunSprite = assets.entities.employee_gun

  self.sprite:setOffsetPreset("center", "bottom")
  self.gunSprite:setOffsetPreset("left", "center")
end

core.objSpawner:register("PistolSecurityGuard", function(obj)
  local securityGuard = PistolSecurityGuard()
  securityGuard.x = obj.x
  securityGuard.y = obj.y

  return securityGuard
end)

return PistolSecurityGuard
