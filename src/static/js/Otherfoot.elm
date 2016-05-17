module Main exposing (..)

import Html.App as Html
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import WebSocket


-- local imports

import Card exposing (Card)


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : String -> ( Model, Cmd Msg )
init name =
    ( Model name Creating [] []
    , Cmd.none
    )



-- MODEL


type State
    = Joining
    | Creating
    | Playing
    | Judging


type alias Model =
    { username : String
    , state : State
    , creations : List Card
    , hand : List Card
    }



-- UPDATE


type Msg
    = Create Card
    | Submit Card
    | Play Card
    | Choose Card
    | Change State
    | Receive String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Create c ->
            model

        Choose c ->
            model

        Submit c ->
            model

        Change s ->
            model



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    WebSocket.listen "ws://echo.websocket.org" Receive



-- VIEW


stub : Html Msg
stub =
    div [] []


landingScreen : Html Msg
landingScreen =
    stub


cardCreationScreen : Html Msg
cardCreationScreen =
    stub


gameScreen : Html Msg
gameScreen =
    stub


view : Model -> Html Msg
view model =
    case model.state of
    Joining -> landingScreen

    Creating -> cardCreationScreen

    Playing -> gameScreen

    Judging -> gameScreen
