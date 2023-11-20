local path = (...):gsub("%.tiled%.tiled_object_spawner$", "")
local Class = require(path .. ".class")

local TiledObjSpawner = Class()

function TiledObjSpawner:init(objList)
  self.constructors = {}
  self.objs = objList
end

function TiledObjSpawner:register(name, constructor)
  self.constructors[name] = constructor
end

function TiledObjSpawner:spawnLayer(layer)
  for _, obj in ipairs(layer.objs) do
    local constructor = self.constructors[obj.type]
    if constructor then
      local instance = constructor(obj)
      self.objs:add(instance)
    end
  end
end

function TiledObjSpawner:spawnMap(map)
  for _, layer in ipairs(map) do
    if layer.type == "objectgroup" then
      self:spawnLayer(layer)
    end
  end
end

return TiledObjSpawner
