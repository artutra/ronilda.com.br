module Pages.Top exposing (Model, Msg, Params, page)

import Browser.Dom exposing (getElement)
import Html exposing (..)
import Html.Attributes exposing (attribute, class, height, id, src, style, tabindex, width)
import Html.Events exposing (onClick)
import Ports exposing (scrollTo, toCmd)
import Shared as Shared exposing (elemId)
import Spa.Document exposing (Document)
import Spa.Page as Page exposing (Page)
import Spa.Url exposing (Url)
import Task


type alias Params =
    ()


type alias Model =
    Url Params


type Msg
    = ScrollToElement String
    | GotElement (Result Browser.Dom.Error Browser.Dom.Element)


elemId =
    { header = "header"
    , about = "about"
    , whoIs = "who-is"
    , services = "services"
    , contact = "contact"
    }


page : Page Params Model Msg
page =
    Page.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


init : Url Params -> ( Model, Cmd msg )
init url =
    ( url, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ScrollToElement elementId ->
            ( model, Task.attempt GotElement (getElement elementId) )

        GotElement result ->
            case result of
                Ok elem ->
                    ( model, toCmd (scrollAction elem.element.y) )

                Err (Browser.Dom.NotFound err) ->
                    Debug.log err
                        ( model, Cmd.none )


imgUrls =
    { logo = "img/trevo.png"
    , bannerBackground = "img/header.png"
    , profile = "img/ronilda-v2.jpg"
    }



-- VIEW


view : Url Params -> Document Msg
view { params } =
    { title = "Homepage"
    , body = [ viewHeader, viewWhoIs, viewAbout, viewServices, viewContact ]
    }


headerButton : String -> String -> Html Msg
headerButton scrollToElemId buttonText =
    button [ class "hover:text-blue-500 px-2 text-xl", onClick (ScrollToElement scrollToElemId) ]
        [ text buttonText ]


viewHeader : Html Msg
viewHeader =
    section [ id elemId.header, class "relative h-screen flex flex-col" ]
        [ img [ src imgUrls.bannerBackground, class "absolute inset-0 object-cover w-full", style "z-index" "-1" ] []
        , div [ class "container mx-auto max-w-6xl flex justify-between items-center py-4" ]
            [ div [ class "text-4xl flex items-center font-semibold" ]
                [ img [ src imgUrls.logo, class "h-10 w-10 object-contain mr-2" ] []
                , text "Ronilda Lima de Miranda"
                ]
            , div [ class "" ]
                [ headerButton elemId.whoIs "Quem sou"
                , headerButton elemId.about "Sobre a Guestalt"
                , headerButton elemId.services "Meus Serviços"
                , headerButton elemId.contact "Contato"
                ]
            ]
        , div [ class "flex-1 container mx-auto max-w-6xl flex" ]
            [ div [ class "max-w-2xl flex-1 pt-32" ]
                [ p [ class "text-3xl font-semibold" ]
                    [ text """
                    "Quando alguém compreende como sinto e como sou, sem querer me analisar ou julgar, 
                    então, nesse clima, posso desabrochar e crescer."
                    """
                    ]
                , p [ class "text-right" ]
                    [ text "Carl Rogers" ]
                ]
            ]
        ]


scrollAction : Float -> Ports.Request a
scrollAction top =
    scrollTo
        { viewportId = Shared.elemId.viewportId
        , top = top
        , left = 0
        , isSmooth = True
        }


viewWhoIs : Html Msg
viewWhoIs =
    section [ id elemId.whoIs ]
        [ div [ class "container mx-auto max-w-2xl flex flex-col items-center py-4" ]
            [ div [ class "flex flex-col items-center mb-6" ]
                [ img [ src imgUrls.logo, class "h-10 w-16 object-contain" ] []
                , h4 [ class "text-4xl font-semibold" ]
                    [ text "Quem sou "
                    , span [ class "text-green-300 font-semibold" ] [ text "eu" ]
                    ]
                ]
            , div [ class "flex" ]
                [ img [ src imgUrls.profile, class "flex-1 h-48 w-48 object-contain" ] []
                , div [ class "flex-1" ]
                    [ p []
                        [ text """
                            Psicóloga, Gestalt-terapeuta pelo Instituto Gestalt do Ceará, 
                            graduada em Psicologia pelo Centro Universitário Santo Agostinho (Teresina-PI) 
                            e graduada em Comunicação Social pela Universidade Federal do Maranhão. 
                        """
                        ]
                    , br [] []
                    , p []
                        [ text """
                            A Gestalt-terapia é a minha principal linha de atuação com foco no atendimento de adultos e 
                            casais.
                        """
                        ]
                    ]
                ]
            ]
        ]


viewAbout : Html msg
viewAbout =
    section [ id elemId.about ]
        [ div [ class "container mx-auto max-w-2xl flex flex-col items-center py-4" ]
            [ div [ class "flex flex-col items-center mb-6" ]
                [ h4 [ class "text-4xl font-semibold" ]
                    [ text "Sobre a "
                    , span [ class "text-yellow-500 font-semibold" ] [ text "Guestalt" ]
                    ]
                ]
            , div [ class "flex" ]
                [ div [ class "flex-1" ]
                    [ p []
                        [ text """
                            As palavras mais próximas para se traduzir a palavra alemã GESTALT 
                            são “forma” ou “configuração”. 
                            Os pressupostos teóricos da Gestalt-terapia estão baseados no humanismo, 
                            existencialismo e na fenomenologia. 
                            É uma abordagem da Psicologia que valoriza a qualidade da relação da 
                            pessoa com o meio, investe no estreitamento do contato, na percepção 
                            das próprias reações diante de determinadas situações e na valorização 
                            da experiência. Se interessa muito mais pelo que o sujeito sente no 
                            “Aqui Agora”, se conscientizando de suas escolhas e seu modo de 
                            viver a fim de, pouco a pouco, ir ampliando sua percepção e 
                            atribuindo seus próprios significados.
                        """
                        ]
                    ]
                ]
            ]
        ]


viewServices : Html msg
viewServices =
    section [ id elemId.services ]
        [ div [ class "container mx-auto max-w-2xl flex flex-col items-center py-4" ]
            [ div [ class "flex flex-col items-center mb-6" ]
                [ h4 [ class "text-4xl font-semibold" ]
                    [ text "Meus "
                    , span [ class "text-blue-500 font-semibold" ] [ text "serviços" ]
                    ]
                ]
            ]
        ]



-- section [ id elemId.services, class "h-screen" ]
--     [ div []
--         [ h5 [] [ text "Terapia individual" ]
--         , p [] [ text "Na terapia individual, ao mesmo tempo em que o terapeuta não abdica de sua autoridade, a emprega de modo que o cliente venha a ser a autoridade em sua própria vida." ]
--         ]
--     , div []
--         [ h5 [] [ text "Terapia de casal" ]
--         , p [] [ text "Segundo Cardella (2009), assim como a vida, pela qual somos responsáveis, uma relação necessita do cultivo de ambos os parceiros para durar e bem durar, mas seu destino transcende todas as tentativas de controlar e determinar os acontecimentos." ]
--         ]
--     , p []
--         [ text """
--             As palavras mais próximas para se traduzir a palavra alemã GESTALT são “forma” ou “configuração”. Os pressupostos teóricos da Gestalt-terapia estão baseados no humanismo, existencialismo e na fenomenologia. É uma abordagem da Psicologia que valoriza a qualidade da relação da pessoa com o meio, investe no estreitamento do contato, na percepção das próprias reações diante de determinadas situações e na valorização da experiência. Se interessa muito mais pelo que o sujeito sente no “Aqui Agora”, se conscientizando de suas escolhas e seu modo de viver a fim de, pouco a pouco, ir ampliando sua percepção e atribuindo seus próprios significados.
--         """
--         ]
--     ]


googleMapsSource =
    "https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3974.1962574438803!2d-42.784652085258365!3d-5.071916196318767!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x78e3a21ead3119d%3A0x2f7d99a34c99bfa8!2sCl%C3%ADnica%20PsicoCentro!5e0!3m2!1spt-BR!2sbr!4v1600825907916!5m2!1spt-BR!2sbr"


viewContact : Html msg
viewContact =
    section [ id elemId.contact ]
        [ div [ class "container mx-auto flex items-start py-4 flex" ]
            [ div [ class "flex-1 flex flex-col items-start justify-start" ]
                [ div [ class "flex-1 flex items-center" ]
                    [ img [ src imgUrls.logo, class "h-10 w-10 object-contain mr-2" ] []
                    , p [ class "text-2xl font-semibold" ] [ text "Ronilda Lima de Miranda" ]
                    ]
                , p [] [ text "Clínica Psicocentro e atendimento online" ]
                , p [] [ text "Av Homero Castelo Branco, 1418" ]
                , p [] [ text "São Cristóvão, Teresina - PI" ]
                , p [] [ text "(86) 3233-9553 / (86) 98823-9553" ]
                ]
            , div [ class "flex-1" ]
                [ iframe
                    [ src googleMapsSource
                    , width 400
                    , height 400
                    , tabindex 0
                    , style "border" "0"
                    , attribute "frameborder" "0"
                    , attribute "allowfullscreen" "true"
                    , attribute "aria-hidden" "false"
                    ]
                    []
                ]
            ]
        ]
