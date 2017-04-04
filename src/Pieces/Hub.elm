module Hub exposing(Hub)

import Color exposing (Color)

import Html exposing (..)
import Element exposing (Element, toHtml)
import Collage exposing (collage, circle, Form, filled)

type alias Hub = 
    { color : Color 
    , pos : (Int, Int)
    , size : Float
    }

newHub: Hub
newHub = 
    { color = Color.blue
    , pos = (0,0)
    , size = 25
    }

toForm: Hub -> Form
toForm hub = 
    let shape = circle hub.size
    in filled hub.color shape

main : Html.Html msg
main = toHtml <| collage 400 400 [toForm newHub]
