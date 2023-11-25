local path = (...):gsub("%.init$", "")

local core = {}

core.event          = require(path .. ".event")

core.event.define("keyPressed")
core.event.define("keyReleased")
core.event.define("mousePressed")
core.event.define("mouseReleased")
core.event.define("mouseMoved")
core.event.define("update")
core.event.define("draw")
core.event.define("gui")

local App = require(path .. ".app")
local app = App()

core.objs = app.objList

core.event.init(app.objList)

core.math           = require(path .. ".mathf")
core.assets         = require(path .. ".asset_loader")
core.viewport       = require(path .. ".viewport")
core.tiled          = require(path .. ".tiled")
core.pathfinding    = require(path .. ".pathfinding")
core.level          = require(path .. ".level_loader")

core.viewport.create("main", 320, 180, true)
core.viewport.create("gui", 320, 180, false)
core.viewport.setBackgroundColor("gui", 0, 0, 0, 0)

core.Class          = require(path .. ".class")
core.StateMachine   = require(path .. ".state_machine")
core.GameObj        = require(path .. ".game_obj")
core.Timer          = require(path .. ".timer")
core.SparseSet      = require(path .. ".object.sparse_set")
core.Array          = require(path .. ".object.array")
core.ResolverBox    = require(path .. ".physics.resolver_box")
core.DetectorBox    = require(path .. ".physics.detector_box")

local TiledObjSpawner = require(path .. ".tiled.tiled_object_spawner")

core.objSpawner = TiledObjSpawner(app.objList)

core.level.initialize(core.objs, core.objSpawner)

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
  core.event.call("update", dt)
end

function core.draw()
  core.viewport.clear("main")
  core.viewport.clear("gui")

  core.viewport.drawTo("main", function()
    app:draw()
    core.event.call("draw")
    physics.draw()
    love.graphics.setColor(1, 1, 1)
  end)

  core.viewport.drawTo("gui", function()
    app:gui()
    core.event.call("gui")
    love.graphics.setColor(1, 1, 1)
  end)

  core.viewport.draw("main")
  core.viewport.draw("gui")
end

return core
