love.graphics.setDefaultFilter("nearest", "nearest")

core = require("core")
assets = core.assets.load("assets")

core.viewport.setBackgroundColor("main", 0.25, 0.5, 0.35)
core.callbacks()

local Player = require("player")

local anchor = { x=40, y=40 }

local box = core.ResolverBox {
  anchor = anchor,
  test = "pasta"
}

function love.load()
  core.objs:add(Player())
end

