module Subscription exposing(..)

-- import AnimationFrame
-- import Window
import Model exposing (..)
import Update exposing (..)

{- stole this from elm-joust -}
subscriptions : Hub -> Sub Msg
subscriptions hub =
  Sub.none
-- subscriptions {ui} =
--   let
--       window = Window.resizes (\{width,height} -> ResizeWindow (width,height))
--       animation = [ AnimationFrame.diffs Tick ]
--       seconds = Time.every Time.second TimeSecond
--   in
--      (
--      case ui.screen of
--        StartScreen ->
--          [ window, seconds ]

--        PlayScreen ->
--          [ window ] ++ keys ++ animation

--        GameoverScreen ->
--          [ window ] ++ keys

--      ) |> Sub.batch


-- initialWindowSizeCommand : Cmd Msg
-- initialWindowSizeCommand =
--   Task.perform (\{width,height} -> ResizeWindow (width,height)) Window.size
