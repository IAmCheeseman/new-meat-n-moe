love.graphics.setDefaultFilter("nearest", "nearest")

core = require("core")
assets = core.assets.load("assets")
assetDirectory = "assets/"

core.viewport.setBackgroundColor("main", 0.25, 0.5, 0.35)
core.callbacks()

local Player = require("player")

local layers = {}

function love.load()
  layers = core.tiled.openLevel(assetDirectory, "assets.level1")

  for _, v in ipairs(layers) do
    if v.type == "tilelayer" then
      core.tiled.generateTileLayerCollision(v)
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

core.event.connect("draw", function()
  for _, v in ipairs(layers) do
    if v.type == "tilelayer" then
      v:draw()
    end
  end
end)

