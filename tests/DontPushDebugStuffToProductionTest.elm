module DontPushDebugStuffToProductionTest exposing (..)

import Configuration
import Test exposing (..)
import Expect


all : Test
all = Test.concat
            [ speedShouldBeFullSpeed ]

speedShouldBeFullSpeed: Test
speedShouldBeFullSpeed =
    test "speed should be full speed" <|
      \() ->
          Expect.equal Configuration.speed Configuration.FullSpeed
