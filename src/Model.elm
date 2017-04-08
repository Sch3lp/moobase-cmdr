module Model exposing(..)

import Color exposing (Color)

type alias Model =
    { hubs: List Hub
    }

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

newHubAt: (Int, Int) -> Hub
newHubAt pos =
    { color = Color.red
    , pos = pos
    , size = 25
    }
