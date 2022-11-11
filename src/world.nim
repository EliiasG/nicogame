type
  BaseEntity* = ref object of RootObj #circular import fix hack
  Tile* = enum
    floor, wall
  WorldCol* = ref object 
    tiles: seq[Tile]
  World* = ref object
    size: uint
    tiles: seq[WorldCol]
    entities: seq[BaseEntity]

proc fillWorld(world: World) =
  for i in 0 ..< world.size:
    var newCol: WorldCol
    new(newCol)
    for i in 0 ..< world.size:
      newCol.tiles.add(Tile.floor)
    world.tiles.add(newCol)

proc newWorld*(size: uint): World =
  new(result)
  result.size = size
  result.tiles = newSeqOfCap[WorldCol](size)
  fillWorld(result)

proc size*(world: World): int =
  world.size.int

proc `[]`*(world: World, i: int): WorldCol =
  world.tiles[i]

proc `[]`*(worldCol: WorldCol, i: int): Tile =
  worldCol.tiles[i]

proc `[]=`*(worldCol: WorldCol, i: int, value: Tile) =
  worldCol.tiles[i] = value