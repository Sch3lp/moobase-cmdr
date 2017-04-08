module Model exposing(..)

import Color exposing (Color)

type alias Angle = Float
type alias Force = Float

type alias Model =
    { rootHub: Hub
    , direction: Angle
    , force: Force
    }

type alias Hub =
    {
     color : Color
    , pos : (Int, Int)
    , size : Float
    , children : ChildHubs
    }

type ChildHubs = ChildHubs (List Hub)

initialHub: Hub
initialHub =
    { color = Color.blue
    , pos = (0,0)
    , size = 25
    , children = ChildHubs []
    }

newHubAt: (Int, Int) -> Hub
newHubAt pos =
    { color = Color.red
    , pos = pos
    , size = 25
    , children = ChildHubs []
    }

launch: Hub -> Angle -> Force -> (Int, Int)
launch hub direction force =
    case (direction, hub.pos) of
        (0  , (x,y)) -> (x, y + round force)
        (180, (x,y)) -> (x, y - round force)
        (90 , (x,y)) -> (x + round force, y)
        (270, (x,y)) -> (x - round force, y)
        (_  , (_,_)) -> (100,100)


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