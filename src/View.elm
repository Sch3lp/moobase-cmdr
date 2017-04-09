module View exposing(..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Svg exposing (..)
import Svg.Attributes exposing (..)


import Model exposing (..)
import Model.Position exposing (..)
import Model.Tree exposing (..)

import Update exposing (..)

{- do general view stuff here, like start menu etc. -}

posToFloat: Position -> (Float, Float)
posToFloat (x, y) =  (toFloat x, toFloat y)

hubBorder: Float
hubBorder = 3

worldSize: Int
worldSize = 2000

hub2Circle: Hub -> Hub -> Svg.Svg Msg
hub2Circle hub selectedHub =
    Svg.circle (renderHub hub selectedHub) []

renderHub: Hub -> Hub -> List (Svg.Attribute Msg)
renderHub hub selectedHub =
    let
        baseAttributes =
            [ cx <| toString (Tuple.first  hub.pos)
            , cy <| toString (Tuple.second hub.pos)
            , r  <| toString (hub.size - hubBorder)
            , strokeWidth <| toString hubBorder
            , fill "blue"
            , onClick (SelectHub hub)
            ]
    in
        if (selectedHub == hub ) then
            stroke "red" :: baseAttributes
        else
            baseAttributes

cord2View: Cord -> Svg.Svg Msg
cord2View cord =
    case (cord.from.pos, cord.to.pos)
    of ((fromX,fromY), (toX,toY)) ->
        Svg.line
            [ x1 <| toString fromX
            , y1 <| toString fromY
            , x2 <| toString toX
            , y2 <| toString toY
            , Html.Attributes.style [("stroke","rgb(0,255,0)"),("stroke-width","2")]
            ]
            [ ]

view : Model -> Html.Html Msg
view model =
    div [Html.Attributes.style [("height", "100%"), ("width", "100%")]]
        [ div []
            [ button [onClick <| LaunchHub model.selectedHub] [Html.text "Launch"]
            , button [onClick AimLeft]   [Html.text "Aim left"]
            , span [] [ Html.text (toString model.direction) ]
            , button [onClick AimRight]  [Html.text "Aim right"]
            , span [] [ Html.text "Force: " ]
            , button [ onClick DecrementForce ] [ Html.text "-" ]
            , span [] [ Html.text (toString model.force) ]
            , button [ onClick IncrementForce ] [ Html.text "+" ]
            ]
        , svg 
            [ Svg.Attributes.width  "100%"
            , Svg.Attributes.height "100%"
            , version "1.1"
            , viewBox <| List.foldr (++) "" <| List.intersperse " " <| List.map toString [(-worldSize//2), (-worldSize//2), worldSize, worldSize]
            ] <| createAllCircles model
        ]

createAllCircles : Model -> List (Svg.Svg Msg)
createAllCircles model = 
    let
        allHubs = getAllElemsRecursive model.rootHub
        allCords = getAllCords model
    in
        List.map (\hub -> hub2Circle hub model.selectedHub) allHubs ++ List.map cord2View allCords
    