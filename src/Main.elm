module Main exposing(..)

import Html exposing (Html)

import Model exposing (..)
import Update exposing (..)
import View exposing (..)
import Subscription exposing (subscriptions)

main : Program Never Hub Msg
main =
  Html.program
  { init = (newHub, Cmd.none)
  , update = update
  , view = view
  , subscriptions = subscriptions }
