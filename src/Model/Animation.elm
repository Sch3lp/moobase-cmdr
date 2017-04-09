module Model.Animation exposing (..)

import Debug exposing (log)

import Model.Position exposing(..)
import Model.Time exposing(..)

type alias AnimatingPosition =
    { from : Position
    , to : Position
    , animationStart : TimeStamp
    , animationEnd : TimeStamp
    }

updateAnimation: TimeStamp -> AnimatingPosition -> (Position, Maybe AnimatingPosition)
updateAnimation newTimeStamp animatingPosition =
    if ( animatingPosition.animationEnd > newTimeStamp) then
        let
            fraction = absoluteToFraction animatingPosition.animationStart animatingPosition.animationEnd newTimeStamp
            newPosition = fractionToAbsolutePos animatingPosition.from animatingPosition.to fraction
        in
            (newPosition, Just animatingPosition)
    else (animatingPosition.to, Nothing)

updateAnimationStatus: TimeStamp -> AnimatingPosition -> Maybe AnimatingPosition
updateAnimationStatus newTimeStamp animatingPosition =
    if (animatingPosition.animationEnd <= newTimeStamp) then Just animatingPosition else Nothing

absoluteToFraction: Float -> Float -> Float -> Float
absoluteToFraction low high point = (point - low) / (high - low)

fractionToAbsolute: Float -> Float -> Float -> Float
fractionToAbsolute low high point = point * (high - low) + low

fractionToAbsoluteInt: Int -> Int -> Float-> Int
fractionToAbsoluteInt low high point = (round ((toFloat (high - low)) * point)) + low


fractionToAbsolutePos: Position -> Position -> Float -> Position
fractionToAbsolutePos (lowX, lowY) (highX, highY) point =
 (fractionToAbsoluteInt lowX highX point, fractionToAbsoluteInt lowY highY point)