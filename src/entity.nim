import world

type
    Entity* = ref object of BaseEntity #circular import fix hack
        componentSeq: seq[Component]
    Component* = ref object of RootObj

var componentProcs: seq[proc(world: World)]

proc applyComponents*(world: World) = 
    for p in componentProcs:
        p(world)

proc components*(entity: Entity): seq[Component] =
    entity.componentSeq

proc hasComponent*(entity: Entity, component: Component): bool =
    for c in entity.componentSeq:
        if c is typeof component:
            return true
    return false

proc addComponent*(entity: Entity, component: Component) = 
    if not entity.hasComponent(component):
        entity.componentSeq.add(component)

proc registerComponentProc*(componentProc: proc(world: World)) =
    componentProcs.add(componentProc)