module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import List exposing (..)

import Model exposing (..)
import Database exposing 
    ( commonTags
    , abilities
    , stratagems
    , warlordTraits )
import Util exposing (filterEmpty)

main : Program () Model Msg
main =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = (\_ -> Sub.none) }

init : () -> ( Model, Cmd Msg )
init _ =
  ( { searchText = ""
    , tags = commonTags
    , abilities = abilities
    , stratagems = stratagems
    , warlordTraits = warlordTraits
    , filteredAbilities = []
    , filteredStratagems = []
    , filteredWarlordTraits = [] }
  , Cmd.none )

type Msg
  = SearchUpdated String
  | AddTag Tag
  | Clear

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    SearchUpdated text ->
        ( { model 
            | searchText = text
            , filteredAbilities = model.abilities
                |> matchArticles (toTerms text)
                |> filterPairs
                |> sortPairs
            , filteredStratagems = model.stratagems
                |> matchArticles (toTerms text)
                |> filterPairs
                |> sortPairs
            , filteredWarlordTraits = model.warlordTraits
                |> matchArticles (toTerms text)
                |> filterPairs
                |> sortPairs }
        , Cmd.none )
    AddTag (Tag tag) ->
        let searchText = if String.isEmpty model.searchText then tag else model.searchText ++ "," ++ tag
            searchUpdated = SearchUpdated searchText
        in update searchUpdated model
    Clear -> 
        ( { model
            | searchText = ""
            , filteredAbilities = [] }
        , Cmd.none )

-- Term

toTerms: String -> List Term
toTerms text = text
    |> String.split ","
    |> List.map String.trim
    |> List.map Term

-- Match

matchArticles: List Term -> List Article -> List (Article, Model.Result)
matchArticles terms articles = articles
    |> List.map (matchArticle terms)

matchArticle: List Term -> Article -> (Article, Model.Result)
matchArticle terms article = 
    let tagsResult = terms
            |> List.map (matchTags article.tags)
            |> List.foldl combine NoMatch
        headerResult = matchHeader article.header terms
    in (article, combine tagsResult headerResult)

matchHeader: Header -> List Term -> Model.Result
matchHeader header terms = 
    let titleStartsWithAnyTerm = if List.any (startsWithTerm header.title) terms then Match 10 else NoMatch
        factionEqualsAnyTerm = matchFaction header.faction terms
        subFactionEqualsAnyTerm = matchFaction header.subfaction terms
    in List.foldl combine NoMatch [titleStartsWithAnyTerm, factionEqualsAnyTerm, subFactionEqualsAnyTerm]

matchFaction: Maybe Faction -> List Term -> Model.Result
matchFaction maybeFaction terms = case maybeFaction of 
    Just faction -> if List.any (equalsTerm faction.name) terms then Match 5 else NoMatch
    Nothing -> NoMatch

matchTags: List Tag -> Term -> Model.Result
matchTags tags (Term term) = tags
    |> List.map (matchTag term)
    |> List.map (\bool -> if bool then Match 1 else NoMatch)
    |> List.foldl combine NoMatch

matchTag: String -> Tag -> Bool
matchTag text (Tag tag) = 
    (String.toLower text) == (String.toLower tag)

startsWithTerm: String -> Term -> Bool
startsWithTerm text (Term term) = 
    let termLow = String.toLower term
        textLow = String.toLower text
    in String.startsWith termLow textLow

equalsTerm: String -> Term -> Bool
equalsTerm text (Term term) = 
    let termLow = String.toLower term
        textLow = String.toLower text
    in termLow == textLow

-- Filter

filterPairs: List (Article, Model.Result) -> List (Article, Model.Result)
filterPairs pairs = pairs
    |> List.map filterPair
    |> filterEmpty

filterPair: (Article, Model.Result) -> Maybe (Article, Model.Result)
filterPair pair = case Tuple.second pair of
    NoMatch -> Nothing
    Match 0 -> Nothing
    Match _ -> Just pair

-- Sort

sortPairs: List (Article, Model.Result) -> List Article
sortPairs pairs = pairs
    |> List.map (\pair -> (Tuple.first pair, case Tuple.second pair of
        Match rank -> rank
        NoMatch -> 0))
    |> List.sortBy Tuple.second
    |> List.map Tuple.first
    |> List.reverse

-- Model.Result

toBool: Model.Result -> Bool
toBool result = case result of
    Match _ -> True
    NoMatch -> False

combine: Model.Result -> Model.Result -> Model.Result
combine result1 result2 = case result1 of
    Match m1 -> case result2 of
        Match m2 -> Match (m1 + m2)
        NoMatch -> Match m1
    NoMatch -> case result2 of
        Match m2 -> Match m2
        NoMatch -> NoMatch

view: Model -> Html Msg
view model =
  div [ id "view-root" ] 
    [ headerView model
    , bodyView model
    , footer [] [] ] 

