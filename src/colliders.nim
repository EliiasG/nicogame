import math
import vector

type
    CircleCollider* = object
        r*: float
    RectCollider* = object
        w*: float
        h*: float

proc newCircleCollider*(r: float): CircleCollider =
    result.r = r

proc newRectCollider*(w, h: float): RectCollider =
    result.w = w
    result.h = h

proc newRectCollider*(size: float): RectCollider =
    newRectCollider(size, size)

proc isWithin(x, lo, hi: float): bool =
    x >= lo and x <= hi

proc isPointInRect*(point, rectPos: Vector, rect: RectCollider): bool =
    point.x.isWithin(rectPos.x, rectPos.x + rect.w) and point.y.isWithin(rectPos.y, rectPos.y + rect.h)

proc collisionDistanceSq(pos0: Vector, col0: CircleCollider, pos1: Vector, col1: CircleCollider): float =
    let allowedSq: float = (col0.r + col1.r).pow 2
    let currentSq: float = pos0.distSq(pos1)
    allowedSq - currentSq

proc isColliding*(pos0: Vector, col0: CircleCollider, pos1: Vector, col1: CircleCollider): bool =
    collisionDistanceSq(pos0, col0, pos1, col1) > 0

proc updatedPosition*(pos: Vector, col: CircleCollider, otherPos: Vector, otherCol: CircleCollider): Vector = 
    if not isColliding(pos, col, otherPos, otherCol): return pos
    otherPos - (otherPos - pos).normalized * (col.r + otherCol.r)

proc getCorners*(pos: Vector, col: RectCollider): array[4, Vector] =
    result[0] = pos
    result[1] = pos + newVector(col.w, 0)
    result[2] = pos + newVector(col.w, col.h)
    result[3] = pos + newVector(0, col.h)

proc isColliding*(pos0: Vector, col0: RectCollider, pos1: Vector, col1: RectCollider): bool =
    return pos0.x.isWithin(pos1.x - col0.w, pos1.x + col1.w) and pos0.y.isWithin(pos1.y - col0.h, pos1.y + col1.h)

proc isCollidingHorizontal(pos0: Vector, col0: CircleCollider, pos1: Vector, col1: RectCollider): bool =
    return pos0.x.isWithin(pos1.x - col0.r, pos1.x + col1.w + col0.r) and pos0.y.isWithin(pos1.y, pos1.y + col1.h)

proc isCollidingVertical(pos0: Vector, col0: CircleCollider, pos1: Vector, col1: RectCollider): bool =
    return pos0.y.isWithin(pos1.y - col0.r, pos1.y + col1.h + col0.r) and pos0.x.isWithin(pos1.x, pos1.x + col1.w)

proc isColliding*(pos0: Vector, col0: CircleCollider, pos1: Vector, col1: RectCollider): bool =
    #this is a optimisation, if a square with a size equal to the diameter of the circle is not colliding, then the circle would also not be colliding
    if not isColliding(pos0 - col0.r, newRectCollider(col0.r*2), pos1, col1): return false
    #check if the circle is colliding with the sides of the rect
    if isCollidingHorizontal(pos0, col0, pos1, col1): return true
    if isCollidingVertical(pos0, col0, pos1, col1): return true
    #check if the circle is colliding with the corners of the rect
    for v in getCorners(pos1, col1):
        if isColliding(pos0, col0, v, newCircleCollider(0)): return true
    false

proc closest(v, x, y: float): float =
    if v > (x+y) / 2: return max(x, y)
    min(x, y)

proc updatedPosition*(pos: Vector, col: CircleCollider, otherPos: Vector, otherCol: RectCollider): Vector =
    #if its not colliding, don't bother with the rest of the checks
    if not isColliding(pos, col, otherPos, otherCol): return pos

    #push it back to the edge if its colliding with the left/right lide
    if isCollidingHorizontal(pos, col, otherPos, otherCol):
        return newVector(closest(pos.x, otherPos.x - col.r, otherPos.x + otherCol.w + col.r), pos.y)

    #push it back to the edge if its colliding with the top/bottom lide
    if isCollidingVertical(pos, col, otherPos, otherCol):
        return newVector(pos.x, closest(pos.y, otherPos.y - col.r, otherPos.y + otherCol.h + col.r))

    #use the circle collision, treating the corners as infinitley small circles
    var pos = pos
    for v in getCorners(otherPos, otherCol):
        pos = updatedPosition(pos, col, v, newCircleCollider(0))
    return pos