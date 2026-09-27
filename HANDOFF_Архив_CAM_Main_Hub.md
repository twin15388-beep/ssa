# АРХИВ КОНТЕКСТА — CAM Main Hub (Roblox), передача новому чату

> **Инструкция для нового чата:** перед любым ответом сначала напиши, какая ты модель/агент, и что этот архив прочитан. Ничего из изложенного не выдумывай.

---

## 1. Суть

Пользователь ведёт разработку **standalone Lua-скрипта CAM Main Hub** для Roblox-игры **place 136406881576517** (игра «CAM» / Project Slayers-подобная, НЕ старая NZL). Скрипт вставляется целиком в исполнитель (executor) без loadstring/HTTP. Цель: рабочий авто-фарм мобов/боссов (подход + настоящие удары) + автолевел по квестам + сопутствующее хозяйство (combat assist, ESP, лут/рыбалка/магазин) в **штатном UI lumen-библиотеки** пользователя.

**Текущий приоритет №1: авто-фарм в игре всё ещё не наносит урон** («не бьёт»), хотя подход к цели есть. Серия именно-канальных фиксов по контракту рабочего скрипта пользователя (документ 3) частично сделана — последний билд не подтверждён в игре.

**Исполнитель пользователя — Delta (мобильная сборка)**: на нём клиентские API мыши (`mouse1press`, `VirtualInputManager:SendMouseButtonEvent`) сервером не принимаются; `getsenv` поддержка тоже под вопросом. Поэтому клик идёт через ремоут игры `Tool_Mouse`.

## 2. Важные детали

### Источники (workspace `/home/user/uploads/`)
- **`Текстовый документ (3).txt`** — РАБОЧИЙ скрипт пользователя для ЭТОЙ игры. Источник истины по протоколам:
  - Сигналы: `ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent:WaitForChild("Event")` — **живой RemoteEvent**, вызов прямым `SignalEvent:FireServer(...)` (SignalEvent — папка, НЕ ModuleScript).
  - Удар: `SignalEvent:FireServer("Combat_Service", combatName, combatCombo, false, serverHitDelay, false, overrideName)`.
  - Тайминги (getCombatTiming): `serverHitDelay=max((hitDelay-swingDelay)/attackSpeed,0)`, `attackInterval=max(attackInterval/attackSpeed,0.12)`, дальнейший апакет `attackStartedAt+attackInterval*0.92` (`combatLeadFactor=0.92`).
  - Анимация перед ударом локально: `Swing_<combo>` из `RS.Assets.Animations.<overrideName>_Combat_Anims` → `<combatName>_Combat_Anims` → fallback `Combat_Combat_Anims`; скорость = `preset.AnimSpeed[combo or Default]*attackSpeedMult`.
  - Экип: `FireServer("Toolbar_Equip", itemName, itemId)` → wait 0.2 → `Items_Config.Equipped=slotIndex` → `FireServer("Item_Equip", slotIndex)` → wait 0.15; **без ожидания ack**.
  - Клик (напр. зелья/сбор): `FireServer("Tool_Mouse","Down",rootPos)` / `("Up",rootPos)`.
  - Защита цели: attr `NpcCounter` 1/2, ребёнок `NpcCounterTriggered`, `Values.Blocking` без `PierceBlock` — таких пропускать.
  - Позиция фарма: оффсетный CFrame (Above/Below/Front/Behind), up-вектор переворот для над/под; `moveNearTarget` — твин/снап + обнуление AssemblyLinear/AngularVelocity.
- **`Текстовый документ (2).txt`** — большой рабочий хаб другой игры (Obsidian Master Hub): идеи zero-desync (позиция каждый heartbeat, velocity=0), authentic M1-комбо, noclip через каст отключения коллизий.
- **`Текстовый документ (5).txt`** — UI-библиотека **lumen** (использует дефолт → Stripe блок demo в конце файла!).
- `new_game_analysis/` (core_sources, overview_received.json) — статический декомпайл игры; `037_ActiveNpcs` и т.п. => каталог NPC/квестов.
- test_main_hub.py — фикстура lupa (Lua 5.5) с мок-Roblox; `_buttons/_toggles/_sliders` бриджи, `Slider/Dropdown/Textbox` = тогл-стабы (`_toggles[d.Name]=d.Callback`).

