local path = (...):gsub("%.obj_list$", "")
local Class = require(path .. ".class")
local Array = require(path .. ".object.array")
local SparseSet = require(path .. ".object.sparse_set")

local ObjList = Class()

function ObjList:init()
  self.objects = Array()
  self.uniqueObjects = SparseSet()
  self.additionQueue = Array()
  self.removalQueue = Array()
end

function ObjList:flushQueues()
  for _, v in self.additionQueue:iter() do
    self.objects:add(v)
    self.uniqueObjects:add(v)
  end
  self.additionQueue:clear()

  for _, v in self.removalQueue:iter() do
    self.objects:add(v)
    self.uniqueObjects:remove(v)
  end
  self.removalQueue:clear()
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
    obj.zIndex = i
    obj:draw()
  end
end

function ObjList:gui()
  for _, obj in self.objects:iter() do
    obj:gui()
  end
end

function ObjList:add(obj)
  self.additionQueue:add(obj, 1)
end

function ObjList:remove(obj)
  self.removalQueue:add(obj, 1)
end

function ObjList:hasObj(obj)
  return self.uniqueObjects:has(obj)
end

return ObjList
