local Weapon = require("require.weapon")
local Pellet = require("require.pellet")
local controls = require("controls")

local Pistol = core.Class(Weapon)

function Pistol:init(boundObj)
  self:base("init", boundObj)
  self.sprite = assets.entities.meat_gun

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
    local total = 10
    local mx, my = core.viewport.getMousePosition("main")
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
  end
end

function Pistol:draw()
  self.sprite:draw(self.x, self.y, self.rotation, 1, self.scaley)
end

return Pistol
