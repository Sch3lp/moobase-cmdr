module Update exposing(..)

import Model exposing (..)
import Model.Animation exposing (AnimatingPosition)
import Model.Position exposing (Position)
import Model.Time exposing (TimeStamp)
import Model.Tree exposing (..)



{- do general update stuff here -}

type Msg
    = LaunchHub
    | AimRight
    | AimLeft
    | IncrementForce
    | DecrementForce
    | Tick TimeStamp

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        -- TODO vincenve need to add the hub we're launching from, for now always root hub
        LaunchHub ->
            let
                oldRootHub = model.rootHub
                targetPosition = launch (extractElem oldRootHub) model.direction model.force
                newHub = (newHubAt (extractElem oldRootHub).pos)
                newAnimatedHub = {newHub | animation = setupAnimation (extractElem oldRootHub).pos targetPosition model}
                newRootHub = appendChild oldRootHub newAnimatedHub
            in
                ({model | rootHub = newRootHub}, Cmd.none)
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

setupAnimation: Position -> Position -> Model -> Maybe AnimatingPosition
setupAnimation from to model =
    Just
    { from = from
    , to = to
    , animationStart = model.currentTime
    , animationEnd = model.currentTime + 3000
    }
