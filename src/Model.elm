module Model exposing(..)

import Model.Animation exposing (..)
import Model.Position exposing (..)
import Model.Time exposing (..)
import Model.Tree exposing (..)

type alias Angle = Float
type alias Force = Float
type alias Power = { force: Force, charging: Bool }
increasePower: Power -> Float -> Power
increasePower power factor =
    {power | force = power.force + factor}
decreasePower: Power -> Float -> Power
decreasePower power factor =
    {power | force = power.force - factor}
toggleChargingPower: Power -> Power
toggleChargingPower power = 
    case power.charging of
      True  -> {power | charging = False}
      False -> {power | charging = True}
resetPower: Power -> Power
resetPower power = {power | force = 0}


{- Game model -}
type alias Model =
    { players: List PlayerState
    , currentTime: TimeStamp
    , direction: Angle
    , power: Power
    , selectedHub: Hub
    }
getPlayerTrees: Model -> List HubTree
getPlayerTrees {players} = List.map (\p -> p.network) players

{- Player stuff -}
type Player
    = Player1
    | Player2
    | Player3
    | Player4

type alias Energy = Int
startingEnergy: Energy
startingEnergy = 7

type alias PlayerState =
    { player: Player
    , network: HubTree
    , energy: Energy
    }
getHubTreeForPlayer: PlayerState -> HubTree
getHubTreeForPlayer player =
    player.network

initialPlayer: Player -> Position -> PlayerState
initialPlayer player pos = 
    { player  = player
    , network = initialHubTreeAt pos
    , energy  = startingEnergy
    }

{- Hub stuff -}
type alias Hub =
    { pos : Position
    , size : Float
    , animation : Maybe AnimatingPosition
    }

newHubAt: Position -> Hub
newHubAt pos =
    { pos = pos
    , size = hubSize
    , animation = Nothing
    }

hubSize: Float
hubSize = 25

{- HubTree stuff -}
type alias HubTree = Tree Hub

initialHubTreeAt: Position -> HubTree
initialHubTreeAt pos = newTree <| newHubAt pos

{- Cord stuff -}
type alias Cord =
    { from: Hub
    , to: Hub
    }

newCord: Hub -> Hub -> Cord
newCord from to =
    { from = from
    , to = to
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
getAllCords model = List.concatMap getAllChildCordsRecursive <| getPlayerTrees model

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
updateAnimations model = 
    let
        updateAnimationForPlayerState playerState = { playerState | network = map (updateAnimationForHub model.currentTime) playerState.network }
        updatedPlayers = List.map updateAnimationForPlayerState model.players
        updatedPower = increasePowerWhenCharging model.power
    in
        {model | players = updatedPlayers, power = updatedPower }

updateAnimationForHub: TimeStamp -> Hub -> Hub
updateAnimationForHub time hub =
    case hub.animation of
        Nothing -> hub
        Just animation ->
            let
                (newPos, newAnimation) = updateAnimation time animation
            in
                {hub | pos = newPos, animation = newAnimation}

increasePowerWhenCharging: Power -> Power
increasePowerWhenCharging power = 
    case power.charging of
      True -> increasePower power 2
      False -> power
        