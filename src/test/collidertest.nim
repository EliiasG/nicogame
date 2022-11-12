import nico
import ../consts
import ../colliders
import ../vector

const appName = "ColliderTest"

type
    CircleColliderObject = ref object
        collider: CircleCollider
        position: Vector
    RectColliderObject = ref object
        collider: RectCollider
        position: Vector

let staticCollider: RectColliderObject = RectColliderObject()
let movingCollider: CircleColliderObject = CircleColliderObject()

var id: int = 0

proc gameInit() =
    #loadFont(1, "font.png")
    let palette: Palette = loadPaletteFromGPL("palette.gpl")
    setPalette(palette)
    staticCollider.collider = newRectCollider(40, 20)
    movingCollider.collider = newCircleCollider(6)
    staticCollider.position = newVector(100, 100)
    movingCollider.position = newVector(100, 200)


proc gameUpdate(dt: float32) =
    var moveDir = newVector(jaxis(pcXAxis, id), jaxis(pcYAxis, id))
    if moveDir.lenSq > 1:
        moveDir = moveDir.normalized
    if moveDir.lenSq < 0.1*0.1:
        moveDir = newVector(0, 0)
    movingCollider.position += moveDir
    movingCollider.position = updatedPosition(movingCollider.position, movingCollider.collider, staticCollider.position, staticCollider.collider)
    echo isColliding(movingCollider.position, movingCollider.collider, staticCollider.position, staticCollider.collider)
    for i in 0..4:
        if anybtnp(i):
            id = i

proc drawCircleColliderObject(obj: CircleColliderObject, draw: proc(cx, cy, r: Pint)) =
    draw(obj.position.x.int, obj.position.y.int, obj.collider.r.int)

proc drawRectColliderObject(obj: RectColliderObject, draw: proc(x, y, w, h: Pint)) =
    draw(obj.position.x.int, obj.position.y.int, obj.collider.w.int, obj.collider.h.int)

proc gameDraw() =
    cls(7)
    setColor(9)
    drawRectColliderObject(staticCollider, boxfill)
    setColor(10)
    drawCircleColliderObject(movingCollider, circ)

proc startColliderTest*() =
    nico.init(orgName, appName)
    nico.createWindow(appName, 256, 256, 3, false)
    nico.run(gameInit, gameUpdate, gameDraw)