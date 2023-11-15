local path = (...):gsub("%.physics%.box$", "")
local Class = require(path .. ".class")

local Box = Class()

function Box:init(data)
  local anchor = data.anchor or error("Property 'anchor' is required.")

  assert(anchor.x, "Anchor must have an 'x' property.")
  assert(anchor.y, "Anchor must have a 'y' property.")

  self.anchor = anchor
  self.x = data.x or 0
  self.y = data.y or 0
  self.w = data.w or 16
  self.h = data.h or 16
  self.layers = {}
  self.mask = {}

  self.test = data.test
  for _, mask in ipairs(data.mask or {"default"}) do
    self:addMask(mask)
  end
end

function Box:addMask(mask)
  self.mask[mask] = true
end

function Box:removeMask(mask)
  self.mask[mask] = nil
end

function Box:hasMask(mask)
  return self.mask[mask] or false
end

function Box:isInLayer(layer)
  return self.layers[layer]
end

function Box:testCollisionX(x1, w1, x2, w2)
  return x1 < x2 + w2
  and    x2 < x1 + w1
end

function Box:testCollisionY(y1, h1, y2, h2)
  return y1 < y2 + h2
  and    y2 < y1 + h1
end

function Box:testCollision(other)
  return self:testCollisionX(self.x + self.anchor.x, self.w, other.x + other.anchor.x, other.w)
  and    self:testCollisionY(self.y + self.anchor.y, self.h, other.y + other.anchor.y, other.h)
end

return Box
