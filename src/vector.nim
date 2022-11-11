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

proc `-`*(vec0, vec1: Vector): Vector =
    newVector(vec0.x - vec1.x, vec0.y - vec1.y)

proc `+=`*(vec0: var Vector, vec1: Vector) =
    vec0 = vec0 + vec1

proc `-=`*(vec0: var Vector, vec1: Vector) =
    vec0 = vec0 - vec1

proc `*`*(vec0: Vector, vec1: Vector): Vector =
    newVector(vec0.x * vec1.x, vec0.y * vec1.y)

proc `*`*(vec0: Vector, v: float): Vector =
    newVector(vec0.x * v, vec0.y * v) # not using the vec * vec proc, as there is no reason to allocate another vector

proc lenSq*(vec: Vector): float =
    vec.x.pow(2) + vec.y.pow(2)

proc len*(vec: Vector): float =
    sqrt(vec.lenSq)

proc distSq*(vec0: Vector, vec1: Vector): float =
    (vec1 - vec0).lenSq

proc dist*(vec0: Vector, vec1: Vector): float =
    (vec1 - vec0).len

proc angle*(vec: Vector): float =
    arctan2(vec.y, vec.x)

proc normalized*(vec: Vector): Vector =
    let ang: float = vec.angle
    newVector(cos(ang), sin(ang))