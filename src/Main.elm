module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import List exposing (..)

import Model exposing (..)
import Database exposing 
    ( abilities
    , stratagems
    , warlordTraits
    , astraMilitarum
    , adeptusCustodes )
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
    , abilities = abilities
    , stratagems = stratagems
    , warlordTraits = warlordTraits
    , showOnlyKind = Nothing
    , factionsToShow = []
    , articles = abilities ++ stratagems ++ warlordTraits
    , visibleArticles = [] }
  , Cmd.none )

type Msg
  = SearchUpdated String
  | AddTag Tag
  | ShowOnlyKind Kind
  | ToggleFaction Faction
  | Clear

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    SearchUpdated text ->
        ( { model 
            | searchText = text
            , visibleArticles = search 
                text 
                model.showOnlyKind 
                model.factionsToShow 
                model.articles }
        , Cmd.none )
    AddTag (Tag tag) ->
        let searchText = if String.isEmpty model.searchText 
                then tag 
                else model.searchText ++ "," ++ tag
            searchUpdated = SearchUpdated searchText
        in update searchUpdated model
    ShowOnlyKind kind -> 
        if compare kind model.showOnlyKind 
            then update (SearchUpdated model.searchText) { model
                | showOnlyKind = Nothing }
            else update (SearchUpdated model.searchText) { model
                | showOnlyKind = Just kind }
    ToggleFaction faction -> 
        if List.member faction model.factionsToShow 
            then update (SearchUpdated model.searchText) { model
                | factionsToShow = (List.filter ((/=) faction) model.factionsToShow) }
            else update (SearchUpdated model.searchText) { model
                | factionsToShow = faction :: model.factionsToShow }
    Clear -> 
        ( { model
            | searchText = ""
            , visibleArticles = [] }
        , Cmd.none )

-- Search

search: String -> Maybe Kind -> List Faction -> List Article -> List Article
search text kind factions articles = articles
    |> filterByFaction factions
    |> filterByKind kind
    |> matchArticles (toTerms text)
    |> filterPairs
    |> sortPairs

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
    Just faction -> if List.any (equalsTerm faction.name) terms 
        then Match 5 
        else NoMatch
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

filterByFaction: List Faction -> List Article -> List Article
filterByFaction factions articles = case factions of
    [] -> articles
    _ -> articles
        |> List.filter (\article -> isIn article.header.faction factions)

filterByKind: Maybe Kind -> List Article -> List Article
filterByKind kind articles = case kind of
    Nothing -> articles
    Just actualKind -> articles
        |> List.filter (\article -> article.header.kind == actualKind)

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

-- Util

compare: e -> Maybe e -> Bool
compare e1 e2 = case e2 of
    Nothing -> False
    Just actualE2 -> e1 == actualE2

isIn: Maybe e -> List e -> Bool
isIn maybeE es = case maybeE of
    Nothing -> List.isEmpty es
    Just e -> List.member e es

-- UI

view: Model -> Html Msg
view model =
  div [ id "view-root" ] 
    [ article [ class "card height-100" ]
        [ headerView model
        , bodyView model
        , footerView model ] ]

headerView: HeaderModel m -> Html Msg
headerView model = header [ class "border" ] 
    [ div [ ] 
        [ input 
            [ class "width-80 mr"
            , type_ "text"
            , placeholder "Search"
            , value model.searchText
            , onInput SearchUpdated ] [] 
        , button 
            [ class ""
            , title "Clear Search"
            , onClick Clear ] [ text "X" ] ] 
    , div [ class "flex three" ] 
        [ div []
            [ kindButton "Abilities" Ability model.showOnlyKind ]
        , div [] 
            [ kindButton "Stratagems" Stratagem model.showOnlyKind ]
        , div []
            [ kindButton "Warlord Traits" WarlordTrait model.showOnlyKind ] ] ]

footerView: FooterModel m -> Html Msg
footerView model = footer [ class "footer border" ] 
    [ div [ class "flex five center" ] 
        [ factionToggle astraMilitarum model
        , span [] []
        , factionToggle adeptusCustodes model ] ]

factionToggle: Faction -> FooterModel m -> Html Msg
factionToggle faction model = button 
        [ class (if List.member faction model.factionsToShow 
            then "faction-button toggle-on" 
            else "faction-button toggle-off")
        , onClick (ToggleFaction faction) ] 
        [ img [ class "faction-icon-large", src ("img/" ++ faction.image) ] [] ]

kindButton: String -> Kind -> Maybe Kind -> Html Msg
kindButton name kind currentKind = button 
        [ class (if (compare kind currentKind) 
            then "kind-button toggle-on" 
            else "kind-button toggle-off")
        , onClick (ShowOnlyKind kind) ] 
        [ text name ]

bodyView: BodyModel m -> Html Msg
bodyView model = div [ class "content articles border" ]
    ( model.visibleArticles
        |> List.map articleView )
    

articleView: Article -> Html Msg
articleView model = article [ class "card article" ] 
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
