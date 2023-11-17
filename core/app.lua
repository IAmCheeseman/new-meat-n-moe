local path = (...):gsub("%.app$", "")
local Class = require(path .. ".class")
local ObjList = require(path .. ".obj_list")

local App = Class()

function App:init()
  self.runtime = 0
  self.objList = ObjList()
end

function App:update(dt)
  self.runtime = self.runtime + dt

  self.objList:update(dt)
end

function App:draw()
  self.objList:draw()
end

function App:gui()
  self.objList:gui()
end

return App
