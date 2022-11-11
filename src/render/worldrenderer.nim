import nico
import ../world
#TODO update
proc renderWorld*(world: World, size: int) =
    for i in 0 ..< world.size:
        for j in 0 ..< world.size:
            if world[i][j] == Tile.wall:
                boxfill(x = i * size, y = j * size, w = size, h = size)