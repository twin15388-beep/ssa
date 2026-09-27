from pathlib import Path
p=Path('cam_main_logic.lua')
original=Path('cam_main_v1_original.lua')
if not original.exists():original.write_text(p.read_text())
s=original.read_text()
s=s.replace('Hub 1.0','Hub 2.0').replace('Version="1.0"','Version="2.0"')
s=s.replace('local S={alive=true, farm=false,','local S={alive=true, autoLevel=false, farm=false,')
s=s.replace('targetName="",targetKind="Mob",searchRange=180,hitRange=6,standOff=4,skillRange=35,','targetName="",targetKind="Mob",searchRange=350,hitRange=7,standOff=4,skillRange=35,\n        targetMode="Selected mob",mobCode="KaruVillageBandit",bossCode="Zuko",\n        positionMode="Above",farmDistance=2,farmHeight=3,travelMode="Tween",travelSpeed=80,orbitSpeed=1,\n        lookMode="Horizontal",inputMode="Auto (live punch / native input)",weapon="Auto combat tool",\n        questPolicy="Highest eligible",questStage="OFF",questName="-",questProgress="-",equipment="-",noDamageTimeout=20,')
s=s.replace('local stopAll,clearESP,refreshTargets,refreshDestinations,refreshHunts','local stopAll,clearESP,refreshTargets,refreshDestinations,refreshHunts,endTravel')
s=s.replace('Signal={"Communication","ServerAndClient","Signals","SignalEvent"},','Signal={"Communication","ServerAndClient","Signals","SignalEvent"},\n        Regions={"Regions"},\n        Info={"CAM","Global","Character_info_provider"},\n        Items={"CAM","Global","Collectibles","Items"},\n        Requirements={"CAM","Global","Collectibles","ItemRequirements"},\n        Restrictions={"CAM","Global","Subsets","Gameplay","ToolbarItemRestrictions"},')
s=s.replace('releaseAll();endFly();stopWalk();restoreMovement();restorePrompts();restoreShift()','releaseAll();endFly();stopWalk();if endTravel then endTravel() end;restoreMovement();restorePrompts();restoreShift()\n        C.questActive=nil;C.questRoute=nil;C.questSentAt=nil;C.questAttempts=0;C.damageWatch=nil;C.punch=nil;C.equipAttempts=0;C.equipmentWait=nil;S.questStage="OFF"')
a=s.index('    local function isPlayer(m)');b=s.index('    local skillActions=',a)
s=s[:a]+Path('cam_farm_engine.lua').read_text()+'\n'+s[b:]
s=s.replace('flag("farm",false);flag("attack",false);flag("skills",false);flag("fly",false)','flag("farm",false);flag("autoLevel",false);endTravel();flag("attack",false);flag("skills",false);flag("fly",false)')
a=s.index('    local function scheduler()');b=s.index('    local function snapshot()',a)
s=s[:a]+'''    local function scheduler()
        local ok,why=usable()
        if not ok then releaseAll();endPrompt();endTravel();S.status=why;return end
        local _,h=char()
        if h.Health/math.max(h.MaxHealth,1)*100<=S.healthStop then
            if S.autoLevel or S.farm or S.attack or S.skills or S.loot or S.chest or S.autoHunt or S.run or S.fly then stopAll("Low HP: stopped, no automatic restart") end
            return
        end
        if S.fly then releaseAll();endTravel();S.status="Fly has movement priority";return end
        if S.run then if not C.owned.Run then press("Run") end else release("Run") end
        if C.activePrompt then
            if not withinPrompt(C.activePrompt) then endPrompt() else release("Combat");endTravel();S.status="Holding native prompt";return end
        end
        if S.priority=="Loot first" and (S.loot or S.chest) then local done,msg=nearbyLoot();if done then S.status=msg;endTravel();return end end
        if S.autoLevel then
            local fight,msg=questStep()
            if not fight then release("Combat");S.status=msg;return end
        end
        if S.autoLevel or S.farm or S.attack or S.skills then
            local _,msg=farmStep();S.status=msg
            if not S.alive then return end
            if S.skills then local sent,skillMsg=skillOnce();if sent then S.status=msg.." | "..skillMsg end end
        else release("Combat");endTravel() end
        if (S.loot or S.chest) and not S.target then local _,msg=nearbyLoot();S.status=msg end
        if S.autoHunt and not C.activePrompt and not (S.autoLevel or S.farm or S.attack or S.skills) and (C.huntCheck or 0)<=os.clock() then
            C.huntCheck=os.clock()+5;local _,msg=claimHunt();S.status=msg
        end
    end
''' +s[b:]
s=s.replace('        local m=S.target\n        return {format=', '        local m=S.target\n        local loaded={};local _,_,root=char()\n        for model in pairs(C.humanoids) do\n            if #loaded>=60 then break end\n            if live(model) and not isPlayer(model) then\n                local p=part(model);local h=model:FindFirstChildOfClass("Humanoid");local def=npcDefinition(model)\n                loaded[#loaded+1]={name=model.Name,kind=kindOfNPC(model),code=def and def.code or "unmatched",attributeCode=tostring(model:GetAttribute("NpcCode")),\n                    hp=h and h.Health or 0,distance=root and p and (root.Position-p.Position).Magnitude or -1}\n            end\n        end\n        C.snapshotHostiles=loaded\n        return {format=')
s=s.replace('state=state,modules=modules,log=C.logs,','state=state,modules=modules,log=C.logs,\n            farm={backend=C.inputBackend or "not used",requests=C.attackRequests or 0,comboAcks=C.comboAcks or 0,damageObservations=C.damageEvents or 0,\n                quest=C.questRoute and C.questRoute.key or "none",questRequestAttempts=C.questAttempts or 0,level=level(),\n                catalogNpcs=#CAM_CATALOG.npcs,catalogQuests=#CAM_CATALOG.quests,loadedHumanoids=C.snapshotHostiles,combatBusy=C.combatBusy==true},')
s=s.replace('Name="CAM MAIN | Source-backed",Version="1.0 / place 5354"','Name="CAM MAIN | Quest & Farm",Version="2.0 / content 5354"')
s=s.replace('Native modules are loaded only after Connect.','Native modules load on Connect or enabling a combat mode.').replace('NPC targeting requires an exact selected name.','47 source-backed hostiles; selected or nearest mode.')
a=s.index('    local fight=page(');b=s.index('    local sk=section(',a)
s=s[:a]+'''    local autoPage=page("auto level","gameplay")
    local al=section(autoPage,"level-aware quest cycle")
    toggle(al,"Auto Level - accept / farm / repeat","autoLevel",function(v)
        endTravel();release("Combat");S.target=nil;C.questRoute=nil;C.questActive=nil;C.questSentAt=nil;C.questAttempts=0
        if v then flag("farm",false);flag("fly",false);endFly();loadNative();S.status="Loading native modules for Auto Level"
        else S.questStage="OFF";S.status="Auto Level OFF" end
    end)
    al:Dropdown({Name="Quest policy",Items={"Highest eligible","Mobs only"},Default=S.questPolicy,Callback=function(v) S.questPolicy=v end})
    al:Label("17 free repeatable kill routes; level thresholds 1-115.")
    al:Label("Checks current level, race and native requirements.")
    al:Label("Active supported quest is finished before switching.")
    al:Label("NPC -> AddQuest -> replicated holder -> kills -> closure.")
    al:Label("Native cooldown respected; no fake CompleteQuest call.")
    local routeSec=section(autoPage,"source-backed progression",2)
    for _,route in ipairs(CAM_CATALOG.quests) do routeSec:Label("Lv "..math.max(1,route.level).." | "..route.npc.." | "..npcByCode[route.code].name) end
    routeSec:Label("Race-specific routes may be skipped. No paid training.")
    local fight=page("farm / combat","gameplay")
    local fs=section(fight,"hostile target selection")
    fs:Dropdown({Name="Target mode",Items={"Selected mob","Selected boss","Nearest hostile"},Default=S.targetMode,Callback=function(v) S.targetMode=v;S.target=nil;endTravel();release("Combat") end})
    local mobNames,bossList,mobMap,bossMap={},{},{},{}
    for _,row in ipairs(CAM_CATALOG.npcs) do
        local list,map=row.boss and bossList or mobNames,row.boss and bossMap or mobMap
        list[#list+1]=row.name;map[row.name]=row.code
    end
    table.sort(mobNames);table.sort(bossList)
    fs:Dropdown({Name="Selected mob",Items=mobNames,Default="Bandit",Callback=function(v) S.mobCode=mobMap[v];S.target=nil;endTravel() end})
    fs:Dropdown({Name="Selected boss",Items=bossList,Default="Zuko",Callback=function(v) S.bossCode=bossMap[v];S.target=nil;endTravel() end})
    refreshTargets=function()
        local n=0;for m in pairs(C.humanoids) do if validTarget(m) then n=n+1 end end;return n
    end
    button(fs,"Count loaded hostile targets",function() note("Loaded source-matched hostiles: "..refreshTargets()) end)
    toggle(fs,"Auto Farm - selected / nearest","farm",function(v)
        endTravel();release("Combat");C.damageWatch=nil
        if v then flag("autoLevel",false);flag("fly",false);endFly();loadNative() end
    end)
    toggle(fs,"Auto M1 (no movement)","attack",function(v) if v then loadNative() elseif not S.farm and not S.autoLevel then release("Combat") end end)
    toggle(fs,"Auto Skills (selected input slots)","skills",function(v) if v then loadNative() else for _,a in ipairs(skillActions) do release(a) end end end)
    button(fs,"M1 once",function() tell(attackOnce()) end)
    slider(fs,"Search range","searchRange",20,1200);slider(fs,"M1 range","hitRange",3,10)
    slider(fs,"M1 interval (seconds)","attackDelay",0.25,3);slider(fs,"STOP at HP percent","healthStop",5,80)
    slider(fs,"STOP after no target damage (seconds)","noDamageTimeout",10,60)
    local posPage=page("farm position","gameplay")
    local posSec=section(posPage,"position / movement")
    posSec:Dropdown({Name="Farm position",Items={"Above","Below","Behind","In front","Left","Right","Orbit","Ground"},Default=S.positionMode,Callback=function(v) S.positionMode=v;endTravel() end})
    posSec:Dropdown({Name="Travel method",Items={"Tween","Instant","Walk"},Default=S.travelMode,Callback=function(v) S.travelMode=v;endTravel() end})
    slider(posSec,"Distance","farmDistance",1,15);slider(posSec,"Height","farmHeight",0,15)
    slider(posSec,"Tween speed (studs/sec)","travelSpeed",10,400);slider(posSec,"Orbit speed","orbitSpeed",0.1,4)
    posSec:Dropdown({Name="Look at target",Items={"Horizontal","Full 3D","Off"},Default=S.lookMode,Callback=function(v) S.lookMode=v end})
    posSec:Label("Above default: height 3, distance 2. Not immunity.")
    posSec:Label("Tween = speed-limited linear movement each frame.")
    posSec:Label("Walk cannot hover. High offsets can make M1 miss.")
    local eqSec=section(posPage,"native equipment / input",2)
    eqSec:Dropdown({Name="Combat weapon",Items={"Auto combat tool","Keep equipped","Slot 1","Slot 2","Slot 3","Slot 4","Slot 5"},Default=S.weapon,Callback=function(v) S.weapon=v;C.equipAttempts=0;C.damageWatch=nil end})
    eqSec:Dropdown({Name="M1 input backend",Items={"Auto (live punch / native input)","Native input only"},Default=S.inputMode,Callback=function(v) S.inputMode=v;release("Combat");C.damageWatch=nil end})
    eqSec:Label("Auto keeps usable weapon; otherwise prefers slot 3 / 1.")
    eqSec:Label("No item buying or toolbar rewriting. Native restrictions apply.")
    eqSec:Label("Live Combat.punch uses getsenv only if supported.")
    eqSec:Label("Fallback InputHandler is not called success until observed.")
    eqSec:Label("No mouse clicks that could accidentally press hub buttons.")
''' +s[b:]
s=s.replace('qs:Label("Generic Auto Level / Auto Quest is not implemented.")','qs:Label("Use Auto Level page for the repeatable kill-quest loop.")')
s=s.replace('"diagnostics / roadmap"','"diagnostics / limits"')
s=s.replace('"Auto Level / full Auto Quest / Delivery loop",','"Delivery / escort / fishing quest automation",')
s=s.replace('"Fishing / bait / EXP / purchases / best equipment"','"Fishing / bait / purchases / inventory gear scoring"')
s=s.replace('if v then flag("farm",false);stopWalk();releaseAll();endPrompt() else endFly()', 'if v then flag("farm",false);flag("autoLevel",false);S.questStage="OFF";endTravel();releaseAll();endPrompt() else endFly()')
s=s.replace('if v then flag("autoLevel",false);flag("fly",false);endFly();loadNative() end', 'if v then flag("autoLevel",false);S.questStage="OFF";flag("fly",false);endFly();loadNative() end')
s=s.replace('moveStep()\n        elapsed=', 'moveStep();farmMove(dt)\n        elapsed=')
s=s.replace('..ready.."/6 (Connect / report for details)"','..ready.."/11 | "..(C.inputBackend or "input not used")')
s=s.replace('questLabel:SetText("Active quests: "..(#names>0 and table.concat(names,", ") or "none / not loaded"))','questLabel:SetText("Lv "..tostring(level() or "?").." | "..S.questStage.." | "..S.questProgress.." | "..short(S.questName,45))')
s=s.replace('note("CAM Main ready. Connect native controls, then choose features. RightCtrl: menu. End: STOP.")','note("CAM Main 2.0 ready. Auto Level or Auto Farm connects native controls automatically. All automation OFF. End: STOP.")')
s=s.replace('    button(ds,"COPY diagnostic report",','''    button(ds,"ONE CLICK - save + copy main diagnostics",function()
        local text=report();local name="CAM_Main_"..os.date("!%Y%m%d_%H%M%S")..".json";local saved,copied=false,false
        if type(writefile)=="function" then saved=pcall(writefile,name,text) end
        local fn=setclipboard or toclipboard or (Clipboard and Clipboard.set)
        if type(fn)=="function" then copied=pcall(fn,text) end
        note((saved and "Saved "..name or "File save unavailable").." | "..(copied and "Clipboard API accepted text" or "Clipboard unavailable"))
        if not saved and not copied then manualReport(text) end
    end)
    button(ds,"COPY diagnostic report",''')
