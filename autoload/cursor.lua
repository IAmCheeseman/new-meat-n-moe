assets.images.cursor:setOffsetPreset("center", "center")
local sprite = assets.images.cursor

love.mouse.setVisible(false)

core.event.connect("gui", function()
  local mx, my = core.viewport.getMousePosition("gui")
  sprite:draw(mx, my)
end)

