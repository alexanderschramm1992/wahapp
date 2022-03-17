module Model exposing (..)

type Cost
    = Simple Int
    | Complex Int Int

type Kind
    = Wargear
    | Ability
    | Stratagem 

type alias Faction =
    { name: String
    , image: String }

type alias Header =
    { title: String
    , cost: Maybe Cost
    , kind: Kind
    , faction: Maybe Faction
    , subfaction: Maybe Faction }

type Range 
    = Inches Int
    | Melee

type Dice
    = D3
    | D6

type Amount
    = Static Int
    | Throws Int Dice
    | ThrowsWithModifier Int Dice Int

type WeaponType
    = Assault Int
    | Heavy Int
    | RapidFire Int
    | Grenade Int
    | Pistol Int

type Strength
    = Numerical Int
    | User

type ArmorPenetration = ArmorPenetration Int

type Damage = Damage Amount

type alias Stats =
    { range: Range
    , weaponType: WeaponType
    , strength: Strength
    , armorPenetation: ArmorPenetration
    , damage: Damage 
    , ability: Maybe String }

type Tag = Tag String

type Term = Term String

type Result 
    = Match Int
    | NoMatch 

type Content
    = Text String
    | Table (List (List String))
    | Mixed Content Content

type alias Article = 
    { header: Header
    , content: Content
    , tags: List Tag }

type alias HeaderModel m = { m 
    | searchText: String
    , tags: List Tag }

type alias BodyModel m = { m
    | filteredArticles: List Article }

type alias Model =
  { searchText: String
  , tags: List Tag
  , articles: List Article 
  , filteredArticles: List Article }
