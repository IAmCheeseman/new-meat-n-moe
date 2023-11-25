local Weapon = require("require.weapon")
local characters = require("require.characters")
local controls   = require("controls")

local Hand = core.Class(Weapon)

assets.images.meat_hand:setOffsetPreset("left", "center")
assets.images.meat_hand.offsetx = -6

function Hand:init(boundObj)
  self:base("init", boundObj)

  self.sprite = assets.images.meat_hand:clone()

  self.targetOffsetY = -self.boundObj.sprite.height / 3

  self.damage = 20

  self.offsetx = 0
  self.offsety = 0

  self.cooldown = core.Timer(0.5)

  self.hitbox = core.DetectorBox {
    anchor = self,
    w = 8, h = 8,
    layers = {"player"},
    mask = {"hurtbox"},
  }
end

function Hand:update(dt)
  self:base("update", dt)

  if characters.getActive() == self.boundObj then
    local mx, my = core.viewport.getMousePosition("main")
    self.rotation = core.math.angleBetween(self.x, self.y, mx, my)
  else
    self.rotation = core.math.angle(self.boundObj.vx, self.boundObj.vy)
  end

  self.offsetx = core.math.lerp(self.offsetx, 0, 10 * dt)
  self.offsety = core.math.lerp(self.offsety, 0, 10 * dt)

  self.zIndex = self.boundObj.zIndex + 1

  self.cooldown:update(dt)

  local isActive = characters.getActive() == self.boundObj
  local cooldownOver = self.cooldown.isOver
  if love.mouse.isDown(controls.mouse.weapon2) and cooldownOver and isActive then
    local mx, my = core.viewport.getMousePosition("main")
    self.boundObj:activateWeapon(self)
    self:punch(mx, my)
    self.cooldown:start()
  end
end

function Hand:punch(mx, my)
  local angle = core.math.angleBetween(self.x, self.y, mx, my)

  self.offsetx = math.cos(angle) * 5
  self.offsety = math.sin(angle) * 5

  self.hitbox.x = (math.cos(angle) * 15) - self.hitbox.w / 2
  self.hitbox.y = (math.sin(angle) * 15) - self.hitbox.h / 2

  for obj, box in self.hitbox:iterColliding() do
    if box:isInLayer("hurtbox") then
      if not obj.takeDamage then
        error("Object with hurtbox does not have `takeDamage` method.")
      end

      if box:isInLayer("enemy") then
        obj:takeDamage(self.damage, angle, 300)
      end
    end
  end
end

function Hand:draw()
  if not self.visible then
    return
  end
  self.sprite:draw(self.x + self.offsetx, self.y + self.offsety, self.rotation, 1, self.scaley)
end

return Hand
