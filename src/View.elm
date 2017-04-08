module View exposing(..)

import Html exposing (..)
import Html.Events exposing (onClick)
import Color exposing (Color)


import Element exposing (Element, toHtml)
import Collage exposing (collage, circle, Form, filled, move)

import Model exposing (..)

import Update exposing (..)

{- do general view stuff here, like start menu etc. -}

toForm: Hub -> Form
toForm hub = 
    let
        shape = circle hub.size
        form = filled Color.blue shape
        (x, y) = hub.pos
    in move (toFloat x, toFloat y) form

view : Model -> Html.Html Msg
view model =
    div []
        [ button [onClick LaunchHub] [text "Launch"]
        , button [onClick AimRight] [text "Aim right"]
        , button [ onClick DecrementForce ] [ text "-" ]
        , span [] [ text (toString model.force) ]
        , button [ onClick IncrementForce ] [ text "+" ]
        , List.map toForm (model.rootHub :: findAllChildrenRecursive model.rootHub)
            |> collage 400 400
            |> toHtml
        ]
