local path = (...):gsub("%.tiled$", "")
local tile = require(path .. ".tiled.tiled_tilemap")
local TiledTileLayer = require(path .. ".tiled.tiled_tile_layer")
local TiledImageLayer = require(path .. ".tiled.tiled_image_layer")
local TiledObjectLayer = require(path .. ".tiled.tiled_object_layer")
local ResolverBox = require(path .. ".physics.resolver_box")

local tiled = {}

local collisionLayers = {}

function tiled.setTilemapCollisionLayers(name, ...)
  collisionLayers[name] = {...}
end

function tiled.generateTileLayerCollision(layer)
  local x, y = 0, 0
  local edgeIds = {}

  for i, id in ipairs(layer.tiles) do
    if id ~= 0 then
      local ts = tile.getTileset(id)
      if not edgeIds[ts.name] then
        edgeIds[ts.name] = {}
      end

      if edgeIds[ts.name][id] == nil then
        edgeIds[ts.name][id] =
               layer.tiles[i - layer.width] == 0
            or layer.tiles[i + layer.width] == 0
            or (layer.tiles[i - 1] == 0 and i % layer.width ~= 0)
            or (layer.tiles[i + 1] == 0 and i / layer.width ~= 1)
      end

      if edgeIds[ts.name][id] then
        ResolverBox {
          anchor = layer,
          x = x * ts.width,
          y = y * ts.height,
          w = ts.width,
          h = ts.height,
          layers = ts.layers
        }
      end
    end

    x = x + 1
    if x == layer.width then
      y = y + 1
      x = 0
    end
  end
end

function tiled.openLevel(assetDirectory, level)
  local data = require(level)

  tile.clearTiles()
  for _, tsData in ipairs(data.tilesets) do
    if tsData.image then
      tile.initTilemap(assetDirectory, tsData, collisionLayers[tsData.name])
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

  local map = {}
  map.width = data.width
  map.height = data.height
  map.tileWidth = data.tilewidth
  map.tileHeight = data.tileheight
  map.pixelWidth = data.width * data.tilewidth
  map.pixelHeight = data.height * data.tileheight
  map.layers = layers

  return map
end

return tiled
