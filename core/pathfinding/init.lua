local path = (...):gsub("%.pathfinding$", "")
local Grid = require(path .. ".pathfinding.jumper.grid")
local Finder = require(path .. ".pathfinding.jumper.pathfinder")

local pathfinding = {}

function pathfinding.getPath(sx, sy, tx, ty)
  return pathfinding.finder:getPath(sx, sy, tx, ty)
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
  local finder = Finder(grid, "ASTAR", walkable)

  core.pathfinding.finder = finder
end

return pathfinding
