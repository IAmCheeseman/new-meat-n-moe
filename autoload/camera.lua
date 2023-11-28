local camera = {}

local jumpTimer = core.Timer(0)
local shakeTimer = core.Timer(0)

local x, y = 0, 0

camera.trackSpeed = 12
camera.boundObj = nil

local screenshake = {
  priority = 0,
  x = 0,
  y = 0,
  time = 0,
  freq = 0,
  strengthMin = 0,
  strengthMax = 0,
  reduce = false,
  angle = nil,
}

function camera.jump(angle, strength)
  screenshake.x = math.cos(angle) * strength
  screenshake.y = math.sin(angle) * strength
end

core.event.connect("update", function(dt)
  if jumpTimer.justOver and not shakeTimer.isOver then
    local angle = screenshake.angle
    if not angle then
      angle = core.math.frandom(0, math.pi * 2)
    end
    if screenshake.reduce then
      angle = angle * (shakeTimer.timeLeft / shakeTimer.totalTime)
    end
    camera.jump(
        angle,
        core.math.frandom(screenshake.strengthMin, screenshake.strengthMax))
    jumpTimer:start()
  end

  if shakeTimer.isOver then
    screenshake.priority = 0
    jumpTimer:stop()
  end

  screenshake.x = core.math.lerp(screenshake.x, 0, 12 * dt)
  screenshake.y = core.math.lerp(screenshake.y, 0, 12 * dt)

  jumpTimer:update()
  shakeTimer:update()

  if camera.boundObj then
    local cw, ch = core.viewport.getSize("main")
    local mx, my = core.viewport.getMousePosition("main")
    local dist = core.math.distanceBetween(
        camera.boundObj.x, camera.boundObj.y, mx, my) * 0.2
    dist = core.math.clamp(dist, 0, 16)
    local angle = core.math.angleBetween(
        camera.boundObj.x, camera.boundObj.y, mx, my)

    local tx = camera.boundObj.x - cw / 2 + math.cos(angle) * dist
    local ty = camera.boundObj.y - ch / 2 + math.sin(angle) * dist

    x = core.math.lerp(x, tx, camera.trackSpeed * dt)
    y = core.math.lerp(y, ty, camera.trackSpeed * dt)

    core.viewport.setCameraPos("main", x + screenshake.x, y + screenshake.y)
  end
end)

function camera.screenshake(
    priority, time, freq, strengthMin, strengthMax, reduce, angle)
  reduce = reduce or false

  if priority <= screenshake.priority then
    return
  end

  screenshake.priority = priority
  screenshake.time = time
  screenshake.freq = freq
  screenshake.strengthMin = strengthMin
  screenshake.strengthMax = strengthMax
  screenshake.reduce = reduce
  screenshake.angle = angle

  jumpTimer:start(freq)
  shakeTimer:start(time)
end

return camera
