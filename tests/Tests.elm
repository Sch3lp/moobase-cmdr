module Tests exposing (..)

import Test exposing (..)
import Expect
import Fuzz exposing (list, int, tuple, string)
import String

import Model exposing (..)

all : Test
all = describe "moobase commander"
    [ hubTests
    , exampleTests
    ]

hubTests : Test
hubTests =
    describe "A hub"
        [ describe "when adding children"
             [ test "given a hub without children, returns a new hub with a child" <|
                 \() ->
                    let
                        hubWithChildren = appendChildToHub initialHub initialHub
                    in
                        hubWithChildren.children |> Expect.equal (ChildHubs [initialHub])
             ]
          , describe "when listing its direct children"
            [ test "given a hub without children, then no children are returned" <|
                \() ->
                    findAllImmediateChildren initialHub |> Expect.equal []
            , test "given a hub with children, then return the children" <|
                \() ->
                    let
                        hubWithChildren = appendChildToHub initialHub initialHub
                    in
                        findAllImmediateChildren hubWithChildren |> Expect.equal [initialHub]
            , test "given a hub with grandchildren, then return only the immediate children" <|
                \() ->
                    let
                        hubWithChildren = appendChildToHub initialHub initialHub
                        hubWithGrandchildren = appendChildToHub initialHub hubWithChildren
                    in
                        findAllImmediateChildren hubWithGrandchildren |> Expect.equal [hubWithChildren]
            ]
        , describe "when listing its children recursively"
              [ test "given a hub without children, then no children are returned" <|
                  \() ->
                      findAllChildrenRecursive initialHub |> Expect.equal []
              , test "given a hub with children, then return the children" <|
                  \() ->
                      let
                          hubWithChildren = appendChildToHub initialHub initialHub
                      in
                          findAllChildrenRecursive hubWithChildren |> Expect.equal [initialHub]
              ]
        ]


exampleTests : Test
exampleTests =
    describe "Sample Test Suite"
        [ describe "Unit test examples"
            [ test "Addition" <|
                \() ->
                    Expect.equal (3 + 7) 10
            , test "String.left" <|
                \() ->
                    Expect.equal "a" (String.left 1 "abcdefg")
            ]
        , describe "Fuzz test examples, using randomly generated input"
            [ fuzz (list int) "Lists always have positive length" <|
                \aList ->
                    List.length aList |> Expect.atLeast 0
            , fuzz (list int) "Sorting a list does not change its length" <|
                \aList ->
                    List.sort aList |> List.length |> Expect.equal (List.length aList)
            , fuzzWith { runs = 1000 } int "List.member will find an integer in a list containing it" <|
                \i ->
                    List.member i [ i ] |> Expect.true "If you see this, List.member returned False!"
            , fuzz2 string string "The length of a string equals the sum of its substrings' lengths" <|
                \s1 s2 ->
                    s1 ++ s2 |> String.length |> Expect.equal (String.length s1 + String.length s2)
            ]
        ]
