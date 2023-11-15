local path = (...):gsub("%.event$", "")
local Array = require(path .. ".object.array")

local event = {}
local definitions = {}
local objs

local function nonexistentError(name)
  if not definitions[name] then
    error("Event '" .. name .. "' does not exist.")
  end
end

function event.define(name)
  local definition = {
    connections = Array(),
  }

  definitions[name] = definition
end

function event.init(objList)
  objs = objList
end

function event.connect(name, callback, bound)
  nonexistentError(name)

  local connection = {
    callback = callback,
    bound = bound
  }

  definitions[name].connections:add(connection)
end

function event.call(name, ...)
  nonexistentError(name)

  local removalQueue = Array()

  for i, c in definitions[name].connections:iter() do
    if objs:hasObj(c.bound) then
      c.callback(c.bound, ...)
    elseif not c.bound then
      c.callback(...)
    else
      removalQueue:add(i)
    end
  end

  for _, c in removalQueue:iter() do
    definitions[name].connections:remove(c)
  end
end

return event
