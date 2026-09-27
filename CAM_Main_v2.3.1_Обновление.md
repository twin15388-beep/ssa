# CAM Main Hub v2.3.1 — продолжение функционала (тоже только из исходников)

Собрано поверх 2.3.0. Все протоколы извлечены статически из декомпилированных скриптов — новых записей не понадобилось.

## Auto Fishing (beta) — раздел «v2.3.1 auto fishing / quests / world»
- Полностью раскрыт протокол из `1_584_Rare_Fishing_Rod.lua` (клиент) и `002_ServerClientPortal.lua`:
  - клёв приходит по порталу: `Event:FireClient("FishingRod", "Bite", id)`;
  - ответ победы: `portal.Event:FireServer("FishingRod", id, true)` — именно то, что шлёт сам клиент.
- Заброс = нативная активация Tool `*Fishing Rod` у воды (тег `SwimParts`), без выдуманных ремоутов.
- Цикл: тоггл — авто-надеть удочку → `Tool:Activate()` → ждать Bite → через слайдер «Answer delay» (1.0 c по умолч.) отправить успех → авто-re-cast. Если клёв не пришёл за «Recast if no bite» (8 c) — повторный заброс.
- Счётчики: casts / bites / wins. STOP/выключение прерывает цикл корректно.
- Оговорка: мини-игра BarKeepup пропускается; сервер МОЖЕТ ожидать минимальное время до ответа — если не засчитывает, увеличьте «Answer delay».

## Quest / prompt helpers
- «Advance delivery/collect quest»: по декомпилированным `029/030/031` шлёт `QuestProgress(questKey, taskId)` ТОЛЬКО для квестов, чей `RequiredItem` реально лежит в вашем инвентаре (Amount ≥ 1). Сервер перепроверяет дистанцию/предмет. Без предметов — тихий отказ, не фейк-недж.
- «Activate nearest world prompt»: очереди/волны/данжи/тренер/порталы в этой игре — ProximityPrompt-объекты (отдельных ремоутов в дампах НЕТ). Кнопка зажимает ближайший валидный prompt в досягаемости (с нативной проверкой LoS/дистанции).

## NPC interactions (встаньте рядом с NPC)
Прямые безпараметровые ремоуты из дампов (подтверждаемые кнопки там, где это трата/дача):
- Gauntlet statues: begin / Gauntlet statue: give schematic
- Wagasa: give schematic
- Muzan: give bell
- Take Foxfire, Retsu: tell Foxfire
- Isao: take toll, Sofen: pull ledger, Liv: gamble (подтверждение!), Dismiss crow, Cleaver duel
- WarFans: submit clue #1–4 (дропдаун номера)

## Расследование «claims» — честный вердикт
- «Infinite stamina»: значение `Stamina` живёт в серверной реплицированной папке `Values` (`014_StaminaComponent`), клиентское присваивание не реплицируется и затрировをётся resync'ом. Полоса на экране — только визуал. Нет ни одного client→server протокола для стамины. **Отклонено.**
- «Instant kill без лута/exp»: боевой урон считается на сервере (`111_CombatBalance` — файл разрешения синергий, не протокол). Клиентских путей нет. **Отклонено.**
- «Code redeem»: во всех дампах нет ни одного code/Redeem-протокола (значение `Code` = алиас квест-трекера, не промокод). Если в игре есть кодовый UI — пригода probe-запись, см. список ниже.

## Осталось слепо (для этого и нужен ОДИН короткий debug)
1. **Skill-tree spend args** — единственное, чего нет в исходниках (UI дерева не сдамплен).
2. (опционально) **Код-редеем** — проверить, есть ли вообще какой-либо ремот.
Остальное покрыто.

## Debug-лист под probe v1.1 (один сеанс, ~2 минуты, НЕ нужны прошлые повторы)
1. Запустить `CAM_Debug_ActionProbe_v1.1.lua` → **1) ATTACH** один раз.
2. На сценариях нажать **«Skill tree: unlock ONE node now»** (маркер).
3. **2) START** → в дереве навыков нажмите **START у любого доступного узла** (разблокировка 1 узла) → **STOP**.
4. (опц.) если есть работающий код: START → ввести код в код-UI → STOP.
5. **EXPORT & COPY** → прислать JSON. Спай `__namecall` в 1.1 поймает прямой `FireServer/InvokeServer` с первыми аргументами — этого хватит.

## Файл/проверки
- `CAM_Main_Hub_v2.3.1.lua` — 277 482 байт, Lua 5.4 syntax PASS.
- `test_cam_main_v230.py` — 5/5; `test_cam_main_v231.py` — 5/5 (fishing-цикл, npc-акшены, quest-progress, prompt, структура); `test_cam_main_v2.py` — регрессия зелёная.
- В моках проверено: каст через EquipTool+Activate, запрет двойного каста при ожидании, `FireServer("FishingRod", id, true)` после delay, цикл re-cast после успеха.
