local Gun = require("require.gun")
local Pellet = require("require.pellet")
local controls = require("controls")
local camera = require("autoload.camera")

local Shotgun = core.Class(Gun)
local shootSfx = assets.sounds.shotgun

function Shotgun:init(boundObj)
  self:base("init", boundObj, 1.6)
  self.sprite = assets.images.meat_gun:clone()
  self.sprite:setOffsetPreset("left", "center")

  self.targetOffsetY = -self.sprite.height / 2
end

function Shotgun:shoot(mx, my)
  local shootSource = love.audio.newSource(shootSfx)
  shootSource:setPitch(core.math.frandom(1, 1.2))
  shootSource:play()

  camera.screenshake(5, 0.3, 0.025, 1, 3, true)

  local total = 10
  local spread = math.pi / 50
  local angle = core.math.angle(mx - self.x, my - self.y) - (spread * (total / 2))

  for _=1, total do
    local bulletDir = angle

    local proj = Pellet(bulletDir, core.math.frandom(400, 600), self)
    proj.damage = 3
    proj.x = self.x + math.cos(bulletDir) * 5
    proj.y = self.y + math.sin(bulletDir) * 5
    proj.damageMask = "enemy"

    core.objs:add(proj)

    angle = angle + spread
  end

  self.offsetx = self.offsetx + math.cos(angle + math.pi) * 10
  self.offsety = self.offsety + math.sin(angle + math.pi) * 10

  self.boundObj.vx = self.boundObj.vx - math.cos(angle) * 100
  self.boundObj.vy = self.boundObj.vy - math.sin(angle) * 100
end

return Shotgun
