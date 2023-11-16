local path = (...):gsub("%.tiled$", "")
local tile = require(path .. ".tiled.tiled_tilemap")
local TiledTileLayer = require(path .. ".tiled.tiled_tile_layer")
local TiledImageLayer = require(path .. ".tiled.tiled_image_layer")
local TiledObjectLayer = require(path .. ".tiled.tiled_object_layer")

local tiled = {}

function tiled.openLevel(assetDirectory, level)
  local data = require(level)

  tile.clearTiles()
  for _, tsData in ipairs(data.tilesets) do
    if tsData.image then
      tile.initTilemap(assetDirectory, tsData)
    end
  end

  local layers = {}
  for _, layer in ipairs(data.layers) do
    if layer.type == "tilelayer" then
      local tileLayer = TiledTileLayer(layer)
      table.insert(layers, tileLayer)
    elseif layer.type == "objectgroup" then
      local objectLayer = TiledObjectLayer(layer)
      table.insert(layers, objectLayer)
    elseif layer.type == "imagelayer" then
      local imageLayer = TiledImageLayer(layer)
      table.insert(layers, imageLayer)
    end
  end

  return layers
end

return tiled
