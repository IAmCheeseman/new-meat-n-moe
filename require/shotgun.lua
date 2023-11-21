local Gun = require("require.gun")
local Pellet = require("require.pellet")
local controls = require("controls")

local Shotgun = core.Class(Gun)

function Shotgun:init(boundObj)
  self:base("init", boundObj)
  self.sprite = assets.entities.meat_gun
  self.sprite:setOffsetPreset("left", "center")

  self.targetOffsetY = self.sprite.height / 2
end

function Shotgun:shoot(mx, my)
  local total = 10
  local spread = math.pi / 50
  local angle = core.math.angle(mx - self.x, my - self.y) - (spread * (total / 2))

  for i=1, total do
    local bulletDir = angle
    local proj = Pellet(bulletDir, 400 + love.math.random() * 200)
    proj.x = self.x + math.cos(bulletDir) * 5
    proj.y = self.y + math.sin(bulletDir) * 5

    core.objs:add(proj)

    angle = angle + spread
  end

  self.offsetx = self.offsetx + math.cos(angle + math.pi) * 10
  self.offsety = self.offsety + math.sin(angle + math.pi) * 10
end

return Shotgun
