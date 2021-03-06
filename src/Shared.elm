module Shared exposing
    ( Flags
    , Model
    , Msg
    , init
    , subscriptions
    , update
    , view, elemId
    )

import Browser.Navigation exposing (Key)
import Html exposing (..)
import Html.Attributes exposing (class, href)
import Spa.Document exposing (Document)
import Spa.Generated.Route as Route
import Url exposing (Url)
import Html.Attributes exposing (id)



-- INIT


type alias Flags =
    ()


type alias Model =
    { url : Url
    , key : Key
    }

elemId = 
    { viewportId = "page"
    }

init : Flags -> Url -> Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model url key
    , Cmd.none
    )



-- UPDATE


type Msg
    = ReplaceMe


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReplaceMe ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view :
    { page : Document msg, toMsg : Msg -> msg }
    -> Model
    -> Document msg
view { page, toMsg } model =
    { title = page.title
    , body =
        [ div [ class "layout" ]
            [ header [ class "fixed" ]
                -- Example of link
                -- [ a [ class "link", href (Route.toString Route.Top) ] [ text "Homepage" ]
                -- ]
                []
            , div [ id elemId.viewportId, class "overflow-auto h-screen" ] page.body
            ]
        ]
    }
