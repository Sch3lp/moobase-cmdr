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

hub2Circle: Hub -> Hub -> String -> Svg.Svg Msg
hub2Circle hub selectedHub color =
    Svg.circle 
        (renderHub hub selectedHub color)
        []

renderHub: Hub -> Hub -> String -> List (Svg.Attribute Msg)
renderHub hub selectedHub color =
    let
        baseAttributes =
            [ cx <| toString (Tuple.first  hub.pos)
            , cy <| toString (Tuple.second hub.pos)
            , r  <| toString (hub.size - hubBorder)
            , strokeWidth <| toString hubBorder
            , fill color
            , onClick (SelectHub hub)
            ]
    in
        if (selectedHub == hub) then
            stroke "red" :: baseAttributes
        else
            baseAttributes

renderReticle: Angle -> Hub -> List (Svg.Svg Msg)
renderReticle direction selectedHub =
    let
      (x, y) = calculateLandingPoint selectedHub.pos direction selectedHub.size
    in
    [ Svg.circle
        [ cx <| toString x
        , cy <| toString y
        , r  <| toString <| hubBorder + 1
        , fill "red"
        ]
        []
    ]

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
            [ Svg.Attributes.width  "90%"
            , Svg.Attributes.height "90%"
            , version "1.1"
            , viewBox <| List.foldr (++) "" <| List.intersperse " " <| List.map toString [(-worldSize//2), (-worldSize//2), worldSize, worldSize]
            ] 
            <| (createAllCircles model) ++ (renderReticle model.direction model.selectedHub)
        ]

getPlayerTreesWithColor: Model -> List (Tree (Hub, String))
getPlayerTreesWithColor {players} = List.map (\p -> Model.Tree.map (\hub -> (hub, if p.player == Player1 then "blue" else "orange")) p.network) players

createAllCircles : Model -> List (Svg.Svg Msg)
createAllCircles model = 
    let
        allHubs: List (Hub, String)
        allHubs = List.concatMap getAllElemsRecursive <| getPlayerTreesWithColor model
        allCords = getAllCords model
    in
        List.map (\(hub, color) -> hub2Circle hub model.selectedHub color) allHubs ++ List.map cord2View allCords
    