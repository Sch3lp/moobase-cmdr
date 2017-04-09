module Model exposing(..)

import Model.Animation exposing (..)
import Model.Position exposing (..)
import Model.Time exposing (..)
import Model.Tree exposing (..)

type alias Angle = Float
type alias Force = Float

type alias Model =
    { rootHub: HubTree
    , currentTime: TimeStamp
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

initialHubTree: HubTree
initialHubTree = newTree (newHubAt (0,0))

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

getAllCords : Model -> List Cord
getAllCords model = getAllChildCordsRecursive model.rootHub

getAllChildCordsRecursive : HubTree -> List Cord
getAllChildCordsRecursive (TreeNode hub children) =
    let
        cords = getAllImmediateChildCords (TreeNode hub children)
    in
        cords ++ List.concatMap getAllChildCordsRecursive children

getAllImmediateChildCords : HubTree -> List Cord
getAllImmediateChildCords hubTree =
    case hubTree of
        TreeNode hub children -> getAllImmediateChildren hubTree |> List.map (newCord hub)

updateAnimations: Model -> Model
updateAnimations model = {model | rootHub = map (updateAnimationForHub model.currentTime) model.rootHub}

updateAnimationForHub: TimeStamp -> Hub -> Hub
updateAnimationForHub time hub =
    case hub.animation of
        Nothing -> hub
        Just animation ->
            let
                (newPos, newAnimation) = updateAnimation time animation
            in
                {hub | pos = newPos, animation = newAnimation}