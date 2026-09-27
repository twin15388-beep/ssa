"""CAM Main 2.1.0 feature patch: auto-noclip while farming/travelling and opt-in Auto Potion.

Runs AFTER the 2.0.1 hotfix in rework_cam_main.py. Does not change quest/combat rules,
watchdog thresholds, or any spending behaviour. Auto Potion consumes items -> default OFF.
"""
def apply_feature(s):
    if 'Version="2.1.0"' in s:
        return s
    assert 'Version="2.0.1"' in s
    def patch(old,new):
        nonlocal s
        assert old in s, old[:140]
        s=s.replace(old,new,1)
    # Version bump (5 known occurrences: header, Env export, window title, snapshot format, ready note).
    assert s.count('2.0.1')==5, s.count('2.0.1')
    s=s.replace('2.0.1','2.1.0')
    s=s.replace('2.1.0 / streaming fix','2.1.0 / farm noclip + auto potion')
    # New state fields (farm noclip defaults ON per explicit user request; potion defaults OFF).
    patch('attackDelay=0.5,skillDelay=3,skillHold=0.2,healthStop=25,',
          'attackDelay=0.5,skillDelay=3,skillHold=0.2,healthStop=25,farmNoclip=true,autoPotion=false,potionHp=35,potionDelay=6,potionChoice="Auto (strongest heal)",')
    # STOP clears an in-flight potion cycle as well.
    patch('S.target=nil;S.skillSlots={};C.flyUp=false;C.flyDown=false;C.cooldowns={};C.huntSent={};C.attackAt=nil;C.skillAt=nil',
          'S.target=nil;S.skillSlots={};C.flyUp=false;C.flyDown=false;C.cooldowns={};C.huntSent={};C.attackAt=nil;C.skillAt=nil;C.potion=nil;C.potionLock=nil;C.potionNext=nil')
    # Potion system: exact native Toolbar flow (slot change -> native Item_Equip -> Tool_Mouse Down/Up).
    patch('    local function findPunch()','''    local directPotions={["Health Elixir"]=60,["Health Potion"]=25}
    local potionPriority={"Health Elixir","Health Potion","Health Regen Elixir","Health Regen Potion"}
    local function potionSlot()
        local d=data();local info=C.modules.Info;local toolbar=d and at(d,{"Inventory","Toolbar"})
        if not toolbar or not info or type(info.GetItemFromId)~="function" then return nil,"Waiting: inventory data / native modules" end
        local names=S.potionChoice=="Auto (strongest heal)" and potionPriority or {S.potionChoice}
        for _,wanted in ipairs(names) do
            for index=1,5 do
                local slot=toolbar:FindFirstChild(toolbarNames[index])
                if slot and slot.Value~=0 then
                    local item=info.GetItemFromId(LP,slot.Value)
                    if item and item.Name==wanted then return index,wanted end
                end
            end
        end
        return nil,"No selected healing potion on toolbar slots 1-5"
    end
    local function finishPotion(success,observedBy)
        local cycle=C.potion;C.potion=nil
        if not cycle then return end
        if success then
            C.potionAcks=(C.potionAcks or 0)+1;C.potionFailures=0;C.potionLock=os.clock()+1
            log("potion",cycle.name.." acknowledged by "..observedBy)
        else
            C.potionFailures=(C.potionFailures or 0)+1;C.potionNext=os.clock()+S.potionDelay+2;C.potionLock=nil
            if (C.potionFailures or 0)>=3 and S.autoPotion then
                flag("autoPotion",false)
                note("Auto Potion paused: 3 uses without observed healing. Check potion/slot, then re-enable.")
            end
        end
        -- When idle, restore the toolbar slot the player had before the drink.
        -- While farming, ensureEquipment re-equips the weapon itself after the lock expires.
        if not (S.autoLevel or S.farm) and S.alive then
            local eq=at(LP,{"Items_Config","Equipped"})
            if eq and eq.Value==cycle.slot then eq.Value=cycle.previousSlot end
        end
    end
    local function stepPotion(h)
        local cycle=C.potion;if not cycle then return end
        local signal=C.modules.Signal;local info=C.modules.Info;local now=os.clock()
        if cycle.stage=="equip" then
            local tool=info and info.Get_equipped_tool(LP)
            if tool and tool.Name==cycle.name then
                if not signal or type(signal.ToServer)~="function" then log("potion","Signal module unavailable for native click");finishPotion(false);return end
                cycle.before=h.Health
                local d=data();local inv=d and at(d,{"Inventory","Inventory"});local owned=inv and inv:FindFirstChild(cycle.name)
                local amount=owned and owned:FindFirstChild("Amount")
                cycle.amount=amount;cycle.amountBefore=amount and amount.Value
                local _,_,root=char()
                local ok=pcall(signal.ToServer,"Tool_Mouse","Down",root and root.Position)
                if not ok then log("potion","Native click request failed");finishPotion(false);return end
                cycle.stage="release";cycle.at=now+0.15
            elseif now>cycle.deadline then
                log("potion","Potion equip not acknowledged by native toolbar");finishPotion(false)
            end
        elseif cycle.stage=="release" then
            if now>=cycle.at then
                local _,_,root=char()
                pcall(signal.ToServer,"Tool_Mouse","Up",root and root.Position)
                cycle.stage="observe";cycle.deadline=now+4.5
            end
        elseif cycle.stage=="observe" then
            local _,hum=char()
            if hum and hum.Health>cycle.before+1 then finishPotion(true,"HP increase") return end
            if cycle.amount and cycle.amount.Parent and cycle.amountBefore and cycle.amount.Value<cycle.amountBefore then finishPotion(true,"item consumption") return end
            if now>cycle.deadline then log("potion","No healing / consumption observed after native click");finishPotion(false) end
        end
    end
    local function usePotion(h)
        -- Exactly the native toolbar flow: set the potion slot (native Toolbar validates + sends
        -- Item_Equip), wait for the equip ack, then Tool_Mouse Down/Up like a player click.
        if C.potion then stepPotion(h) return C.potion~=nil,"Potion in progress" end
        if (C.potionNext or 0)>os.clock() then return false,"Potion recheck cooldown" end
        if C.combatBusy then return false,"Waiting for native combat call before potion" end
        if h.Health>=h.MaxHealth*S.potionHp/100 then return false,"HP above potion threshold" end
        if directPotions[S.potionChoice] and h.MaxHealth-h.Health<15 then return false,"Deficit too small for a direct potion" end
        local slot,name=potionSlot()
        if not slot then
            if not C.potionTip then C.potionTip=true;log("potion","No selected healing potion on toolbar slots 1-5") end
            return false,"Potion: none on toolbar slots 1-5"
        end
        C.potionTip=nil
        local equipped=at(LP,{"Items_Config","Equipped"})
        if not equipped or not C.modules.Info or not C.modules.Signal then return false,"Connect native controls first" end
        C.potionRequests=(C.potionRequests or 0)+1
        C.potionLock=os.clock()+8
        C.potion={stage="equip",slot=slot,name=name,previousSlot=equipped.Value,deadline=os.clock()+2}
        equipped.Value=slot
        log("potion","Toolbar slot "..slot.." / "..name.." at "..math.floor(h.Health).." HP (native equip + click)")
        stepPotion(h)
        return true,"Potion: native equip + click requested"
    end
    local function findPunch()''')
    # Farm must not fight the potion for the toolbar slot mid-drink.
    patch('''    local function attackOnce()
        local ok,why=usable();if not ok then return false,why end''','''    local function attackOnce()
        local ok,why=usable();if not ok then return false,why end
        if C.potion or (C.potionLock or 0)>os.clock() then return false,"Potion in progress" end''')
    # Scheduler: heal check runs whenever enabled, before loot/quest/farm stages.
    patch('        if S.run then if not C.owned.Run then press("Run") end else release("Run") end',
          '''        if S.run then if not C.owned.Run then press("Run") end else release("Run") end
        if S.autoPotion then usePotion(h) end''')
    # Auto noclip while the farm/travel loop moves the character; restores original collisions.
    patch('        if S.noclip then',
          '        if S.noclip or (S.farmNoclip and (S.autoLevel or S.farm) and not S.fly) then')
    # Diagnostics counters.
    patch('damageObservations=C.damageEvents or 0,',
          'damageObservations=C.damageEvents or 0,potionRequests=C.potionRequests or 0,potionAcks=C.potionAcks or 0,potionFailures=C.potionFailures or 0,')
    # UI: farm noclip toggle next to manual Noclip (UI default is always false, so sync it).
    patch('    toggle(ms,"Noclip","noclip")',
          '''    toggle(ms,"Noclip","noclip")
    local farmNoclipRef=toggle(ms,"Noclip while farming/travelling (auto)","farmNoclip")
    farmNoclipRef:Set(S.farmNoclip,true)''')
    # UI: Auto Potion section on the fight page.
    patch('    slider(sk,"Skill interval","skillDelay",1,10);slider(sk,"Skill hold seconds","skillHold",0.08,3);slider(sk,"Skill target range","skillRange",5,100)','''    slider(sk,"Skill interval","skillDelay",1,10);slider(sk,"Skill hold seconds","skillHold",0.08,3);slider(sk,"Skill target range","skillRange",5,100)
    local ps=section(fight,"auto potion (native toolbar)",2)
    toggle(ps,"Auto Potion - consumes toolbar potion at low HP","autoPotion",function(v) if v then loadNative() else C.potion=nil;C.potionLock=nil end end)
    ps:Dropdown({Name="Potion choice",Items={"Auto (strongest heal)","Health Elixir","Health Potion","Health Regen Elixir","Health Regen Potion"},Default=S.potionChoice,Flag="cam_potion_choice",Callback=function(v) S.potionChoice=v end})
    slider(ps,"Use below HP percent","potionHp",10,80)
    slider(ps,"Potion recheck seconds","potionDelay",3,15)
    ps:Label("The potion must already sit on toolbar slot 1-5; drinking consumes the item.")
    ps:Label("Native equip + click path; acknowledged by HP increase or item consumption.")
    ps:Label("Keep 'Use below HP percent' above 'STOP at HP percent' or it never fires.")''')
    # This part of the backlog is now shipped.
    patch('"Auto Potion / Auto Parry / claim souls / schematics"','"Auto Parry / claim souls / schematics"')
    return s
