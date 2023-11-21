local controls = require("controls")

local Player = core.Class(core.GameObj)

function Player:init()
  self:base("init")

  self.x = 0
  self.y = 0
  self.vx = 0
  self.vy = 0

  self.n = core.assets.noise(11, 11, 0.5, 1)
  self.blood = love.graphics.newShader("blood.frag")
  self.blood:send("noise", self.n)
  self.blood:send("strength", 0)

  self.speed = 110
  self.accel = 5
  self.frict = 10

  self.stateMachine = core.StateMachine(self)
      :addState("default", {
        update = self.defaultUpdate,
        draw = self.defaultDraw,
      })
      :setState("default")

  self.box = core.ResolverBox {
    anchor = self,
    layers = {"player"},
    mask = {"env"},
    x = -6,
    y = -6,
    w = 12,
    h = 12,
  }

  self.hitbox = core.DetectorBox {
    anchor = self,
    layers = {"player"},
    mask = {"default"},
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

function Player:getInputVector()
  local ix, iy = 0, 0
  if love.keyboard.isDown(controls.keys.up) then iy = iy - 1 end
  if love.keyboard.isDown(controls.keys.left) then ix = ix - 1 end
  if love.keyboard.isDown(controls.keys.down) then iy = iy + 1 end
  if love.keyboard.isDown(controls.keys.right) then ix = ix + 1 end
  ix, iy = core.math.normalize(ix, iy)
  return ix, iy
end

function Player:defaultUpdate(dt)
  local ix, iy = self:getInputVector()

  local accel = self.accel
  if core.math.dot(ix, iy, self.vx, self.vy) < 0.5 then
    accel = self.frict
  end

  self.vx = core.math.lerp(self.vx, ix * self.speed, accel * dt)
  self.vy = core.math.lerp(self.vy, iy * self.speed, accel * dt)

  self.box:moveAndCollide(self.vx, self.vy, dt)

  local cw, ch = core.viewport.getSize("main")
  core.viewport.setCameraPos("main", self.x - cw / 2, self.y - ch / 2)
end

function Player:defaultDraw()
end

return Player
