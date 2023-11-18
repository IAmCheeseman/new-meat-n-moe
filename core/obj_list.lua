local path = (...):gsub("%.obj_list$", "")
local Class = require(path .. ".class")
local Array = require(path .. ".object.array")
local SparseSet = require(path .. ".object.sparse_set")

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
    if self.objectMetadata[v] then
      local index = self.objectMetadata[v].index
      self.objects:swapRemove(index)

      local newObj = self.objects[index]
      if newObj then
        self.objectMetadata[newObj].index = index
      end

      self.objectMetadata[v] = nil
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

  for i, obj in self.objects:iter() do
    self.objectMetadata[obj].index = i
    obj:draw()
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
