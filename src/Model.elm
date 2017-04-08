module Model exposing(..)

import Model.Animation exposing (..)
import Model.Position exposing (..)
import Model.Time exposing (..)
import Model.Tree exposing (..)

type alias Angle = Float
type alias Force = Float

type alias Model =
    { rootHub: HubTree
    , direction: Angle
    , force: Force
    }

type alias Hub =
    { pos : Position
    , size : Float
    , animation : Maybe AnimatingPosition
    }

type alias HubTree = Tree Hub

type alias Cord =
    { from: Hub
    , to: Hub
    }

newCord: Hub -> Hub -> Cord
newCord from to =
    { from = from
    , to = to
    }

hubSize: Float
hubSize = 25

initialHub: HubTree
initialHub = newTree (newHubAt (0,0))

newHubAt: Position -> Hub
newHubAt pos =
    { pos = pos
    , size = hubSize
    , animation = Nothing
    }

launch: Hub -> Angle -> Force -> Position
launch hub direction force = calculateLandingPoint hub.pos direction force

calculateLP: Int -> (Float -> Float) -> Angle -> Force -> Int
calculateLP i fn direction force = 
    (+) i 
    <| round 
    <| (*) force
    <| fn 
    <| degrees direction

calculateLandingPoint: Position -> Angle -> Force -> Position
calculateLandingPoint (x,y) direction force =
        ( calculateLP x sin direction force, calculateLP y cos (direction + 180) force) -- -180 because fuck you SVG

findAllCords : Model -> List Cord
findAllCords model = findAllChildCordsRecursive model.rootHub

findAllChildCordsRecursive : HubTree -> List Cord
findAllChildCordsRecursive (TreeNode hub children) =
    let
        cords = findAllImmediateChildCords (TreeNode hub children)
    in
        cords ++ List.concatMap findAllChildCordsRecursive children

findAllImmediateChildCords : HubTree -> List Cord
findAllImmediateChildCords hubTree =
    case hubTree of
        TreeNode hub children -> findAllImmediateChildren hubTree |> List.map (newCord hub)

