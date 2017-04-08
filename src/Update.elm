module Update exposing(..)

import Model exposing (..)

{- do general update stuff here -}

type Msg = LaunchHub

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        LaunchHub ->
            let
                newHubs = (newHubAt (100, 100)) :: model.hubs
            in
                ({model | hubs = newHubs}, Cmd.none)
