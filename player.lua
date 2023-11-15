local keybinds = require("keybinds")
local Pistol = require("pistol")

local Player = core.Class(core.GameObj)

function Player:init()
  self:base("init")

  self.x = 0
  self.y = 0
  self.vx = 0
  self.vy = 0

  self.speed = 110
  self.accel = 5
  self.frict = 10

  self.sprite = assets.entities.moe
  self.sprite:setOffsetPreset("center", "center")

  self.gun = Pistol(self)
  core.objs:add(self.gun)

  self.stateMachine = core.StateMachine(self)
      :addState("default", {
        update = self.defaultUpdate,
        draw = self.defaultDraw,
      })
      :setState("default")

  self.box = core.ResolverBox {
    anchor = self,
    layers = {"player"},
    mask = {"default"},
    test = "player collision",
    x = -6,
    y = -6,
    w = 12,
    h = 12,
  }

  self.hitbox = core.DetectorBox {
    anchor = self,
    layers = {"player"},
    mask = {"default"},
    test = "player hitbox",
    x = -7,
    y = -7,
    w = 14,
    h = 14
  }
end

function Player:update(dt)
  self.stateMachine:update(dt)
end

function Player:draw()
  self.stateMachine:draw()
end

function Player:defaultUpdate(dt)
  local ix, iy = 0, 0
  if love.keyboard.isDown(keybinds.up) then iy = iy - 1 end
  if love.keyboard.isDown(keybinds.left) then ix = ix - 1 end
  if love.keyboard.isDown(keybinds.down) then iy = iy + 1 end
  if love.keyboard.isDown(keybinds.right) then ix = ix + 1 end
  ix, iy = core.math.normalize(ix, iy)

  local accel = self.accel
  if core.math.dot(ix, iy, self.vx, self.vy) < 0.5 then
    accel = self.frict
  end

  self.vx = core.math.lerp(self.vx, ix * self.speed, accel * dt)
  self.vy = core.math.lerp(self.vy, iy * self.speed, accel * dt)

  self.box:moveAndCollide(self.vx, self.vy, dt)
end

function Player:defaultDraw()
  local mx, _ = core.viewport.getMousePosition("main")
  self.sprite:draw(self.x, self.y, 0, mx > self.x and -1 or 1, 1)
end

return Player
