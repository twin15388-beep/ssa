# CAM Main Hub — workspace

Standalone Lua hub (lumen UI) for Roblox place `136406881576517`, pasted whole into the executor (Delta mobile).
Russian project notes live in `HANDOFF_Архив_CAM_Main_Hub.md` (context / rules) and `CAM_Main_vX.Y.Z_Обновление.md` (per-version changelog).

## Layout
- `cam_main_logic.lua` — hub logic (single closure `StartCAMHub(Lumen)`); patched via `cam_main_feature_vXYZ.py` scripts (exact-replace + assert).
- `build_cam_main.py` — bundles lumen lib + catalog + logic into `CAM_Main_Hub_v<VERSION>.lua` (current: **3.3.0**).
- `cam_catalog.lua`, `cam_boss_names.lua`, `portable_json.lua` — embedded data / helpers.
- `test_cam_main_v*.py`, `test_main_hub.py`, `test_farm_features.py` — lupa (Lua) mock suites. Active: v230, v231, v240, v250, v330 + `test_main_hub.py`, `test_farm_features.py`. Legacy (pinned to old versions, fail by design): v201, v210, v220, `test_cam_main.py`.
- `uploads/` — user sources (working script `Текстовый документ (3).txt` = protocol source of truth; lumen lib `(5).txt`).
- `new_game_analysis/` — game decompiles (`core_sources/`, `readable/`, `overview_received.json`).

## Build & test
```bash
pip -q install --break-system-packages lupa
python3 build_cam_main.py            # -> CAM_Main_Hub_v3.3.0.lua, prints "Standalone syntax PASS"
for t in test_cam_main_v230.py test_cam_main_v231.py test_cam_main_v240.py test_cam_main_v250.py test_cam_main_v330.py test_main_hub.py test_farm_features.py; do python3 $t; done
sha256sum CAM_Main_Hub_v3.3.0.lua
```
Rules of the project (no fake packets, honest UI statuses, one Unload in settings, no death/STOP-ALL shutdowns, manual-only spending) are listed in the handoff document.
