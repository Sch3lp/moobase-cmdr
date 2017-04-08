module Main exposing(..)

import Html exposing (Html)

import Model exposing (..)
import Update exposing (..)
import View exposing (..)
import Subscription exposing (subscriptions)

initialModel: Model
initialModel = { hubs = [newHub]
               , direction = 0
               , force = 50
               }

main : Program Never Model Msg 
main =
  Html.program
  { init = (initialModel, Cmd.none)
  , update = update
  , view = view
  , subscriptions = subscriptions }
