local path = (...):gsub("%.tiled%.tiled_object$", "")
local Class = require(path .. ".class")

local TiledObj = Class()

function TiledObj:init(obj)
  self.name = obj.name
  self.type = obj.type
  self.x = obj.x
  self.y = obj.y
  self.width = obj.width
  self.height = obj.height
  self.rot = obj.rotation
  self.visible = obj.visible
  self.custom = obj.properties
end

return TiledObj
