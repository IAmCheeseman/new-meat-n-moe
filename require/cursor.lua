
local Cursor = core.Class(core.GameObj)

function Cursor:init()
  self:base("init")

  love.mouse.setVisible(false)

  self.sprite = assets.images.cursor
  self.sprite:setOffsetPreset("center", "center")
end

function Cursor:gui()
  local mx, my = core.viewport.getMousePosition("gui")
  self.sprite:draw(mx, my)
end

return Cursor
