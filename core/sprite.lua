local path = (...):gsub("%.sprite$", "")
local Class = require(path .. ".class")
local event = require(path .. ".event")

local Sprite = Class()

function Sprite:init(spritePath)
  self.image = love.graphics.newImage(spritePath)

  self.width, self.height = self.image:getDimensions()
  self.realWidth, self.realHeight = self.width, self.height
  self.frame = 1
  self.time = 0
  self.path = spritePath
  self.modulate = {1, 1, 1}

  -- event.connect("update", self.update, self)
end

function Sprite:initAnimation(hframes, vframes, animations)
  local frames = {}
  local tags = {}
  local animation

  local w, h = self.image:getWidth() / hframes, self.image:getHeight() / vframes

  local i = 1
  for y=0, vframes-1 do
    for x=0, hframes-1 do
      local quad = love.graphics.newQuad(
          x * w, y * h,
          w, h,
          self.image:getDimensions())

      frames[i] = {
        quad = quad,
        duration = animations[i] or 0.1,
      }

      i = i + 1
    end
  end

  for k, v in pairs(animations) do
    if not animation then
      animation = k
    end
    tags[k] = v
  end

  self.frames = frames
  self.tags = tags
  self.animation = animation
  self.inputAnimation = animations
  self.vframes = vframes
  self.hframes = hframes
  self.realWidth = self.width
  self.realHeight = self.height
  self.width = self.width / hframes
  self.height = self.height / vframes
  if self.tags[animation] then
    self:play(animation)
  end
end

function Sprite:clone()
  local cloned = Sprite(self.path)
  cloned.offsetx = self.offsetx
  cloned.offsety = self.offsety

  if self.inputAnimation then
    cloned:initAnimation(self.hframes, self.vframes, self.inputAnimation)
  end

  return cloned
end

function Sprite:play(name)
  assert(self.tags[name], "Animation '" .. name .. "' does not exist.")

  if self.animation == name then
    return
  end

  self.animation = name
  self.frame = self.tags[name].from
end

function Sprite:update()
  local dt = love.timer.getDelta()

  local tag = self.tags[self.animation]

  if not tag then
    self.frame = 1
    return
  end

  self.time = self.time + dt

  if self.time >= self.frames[self.frame].duration then
    self.frame = self.frame + 1
    self.time = 0
    if self.frame > tag.to then
      self.frame = tag.from
    end
  end
end

function Sprite:draw(x, y, r, sx, sy)
  r = r or 0
  sx = sx or 1
  sy = sy or sx

  local quad
  if self.frames then
    quad = self.frames[self.frame].quad
  else
    quad = love.graphics.newQuad(0, 0, self.width, self.height, self.width, self.height)
  end

  love.graphics.setColor(unpack(self.modulate))
  love.graphics.draw(self.image, quad, x, y, r, sx, sy, self.offsetx, self.offsety)
  love.graphics.setColor(1, 1, 1)
end

function Sprite:setOffsetPreset(horizontal, vertical)
  horizontal = horizontal or "left"
  vertical = vertical or "top"

  if horizontal == "left" then
    self.offsetx = 0
  elseif horizontal == "center" then
    self.offsetx = math.floor(self.width / 2 + 0.5)
  elseif horizontal == "right" then
    self.offsetx = self.width
  end

  if vertical == "top" then
    self.offsety = 0
  elseif vertical == "center" then
    self.offsety = math.floor(self.height / 2 + 0.5)
  elseif vertical == "bottom" then
    self.offsety = self.height
  end
end

return Sprite
