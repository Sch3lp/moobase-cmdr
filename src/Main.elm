module Main exposing(..)

import Html exposing (Html)

import Model exposing (..)
import Update exposing (..)
import View exposing (..)
import Subscription exposing (subscriptions)

main : Program Never Model Msg
main =
  Html.program
  { init = ({hubs=[newHub]}, Cmd.none)
  , update = update
  , view = view
  , subscriptions = subscriptions }
