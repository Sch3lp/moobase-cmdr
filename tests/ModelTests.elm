module ModelTests exposing (..)

import Test exposing (..)
import Expect
-- import Fuzz exposing (list, int, tuple, string)
-- import String

import Model exposing (..)


all : Test
all = Test.concat
            [ launchTest ]


hub: Hub
hub = 
    { pos = (0,0)
    , size = 25
    , animation = Nothing
    }

launchTest: Test
launchTest = 
    describe "launch with force 100"
        [ describe "direction is Up"
            [ test "hub is in the middle" <|
                \() ->
                    Expect.equal (launch {hub | pos = (0,0)} 0 100) (0,-100)
            , test "hub is on x = 10, y = 0" <|
                \() ->
                    Expect.equal (launch {hub | pos = (10,0)} 0 100) (10,-100)
            , test "hub is on x = 33, y = -10" <|
                \() ->
                    Expect.equal (launch {hub | pos = (33,-10)} 0 100) (33,-110)
            ]
        ]
