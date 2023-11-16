local path = (...):gsub("%.tiled%.tiled_image_layer$", "")
local Class = require(path .. ".class")
local TiledLayer = require(path .. ".tiled.tiled_layer")

local TiledImageLayer = Class(TiledLayer)

function TiledImageLayer:init(layer)
  self:base("init", layer)

  self.imagePath = "assets/" .. layer.image
  self.image = love.graphics.newImage(self.imagePath)
end

return TiledImageLayer
