local function instanceObject(class, ...)
  local instance = setmetatable({}, class)
  if type(instance.init) == "function" then
    instance:init(...)
  end
  return instance
end

local function base(self, func, ...)
  local mt = getmetatable(self)
  local childMt = mt
  if not childMt.__inherits then
    error("Cannot use 'base' on a base class.")
  end

  for _=1, childMt.__baseCalls do
    mt = mt.__inherits
  end

  childMt.__baseCalls = childMt.__baseCalls + 1
  local res = mt.__inherits[func](self, ...)
  childMt.__baseCalls = childMt.__baseCalls - 1
  return res
end

local function checkType(mt, class)
  if mt == class then
    return true
  end

  if mt.__inherits then
    return checkType(mt.__inherits, class)
  else
    return false
  end
end

local function isTypeOf(self, class)
  return checkType(getmetatable(self), class)
end

local classMt = {
  __call = instanceObject,
}

local function Class(inherits)
  local class = {}
  class.__index = class
  class.__baseCalls = 0

  class.base = base
  class.isTypeOf = isTypeOf

  if inherits then
    class.__inherits = inherits
    setmetatable(class, {
      __index = inherits,
      __call = instanceObject,
    })
  else
    setmetatable(class, classMt)
  end

  return class
end

return Class
