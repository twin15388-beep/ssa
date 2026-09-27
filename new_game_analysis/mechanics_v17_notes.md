# User verification and next evidence — Mechanics v1.7

## New user confirmation
User confirms CAM Main v2.0 moves to NPC, accepts quests, equips a weapon, attacks, repeats quests and follows progression. Auto Level sometimes switches itself OFF. Cause is not yet known: do not remove low-HP/no-damage/movement/acceptance/lifecycle protections blindly. This is user-observed success of the core loop, not a live test by the agent and not verification of all 17 routes.

User explicitly says Infinite Stamina implementations exist and asks to investigate; also says instant kill exists without loot/EXP. Treat this as a user report, not proof of a specific method. They request collecting data for the remaining functions. Current turn produces a new one-button focused passive recorder, not a main update.

## Source inspection this turn
- core_sources/014_StaminaComponent.lua + sources/2_27_Stamina.lua: HUD/Billboard rendering of stamina, not spending logic.
- core_sources/007_Skills_Module.lua: u2=RunService:IsServer(); cost=max(0, skill.Stamina*(1+PlayerStatResolver Stamina Cost Factor/category factor)); v9.Stamina.Value comparison both sides; subtract in u2/server branch after native checks. NotEnoughStamina BindableEvent on client when insufficient. Does not establish a working bypass.
- sources/2_202_Climbing.lua, original path Workspace.Humanoids.Kokakoka20.Character Scripts.Climbing: local table CurrentStamina=7, MaxClimbTime=7; decrement/recovery in client logic. Separate climbing mechanic, not combat stamina.
- sources/1_566_Horse.lua: local stamina accumulator u8, max45, StaminaDrain per gait and local movement; distinct mechanic. No new infinite-stamina implementation was shipped.

## Delivered candidate
CAM_Debug_Mechanics_v1.7.lua — 270337 bytes.
SHA256 16c90bb4a0f02dbfd45764618ed64f5bc6c3fd876f1aa4dbccde84c42d73cca6.
Instructions: CAM_Debug_Mechanics_v1.7_Инструкция.md.

Source files: build_mechanics_debug.py, mechanics_discovery.lua, mechanics_recording.lua; generated mechanics_debug_logic.lua + cam_known_mechanics_sources.lua (424 known paths, latest available source reference preferred). Reuses old bounded reader/portable serializer/embedded isolated CAMDebugLumen UI, not gameplay logic. Main and existing v1.6 artifact are unchanged.

One button START 90s + COLLECT + SAVE + COPY. 90 seconds passive observation, initial source scan budget85s/350 sources; late additional-source scan budget25s/80 sources. Auto save/copy CAM_Debug_Mechanics_<PlaceId>_<UTC>.json. Same JSON for file and clipboard. Optional FINISH NOW produces partial report. No require/gameplay actions/stat modifications/outgoing remotes/hooks/HTTP upload. User/main acts during recording; collector does not demonstrate actions. No teleport persistence: rerun inside each relevant mode.

Initial/final runtime snapshots include main Snapshot, local data, executor, device, local attributes and world attrs. Trace samples value deltas every0.5s; main status/ON->OFF transitions and logs; HP/stamina bounds/EXP/Wen/quests/equipment/powers/skill tree; NotEnoughStamina local event; up to12 nearby non-player humanoids within200 studs with stable per-recording IDs, attributes/ownership/position/health. Up to50 NPC event watch sets for HP, Died, animation and ancestry removal. Read-only ownership API presence is not a bypass or proof of authoritative death. UI snapshots every15s filter chat/TextBox/main/debug. Some global mode value roots are sampled, roster branches excluded. Directly accessible local client state only; no arbitrary module evaluation.

Discovery: RS + own scripts/gui/character/backpack + ReplicatedFirst, bounded25000 nodes; excludes packages/assets/effects models/Core/internal services/other-player data; communication Effects wrapper is allowed. 350 mechanic-prioritized scripts first,80 additional at end; deferred paths exported. Same-build known unrelated Content references reused, mechanics re-read. No fixed source-path manual configuration. Discovery/selection/source/time/trace truncation is explicit. Report top-level format CAM Mechanics Recorder OneClick 1.7; sources live under sourcePasses[*].scripts, not top-level scripts. recording holds events/samples/mainTransitions/mainLogs/uiSnapshots.

## Validation
pip installed lupa (dependencies do not persist reliably); build_mechanics_debug.py syntax PASS. test_mechanics_debug.py PASS for virtual-time90s completion, initial and late scripts, main ON->OFF stop reason, stamina and NotEnoughStamina, NPC health/removal/animation, known source reuse, source/discovery limits/deferred manifest, hanging decompiler time budget, partial finish, identical saved/copied JSON, native JSON failure fallback, write/clipboard failures, callback cleanup on finish/unload, no main STOP/require/remote calls, actual embedded-library bootstrap does not unload CAMMainLumen or legacy Lumen.

Mock-only verification; v1.7 not live-tested in Potassium by agent.

## Next turn
Expect returned Mechanics JSON(s). Parse sourcePasses[*].scripts, extract new texts; inspect runtimeBefore.mainHub/report.log + recording.mainTransitions/mainLogs for exact Auto Level OFF cause. Distinguish user manual STOP/death/team/low HP/no-damage/blocked movement/quest acceptance failures. Then implement evidence-backed fixes/remaining mechanics in authoritative main engine/builders and retest. Don't request another broad world dump. No main patch has been made in this turn.
