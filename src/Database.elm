module Database exposing (commonTags, state)

import Model exposing (..)

commonTags: List Tag
commonTags = 
  [ Tag "Stratagem"
  , Tag "Ability"
  , Tag "Warlord Trait" ]

astraMilitarum: Maybe Faction
astraMilitarum = Just (Faction "Astra Militarum" "AstraMilitarum.png")

armageddon: Maybe Faction
armageddon = Just (Faction "Armageddon" "Armageddon.png")

krieg: Maybe Faction
krieg = Just (Faction "Krieg" "Krieg.png")

specialistDetachment: Maybe Faction
specialistDetachment = Just (Faction "Specialist Detachment" "SpecialistDetachment.png")

-- Warlord Traits

warlordTraits: List Article
warlordTraits =
  [ { header = 
        { title = "Grand Strategist"
        , cost = Nothing
        , kind = WarlordTrait
        , faction = astraMilitarum
        , subfaction = Nothing }
    , content = Text "Whilst your Warlord is alive, you can re-roll a single hit roll, wound roll or saving throw per battle. In addition, if your army is Battle-forged and this Warlord is on the battlefield, roll a D6 for each Command Point you spend to use a Stratagem; on a 5+ that Command Point is immediately refunded."
    , tags = 
      [ (Tag "Warlord Trait")
      , (Tag "Stratagem") ] }
  , { header = 
        { title = "Old Grudges"
        , cost = Nothing
        , kind = WarlordTrait
        , faction = astraMilitarum
        , subfaction = Nothing }
    , content = Text "After deployment, but before the first battle round begins, choose a unit in your opponent's army. You can re-roll failed wound rolls for ASTRA MILITARUM units from your army that target the unit you chose whilst they are within 6'' of your Warlord."
    , tags = 
      [ (Tag "Warlord Trait")
      , (Tag "Before Battle") ] }
  , { header = 
        { title = "Implacable Determination"
        , cost = Nothing
        , kind = WarlordTrait
        , faction = astraMilitarum
        , subfaction = Nothing }
    , content = Text "When your Warlord and a single friendly unit within 3'' of them Advances, they may both add 6'' to their Move characteristic for that Movement phase instead of rolling a dice."
    , tags = 
      [ (Tag "Warlord Trait")
      , (Tag "Movement Phase")
      , (Tag "Advance") ] }
  , { header = 
        { title = "Draconian Disciplinarian"
        , cost = Nothing
        , kind = WarlordTrait
        , faction = astraMilitarum
        , subfaction = Nothing }
    , content = Text "You can re-roll failed Morale tests for friendly ASTRA MILITARUM INFANTRY units within 6'' of your Warlord in the Morale phase. If a COMMISSAR has this Warlord Trait, then their Summary Execution ability takes precedence, but if the re-rolled Morale test is also failed then D3 additional models are slain and the test is then considered to have passed."
    , tags = 
      [ (Tag "Warlord Trait")
      , (Tag "Morale Phase")
      , (Tag "Commissar") ] }
  , { header = 
        { title = "Bellowing Voice"
        , cost = Nothing
        , kind = WarlordTrait
        , faction = astraMilitarum
        , subfaction = Nothing }
    , content = Text "Add 3'' to the range of any abilities on your Warlord's datasheet (such as Aura of Discipline or Voice of Command)."
    , tags = 
      [ (Tag "Warlord Trait") ] }
  , { header = 
        { title = "Master of Command"
        , cost = Nothing
        , kind = WarlordTrait
        , faction = astraMilitarum
        , subfaction = Nothing }
    , content = Text "Your Warlord gains the Voice of Command ability. If your Warlord already has the Voice of Command or Tank Orders ability, they may instead issue one additional order per turn. If your Warlord is a COMMISSAR, it can issue an order to any <REGIMENT> INFANTRY unit (irrespective of what regiment that unit is from – e.g. MILITARUM TEMPESTUS, CADIAN, etc.)"
    , tags = 
      [ (Tag "Warlord Trait")
      , (Tag "Infantry")
      , (Tag "Vehicle")
      , (Tag "Commissar") ] }
  , { header = 
        { title = "Ex Gang Leader"
        , cost = Nothing
        , kind = WarlordTrait
        , faction = astraMilitarum
        , subfaction = armageddon }
    , content = Text "Add 1 to this Warlord's Attacks characteristic. In addition, add 1 to any wound rolls made for your Warlord in the Fight phase."
    , tags = 
      [ (Tag "Warlord Trait")
      , (Tag "Fight Phase") ] } ]

-- Abilities

