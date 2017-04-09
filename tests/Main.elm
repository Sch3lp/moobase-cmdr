port module Main exposing (..)

import Tests
import DontPushDebugStuffToProductionTest
import ModelTests
import Test exposing(concat)
import Test.Runner.Node exposing (run, TestProgram)
import Json.Encode exposing (Value)


main : TestProgram
main =
    run emit 
        <| Test.concat [ Tests.all, ModelTests.all, DontPushDebugStuffToProductionTest.all ]

port emit : ( String, Value ) -> Cmd msg
