module Update exposing(..)

import Model exposing (..)
import Model.Time exposing (TimeDelta)


{- do general update stuff here -}

type Msg
    = LaunchHub
    | AimRight
    | AimLeft
    | IncrementForce
    | DecrementForce
    | Tick TimeDelta

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        -- TODO vincenve need to add the hub we're launching from, for now always root hub
        LaunchHub ->
            let
                oldRootHub = model.rootHub
                newHub = (newHubAt <| launch (extractHub oldRootHub) model.direction model.force)
                newRootHub = appendChildToHub oldRootHub newHub
            in
                ({model | rootHub = newRootHub}, Cmd.none)
        AimRight ->
            let
                newDirection = model.direction + 90
            in
                ({model | direction = newDirection}, Cmd.none)
        AimLeft ->
            let
                newDirection = model.direction - 90
            in
                ({model | direction = newDirection}, Cmd.none)
        IncrementForce ->
            ({model | force = model.force + 15}, Cmd.none)
        DecrementForce ->
            ({model | force = model.force - 15}, Cmd.none)
        Tick delta ->
            (model, Cmd.none)

