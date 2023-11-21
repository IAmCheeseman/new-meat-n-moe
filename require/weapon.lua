local Weapon = core.Class(core.GameObj)

function Weapon:init(boundObj)
  self.zIndex = 0

  self.x = boundObj.x
  self.y = boundObj.y
  self.targetOffsetX = 0
  self.targetOffsetY = 0

  self.boundObj = boundObj
  self.trackSpeed = 48
end

function Weapon:update(dt)
  self.x = core.math.lerp(self.x, self.boundObj.x + self.targetoffsetx, self.trackSpeed * dt)
  self.y = core.math.lerp(self.y, self.boundObj.y + self.targetoffsety, self.trackSpeed * dt)
end

function Weapon:attack()

end

return Weapon
