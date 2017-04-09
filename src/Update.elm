module Update exposing(..)

import Model exposing (..)
import Model.Animation exposing (AnimatingPosition)
import Model.Position exposing (Position)
import Model.Time exposing (TimeStamp)
import Model.Tree exposing (..)



{- do general update stuff here -}

type Msg
    = LaunchHub Hub
    | AimRight
    | AimLeft
    | IncrementForce
    | DecrementForce
    | Tick TimeStamp
    | SelectHub Hub

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        LaunchHub originatingHub -> launchHub model originatingHub
        AimRight ->
            let
                newDirection = model.direction + 15
            in
                ({model | direction = newDirection}, Cmd.none)
        AimLeft ->
            let
                newDirection = model.direction - 15
            in
                ({model | direction = newDirection}, Cmd.none)
        IncrementForce ->
            ({model | force = model.force + 15}, Cmd.none)
        DecrementForce ->
            ({model | force = model.force - 15}, Cmd.none)
        Tick newTime ->
            let
                updatedTime = {model | currentTime = newTime}
                updatedAnimations = updateAnimations updatedTime
            in
                (updatedAnimations, Cmd.none)
        SelectHub newSelectedHub ->
            ({model | selectedHub = newSelectedHub}, Cmd.none)

launchHub: Model -> Hub -> (Model, Cmd Msg)
launchHub model originatingHub = 
    let
        updateTreeAfterLaunchForPlayerState playerState = { playerState | network = updateTreeAfterLaunch model originatingHub playerState.network }
        updatedPlayers = List.map updateTreeAfterLaunchForPlayerState model.players
    in
      ({model | players = updatedPlayers}, Cmd.none)

updateTreeAfterLaunch : Model -> Hub -> HubTree -> HubTree
updateTreeAfterLaunch model originatingHub tree =
    let
        targetPosition = launch originatingHub model.direction model.force
        newHub = (newHubAt originatingHub.pos)
        newAnimatedHub = {newHub | animation = setupAnimation originatingHub.pos targetPosition model}
        newRootHub = appendChildAt tree newAnimatedHub (\x -> x == originatingHub)
    in
        newRootHub

setupAnimation: Position -> Position -> Model -> Maybe AnimatingPosition
setupAnimation from to model =
    Just
    { from = from
    , to = to
    , animationStart = model.currentTime
    , animationEnd = model.currentTime + 3000
    }
