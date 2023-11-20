love.graphics.setDefaultFilter("nearest", "nearest")

core = require("core")
assets = core.assets.load("assets")
core.assets.loadScripts("objects/")
assetDirectory = "assets/"

core.viewport.setBackgroundColor("main", 0.25, 0.5, 0.35)
core.tiled.setTilemapCollisionLayers("office", "env")
core.callbacks()

local Cursor = require("objects.cursor")

local layers = {}

function love.load()
  layers = core.tiled.openLevel(assetDirectory, "assets.level1")

  core.objs:add(Cursor())

  core.objSpawner:spawnMap(layers)

  for _, v in ipairs(layers) do
    if v.type == "tilelayer" then
      core.tiled.generateTileLayerCollision(v)
      core.objs:add(v)
    elseif v.type == "imagelayer" then
      core.objs:add(v)
    end
  end
end

