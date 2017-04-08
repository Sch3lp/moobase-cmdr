module Model exposing(..)

import Color exposing (Color)

type alias Hub = 
    { color : Color 
    , pos : (Int, Int)
    , size : Float
    }