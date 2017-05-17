module Update exposing(..)

import Model exposing (..)
import Model.Animation exposing (AnimatingPosition)
import Model.Position exposing (Position)
import Model.Time exposing (TimeStamp)
import Model.Tree exposing (..)
import Keyboard exposing (KeyCode)


{- do general update stuff here -}

type Msg
    = LaunchHub Hub
    | AimRight
    | AimLeft
    | IncrementForce
    | DecrementForce
    | Tick TimeStamp
    | SelectHub Hub
    | KeyPress KeyCode

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        LaunchHub originatingHub -> 
            (launchHub model originatingHub, Cmd.none)
        AimRight ->
            (aimRight model, Cmd.none)
        AimLeft ->
            (aimLeft model, Cmd.none)
        IncrementForce ->
            (incrementForce model, Cmd.none)
        DecrementForce ->
            (decrementForce model, Cmd.none)
        Tick newTime ->
            let
                updatedAnimations = updateAfterTimePassed newTime model
            in
                (updatedAnimations, Cmd.none)
        SelectHub newSelectedHub ->
            ({model | selectedHub = newSelectedHub}, Cmd.none)
        KeyPress keyCode ->
            (handleKeyPress keyCode model, Cmd.none)

incrementForce: Model -> Model
incrementForce model =
    { model | power = increasePower model.power 15 }

decrementForce: Model -> Model
decrementForce model =
    { model | power = decreasePower model.power 15 }


aimRight: Model -> Model
aimRight model =
    let
        newDirection = model.direction + 15
    in
        {model | direction = newDirection}

aimLeft: Model -> Model
aimLeft model =
    let
        newDirection = model.direction - 15
    in
        {model | direction = newDirection}


toggleChargeOrLaunch: Model -> Model
toggleChargeOrLaunch model =
    toggleCharge model |> launchIfChargingStopped

toggleCharge: Model -> Model
toggleCharge model = 
    let
        newPower = model.power |> toggleChargingPower
    in
      {model | power = newPower}

launchIfChargingStopped: Model -> Model
launchIfChargingStopped model =
    case model.power.charging of
        True -> model
        False -> launchHub model model.selectedHub
    


launchHub: Model -> Hub -> Model
launchHub model originatingHub = 
    let
        updateTreeAfterLaunchForPlayerState playerState = { playerState | network = updateTreeAfterLaunch model originatingHub playerState.network }
        updatedPlayers = List.map updateTreeAfterLaunchForPlayerState model.players
        updatedPower = resetPower model.power
    in
      {model | players = updatedPlayers, power = updatedPower}

updateTreeAfterLaunch : Model -> Hub -> HubTree -> HubTree
updateTreeAfterLaunch model originatingHub tree =
    let
        targetPosition = launch originatingHub model.direction model.power.force
        newHub = (newHubAt originatingHub.pos)
        newAnimatedHub = {newHub | animation = setupAnimation originatingHub.pos targetPosition model}
        newRootHub = appendChildAt tree newAnimatedHub (\x -> x == originatingHub)
    in
        newRootHub

setupAnimation: Position -> Position -> Model -> Maybe AnimatingPosition
setupAnimation from to model =
    Just
    { from = from
    , to = to
    , animationStart = model.currentTime
    , animationEnd = model.currentTime + 3000
    }


handleKeyPress : KeyCode -> Model -> Model
handleKeyPress keycode model =
  case keycode of
    37 -> aimLeft model
    39 -> aimRight model
    32 -> toggleChargeOrLaunch model
    _ -> model