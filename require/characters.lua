local camera = require("autoload.camera")

local activeCharacter = nil
local inactiveCharacter = nil

local characters = {}

function characters.getActive()
  if not activeCharacter then
    error("Must use `init()` once in order to use `getInactive()`")
  end
  return activeCharacter
end

function characters.getInactive()
  if not inactiveCharacter then
    error("Must use `init()` twice in order to use `getInactive()`")
  end
  return inactiveCharacter
end

function characters.swap()
  activeCharacter, inactiveCharacter = inactiveCharacter, activeCharacter
  camera.boundObj = activeCharacter
end

function characters.init(character)
  if not activeCharacter then
    activeCharacter = character
    camera.boundObj = character
  else
    inactiveCharacter = character
  end
end

return characters
