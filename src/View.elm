module View exposing(..)

import Html exposing (..)
import Html.Events exposing (onClick)
import Color exposing (Color)

import Element exposing (Element, toHtml)
import Collage exposing (collage, circle, Form, filled)

import Model exposing (..)

import Update exposing (..)

{- do general view stuff here, like start menu etc. -}

toForm: Hub -> Form
toForm hub = 
    let shape = circle hub.size
    in filled hub.color shape

newHub: Hub
newHub = 
    { color = Color.blue
    , pos = (0,0)
    , size = 25
    }

view : Model -> Html.Html Msg
view model =
    div []
        [ button [onClick LaunchHub] [text "Launch"]
        , toHtml <| collage 400 400 (List.map toForm model.hubs)
        ]

