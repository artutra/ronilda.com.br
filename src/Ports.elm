port module Ports exposing (toJavascript, toElm, scrollTo, toCmd, Request)
import Json.Encode as JsonE

type Request a
    = Request
        { id : String
        , data : JsonE.Value
        , response :
            Maybe
                { address : a
                , data : JsonE.Value
                }
        }

port toElm : (JsonE.Value -> msg) -> Sub msg


port toJavascript : JsonE.Value -> Cmd msg

noResponse : String -> JsonE.Value -> Request a
noResponse id data =
    Request
        { id = id
        , data = data
        , response = Nothing
        }

scrollTo :
    { viewportId : String
    , top : Float
    , left : Float
    , isSmooth : Bool
    }
    -> Request a
scrollTo config =
    [ ( "id", JsonE.string config.viewportId )
    , ( "config"
      , JsonE.object
            [ ( "top", JsonE.float config.top )
            , ( "left", JsonE.float config.left )
            , ( "behavior"
              , JsonE.string
                    (if config.isSmooth then
                        "smooth"

                     else
                        "auto"
                    )
              )
            ]
      )
    ]
        |> JsonE.object
        |> noResponse "ScrollTo"


toCmd : Request a -> Cmd msg
toCmd (Request req) =
    JsonE.object
        [ ( "id", JsonE.string req.id )
        , ( "data", req.data )
        , ( "response"
          , Maybe.map
                (\res ->
                    [ ( "data", res.data )
                    ]
                        |> JsonE.object
                )
                req.response
                |> Maybe.withDefault JsonE.null
          )
        ]
        |> toJavascript
