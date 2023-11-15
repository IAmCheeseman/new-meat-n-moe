local path = (...):gsub("%.physics%.detector_box$", "")
local Class = require(path .. ".class")
local Box = require(path .. ".physics.box")
local physics = require(path .. ".physics.layer")

local DetectorBox = Class(Box)

function DetectorBox:init(data)
  self:base("init", data)

  for _, layer in ipairs(data.layers or {"default"}) do
    physics.addToLayer(self, layer, "detector")
  end
end

function DetectorBox:isColliding()
  for layer, _ in pairs(self.mask) do
    for _, other in ipairs(physics.getLayerObjects(layer, "resolver")) do
      if self.anchor ~= other.anchor and self:testCollision(other) then
        return true
      end
    end

    for _, other in ipairs(physics.getLayerObjects(layer, "detector")) do
      if self.anchor ~= other.anchor and other ~= self and self:testCollision(other) then
        return true
      end
    end
  end

  return false
end

function DetectorBox:getColliding()
  local collisions = {}

  for layer, _ in pairs(self.mask) do
    for _, other in ipairs(physics.getLayerObjects(layer, "resolver")) do
      if self.anchor ~= other.anchor and self:testCollision(other) then
        table.insert(collisions, other)
      end
    end

    for _, other in ipairs(physics.getLayerObjects(layer, "detector")) do
      if self.anchor ~= other.anchor and other ~= self and self:testCollision(other) then
        table.insert(collisions, other)
      end
    end
  end

  return collisions
end

return DetectorBox
