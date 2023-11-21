---@diagnostic disable: need-check-nil, undefined-field
local controls = require("controls")
local characters = require("require.characters")

local Player = core.Class(core.GameObj)

local function onKeyPressed(key, isRepeat)
  if not isRepeat and key == controls.keys.swap then
    characters.swap()
  end
end

core.event.connect("keyPressed", onKeyPressed)

function Player:init()
  self:base("init")

  characters.init(self)

  self.x = 0
  self.y = 0
  self.vx = 0
  self.vy = 0

  self.n = core.assets.noise(11, 11, 0.5, 1)
  self.blood = love.graphics.newShader("vfx/blood.frag")
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
      :addState("inactive", {
        update = self.inactiveUpdate,
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
  local cx, cy = core.viewport.getCameraPos("main")

  core.viewport.setCameraPos("main",
      core.math.lerp(cx, self.x - cw / 2, 12 * dt),
      core.math.lerp(cy, self.y - ch / 2, 12 * dt))

  if characters.getActive() ~= self then
    self.stateMachine:setState("inactive")
  end
end

function Player:inactiveUpdate(dt)
  local tx, ty = characters.getActive().x, characters.getActive().y
  local dx, dy = core.math.directionTo(self.x, self.y, tx, ty)
  local dist = core.math.distanceBetween(self.x, self.y, tx, ty)

  if dist > 16 * 3 then
    self.x, self.y = tx, ty
  end

  if dist > 16 then
    local accel = self.accel
    if core.math.dot(dx, dy, self.vx, self.vy) < 0.5 then
      accel = self.frict
    end

    self.vx = core.math.lerp(self.vx, dx * self.speed, accel * dt)
    self.vy = core.math.lerp(self.vy, dy * self.speed, accel * dt)
  else
    self.vx = core.math.lerp(self.vx, 0, self.frict * dt)
    self.vy = core.math.lerp(self.vy, 0, self.frict * dt)
  end

  self.box:moveAndCollide(self.vx, self.vy, dt)

  if characters.getActive() == self then
    self.stateMachine:setState("default")
  end
end

function Player:defaultDraw()
end

return Player
