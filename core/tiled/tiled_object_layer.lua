local path = (...):gsub("%.tiled%.tiled_object_layer$", "")
local Class = require(path .. ".class")
local TiledLayer = require(path .. ".tiled.tiled_layer")
local TiledObj = require(path .. ".tiled.tiled_object")

local TiledObjLayer = Class(TiledLayer)

function TiledObjLayer:init(layer)
  self:base("init", layer)

  self.objs = {}
  for _, obj in ipairs(layer.objects) do
    table.insert(self.objs, TiledObj(obj))
  end
end

function TiledObjLayer:iter()
  return ipairs(self.objs)
end

return TiledObjLayer
