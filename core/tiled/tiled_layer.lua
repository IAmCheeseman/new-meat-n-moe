local path = (...):gsub("%.tiled%.tiled_layer$", "")
local Class = require(path .. ".class")
local GameObj = require(path .. ".game_obj")

local TiledLayer = Class(GameObj)

function TiledLayer:init(layer)
  -- self:base("init")

  self.type = layer.type

  self.name = layer.name
  self.x = layer.x
  self.y = layer.y
  self.visible = layer.visible
  self.opacity = layer.opacity
  self.offsetX = layer.offsetx
  self.offsetY = layer.offsety
  self.parallaxX = layer.parallaxx
  self.parallaxY = layer.parallaxy
  self.custom = layer.properties
  self.zIndex = layer.properties.zIndex or 0
  layer.properties.zIndex = nil
end

return TiledLayer
