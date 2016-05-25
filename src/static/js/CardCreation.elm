module CardCreation exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (on)
import Collage exposing (collage)
import Element exposing (toHtml, show)
import Json.Decode as Json exposing ((:=))
import Mouse exposing (Position)


-- MODEL


type alias Model =
    { text : String
    , paths : List Collage.Form
    , currentPath : List (Float, Float)
    , drag : Maybe Drag
    }


main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


init : ( Model, Cmd Msg )
init =
  ( Model "" [] [] Nothing, Cmd.none )



-- UPDATE


type Msg
    = EnterText String
    | Draw (Maybe Drag)


type alias Drag =
    { start : Position
    , current : Position
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  ( updateHelp msg model, Cmd.none )


updateHelp : Msg -> Model -> Model
updateHelp msg model =
  case msg of
    EnterText s ->
        { model
            | text = s
              }
    Draw pos ->
        { model
        | drag = pos
        }



-- SUBSCRIPTIONS


mouseUp : Position -> Msg
mouseUp _ =
    Draw Nothing


updateDrag : Position -> Position -> Msg
updateDrag start new =
    Draw <| Just {start = start, current = new}


subscriptions : Model -> Sub Msg
subscriptions model =
  case model.drag of
    Nothing ->
      Sub.none

    Just {start, current} ->
      Sub.batch
             [ Mouse.moves (updateDrag start)
             , Mouse.ups mouseUp ]



-- VIEW


(=>) = (,)


view : Model -> Html Msg
view model =
    div
        [ style [ "border" => "1px black solid" ]
        , onMouseDown ]
        [ toHtml <| collage 400 300 model.paths
        , toHtml <| show model.drag]


getPosition : Model -> Maybe Position
getPosition model =
    case model.drag of
      Nothing ->
          Nothing

      Just {start, current} ->
          Just <| Position
              (current.x - start.x)
              (current.y - start.y)


onMouseDown : Attribute Msg
onMouseDown =
    on "mousedown" (Json.map (\pos -> updateDrag pos pos) Mouse.position)
