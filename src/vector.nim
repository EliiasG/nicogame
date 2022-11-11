import math
type
    Vector* = object
        x*: float
        y*: float

proc newVector*(x, y: float): Vector =
    result.x = x
    result.y = y

proc `$`*(vec: Vector): string =
    result = $vec.x & ", " & $vec.y

proc `+`*(vec0, vec1: Vector): Vector =
    newVector(vec0.x + vec1.x, vec0.y + vec1.y)

proc `+=`*(vec0: var Vector, vec1: Vector) =
    vec0 = vec0 + vec1

proc angle*(vec: Vector): float =
    arctan2(vec.y, vec.x)

proc normalized(vec: Vector): Vector =
    let ang: float = vec.angle
    newVector(cos(ang), sin(ang))

var vec: Vector = newVector(1, 1)
#vec += newVector(1, 1)
echo vec.normalized