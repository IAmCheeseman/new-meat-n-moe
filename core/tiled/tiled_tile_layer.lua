local path = (...):gsub("%.tiled%.tiled_tile_layer$", "")
local Class = require(path .. ".class")
local TiledLayer = require(path .. ".tiled.tiled_layer")
local tile = require(path .. ".tiled.tiled_tilemap")

local TiledTileLayer = Class(TiledLayer)

function TiledTileLayer:init(layer)
  self:base("init", layer)

  self.width = layer.width
  self.height = layer.height
  self.tiles = layer.data

  self.spriteBatches = {}
  self:initSpriteBatches()
end

function TiledTileLayer:initSpriteBatches()
  self.spriteBatches = {}
  local x, y = 0, 0
  for _, id in ipairs(self.tiles) do
    if id ~= 0 then
      local image, quad = tile.getTile(id)
      if not self.spriteBatches[image] then
        local batch = love.graphics.newSpriteBatch(image, 1)
        self.spriteBatches[image] = batch
      end
      self.spriteBatches[image]:add(quad, x * 16, y * 16)
    end

    x = x + 1
    if x == self.width then
      y = y + 1
      x = 0
    end
  end
end

function TiledTileLayer:draw()
  for _, batch in pairs(self.spriteBatches) do
    love.graphics.draw(batch, 0, 0)
  end
end

return TiledTileLayer