### Критические технические решения и баги (по порядку «как было найдено»)
1. **Тень окна lumen**: `Window.Items.Shadow` (3 чёрных слоя-фрейма) синхронится по сигналам Main; одиночное Visible=false и прозрачность фона не хватало → фикс: прозрачности Background+Image для всех комдеривов, обнуление Size, вотчер по Visible-сигналу + повтор в каждом фарм-тике heartbeat.
2. **Демо-блок lumen портили заметки**: бундл содержал `--#region example` (NZL Studio): водяная полоса сверху, демо-окно, welcome-тост, keybind-list — прелоадовый мусор, который НЕ закрывался нашим меню. Убрано в build_cam_main.py (обрезка от `--#region example` до конца; `Watermark("NZL Studio")` убран из библиотеки. `Lumen:Init()` (авто лоад конфигов/тем) вызываем сами после `Lumen:Window(...)`.
3. **Settings кнопка**: в `Lumen:Window` убрали `SettingsPage=false` строчкой (есть встроенная страница: menu/appearance/configs/theme).
4. **Unload одна**: свою «Unload hub» с farm-страницы убрали; осталась встроенная lumen (settings → «unload ui»). `Lumen:Unload` обёрнут pcall+warn при ошибке.
5. **STOP ALL/End убраны**; функции выключаются тем же тогглом; внутренний `stopAll(...)` оставлен для low-HP и ошибок. Бонус: `Env.CAMMainHub.StopAll` экспортирован для тестов.
6. **Смерть не выключает**: CharacterRemoving/Added сбрасывают только цели/кэши (C.farmTarget, fatk.combo); тогглы живут.
7. **Оружие**: `ensureEquipment()` — из nargs-будущего паттерна рабочего скрипта: если в тулбаре нет боевого — `Toolbar_Equip(name,id)`; далее `Equipped=slot` + прямой `Item_Equip(slot)`; **никакого hard-gate по `Get_equipped_tool`** — таймаут 1.5 сек и дерёмся (этот gate убил бои ранее: вечное «Preparing weapon»).
8. **Signal remote**: `loadNative()` если `require(SignalEvent)` не дал table — резолвит `Signals/SignalEvent/Event` (RemoteEvent/UnreliableRemoteEvent) и подменяет `C.modules.Signal={ToServer=...}`. Это самый важный живой баг-факт: в игре SignalEvent — папка с Event.
9. **Движение фарма (v3.2.3)**: каждый heartbeat шаг `farmSpeed*dt` (не реже; dt-кап 0.2с); velocity обнулить; вкуп ≤1 — снап; watchdog: <0.6 studs за 0.75с → snap раз в секунду на целевую CFrame + log «movement stall». Раньше были 0.1с-шаги по 2–40 стадов — сервер относит назад/в стены.
10. **Tool_Mouse hold**: `m1Down/m1Up` — сначала `C.modules.Signal` ↦ `ToServer("Tool_Mouse","Down"/"Up",root.Position)`; fallback mouse1press/mouse1release затем VIM. Отпуск: цель сдохла/догла/защищается/тоггл выкл/unload/stopAll.
11. **Fast Attack (Combat_Service)**: `C.fatk.combo` 1..Max, `C.fatk.next` гейт `interval*0.92`; пакет `pcall(sig.ToServer,"Combat_Service",combo...)`.

### Структура UI (lumen)
Страницы (sitebar группы): **main: farm** (слева: прямой фарм + Attack mode + Weapon + classic position; справа: hub(только Connect native controls + подпись куда unload) + auto potion + priority + classic engage) · **gameplay: auto level, quests / boss hunts, loot / interaction** · **utilities: movement / teleports** · **visuals: ESP / notifications** · **system: diagnostics / limits** (live status + другой report + pending) · **action: combat, skills (+ auto skills/scheduler на side2)***. Кнопка settings — встроенная, внизу сайдбара.

Восстановленные классические элементы на farm: Target mode (Selected mob/boss/Nearest hostile), списки мобов/боссов из CAM_CATALOG, «Count loaded hostile targets», «Auto Farm - selected / nearest (classic)» (кей `farm`), «Auto M1 (no movement)» (кей `attack`), кнопка «M1 once», позиция/ход: Above/Below/Behind/In front/Left/Right/Orbit/Ground; Tween/Instant/Walk; lookMode; sliders farmDistance/travelSpeed(10-400)/orbitSpeed/hitRange/attackDelay/healthStop/noDamageTimeout/inputMode.
Skills-авто: toggle «Auto Skills (selected input slots)» (key `skills`) + 10 слотов `skillSlot1..10` + sliders skillDelay(0.25-5)/skillHold(0.01-1)/skillRange(10-200).

Слайдерные/тогл ключи (State `S`): `autoFarm,autoBoss,farmMobText,farmStyle(Behind),farmDist(6),farmHeight(7),farmNoclip(true),farmSpeed(120),searchRange(300),m1Mode="Fast Attack (Combat_Service)" (def),weapon="Auto combat tool",autoPotion,potionHp(35),potionDelay(6),potionChoice,culprit... skillSlots={}`.

### Каталоги
- `CAM_CATALOG` (cam_catalog.lua → встраивается в бандл): 47 NPC (33 босса `[name]=true`), 18 квестов (level/npc/code/count/targetPosition). boss list имя-индексируется CAM_BOSS_NAMES.
- Целевые коды: `S.mobCode="KaruVillageBandit"`, `S.bossCode="Zuko"` дефолт.

## 3. Что уже известно / сделано

- Выдвинут бандл **CAM_Main_Hub_v3.2.4.lua** = 406 315 B, SHA-256 `ebddc4d943dd8aee б19dcb09f596d2e2e872c4ce193ceea317ede80a6361827f99` (точно: в файле записано как ebddc4d943dd8ee19dcb09f596d2e2e872c4ce193ceea317ede80a6361827f99; из sha256sum). Сборка `python build_cam_main.py` (VERSION в файле), lupa нужна (сайт-пакеджи НЕ входят в снапшоты — всегда `pip -q install lupa` перед сборкой).
- Тесты (mock): v250 (17 PASS), v240/231/230 (+ счетные PASS), v2.py урезан до фикстуры (содержит вехч marker `assert lua.eval('_requireCalls')==0`, дальше api `_stop()=CAMMainHub.StopAll()`).
- Пользователь прогонял в игре избранные версии: 3.0.0 (UI ок, тень), 3.1.x (были правки), 3.2.x — «все ломалось/эго стопят/не бьёт». Реальный урон НЕ подтверждён ни одним лайв запуском.

## 4. Что нужно сделать дальше

1. **Получить от юзера статус-трейс** из diagnostics (local report → COPY) после попытки фарма на любом мобе: там видно этапы (Signal ready?, equip, Tool_Mouse/Combat_Service sends) — чтобы понять, доходят ли пакеты.
2. Возможные следующие причины «удар не засчитывается» при доходящем пакете:
   - серверный чек предполагает локальную анимацию/состояние `Combat_presets.Last_Punched/Last_Combo` — выставлять их рядом с FireServer (в v2.4.1 для rapid M1 уже патчим presets таблицу: `Last_Punched`, `Last_Combo`, `combo_duration`, скорости swing);
   - Delta-мобильный executor может не выполнять `require` внутри `task.spawn` (loadNative асинхронный) — держать в голове sync-path;
   - убедиться что `C.modules.Items/Info/CombatPresets` резолвятся в лайве (нет логов «module … missing»);
   - проверить, что `resolveCombatPreset` в лайве даёт заполненный `preset` (без него no fire — возврат "No preset"); писать это в S.status для видимости.
3. При подтверждении удара — лупить версионирование/заметки и довести босс-режим/автолевел до такой же канальной чистки.
4. Всегда держать общий принцип: «нет фейк-пакетов — только каналы рабочего скрипта пользователя».

## 5. Риски/неясности

- Серверная регистрация ударов проверяться статически НЕ может; моки это скрывают.
- Возможна анти-чит фича: сервер откидывает Combat_Service без реального input accumulator (нужен их локальный `Checker` таблица — в моке `_mods.Combat_presets` мы фейкаем).
- Польз. склонен считать任何一个 пустышку «все сломалось» — при плохом сигнале не удаляйте существующие функции, а делайте режимы/опции (Dropdows) и честные статусы.
- Люмен-стейты могут сохранятся от прошлых запусков (autoload config) — при диком поведении UI попросить вырубить autoload или удалить конфиги.
- lupa не персистится между снапшотами — build ломается ModuleNotFoundError, лечить `pip -q install lupa`.

## 6. Файлы workspace (важное)

- `cam_main_logic.lua` — исходник логики (движок + UI build; ровно то, что идёт в бандл);
- `build_cam_main.py` — сборщик (режет lumen demo, версии, `getgenv().CAMMainLumen`, русские замены, sha не считает);
- `CAM_Main_Hub_v3.2.4.lua` — последний доставленный бандл + файлы-заметки `CAM_Main_v3.2.4_Обновление.md`;
- `test_cam_main.py` (legacy), `test_cam_main_v2.py` (фикстура), `test_cam_main_v{230,231,240,250}.py` (наборы), `test_main_hub.py` (базовый мок; в нём Lumen-стаб и `_obj/_path/_add` примитивы);
- `cam_catalog.lua`, `cam_boss_names.lua` (генерируются билдером);
- `uploads/` — документы 1/2/3/5/lumen + скрины пользователя; `new_game_analysis/` — статический экстракт.

## 7. (Правило для нового чата)

**Перед всей информацией в новом чате пиши какая ты модель/агент.** Формат: «Я — <имя модели> (платформа …). Архив прочитан.» Это правило пользователя, применяется первым сообщением в новом чате.

### Hard constraints пользователя (обязательные)

- Русский язык общения, коротко и по делу.
- Без фейковых функций/пакетов — всё подписывать честными статусами в UI («Mock/static only …» футер в тестах тоже).
- Clipboard/copy — с согласия не делаем без запроса (старые отказы были приняты).
- Никаких авто-трать циклов (валюта/поинты) — только явные клики-кнопки.
- «Insta kill»-отказ пользователь отклонил: instant kill остаётся как есть: network-owned мобы, порог HP% (по умолчанию 25).
- Не выключать функции при смерти персонажа.
- Не трогать серверные способы (никаких заявлений на обход серверных лимитов в UI).
- Одна кнопка unload (настройки), settings-кнопка обязательная, dashboard отсутствует, отсутствие STOP ALL и End-hotkey.
- При крупных правках: сначала точечные патчи через python exact-replace с assert; версия бампается (строка в logic + `VERSION` в builder + иглы в test_cam_main_v*), тесты запускать ALL, sha256sum фиксировать, заметки `CAM_Main_vX.Y.Z_Обновление.md` обновлять, новый файл презентовать.
