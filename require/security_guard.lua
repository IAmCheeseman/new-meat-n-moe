local Projectile = require("require.projectile")
local Corpse = require("require.corpse")

local SecurityGuard = core.Class(core.GameObj)
local characters = require("require.characters")
local drawShadow = require("require.shadow")

assets.entities.employee_corpse:setOffsetPreset("center", "bottom")

function SecurityGuard:init()
  self:base("init")

  self.vx, self.vy = 0, 0
  self.gunOffsetX, self.gunOffsetY = 0, 0

  self.speed = 50
  self.accel = 2
  self.frict = 10

  self.scalex = 1

  self.bullet = Projectile

  self.targetDist = 16 * 4
  self.minShootDist = 16 * 3
  self.minShootCooldown = 3
  self.maxShootCooldown = 6

  self.shootTimer = core.Timer((3 + 6) / 2)
  self.retreatTimer = core.Timer(1)

  self.box = core.ResolverBox {
    anchor = self,
    layers = {"enemy"},
    mask = {"env"},
    x = -6,
    y = -12,
    w = 12,
    h = 14,
  }

  self.hurtbox = core.DetectorBox {
    anchor = self,
    x = -7, y = -13,
    w = 14, h = 14,
    layers = {"enemy", "hurtbox"},
    mask = {"bullet"},
  }

  self.health = 20

  self.stateMachine = core.StateMachine(self)
    :addState("idle", {
      update = self.idleUpdate,
    })
    :addState("chase", {
      update = self.chaseUpdate,
    })
    :addState("retreat", {
      enter = self.retreatEnter,
      update = self.retreatUpdate,
    })
    :addState("attack", {
      update = self.attackUpdate,
    })
    :setState("idle")

  self.path = nil
end

function SecurityGuard:takeDamage(amount, kbDir, kbStrength)
  self.health = self.health - amount
  self.vx = self.vx + math.cos(kbDir) * kbStrength
  self.vy = self.vy + math.sin(kbDir) * kbStrength

  if self.health <= 0 and not self.isDead then
    self.isDead = true

    core.objs:remove(self)

    local sprite = assets.entities.employee_corpse:clone()
    local corpse = Corpse(self.vx, self.vy, sprite)
    corpse.x = self.x
    corpse.y = self.y
    core.objs:add(corpse)
  end

  return true
end

function SecurityGuard:update(dt)
  self.stateMachine:update(dt)
  self.sprite:update(dt)

  self.zIndex = self.y
end

function SecurityGuard:idleUpdate(dt)
  local active = characters.getActive()
  local dist = core.math.distanceBetween(self.x, self.y, active.x, active.y)
  if dist < 16 * 5 then
    self.stateMachine:setState("chase")
  end

  self.sprite:play("idle")
end

function SecurityGuard:chaseUpdate(dt)
  self:defaultUpdate(dt, false)

  self.shootTimer:update(dt)

  local active = characters.getActive()
  local dist = core.math.distanceBetween(self.x, self.y, active.x, active.y)

  if dist < self.minShootDist then
    self.stateMachine:setState("retreat")
  end

  if self.shootTimer.isOver and core.viewport.isPointVisible("main", self.x, self.y) then
    self.stateMachine:setState("attack")
    self.shootTimer:start(1)
  end
end

function SecurityGuard:retreatEnter()
  self.retreatTimer:start(core.math.frandom(0.5, 1.5))
end

function SecurityGuard:retreatUpdate(dt)
  self:defaultUpdate(dt, true)

  self.retreatTimer:update(dt)

  if self.retreatTimer.isOver then
    self.stateMachine:setState("chase")
  end
end

function SecurityGuard:defaultUpdate(dt, invertDir)
  local active = characters.getActive()

  self.path = core.pathfinding.getPath(self.x, self.y, active.x, active.y)

  local dirx, diry
  if self.path and self.path._nodes[3] then
    local nextx, nexty = core.pathfinding.nodeToWorld(self.path._nodes[3])
    dirx, diry = core.math.directionTo(self.x, self.y, nextx, nexty)
  else
    dirx, diry = core.math.directionTo(self.x, self.y, active.x, active.y)
  end

  if invertDir then
    dirx = -dirx
    diry = -diry
  end

  self.vx = core.math.lerp(self.vx, dirx * self.speed, self.accel * dt)
  self.vy = core.math.lerp(self.vy, diry * self.speed, self.accel * dt)

  self.scalex = self.vx < 0 and -1 or 1

  self.vx, self.vy = self.box:moveAndCollide(self.vx, self.vy, dt)

  self.sprite:play("walk")
end

function SecurityGuard:attackUpdate(dt)
  self.sprite:play("aim")

  self.vx = core.math.lerp(self.vx, 0, self.frict * dt)
  self.vy = core.math.lerp(self.vy, 0, self.frict * dt)

  self.vx, self.vy = self.box:moveAndCollide(self.vx, self.vy, dt)

  local active = characters.getActive()

  self.scalex = active.x < self.x and -1 or 1

  self.shootTimer:update(dt)

  if self.shootTimer.isOver then
    local angle = core.math.angleBetween(self.x, self.y, active.x, active.y)
    local bx, by = self.x + math.cos(angle) * 7, self.y - 6 + math.sin(angle) * 7

    local bullet = self.bullet(angle, 200)
    bullet.x, bullet.y = bx, by
    bullet.sprite = assets.entities.enemy_bullet
    bullet.damageMask = "player"

    core.objs:add(bullet)

    self.stateMachine:setState("retreat")
    self.shootTimer:start(core.math.frandom(self.minShootCooldown, self.maxShootCooldown))
  end
end

function SecurityGuard:draw()
  local x, y = math.floor(self.x), math.floor(self.y)
  drawShadow(x, y, self.sprite)
  self.sprite:draw(x, y, 0, self.scalex, 1)

  if self.stateMachine:getState() == "attack" then
    local active = characters.getActive()
    local angle = core.math.angleBetween(self.x, self.y, active.x, active.y)
    local scaley = active.x < self.x and -1 or 1
    self.gunSprite:draw(x + self.gunOffsetX * self.scalex, y + self.gunOffsetY, angle, 1, scaley)
  end

  -- if self.path then
  --   core.pathfinding.drawPath(self.path)
  -- end
end

return SecurityGuard
