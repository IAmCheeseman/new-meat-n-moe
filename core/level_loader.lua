local path = (...):gsub("%.level_loader$", "")
local pathfinding = require(path .. ".pathfinding")
local tiled = require(path .. ".tiled")
local event = require(path .. ".event")

local levelLoader = {}

local objList

event.define("levelChanged")

levelLoader.assetsDirectory = "assets/"
levelLoader.pathfindingLayer = "Tiles"
levelLoader.collisionLayers = {"Tiles"}

function levelLoader.initialize(objs, spawner)
  objList = objs
  objSpawner = spawner
end

function levelLoader.load(levelPath)
  local map = tiled.openLevel(levelLoader.assetsDirectory, levelPath)

  objSpawner:spawnMap(map.layers)

  for _, layer in ipairs(map.layers) do
    if layer.type == "tilelayer" then
      if layer.name == levelLoader.pathfindingLayer then
        pathfinding.initWithTileLayer(layer)
      end

      for _, name in ipairs(levelLoader.collisionLayers) do
        if layer.name == name then
          tiled.generateTileLayerCollision(layer)
          break
        end
      end

      objList:add(layer)
    elseif layer.type == "imagelayer" then
      objList:add(layer)
    end
  end

  event.call("levelChanged", map)
end

return levelLoader