abilities: List Article
abilities =
  [ { header = 
        { title = "Grinding Advance"
        , cost = Nothing
        , kind = Ability
        , faction = astraMilitarum
        , subfaction = Nothing }
    , content = Text "If this model Remains Stationary or moves under half speed in its Movement phase (i.e. it moves a distance in inches less than half of its current Move characteristic) it can shoot its turret weapon twice in the following Shooting phase (the turret weapon must target the same unit both times). The following weapons are turret weapons: battle cannon; eradicator nova cannon; exterminator autocannon; vanquisher battle cannon; demolisher cannon; executioner plasma cannon; punisher gatling cannon."
    , tags = 
      [ (Tag "Ability")
      , (Tag "Shooting Phase")
      , (Tag "Movement Phase")
      , (Tag "Vehicle")
      , (Tag "Leman Russ") ] }
  , { header = 
        { title = "Voice of Command"
        , cost = Nothing
        , kind = Ability
        , faction = astraMilitarum
        , subfaction = Nothing }
    , content = Mixed (Text "This unit may issue one order per turn to the soldiers under their command at the start of their Shooting phase. Orders may only be issued to INFANTRY units within 6'' of this unit that have the same <REGIMENT> keyword as this unit. To issue an order, pick a target unit and choose which order you wish to issue from the table below. A unit may only be affected by one order per turn. Each time a <REGIMENT> unit with the Voice of Command ability issues one of the following orders to a <REGIMENT> INFANTRY unit, that same order can be issued to one or more other friendly <REGIMENT> INFANTRY units (excluding OFFICER units) that are within 6'' of the unit that order was originally issued to: Take Aim!; First Rank, Fire! Second Rank, Fire!; Bring it Down!; Forwards, for the Emperor!; Get Back in the Fight!; Fix Bayonets!") (Table 
      [ [ "Order", "Effect" ]
      , [ "Take Aim!", "Re-roll hit rolls of 1 for all the models in the ordered unit until the end of the phase." ]
      , [ "First Rank, Fire! Second Rank, Fire!", "All lasguns and all hot-shot lasguns in the ordered unit change their Type to Rapid Fire 2 until the end of the phase." ]
      , [ "Bring it Down!", "Re-roll wound rolls of 1 for all the models in the ordered unit until the end of the phase" ]
      , [ "Forwards, for the Emperor!", "The ordered unit can shoot this phase even if it Advanced in its Movement phase." ]
      , [ "Get back in the Fight!", "The ordered unit can shoot this phase even if it Fell Back in its Movement phase." ]
      , [ "Move! Move! Move!", "Instead of shooting this phase the ordered unit immediately moves as if it were the Movement phase. It must Advance as part of this move, and cannot declare a charge during this turn." ]
      , [ "Fix Bayonets!", "This order can only be issued to units that are within 1'' of an enemy unit. The ordered unit immediately fights as if it were the Fight phase." ] ])
    , tags = 
      [ (Tag "Ability")
      , (Tag "Shooting Phase")
      , (Tag "Officer")
      , (Tag "Infantry") ] }
  , { header = 
        { title = "Refractor Field"
        , cost = Nothing
        , kind = Ability
        , faction = astraMilitarum
        , subfaction = Nothing }
    , content = Text "This model has a 5+ invulnerable save."
    , tags = 
      [ (Tag "Ability")
      , (Tag "Invulnerable Save") ] }
  , { header = 
        { title = "Senior Officer"
        , cost = Nothing
        , kind = Ability
        , faction = astraMilitarum
        , subfaction = Nothing }
    , content = Text "This model may use the Voice of Command ability twice in each of your turns. Resolve the effects of the first order before issuing the second order."
    , tags = 
      [ (Tag "Ability")
      , (Tag "Shooting Phase")
      , (Tag "Officer") ] }
  , { header = 
        { title = "Aura of Discipline"
        , cost = Nothing
        , kind = Ability
        , faction = astraMilitarum
        , subfaction = Nothing }
    , content = Text "ASTRA MILITARUM units within 6'' of a friendly COMMISSAR can use the Commissar's Leadership instead of their own."
    , tags = 
      [ (Tag "Ability")
      , (Tag "Morale Phase")
      , (Tag "Officer")
      , (Tag "Leadership") ] }
  , { header = 
        { title = "Summary Execution"
        , cost = Nothing
        , kind = Ability
        , faction = astraMilitarum
        , subfaction = Nothing }
    , content = Text "The first time an ASTRA MILITARUM unit fails a Morale test during the Morale phase whilst it is within 6'' of any friendly COMMISSARS, you can execute a model. If you do, one model of your choice in that unit is slain and the Morale test is re-rolled (do not include this slain model when re-rolling the Morale test)."
    , tags = 
      [ (Tag "Ability")
      , (Tag "Morale Phase")
      , (Tag "Commissar") ] }
  , { header = 
        { title = "It's for your own Good"
        , cost = Nothing
        , kind = Ability
        , faction = astraMilitarum
        , subfaction = Nothing }
    , content = Text "If Aradia Madellan is slain as a result of Perils of the Warp whilst within 6'' of a friendly COMMISSAR, she is executed before anything untoward can happen - the power she was attempting still fails, but units within 6'' of her do not suffer D3 mortal wounds as normal."
    , tags = 
      [ (Tag "Ability")
      , (Tag "Psychic Phase")
      , (Tag "Perils of the Warp")
      , (Tag "Commissar") ] }
  , { header = 
        { title = "Smite"
        , cost = Nothing
        , kind = Ability
        , faction = Nothing
        , subfaction = Nothing }
    , content = Text "Smite has a warp charge value of 5. Add 1 to the warp charge value of this psychic power for each other attempt that has been made to manifest this power by a unit from your army in this phase, whether that attempt was successful or not. If manifested, the closest enemy unit within 18'' of and visible to the psyker suffers D3 mortal wounds. If the result of the Psychic test was 11 or more, that unit suffers D6 mortal wounds instead."
    , tags = 
      [ (Tag "Ability")
      , (Tag "Psychic Phase")
      , (Tag "Mortal Wound") ] }
  , { header = 
        { title = "Deny the Witch"
        , cost = Nothing
        , kind = Ability
        , faction = Nothing
        , subfaction = Nothing }
    , content = Text "When a PSYKER unit attempts to deny a psychic power, you must take a Deny the Witch test for that unit by rolling 2D6. If the total is greater than the result of the Psychic test, the Deny the Witch test is passed and the psychic power is denied. Only one attempt can be made to deny a psychic power. If a PSYKER unit can attempt to deny more than one psychic power in a psychic phase, this will be listed on its datasheet."
    , tags = 
      [ (Tag "Ability")
      , (Tag "Psychic Phase") ] }
  , { header = 
        { title = "Psychic Augment"
        , cost = Nothing
        , kind = Ability
        , faction = astraMilitarum
        , subfaction = Nothing }
    , content = Text "Psychic Augment has a warp charge value of 8. If manifested, select a friendly ASTRA MILITARUM INFANTRY unit within 12'' of the psyker. Add 1 to hit rolls for attacks made by that unit until the start of your next psychic phase."
    , tags = 
      [ (Tag "Ability")
      , (Tag "Psychic Phase")
      , (Tag "Infantry") ] }
  , { header = 
        { title = "Explodes"
        , cost = Nothing
        , kind = Ability
        , faction = Nothing
        , subfaction = Nothing }
    , content = Text "If this model is reduced to 0 wounds, roll a D6 before removing it from the battlefield. On a 6 it explodes, and each unit within 6'' suffers D3 mortal wounds."
    , tags = 
      [ (Tag "Ability")
      , (Tag "Vehicle")
      , (Tag "Mortal Wound") ] }
  , { header = 
        { title = "Smoke Launchers"
        , cost = Nothing
        , kind = Ability
        , faction = Nothing
        , subfaction = Nothing }
    , content = Text "Once per battle, instead of shooting in your Shooting phase, this model can use its smoke launchers. Until the start of your next Shooting phase, when resolving an attack made with a ranged weapon against this model, subtract 1 from the hit roll."
    , tags = 
      [ (Tag "Ability")
      , (Tag "Vehicle")
      , (Tag "Shooting Phase") ] }
  , { header = 
        { title = "Emergency Plasma Vents"
        , cost = Nothing
        , kind = Ability
        , faction = Nothing
        , subfaction = Nothing }
    , content = Text "If this model fires a supercharged plasma cannon, and you roll one or more hit rolls of 1, it is not automatically destroyed. Instead, for each hit roll of 1, the bearer suffers 1 mortal wound after all of this weapon's shots have been resolved."
    , tags = 
      [ (Tag "Ability")
      , (Tag "Vehicle")
      , (Tag "Mortal Wound")
      , (Tag "Shooting Phase")
      , (Tag "Plasma") ] }
  , { header = 
        { title = "Tank Orders"
        , cost = Nothing
        , kind = Ability
        , faction = astraMilitarum
        , subfaction = Nothing }
    , content = Mixed (Text "This model can issue one order each turn to a friendly <REGIMENT> VEHICLE unit (excluding TITANIC units) at the start of your Shooting phase. To issue a tank order, pick a target <REGIMENT> VEHICLE unit within 6'' of this model and choose which order you wish to issue from the table below. Each <REGIMENT> VEHICLE unit can only be given a single order each turn.") (Table 
      [ [ "Order", "Effect" ]
      , [ "Full Throttle!", "Instead of shooting this phase the ordered model immediately moves as if it were the Movement phase. It must Advance as part of this move, and cannot declare a charge during this turn." ]
      , [ "Gunners, Kill on Sight!", "Re-roll hit rolls of 1 for the ordered model until the end of the phase." ]
      , [ "Strike and Shroud!", "This order can only be issued to a model that has not yet used its smoke launchers during the battle. The ordered model can shoot its weapons and launch its smoke launchers during this phase." ] ])
    , tags = 
      [ (Tag "Ability")
      , (Tag "Vehicle")
      , (Tag "Shooting Phase") ] }
  , { header = 
        { title = "Brute Shield"
        , cost = Nothing
        , kind = Ability
        , faction = astraMilitarum
        , subfaction = Nothing }
    , content = Text "Models equipped with a brute shield have a 4+ invulnerable save."
    , tags = 
      [ (Tag "Ability")
      , (Tag "Invulnerable Save") ] }
  , { header = 
        { title = "Avalanche of Muscle"
        , cost = Nothing
        , kind = Ability
        , faction = astraMilitarum
        , subfaction = Nothing }
    , content = Text "You can add 1 to the Attacks characteristic of this unit in the Fight phase on any turn in which it made a successful charge. This ability may only be used the first time this unit fights each turn."
    , tags = 
      [ (Tag "Ability")
      , (Tag "Fight Phase")
      , (Tag "Charge Phase") ] }
  , { header = 
        { title = "Leading from the Front"
        , cost = Nothing
        , kind = Ability
        , faction = astraMilitarum
        , subfaction = Nothing }
    , content = Text "Friendly ASTRA MILITARUM units within 6'' of this model automatically pass Morale tests whilst this model is within 1'' of an enemy model."
    , tags = 
      [ (Tag "Ability")
      , (Tag "Morale Phase") ] }
  , { header = 
        { title = "Vehicle Squadron"
        , cost = Nothing
        , kind = Ability
        , faction = astraMilitarum
        , subfaction = Nothing }
    , content = Text "The first time this unit is set up, all models in this unit must be placed within 6'' of each other. From that point onwards, each operates independently and is treated as a separate unit for all rules purposes."
    , tags = 
      [ (Tag "Ability")
      , (Tag "Before Battle") ] }
  , { header = 
        { title = "Artillery and Crew"
        , cost = Nothing
        , kind = Ability
        , faction = astraMilitarum
        , subfaction = Nothing }
    , content = Text "Each Heavy Quad Launcher and its crew are treated as a single model for all rules purposes (crew models must remain within 1'' of their Heavy Quad Launcher model). This means that the crew models cannot be targeted or attacked separately and that visibility and all ranges are measured to and from the Heavy Quad Launcher's model, not the crew models. This unit cannot Advance, is never eligible to charge or Heroically Intervene, and cannot make pile-in or consolidation moves."
    , tags = 
      [ (Tag "Ability") ] }
  , { header = 
        { title = "Augmented Mount"
        , cost = Nothing
        , kind = Ability
        , faction = astraMilitarum
        , subfaction = krieg }
    , content = Text "Each time a model in this unit would lose a wound, roll one D6: on a 5+, that wound is not lost."
    , tags = 
      [ (Tag "Ability") ] }
  , { header = 
        { title = "Flanking Manoeuvres"
        , cost = Nothing
        , kind = Ability
        , faction = astraMilitarum
        , subfaction = krieg }
    , content = Text "During deployment, you can set this unit up behind enemy lines instead of setting them up on the battlefield. If you do, then in the Reinforcements step of one of your Movement phases you can set up all of these units wholly within 6'' of the same battlefield edge and more than 9'' away from any enemy models."
    , tags = 
      [ (Tag "Ability")
      , (Tag "Before Battle")
      , (Tag "Movement Phase") ] } ]