headerView: HeaderModel m -> Html Msg
headerView model = header [] 
    [ div [] 
        [ nav [ ] 
            [ div [ class "brand" ] 
                [ input 
                    [ class "mr"
                    , type_ "text"
                    , placeholder "Search"
                    , value model.searchText
                    , onInput SearchUpdated ] [] 
                , button [ title "Clear Search", onClick Clear ] [ text "X" ] ]
            , input [ id "menu", type_ "checkbox", class "show" ] []
            , label [ for "menu", class "burger pseudo button" ] [ ] ]
            , div [ class "menu" ] 
                [ a [ href "#", class "pseudo button" ] [ text "Options" ]
                , a [ href "#", class "pseudo button" ] [ text "About" ] ] ] ]

bodyView: BodyModel m -> Html Msg
bodyView model = div [ class "content" ]
    [ div [ class "tabs three" ] 
        [ input 
            [ id "tab-1"
            , type_ "radio"
            , name "tabgroupA"
            , checked True ] []
        , label 
            [ class "fixed width-30 top-40 z-99 label tag"
            , for "tab-1" ] 
            [ text "Abilities" ]
        , input 
            [ id "tab-2"
            , type_ "radio"
            , name "tabgroupA" ] []
        , label 
            [ class "fixed width-30 left-32 top-40 z-99 label tag"
            , for "tab-2" ] 
            [ text "Stratagems" ]
        , input 
            [ id "tab-3"
            , type_ "radio"
            , name "tabgroupA" ] []
        , label 
            [ class "fixed width-30 left-64 top-40 z-99 label tag"
            , for "tab-3" ] 
            [ text "Warlord Traits" ]
        , div [ class "row relative top-30" ] 
            [ div [] ( model.filteredAbilities
                |> List.map articleView )
            , div [] ( model.filteredStratagems
                |> List.map articleView )
            , div [] ( model.filteredWarlordTraits
                |> List.map articleView ) ] ] ]
    

articleView: Article -> Html Msg
articleView model = article [ class "card m-01" ] 
    [ articleHeaderView model.header
    , div [ class "p" ] 
        [ articleSubHeaderView model.header
        , contentView model.content ]
    , footer []
        ( model.tags
            |> List.map tagView ) ]

contentView: Content -> Html Msg
contentView model = case model of 
    Text content -> div [] [ text content ]
    Table content -> div [] [ contentTableView content ]
    Mixed c1 c2 -> div [] [ contentView c1, contentView c2 ]

contentTableView: List (List String) -> Html Msg
contentTableView model = table [] (case model of
    [] -> []
    headerRow::rows -> [ contentTableHeaderView headerRow, contentTableBodyView rows ] )

contentTableHeaderView: List String -> Html Msg
contentTableHeaderView model = model
    |> List.map text
    |> List.map List.singleton
    |> List.map (th [])
    |> (tr [])
    |> List.singleton
    |> (thead [])

contentTableBodyView: List (List String) -> Html Msg
contentTableBodyView model = model
    |> List.map contentTableRowView
    |> (tbody [])

contentTableRowView: List String -> Html Msg
contentTableRowView model = model
    |> List.map text
    |> List.map List.singleton
    |> List.map (td [])
    |> (tr [])

articleSubHeaderView: Header -> Html Msg
articleSubHeaderView model = case model.kind of
    Stratagem -> div [ class "sub-header" ] 
        [ span [] [ text "Stratagem" ] 
        , costView model.cost ]
    Ability -> div [ class "sub-header" ]
        [ span [] [ text "Ability" ] ]
    WarlordTrait -> div [ class "sub-header" ]
        [ span [] [ text "Warlord Trait" ] ]

costView: Maybe Cost -> Html Msg
costView model = span [ class "cost" ] [ ( case model of 
    Just (Simple cost) -> text ((String.fromInt cost) ++ " CP")
    Just (Complex c1 c2) -> text ((String.fromInt c1) ++ " CP / " ++ (String.fromInt c2) ++ " CP" )
    Nothing -> text "" ) ]

articleHeaderView: Header -> Html Msg
articleHeaderView model = header [] 
    [ h3 [ class "width-80 mr-0" ] [ text model.title ]
    , span [ class "width-20" ] 
        [ factionView model.subfaction
        , factionView model.faction] ]

factionView: Maybe Faction -> Html Msg
factionView model = case model of
    Just faction -> img 
        [ src ("./img/" ++ faction.image)
        , alt faction.name 
        , class "faction-icon" 
        , onClick (AddTag (Tag faction.name)) ] []
    Nothing -> span [] []

tagView: Tag -> Html Msg
tagView (Tag name) = span 
    [ class "label mt-02 tag"
    , onClick (AddTag (Tag name)) ] [ text name ]
