local path = (...):gsub("%.pathfinding$", "")
local Grid = require(path .. ".pathfinding.jumper.grid")
local Finder = require(path .. ".pathfinding.jumper.pathfinder")

local pathfinding = {}

pathfinding.width = 16
pathfinding.height = 16

function pathfinding.getPath(sx, sy, tx, ty)
  local nsx, nsy = pathfinding.worldToNode(sx, sy)
  local ntx, nty = pathfinding.worldToNode(tx, ty)
  return pathfinding.finder:getPath(nsx, nsy, ntx, nty)
end

function pathfinding.nodeToWorld(node)
  local x, y = node:getPos()
  x = x * pathfinding.width - (pathfinding.width * 0.5)
  y = y * pathfinding.height + (pathfinding.height * 0.5)

  return x, y
end

function pathfinding.worldToNode(x, y)
  local nx = math.floor(x / pathfinding.width + 0.5)
  local ny = math.floor(y / pathfinding.height + 0.5)
  if not pathfinding.grid:isWalkableAt(nx, ny, 0) then
    nx = math.ceil(x / pathfinding.width)
    ny = math.ceil(y / pathfinding.height)
  end
  if not pathfinding.grid:isWalkableAt(nx, ny, 0) then
    nx = math.floor(x / pathfinding.width)
    ny = math.floor(y / pathfinding.height)
  end

  return nx, ny
end

function pathfinding.initWithTileLayer(layer, walkable)
  walkable = walkable or 0
  local map = {}
  for y=1, layer.height - 1 do
    table.insert(map, {})
    for x=1, layer.width - 1 do
      local index = (y * layer.height) + layer.width - x
      table.insert(map[y], 1, layer.tiles[index])
    end
  end

  local grid = Grid(map)
  local finder = Finder(grid, "JPS", walkable)
      :setMode("ORTHOGONAL")

  core.pathfinding.grid = grid
  core.pathfinding.finder = finder
end

return pathfinding
