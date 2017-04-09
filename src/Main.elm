module Main exposing(..)

import Html exposing (Html)

import Model exposing (..)
import Model.Tree exposing (extractElem)
import Update exposing (..)
import View exposing (..)
import Subscription exposing (subscriptions)

initialModel: Model
initialModel = { rootHub = initialHubTree
               , direction = 0
               , force = 50
               , currentTime = 0
               , selectedHub = extractElem (initialHubTree)
               }

main : Program Never Model Msg 
main =
  Html.program
  { init = (initialModel, Cmd.none)
  , update = update
  , view = view
  , subscriptions = subscriptions }
