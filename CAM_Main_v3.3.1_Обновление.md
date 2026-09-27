# CAM Main Hub — v3.3.1

Файл: **`CAM_Main_Hub_v3.3.1.lua`** (standalone, вставляется целиком в исполнитель; без loadstring/HTTP).
Размер: **424 722 байт**, sha256: **`37ac1635ef66bcaa9c1d462d11fc843da424ddc45cef429b1a69fa269235bf8c`**.

## v3.3.1 (досягаемость хитбокса + канал Combat_Service для классического пути + баг stopAll)

- **Факт из общего модуля `Combat_presets.Get_Players_For_Combat`** (его же считает сервер): при обычном ударе стоя хитбокс — коробка
  `(6+W) × (6.25+W) × (9+D)` стадов, **центрированная на игроке** (1 стад ниже корня) и сдвинутая вперёд только на `Reaches`
  пресета (у кулаков `Combat` их нет, у катан `Reaches=1`). Вперёд она достаёт ≈ `4.5 + 1.25·Reaches` стадов → **кулаки ≈ 5,
  катаны ≈ 6 стадов до корня цели**. Дефолт прямого фарма был **6 стадов «Behind»** — для кулаков это уже вне коробки, для
  катаны впритык. Это очень вероятная причина «подходит, но не бьёт» (особенно если оружие не надевалось и бой шёл кулаками).
  - Дефолты: **Distance 6 → 4**, **Farm height 7 → 5**. Сохранённый конфиг lumen может держать старые значения — смотри строку `Farm:`.
  - Статус честно предупреждает: `dist 9.0 > hitbox reach~5.0 (lower Distance / height)`; удар при этом всё равно отправляется (решает сервер).
  - В отчёте: `farm.direct.hitboxReach`.
- **Классический путь (Auto Level / classic farm / Auto M1 / Kill Aura) получил бэкенд «Combat_Service (direct)»** (по умолчанию):
  тот же канал рабочего скрипта, что и прямой фарм (свинг‑задержка, комбо, best‑effort оружие без блокировки). Старые
  «Auto (live punch / native input)» и «Native input only» остались в списке. На Delta `getsenv`/VirtualPress сервером не
  принимаются — поэтому дефолт сменён. Единственная остановка на этом бэкенде — явный слайдер «STOP after no target damage»
  (в причине теперь указаны `sent`, дистанция и reach).
- **Баг `stopAll` (с 3.2.x)**: внутри `stopAll` стояло `pcall(actions.m1Up)`, а таблица `actions` объявлялась ниже → каждый
  вызов `stopAll` (смерть в 3.2.4, low HP, ошибка колбэка, StopAll из диагностики) падал с
  `attempt to index a nil value (global 'actions')` посреди очистки: тогглы уже выключены, а движение/полёт/промпты не
  восстанавливались. Исправлено forward‑declaration; воспроизведено моком на 3.3.0 (падало) и 3.3.1 (чисто).

### Что проверить в игре
1. Auto Farm ON у моба, **Distance 4** → строка `Farm:` без предупреждения `> hitbox reach`, `sent` растёт, HP моба падает?
2. Если не падает — прислать строку `Farm:` (там теперь и дистанция, и reach) + отчёт.
3. Auto Level / Auto M1: бэкенд по умолчанию Combat_Service (direct) — статус в главной строке.

### Проверки
- `python3 test_cam_main_v331.py` — 7 PASS (дефолты; классический Auto M1 шлёт Combat_Service без punch/VirtualPress; legacy
  бэкенд на месте; подсказка reach при Distance 9 и её отсутствие при 4; Kill Aura на прямом канале; структура сборки).
- `test_cam_main_v330.py` 14 PASS, `v250` 17 PASS (тест Kill Aura явно выбирает punch‑бэкенд), `v230/231/240`, `test_main_hub.py`,
  `test_farm_features.py` — PASS. Legacy `v201/210/220`, `test_cam_main.py` — падают как и раньше (старые версии UI).
- Mock/static only: приём `Combat_Service` сервером моками не проверяется.

## v3.3.0 (фарм‑бой перестроен 1:1 по рабочему скрипту + честный живой статус)

Что выяснилось при сверке хаба с рабочим скриптом (документ 3) и декомпилами игры (`readable/2_75_Combat.lua`,
`Main_Combat_Script_Client`, `core_sources/003_Combat_presets.lua`, `oneclick_sources/013_Toolbar.lua`):

- **`SignalEvent` в игре — ModuleScript с дочерним `Event` (RemoteEvent)**, а не «папка», как считалось в 3.2.2. Оба пути
  (require‑модуль и живой `Event:FireServer`) заканчиваются одним и тем же ремоутом. Хаб теперь **сначала** берёт живой
  `SignalEvent/Event` (канал рабочего скрипта), require — только запасной путь. Какой канал реально используется — видно в
  диагностике (`farm.direct.signalPath`).
- **Свинг‑задержка.** Клиент игры и рабочий скрипт шлют `Combat_Service` **после `delay_before_swing`** пресета (у Combat это
  0.2 с), а хаб слал сразу. Сервер сверяет тайминги (`get_combat_cd_info`: `last_cmbat`/`last_combo`), поэтому добавлен
  выбор **Attack timing**: «Game client (swing delay)» (по умолчанию, как игра) / «Instant (no swing delay)» (как было).
- **Комбо‑синхронизация.** Сервер принимает удар только если `combo == last_combo+1` (или 1 после таймаута
  `combo_duration`/финала). Если атрибут `last_combo` виден клиенту (персонаж/Player), хаб при расхождении пересылает
  правильный номер (счётчик `comboResyncs`, лог «combo resync»). Если атрибута нет — работает прежний локальный счётчик.
