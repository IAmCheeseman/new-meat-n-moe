local Player = require("require.player")
local Shotgun = require("require.shotgun")
local Hand = require("require.hand")
local characters = require("require.characters")
local drawShadow = require("require.shadow")
local decal = require("autoload.decal")
local controls = require("controls")

local Meat = core.Class(Player)

local animations = {
  idle = { from=1, to=2 },
  walk = { from=7, to=12 },
}
assets.images.meat:initAnimation(6, 3, animations)
assets.images.meat_bloody:initAnimation(6, 3, animations)

function Meat:init()
  self:base("init", 150)

  self.sprite = assets.images.meat:clone()
  self.sprite:setOffsetPreset("center", "bottom")
  self.bloodSprite = assets.images.meat_bloody:clone()
  self.bloodSprite:setOffsetPreset("center", "bottom")

  self.speed = 90

  local gun = Shotgun(self)
  core.objs:add(gun)
  self:addWeapon(gun)

  local hand = Hand(self)
  core.objs:add(hand)
  self:addWeapon(hand)

  self:activateWeapon(gun)

  core.event.connect("keyPressed", self.onKeyPressed, self)
end

function Meat:onKeyPressed(key, isRepeated)
  if key == controls.keys.ability2 and not isRepeated then
    local ix, iy = self:getInputVector()
    local teleportDistance = 16 * 4

    for _=1, 5 do
      local angle = core.math.frandom(0, math.pi * 2)
      local dist = core.math.frandom(0, 32)
      decal.blood(
        self.x + math.cos(angle) * dist,
        self.y + math.sin(angle) * dist)
    end

    local angle = core.math.angle(ix, iy)
    local splatCount = 5
    for i=1, splatCount do
      local dist = (i / splatCount) * teleportDistance
      decal.blood(
        self.x + math.cos(angle) * dist,
        self.y + math.sin(angle) * dist)
    end

    self.x = self.x + ix * teleportDistance
    self.y = self.y + iy * teleportDistance
  end
end

function Meat:takeDamage(...)
  local res = self:base("takeDamage", ...)

  if characters.getActive() == self then
    decal.blood(self.x, self.y)
  end

  return res
end

function Meat:defaultUpdate(dt)
  self:base("defaultUpdate", dt)
  self.sprite:update()
  self.bloodSprite.frame = self.sprite.frame
end

function Meat:inactiveUpdate(dt)
  self:base("inactiveUpdate", dt)
  self.sprite:update()
  self.bloodSprite.frame = self.sprite.frame
end

function Meat:defaultDraw()
  self:base("defaultDraw")

  local mx, _ = core.viewport.getMousePosition("main")

  local x = math.floor(self.x)
  local y = math.floor(self.y)
  drawShadow(x, y, self.sprite)

  local scalex = mx > self.x and -1 or 1
  local active = characters.getActive()
  if active ~= self then
    scalex = active.x > self.x and -1 or 1
  end

  self:drawSprite(x, y, 0, scalex, 1)

  local ix, iy = self:getInputVector()

  if core.math.length(ix, iy) ~= 0 then
    self.sprite:play("walk")
    self.bloodSprite:play("walk")
  else
    self.sprite:play("idle")
    self.bloodSprite:play("idle")
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
