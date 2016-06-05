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
    ( Model "" (Drawing (Size 400 300) [] []) Nothing, Cmd.none )



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
    ( updateModel msg model, Cmd.none )


updateModel : Msg -> Model -> Model
updateModel msg model =
    case msg of
        EnterText s ->
            { model
                | text = s
            }

        Draw pos ->
            { model
                | drag = pos
                , draw = updateDrawing pos model.draw
            }


updateDrawing : Maybe Drag -> Drawing -> Drawing
updateDrawing drag draw =
    case drag of
        Nothing ->
            Drawing
                draw.size
                (draw.paths ++ [ traced defaultLine (path draw.current) ])
                []

        Just drag ->
            Drawing
                draw.size
                draw.paths
                (draw.current ++ [ relativePosition drag ])



-- SUBSCRIPTIONS


mouseUp : Position -> Msg
mouseUp _ =
    Draw Nothing


updateDrag : Position -> Position -> Msg
updateDrag start new =
    Draw <| Just { start = start, current = new }


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.drag of
        Nothing ->
            Sub.none

        Just { start, current } ->
            Sub.batch
                [ Mouse.moves (updateDrag start)
                , Mouse.ups mouseUp
                ]



-- VIEW


(=>) =
    (,)


view : Model -> Html Msg
view model =
    div
        [ style
            [ "border" => "1px black solid"
            , "width" => "400px"
            , "height" => "300px"
            ]
        , onMouseDown
        ]
        [ toHtml <| collage model.draw.size.w model.draw.size.h model.draw.paths
        , toHtml <| show model.drag
        ]


relativePosition : Drag -> ( Float, Float )
relativePosition { start, current } =
    ( toFloat <| current.x - start.x - 200
    , toFloat <| start.y - current.y - 150
    )


onMouseDown : Attribute Msg
onMouseDown =
    on "mousedown" (Json.map (\pos -> updateDrag pos pos) Mouse.position)
