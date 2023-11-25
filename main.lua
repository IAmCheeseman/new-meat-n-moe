local controls = require("controls")

love.graphics.setDefaultFilter("nearest", "nearest")
love.graphics.scale(0.4)

core = require("core")
assets = core.assets.load("assets")
core.assets.loadScripts("autoload/")
assetDirectory = "assets/"

core.viewport.setBackgroundColor("main", 0.25, 0.5, 0.35)
core.tiled.setTilemapCollisionLayers("office", "env")
core.callbacks()

local discord = require("discord")

function love.load()
  discord.init()

  core.level.load("assets.level1")
end

function love.quit()
  discord.quit()
end

local fullscreen = love.window.getFullscreen()

core.event.connect("keyPressed", function(key, _)
  if key == controls.keys.fullscreen then
    fullscreen = not fullscreen
    love.window.setFullscreen(fullscreen, "desktop")
  end
end)
