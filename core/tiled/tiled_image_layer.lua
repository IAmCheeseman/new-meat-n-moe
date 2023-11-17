local path = (...):gsub("%.tiled%.tiled_image_layer$", "")
local Class = require(path .. ".class")
local TiledLayer = require(path .. ".tiled.tiled_layer")
local viewport = require(path .. ".viewport")
local mathf = require(path .. ".mathf")

local TiledImageLayer = Class(TiledLayer)

function TiledImageLayer:init(layer)
  self:base("init", layer)

  self.imagePath = "assets/" .. layer.image
  self.image = love.graphics.newImage(self.imagePath)
  self.image:setWrap("repeat")

  self.repx = layer.repeatx
  self.repy = layer.repeaty
end

function TiledImageLayer:draw()
  local x, y = viewport.getCameraPos(viewport.current())
  local w, h = viewport.getSize(viewport.current())
  local iw, ih = self.image:getDimensions()
  w = mathf.snapped(w, iw)
  h = mathf.snapped(h, ih)

  x = mathf.snapped(x, w) - w
  y = mathf.snapped(y, h) - h
  w = w * 3
  h = h * 3

  if not self.repx then
    x = 0
    w = iw
  end
  if not self.repy then
    y = 0
    h = ih
  end

  local quad = love.graphics.newQuad(0, 0, w, h, iw, ih)
  love.graphics.draw(self.image, quad, x, y)
end

return TiledImageLayer
