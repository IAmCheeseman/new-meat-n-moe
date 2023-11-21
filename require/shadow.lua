local function drawShadow(x, y, sprite)
  love.graphics.setColor(0, 0, 0, 0.5)
  love.graphics.ellipse("fill", x, y, sprite.width / 2, 2)
  love.graphics.setColor(1, 1, 1)
end

return drawShadow
