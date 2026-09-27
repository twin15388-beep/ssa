# Main v2.0.1 hotfix / second Mechanics report

Latest uploaded uploads/Текстовый документ (2).txt overwrote previous filename. Saved parsed second report to new_game_analysis/mechanics_report_second.json. Previous report remains mechanics_report.json. Screenshot uploads/image-1.png is now the small CAM native-loading toast (old reference image-1 overwritten).

Second report: Mechanics v1.7, game version5400, initial350sources/1,794,021bytes, no source failures/truncation.51.699s early-finished recording /51.79total; no late pass. Main v2.0 PRESENT before/after and all samples. Earlier debug-only clarification applies only to previous report; no environment-isolation failure is established.

Confirmed main problem:
- 12:45:46,47,51 callback errors ':6272: table index is nil', followed by 'Callback failed; see diagnostics'.
- Recorder main ON->OFF at29.399s with that reason, HP147/147. Later transition46.644s 'Auto Level OFF' is a distinct toggle status, not logged as the same callback error.
- Exact delivered CAM_Main_Hub_v2.0.lua line6272 is `if o:IsA("Humanoid") then C.humanoids[o.Parent]=nil end`.
- Parentless Humanoid destruction/streaming callback -> nil-key table assignment -> caught by connect -> global STOP. Other NPC/player humanoid removal can trigger it, not just chosen target.
- Main native modules all11ready; equips slot3 Tanto; native punch later active with19combo observations/23requests/5HP decrease observations. No evidence native-loading notification is an error. Other-player animation-limit warnings do not establish the root cause.
- runtimeBefore.report.log references live C.logs, causing later entries to appear in earlier-timestamped snapshot. Recorder mainTransitions/mainLogs provide chronology. Snapshot log alias also fixed.

Changes:
- cam_main_hotfix_v201.py applies reproducible patch, invoked by rework_cam_main.py before writing authoritative cam_main_logic.lua. Backup pre-patch authoritative code cam_main_v2_0_before_hotfix.lua.
- C.humanoids[model] now holds exact Humanoid, plus weak-key reverse humanoidOwners. Nil-safe removal uses cached owner, clears model/object/target/hold, ignores stale old-Humanoid callbacks if replacement is indexed. Duplicate/unindexed removal safe.
- STOP guards retained. C.lastStop preserves reason/time/pre-stop mode/quest/HP/stamina/backend; exposed in Snapshot. Named Added/Removing callback error context. Snapshot deep-copies log rows. Native module connection notice clarified.
- build_cam_main.py emits CAM_Main_Hub_v2.0.1.lua; header catalog5354/bug report5400, old standalone v2.0 preserved. No quest/combat/spending-policy change, no unsupported features added.

Final file CAM_Main_Hub_v2.0.1.lua =244904bytes; SHA256102082df51693ad8c721bf458ae6753ba0537933f939b6502ba370da2523a746.
Instructions CAM_Main_v2.0.1_Исправление.md.

Validation: installed lupa if absent; standalone syntax PASS. test_cam_main_v201.py reproduces error on original v2.0, then PASS on hotfix for nil/unindexed/duplicate callbacks, cached owner cleanup, replacement race, both model/humanoid removal orders, live target hold removal without global STOP, frozen snapshots, lastStop context, low-HP and unexpected-error guards. Original test_cam_main_v2.py suite also PASS on updated authoritative logic. Ran rework+build again and repeated both tests to verify patch is not lost by regeneration. Tests are mock/static, no live Roblox hotfix verification.

Deliver new MAIN, not another debug. Explain screenshot toast informational and actual error our own removal handler. User should unload old main, run standalone2.0.1, explicitly enableAutoLevel. No new full dump needed.
