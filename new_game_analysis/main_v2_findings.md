# Main v2 implementation / verification record

Artifact: CAM_Main_Hub_v2.0.lua (242797 bytes)
SHA-256: 91ef8fef6bfdc3c51a1dcdeef6d7f6b380b0ecc912cc0018dcb631baee39c934

Evidence: user uploads/2.txt, World Content v1.6; 271 collected source texts with no individual failures/truncations. Tree limit 15000 reached; not proof of full-world source coverage. Earlier native client sources reused. Original v1 no-action cause remains unproven; no live Roblox/server test here.

Implementation: authoritative cam_main_logic.lua rebuilt by rework_cam_main.py from preserved cam_main_v1_original.lua plus cam_farm_engine.lua. build_cam_catalog.py extracts static routes without executing decompiled scripts. Catalog: 47 active hostile definitions, 17 free repeatable single-kill-task combat routes, level thresholds 0/7/10/18/26/34/40/47/50/62/75/75/83/90/90/105/115. Runtime definition, race, NPC requirements, CanAddQuest, cost/task/category checks remain mandatory. Level Exp.Goal/60. AddQuest server request observed through replicated holder; no local quest creation/reward mutation. Completion observed, not invented remote.

Equipment correction: Items_Config.Equipped is a toolbar SLOT index (1..5), not inventory ID. Native Info/Requirements/Restrictions checks before changing it, equivalent to documented Utility.ForceEquip behavior; HUD Changed performs actual equip protocol. Optional getsenv of existing CU.Combat LocalScript exposes its punch function; native InputHandler fallback; API support/shared listeners remain unverified. Count requests, native combo observations, target HP observations separately. No virtual physical mouse clicks.

Farm modes: selected mob, selected boss, nearest hostile; exclude players/unknown humanoids. Eight positions Above(default), Below, Behind, In front, Left, Right, Orbit, Ground. Tween (framewise speed-limited interpolation), Instant, Walk. Walk not hover; no immunity promise. All automations OFF until explicit enable. Native modules autoload on enabled combat modes only. STOP/low HP/respawn/character/team guards, hold removal and AutoRotate restoration. Fly first releases farm hold to prevent restoration-order bug. Main UI isolated CAMMainLumen from debug CAMDebugLumen.

Validation: build_cam_main.py standalone syntax PASS; test_cam_main_v2.py full mock scenarios PASS. Tested no startup require/actions, 11 explicit native module loads, level8 Zuko acceptance request, ack gate, slot3 rather than item14, live punch mock, closure and level10 Bear switch, all eight positions, nearest player/unknown exclusion, blocked equipment, no-damage fallback stop, three-attempt acceptance bound, native cooldown, runtime paid-route rejection, focus/HP/place/STOP/unload, identical one-click saved/copied diagnostic JSON. Mocks do NOT establish live/server/executor success.

Delivery: standalone Lua plus Russian CAM_Main_v2.0_Инструкция.md. Broader unimplemented features are listed honestly; not a claim to full Ouroboros parity. No further debug collection requested for this turn.
