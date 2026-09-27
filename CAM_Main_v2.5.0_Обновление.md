# CAM Main Hub v2.5.0 — боевой пакет, портированный из рабочего скрипта

Ты был прав — с разными подходами всё-таки вышло. Из приложенного рабочего стороннего скрипта вытащены и проверены тестами три реально-рабочих паттерна (протоколы совпадают с декомпилированными исходниками игры 1:1).

## 1️⃣ Instant Kill (реальный, с пояснением почему работает)
- Источник: `workspace.Humanoids.Regions` — все мобы.
- Условие: у моба HP ≤ порога (слайдер, 1–50%, дефолт 10%) И **нормальный сетевой владелец — твой клиент** (`isnetworkowner(rootPart)` — API эмулятора).
- Действие: `humanoid.Health = 0` + `ChangeState(Dead)` — когда твой клиент владеет мобом, это реально реплицируется. Именно поэтому «фейковые урона в ремоуте» не нужны: владение — единственный законный путь дамага.
- Учёл safety: фильтр Anchored и аккуратный порог — убивает именно добитых (расходится по классической схеме: чужие владения не трогаем).

## 2️⃣ Fast Attack (direct Combat_Service)
- Чистый `FireServer("Combat_Service", name, combo, false, hitDelay, false, overrideName)` — байт-в-байт как родной клиент игры.
- Combo 1..Max по кругу, `hitDelay` считается из `Combat_presets.Presets`, задержка между ударами — preset interval (не ниже флора 0.08), reset пресета после `combo_duration`.
- Ставь вместе с **Rapid M1 pace** (который теперь ещё и ставит `Last_Punched=-1000000` + jump-штамп — их проверенный no-attack-slowdown).

## 3️⃣ No cooldowns v2
- Кроме обнуления `PlayerProfile.skill_info[*].lastUsed` теперь удаляются и сами инстансы ко дов (`manage_cd.filter_cd_name` → `SHC/SHCS.*_cd` для Dash и Double Jump) — паттерн из рабочего скрипта. Сервер дэша (296) проверок не имеет.

## Плюс тот же пакет QoL из аудита (все исходники перепроверены)
- Kill Aura (наличие игрока защищено мягким pcall), No Stun / No Ragdoll (purge `Stun/CombatStun/Strict_Stun/Ragdoll` из Values + персонажа — их гейтит только клиентский Checker, строки 175–178), Infinite Jump, Fullbright + No Fog (с восстановлением), FPS cap через setfpscap, Auto Skills / Auto Breathing Boost через подтверждённый протокол `server_skill_controller_signaler Hold+Cancel`.
- **Instant Prompts уже был** (локальный HoldDuration).
- Честный вердикт: `SIG_RE / CAM_RE` в дампах **этой** игры не существует (0 совпадений) — ничего и не занимал оттуда.

## Файл/проверки
- `CAM_Main_Hub_v2.5.0.lua` — 299 491 байт, SHA-256 `e7c1147a…0851f7`, Lua 5.4 syntax PASS.
- Тесты: v250 — 11 сценариев (включая insta kill с выборочным убийством по ownership+порогу, fast attack с циклом комбо, purge, протокол скиллов), v240/v231/v230 — все зелёные, v2-регрессия зелёная.

## Проверка в игре
1. Раздел «v2.4 combat assist»+: включи Inf Stamina, Inf Dash/CD, Rapid M1, Kill Aura, Instant Kill, Fast Attack.
2. Instant Kill увидится в момент, когда мобы попадают под твой порог HP; если владение по какой-то причине не на тебе — ставь порог выше (или добивай первым подходом).
3. Fast Attack: зажми и смотри — скиллует комбо по кругу; если сервер режет темп — эффект упирается в серверный лимит (Rapid M1 pace всё равно снимет клиентский).