from cam_main_hotfix_v201 import apply_hotfix
s=apply_hotfix(s)
from cam_main_feature_v210 import apply_feature
s=apply_feature(s)
from cam_main_feature_v220 import apply_feature as apply_feature_220
s=apply_feature_220(s)
p.write_text(s)
# Build standalone without executing any gameplay code.
bp=Path('build_cam_main.py');b=bp.read_text()
b=b.replace('CAM MAIN HUB 1.0','CAM MAIN HUB 2.0').replace('-- First: Connect native controls. Then choose an exact loaded NPC name.','-- Auto Level / Auto Farm connect native modules on explicit enable. Above position default.')
if "lib=lib.replace('getgenv().Lumen'" not in b:
 b=b.replace("text=header+lib+", "lib=lib.replace('getgenv().Lumen','getgenv().CAMMainLumen')\ntext=header+lib+")
b=b.replace("+'\\n'+boss_code+(root/'cam_main_logic.lua').read_text()", "+'\\n'+boss_code+(root/'cam_catalog.lua').read_text()+(root/'cam_main_logic.lua').read_text()")
b=b.replace("CAM_Main_Hub_v1.0.lua","CAM_Main_Hub_v2.0.lua")
bp.write_text(b)
print('Main logic rebuilt:',len(s.encode()),'bytes')
