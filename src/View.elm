module View exposing(..)

import Html exposing (..)
import Html.Events exposing (onClick)

import Element exposing (Element, toHtml)
import Collage exposing (collage, circle, Form, filled, move)

import Model exposing (..)

import Update exposing (..)

{- do general view stuff here, like start menu etc. -}

toForm: Hub -> Form
toForm hub = 
    let
        shape = circle hub.size
        form = filled hub.color shape
        (x, y) = hub.pos
    in move (toFloat x, toFloat y) form

view : Model -> Html.Html Msg
view model =
    div []
        [ button [onClick LaunchHub] [text "Launch"]
        , button [onClick AimRight] [text "Aim right"]
        , List.map toForm model.hubs
            |> collage 400 400
            |> toHtml
        ]

