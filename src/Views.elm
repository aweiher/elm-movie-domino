module Views exposing (view)

import Http
import Html exposing (..)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (placeholder, class)

import Models exposing (Model, DominoAppMessage(..), Actor)


view : Model -> Html DominoAppMessage
view model =
    div []
        (   [ renderHeader ]
            ++ [ renderErrorButtons ]
            ++ (renderErrorMessage model.errorMessage model.errorIsDisplayed)
            ++ [ (renderSearchField model) ]
            ++ [ renderActorsListView model.actors ]
        )


renderErrorMessage : Maybe String -> Bool -> List (Html DominoAppMessage)
renderErrorMessage maybeErrors displayError =
    case maybeErrors of
        Nothing ->
            []

        Just errors ->
            case displayError of
              True ->
                [ div [ class "bg-danger" ] [ text errors ] ]
              _ ->
                [ div [] []]



renderErrorButtons : Html DominoAppMessage
renderErrorButtons =
  div [ class "input-group"] [
    button [onClick ToggleErrorDisplay] [text "show error message"],
    button [onClick (SearchFailed Http.Timeout)] [text "timeout error"],
    button [onClick (SearchFailed Http.NetworkError)] [text "network error"],
    button [onClick (SearchFailed (Http.UnexpectedPayload "nope"))] [text "unexpected payload error"],
    button [onClick (SearchFailed (Http.BadResponse 500 "nope"))] [text "bad response error"]
  ]

renderSearchField : Model -> Html DominoAppMessage
renderSearchField model =
    div [ class "input-group" ]
        [ input
            [ placeholder "e.g. Uma Thurman"
            , onInput TextChanged
            , class "form-control"
            ]
            [ text model.actorSearchFieldText ]
        , span
            [ class "input-group-btn"
            ]
            [ button
                [ onClick SearchClicked
                , class "btn btn-default"
                ]
                [ text "Search" ]
            ]
        ]


renderHeader : Html DominoAppMessage
renderHeader =
    h1 [] [ text "Movie Domino" ]


renderActorsListView : Maybe (List Actor) -> Html DominoAppMessage
renderActorsListView maybeActors =
    case maybeActors of
        Nothing ->
            text "Pending"

        Just actors ->
            div [ class "list-group" ] (List.map renderActorView actors)


renderActorView : Actor -> Html DominoAppMessage
renderActorView actor =
    button [ class "list-group-item" ] [ text actor.name ]
