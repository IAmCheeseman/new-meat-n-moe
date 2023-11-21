local path = (...):gsub("%.obj_list$", "")
local Class = require(path .. ".class")
local Array = require(path .. ".object.array")
local physics = require(path .. ".physics.physics")

local ObjList = Class()

function ObjList:init()
  self.objects = Array()
  self.objectMetadata = {}
  self.additionQueue = {}
  self.removalQueue = {}
end

function ObjList:flushQueues()
  for _, v in ipairs(self.additionQueue) do
    self.objects:add(v)
    self.objectMetadata[v] = {
      index = self.objects:len()
    }
  end
  self.additionQueue = {}

  for _, v in ipairs(self.removalQueue) do
    if self.objectMetadata[v] then -- Is this object already freed?
      local index = self.objectMetadata[v].index
      self.objectMetadata[v] = nil
      self.objects:swapRemove(index)
      physics.deleteObj(v)

      local newObj = self.objects[index]
      if newObj then
        self.objectMetadata[newObj].index = index
      end
    end
  end
  self.removalQueue = {}
end

function ObjList:update(dt)
  self:flushQueues()

  for _, obj in self.objects:iter() do
    obj:update(dt)
  end
end

function ObjList:draw()
  self.objects:sort(function(a, b)
    return a.zIndex < b.zIndex
  end)

  print(self.objects:len())

  for i, obj in self.objects:iter() do
    if self.objectMetadata[obj] then
      self.objectMetadata[obj].index = i
      obj:draw()
    end
  end
end

function ObjList:gui()
  for _, obj in self.objects:iter() do
    obj:gui()
  end
end

function ObjList:add(obj)
  table.insert(self.additionQueue, 1, obj)
end

function ObjList:remove(obj)
  table.insert(self.removalQueue, 1, obj)
end

function ObjList:hasObj(obj)
  return self.objectMetadata[obj] ~= nil
end

return ObjList
