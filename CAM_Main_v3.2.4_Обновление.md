# CAM Main Hub — v3.2.4

Файл: **`CAM_Main_Hub_v3.2.0.lua`** (standalone, вставляется целиком в исполнитель).

## v3.2.4 (патч: бой по схеме рабочего скрипта; Farm speed до 300)
- **Дефолтный Attack mode = «Fast Attack (Combat_Service)»** (протокол рабочего скрипта), «Hold M1 (native)» остаётся опцией.
- **Бой больше не гейтится на ack экипа**: принадлежность оружия проверялась через `Get_equipped_tool` и в игре могла не подтверждаться — фарм застревал на «Preparing weapon» и ни одного пакета удара не уходило. Теперь каналы рабочего скрипта: `Toolbar_Equip` → слот → `Item_Equip` → подождали 1.5с → дерёмся в любом случае (с пометкой в лог).
- **Тайминги удара 1:1 из рабочего скрипта**: `interval/attackSpeedMult` с полом 0.12, следующий апакет `interval*0.92`; анимация `Swing_<combo>` с той же цепочкой папок (`<override>_Combat_Anims` → `<combat>_Combat_Anims` → `Combat_Combat_Anims`).
- **Farm speed max = 300** (было 150), дефолт = 120. Classic Tween speed — как было (до 400).

## v3.2.3 (патч: движение фарма не упирается в стены)
- **Mover стал every-tick, маленькими шагами** (как в рабочих скриптах: позиция задаётся каждый heartbeat, без больших скачков). Раньше шаг был раз в 0.1 с по 2–40 стадов — сервер относил персонажа назад между шагами, а проходя мимо стены шаг мог закинуть в геометрию, откуда сервер нас выталкивал. Теперь шаг = `farmSpeed*dt` (при ~60 fps это ~1 стад на тик со скоростью 60), скорости (AssemblyLinear/Angular) обнуляются каждый тик — сервер видит непрерывную, согласованную позицию.
- **Watchdog стопа**: если позиция почти не меняется 0.75 с (нас стопает/относит назад) — раз в секунду делается прямой snap на целевую точку (behind/near the target), в лог пишется «movement stall».
- Noclip фарма как был — каждый тик гасится коллизия у частей персонажа; основное движение теперь не зависит от коллизии, т.к. идёт через маленькие CFrame-шаги.

## v3.2.2 (патч: сигнальный ремоут — живой Event, как в рабочем скрипте)
- Корневоe отличие от рабочего скрипта: там сигнул идёт не через require-модуль, а через **живой `RemoteEvent` `SignalEvent/Event`** (`ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent:WaitForChild("Event")`) с прямым `FireServer`. Наш лоадер пытался `require` путь и молча падал (в игре это не ModuleScript) — все удалённые действия (удар, экип, Tool_Mouse) в игре тихо не отправлялись, в моках же проходили. Это и было «ничего не бьёт».
- `loadNative` теперь: если модуль SignalEvent не резолвится — находит `SignalEvent/Event` напрямую (RemoteEvent/UnreliableRemoteEvent) и подменяет `C.modules.Signal` обёрткой `{ToServer=...->evt:FireServer(...)}`. Весь код хаба уже зовёт `sig.ToServer(...)`, так что удар/экип/клик больше не зависят от require.
- Мок-проверка: облом require + живая папка с Event → фарм отправляет ремоуты (новый PASS).

