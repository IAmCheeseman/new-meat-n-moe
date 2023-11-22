local Gun = require("require.gun")
local Projectile = require("require.projectile")
local controls = require("controls")

local Pistol = core.Class(Gun)
local shootSfx = assets.sounds.pistol

function Pistol:init(boundObj)
  self:base("init", boundObj, 0.7)
  self.sprite = assets.entities.moe_gun
  self.sprite:setOffsetPreset("left", "center")

  self.targetOffsetY = -self.sprite.height / 2
end

function Pistol:shoot(mx, my)
  local shootSource = love.audio.newSource(shootSfx)
  shootSource:play()

  local angle = core.math.angle(mx - self.x, my - self.y)
  local proj = Projectile(angle, 400)
  proj.x = self.x + math.cos(angle) * 5
  proj.y = self.y + math.sin(angle) * 5

  core.objs:add(proj)

  self.offsetx = self.offsetx + math.cos(angle + math.pi) * 5
  self.offsety = self.offsety + math.sin(angle + math.pi) * 5
end

return Pistol
