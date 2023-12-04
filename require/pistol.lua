local Gun = require("require.gun")
local Projectile = require("require.projectile")
local camera = require("autoload.camera")

local Pistol = core.Class(Gun)
local shootSfx = core.SoundPlayer(assets.sounds.pistol, 7)

function Pistol:init(boundObj)
  self:base("init", boundObj, 0.2)
  self.sprite = assets.images.moe_gun
  self.sprite:setOffsetPreset("left", "center")
  self.sprite.offsetx = 5

  self.targetOffsetY = -2
end

function Pistol:shoot(mx, my)
  shootSfx:setPitch(core.math.frandom(1, 1.2))
  shootSfx:play()

  local spread = math.pi / 30

  local angle = core.math.angle(mx - self.x, my - self.y)
  angle = angle + core.math.frandom(-spread, spread)
  local proj = Projectile(angle, 400, self)
  proj.x = self.x + math.cos(angle) * 7
  proj.y = self.y + math.sin(angle) * 7
  proj.damage = 4
  proj.damageMask = "enemy"

  core.objs:add(proj)

  self.offsetx = self.offsetx + math.cos(angle + math.pi) * 5
  self.offsety = self.offsety + math.sin(angle + math.pi) * 5

  camera.screenshake(5, 0.05, 0.05, 2, 4, false, angle + math.pi)
end

return Pistol
