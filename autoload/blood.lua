local canvas

assets.effects.blood:initAnimation(3, 1, {})
assets.effects.blood:setOffsetPreset("center", "center")
local bloodSplats = assets.effects.blood:clone()

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
  bloodSplats:draw(x, y, core.math.frandom(0, math.pi * 2))
  love.graphics.setColor(1, 1, 1)
  love.graphics.setCanvas(prevCanvas)
end

return blood
