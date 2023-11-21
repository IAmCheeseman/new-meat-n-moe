local Player = require("require.player")
local Pistol = require("require.pistol")

local Meat = core.Class(Player)

assets.entities.meat:initAnimation(6, 3, {
  idle = { from=1, to=2 },
  walk = { from=7, to=11 },
})

function Meat:init()
  self:base("init")

  self.sprite = assets.entities.meat
  self.sprite:setOffsetPreset("center", "center")
  self.bloodSprite = assets.entities.meat_bloody
  self.bloodSprite:setOffsetPreset("center", "center")

  self.gun = Pistol(self)
  core.objs:add(self.gun)
end

function Meat:defaultUpdate(dt)
  self:base("defaultUpdate", dt)
  self.sprite:update(dt)
end

function Meat:defaultDraw()
  local mx, _ = core.viewport.getMousePosition("main")

  local y = math.floor(self.y)
  local x = math.floor(self.x)
  local scalex = mx > self.x and -1 or 1

  self.sprite:draw(x, y, 0, scalex, 1)

  local ix, iy = self:getInputVector()

  if core.math.length(ix, iy) ~= 0 then
    self.sprite:play("walk")
  else
    self.sprite:play("idle")
  end

  love.graphics.setShader(self.blood)
  self.bloodSprite:draw(x, y, 0, scalex, 1)
  love.graphics.setShader()
end

core.objSpawner:register("Meat", function(obj)
  local meat = Meat()
  meat.x = obj.x
  meat.y = obj.y

  return meat
end)

return Meat