-- Stratagems

stratagems: List Article
stratagems =
  [ { header = 
        { title = "Fire on my Position"
        , cost = Just (Simple 3)
        , kind = Stratagem
        , faction = astraMilitarum
        , subfaction = Nothing }
    , content = Text "Use this Stratagem when the last model is slain from an ASTRA MILITARUM unit from your army equipped with a vox-caster. Before removing the model, roll a D6 for each unit within 3'' of it. On a 4+ that unit suffers D3 mortal wounds."
    , tags = 
      [ (Tag "Stratagem")
      , (Tag "Vox Caster")
      , (Tag "Infantry")
      , (Tag "Mortal Wound") ] }
  , { header = 
      { title = "Crush Them!"
      , cost = Just (Simple 1)
      , kind = Stratagem
      , faction = astraMilitarum
      , subfaction = Nothing }
    , content = Text "Use this Stratagem at the start of your Charge phase. Select an ASTRA MILITARUM VEHICLE unit from your army. This unit can charge even if it Advanced this turn. In the following Fight phase, attacks made by this unit hit on a 2+."
    , tags = 
      [ (Tag "Stratagem")
      , (Tag "Charge Phase")
      , (Tag "Overwatch")
      , (Tag "Vehicle")
      , (Tag "Advance") ] }
  , { header = 
      { title = "Jury Rigging"
      , cost = Just (Simple 1)
      , kind = Stratagem
      , faction = astraMilitarum
      , subfaction = Nothing }
    , content = Text "Use this Stratagem at the start of your turn. Select an ASTRA MILITARUM VEHICLE from your army. It cannot move, charge or pile in this turn, but immediately heals 1 wound. You can only use this Stratagem once per turn."
    , tags = 
      [ (Tag "Stratagem")
      , (Tag "Command Phase")
      , (Tag "Heal")
      , (Tag "Vehicle") ] }
  , { header = 
      { title = "Consolidate Squads"
      , cost = Just (Simple 1)
      , kind = Stratagem
      , faction = astraMilitarum
      , subfaction = Nothing }
    , content = Text "Use this Stratagem at the end of your Movement phase. Choose an Infantry Squad from your army that is within 2'' of another of your Infantry Squads from the same <REGIMENT>. You can merge these squads into a single unit and they are treated as such for the rest of the battle."
    , tags = 
      [ (Tag "Stratagem")
      , (Tag "Movement Phase")
      , (Tag "Infantry") ] }
  , { header = 
      { title = "Imperial Commander's Armoury"
      , cost = Just (Complex 1 3)
      , kind = Stratagem
      , faction = astraMilitarum
      , subfaction = Nothing }
    , content = Text "Use this Stratagem before the battle. Your army can have one extra relic from the Heirlooms of Conquest for 1 CP, or two extra relics for 3 CPs. All of the relics that you include must be different and be given to different ASTRA MILITARUM CHARACTERS. You can only use this Stratagem once per battle."
    , tags = 
      [ (Tag "Stratagem")
      , (Tag "Before Battle")
      , (Tag "Relic")
      , (Tag "Character") ] }
  , { header = 
      { title = "Officio Prefectus Command Tank"
      , cost = Just (Simple 2)
      , kind = Stratagem
      , faction = astraMilitarum
      , subfaction = Nothing }
    , content = Text "Use this Stratagem at the start of the first battle round, before the first turn begins. Select a LEMAN RUSS from your army. All friendly ASTRA MILITARUM units have a Leadership characteristic of 9 (unless it would otherwise be higher) whilst they are within 6'' of this vehicle."
    , tags = 
      [ (Tag "Stratagem")
      , (Tag "Before Battle")
      , (Tag "Leadership")
      , (Tag "Leman Russ") ] }
  , { header = 
      { title = "Mobile Command Vehicle"
      , cost = Just (Simple 1)
      , kind = Stratagem
      , faction = astraMilitarum
      , subfaction = Nothing }
    , content = Text "Use this Stratagem at the start of any turn. Choose a Chimera from your army. Until the end of the turn, an OFFICER from your army with the Voice of Command ability may still issue orders whilst embarked within that Chimera (measuring ranges from any point on the vehicle), and is treated as being within 3'' of a vox-caster."
    , tags = 
      [ (Tag "Stratagem")
      , (Tag "Before Battle") ] }
  , { header = 
      { title = "Preliminary Bombardment"
      , cost = Just (Simple 2)
      , kind = Stratagem
      , faction = astraMilitarum
      , subfaction = Nothing }
    , content = Text "Use this Stratagem after both sides have deployed, but before the first battle round begins. Roll a dice for each enemy unit on the battlefield. On a 6, that unit suffers 1 mortal wound. You can only use this Stratagem once per battle."
    , tags = 
      [ (Tag "Stratagem")
      , (Tag "Command Phase")
      , (Tag "Officer")
      , (Tag "Chimera")
      , (Tag "Vox Caster") ] }
  , { header = 
      { title = "Inspired Tactics"
      , cost = Just (Simple 1)
      , kind = Stratagem
      , faction = astraMilitarum
      , subfaction = Nothing }
    , content = Text "Use this Stratagem after an OFFICER from your army has issued an order or tank order. That officer may immediately issue an additional order."
    , tags = 
      [ (Tag "Stratagem")
      , (Tag "Order") ] }
  , { header = 
      { title = "Defensive Gunners"
      , cost = Just (Simple 1)
      , kind = Stratagem
      , faction = astraMilitarum
      , subfaction = Nothing }
    , content = Text "Use this Stratagem when a charge is declared against one of your ASTRA MILITARUM VEHICLE units. When that unit fires Overwatch this phase, they successfully hit on a roll of 5 or 6, instead of only 6."
    , tags = 
      [ (Tag "Stratagem")
      , (Tag "Charge Phase")
      , (Tag "Vehicle")
      , (Tag "Overwatch") ] }
  , { header = 
        { title = "Take Cover!"
        , cost = Just (Simple 1)
        , kind = Stratagem
        , faction = astraMilitarum
        , subfaction = Nothing }
    , content = Text "Use this Stratagem in your opponent's Shooting phase when your opponent selects one of your ASTRA MILITARUM INFANTRY units as a target. You can add 1 to armour saving throws you make for this unit until the end of the phase."
    , tags = 
      [ (Tag "Stratagem")
      , (Tag "Shooting Phase")
      , (Tag "Infantry")
      , (Tag "Saving Throw") ] }
  , { header = 
      { title = "Grenadiers"
      , cost = Just (Simple 1)
      , kind = Stratagem
      , faction = astraMilitarum
      , subfaction = Nothing }
    , content = Text "Use this Stratagem before an ASTRA MILITARUM INFANTRY unit from your army shoots or fires Overwatch. Up to ten models in the unit that are armed with grenades can throw a grenade this phase, instead of only one model being able to do so."
    , tags = 
      [ (Tag "Stratagem")
      , (Tag "Charge Phase")
      , (Tag "Overwatch")
      , (Tag "Infantry")
      , (Tag "Grenade") ] }
  , { header = 
      { title = "Fight to the Deatch"
      , cost = Just (Simple 1)
      , kind = Stratagem
      , faction = astraMilitarum
      , subfaction = Nothing }
    , content = Text "Use this Stratagem at the start of the Morale phase. Pick an ASTRA MILITARUM INFANTRY unit from your army that is required to take a Morale test. You can roll a D3 for the unit, rather than a D6, when taking this test."
    , tags = 
      [ (Tag "Stratagem")
      , (Tag "Morale Phase")
      , (Tag "Infantry") ] }
  , { header = 
      { title = "Armoured Fist"
      , cost = Just (Simple 1)
      , kind = Stratagem
      , faction = astraMilitarum
      , subfaction = armageddon }
    , content = Text "Use this Stratagem at the start of your Shooting phase. Select an ARMAGEDDON INFANTRY unit from your army that disembarked from an ARMAGEDDON TRANSPORT VEHICLE this turn. You can re-roll hit rolls of 1 for that unit until the end of the phase."
    , tags = 
      [ (Tag "Stratagem")
      , (Tag "Shooting Phase")
      , (Tag "Chimera")
      , (Tag "Infantry") ] }
  , { header = 
      { title = "Relentless"
      , cost = Just (Simple 1)
      , kind = Stratagem
      , faction = astraMilitarum
      , subfaction = Nothing }
    , content = Text "Use this Stratagem at the start of your turn. Select one VEHICLE model (except a TITANIC model) that has a damage table on its datasheet. Until the end of that turn, that model uses the top row of its damage table, regardless of how many wounds it has lost."
    , tags = 
      [ (Tag "Stratagem")
      , (Tag "Command Phase")
      , (Tag "Vehicle") ] }
  , { header = 
      { title = "Expirienced Eye"
      , cost = Just (Simple 1)
      , kind = Stratagem
      , faction = astraMilitarum
      , subfaction = Nothing }
    , content = Text "Use this Stratagem in your Shooting phase, when an ASTRA MILITARUM VETERANS unit from your army is chosen to shoot with. Until the end of that phase, when resolving an attack made with a weapon by a model in that unit, improve the Armour Penetration characteristic of that weapon by 1 for that attack (e.g. AP 0 becomes AP -1)."
    , tags = 
      [ (Tag "Stratagem")
      , (Tag "Shooting Phase")
      , (Tag "Veterans")
      , (Tag "Armour Penetration") ] }
  , { header = 
      { title = "Spalsh Damage"
      , cost = Just (Simple 1)
      , kind = Stratagem
      , faction = astraMilitarum
      , subfaction = Nothing }
    , content = Text "Use this Stratagem in your Shooting phase, when a HELLHOUND model from your army is chosen to shoot with. Until the end of that phase, when resolving an attack made with a chem cannon, inferno cannon or melta cannon by that model against a unit that is receiving the benefit of cover, you can re-roll the wound roll."
    , tags = 
      [ (Tag "Stratagem")
      , (Tag "Shooting Phase")
      , (Tag "Hellhound")
      , (Tag "Cover") ] }
  , { header = 
      { title = "Concentrated Fire"
      , cost = Just (Simple 1)
      , kind = Stratagem
      , faction = astraMilitarum
      , subfaction = Nothing }
    , content = Text "Use this Stratagem in your Shooting phase, when a HEAVY WEAPONS SQUADunit from your army is chosen to shoot with. Select one enemy unit. Until the end of that phase, attacks made by models in that HEAVY WEAPONS SQUAD unit must target that enemy unit, and when resolving those attacks, add 1 to the hit and wound rolls for any attack made with a weapon from the Heavy Weapons list."
    , tags = 
      [ (Tag "Stratagem")
      , (Tag "Shooting Phase")
      , (Tag "Heavy Weapons Squad") ] }
  , { header = 
      { title = "Shield of Flesh"
      , cost = Just (Simple 1)
      , kind = Stratagem
      , faction = astraMilitarum
      , subfaction = Nothing }
    , content = Text "Use this Stratagem in the Shooting phase, when an INFANTRY unit from your army that is within 3'' of a friendly BULLGRYNS unit is chosen as the target of an attack. Until the end of that phase, when resolving an attack made against that INFANTRY unit, if that BULLGRYNS unit is closer to the attacking model than that INFANTRY unit is, subtract 1 from the hit roll."
    , tags = 
      [ (Tag "Stratagem")
      , (Tag "Shooting Phase")
      , (Tag "Bullgryns")
      , (Tag "Infantry") ] }
  , { header = 
      { title = "Hail of Fire"
      , cost = Just (Simple 2)
      , kind = Stratagem
      , faction = astraMilitarum
      , subfaction = Nothing }
    , content = Text "Use this Stratagem in your Shooting phase, when a LEMAN RUSS model from your army is chosen to shoot with. Until the end of that phase, when resolving an attack made with a weapon by that model against a VEHICLE unit, do not roll to determine the Type characteristic of that weapon; it has the maximum value (e.g. a Heavy D6 weapon makes 6 shots)."
    , tags = 
      [ (Tag "Stratagem")
      , (Tag "Shooting Phase")
      , (Tag "Leman Russ") ] }
  , { header = 
      { title = "Head First"
      , cost = Just (Simple 1)
      , kind = Stratagem
      , faction = astraMilitarum
      , subfaction = Nothing }
    , content = Text "Use this Stratagem in your Charge phase, when a unit from your army is chosen to charge with. Until the end of that phase, if that unit disembarked from a CHIMERA unit this turn, when making a charge roll for that unit, add 2 to the result."
    , tags = 
      [ (Tag "Stratagem")
      , (Tag "Charge Phase")
      , (Tag "Chimera") ] }
  , { header = 
      { title = "Emperor's Blade Assault Company"
      , cost = Just (Simple 1)
      , kind = Stratagem
      , faction = astraMilitarum
      , subfaction = specialistDetachment }
    , content = Text "Use this Stratagem when choosing your army. Pick an ASTRA MILITARUM Detachment from your army to be an Emperor's Blade Specialist Detachment. COMPANY COMMANDERS, PLATOON COMMANDERS, COMMAND SQUADS, SPECIAL WEAPON SQUADS, VETERANS, INFANTRY SQUADS, CHIMERAS and TAUROXES in that Detachment gain the EMPEROR'S BLADE keyword."
    , tags = 
      [ (Tag "Stratagem")
      , (Tag "Before Battle")
      , (Tag "Emperor's Blade")
      , (Tag "Chimera")
      , (Tag "Vehicle")
      , (Tag "Infantry")
      , (Tag "Officer") ] }
  , { header = 
      { title = "Mechanised Fire Support"
      , cost = Just (Simple 1)
      , kind = Stratagem
      , faction = astraMilitarum
      , subfaction = specialistDetachment }
    , content = Text "Use this Stratagem in the enemy Charge phase after an EMPEROR'S BLADE INFANTRY unit from your army is chosen as the target of an enemy unit's charge. Pick an EMPEROR'S BLADE CHIMERA or EMPEROR'S BLADE TAUROX from your army within 6'' of the unit being charged. The vehicle picked can fire Overwatch at the charging unit even if it is not the target of the charge, and when doing so, will hit the enemy on hit rolls of 4+, regardless of modifiers."
    , tags = 
      [ (Tag "Stratagem")
      , (Tag "Charge Phase")
      , (Tag "Emperor's Blade")
      , (Tag "Chimera")
      , (Tag "Infantry")
      , (Tag "Overwatch") ] }
  , { header = 
      { title = "Rapid Redeploy"
      , cost = Just (Simple 1)
      , kind = Stratagem
      , faction = astraMilitarum
      , subfaction = specialistDetachment }
    , content = Text "Use this Stratagem at the end of your Movement phase. An EMPEROR'S BLADE unit embarked within an EMPEROR'S BLADE CHIMERA or EMPEROR'S BLADE TAUROX can disembark. That unit cannot move further in this phase, but can otherwise act normally for the rest of the turn. That unit counts as having moved for any rules purposes, such as shooting Heavy weapons."
    , tags = 
      [ (Tag "Stratagem")
      , (Tag "Movement Phase")
      , (Tag "Emperor's Blade")
      , (Tag "Chimera")
      , (Tag "Infantry") ] }
  , { header = 
      { title = "Command Re-Roll"
      , cost = Just (Simple 1)
      , kind = Stratagem
      , faction = Nothing
      , subfaction = Nothing }
    , content = Text "Use this Stratagem after you have made a hit roll, a wound roll, a damage roll, a saving throw, an Advance roll, a charge roll, a Psychic test, a Deny the Witch test or you have rolled the dice to determine the number of attacks made by a weapon. Re-roll that roll, test or saving throw."
    , tags = 
      [ (Tag "Stratagem") ] }
  , { header = 
      { title = "Cut them down"
      , cost = Just (Simple 1)
      , kind = Stratagem
      , faction = Nothing
      , subfaction = Nothing }
    , content = Text "Use this Stratagem when an enemy unit Falls Back, before any models in that unit are moved. Roll one D6 for each model from your army that is within Engagement Range of that enemy unit; for each result of 6, that enemy unit suffers 1 mortal wound."
    , tags = 
      [ (Tag "Stratagem")
      , (Tag "Movement Phase")
      , (Tag "Fall Back")
      , (Tag "Mortal Wound") ] }
  , { header = 
      { title = "Desperate Breakout"
      , cost = Just (Simple 2)
      , kind = Stratagem
      , faction = Nothing
      , subfaction = Nothing }
    , content = Text "Use this Stratagem in your Movement phase. Select one unit from your army that has not been selected to move this phase and which is in Engagement Range with at least one enemy unit. Roll one D6 for each model in that unit; for each result of 1, one model in that unit of your choice is destroyed. Assuming that unit was not destroyed, it can now attempt to Fall Back, and when doing so its models can be moved across enemy models as if they were not there. Any model in that unit that ends its Fall Back move within Engagement Range of any enemy model is destroyed. Assuming the unit is not destroyed, it cannot do anything else this turn (i.e. it cannot attempt to manifest psychic powers, shoot, declare a charge, be selected to fight etc.), even if it has a rule that would allow it to do so after Falling Back."
    , tags = 
      [ (Tag "Stratagem")
      , (Tag "Movement Phase") ] }
  , { header = 
      { title = "Emergency Disembarkation"
      , cost = Just (Simple 1)
      , kind = Stratagem
      , faction = Nothing
      , subfaction = Nothing }
    , content = Text "Use this Stratagem when a TRANSPORT model from your army is destroyed. All units that are embarked within that model can be set up wholly within 6'' of the destroyed model when they disembark instead of the normal 3'' before the model itself is removed from the battlefield. These units are not affected by the destroyed model's Explodes ability (or equivalent) — instead you must roll one D6 for each model you just set up on the battlefield. Instead of one model that disembarked (your choice) being destroyed for each roll of 1, one model that disembarked (your choice) is destroyed for each roll of 1 or 2. Units cannot declare a charge or perform a Heroic Intervention in the same turn that they disembarked from a destroyed TRANSPORT model."
    , tags = 
      [ (Tag "Stratagem")
      , (Tag "Transport") ] }
  , { header = 
      { title = "Fire Overwatch"
      , cost = Just (Simple 1)
      , kind = Stratagem
      , faction = Nothing
      , subfaction = Nothing }
    , content = Text "Use this Stratagem after an enemy unit has declared a charge against one or more units from your army. One of the units that was chosen as the target of that charge can fire Overwatch before the charge roll is made."
    , tags = 
      [ (Tag "Stratagem")
      , (Tag "Charge Phase")
      , (Tag "Overwatch") ] }
  , { header = 
      { title = "Counter Offensive"
      , cost = Just (Simple 2)
      , kind = Stratagem
      , faction = Nothing
      , subfaction = Nothing }
    , content = Text "Use this Stratagem after an enemy unit has fought in this turn. Select one of your own eligible units and fight with it next."
    , tags = 
      [ (Tag "Stratagem")
      , (Tag "Fight Phase") ] }
  , { header = 
      { title = "Insane Bravery"
      , cost = Just (Simple 2)
      , kind = Stratagem
      , faction = Nothing
      , subfaction = Nothing }
    , content = Text "Use this Stratagem before you take a Morale test for a unit in your army. That test is automatically passed (do not roll any dice). You can only use this Stratagem once per battle."
    , tags = 
      [ (Tag "Stratagem")
      , (Tag "Morale Phase") ] } ]

state: List Article
state = stratagems ++ abilities ++ warlordTraits
