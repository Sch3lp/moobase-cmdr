module View exposing(..)

import Html exposing (..)
import Html.Events exposing (onClick)
import Color exposing (Color)


import Element exposing (Element, toHtml)
import Collage exposing (..)

import Model exposing (..)

import Update exposing (..)

{- do general view stuff here, like start menu etc. -}

hub2Form: Hub -> Form
hub2Form hub =
    let
        shape = circle hub.size
        form = filled Color.blue shape
        (x, y) = hub.pos
    in move (toFloat x, toFloat y) form

cord2Form: Cord -> Form
cord2Form cord =
    let
        (x1, y1) = cord.from.pos
        (x2, y2) = cord.to.pos
        p = path [(toFloat x1, toFloat y1), (toFloat x2, toFloat y2)]
    in traced defaultLine p

view : Model -> Html.Html Msg
view model =
    div []
        [ button [onClick LaunchHub] [Html.text "Launch"]
        , button [onClick AimLeft] [Html.text "Aim left"]
        , button [onClick AimRight] [Html.text "Aim right"]
        , span [] [ Html.text "Force: " ]
        , button [ onClick DecrementForce ] [ Html.text "-" ]
        , span [] [ Html.text (toString model.force) ]
        , button [ onClick IncrementForce ] [ Html.text "+" ]
        , createAllForms model
            |> collage 400 400
            |> toHtml
        ]

createAllForms : Model -> List Form
createAllForms model =
    let
        allHubs = (model.rootHub :: findAllChildrenRecursive model.rootHub)
        allCords = findAllCords model
    in
        List.map hub2Form allHubs
        ++ List.map cord2Form allCords