## v3.2.1 (патч: удар/экип по каналам рабочего скрипта)
Инфо вытащена из твоего рабочего скрипта (документ 3) — оттуда факты, а не догадки:
- **Hold M1 теперь идёт через ремоут самой игры `Tool_Mouse Down/Up`** (сигнал `Tool_Mouse` + позиция корня — именно так рабочий скрипт жмёт клики, напр. при зельях). `mouse1press`/`VirtualInputManager` — только запасной вариант, если нативные модули не подключены. В прошлых версиях hold-стили через клиентские API мыши у сервера ничего не взвешивали.
- **Экип — через настоящие ремоуты**: как в рабочем скрипте — `Toolbar_Equip(name,id)` (если оружие лежит в инвентаре, а не на тулбаре), потом `Equipped` слот + прямой `Item_Equip(slot)`. Раньше мы только выставляли `Items_Config.Equipped` и надеялись на HUD-слушателя — у тебя сервер так и не видел экипа, оружие не доставалось.
- **Свинг-анимация локально проигрывается перед каждым Combat_Service** (Swing_<combo> из `Assets.Animations.*_Combat_Anims`, со Speed-presets — как в рабочем скрипте; смотрелка не ломает отправку даже при аномалиях).
- Мелкий фикс: в канале Tool_Mouse упрятывался лишний аргумент self (двоеточие) — убрано.

## v3.2.0 — сбалансированная сборка: весь функционал назад + фарм, который бьёт

Назад возвращено всё, что было до обрезающей чистки; улучшения, внесённые по запросам, сохранены.

### Сохранены улучшения (fast-ветка 3.1.x)
- **Прямой фарм** (scan Regions → подход пошаговым телепортом → оффсет позиции → **Hold M1**, который бьёт; fallback `VirtualInputManager`; пропуск защищающихся целей), **Auto Boss** по 33 именам.
- **Фарм сам надевает оружие** (ensureEquipment на каждом тике до удара) + выбор Weapon (Auto combat tool / Keep equipped / Slot 1–5).
- **Settings кнопка** (полноценная страница lumen: меню/APPEARANCE/CONFIGS/THEME) — есть.
- **Dashboard выкинулся** и не возвращается.
- **Unload одна, в settings** — надёжная, с pcall; наших дублей нет.
- **Функции не гаснут при смерти** (сбрасывается только цель фарма); STOP ALL/End убраны — функции выключаются тем же тогглом.
- NZL-демо-блок библиотеки вырезан: нет водяной полосы, приветственного тоста, лишнего окна; тень окна убита тройным засовом.

### Восстановлено (classic-ветка, на farm-вкладке отдельными секциями)
- **Classic engage (native input path)**: Target mode (Selected mob/boss/Nearest hostile), выпадающие списки мобов/боссов из каталога, Count loaded hostile targets, **Auto Farm - selected / nearest (classic)** — старый проверенный путь (goTo позиция + родной punch), **Auto M1 (no movement)**, кнопка **M1 once**.
- **Classic position / movement**: Farm position (Above/Below/Behind/In front/Left/Right/Orbit/Ground), Travel method (Tween/Instant/Walk), Look at target, Classic distance, Tween speed, Orbit speed, M1 range, M1 interval, STOP at HP %, no-damage timeout, M1 input backend.
- **Skills → auto skills / native scheduler**: Auto Skills (переключение), 10 слотов `Skills_1st..10th` отдельными тогглами, интервал использования, длительность холда, дальность.

### Размещение
- **farm** (main): прямой фарм + Attack mode + Weapon (слева); hub (Connect) + auto potion + priority + classic engage (справа); classic position / movement (слева, под прямым фармом).
- **auto level** (gameplay) — на месте со списком 17 маршрутов.
- Остальные вкладки (quests / loot / movement / ESP / diagnostics / combat / skills) без изменений.

## Мерки сборки
- Размер: 406 315 байт.
- SHA-256: `ebddc4d943dd8ee19dcb09f596d2e2e872c4ce193ceea317ede80a6361827f99`
- Каталог: 47 NPC (33 босса), 18 квестов.

## Тесты (мок, lupa)
- v250: 16 PASS, включая direct farm (подход + Combat_Service в Fast Attack режиме), hold M1 (зажим/отпуск), boss-mode игнор мобятов, стрип демо-блока.
- v240 / v231 / v230: все PASS (rapid M1, fishing, quest/npc actions, parry/training/shop).
- mock/static only; серверные лимиты игры на живой не проверялись — честные подписи в UI.
