# Received Mechanics v1.7 report — 2026-09-26

Input: uploads/Текстовый документ (2).txt, valid JSON (~2.4 MB).
Parsed: new_game_analysis/mechanics_report.json.
Extracted: new_game_analysis/mechanics_sources/manifest.json and 350 .lua files.

## Verified facts
- Place136406881576517 / Universe5595353122, **version5400**, updated from source baseline5354.
- Potassium v2.5.0; decompile/writefile/clipboard/getsenv/isnetworkowner APIs present. Presence does not prove getsenv returns usable shared runtime state.
- Initial source pass:350 attempted/350 collected, 1,794,021 source bytes,346 unique texts, zero failures/timeouts/truncations,21.71s.
- Discovery visited5698 nodes,2104 eligible source candidates, selected350.500 deferred paths retained; deferred list also hit cap. No full source coverage. Priority ordering spent many slots on individual breathing skill modules; current ToolScripts/fishing rod/potion and full Minigames Place sources not in these350.
- Recording requested90s, actual46.016s,91 ticks, finishedEarly=true; total46.12s. No late pass.286 events,46 samples,4 UI snapshots. Recording errors0; MenuDepth flagged incomplete. Do not blame user or report failure: source collection succeeded, recording is intentionally/explicitly early-finished.
- runtimeBefore.mainHub.present=false; runtimeAfter same; all46 samples main.present=false. No mainTransitions or mainLogs. This does NOT prove main was not running; executor environment separation remains possible. No evidence of a main STOP cause in this file.

## Character observations
- Goal660 / expPerLevel60 = **level11**; CurrentEXP348; Wen754; HP147/147; stamina125/125.
- Active quest Hunt the Bears / key Ill drive the bears back(Lv 10), BearCub task1/4.
- These values stayed unchanged throughout46s; player position exactly unchanged in all samples at(-467.211609,1242.999878,-940.499695), near Windy Peak. No player-progress or stamina-consumption scenario captured.
- Events:54 initial/added value entries,200 NPC animations,31 NPC HP events,1 NPC removal. No valueChanged event, no NotEnoughStamina event.
- Zuko model id4 removed from Workspace at35.927s, last observed HP -4.1524977684. NPC ownership samples were not local client. Own EXP/Wen/quest count unchanged. This does NOT identify the killing player, establish server-authoritative kill, prove instant kill, prove reward bug, or demonstrate a working client deletion technique.
- Logs contain only CoreGui GetServerChannelRemote unavailable, SmartBone startup, version v.182; no main errors. Do not treat engine/UI log as cause of Auto Level stopping.

## Useful new contracts / changes
- 019_Skills_Module.lua version5400 adds CombatBalance.CastKnob(player,skill,"Stamina") into cost: max(0,skill.Stamina*(1+costFactor)*CastKnob). Shared module retains server-branch debit and client NotEnoughStamina UI event. Old clamp-only assumptions are outdated. Native client changes alone do not prove infinite server stamina; no working implementation yet.
- 012_Skill_Controller.lua now tests InputHandler.IsDown("Skills_1st") instead of UserInputService:IsKeyDown(F) when deciding native block-release behavior. Relevant to future block/parry integration; source change, not proof of shared executor listeners.
- 021_Utility.lua is text-identical to old core Utility; Checker, Stats, Skills_Module and Skill_Controller differ (decompiler renaming/formatting accounts for some differences; compare semantically).
- 002_ServerClientPortal.lua exposes session-specific listener ConnectionName and :Server/:YieldServer. Important for fishing: not a universal static FinishFishing payload; do not invent one. Older rod scripts exist in initial373-source corpus, current rod ToolScripts not recollected here.
- 072_Bait.lua native UI sends SignalEvent.ToServer("EquipBait", itemId or0), player value Misc/EquippedBaitId. Can implement owned-bait selection with acknowledgement after runtime validation; not yet implemented.
- 143_Client/150_Client/etc: training native Do/Stop, pause_gameplay, skill_stand_still, NR, mini-game components. Meditation/Pushups use SignalEvent.ToServer("training_signaler","Stop",successBoolean) after UI result. Server per-training modules144/151.Stop returntrue; this is NOT proof the central server dispatcher accepts arbitrary success without validation. No instant-complete training method shipped.
- 135..157: concrete training client/server modules for BoulderPush/Split,CupGame,Horse,Meditation,Parkour,Pushups,Squat,TargetShooting and Template.
- 092..096: BarKeepup, CupGame, Shrinking, SlideBubbles, Slider components recovered.
- 006_QueueSignal only wrapper/transport; does not define queue join arguments. 106_RankedController defines leaderboard/request/claim behavior, not matchmaking by itself.
- 029_Minigame_Ouwigahara and similar CU.Biomes modules are environmental lighting, not wave/card controllers. 040_OuwigaharaBoard explicitly depends on ReplicatedStorage['Minigames Place'].Minigames.Ouwigahara.Score, absent from these350 sources. Cannot claim all dungeon logic collected.
- 115_MinigameSettings contains rules, waves and mode stat overrides (Max Stamina400 for a mode); settings are not an infinite-stamina implementation.
- 188..193 potion item descriptions/equip type recovered, not current consumption controllers. Older health potion ToolScripts available in initial corpus; version compatibility not established by item definitions alone.

## Current continuation
No main changes or new deliverable have been made for this upload. Core main was user-confirmed working in previous turn. Do not rewrite working Auto Level blindly or disable safety stops without their reason.
Important clarification to ask: was main actually loaded and Auto Level ON during THIS 46s recording, vs UI only/OFF or debug alone? Lack of env snapshot plus stationary character cannot resolve this unilaterally.
If main was running, implement a read-only local Instance-based diagnostic bridge / persistent lastStop record in main to avoid getgenv sharing dependency, or use main's own one-click diagnostic button (already bound to its own execution environment). Do not request another broad source dump to fix this diagnostic visibility issue.
Sufficient material now exists to design training/native skill controls/bait integration; still need current-mode controllers for full wave/card/queue automation. Need user-defined spending thresholds/priority if enabling consumables or irreversible purchases; all such actions default OFF.

## Clarification resolved in same turn
User selected **debug_only**: only debug was running during this 46s recording; main was not running. Thus mainHub.present=false and absent main logs are expected for THIS report. Do not claim executor/getgenv separation as the observed cause or ship an unnecessary visibility fix based on this file. Earlier absent snapshots remain separate evidence. No new source dump needed now. For intermittent main OFF, use main v2.0's own ONE CLICK save+copy diagnostic immediately after the actual stop, without unloading it; its own callback already accesses its local state. Latest file remains useful for 350 source texts but not an Auto Level failure reproduction.
