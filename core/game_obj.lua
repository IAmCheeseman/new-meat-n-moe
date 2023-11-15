local path = (...):gsub("%.game_obj$", "")
local Class = require(path .. ".class")

local GameObj = Class()

function GameObj:init()
  self.zIndex = 0
end

function GameObj:update(dt)
end

function GameObj:draw()
end

return GameObj
