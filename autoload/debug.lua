local function fps()
  return love.timer.getFPS() .. " FPS"
end

local function objs()
  return core.objs:count() .. " Objects"
end

local menu = {
  fps,
  objs
}

local visible = false

core.event.connect("keyPressed", function(key, isRepeat)
  if not isRepeat and key == "f3" then
    visible = not visible
  end
end)

core.event.connect("gui", function()
  if not visible then
    return
  end

  local font = love.graphics.getFont()
  local height = font:getHeight()
  local y = 0
  for _, item in ipairs(menu) do
    love.graphics.print(item(), 0, y)
    y = y + height * 1.2
  end
end)

