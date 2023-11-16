love.graphics.setDefaultFilter("nearest", "nearest")

core = require("core")
assets = core.assets.load("assets")
assetDirectory = "assets/"

core.viewport.setBackgroundColor("main", 0.25, 0.5, 0.35)
core.callbacks()

local Player = require("player")

local anchor = { x=40, y=40 }

local box = core.ResolverBox {
  anchor = anchor,
  test = "pasta"
}

local layers = {}

function love.load()
  core.objs:add(Player())
  layers = core.tiled.openLevel(assetDirectory, "assets.level1")
end

core.event.connect("draw", function()
  for _, v in ipairs(layers) do
    if v.type == "tilelayer" then
      v:draw()
    end
  end
end)

