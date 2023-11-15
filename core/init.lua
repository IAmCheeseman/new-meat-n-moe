local path = (...):gsub("%.init$", "")

local core = {}

local App = require(path .. ".app")
local app = App()

core.objs = app.objList

core.math           = require(path .. ".mathf")
core.assets         = require(path .. ".asset_loader")
core.viewport       = require(path .. ".viewport")
core.event          = require(path .. ".event")

core.viewport.create("main", 320, 180, true)

core.event.init(app.objList)
core.event.define("keyPressed")
core.event.define("keyReleased")
core.event.define("mousePressed")
core.event.define("mouseReleased")
core.event.define("mouseMoved")

core.Class          = require(path .. ".class")
core.StateMachine   = require(path .. ".state_machine")
core.GameObj        = require(path .. ".game_obj")
core.SparseSet      = require(path .. ".object.sparse_set")
core.Array          = require(path .. ".object.array")
core.ResolverBox    = require(path .. ".physics.resolver_box")
core.DetectorBox    = require(path .. ".physics.detector_box")

local physics = require(path .. ".physics.physics")

function core.callbacks()
  love.update = function(dt)
    core.update(dt)
  end
  love.draw = function()
    core.draw()
  end
  love.keypressed = function(key, _, isRepeat)
    core.event.call("keyPressed", key, isRepeat)
  end
  love.keyreleased = function(key, _)
    core.event.call("keyReleased", key)
  end
  love.mousepressed = function(x, y, button, isTouch, presses)
    core.event.call("mousePressed", x, y, button, isTouch, presses)
  end
  love.mousereleased = function(x, y, button, isTouch, presses)
    core.event.call("mouseReleased", x, y, button, isTouch, presses)
  end
  love.mousemoved = function(x, y, dx, dy, isTouch)
    core.event.call("mouseMoved", x, y, dx, dy, isTouch)
  end
end

function core.getRuntime()
  return app.runtime
end

function core.update(dt)
  app:update(dt)
end

function core.draw()
  core.viewport.clear("main")
  core.viewport.drawTo("main", function()
    app:draw()
    physics.draw()
    love.graphics.setColor(1, 1, 1)
  end)
  core.viewport.draw("main")
end

return core
