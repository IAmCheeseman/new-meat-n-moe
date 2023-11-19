local path = (...):gsub("%.physics%.physics", "")
local event = require(path .. ".event")

local debug = false

local physics = {}
local objects = {}
local layers = {}

function physics.getLayerObjects(layer, type)
  if not layers[layer] then
    physics.createLayer(layer)
  end

  assert(layers[layer][type], "Invalid layer type '" .. type .. "'")
  return layers[layer][type]
end

function physics.createLayer(name)
  if layers[name] then
    return
  end

  local newLayer = {
    resolver = {},
    detector = {},
  }
  layers[name] = newLayer
end

function physics.registerBox(box)
  local anchor = box.anchor
  if not objects[anchor] then
    objects[anchor] = {}
  end

  table.insert(objects[anchor], box)
end

function physics.deleteObj(obj)
  if not objects[obj] then
    return
  end

  for _, box in ipairs(objects[obj]) do
    for layerName, index in pairs(box.layers) do
      local layer = layers[layerName][box.type]
      layer[index] = layer[#layer]
      layer[#layer] = nil

      if layer[index] then
        layer[index].layers[layerName] = index
      end
    end
  end

  objects[obj] = {}
end

function physics.addToLayer(box, layer, type)
  local layerTable = physics.getLayerObjects(layer, type)
  table.insert(layerTable, box)
  box.layers[layer] = #layerTable
end

local function drawBoxes(boxes)
  for _, box in ipairs(boxes) do
    love.graphics.rectangle(
        "fill",
        box.anchor.x + box.x, box.anchor.y + box.y,
        box.w, box.h)
  end
end

function physics.draw()
  if not debug then
    return
  end

  for _, layer in pairs(layers) do
    love.graphics.setColor(1, 0, 0, 0.5)
    drawBoxes(layer.resolver)
    love.graphics.setColor(0, 0, 1, 0.5)
    drawBoxes(layer.detector)
  end
end

event.connect("keyPressed", function(key, isRepeat)
  if not isRepeat and key == "f4" then
    debug = not debug
  end
end)

physics.createLayer("default")

return physics
