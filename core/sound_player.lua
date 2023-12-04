local path = (...):gsub("%.sound_player$", "")
local Class = require(path .. ".class")

local SoundPlayer = Class()

function SoundPlayer:init(data, poolSize)
  poolSize = poolSize or 2

  self.pool = {}
  self.current = 1
  self.pitch = 1

  for _=1, poolSize do
    table.insert(self.pool, love.audio.newSource(data))
  end
end

function SoundPlayer:setPitch(pitch)
  self.pitch = pitch
end

function SoundPlayer:play()
  local source = self.pool[self.current]
  source:setPitch(self.pitch)

  source:stop()
  source:play()
end

return SoundPlayer
