import math
import vector

type
    CircleCollider* = object
        r*: float
    RectCollider* = object
        size: Vector

proc collisionDistanceSq(pos0: Vector, col0: CircleCollider, pos1: Vector, col1: CircleCollider): float =
    let allowedSq: float = (col0.r + col1.r).pow 2
    let currentSq: float = pos0.distSq(pos1)
    allowedSq - currentSq

proc collisionDistance(pos0: Vector, col0: CircleCollider, pos1: Vector, col1: CircleCollider): float =
    let allowedSq: float = col0.r + col1.r
    let currentSq: float = pos0.dist(pos1)
    allowedSq - currentSq

proc isColliding*(pos0: Vector, col0: CircleCollider, pos1: Vector, col1: CircleCollider): bool =
    collisionDistanceSq(pos0, col0, pos1, col1) > 0

proc updatedPosition*(pos: Vector, col: CircleCollider, otherPos: Vector, otherCol: CircleCollider): Vector = 
    if not isColliding(pos, col, otherPos, otherCol): return pos
    pos - (otherPos - pos).normalized * collisionDistance(pos, col, otherPos, otherCol) * 1