module Model exposing(..)

type alias Angle = Float
type alias Force = Float
type alias Position = (Int, Int)

type alias Model =
    { rootHub: Hub
    , direction: Angle
    , force: Force
    }

type alias Hub =
    { pos : Position
    , size : Float
    , children : ChildHubs
    }

type ChildHubs = ChildHubs (List Hub)

type alias Cord =
    { from: Hub
    , to: Hub
    }

newCord: Hub -> Hub -> Cord
newCord from to =
    { from = from
    , to = to
    }

initialHub: Hub
initialHub =
    { pos = (0,0)
    , size = 25
    , children = ChildHubs []
    }

newHubAt: Position -> Hub
newHubAt pos =
    { pos = pos
    , size = 25
    , children = ChildHubs []
    }

launch: Hub -> Angle -> Force -> Position
launch hub direction force =
    case (direction, hub.pos) of
        (0  , (x,y)) -> (x, y + round force)
        (180, (x,y)) -> (x, y - round force)
        (90 , (x,y)) -> (x + round force, y)
        (270, (x,y)) -> (x - round force, y)
        (_  , (_,_)) -> (100,100)

findAllCords : Model -> List Cord
findAllCords model = findAllChildCordsRecursive model.rootHub

findAllChildCordsRecursive : Hub -> List Cord
findAllChildCordsRecursive hub =
    let
        children = findAllImmediateChildren hub
        cords = findAllImmediateChildCords hub
    in
        cords ++ List.concatMap findAllChildCordsRecursive children

findAllImmediateChildCords : Hub -> List Cord
findAllImmediateChildCords hub =
    findAllImmediateChildren hub
    |> List.map (newCord hub)


findAllChildrenRecursive : Hub -> List Hub
findAllChildrenRecursive hub =
    let
        children = findAllImmediateChildren hub
    in
        children ++ List.concatMap findAllChildrenRecursive children

findAllImmediateChildren : Hub -> List Hub
findAllImmediateChildren hub =
    case hub.children of
        ChildHubs (children) -> children

appendChildToHub: Hub -> Hub -> Hub
appendChildToHub parent child =
    let
        newChildren = appendChildWithUnwrap parent.children child
    in
        {parent | children = newChildren}

-- I don't know how to do this inline, so I'll add another function!
appendChildWithUnwrap: ChildHubs -> Hub -> ChildHubs
appendChildWithUnwrap (ChildHubs existingChildren) child =
    ChildHubs (child :: existingChildren)