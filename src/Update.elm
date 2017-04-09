module Update exposing(..)

import Model exposing (..)
import Model.Animation exposing (AnimatingPosition)
import Model.Position exposing (Position)
import Model.Time exposing (TimeStamp)
import Model.Tree exposing (..)
import Keyboard exposing (KeyCode)


{- do general update stuff here -}

type Msg
    = LaunchHub Hub
    | AimRight
    | AimLeft
    | IncrementForce
    | DecrementForce
    | Tick TimeStamp
    | SelectHub Hub
    | KeyPress KeyCode

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        LaunchHub originatingHub ->
                ({model | playerTrees = List.map (updateTreeAfterLaunch model originatingHub) model.playerTrees}, Cmd.none)
        AimRight ->
            (aimRight model, Cmd.none)
        AimLeft ->
            (aimLeft model, Cmd.none)
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
        KeyPress keyCode ->
            (handleKeyPress keyCode model, Cmd.none)

aimRight model =
    let
        newDirection = model.direction + 15
    in
        {model | direction = newDirection}

aimLeft model =
    let
        newDirection = model.direction - 15
    in
        {model | direction = newDirection}

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


handleKeyPress : KeyCode -> Model -> Model
handleKeyPress keycode model =
  case keycode of
    37 -> aimLeft model
    39 -> aimRight model
    _ -> model