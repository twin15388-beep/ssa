# CAM Main Hub v3.0.0 — весь хаб на твоём Lumen UI, аккуратно по вкладкам

396 763 байт · SHA-256 `776c0600…c6d83` · standalone (ни одного loadstring/HTTP) · Lua 5.4 syntax PASS · все 5 наборов тестов зелёные.

## Вкладки (группы в сайдбаре)
- **main** → dashboard: живой статус, кнопки Connect/STOP/Copy diags/Unload.
- **gameplay** → auto level · farm/combat (таргеты, скилл-цикл, авто-зелье) · farm position (позиции/экип).
- **action** → **combat**: combat assist (Inf Stamina · Inf Dash/CD · Rapid M1 · Kill Aura+range · Instant Kill+threshold · Fast Attack), defense-auto parry, auto training.  **skills**: skill tree (ручной клик), auto skills + auto breathing, shop/loadout.
- **gameplay** → quests/boss hunts (+quest/prompt helpers, NPC-интеракции, Muzan/ranked).
- **gameplay** → loot/interaction (+auto fishing, EquipBait).
- **utilities** → movement/teleports.
- **visuals** → ESP/нотификации.
- **system** → diagnostics + честный список неподключённого.

## Без воды
- Все протокольные «лекции» из лейблов ужаты до одной строки (каждый короче ~85 символов), суть и подтверждения оставлены. Удалён промежуточный «v2.3 actions» склад.
- Названия тогглов/кнопок/флагов НЕ менялись — твои конфиги автолоута совместимы как есть.

## Тех. детали (коротко)
- Lumen ui — весь твой файл целиком; глобалка `getgenv().CAMMainLumen`, конфиги в `Lumen.Folder = cam_main_hub` (библиотека сама save/load/autoload).
- `Env.CAMMainHub` → State/Stop/Snapshot/Version="3.0.0". Меню RightControl, STOP End.
