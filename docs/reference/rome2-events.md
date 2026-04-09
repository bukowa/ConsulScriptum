# Rome II Event Reference

The following events are available for Rome II in Consul Scriptum. This list is consolidated from game dumps and documentation.

## Table of Contents

- [AdviceDismissed](#advicedismissed)
- [AdviceFinishedTrigger](#advicefinishedtrigger)
- [AdviceIssued](#adviceissued)
- [AdviceSuperseded](#advicesuperseded)
- [AreaCameraEntered](#areacameraentered)
- [AreaCameraExited](#areacameraexited)
- [AreaEntered](#areaentered)
- [AreaExited](#areaexited)
- [ArmyBribeAttemptFailure](#armybribeattemptfailure)
- [ArmySabotageAttemptFailure](#armysabotageattemptfailure)
- [ArmySabotageAttemptSuccess](#armysabotageattemptsuccess)
- [AssassinationAttemptCriticalSuccess](#assassinationattemptcriticalsuccess)
- [AssassinationAttemptFailure](#assassinationattemptfailure)
- [AssassinationAttemptSuccess](#assassinationattemptsuccess)
- [BattleBoardingActionCommenced](#battleboardingactioncommenced)
- [BattleBoardingShip](#battleboardingship)
- [BattleCommandingShipRouts](#battlecommandingshiprouts)
- [BattleCommandingUnitRouts](#battlecommandingunitrouts)
- [BattleCompleted](#battlecompleted)
- [BattleConflictPhaseCommenced](#battleconflictphasecommenced)
- [BattleDeploymentPhaseCommenced](#battledeploymentphasecommenced)
- [BattleFortPlazaCaptureCommenced](#battlefortplazacapturecommenced)
- [BattleShipAttacksEnemyShip](#battleshipattacksenemyship)
- [BattleShipCaughtFire](#battleshipcaughtfire)
- [BattleShipMagazineExplosion](#battleshipmagazineexplosion)
- [BattleShipRouts](#battleshiprouts)
- [BattleShipRunAground](#battleshiprunaground)
- [BattleShipSailingIntoWind](#battleshipsailingintowind)
- [BattleShipSurrendered](#battleshipsurrendered)
- [BattleUnitAttacksBuilding](#battleunitattacksbuilding)
- [BattleUnitAttacksEnemyUnit](#battleunitattacksenemyunit)
- [BattleUnitAttacksWalls](#battleunitattackswalls)
- [BattleUnitCapturesBuilding](#battleunitcapturesbuilding)
- [BattleUnitDestroysBuilding](#battleunitdestroysbuilding)
- [BattleUnitRouts](#battleunitrouts)
- [BattleUnitUsingBuilding](#battleunitusingbuilding)
- [BattleUnitUsingWall](#battleunitusingwall)
- [BuildingCardSelected](#buildingcardselected)
- [BuildingCompleted](#buildingcompleted)
- [BuildingConstructionIssuedByPlayer](#buildingconstructionissuedbyplayer)
- [BuildingInfoPanelOpenedCampaign](#buildinginfopanelopenedcampaign)
- [CameraMoverCancelled](#cameramovercancelled)
- [CameraMoverFinished](#cameramoverfinished)
- [CampaignArmiesMerge](#campaignarmiesmerge)
- [CampaignBuildingDamaged](#campaignbuildingdamaged)
- [CampaignCoastalAssaultOnCharacter](#campaigncoastalassaultoncharacter)
- [CampaignCoastalAssaultOnGarrison](#campaigncoastalassaultongarrison)
- [CampaignEffectsBundleAwarded](#campaigneffectsbundleawarded)
- [CampaignSettlementAttacked](#campaignsettlementattacked)
- [CharacterAttacksAlly](#characterattacksally)
- [CharacterBecomesFactionLeader](#characterbecomesfactionleader)
- [CharacterBesiegesSettlement](#characterbesiegessettlement)
- [CharacterBlockadedPort](#characterblockadedport)
- [CharacterBrokePortBlockade](#characterbrokeportblockade)
- [CharacterBuildingCompleted](#characterbuildingcompleted)
- [CharacterCanLiberate](#charactercanliberate)
- [CharacterCandidateBecomesMinister](#charactercandidatebecomesminister)
- [CharacterCharacterTargetAction](#charactercharactertargetaction)
- [CharacterComesOfAge](#charactercomesofage)
- [CharacterCompletedBattle](#charactercompletedbattle)
- [CharacterCreated](#charactercreated)
- [CharacterDamagedByDisaster](#characterdamagedbydisaster)
- [CharacterDeselected](#characterdeselected)
- [CharacterDiscovered](#characterdiscovered)
- [CharacterDisembarksNavy](#characterdisembarksnavy)
- [CharacterEmbarksNavy](#characterembarksnavy)
- [CharacterEntersAttritionalArea](#characterentersattritionalarea)
- [CharacterEntersGarrison](#characterentersgarrison)
- [CharacterFactionCompletesResearch](#characterfactioncompletesresearch)
- [CharacterFamilyRelationDied](#characterfamilyrelationdied)
- [CharacterGarrisonTargetAction](#charactergarrisontargetaction)
- [CharacterGeneralDiedInBattle](#charactergeneraldiedinbattle)
- [CharacterInfoPanelOpened](#characterinfopanelopened)
- [CharacterLeavesGarrison](#characterleavesgarrison)
- [CharacterLootedSettlement](#characterlootedsettlement)
- [CharacterMarriage](#charactermarriage)
- [CharacterMilitaryForceTraditionPointAllocated](#charactermilitaryforcetraditionpointallocated)
- [CharacterParticipatedAsSecondaryGeneralInBattle](#characterparticipatedassecondarygeneralinbattle)
- [CharacterPerformsActionAgainstFriendlyTarget](#characterperformsactionagainstfriendlytarget)
- [CharacterPoliticalAction](#characterpoliticalaction)
- [CharacterPoliticalActionPoliticalMariage](#characterpoliticalactionpoliticalmariage)
- [CharacterPoliticalAdoption](#characterpoliticaladoption)
- [CharacterPoliticalAssassination](#characterpoliticalassassination)
- [CharacterPoliticalBribe](#characterpoliticalbribe)
- [CharacterPoliticalDivorce](#characterpoliticaldivorce)
- [CharacterPoliticalEmbezzleFunds](#characterpoliticalembezzlefunds)
- [CharacterPoliticalEntice](#characterpoliticalentice)
- [CharacterPoliticalFlirt](#characterpoliticalflirt)
- [CharacterPoliticalGatherSupport](#characterpoliticalgathersupport)
- [CharacterPoliticalInsult](#characterpoliticalinsult)
- [CharacterPoliticalOrganizeGames](#characterpoliticalorganizegames)
- [CharacterPoliticalPartyProvoke](#characterpoliticalpartyprovoke)
- [CharacterPoliticalPartyPurge](#characterpoliticalpartypurge)
- [CharacterPoliticalPartySecureLoyalty](#characterpoliticalpartysecureloyalty)
- [CharacterPoliticalPraise](#characterpoliticalpraise)
- [CharacterPoliticalPromotion](#characterpoliticalpromotion)
- [CharacterPoliticalProvoke](#characterpoliticalprovoke)
- [CharacterPoliticalRumours](#characterpoliticalrumours)
- [CharacterPoliticalSecureLoyalty](#characterpoliticalsecureloyalty)
- [CharacterPoliticalSendDiplomat](#characterpoliticalsenddiplomat)
- [CharacterPoliticalSendEmissary](#characterpoliticalsendemissary)
- [CharacterPoliticalSendGift](#characterpoliticalsendgift)
- [CharacterPoliticalSuicide](#characterpoliticalsuicide)
- [CharacterPostBattleEnslave](#characterpostbattleenslave)
- [CharacterPostBattleRelease](#characterpostbattlerelease)
- [CharacterPostBattleSlaughter](#characterpostbattleslaughter)
- [CharacterPromoted](#characterpromoted)
- [CharacterRankUp](#characterrankup)
- [CharacterRankUpNeedsAncillary](#characterrankupneedsancillary)
- [CharacterRelativeKilled](#characterrelativekilled)
- [CharacterSelected](#characterselected)
- [CharacterSettlementBesieged](#charactersettlementbesieged)
- [CharacterSettlementBlockaded](#charactersettlementblockaded)
- [CharacterSkillPointAllocated](#characterskillpointallocated)
- [CharacterSuccessfulArmyBribe](#charactersuccessfularmybribe)
- [CharacterSuccessfulConvert](#charactersuccessfulconvert)
- [CharacterSuccessfulDemoralise](#charactersuccessfuldemoralise)
- [CharacterSuccessfulInciteRevolt](#charactersuccessfulinciterevolt)
- [CharacterSurvivesAssassinationAttempt](#charactersurvivesassassinationattempt)
- [CharacterTurnEnd](#characterturnend)
- [CharacterTurnStart](#characterturnstart)
- [CharacterTurnStartCarthage](#characterturnstartcarthage)
- [CharacterTurnStartRome](#characterturnstartrome)
- [CharacterWoundedInAssassinationAttempt](#characterwoundedinassassinationattempt)
- [ClanBecomesVassal](#clanbecomesvassal)
- [ComponentCreated](#componentcreated)
- [ComponentLClickUp](#componentlclickup)
- [ComponentMouseOn](#componentmouseon)
- [ComponentMoved](#componentmoved)
- [ConvertAttemptFailure](#convertattemptfailure)
- [CustomMission](#custommission)
- [DemoraliseAttemptFailure](#demoraliseattemptfailure)
- [DuelDemanded](#dueldemanded)
- [DummyEvent](#dummyevent)
- [EncylopediaEntryRequested](#encylopediaentryrequested)
- [EventMessageOpenedBattle](#eventmessageopenedbattle)
- [EventMessageOpenedCampaign](#eventmessageopenedcampaign)
- [FactionAboutToEndTurn](#factionabouttoendturn)
- [FactionBattleDefeat](#factionbattledefeat)
- [FactionBattleVictory](#factionbattlevictory)
- [FactionBecomesLiberationProtectorate](#factionbecomesliberationprotectorate)
- [FactionBecomesLiberationVassal](#factionbecomesliberationvassal)
- [FactionBecomesShogun](#factionbecomesshogun)
- [FactionBecomesWorldLeader](#factionbecomesworldleader)
- [FactionBeginTurnPhaseNormal](#factionbeginturnphasenormal)
- [FactionCapturesKyoto](#factioncaptureskyoto)
- [FactionCapturesWorldCapital](#factioncapturesworldcapital)
- [FactionCivilWarEnd](#factioncivilwarend)
- [FactionEncountersOtherFaction](#factionencountersotherfaction)
- [FactionFameLevelUp](#factionfamelevelup)
- [FactionGovernmentTypeChanged](#factiongovernmenttypechanged)
- [FactionLeaderDeclaresWar](#factionleaderdeclareswar)
- [FactionLeaderIssuesEdict](#factionleaderissuesedict)
- [FactionLeaderSignsPeaceTreaty](#factionleadersignspeacetreaty)
- [FactionPoliticsGovernmentActionTriggered](#factionpoliticsgovernmentactiontriggered)
- [FactionPoliticsGovernmentTypeChanged](#factionpoliticsgovernmenttypechanged)
- [FactionRoundStart](#factionroundstart)
- [FactionSecessionEnd](#factionsecessionend)
- [FactionSubjugatesOtherFaction](#factionsubjugatesotherfaction)
- [FactionTurnEnd](#factionturnend)
- [FactionTurnStart](#factionturnstart)
- [FirstTickAfterNewCampaignStarted](#firsttickafternewcampaignstarted)
- [FirstTickAfterWorldCreated](#firsttickafterworldcreated)
- [ForceAdoptsStance](#forceadoptsstance)
- [FortSelected](#fortselected)
- [FrontendScreenTransition](#frontendscreentransition)
- [GarrisonAttackedEvent](#garrisonattackedevent)
- [GarrisonOccupiedEvent](#garrisonoccupiedevent)
- [GarrisonResidenceCaptured](#garrisonresidencecaptured)
- [GovernorshipTaxRateChanged](#governorshiptaxratechanged)
- [HistoricBattleEvent](#historicbattleevent)
- [HistoricalCharacters](#historicalcharacters)
- [HistoricalEvents](#historicalevents)
- [HudRefresh](#hudrefresh)
- [InciteRevoltAttemptFailure](#inciterevoltattemptfailure)
- [IncomingMessage](#incomingmessage)
- [LandTradeRouteRaided](#landtraderouteraided)
- [LoadingGame](#loadinggame)
- [LoadingScreenDismissed](#loadingscreendismissed)
- [LocationEntered](#locationentered)
- [LocationUnveiled](#locationunveiled)
- [MPLobbyChatCreated](#mplobbychatcreated)
- [MapIconMoved](#mapiconmoved)
- [MissionCancelled](#missioncancelled)
- [MissionCheckAssassination](#missioncheckassassination)
- [MissionCheckBlockadePort](#missioncheckblockadeport)
- [MissionCheckBuild](#missioncheckbuild)
- [MissionCheckCaptureCity](#missioncheckcapturecity)
- [MissionCheckDuel](#missioncheckduel)
- [MissionCheckEngageCharacter](#missioncheckengagecharacter)
- [MissionCheckEngageFaction](#missioncheckengagefaction)
- [MissionCheckGainMilitaryAccess](#missioncheckgainmilitaryaccess)
- [MissionCheckMakeAlliance](#missioncheckmakealliance)
- [MissionCheckMakeTradeAgreement](#missioncheckmaketradeagreement)
- [MissionCheckRecruit](#missioncheckrecruit)
- [MissionCheckResearch](#missioncheckresearch)
- [MissionCheckSpyOnCity](#missioncheckspyoncity)
- [MissionEvaluateAssassination](#missionevaluateassassination)
- [MissionEvaluateBlockadePort](#missionevaluateblockadeport)
- [MissionEvaluateBuild](#missionevaluatebuild)
- [MissionEvaluateCaptureCity](#missionevaluatecapturecity)
- [MissionEvaluateDuel](#missionevaluateduel)
- [MissionEvaluateEngageCharacter](#missionevaluateengagecharacter)
- [MissionEvaluateEngageFaction](#missionevaluateengagefaction)
- [MissionEvaluateGainMilitaryAccess](#missionevaluategainmilitaryaccess)
- [MissionEvaluateMakeAlliance](#missionevaluatemakealliance)
- [MissionEvaluateMakeTradeAgreement](#missionevaluatemaketradeagreement)
- [MissionEvaluateRecruit](#missionevaluaterecruit)
- [MissionEvaluateResearch](#missionevaluateresearch)
- [MissionEvaluateSpyOnCity](#missionevaluatespyoncity)
- [MissionFailed](#missionfailed)
- [MissionIssued](#missionissued)
- [MissionNearingExpiry](#missionnearingexpiry)
- [MissionSucceeded](#missionsucceeded)
- [ModelCreated](#modelcreated)
- [MovementPointsExhausted](#movementpointsexhausted)
- [MultiTurnMove](#multiturnmove)
- [NewCampaignStarted](#newcampaignstarted)
- [NewSession](#newsession)
- [PanelAdviceRequestedBattle](#paneladvicerequestedbattle)
- [PanelAdviceRequestedCampaign](#paneladvicerequestedcampaign)
- [PanelClosedBattle](#panelclosedbattle)
- [PanelClosedCampaign](#panelclosedcampaign)
- [PanelOpenedBattle](#panelopenedbattle)
- [PanelOpenedCampaign](#panelopenedcampaign)
- [PendingBankruptcy](#pendingbankruptcy)
- [PendingBattle](#pendingbattle)
- [PositiveDiplomaticEvent](#positivediplomaticevent)
- [PreBattle](#prebattle)
- [RecruitmentItemIssuedByPlayer](#recruitmentitemissuedbyplayer)
- [RegionChangedFaction](#regionchangedfaction)
- [RegionGainedDevlopmentPoint](#regiongaineddevlopmentpoint)
- [RegionIssuesDemands](#regionissuesdemands)
- [RegionRebels](#regionrebels)
- [RegionRiots](#regionriots)
- [RegionSelected](#regionselected)
- [RegionStrikes](#regionstrikes)
- [RegionTurnEnd](#regionturnend)
- [RegionTurnStart](#regionturnstart)
- [ResearchCompleted](#researchcompleted)
- [ResearchStarted](#researchstarted)
- [SabotageAttemptFailure](#sabotageattemptfailure)
- [SabotageAttemptSuccess](#sabotageattemptsuccess)
- [SavingGame](#savinggame)
- [ScriptedAgentCreated](#scriptedagentcreated)
- [ScriptedAgentCreationFailed](#scriptedagentcreationfailed)
- [ScriptedCharacterUnhidden](#scriptedcharacterunhidden)
- [ScriptedCharacterUnhiddenFailed](#scriptedcharacterunhiddenfailed)
- [ScriptedForceCreated](#scriptedforcecreated)
- [SeaTradeRouteRaided](#seatraderouteraided)
- [SettlementDeselected](#settlementdeselected)
- [SettlementOccupied](#settlementoccupied)
- [SettlementSelected](#settlementselected)
- [ShortcutTriggered](#shortcuttriggered)
- [SiegeLifted](#siegelifted)
- [SlotOpens](#slotopens)
- [SlotRoundStart](#slotroundstart)
- [SlotSelected](#slotselected)
- [SlotTurnStart](#slotturnstart)
- [StartRegionPopupVisible](#startregionpopupvisible)
- [StartRegionSelected](#startregionselected)
- [TechnologyInfoPanelOpenedCampaign](#technologyinfopanelopenedcampaign)
- [TestEvent](#testevent)
- [TimeTrigger](#timetrigger)
- [TooltipAdvice](#tooltipadvice)
- [TouchUsed](#touchused)
- [TradeLinkEstablished](#tradelinkestablished)
- [TradeNodeConnected](#tradenodeconnected)
- [TradeRouteEstablished](#traderouteestablished)
- [UICreated](#uicreated)
- [UIDestroyed](#uidestroyed)
- [UngarrisonedFort](#ungarrisonedfort)
- [UnitCompletedBattle](#unitcompletedbattle)
- [UnitCreated](#unitcreated)
- [UnitSelectedCampaign](#unitselectedcampaign)
- [UnitTrained](#unittrained)
- [UnitTurnEnd](#unitturnend)
- [VictoryConditionFailed](#victoryconditionfailed)
- [VictoryConditionMet](#victoryconditionmet)
- [WorldCreated](#worldcreated)
- [historical_events](#historical_events)

---

## AdviceDismissed

*No parameters documented.*

---

## AdviceFinishedTrigger

Notify scripters when current advice has finished playing

**Engine Code:** `ADVICE_FINISHED_EVENT`

**Context Parameters:**

- `Sound`

---

## AdviceIssued

*No parameters documented.*

---

## AdviceSuperseded

*No parameters documented.*

---

## AreaCameraEntered

Fired when the camera enters an area trigger

**Engine Code:** `AREA_TRIGGER_CAMERA_ENTER_EVENT`

**Context Parameters:**

- `UniString trigger name`

---

## AreaCameraExited

Fired when the camera exits an area trigger

**Engine Code:** `AREA_TRIGGER_CAMERA_EXIT_EVENT`

**Context Parameters:**

- `UniString trigger name`

---

## AreaEntered

Fired when a piece enters an area trigger

**Engine Code:** `AREA_TRIGGER_ENTER_EVENT`

**Context Parameters:**

- `UniString trigger name`
- `CHARACTER character who entered`

---

## AreaExited

Fired when a piece exits an area trigger

**Engine Code:** `AREA_TRIGGER_EXIT_EVENT`

**Context Parameters:**

- `UniString trigger name`
- `CHARACTER character who exited`

---

## ArmyBribeAttemptFailure

*No parameters documented.*

---

## ArmySabotageAttemptFailure

*No parameters documented.*

---

## ArmySabotageAttemptSuccess

*No parameters documented.*

---

## AssassinationAttemptCriticalSuccess

*No parameters documented.*

---

## AssassinationAttemptFailure

*No parameters documented.*

---

## AssassinationAttemptSuccess

*No parameters documented.*

---

## BattleBoardingActionCommenced

Fired each time a ship commences the boarding of an enemy vessel

**Engine Code:** `BATTLE_BOARDING_ACTION_COMMENCED`

**Context Parameters:**

- `Battle`

---

## BattleBoardingShip

Gets triggered when the order to board a ship is issued

**Engine Code:** `BATTLE_BOARDING_SHIP`

**Context Parameters:**

- `Battle`

---

## BattleCommandingShipRouts

The ship containing the fleet admiral has just routed

**Engine Code:** `BATTLE_COMMANDING_SHIP_ROUTS`

**Context Parameters:**

- `Naval Battle`

---

## BattleCommandingUnitRouts

Fires off an event for when a unit that has a commanding general attached to it routs

**Engine Code:** `BATTLE_COMMANDING_UNIT_ROUTS`

**Context Parameters:**

- `Land Battle`

---

## BattleCompleted

A battle has been completed on the campaign map

**Engine Code:** `BATTLE_COMPLETED`

**Context Parameters:**

- `Campaign model`

---

## BattleConflictPhaseCommenced

Fired once at the start of conflict

**Engine Code:** `BATTLE_CONFLICT_PHASE_COMMENCED`

**Context Parameters:**

- `Battle`

---

## BattleDeploymentPhaseCommenced

Fired once at the start of deployment

**Engine Code:** `BATTLE_DEPLOYMENT_PHASE_COMMENCED`

**Context Parameters:**

- `Battle`

---

## BattleFortPlazaCaptureCommenced

Fired each time an attacking unit starts capturing the capture location inside a fort

**Engine Code:** `BATTLE_FORT_PLAZA_CAPTURE_COMMENCED`

**Context Parameters:**

- `Battle`

---

## BattleShipAttacksEnemyShip

Gets fired off for every attack order executed by a ship

**Engine Code:** `BATTLE_SHIP_ATTACKS_ENEMY_SHIP`

**Context Parameters:**

- `Battle`

---

## BattleShipCaughtFire

A ship just caught fire

**Engine Code:** `BATTLE_SHIP_CAUGHT_FIRE`

**Context Parameters:**

- `Battle`

---

## BattleShipMagazineExplosion

Fired off when a ship explodes

**Engine Code:** `BATTLE_SHIP_MAGAZINE_EXPLOSION`

**Context Parameters:**

- `Battle`

---

## BattleShipRouts

Fires off whenever a ship enters the rout state of morale

**Engine Code:** `BATTLE_SHIP_ROUTS`

**Context Parameters:**

- `Naval Battle`

---

## BattleShipRunAground

Fired off when a ship collides with the terrain

**Engine Code:** `BATTLE_SHIP_RUN_AGROUND`

**Context Parameters:**

- `Naval Battle`

---

## BattleShipSailingIntoWind

Fired off when a ship is sailing approximately into the wind

**Engine Code:** `BATTLE_SHIP_SAILING_INTO_WIND`

**Context Parameters:**

- `Naval Battle`

---

## BattleShipSurrendered

Fired off when a ship surrenders

**Engine Code:** `BATTLE_SHIP_SURRENDERED`

**Context Parameters:**

- `Naval Battle`

---

## BattleUnitAttacksBuilding

Gets fired off for every attack order executed by a unit

**Engine Code:** `BATTLE_UNIT_ATTACKS_BUILDING`

**Context Parameters:**

- `Battle`

---

## BattleUnitAttacksEnemyUnit

Gets fired off for every attack order executed by a unit

**Engine Code:** `BATTLE_UNIT_ATTACKS_ENEMY_UNIT`

**Context Parameters:**

- `Battle`

---

## BattleUnitAttacksWalls

Gets fired off for every attack order executed by a unit when attacking a fort building

**Engine Code:** `BATTLE_UNIT_ATTACKS_WALLS`

**Context Parameters:**

- `Battle`

---

## BattleUnitCapturesBuilding

Gets fired each time a building has a new alliance as an owner, initiated by a unit

**Engine Code:** `BATTLE_UNIT_CAPTURES_BUILDING`

**Context Parameters:**

- `Battle`

---

## BattleUnitDestroysBuilding

Gets fired each time a building gets destroyed by a unit

**Engine Code:** `BATTLE_UNIT_DESTROYS_BUILDING`

**Context Parameters:**

- `Battle`

---

## BattleUnitRouts

Fires off an event for when a unit enters rout.

**Engine Code:** `BATTLE_UNIT_ROUTS`

**Context Parameters:**

- `Land Battle`

---

## BattleUnitUsingBuilding

*No parameters documented.*

---

## BattleUnitUsingWall

Fires off when a unit attaches itself to a wall

**Engine Code:** `BATTLE_UNIT_USING_WALL`

**Context Parameters:**

- `Battle`

---

## BuildingCardSelected

Fires when a building card is clicked on on the hud

**Engine Code:** `BUILDING_CARD_SELECTED`

**Context Parameters:**

- `String (building record key)`

---

## BuildingCompleted

A building has been completed

**Engine Code:** `BUILDING_COMPLETED_EVENT`

**Context Parameters:**

- `Building level record`

---

## BuildingConstructionIssuedByPlayer

Fired when the player adds a building to the queue

**Engine Code:** `BUILDING_CONSTRUCTION_ISSUED_BY_PLAYER`

**Context Parameters:**

- `building level`

---

## BuildingInfoPanelOpenedCampaign

triggers when the building info panel is opened by the user in the campaign game

**Engine Code:** `BUILDING_INFO_PANEL_OPEN_EVENT_CAMPAIGN`

**Context Parameters:**

- `string`

---

## CameraMoverCancelled

When the camera controller is cancelled before completion

**Engine Code:** `CAMERA_MOVER_CANCELLED`

**Context Parameters:**

- `MAP_LOCATION`

---

## CameraMoverFinished

When the camera reaches the end of its path, or when another camera transition cuts in

**Engine Code:** `CAMERA_MOVER_FINISHED`

**Context Parameters:**

- `MAP_LOCATION`

---

## CampaignArmiesMerge

Two campaign armies merge

**Engine Code:** `MILITARY_FORCE_MERGE_EVENT`

**Context Parameters:**

- `Character`
- `character target`

---

## CampaignBuildingDamaged

A building is damaged

**Engine Code:** `BUILDING_DAMAGED_EVENT`

**Context Parameters:**

- `Region slot`

---

## CampaignCoastalAssaultOnCharacter

Fired when a character initiates a coastal assault on a character

**Engine Code:** `CHARACTER_COASTAL_CHARACTER_ASSAULT`

**Context Parameters:**

- `Character`

---

## CampaignCoastalAssaultOnGarrison

Fired when a character initiates a coastal assault on a garrison

**Engine Code:** `CHARACTER_COASTAL_GARRISON_ASSAULT`

**Context Parameters:**

- `Character`

---

## CampaignEffectsBundleAwarded

A faction has gained an effect bundle

**Engine Code:** `FACTION_AWARDED_EFFECT_BUNDLE`

**Context Parameters:**

- `Faction`

---

## CampaignSettlementAttacked

*No parameters documented.*

---

## CharacterAttacksAlly

A character has attacked an ally

**Engine Code:** `CHARACTER_ATTACKS_ALLY_EVENT`

**Context Parameters:**

- `Character`

---

## CharacterBecomesFactionLeader

A character has become faction leader

**Engine Code:** `CHARACTER_BECOMES_FACTION_LEADER`

**Context Parameters:**

- `Character`

---

## CharacterBesiegesSettlement

Fired when a character besieges a settlement

**Engine Code:** `CHARACTER_BESIEGES_SETTLEMENT`

**Context Parameters:**

- `Character`

---

## CharacterBlockadedPort

A character successfully blockades a port

**Engine Code:** `CHARACTER_BLOCKADED_PORT_EVENT`

**Context Parameters:**

- `Character`

---

## CharacterBrokePortBlockade

A character successfully broke a port blockade

**Engine Code:** `CHARACTER_BROKE_PORT_BLOCKADE_EVENT`

**Context Parameters:**

- `Character`

---

## CharacterBuildingCompleted

A building has been completed

**Engine Code:** `CHARACTER_BUILDING_COMPLETED_EVENT`

**Context Parameters:**

- `Building level record`
- `Character`

---

## CharacterCanLiberate

A character was given the opportunity to liberate a region

**Engine Code:** `CHARACTER_CAN_LIBERATE_EVENT`

**Context Parameters:**

- `Character`

---

## CharacterCandidateBecomesMinister

Fired when a candidate becomes a minister

**Engine Code:** `CHARACTER_CANDIDATE_BECOMES_MINISER`

**Context Parameters:**

- `Character`

---

## CharacterCharacterTargetAction

A character has performed an agent action against a character

**Engine Code:** `CHARACTER_CHARACTER_TARGET_ACTION_EVENT`

**Context Parameters:**

- `Character`

---

## CharacterComesOfAge

An agent has failed to bribe an enemy army

**Engine Code:** `CHARACTER_COMES_OF_AGE`

**Context Parameters:**

- `Character`

---

## CharacterCompletedBattle

A character took part in a battle and didn\'t die

**Engine Code:** `CHARACTER_COMPLETED_BATTLE`

**Context Parameters:**

- `Character`

---

## CharacterCreated

Fired when a character is created

**Engine Code:** `CHARACTER_CREATION`

**Context Parameters:**

- `Character`

---

## CharacterDamagedByDisaster

*No parameters documented.*

---

## CharacterDeselected

triggers when a character has been deselected on the campaign map

**Engine Code:** `CHARACTER_DESELECTED_EVENT`

**Context Parameters:**

- `Empty string`

---

## CharacterDiscovered

Fired when an character is discovered

**Engine Code:** `CHARACTER_DISCOVERED`

**Context Parameters:**

- `Character`

---

## CharacterDisembarksNavy

A character disembarks a navy

**Engine Code:** `CHARACTER_DISEMBARKS_NAVY`

**Context Parameters:**

- `Character`

---

## CharacterEmbarksNavy

A character embarks on a navy

**Engine Code:** `CHARACTER_EMBARKS_NAVY`

**Context Parameters:**

- `Character`

---

## CharacterEntersAttritionalArea

Fired when a characters ends its movement in a position where it will suffer attrition

**Engine Code:** `CHARACTER_ENTERS_ATTRITIONAL_AREA`

**Context Parameters:**

- `Character`

---

## CharacterEntersGarrison

A character enters a garrison (settlement, slot or fort)

**Engine Code:** `CHARACTER_ENTERS_GARRISON`

**Context Parameters:**

- `Garrison`
- `Character`

---

## CharacterFactionCompletesResearch

research completed

**Engine Code:** `CHARACTER_FACTION_COMPLETES_RESEARCH`

**Context Parameters:**

- `Characters faction has research a technology`

---

## CharacterFamilyRelationDied

A character\'s immediate family member has died

**Engine Code:** `CHARACTER_FAMILY_RELATION_DIED_EVENT`

**Context Parameters:**

- `Character`

---

## CharacterGarrisonTargetAction

A character has performed an agent action against a garrison

**Engine Code:** `CHARACTER_GARRISON_TARGET_ACTION_EVENT`

**Context Parameters:**

- `Character`

---

## CharacterGeneralDiedInBattle

A character took part in a battle as a general and died

**Engine Code:** `CHARACTER_GENERAL_DIED_IN_BATTLE`

**Context Parameters:**

- `Character`

---

## CharacterInfoPanelOpened

triggers the character information panel has been opened

**Engine Code:** `CHARACTER_INFO_PANEL_OPENED`

**Context Parameters:**

- `character`
- `faction`

---

## CharacterLeavesGarrison

A character leaves a garrison (settlement, slot or fort)

**Engine Code:** `CHARACTER_LEAVES_GARRISON`

**Context Parameters:**

- `Garrison`
- `Character`

---

## CharacterLootedSettlement

A character loots a settlement

**Engine Code:** `CHARACTER_LOOTS_SETTLEMENT`

**Context Parameters:**

- `Character`

---

## CharacterMarriage

A character has married

**Engine Code:** `CHARACTER_MARRIES`

**Context Parameters:**

- `Character`

---

## CharacterMilitaryForceTraditionPointAllocated

Fired when a military force is assigned a tradition point

**Engine Code:** `CHARACTER_MILITARY_FORCE_TRADITION_POINT_ALLOCATED`

**Context Parameters:**

- `Character`

---

## CharacterParticipatedAsSecondaryGeneralInBattle

A character took part in a battle as a secondary general and didn\'t die

**Engine Code:** `CHARACTER_PARTICIPATED_AS_SECONDARY_GENERAL_IN_BATTLE`

**Context Parameters:**

- `Character`

---

## CharacterPerformsActionAgainstFriendlyTarget

Fired when an agent ends turn in a settlement or army

**Engine Code:** `CHARACTER_PERFORMS_ACTION_AGAINST_FRIENDLY_TARGET`

**Context Parameters:**

- `Character`

---

## CharacterPoliticalAction

Fired when a character performs a political action

**Engine Code:** `CHARACTER_POLITICAL_ACTION`

**Context Parameters:**

- `Character`

---

## CharacterPoliticalActionPoliticalMariage

Fired when a character is married politically

**Engine Code:** `CHARACTER_POLITICAL_ACTION_POLITICAL_MARRIAGE`

**Context Parameters:**

- `Character`

---

## CharacterPoliticalAdoption

Fired when a character is adopted

**Engine Code:** `CHARACTER_POLITICAL_ADOPTION`

**Context Parameters:**

- `Character`

---

## CharacterPoliticalAssassination

Fired when a character is assassinated

**Engine Code:** `CHARACTER_POLITICAL_ASSASSINATION`

**Context Parameters:**

- `Character`

---

## CharacterPoliticalBribe

Fired when a character is bribed

**Engine Code:** `CHARACTER_POLITICAL_BRIBE`

**Context Parameters:**

- `Character`

---

## CharacterPoliticalDivorce

Fired when a character is divorced politically

**Engine Code:** `CHARACTER_POLITICAL_DIVORCE`

**Context Parameters:**

- `Character`

---

## CharacterPoliticalEmbezzleFunds

Fired when Embezzle Funds political action executed

**Engine Code:** `CHARACTER_POLITICAL_EMBEZZLE_FUNDS`

**Context Parameters:**

- `Character`

---

## CharacterPoliticalEntice

Fired when Entice political action executed

**Engine Code:** `CHARACTER_POLITICAL_ENTICE`

**Context Parameters:**

- `Character`

---

## CharacterPoliticalFlirt

Fired when Flirt political action executed

**Engine Code:** `CHARACTER_POLITICAL_FLIRT`

**Context Parameters:**

- `Character`

---

## CharacterPoliticalGatherSupport

Fired when Gather Support political action executed

**Engine Code:** `CHARACTER_POLITICAL_GATHER_SUPPORT`

**Context Parameters:**

- `Character`

---

## CharacterPoliticalInsult

Fired when Insult political action executed

**Engine Code:** `CHARACTER_POLITICAL_INSULT`

**Context Parameters:**

- `Character`

---

## CharacterPoliticalOrganizeGames

Fired when Organize Games political action executed

**Engine Code:** `CHARACTER_POLITICAL_ORGANIZE_GAMES`

**Context Parameters:**

- `Character`

---

## CharacterPoliticalPartyProvoke

Fired when Party Provoke political action executed

**Engine Code:** `CHARACTER_POLITICAL_PARTY_PROVOKE`

**Context Parameters:**

- `Character`

---

## CharacterPoliticalPartyPurge

Fired when Party Purge political action executed

**Engine Code:** `CHARACTER_POLITICAL_PARTY_PURGE`

**Context Parameters:**

- `Character`

---

## CharacterPoliticalPartySecureLoyalty

Fired when Party Secure Loyalty political action executed

**Engine Code:** `CHARACTER_POLITICAL_PARTY_SECURE_LOYALTY`

**Context Parameters:**

- `Character`

---

## CharacterPoliticalPraise

Fired when Praise political action executed

**Engine Code:** `CHARACTER_POLITICAL_PRAISE`

**Context Parameters:**

- `Character`

---

## CharacterPoliticalPromotion

Fired when character secure promoted

**Engine Code:** `CHARACTER_POLITICAL_PROMOTION`

**Context Parameters:**

- `Character`

---

## CharacterPoliticalProvoke

Fired when Provoke political action executed

**Engine Code:** `CHARACTER_POLITICAL_PROVOKE`

**Context Parameters:**

- `Character`

---

## CharacterPoliticalRumours

Fired when rumours are spread about a character

**Engine Code:** `CHARACTER_POLITICAL_RUMOURS`

**Context Parameters:**

- `Character`

---

## CharacterPoliticalSecureLoyalty

Fired when Insult political action executed

**Engine Code:** `CHARACTER_POLITICAL_SECURE_LOYALTY`

**Context Parameters:**

- `Character`

---

## CharacterPoliticalSendDiplomat

Fired when Organize Games political action executed

**Engine Code:** `CHARACTER_POLITICAL_SEND_DIPLOMAT`

**Context Parameters:**

- `Character`

---

## CharacterPoliticalSendEmissary

Fired when Send Emissary political action executed

**Engine Code:** `CHARACTER_POLITICAL_SEND_EMISSARY`

**Context Parameters:**

- `Character`

---

## CharacterPoliticalSendGift

Fired when Send Gift political action executed

**Engine Code:** `CHARACTER_POLITICAL_SEND_GIFT`

**Context Parameters:**

- `Character`

---

## CharacterPoliticalSuicide

Fired when a character suicides

**Engine Code:** `CHARACTER_POLITICAL_SUICIDE`

**Context Parameters:**

- `Character`

---

## CharacterPostBattleEnslave

Occurs when a user selects to enslave prisoners after a battle

**Engine Code:** `CHARACTER_POSTBATTLE_ENSLAVE_EVENT`

**Context Parameters:**

- `User is selecting fate of prisoners`

---

## CharacterPostBattleRelease

Occurs when a user selects to release prisoners after a battle

**Engine Code:** `CHARACTER_POSTBATTLE_RELEASE_EVENT`

**Context Parameters:**

- `User is selecting fate of prisoners`

---

## CharacterPostBattleSlaughter

Occurs when a user selects to slaughter prisoners after a battle

**Engine Code:** `CHARACTER_POSTBATTLE_SLAUGHTER_EVENT`

**Context Parameters:**

- `User is selecting fate of prisoners`

---

## CharacterPromoted

A character has been promoted

**Engine Code:** `CHARACTER_PROMOTED_EVENT`

**Context Parameters:**

- `Character`

---

## CharacterRankUp

Fired when a character ranks up

**Engine Code:** `CHARACTER_RANK_UP`

**Context Parameters:**

- `Character`

---

## CharacterRankUpNeedsAncillary

Fired when a character ranks up and needs an ancillary generated

**Engine Code:** `CHARACTER_RANK_UP_NEEDS_ANCILLARY`

**Context Parameters:**

- `Character`

---

## CharacterRelativeKilled

An agent has failed to bribe an enemy army

**Engine Code:** `CHARACTER_RELATIVE_KILLED`

**Context Parameters:**

- `Character`

---

## CharacterSelected

Fired when a character is selected

**Engine Code:** `CHARACTER_SELECTED_EVENT`

**Context Parameters:**

- `Character`

---

## CharacterSettlementBesieged

Fired when a settlement garrisoned by a character is besieged

**Engine Code:** `SETTLEMENT_BESIEGED`

**Context Parameters:**

- `Garrison Residence`

---

## CharacterSettlementBlockaded

Fired when a settlement garrisoned by a character is besieged

**Engine Code:** `SETTLEMENT_BLOCKADED`

**Context Parameters:**

- `Garrison Residence`

---

## CharacterSkillPointAllocated

Fired when an character has a skill point allocated

**Engine Code:** `CHARACTER_SKILL_POINT_ALLOCATED`

**Context Parameters:**

- `Character`

---

## CharacterSuccessfulArmyBribe

*No parameters documented.*

---

## CharacterSuccessfulConvert

*No parameters documented.*

---

## CharacterSuccessfulDemoralise

*No parameters documented.*

---

## CharacterSuccessfulInciteRevolt

*No parameters documented.*

---

## CharacterSurvivesAssassinationAttempt

*No parameters documented.*

---

## CharacterTurnEnd

Fired for every character at the start of their turn

**Engine Code:** `CHARACTER_END_TURN_EVENT`

**Context Parameters:**

- `Character`

---

## CharacterTurnStart

Fired for every character at the start of their turn

**Engine Code:** `CHARACTER_START_TURN_EVENT`

**Context Parameters:**

- `Character`

---

## CharacterTurnStartCarthage

Fired for every character at the start of their turn

**Engine Code:** `CHARACTER_START_TURN_EVENT_CARTHAGE`

**Context Parameters:**

- `Character`

---

## CharacterTurnStartRome

Fired for every character at the start of their turn

**Engine Code:** `CHARACTER_START_TURN_EVENT_ROME`

**Context Parameters:**

- `Character`

---

## CharacterWoundedInAssassinationAttempt

*No parameters documented.*

---

## ClanBecomesVassal

A clan has become a vassal

**Engine Code:** `FACTION_BECOMES_VASSAL`

**Context Parameters:**

- `Faction`

---

## ComponentCreated

Fires when a Component is first created (at end of RunScript)

**Engine Code:** `COMPONENT_CREATED_EVENT`

**Context Parameters:**

- `String (name of the Component)`
- `Component ( this )`

---

## ComponentLClickUp

Triggered when a user clicks on any component

**Engine Code:** `COMPONENT_LCLICK_EVENT`

**Context Parameters:**

- `String (ComponentType condition)`
- `Component`

---

## ComponentMouseOn

Triggered when a user mouses over any component

**Engine Code:** `COMPONENT_MOUSEON_EVENT`

**Context Parameters:**

- `String (ComponentType condition)`
- `Component`

---

## ComponentMoved

Triggered when a user releases the left button after dragging an item

**Engine Code:** `COMPONENT_MOVED_EVENT`

**Context Parameters:**

- `String (ComponentType condition)`
- `Component`

---

## ConvertAttemptFailure

*No parameters documented.*

---

## CustomMission

Internal event: does not fire and cannot be used in the script

**Engine Code:** `CUSTOM_MISSION_EVENT`

**Context Parameters:**

- `Cannot be used in LUA`

---

## DemoraliseAttemptFailure

*No parameters documented.*

---

## DuelDemanded

*No parameters documented.*

---

## DummyEvent

*No parameters documented.*

---

## EncylopediaEntryRequested

Fired when an advice button is pressed.

**Engine Code:** `ENCYCLOPEDIA_ENTRY_REQUESTED`

**Context Parameters:**

- `String`

---

## EventMessageOpenedBattle

triggers when a dropdown message is opened by the user

**Engine Code:** `MESSAGE_OPENED_EVENT_BATTLE`

**Context Parameters:**

- `string (event name)`

---

## EventMessageOpenedCampaign

triggers when a dropdown message is opened by the user

**Engine Code:** `MESSAGE_OPENED_EVENT_CAMPAIGN`

**Context Parameters:**

- `string (event name)`

---

## FactionAboutToEndTurn

Faction about to end it\'s turn

**Engine Code:** `FACTION_ABOUT_TO_END_TURN`

**Context Parameters:**

- `Faction`

---

## FactionBattleDefeat

Fired when faction lose a battle

**Engine Code:** `FACTION_BATTLE_DEFEAT`

**Context Parameters:**

- `Faction`

---

## FactionBattleVictory

Fired when faction wins a battle

**Engine Code:** `FACTION_BATTLE_VICTORY`

**Context Parameters:**

- `Faction`

---

## FactionBecomesLiberationProtectorate

*No parameters documented.*

---

## FactionBecomesLiberationVassal

A faction has liberated another faction

**Engine Code:** `FACTION_BECOMES_LIBERATION_VASSAL_EVENT`

**Context Parameters:**

- `Faction`

---

## FactionBecomesShogun

**Context Parameters:**

- `faction`

---

## FactionBecomesWorldLeader

A faction has become world leader

**Engine Code:** `FACTION_BECOMES_WORLD_LEADER_EVENT`

**Context Parameters:**

- `Faction`

---

## FactionBeginTurnPhaseNormal

Faction begins its Normal turn phase

**Engine Code:** `FACTION_BEGIN_TURN_PHASE_NORMAL`

**Context Parameters:**

- `Faction`

---

## FactionCapturesKyoto

**Context Parameters:**

- `faction`

---

## FactionCapturesWorldCapital

A faction has captured the world capital

**Engine Code:** `FACTION_CAPTURES_WORLD_CAPITAL_EVENT`

**Context Parameters:**

- `Faction`

---

## FactionCivilWarEnd

Fired when civil war in faction ends

**Engine Code:** `FACTION_CIVIL_WAR_END`

**Context Parameters:**

- `Faction`

---

## FactionEncountersOtherFaction

A faction encounters another faction

**Engine Code:** `FACTION_ENCOUNTERS_OTHER_FACTION`

**Context Parameters:**

- `Faction`

---

## FactionFameLevelUp

Faction fame as gone up a level

**Engine Code:** `FACTION_FAME_LEVELUP`

**Context Parameters:**

- `Faction`

---

## FactionGovernmentTypeChanged

The factions government type has changed

**Engine Code:** `FACTION_GOVERNMENT_TYPE_CHANGED`

**Context Parameters:**

- `Faction`

---

## FactionLeaderDeclaresWar

War has been declared

**Engine Code:** `FACTION_LEADER_DECLARES_WAR`

**Context Parameters:**

- `Character`

---

## FactionLeaderIssuesEdict

Fired when a faction issues an edict

**Engine Code:** `FACTION_LEADER_ISSUES_EDICT`

**Context Parameters:**

- `Faction`

---

## FactionLeaderSignsPeaceTreaty

A peace treaty has been signed

**Engine Code:** `FACTION_LEADER_SIGNS_PEACE_TREATY`

**Context Parameters:**

- `Character`

---

## FactionPoliticsGovernmentActionTriggered

Fired when a custom scripted action must be executed for a particular politics government type

**Engine Code:** `FACTION_POLITICS_GOVERNMENT_ACTION_TRIGGERED`

**Context Parameters:**

- `Faction`

---

## FactionPoliticsGovernmentTypeChanged

Fired when politics government type has changed

**Engine Code:** `FACTION_POLITICS_GOVERNMENT_TYPE_CHANGED`

**Context Parameters:**

- `Faction`

---

## FactionRoundStart

Faction starts the round

**Engine Code:** `FACTION_START_ROUND`

**Context Parameters:**

- `Faction`

---

## FactionSecessionEnd

Fired when secession in faction ends

**Engine Code:** `FACTION_SECESSION_END`

**Context Parameters:**

- `Faction`

---

## FactionSubjugatesOtherFaction

A faction subjugates another faction

**Engine Code:** `FACTION_SUBJUGATES_OTHER_FACTION`

**Context Parameters:**

- `Faction`

---

## FactionTurnEnd

Faction ends it\'s turn

**Engine Code:** `FACTION_END_TURN`

**Context Parameters:**

- `Faction`

---

## FactionTurnStart

Faction starts it\'s turn

**Engine Code:** `FACTION_START_TURN`

**Context Parameters:**

- `Faction`

---

## FirstTickAfterNewCampaignStarted

A new campaign game has being started and the first tick is just being done - not triggered when processing startpos. Guarantees UI is open.

**Engine Code:** `FIRST_TICK_AFTER_NEW_CAMPAIGN_STARTED`

**Context Parameters:**

- `DAT_1173e900`

---

## FirstTickAfterWorldCreated

First tick after a game was started or loaded

**Engine Code:** `FIRST_TICK_AFTER_WORLD_CREATED`

**Context Parameters:**

- `DAT_1173e900`

---

## ForceAdoptsStance

Fired when an characters military force changes stance

**Engine Code:** `FORCE_ADOPTS_STANCE`

**Context Parameters:**

- `Character`

---

## FortSelected

*No parameters documented.*

---

## FrontendScreenTransition

triggers we change screens in the frontend

**Engine Code:** `FRONTEND_TRANSITION_EVENT`

**Context Parameters:**

- `string (name of layout transitioned to)`

---

## GarrisonAttackedEvent

DAT_1173dad0

**Engine Code:** `GARRISON_ATTACKED_EVENT`

**Context Parameters:**

- `DAT_1173dad0`

---

## GarrisonOccupiedEvent

DAT_1173dad0

**Engine Code:** `GARRISON_OCCUPIED_EVENT`

**Context Parameters:**

- `DAT_1173dad0`

---

## GarrisonResidenceCaptured

A garrison residence (settlement, fort, port &c.) has been captured

**Engine Code:** `GARRISON_RESIDENCE_CAPTURED`

**Context Parameters:**

- `Garrison residence`

---

## GovernorshipTaxRateChanged

A tax rate in a governorship has changed

**Engine Code:** `GOVERNORSHIP_TAX_RATE_CHANGE`

**Context Parameters:**

- `Governorship`

---

## HistoricBattleEvent

Events fired from Historic battle, will send the name of next battle to be played !

**Engine Code:** `HISTORIC_BATTLE_EVENTS`

**Context Parameters:**

- `String`

---

## HistoricalCharacters

DAT_1173dad0

**Engine Code:** `HISTORICAL_CHARACTER_GENERATION_EVENT`

**Context Parameters:**

- `List of possible historical characters`

---

## HistoricalEvents

DAT_1173dad0

**Engine Code:** `HISTORICAL_EVENTS_EVENT`

**Context Parameters:**

- `List of possible historical events`

---

## HudRefresh

triggers when the HUD is reconstructed

**Engine Code:** `HUD_REFRESH_EVENT`

**Context Parameters:**

- `Empty string`

---

## InciteRevoltAttemptFailure

*No parameters documented.*

---

## IncomingMessage

triggers when a dropdown message first starts falling down the screen

**Engine Code:** `INCOMING_MESSAGE_EVENT`

**Context Parameters:**

- `string (event name)`

---

## LandTradeRouteRaided

A character has raided a land trade route

**Engine Code:** `LAND_TRADE_ROUTE_ATTACKED_EVENT`

**Context Parameters:**

- `Character`
- `Position`

---

## LoadingGame

A game is being loaded

**Engine Code:** `LOAD_GAME_EVENT`

**Context Parameters:**

- `FileHandle`

---

## LoadingScreenDismissed

triggers when loading screen dismissed by player

**Engine Code:** `LOADING_SCREEN_DISMISSED_EVENT`

**Context Parameters:**

- `Empty string`

---

## LocationEntered

When a piece enters a location trigger, fire ony once per trigger

**Engine Code:** `LOCATION_ENTERED_EVENT`

**Context Parameters:**

- `MAP_LOCATION`
- `the piece that entered`

---

## LocationUnveiled

When the location becomes visible for the first time

**Engine Code:** `LOCATION_UNVEILED_EVENT`

**Context Parameters:**

- `MAP_LOCATION`
- `the piece that unveiled the area`

---

## MPLobbyChatCreated

*No parameters documented.*

---

## MapIconMoved

*No parameters documented.*

---

## MissionCancelled

A mission has been cancelled - ie is no longer viable

**Engine Code:** `MISSION_CANCELLED`

**Context Parameters:**

- `Mission`
- `mission manager`
- `faction of mission manager`
- `campaign model`

---

## MissionCheckAssassination

*No parameters documented.*

---

## MissionCheckBlockadePort

*No parameters documented.*

---

## MissionCheckBuild

*No parameters documented.*

---

## MissionCheckCaptureCity

*No parameters documented.*

---

## MissionCheckDuel

*No parameters documented.*

---

## MissionCheckEngageCharacter

*No parameters documented.*

---

## MissionCheckEngageFaction

*No parameters documented.*

---

## MissionCheckGainMilitaryAccess

*No parameters documented.*

---

## MissionCheckMakeAlliance

*No parameters documented.*

---

## MissionCheckMakeTradeAgreement

*No parameters documented.*

---

## MissionCheckRecruit

*No parameters documented.*

---

## MissionCheckResearch

*No parameters documented.*

---

## MissionCheckSpyOnCity

*No parameters documented.*

---

## MissionEvaluateAssassination

*No parameters documented.*

---

## MissionEvaluateBlockadePort

*No parameters documented.*

---

## MissionEvaluateBuild

*No parameters documented.*

---

## MissionEvaluateCaptureCity

*No parameters documented.*

---

## MissionEvaluateDuel

*No parameters documented.*

---

## MissionEvaluateEngageCharacter

*No parameters documented.*

---

## MissionEvaluateEngageFaction

*No parameters documented.*

---

## MissionEvaluateGainMilitaryAccess

*No parameters documented.*

---

## MissionEvaluateMakeAlliance

*No parameters documented.*

---

## MissionEvaluateMakeTradeAgreement

*No parameters documented.*

---

## MissionEvaluateRecruit

*No parameters documented.*

---

## MissionEvaluateResearch

*No parameters documented.*

---

## MissionEvaluateSpyOnCity

*No parameters documented.*

---

## MissionFailed

The player has failed a mission

**Engine Code:** `MISSION_FAILED`

**Context Parameters:**

- `Mission`
- `mission manager`
- `faction of mission manager`
- `campaign model`

---

## MissionIssued

A mission has been issued to the player

**Engine Code:** `MISSION_ISSUED`

**Context Parameters:**

- `Mission`
- `mission manager`
- `faction of mission manager`
- `campaign model`

---

## MissionNearingExpiry

A mission only has a quarter of its time left before its too late to complete it

**Engine Code:** `MISSION_NEARING_EXPIRY`

**Context Parameters:**

- `Mission`
- `mission manager`
- `faction of mission manager`
- `campaign model`

---

## MissionSucceeded

A mission has been successfully completed

**Engine Code:** `MISSION_SUCCEEDED`

**Context Parameters:**

- `Mission`
- `mission manager`
- `faction of mission manager`
- `campaign model`

---

## ModelCreated

A game is being started or loaded, at this point the most vital parts pf the game are initialized

**Engine Code:** `MODEL_CREATED`

**Context Parameters:**

- `DAT_1173e900`

---

## MovementPointsExhausted

A general can move no more

**Engine Code:** `CHARACTER_ACTION_POINTS_EXHAUSTED`

**Context Parameters:**

- `Character`

---

## MultiTurnMove

A character has been issued a movement that will take more than one turn

**Engine Code:** `CHARACTER_MULTITURN_MOVE_ISSUED_EVENT`

**Context Parameters:**

- `Character`

---

## NewCampaignStarted

A new campaign game is being started - called exactly once during a campaign, when it is created for the first time - NOT called when loading, NOT called when processing startpos

**Engine Code:** `NEW_CAMPAIGN_STARTED`

**Context Parameters:**

- `DAT_1173e900`

---

## NewSession

A game is being started, could be a new game or loading a save game

**Engine Code:** `NEW_GAME_EVENT`

**Context Parameters:**

- `model access`

---

## PanelAdviceRequestedBattle

triggers when the user clicks on the request advice button on a panel in battle

**Engine Code:** `PANEL_ADVICE_EVENT_BATTLE`

**Context Parameters:**

- `string`

---

## PanelAdviceRequestedCampaign

triggers when the user clicks on the request advice button on a panel in the campaign game

**Engine Code:** `PANEL_ADVICE_EVENT_CAMPAIGN`

**Context Parameters:**

- `string`

---

## PanelClosedBattle

triggers when a ui panel is closed by the user in battle

**Engine Code:** `PANEL_CLOSED_EVENT_BATTLE`

**Context Parameters:**

- `string`

---

## PanelClosedCampaign

triggers when a ui panel is closed by the user in the campaign game

**Engine Code:** `PANEL_CLOSED_EVENT_CAMPAIGN`

**Context Parameters:**

- `string`

---

## PanelOpenedBattle

triggers when a ui panel is opened by the user in battle

**Engine Code:** `PANEL_OPEN_EVENT_BATTLE`

**Context Parameters:**

- `string`

---

## PanelOpenedCampaign

triggers when a ui panel is opened by the user in the campaign game

**Engine Code:** `PANEL_OPEN_EVENT_CAMPAIGN`

**Context Parameters:**

- `string`

---

## PendingBankruptcy

The faction is about to go bankrupt

**Engine Code:** `FACTION_PENDING_BANKRUPTCY_EVENT`

**Context Parameters:**

- `Faction`

---

## PendingBattle

A battle is about to occur

**Engine Code:** `PENDING_BATTLE_EVENT`

**Context Parameters:**

- `The character and faction initiating the battle`

---

## PositiveDiplomaticEvent

Fires when a user performs a positive diplomatic action

**Engine Code:** `POSITIVE_DIPLOMATIC_EVENT`

**Context Parameters:**

- `DAT_1173e900`

---

## PreBattle

*No parameters documented.*

---

## RecruitmentItemIssuedByPlayer

Fired when the player selects adds a unit to the queue

**Engine Code:** `RECRUITMENT_ITEM_ISSUED_BY_PLAYER`

**Context Parameters:**

- `unit record`

---

## RegionChangedFaction

Fired when a region changes faction

**Engine Code:** `REGION_CHANGED_FACTION`

**Context Parameters:**

- `Region`

---

## RegionGainedDevlopmentPoint

Region gained a development point

**Engine Code:** `REGION_GAINED_DEVELOPMENT_POINT`

**Context Parameters:**

- `Region`

---

## RegionIssuesDemands

This region has issued demands

**Engine Code:** `REGION_ISSUES_DEMANDS`

**Context Parameters:**

- `Region`

---

## RegionRebels

This region has started rebelling

**Engine Code:** `REGION_REBELS`

**Context Parameters:**

- `Region`

---

## RegionRiots

This region has started riots

**Engine Code:** `REGION_RIOTS`

**Context Parameters:**

- `Region`

---

## RegionSelected

Fired when a region is selected

**Engine Code:** `REGION_SELECTED_EVENT`

**Context Parameters:**

- `Region`

---

## RegionStrikes

This region has started striking

**Engine Code:** `REGION_STRIKES`

**Context Parameters:**

- `Region`

---

## RegionTurnEnd

Region ends it\'s turn

**Engine Code:** `REGION_END_TURN`

**Context Parameters:**

- `Region`

---

## RegionTurnStart

Region starts it\'s turn

**Engine Code:** `REGION_START_TURN`

**Context Parameters:**

- `Region`

---

## ResearchCompleted

Research has been completed in this slot

**Engine Code:** `RESEARCH_COMPLETED_EVENT`

**Context Parameters:**

- `Technology record`
- `faction`

---

## ResearchStarted

Research has been started

**Engine Code:** `RESEARCH_STARTED_EVENT`

**Context Parameters:**

- `Technology record`
- `faction`

---

## SabotageAttemptFailure

*No parameters documented.*

---

## SabotageAttemptSuccess

*No parameters documented.*

---

## SavingGame

A game is being saveed

**Engine Code:** `SAVE_GAME_EVENT`

**Context Parameters:**

- `FileHandle`

---

## ScriptedAgentCreated

Fired when the an agent is created through script

**Engine Code:** `SCRIPTED_AGENT_CREATED`

**Context Parameters:**

- `String`

---

## ScriptedAgentCreationFailed

Fired when the an agent is unable to be created through script

**Engine Code:** `SCRIPTED_AGENT_CREATION_FAILED`

**Context Parameters:**

- `String`

---

## ScriptedCharacterUnhidden

Fired when a character is sucessfully unhidden by script

**Engine Code:** `SCRIPTED_CHARACTER_UNHIDDEN`

**Context Parameters:**

- `Character`

---

## ScriptedCharacterUnhiddenFailed

Fired when a character is unsucessfully unhidden by script

**Engine Code:** `SCRIPTED_CHARACTER_UNHIDDEN_FAILED`

**Context Parameters:**

- `Character`

---

## ScriptedForceCreated

Fired when the a force is created through script

**Engine Code:** `SCRIPTED_FORCE_CREATED`

**Context Parameters:**

- `String`

---

## SeaTradeRouteRaided

A character has raided a sea trade route

**Engine Code:** `SEA_TRADE_ROUTE_ATTACKED_EVENT`

**Context Parameters:**

- `Character`
- `Position`

---

## SettlementDeselected

triggers when a settlement has been deselected on the campaign map

**Engine Code:** `SETTLEMENT_DESELECTED_EVENT`

**Context Parameters:**

- `Empty string`

---

## SettlementOccupied

*No parameters documented.*

---

## SettlementSelected

Fired when the player selects a settlement on the map

**Engine Code:** `SETTLEMENT_SELECTED_EVENT`

**Context Parameters:**

- `Settlement`

---

## ShortcutTriggered

Fired when a keyboard shortcut is triggered

**Engine Code:** `SHORTCUT_TRIGGERED`

**Context Parameters:**

- `String`

---

## SiegeLifted

*No parameters documented.*

---

## SlotOpens

A slot has just opened

**Engine Code:** `REGION_SLOT_POPPED_EVENT`

**Context Parameters:**

- `Slot`
- `Region`

---

## SlotRoundStart

The start of round for this slot

**Engine Code:** `REGION_SLOT_ROUND_START_EVENT`

**Context Parameters:**

- `Slot`
- `Region`

---

## SlotSelected

Fired when the player selects a settlement slot on the map

**Engine Code:** `SLOT_SELECTED_EVENT`

**Context Parameters:**

- `DAT_117a5ac0`

---

## SlotTurnStart

The start of turn for this slot

**Engine Code:** `REGION_SLOT_START_TURN_EVENT`

**Context Parameters:**

- `Slot`
- `Region`

---

## StartRegionPopupVisible

*No parameters documented.*

---

## StartRegionSelected

*No parameters documented.*

---

## TechnologyInfoPanelOpenedCampaign

triggers when the technology info panel is opened by the user in the campaign game

**Engine Code:** `TECHNOLOGY_INFO_PANEL_OPEN_EVENT_CAMPAIGN`

**Context Parameters:**

- `string`

---

## TestEvent

Test event

**Engine Code:** `TEST_EVENT`

**Context Parameters:**

- `model`

---

## TimeTrigger

*No parameters documented.*

---

## TooltipAdvice

triggers when a tooltip cycles though all of it\'s available lines (only happens at end of first sequence

**Engine Code:** `TOOLTIP_ADVICE_EVENT`

**Context Parameters:**

- `string`

---

## TouchUsed

Trigger when touch controls have been used

**Engine Code:** `TOUCH_USED_EVENT`

**Context Parameters:**

- `battle_ui`

---

## TradeLinkEstablished

*No parameters documented.*

---

## TradeNodeConnected

Fired when a character enters a trade node and establishes a trade route

**Engine Code:** `CHARACTER_ESTABLISHED_DOMESTIC_TRADE_ROUTE`

**Context Parameters:**

- `Character`

---

## TradeRouteEstablished

A trade route has been established with this faction

**Engine Code:** `TRADE_ROUTE_ESTABLISHED`

**Context Parameters:**

- `Faction`

---

## UICreated

Fires when the UI is first created

**Engine Code:** `UI_CREATED_EVENT`

**Context Parameters:**

- `String (name of the UI)`
- `Component (root component of the ui)`

---

## UIDestroyed

Fires when the UI is destroyed

**Engine Code:** `UI_DESTROYED_EVENT`

**Context Parameters:**

- `String (name of the UI)`

---

## UngarrisonedFort

*No parameters documented.*

---

## UnitCompletedBattle

A unit has completed the battle

**Engine Code:** `UNIT_COMPLETED_BATTLE_EVENT`

**Context Parameters:**

- `DAT_117af86c`

---

## UnitCreated

A unit has been created

**Engine Code:** `UNIT_CREATION_EVENT`

**Context Parameters:**

- `DAT_117af86c`

---

## UnitSelectedCampaign

Fires when a unit card is selected on the campaign map

**Engine Code:** `UNIT_SELECTED_EVENT_CAMPAIGN`

**Context Parameters:**

- `Unit (campaign)`

---

## UnitTrained

A unit is trained

**Engine Code:** `UNIT_RECRUITED_EVENT`

**Context Parameters:**

- `DAT_117af86c`

---

## UnitTurnEnd

A unit has ended its turn

**Engine Code:** `UNIT_TURN_END_EVENT`

**Context Parameters:**

- `DAT_117af86c`

---

## VictoryConditionFailed

*No parameters documented.*

---

## VictoryConditionMet

*No parameters documented.*

---

## WorldCreated

A game is being started or loaded, at this point the most vital parts of the game are initialized

**Engine Code:** `WORLD_CREATED`

**Context Parameters:**

- `DAT_1173e900`

---

## historical_events

*No parameters documented.*

---

