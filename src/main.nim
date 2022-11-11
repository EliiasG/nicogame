import world
import nico
import render/worldrenderer

const orgName = "EliiasG"
const appName = "NicoTest"

var buttonDown = false

let testWorld: World = newWorld(10)
testWorld[0][0] = wall
testWorld[2][2] = wall

proc gameInit() =
  loadFont(1, "font.png")
  let palette: Palette = loadPaletteFromGPL("palette.gpl")
  setPalette(palette)

proc gameUpdate(dt: float32) =
  buttonDown = btn(pcA, 0)

proc gameDraw() =
  cls(6)
  setColor(if buttonDown: 7 else: 9)
  renderWorld(testWorld, 25)

nico.init(orgName, appName)
nico.createWindow(appName, 256, 256, 3, false)
nico.run(gameInit, gameUpdate, gameDraw)