local path = (...):gsub("%.object%.sparse_set$", "")
local Class = require(path .. ".class")

local SparseSet = Class()

function SparseSet:init()
  self.sparse = {}
  self.dense = {}
end

function SparseSet:has(item)
  return self.sparse[item] ~= nil
end

function SparseSet:add(item)
  if self:has(item) then
    return false
  end

  table.insert(self.dense, item)
  self.sparse[item] = #self.dense

  return true
end

function SparseSet:remove(item)
  local index = self.sparse[item]
  self.dense[index] = self.dense[#self.dense]
  self.dense[#self.dense] = nil
  local newItem = self.dense[index]
  if newItem then
    self.sparse[newItem] = index
  end
end

function SparseSet:clear()
  self.dense = {}
  self.sparse = {}
end

function SparseSet:len()
  return #self.dense
end

function SparseSet:iter()
  return ipairs(self.dense)
end

return SparseSet
