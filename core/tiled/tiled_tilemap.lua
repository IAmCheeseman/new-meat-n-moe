local path = (...):gsub("%.tiled%.tiled_tilemap$", "")

local tiles = {}
local tileImages = {}

local tile = {}

function tile.initTilemap(assetDirectory, data)
  for y=0, data.imageheight/data.tileheight-1 do
    for x=0, data.imagewidth/data.tilewidth-1 do
      local quad = love.graphics.newQuad(
          x * data.tilewidth, y * data.tileheight,
          data.tilewidth, data.tileheight,
          data.imagewidth, data.imageheight)
      table.insert(tiles, quad)
    end
  end

  tileImages[#tiles] = love.graphics.newImage(assetDirectory .. data.image)
end

function tile.clearTiles()
  tiles = {}
end

function tile.getTile(id)
  local quad = tiles[id]
  local image
  for k, v in pairs(tileImages) do
    if id <= k then
      image = v
    end
  end

  if not image then
    error("Tile ID '" .. id .. "' is not defined.")
  end

  return image, quad
end

return tile
