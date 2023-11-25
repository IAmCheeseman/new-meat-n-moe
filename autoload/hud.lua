local characters = require("require.characters")

local font = love.graphics.newImageFont("assets/fonts/custom.png", " abcdefghijklmnopqrstuvwxyz0123456789.,;!'\"/\\")


local function drawCharacterHealth(x, y, w, h, r, g, b, tr, tg, tb, character)
  local health = character.health
  local maxHealth = character.maxHealth

  local percentage = health / maxHealth
  local progressWidth = (w - 2) * percentage

  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("fill", x, y, w, h)
  love.graphics.setColor(r, g, b)
  love.graphics.rectangle("fill", x + 1, y + 1, progressWidth, h - 2)

  love.graphics.setFont(font)
  love.graphics.setColor(tr, tg, tb)
  love.graphics.print(("%d/%d"):format(health, maxHealth), x + w + 2, y)

  love.graphics.setColor(1, 1, 1)
end

core.event.connect("gui", function()
  local active = characters.getActive()
  local inactive = characters.getInactive()

  drawCharacterHealth(1, 1, 48, 8, 1, 0, 0, 1, 1, 1, active)
  drawCharacterHealth(1, 10, 48, 8, 0.5, 0, 0, 0.8, 0.8, 0.8, inactive)
end)
