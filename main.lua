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

local Cursor = require("require.cursor")
local discord = require("discord")

local layers = {}

function love.load()
  discord.init()

  layers = core.tiled.openLevel(assetDirectory, "assets.level1")

  core.objs:add(Cursor())

  core.objSpawner:spawnMap(layers)

  for _, v in ipairs(layers) do
    if v.type == "tilelayer" then
      if v.name == "Tiles" then
        core.pathfinding.initWithTileLayer(v)
      end

      core.tiled.generateTileLayerCollision(v)
      core.objs:add(v)
    elseif v.type == "imagelayer" then
      core.objs:add(v)
    end
  end
end

function love.quit()
  discord.quit()
end

local fullscreen = love.window.getFullscreen()

core.event.connect("keyPressed", function(key, isRepeat)
  if key == controls.keys.fullscreen then
    fullscreen = not fullscreen
    love.window.setFullscreen(fullscreen, "desktop")
  end
end)
