module Subscription exposing(..)

import AnimationFrame
-- import Window
import Model exposing (..)
import Time exposing (Time, second)
import Update exposing (..)

{- stole this from elm-joust -}
subscriptions : Model -> Sub Msg
subscriptions model =
   oncePerSecond |> Sub.batch

fullSpeed: List (Sub Msg)
fullSpeed = [ AnimationFrame.times Tick ]

oncePerSecond: List (Sub Msg)
oncePerSecond = [ Time.every second Tick ]