- **Оружие больше не блокирует бой.** Раньше фарм мог зависнуть на «Preparing weapon / Waiting for equipment acknowledgement»
  и не ударить ни разу. Теперь `prepareWeapon()` — best effort: `Item_Equip` раз в 2 с (после 3 попыток — раз в 10 с),
  `Toolbar_Equip(name,id)` раз в 3 с если оружие только в инвентаре, и **бой идёт в любом случае** текущим инструментом
  (кулаки «Combat» — тоже боевой пресет). Порядок как в рабочем скрипте: `Items_Config.Equipped = слот` → `Item_Equip(слот)`.
- **Синхронная подгрузка модулей для фарма.** На Delta `require` внутри `task.spawn` не гарантирован — фарм теперь сам
  дотягивает `Combat_presets`/`Items`/`Character_info_provider` прямо в тике (раз в 3 с на модуль), лог «loaded (sync path)».
- **Классический путь (`ensureEquipment`)**: модули ограничений (`ToolbarItemRestrictions`, `ItemRequirements`) стали
  необязательными — без них решает сервер, фарм не замирает.
- **Защищающаяся цель**: проверка `Blocking`/`PierceBlock` теперь и в `Player_Service.Values[<имя>]` (как
  `Utility.getvaluesfolder`), не только в модели.
- **Удар только в радиусе** `max(Farm distance+8, 12)` стадов и не по защищающейся цели; сервер бьёт хитбоксом от позиции
  игрока, так что стрелять пакетами издалека бессмысленно — это отдельно видно в статусе («approaching»).
- **Hold M1 честно подписан**: `Tool_Mouse Down/Up` — канал активации инструмента (зелья/удочка), **мечи им не машут**
  (013_Toolbar шлёт его только для инструментов с серверным обработчиком мыши). Опция оставлена, по умолчанию Fast Attack.

### Ничего больше не гасит все тогглы
- **Смерть**: раньше в heartbeat стоял `stopAll("Death: all toggles OFF")` — вопреки правилу «функции не выключать при смерти».
  Теперь при смерти сбрасываются только цель/комбо/движение, статус: «Died: toggles stay ON, waiting for respawn», после
  респавна фарм продолжает сам.
- **Ошибка в колбэке** (напр. один странный объект в `workspace.DescendantAdded`) — считается и логируется
  (`farm.callbackErrors`, `farm.lastCallbackError`), автоматизация продолжает работать. Стоп только при лавине
  (≥30 ошибок за 10 с) — с текстом причины.
- **Ошибка кнопки** — уведомление + лог, без остановки всего.

### Живой статус фарма (для отладки «не бьёт»)
- На странице фарма новая строка **`Farm: …`**, обновляется раз в секунду:
  `Farming <моб> <дист>st HP <hp> | Combat_Service Combat c3 | sent 17 | srv combo 2 | weapon: Tanto`
  или причина простоя: `approaching`, `target defending - holding`, `swing pending`, `pacing 0.11s`,
  `Combat_presets not loaded (…)`, `Signal remote missing (…)`, `No farm target within 300 studs (…)`.
- Тот же текст — в главном статусе, когда включён только прямой фарм.
- Кнопка **«Attack once (Combat_Service probe)»** — один удар текущим пресетом без включения фарма (подойди к мобу вплотную,
  смотри на него): если HP моба не падает при `sent 1` и без причины в статусе — проблема на стороне сервера/пресета, и это
  уже видно без долгих тестов.
- Диагностический отчёт: `farm.direct = {status, attackMode, attackTiming, weaponMode, equipment, combatServiceSent,
  skippedDefending, comboResyncs, lastCombat, lastReason, signalPath, serverLastCombo, farmTarget}` + `callbackErrors`.

### Что проверить в игре (в таком порядке)
1. Auto Farm ON рядом с мобом → строка `Farm:` должна дойти до `Combat_Service Combat c1… | sent N` (N растёт).
2. Если `sent` растёт, а HP моба не падает: переключить **Attack timing** на «Instant» и обратно; посмотреть `srv combo`
   в статусе (если есть) и `lastReason` в отчёте; прислать строку статуса + отчёт.
3. Если `sent` не растёт — причина написана прямо в строке статуса (модуль/ремоут/дистанция/защита).
4. «Attack once» вплотную к мобу — самый короткий тест канала.

### Проверки
- `python3 test_cam_main_v330.py` — 14 PASS (свинг‑задержка и точный порядок аргументов `Combat_Service`, instant‑режим,
  синхронный путь модулей без task.spawn, `Item_Equip` один раз, `Toolbar_Equip` из инвентаря без блокировки боя,
  отсутствие модулей ограничений, смерть не гасит тогглы и фарм возобновляется, ошибка колбэка считается без stopAll,
  защита NpcCounter/Values.Blocking, ресинк комбо по `last_combo`, «Attack once», живой RemoteEvent, структура сборки).
- Старые наборы: `test_cam_main_v230/231/240/250.py`, `test_main_hub.py`, `test_farm_features.py` — PASS
  (в v250 тесты 10/12 теперь дренируют `task.delay`, т.к. пакет уходит после свинг‑задержки).
- `test_cam_main_v201/210/220.py`, `test_cam_main.py` — legacy‑наборы под старые версии, падали и до 3.3.0 (не регресс).
- Mock/static only: **приём `Combat_Service` сервером (реальный урон) моками не проверяется** — только в игре по строке статуса.

### Сборка
`pip -q install --break-system-packages lupa && python3 build_cam_main.py` → `CAM_Main_Hub_v3.3.0.lua` (Standalone syntax PASS).
Патч логики воспроизводим: `cam_main_feature_v330.py` (exact‑replace с assert поверх `cam_main_logic.lua` версии 3.2.4).
