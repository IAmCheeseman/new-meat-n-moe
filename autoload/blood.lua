local canvas

assets.images.blood:initAnimation(3, 1, {})
assets.images.blood:setOffsetPreset("center", "center")
local bloodSplats = assets.images.blood:clone()

local BloodDrawer = core.Class(core.GameObj)

function BloodDrawer:init()
  self:base("init")
  self.zIndex = -1
end

function BloodDrawer:draw()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(canvas, 0, 0)
end

core.event.connect("levelChanged", function(level)
  canvas = love.graphics.newCanvas(level.pixelWidth, level.pixelHeight)
  core.objs:add(BloodDrawer())
end)

local blood = {}

function blood.add(x, y, r, g, b)
  r = r or 0.8
  g = g or 0
  b = b or 0.2

  local prevCanvas = love.graphics.getCanvas()

  love.graphics.setCanvas(canvas)
  bloodSplats.frame = love.math.random(1, bloodSplats.hframes)
  bloodSplats.modulate = {r, g, b}
  bloodSplats:draw(x, y, core.math.frandom(0, math.pi * 2), core.math.frandom(0.8, 1.2))
  love.graphics.setColor(1, 1, 1)
  love.graphics.setCanvas(prevCanvas)
end

function blood.coverDamager(damaged, damager)
  local base = damager
  while base.owner do
    base = base.owner
  end

  if base.bloodStrength then
    base.bloodStrength = core.math.clamp(base.bloodStrength + 0.2, 0, 1)
  end
end

return blood
