local path = (...):gsub("%.physics%.resolver_box$", "")
local Class = require(path .. ".class")
local Box = require(path .. ".physics.box")
local physics = require(path .. ".physics.physics")

local ResolverBox = Class(Box)

function ResolverBox:init(data)
  self:base("init", data)

  for _, layer in ipairs(data.layers or {"default"}) do
    physics.addToLayer(self, layer, "resolver")
  end
end

function ResolverBox:moveAndCollide(velx, vely, dt)
  local anchor = self.anchor
  local x, y = anchor.x + self.x, anchor.y + self.y

  for layer, _ in pairs(self.mask) do
    for _, other in ipairs(physics.getLayerObjects(layer, "resolver")) do
      if other ~= self then
        local oAnchor = other.anchor
        local ox, oy = oAnchor.x + other.x, oAnchor.y + other.y

        local collidingx = self:testCollisionX(x + velx * dt, self.w, ox, other.w)
        local collidingy = self:testCollisionY(y + vely * dt, self.h, oy, other.h)

        if collidingx and collidingy then
          local currCollidingX = self:testCollisionX(x, self.w, ox, other.w)
          local currCollidingY = self:testCollisionY(y, self.h, oy, other.h)

          if currCollidingX and vely ~= 0 then
            if vely > 0 then
              anchor.y = oy - (self.h + self.y)
            else
              anchor.y = oy + (other.h - self.y)
            end
            vely = 0
          elseif currCollidingY and velx ~= 0 then
            if velx > 0 then
              anchor.x = ox - (self.w + self.x)
            else
              anchor.x = ox + (other.w - self.x)
            end
            velx = 0
          end
        end
      end
    end
  end

  anchor.x = anchor.x + velx * dt
  anchor.y = anchor.y + vely * dt
  return velx, vely
end

return ResolverBox
