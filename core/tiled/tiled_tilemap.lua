local path = (...):gsub("%.tiled%.tiled_tilemap$", "")

local tiles = {}
local tilesets = {}

local tile = {}

function tile.initTilemap(assetDirectory, data, collisionLayers)
  for y=0, data.imageheight/data.tileheight-1 do
    for x=0, data.imagewidth/data.tilewidth-1 do
      local quad = love.graphics.newQuad(
          x * data.tilewidth, y * data.tileheight,
          data.tilewidth, data.tileheight,
          data.imagewidth, data.imageheight)
      table.insert(tiles, quad)
    end
  end

  tilesets[#tiles] = {
    image = love.graphics.newImage(assetDirectory .. data.image),
    name = data.name,
    width = data.tilewidth,
    height = data.tileheight,
    layers = collisionLayers or {"default"},
  }
end

local function findTileset(id)
  local tileset
  for k, v in pairs(tilesets) do
    if id <= k then
      tileset = v
    end
  end

  if not tileset then
    error("Tile ID '" .. id .. "' is not defined.")
  end

  return tileset
end

function tile.getTileset(id)
  return findTileset(id)
end

function tile.getSize(id)
  local tileset = findTileset(id)
  return tileset.width, tileset.height
end

function tile.clearTiles()
  tiles = {}
end

function tile.getTile(id)
  local quad = tiles[id]
  local image = findTileset(id).image
  return image, quad
end

return tile
