module Main exposing(..)

import Html exposing (Html)

import Model exposing (..)
import Model.Tree exposing (extractElem)
import Update exposing (..)
import View exposing (..)
import Subscription exposing (subscriptions)

initialModel: Model
initialModel = { players = [initialPlayer Player1 (-200, -200), initialPlayer Player2 (200, 200)]
               , direction = 0
               , force = 50
               , currentTime = 0
               , selectedHub = extractElem (initialHubTreeAt (-200, -200))
               }

main : Program Never Model Msg 
main =
  Html.program
  { init = (initialModel, Cmd.none)
  , update = update
  , view = view
  , subscriptions = subscriptions }
