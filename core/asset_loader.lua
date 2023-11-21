local path = (...):gsub(".asset_loader$", "")
local json = require(path .. ".third.json")
local Sprite = require(path .. ".sprite")

local assetLoader = {}

local function openJson(filePath)
  local contents = love.filesystem.read(filePath)
  return json.decode(contents)
end

local loaders = {
  png = Sprite,
  jpg = Sprite,

  fs = love.graphics.newShader,
  vs = love.graphics.newShader,
  glsl = love.graphics.newShader,

  mp3 = love.sound.newSoundData,
  ogg = love.sound.newSoundData,
  wav = love.sound.newSoundData,

  ttf = love.filesystem.newFileData,

  txt = love.filesystem.read,
  json = openJson,
}

local function loadAsset(filePath)
  for extension, v in pairs(loaders) do
    local fullPath = filePath .. "." .. extension
    local info = love.filesystem.getInfo(fullPath)
    if info then
      return v(fullPath)
    end
  end

  local info = love.filesystem.getInfo(filePath)
  if info then
    if info.type == "directory" then
      return assetLoader.load(filePath)
    end
  end

  return nil
end

local assetDirMt = {
  __index = function(t, k)
    if not rawget(t, k) then
      local asset = loadAsset(rawget(t, 1) .. "/" .. k)
      rawset(t, k, asset)
      return asset
    end
    return rawget(t, k)
  end,
  __newindex = function(_, _, _)
    error("Asset table is readonly!")
  end
}

function assetLoader.load(dirPath)
  dirPath = dirPath or ""
  local files = love.filesystem.getDirectoryItems(dirPath)

  local directory = {}

  for _, fileName in ipairs(files) do
    local filePath = dirPath .. "/" .. fileName
    local info = love.filesystem.getInfo(filePath)
    if info then
      if info.type == "directory" then
        directory[fileName] = assetLoader.load(filePath)
      end
    end
  end

  rawset(directory, 1, dirPath)
  return setmetatable(directory, assetDirMt)
end

function assetLoader.loadScripts(dirPath)
  local files = love.filesystem.getDirectoryItems(dirPath)

  for _, fileName in ipairs(files) do
    local filePath = dirPath .. "/" .. fileName
    local info = love.filesystem.getInfo(filePath)
    if info then
      if info.type == "file" then
        if fileName:gmatch(".lua$") then
          require(filePath:gsub(".lua$", ""))
        end
      end
    end
  end
end

function assetLoader.noise(w, h, scale, layers, layerDetail)
  scale = scale or 0.5
  layers = layers or 0
  layerDetail = layerDetail or 0.5
  local image = love.graphics.newCanvas(w, h)

  love.graphics.setCanvas(image)
  for x=0, w-1 do
    for y=0, h-1 do
      local n = love.math.noise(x * scale, y * scale)
      for i=1, layers do
        local detail = scale + layerDetail * i
        n = n + love.math.noise(x * detail, y * detail)
      end
      n = n / (layers + 1)
      love.graphics.setColor(n, n, n)
      love.graphics.points(x, y)
    end
  end
  love.graphics.setCanvas()

  return image
end

return assetLoader
