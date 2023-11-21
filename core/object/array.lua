local path = (...):gsub("%.object%.array$", "")
local Class = require(path .. ".class")

local Array = Class()

function Array:init(defaults)
  defaults = defaults or {}
  self.items = defaults
end

function Array:add(item, index)
  index = index or #self.items + 1
  table.insert(self.items, index, item)
end

function Array:remove(index)
  table.remove(self.items, index)
end

function Array:swapRemove(index)
  self.items[index] = self.items[#self.items]
  self.items[#self.items] = nil
end

function Array:pop()
  return table.remove(self.items)
end

function Array:popFront()
  return table.remove(self.items[1])
end

function Array:sort(fn)
  table.sort(self.items, fn)
end

function Array:clear()
  self.items = {}
end

function Array:iter()
  return ipairs(self.items)
end

function Array:len()
  return #self.items
end

return Array
