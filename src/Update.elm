module Update exposing(..)

import Model exposing (..)

{- do general update stuff here -}

type Msg = LaunchHub

update: Msg -> Hub -> (Hub, Cmd Msg)
update msg hub =
    (hub, Cmd.none)
