module Update exposing(..)

import Model exposing (..)

{- do general update stuff here -}

type Msg = LaunchHub

update: Msg -> Model -> (Model, Cmd Msg)
update msg hubs =
    case msg of
        LaunchHub ->
            (hubs, Cmd.none)
