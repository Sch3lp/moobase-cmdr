module Subscription exposing(..)

import AnimationFrame
-- import Window
import Configuration exposing (..)
import Keyboard
import Model exposing (..)
import Time exposing (Time, second)
import Update exposing (..)

{- stole this from elm-joust -}
subscriptions : Model -> Sub Msg
subscriptions model =
   selectedSpeed ++ keys
   |> Sub.batch

selectedSpeed =
    case Configuration.speed of
        FullSpeed -> fullSpeed
        OncePerSecond -> oncePerSecond

fullSpeed: List (Sub Msg)
fullSpeed = [ AnimationFrame.times Tick ]

oncePerSecond: List (Sub Msg)
oncePerSecond = [ Time.every second Tick ]

keys: List (Sub Msg)
keys = [ Keyboard.downs KeyPress ]
