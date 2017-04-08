module Update exposing(..)

import Model exposing (..)

{- do general update stuff here -}

type Msg = LaunchHub | AimRight

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        -- TODO vincenve need to add the hub we're launching from, for now always root hub
        LaunchHub ->
            let
                newHub = (newHubAt <| launch initialHub model.direction model.force)
                oldRootHub = model.rootHub
                newRootHub = appendChildToHub oldRootHub newHub
            in
                ({model | rootHub = newRootHub}, Cmd.none)
        AimRight ->
            let
                newDirection = model.direction + 90
            in
                ({model | direction = newDirection}, Cmd.none)
