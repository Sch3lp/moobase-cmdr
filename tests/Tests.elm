module Tests exposing (..)

import Test exposing (..)
import Expect
import Fuzz exposing (list, int, tuple, string)
import String

import Model exposing (..)
import Model.Tree exposing (..)

all : Test
all = describe "moobase commander"
    [ hubTests
    , exampleTests
    ]

initialHub = (newHubAt (0,0))
aHub = (newHubAt (100,100))
anotherHub = (newHubAt (200,200))

hubTests : Test
hubTests =
    describe "A hubtree"
        [ describe "when adding children"
             [ test "given an initial hubtree, returns a new hubtree with a child" <|
                 \() ->
                    let
                        hubWithChildren = appendChild initialHubTree aHub
                    in
                        hubWithChildren |> Expect.equal (TreeNode initialHub [TreeNode aHub []])
             , test "given a hubtree with child, returns a new hubtree with grandchildren" <|
                 \() ->
                    let
                        hubWithChildren = appendChild initialHubTree aHub
                        hubWithGrandchildren = appendChildAt hubWithChildren anotherHub (\x -> x == aHub)
                    in
                        hubWithGrandchildren |> Expect.equal (TreeNode initialHub [TreeNode aHub [TreeNode anotherHub []]])
             ]
        , describe "when listing its direct children"
             [ test "given a hub without children, then no children are returned" <|
                 \() ->
                     getAllImmediateChildren initialHubTree |> Expect.equal []
             , test "given a hub with children, then return the children" <|
                 \() ->
                     let
                         hubWithChildren = appendChild initialHubTree aHub
                     in
                         getAllImmediateChildren hubWithChildren |> Expect.equal [aHub]
             , test "given a hub with grandchildren, then return only the immediate children" <|
                 \() ->
                     let
                         hubWithChildren = appendChild initialHubTree aHub
                         hubWithGrandchildren = appendChildAt hubWithChildren anotherHub (\x -> x == aHub)
                     in
                         getAllImmediateChildren hubWithGrandchildren |> Expect.equal [aHub]
             ]
        , describe "when listing all elements recursively"
              [ test "given an initial hubtree, then the initial hub is returned" <|
                  \() ->
                      getAllElemsRecursive initialHubTree |> Expect.equal [initialHub]
              , test "given a hub with children, then the initial hub and the child are returned" <|
                  \() ->
                      let
                          hubWithChildren = appendChild initialHubTree aHub
                      in
                          getAllElemsRecursive hubWithChildren |> Expect.equal [initialHub, aHub]
              , test "given a hub with grandchildren, then the initial hub and all children are returned" <|
                  \() ->
                      let
                          hubWithChildren = appendChild initialHubTree aHub
                          hubWithGrandchildren = appendChildAt hubWithChildren anotherHub (\x -> x == aHub)
                      in
                          getAllElemsRecursive hubWithGrandchildren |> Expect.equal [initialHub, aHub, anotherHub]
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
            , fuzzWith { runs = 1000 } int "List.member will get an integer in a list containing it" <|
                \i ->
                    List.member i [ i ] |> Expect.true "If you see this, List.member returned False!"
            , fuzz2 string string "The length of a string equals the sum of its substrings' lengths" <|
                \s1 s2 ->
                    s1 ++ s2 |> String.length |> Expect.equal (String.length s1 + String.length s2)
            ]
        ]
