module CardCreation exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (on)
import Collage exposing (collage, defaultLine, traced, path)
import Element exposing (toHtml, show)
import Json.Decode as Json exposing ((:=))
import Mouse exposing (Position)


-- MODEL


type alias Size =
    { w : Int
    , h : Int
    }


type alias Drawing =
    { size : Size
    , paths : List Collage.Form
    , current : List ( Float, Float )
    }


type alias Model =
    { text : String
    , draw : Drawing
    , pos : Maybe Position
    , clicked : Bool
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
    ( Model "" (Drawing (Size 400 300) [] []) Nothing False, Cmd.none )



-- UPDATE


type Msg
    = EnterText String
    | Click Position
    | Draw (Maybe Position)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( updateModel msg model, Cmd.none )


updateModel : Msg -> Model -> Model
updateModel msg model =
    case msg of
        EnterText s ->
            { model
                | text = s
            }

        Click pos ->
            { model
                | pos = Just pos
                , clicked = True
            }

        Draw pos ->
            { model
                | pos = pos
                , draw = if model.clicked then
                             updateDrawing pos model.draw
                         else
                             model.draw
                , clicked = case pos of
                                Nothing -> False
                                Just _ -> model.clicked
            }


toDrawingPos : Size -> Position -> ( Float, Float )
toDrawingPos size pos =
    ( (toFloat pos.x) - (toFloat size.w / 2.0)
    , (toFloat size.h / 2.0) - (toFloat pos.y)
    )


updateDrawing : Maybe Position -> Drawing -> Drawing
updateDrawing drag draw =
    case drag of
        Nothing ->
            Drawing draw.size
                (draw.paths ++ [ traced defaultLine (path draw.current) ])
                []

        Just pos ->
            Drawing draw.size
                draw.paths
                (draw.current ++ [ toDrawingPos draw.size pos ])



-- SUBSCRIPTIONS


mouseUp : Position -> Msg
mouseUp _ =
    Draw Nothing


updateDrag : Position -> Msg
updateDrag pos =
    Draw (Just pos)


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.pos of
        Nothing ->
            Sub.none

        Just _ ->
            Mouse.ups mouseUp



-- VIEW


(=>) =
    (,)


view : Model -> Html Msg
view model =
    let
        dbg =
            case model.pos of
                Nothing ->
                    show "No position"

                Just pos ->
                    show (toDrawingPos model.draw.size pos)
    in
        div
            [ style
                [ "border" => "1px black solid"
                , "width" => "400px"
                , "height" => "300px"
                ]
            , getPositionOn "mousedown" Click
            , getPositionOn "mousemove" (Just >> Draw)
            ]
            [ toHtml <| collage model.draw.size.w model.draw.size.h model.draw.paths
            , toHtml <| dbg
            ]



-- relativePosition : Drag -> ( Float, Float )
-- relativePosition { start, current } =
--     ( toFloat <| current.x - start.x - 200
--     , toFloat <| start.y - current.y - 150
--     )


offsetPosition : Json.Decoder Position
offsetPosition =
    Json.object2 Position ("offsetX" := Json.int) ("offsetY" := Json.int)


getPositionOn : String -> (Position -> Msg) -> Attribute Msg
getPositionOn s msg =
    on s (Json.map msg offsetPosition)
