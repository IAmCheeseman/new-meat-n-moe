local Player = require("require.player")
local Pistol = require("require.pistol")
local characters = require("require.characters")

local Moe = core.Class(Player)

function Moe:init()
  self:base("init")

  self.bob = 0

  self.sprite = assets.entities.moe
  self.sprite:setOffsetPreset("center", "center")
  self.bloodSprite = assets.entities.moe_bloody
  self.bloodSprite:setOffsetPreset("center", "center")

  self.gun = Pistol(self)
  core.objs:add(self.gun)
end

function Moe:defaultUpdate(dt)
  self:base("defaultUpdate", dt)

  local animSpeed = 3 + core.math.length(self.vx, self.vy) / self.speed * 24
  self.bob = core.math.lerp(self.bob, math.sin(core.getRuntime() * animSpeed) * 1.4, 15 * dt)
end

function Moe:defaultDraw()
  local mx, _ = core.viewport.getMousePosition("main")

  local y = math.floor(self.y + self.bob)
  local x = math.floor(self.x)
  local scalex = mx > self.x and -1 or 1
  local active = characters.getActive()
  if active ~= self then
    scalex = active.x > self.x and -1 or 1
  end

  self.sprite:draw(x, y, 0, scalex, 1)

  love.graphics.setShader(self.blood)
  self.bloodSprite:draw(x, y, 0, scalex, 1)
  love.graphics.setShader()
end

core.objSpawner:register("Moe", function(obj)
  local moe = Moe()
  moe.x = obj.x
  moe.y = obj.y

  return moe
end)

return Moe
