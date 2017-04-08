module View exposing(..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Svg exposing (..)
import Svg.Attributes exposing (..)


import Model exposing (..)
import Model.Position exposing (..)

import Update exposing (..)

{- do general view stuff here, like start menu etc. -}

posToFloat: Position -> (Float, Float)
posToFloat (x, y) =  (toFloat x, toFloat y)

hubBorder: Float
hubBorder = 3

hub2Circle: Hub -> Svg.Svg msg
hub2Circle hub = 
    Svg.circle 
        [ cx <| toString (Tuple.first  hub.pos)
        , cy <| toString (Tuple.second hub.pos)
        , r  <| toString (hub.size - hubBorder)
        , stroke "red"
        , strokeWidth <| toString hubBorder
        , fill "blue"
        ] []

{- TODO write to SVG
cord2Form: Cord -> Form
cord2Form cord =
    let
        p = Collage.path [posToFloat cord.from.pos, posToFloat cord.to.pos]
    in traced defaultLine p
-}

cord2View: Cord -> Svg.Svg msg
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
            [ button [onClick LaunchHub] [Html.text "Launch"]
            , button [onClick AimLeft]   [Html.text "Aim left"]
            , button [onClick AimRight]  [Html.text "Aim right"]
            , span [] [ Html.text "Force: " ]
            , button [ onClick DecrementForce ] [ Html.text "-" ]
            , span [] [ Html.text (toString model.force) ]
            , button [ onClick IncrementForce ] [ Html.text "+" ]
            ]
        , svg 
            [ Svg.Attributes.width  "400"
            , Svg.Attributes.height "400"
            , version "1.1"
            , viewBox "-200 -200 400 400"
            ] <| createAllCircles model
        ]

createAllCircles : Model -> List (Svg.Svg msg)
createAllCircles model = 
    let
        allHubs = (model.rootHub :: findAllChildrenRecursive model.rootHub)
        allCords = findAllCords model
    in
        List.map hub2Circle allHubs ++ List.map cord2View allCords
    