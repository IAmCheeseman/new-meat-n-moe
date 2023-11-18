love.graphics.setDefaultFilter("nearest", "nearest")

core = require("core")
assets = core.assets.load("assets")
assetDirectory = "assets/"

core.viewport.setBackgroundColor("main", 0.25, 0.5, 0.35)
core.tiled.setTilemapCollisionLayers("office", "env")
core.callbacks()

local Player = require("player")
local Cursor = require("cursor")

local layers = {}

function love.load()
  layers = core.tiled.openLevel(assetDirectory, "assets.level1")

  core.objs:add(Cursor())

  for _, v in ipairs(layers) do
    if v.type == "tilelayer" then
      core.tiled.generateTileLayerCollision(v)
      core.objs:add(v)
    elseif v.type == "imagelayer" then
      core.objs:add(v)
    end

    if v.type == "objectgroup" then
      for _, obj in ipairs(v.objs) do
        if obj.type == "Player" then
          local player = Player()
          player.x = obj.x
          player.y = obj.y
          core.objs:add(player)
        end
      end
    end
  end
end

