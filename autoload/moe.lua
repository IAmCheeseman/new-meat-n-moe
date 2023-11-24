local Player = require("require.player")
local Pistol = require("require.pistol")
local characters = require("require.characters")
local drawShadow = require("require.shadow")

local Moe = core.Class(Player)

function Moe:init()
  self:base("init", 100)

  self.bob = 0

  self.sprite = assets.entities.moe:clone()
  self.sprite:setOffsetPreset("center", "bottom")
  self.bloodSprite = assets.entities.moe_bloody:clone()
  self.bloodSprite:setOffsetPreset("center", "bottom")

  self.gun = Pistol(self)
  core.objs:add(self.gun)
end

function Moe:updateBob(dt)
  local ix, iy = self:getInputVector()
  local animSpeed = 8
  if core.math.length(ix, iy) ~= 0 then
    animSpeed = 24
  end
  self.bob = core.math.lerp(self.bob, math.sin(core.getRuntime() * animSpeed) * 1.4, 15 * dt)
end

function Moe:defaultUpdate(dt)
  self:base("defaultUpdate", dt)

  self:updateBob(dt)
end

function Moe:inactiveUpdate(dt)
  self:base("inactiveUpdate", dt)

  self:updateBob(dt)
end

function Moe:defaultDraw()
  local mx, _ = core.viewport.getMousePosition("main")

  local x = math.floor(self.x)
  local y = math.floor(self.y + self.bob)

  drawShadow(x, math.floor(self.y), self.sprite)

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
