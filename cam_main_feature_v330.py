from pathlib import Path
# CAM Main Hub 3.3.0 - direct farm combat core rebuilt 1:1 on the working script's channels (document 3)
# + honest live status + no "everything stops" behaviour (death / one-off callback errors).
p=Path('cam_main_logic.lua');s=p.read_text()
def patch(old,new):
    global s
    assert old in s,'ANCHOR MISS: '+old[:90]
    s=s.replace(old,new,1)

# --- header / version strings ---
patch("-- CAM Main Hub 3.2.4 | source-backed client integration for place 136406881576517.",
"-- CAM Main Hub 3.3.0 | source-backed client integration for place 136406881576517.")
patch('return {format="CAM Main Hub 3.2.4",','return {format="CAM Main Hub 3.3.0",')
patch('Snapshot=snapshot,Version="3.2.4"}','Snapshot=snapshot,Version="3.3.0"}')
patch('Version="3.2.4 / + combat_service default, speed 300"','Version="3.3.0 / + working-script combat core, live farm status"')
patch('note("CAM Main 3.2.4 ready. Auto Level or Auto Farm connects native controls automatically. All automation OFF. End: STOP.")',
'note("CAM Main 3.3.0 ready. Auto Farm / Auto Level connect native modules automatically. All automation OFF. Unload: settings tab.")')

# --- S defaults: attack timing option + live farm status ---
patch('m1Mode="Fast Attack (Combat_Service)",\n        fullbright=false',
'm1Mode="Fast Attack (Combat_Service)",attackTiming="Game client (swing delay)",farmStatus="OFF",\n        fullbright=false')

# --- C init: sync-require retry table + fast attack counters ---
patch("fish={casts=0,bites=0,wins=0,awaitingBite=false,last=0,portalDone=false},fastM1={},fatk={combo=1,next=0,last=0}}",
"fish={casts=0,bites=0,wins=0,awaitingBite=false,last=0,portalDone=false},fastM1={},fatk={combo=1,next=0,last=0,sent=0},syncRetry={}}")

# --- label decl ---
patch("    local statusLabel,targetLabel,resourceLabel,questLabel,nativeLabel,indexLabel,parryLabel,trainLabel,fishLabel,treeLabel",
"    local statusLabel,targetLabel,resourceLabel,questLabel,nativeLabel,indexLabel,parryLabel,trainLabel,fishLabel,treeLabel,farmStatusLabel")

# --- connect(): a single callback error must not switch every toggle off ---
patch("""    local function connect(signal,fn,label)
        local con=signal:Connect(function(...)
            if not S.alive then return end
            local ok,err=pcall(fn,...)
            if not ok then log("callback error",(label or "Callback")..": "..tostring(err));if stopAll then stopAll("Callback failed; see diagnostics") end end
        end)
        C.connections[#C.connections+1]=con;return con
    end""",
"""    local function connect(signal,fn,label)
        -- v3.3.0: errors are logged and counted; only a runaway error loop (30 errors within 10s) stops automation
        local con=signal:Connect(function(...)
            if not S.alive then return end
            local ok,err=pcall(fn,...)
            if not ok then
                local now=os.clock()
                C.callbackErrors=(C.callbackErrors or 0)+1;C.lastCallbackError=(label or "Callback")..": "..tostring(err)
                if (C.errLogAt or 0)<=now then C.errLogAt=now+1;log("callback error",C.lastCallbackError) end
                if not C.errWindowAt or now-C.errWindowAt>10 then C.errWindowAt=now;C.errWindowCount=0 end
                C.errWindowCount=(C.errWindowCount or 0)+1
                if C.errWindowCount>=30 and stopAll then C.errWindowCount=0;stopAll("Repeated callback errors ("..C.callbackErrors.."): "..short(C.lastCallbackError,120)) end
            end
        end)
        C.connections[#C.connections+1]=con;return con
    end""")

# --- loadNative(): resolve the live RemoteEvent first (working-script channel), honest notice text ---
patch("""    local function loadNative()
        if game.PlaceId~=136406881576517 then note("Wrong place; native controls disabled") return end
        local epoch=S.epoch
        for key,path in pairs(modulePaths) do""",
"""    local resolveSignal,ensureModule
    local function loadNative()
        if game.PlaceId~=136406881576517 then note("Wrong place; native controls disabled") return end
        local epoch=S.epoch
        resolveSignal()
        for key,path in pairs(modulePaths) do""")
patch("""        -- Live layout fact (working script): Signals/SignalEvent is a FOLDER with the
        -- RemoteEvent child "Event"; requiring the folder fails, so resolve it directly.
        if not C.modules.Signal then
            local evt=at(RS,{"Communication","ServerAndClient","Signals","SignalEvent","Event"})
            if evt and (evt:IsA("RemoteEvent") or evt:IsA("UnreliableRemoteEvent")) then
                C.modules.Signal={ToServer=function(...) return evt:FireServer(...) end}
                C.loading.Signal="ready";log("module","Signal: live RemoteEvent resolved directly")
            end
        end
        local ready,total=0,0
        for key in pairs(modulePaths) do total=total+1;if C.modules[key] then ready=ready+1 end end
        note(ready==total and "Native controls ready. Enabled modes continue automatically." or
            ("Connecting native controls: "..ready.."/"..total.." ready. See dashboard for progress."))
    end""",
"""        local ready,total=0,0
        for key in pairs(modulePaths) do total=total+1;if C.modules[key] then ready=ready+1 end end
        note(ready==total and "Native controls ready. Enabled modes continue automatically." or
            ("Connecting native controls: "..ready.."/"..total.." ready. Live status: farm page / diagnostics."))
    end
    -- v3.3.0 working-script signal channel: ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent.Event
    -- is a live RemoteEvent (decompiled layout: SignalEvent = ModuleScript, child Event = RemoteEvent). The game's
    -- SignalEvent.ToServer(...) ends in exactly Event:FireServer(...) (RemotePlus EventerMain.To), so the direct
    -- remote needs no require and is what the working script uses for Combat_Service / Item_Equip / Tool_Mouse.
    resolveSignal=function()
        local evt=C.signalEvent
        if not (evt and evt.Parent) then
            evt=at(RS,{"Communication","ServerAndClient","Signals","SignalEvent","Event"})
            if evt and not (evt:IsA("RemoteEvent") or evt:IsA("UnreliableRemoteEvent")) then evt=nil end
            if evt then
                C.signalEvent=evt;C.signalPath="live RemoteEvent SignalEvent/Event"
                C.modules.Signal={ToServer=function(...) return evt:FireServer(...) end};C.loading.Signal="ready"
                log("module","Signal: live RemoteEvent SignalEvent/Event (working-script channel)")
            end
        end
        local m=C.modules.Signal
        if type(m)=="table" and type(m.ToServer)=="function" then C.signalPath=C.signalPath or "SignalEvent module (require)";return m end
        return nil
    end
    -- Synchronous module path for the farm tick: Delta (mobile) does not guarantee that a require inside
    -- task.spawn ever completes, so the farm resolves what it needs inline (rate-limited, once per 3s per key).
    ensureModule=function(key)
        if C.modules[key] then return C.modules[key] end
        if key=="Signal" then local m=resolveSignal();if m then return m end end
        if (C.syncRetry[key] or 0)>os.clock() then return nil end
        C.syncRetry[key]=os.clock()+3
        local path=modulePaths[key];local obj=path and at(RS,path)
        if not obj or not obj:IsA("ModuleScript") then
            C.loading[key]="missing";log("module",key..": missing at ReplicatedStorage."..table.concat(path or {},"."));return nil
        end
        local ok,result=pcall(require,obj)
        if ok and type(result)=="table" then C.modules[key]=result;C.loading[key]="ready";log("module",key..": loaded (sync path)");return result end
        C.loading[key]="failed";log("module",key..": require failed: "..short(result));return nil
    end""")

# --- stopAll: clear the direct-farm transient state too ---
patch("""        S.target=nil;S.skillSlots={};C.flyUp=false;C.flyDown=false;C.cooldowns={};C.huntSent={};C.attackAt=nil;C.skillAt=nil;C.potion=nil;C.potionLock=nil;C.potionNext=nil""",
"""        S.target=nil;S.skillSlots={};C.flyUp=false;C.flyDown=false;C.cooldowns={};C.huntSent={};C.attackAt=nil;C.skillAt=nil;C.potion=nil;C.potionLock=nil;C.potionNext=nil
        C.farmTarget=nil;C.fatk.pending=nil;C.fatk.next=0;C.fatk.combo=1;C.toolbarEquipAt=nil;C.equipAt=nil;S.farmStatus="OFF\"""")

# --- classic ensureEquipment(): optional restriction modules must not freeze the classic path ---
patch("""        if not d or not equipped or not toolbar or not info or not items or not rules or not req then return false,"Waiting: equipment data/native modules" end
        local function combatItem(index)
            local slot=toolbar:FindFirstChild(toolbarNames[index] or "")
            if not slot or slot.Value==0 then return nil end
            local item=info.GetItemFromId(LP,slot.Value);local def=item and items[item.Name]
            if not def or not (def.HasCombat or def.CombatPreset or item.Name=="Combat") then return nil end
            local limits=rules.GetCurrentRestrictions(LP,toolbarNames[index])
            if limits.Locked or limits.ActionsDisabled or not req.SatisfiesEquip(d,item.Name) then return nil end
            return item
        end""",
"""        if not d or not equipped or not toolbar or not info or not items then return false,"Waiting: equipment data/native modules (Info/Items)" end
        local function combatItem(index)
            local slot=toolbar:FindFirstChild(toolbarNames[index] or "")
            if not slot or slot.Value==0 then return nil end
            local item=info.GetItemFromId(LP,slot.Value);local def=item and items[item.Name]
            if not def or not (def.HasCombat or def.CombatPreset or item.Name=="Combat") then return nil end
            -- restriction modules are optional (v3.3.0): if they are not loaded the server still decides
            if rules and type(rules.GetCurrentRestrictions)=="function" then
                local okL,limits=pcall(rules.GetCurrentRestrictions,LP,toolbarNames[index])
                if okL and type(limits)=="table" and (limits.Locked or limits.ActionsDisabled) then return nil end
            end
            if req and type(req.SatisfiesEquip)=="function" then
                local okR,fine=pcall(req.SatisfiesEquip,d,item.Name)
                if okR and fine==false then return nil end
            end
            return item
        end""")

# --- isFarmDefending: values folder like Utility.getvaluesfolder (Player_Service.Values[<name>] or the model) ---
patch("""    actions.isFarmDefending=function(m)
        local nc;local okA=pcall(function() nc=m:GetAttribute("NpcCounter") end)
        if okA and (nc==1 or nc==2) then return true end
        local okB,t=pcall(function() return m:FindFirstChild("NpcCounterTriggered") end)
        if okB and t then return true end
        local okC,bl=pcall(function() return m:FindFirstChild("Blocking") end)
        local okD,pb=pcall(function() return m:FindFirstChild("PierceBlock") end)
        return okC and bl~=nil and not (okD and pb~=nil)
    end""",
"""    actions.isFarmDefending=function(m)
        -- working script isTargetDefending(): NpcCounter 1/2, NpcCounterTriggered, Values.Blocking without PierceBlock
        -- (values folder = Player_Service.Values[<name>] when it exists, otherwise the model itself: Utility.getvaluesfolder)
        if not m then return false end
        local nc;local okA=pcall(function() nc=m:GetAttribute("NpcCounter") end)
        if okA and (nc==1 or nc==2) then return true end
        local okB,t=pcall(function() return m:FindFirstChild("NpcCounterTriggered") end)
        if okB and t then return true end
        local function blocking(folder)
            if not folder then return false end
            local okC,bl=pcall(function() return folder:FindFirstChild("Blocking") end)
            local okD,pb=pcall(function() return folder:FindFirstChild("PierceBlock") end)
            return okC and bl~=nil and not (okD and pb~=nil)
        end
        if blocking(m) then return true end
        local okV,vf=pcall(function() return at(RS,{"Player_Service","Values",m.Name}) end)
        return (okV and blocking(vf)) or false
    end""")

# --- farmTick: weapon never blocks, attack only in range, live status string ---
patch("""    actions.farmTick=function()
        local ch=LP.Character;local hrp=ch and ch:FindFirstChild("HumanoidRootPart");local hum=ch and ch:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health<=0 then C.farmTarget=nil;pcall(actions.m1Up);return false,"No character" end
        local t=actions.pickFarmTarget()
        C.farmTarget=t
        if not t then pcall(actions.m1Up);return false,"No farm target in range" end
        local eqOk,eqMsg=ensureEquipment()
        if not eqOk then pcall(actions.m1Up);return false,eqMsg end
        if S.farmNoclip then pcall(function()
            for _,part in ipairs(ch:GetDescendants()) do
                if part.IsA and part:IsA("BasePart") and part.CanCollide then part.CanCollide=false end
            end
        end) end
        local defending=actions.isFarmDefending(t.m)
        local inRange=(t.r.Position-hrp.Position).Magnitude<=math.max(S.farmDist+8,10)
        if S.m1Mode=="Fast Attack (Combat_Service)" then
            if not defending then pcall(actions.fastAttackTick) end
            pcall(actions.m1Up)
        else
            if not defending and inRange then pcall(actions.m1Down) else pcall(actions.m1Up) end
        end
        local now=os.clock()""",
"""    actions.farmTick=function()
        local ch=LP.Character;local hrp=ch and ch:FindFirstChild("HumanoidRootPart");local hum=ch and ch:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health<=0 then C.farmTarget=nil;pcall(actions.m1Up);return false,"No character / dead: waiting for respawn (toggles stay ON)" end
        local t=actions.pickFarmTarget()
        if C.farmTarget~=t then C.farmTarget=t;C.equipAttempts=0;C.equipAt=nil end
        if not t then pcall(actions.m1Up);return false,"No farm target within "..tostring(S.searchRange).." studs ("..((S.autoFarm and S.autoBoss) and "mobs + bosses" or (S.autoBoss and "bosses only" or "mobs only"))..(S.farmMobText~="" and (", filter: "..S.farmMobText) or "")..")" end
        -- v3.3.0: weapon handling is best effort and never blocks the attack (working script: equip once, then fight with what is equipped)
        local eqMsg=actions.prepareWeapon()
        if S.farmNoclip then pcall(function()
            for _,part in ipairs(ch:GetDescendants()) do
                if part.IsA and part:IsA("BasePart") and part.CanCollide then part.CanCollide=false end
            end
        end) end
        local defending=actions.isFarmDefending(t.m)
        local dist=(t.r.Position-hrp.Position).Magnitude
        local inRange=dist<=math.max(S.farmDist+8,12)
        local atkMsg
        if S.m1Mode=="Fast Attack (Combat_Service)" then
            if defending then atkMsg="target defending - holding"
            elseif not inRange then atkMsg="approaching"
            else local _,m=actions.fastAttackTick(t.m);atkMsg=m end
            pcall(actions.m1Up)
        else
            if not defending and inRange then pcall(actions.m1Down);atkMsg="Tool_Mouse hold (tool activation only; melee needs Fast Attack)"
            else pcall(actions.m1Up);atkMsg=defending and "target defending - holding" or "approaching" end
        end
        local now=os.clock()""")
patch("""        else C.stallPos=nil;C.stallAt=nil end
        return true,"Farming "..tostring(t.m.Name)
    end""",
"""        else C.stallPos=nil;C.stallAt=nil end
        local hp=t.h and t.h.Health or 0
        return true,"Farming "..tostring(t.m.Name).." "..math.floor(dist).."st HP "..math.floor(hp).." | "..tostring(atkMsg).." | "..tostring(eqMsg)
    end""")

# --- combat core: replace fastAttackTick with the working-script port ---
old_start="""    actions.fastAttackTick=function()
        local sig=C.modules.Signal;local cp=C.modules.CombatPresets;local ci=C.modules.Info;local items=C.modules.Items"""
old_end="""        pcall(sig.ToServer,"Combat_Service",combatName,combo,false,serverHitDelay,false,overrideName)
        C.fatk.combo=(combo>=maxc) and 1 or (combo+1)
        C.fatk.last=os.clock()
        return true
    end
"""
i=s.index(old_start);j=s.index(old_end,i)+len(old_end)
new_core=r'''    -- v3.3.0 direct combat core = 1:1 port of the working script (document 3: resolveCombatPreset / getCombatTiming /
    -- performCombatAttack) which is itself the game's own client path (2_75_Combat + Main_Combat_Script_Client):
    -- local Swing_<combo> animation, Combat_Service after the preset swing delay, combo 1..Max, combo_duration reset.
    -- No invented packets; only Combat_Service / Item_Equip / Toolbar_Equip / Tool_Mouse on the live SignalEvent.
    actions.resolveCombat=function()
        local cp=C.modules.CombatPresets;local ci=C.modules.Info;local items=C.modules.Items
        if type(cp)~="table" or type(cp.Presets)~="table" then return nil,"Combat_presets module not loaded ("..tostring(C.loading.CombatPresets or "not requested")..")" end
        local tool
        if type(ci)=="table" and type(ci.Get_equipped_tool)=="function" then local ok,tl=pcall(ci.Get_equipped_tool,LP);if ok then tool=tl end end
        local eq=tool and type(items)=="table" and items[tool.Name] or nil
        local combatName
        if eq and eq.CombatPreset and eq.CombatPreset~="Combat" then combatName=tool.Name
        else
            for powerName in string.gmatch(actions.curPower() or "","([^,]+)") do
                local pn=powerName:gsub("^%s+",""):gsub("%s+$","")
                if at(RS,{"Assets","Animations",pn.."_Combat_Anims"}) then combatName=pn;break end
            end
            if not combatName and tool then
                if eq and eq.HasCombat then combatName=tool.Name
                elseif at(RS,{"Assets","Animations",tool.Name.."_Combat_Anims"}) then combatName=tool.Name end
            end
        end
        combatName=combatName or "Combat"
        local overrideName;local preset=cp.Presets[combatName]
        if not preset and type(items)=="table" and items[combatName] then
            local it=items[combatName]
            if it.Breathing~=nil or it.HasCombat or it.CombatPreset~=nil then
                overrideName=combatName;combatName=it.CombatPreset or "Regular Katana";preset=cp.Presets[combatName]
            end
        end
        if not preset then combatName="Combat";overrideName=nil;preset=cp.Presets.Combat end
        if type(preset)~="table" then return nil,"No combat preset for "..tostring(combatName).." (Combat_presets.Presets.Combat missing)" end
        return {name=combatName,preset=preset,override=overrideName,tool=tool and tool.Name or "none"}
    end
    local function attackSpeed(cp)
        local ok,aspd=pcall(type(cp.attackSpeedMult)=="function" and cp.attackSpeedMult or function() return 1 end,LP)
        if not ok or type(aspd)~="number" or aspd<=0 then return 1 end
        return aspd
    end
    local function combatTiming(cp,preset,combo)
        local aspd=attackSpeed(cp)
        local function pick(field,fallback) local t=preset[field];local v=type(t)=="table" and t[combo] or nil;return v or fallback end
        local swingDelay=pick("delay_before_swing",preset.default_before_swing or cp.Default_Swing_Wait or 0)
        local hitDelay=pick("delay_before_hit",preset.default_before_hit or swingDelay)
        local serverHitDelay=math.max((hitDelay-swingDelay)/aspd,0)
        local interval=pick("customDelay",preset.default or 0.25)
        local maxc=preset.Max or 5
        if combo==maxc and type(preset.final)=="number" then interval=math.max(interval,preset.final) end
        interval=math.max(interval/aspd,0.12)
        return serverHitDelay,interval,swingDelay,aspd,maxc
    end
    local function playSwing(rc,combo,aspd)
        pcall(function()
            local anims=at(RS,{"Assets","Animations"})
            local folder=(rc.override and anims and anims:FindFirstChild(rc.override.."_Combat_Anims"))
                or (anims and anims:FindFirstChild(rc.name.."_Combat_Anims"))
                or (anims and anims:FindFirstChild("Combat_Combat_Anims"))
            local anim=folder and folder:FindFirstChild("Swing_"..combo)
            local _,hum=char();local animator=hum and hum:FindFirstChildOfClass("Animator")
            if anim and animator then
                local track=animator:LoadAnimation(anim);track:Play()
                if type(rc.preset.AnimSpeed)=="table" then track:AdjustSpeed((rc.preset.AnimSpeed[combo] or rc.preset.AnimSpeed.Default or 1)*aspd) end
            end
        end)
    end
    local function serverCombo()
        -- read-only: Combat_presets.Check_can_do_combat_server keeps last_combo / last_cmbat as attributes; if they are
        -- replicated (character or player) they tell exactly which combo the server accepted last.
        for _,holder in ipairs({LP.Character,LP}) do
            if holder then
                local ok,v=pcall(function() return holder:GetAttribute("last_combo") end)
                if ok and type(v)=="number" then return v end
            end
        end
        return nil
    end
    -- v3.3.0 best-effort weapon prep for the direct farm (working script equipToolbarItem): Toolbar_Equip(name,id) when the
    -- weapon only sits in the Inventory, then Items_Config.Equipped = slot + Item_Equip(slot). Never gates the attack.
    actions.prepareWeapon=function()
        if S.weapon=="Keep equipped" then return "weapon: keep equipped" end
        local sig=C.modules.Signal;local items=C.modules.Items;local info=C.modules.Info
        local equipped=at(LP,{"Items_Config","Equipped"});local d=data();local toolbar=at(d,{"Inventory","Toolbar"});local inv=at(d,{"Inventory","Inventory"})
        if not equipped or not toolbar then return "weapon: toolbar data missing - using current tool" end
        local function itemId(it)
            local idv=it:FindFirstChild("Id")
            if idv and idv:IsA("ValueBase") then return idv.Value end
            return it:GetAttribute("Id")
        end
        local function itemById(id)
            if id==nil or id==0 then return nil end
            if type(info)=="table" and type(info.GetItemFromId)=="function" then local ok,it=pcall(info.GetItemFromId,LP,id);if ok and it then return it end end
            if inv then for _,it in ipairs(inv:GetChildren()) do if itemId(it)==id then return it end end end
            return nil
        end
        local function slotItem(index) local slot=toolbar:FindFirstChild(toolbarNames[index] or "");return slot and itemById(slot.Value) or nil end
        local function isCombat(it)
            if not it then return false end
            local def=type(items)=="table" and items[it.Name] or nil
            if def then return def.HasCombat==true or def.CombatPreset~=nil end
            return it.Name=="Combat" or at(RS,{"Assets","Animations",it.Name.."_Combat_Anims"})~=nil
        end
        local desired
        if S.weapon=="Auto combat tool" then
            local cur=slotItem(equipped.Value)
            if isCombat(cur) then C.equipAttempts=0;S.equipment=cur.Name;return "weapon: "..cur.Name end
            for _,i in ipairs({3,1,2,4,5}) do if isCombat(slotItem(i)) then desired=i;break end end
            if not desired then
                if inv and sig then
                    for _,it in ipairs(inv:GetChildren()) do
                        local idv=isCombat(it) and itemId(it) or nil
                        if idv~=nil then
                            if (C.toolbarEquipAt or 0)>os.clock() then return "weapon: Toolbar_Equip "..it.Name.." pending" end
                            C.toolbarEquipAt=os.clock()+3
                            pcall(sig.ToServer,"Toolbar_Equip",it.Name,idv);log("equipment","Toolbar_Equip "..it.Name.." (id "..tostring(idv)..")")
                            return "weapon: Toolbar_Equip "..it.Name
                        end
                    end
                end
                return "weapon: no combat item on toolbar - fighting with the current tool"
            end
        else desired=tonumber(S.weapon:match("(%d+)")) end
        if not desired then return "weapon: "..tostring(S.weapon) end
        if equipped.Value==desired then
            local it=slotItem(desired);S.equipment=it and it.Name or ("slot "..desired)
            return "weapon: slot "..desired..(it and (" "..it.Name) or "")
        end
        if (C.equipAt or 0)>os.clock() then return "weapon: equipping slot "..desired end
        C.equipAttempts=(C.equipAttempts or 0)+1
        C.equipAt=os.clock()+(C.equipAttempts>3 and 10 or 2)
        -- working script order: Items_Config.Equipped = slot, then Item_Equip(slot); no acknowledgement gate
        pcall(function() equipped.Value=desired end)
        if sig then pcall(sig.ToServer,"Item_Equip",desired) end
        log("equipment","Item_Equip slot "..desired.." (attempt "..C.equipAttempts..")")
        return "weapon: Item_Equip slot "..desired
    end
    actions.fastAttackTick=function(targetModel)
        local sig=ensureModule("Signal")
        if not sig then C.fatk.reason="Signal remote missing (Communication/ServerAndClient/Signals/SignalEvent/Event)";return false,C.fatk.reason end
        local cp=ensureModule("CombatPresets")
        if not cp then C.fatk.reason="Combat_presets not loaded ("..tostring(C.loading.CombatPresets or "pending").."); retrying";return false,C.fatk.reason end
        ensureModule("Items");ensureModule("Info")
        local now=os.clock()
        if C.fatk.pending then return true,"swing pending | sent "..(C.fatk.sent or 0) end
        if now<(C.fatk.next or 0) then return true,"pacing "..string.format("%.2f",C.fatk.next-now).."s | sent "..(C.fatk.sent or 0) end
        local rc,why=actions.resolveCombat()
        if not rc then C.fatk.reason=why;return false,why end
        local aspd0=attackSpeed(cp)
        -- combo reset exactly like performCombatAttack(): combo_duration / attackSpeed since the last swing
        if now-(C.fatk.last or 0)>(cp.combo_duration or 1)/aspd0 then C.fatk.combo=1 end
        local maxc=rc.preset.Max or 5
        if C.fatk.combo>maxc then C.fatk.combo=1 end
        local combo=C.fatk.combo
        -- resync with the server's accepted combo when the attribute is visible and our last packet was not taken
        local sc=serverCombo()
        if type(sc)=="number" and C.fatk.sentCombo and C.fatk.lastSend and now-C.fatk.lastSend>0.3 and sc~=C.fatk.sentCombo then
            local want=(sc==5 or sc==7 or sc>=maxc) and 1 or (sc+1)
            if want~=combo then C.fatk.resyncs=(C.fatk.resyncs or 0)+1;combo=want;C.fatk.combo=want;log("combat","combo resync: server last_combo="..sc.." -> sending "..want) end
        end
        local serverHitDelay,interval,swingDelay,aspd=combatTiming(cp,rc.preset,combo)
        playSwing(rc,combo,aspd)
        C.fatk.last=now;C.fatk.next=now+interval*0.92
        C.fatk.combo=(combo>=maxc) and 1 or (combo+1)
        C.fatk.lastCombat=rc.name..(rc.override and ("/"..rc.override) or "").." c"..combo.." tool="..rc.tool
        local epoch=S.epoch
        local function fire()
            C.fatk.pending=nil
            if not S.alive or epoch~=S.epoch then return end
            if targetModel and (not targetModel.Parent or actions.isFarmDefending(targetModel)) then
                C.fatk.skipped=(C.fatk.skipped or 0)+1;C.fatk.next=os.clock()+0.05;return
            end
            local ok,err=pcall(sig.ToServer,"Combat_Service",rc.name,combo,false,serverHitDelay,false,rc.override)
            if ok then C.fatk.sent=(C.fatk.sent or 0)+1;C.fatk.lastSend=os.clock();C.fatk.sentCombo=combo;C.fatk.reason=nil
            else C.fatk.reason="Combat_Service send error: "..short(err);log("combat",C.fatk.reason) end
        end
        if S.attackTiming=="Instant (no swing delay)" or swingDelay<=0 then fire()
        else C.fatk.pending=true;task.delay(swingDelay,fire) end
        return true,"Combat_Service "..rc.name.." c"..combo..(rc.override and (" ("..rc.override..")") or "").." | sent "..(C.fatk.sent or 0)..(sc and (" | srv combo "..sc) or "")
    end
'''
s=s[:i]+new_core+s[j:]

# --- heartbeat: publish farm status, keep toggles alive through death ---
patch("""        if S.autoFarm or S.autoBoss then pcall(actions.farmTick) end""",
"""        if S.autoFarm or S.autoBoss then
            local okF,resF,msgF=pcall(actions.farmTick)
            if not okF then S.farmStatus="farm error: "..short(resF);if (C.farmErrAt or 0)<=os.clock() then C.farmErrAt=os.clock()+2;log("farm error",tostring(resF)) end
            else S.farmStatus=msgF or S.farmStatus end
            if not (S.autoLevel or S.farm or S.attack or S.skills) then S.status=S.farmStatus end
        elseif S.farmStatus~="OFF" then S.farmStatus="OFF";C.farmTarget=nil;C.fatk.pending=nil end""")
patch("""        local current,h=char()
        if h and h.Health<=0 and C.deadCharacter~=current then C.deadCharacter=current;stopAll("Death: all toggles OFF") end
        if h and h.Health>0 then C.deadCharacter=nil end""",
"""        local current,h=char()
        if h and h.Health<=0 and C.deadCharacter~=current then
            -- v3.3.0 (user rule): death never switches features off; only targets / transient combat state reset
            C.deadCharacter=current;C.farmTarget=nil;S.target=nil;C.target=nil;C.fatk.combo=1;C.fatk.next=0;C.fatk.pending=nil;C.damageWatch=nil
            pcall(actions.m1Up);releaseAll();endTravel()
            S.status="Died: toggles stay ON, waiting for respawn";S.farmStatus=S.status;log("death",S.status)
        end
        if h and h.Health>0 then C.deadCharacter=nil end""")
patch("""            statusLabel:SetText(short(S.status,95));indexLabel:SetText((C.indexing and "Indexing... " or "Loaded index: ")..n.." objects")""",
"""            statusLabel:SetText(short(S.status,95));indexLabel:SetText((C.indexing and "Indexing... " or "Loaded index: ")..n.." objects")
            if farmStatusLabel and farmStatusLabel.SetText then
                farmStatusLabel:SetText(short("Farm: "..tostring(S.farmStatus).." | Combat_Service sent "..(C.fatk.sent or 0)..(C.fatk.lastCombat and (" | last "..C.fatk.lastCombat) or "")..(C.fatk.reason and (" | "..C.fatk.reason) or ""),160))
            end""")

# --- usable(): honest death wording (features persist through death) ---
patch('''        if not h or not r or h.Health<=0 then return false,"Character unavailable" end
        if focused() or menuOpen()''',
'''        if h and r and h.Health<=0 then return false,"Died: toggles stay ON, waiting for respawn" end
        if not h or not r then return false,"Character unavailable (respawning); toggles stay ON" end
        if focused() or menuOpen()''')

# --- button(): a failing click is reported, it does not switch every toggle off ---
patch("""            local ok,err=pcall(fn);if not ok then log("button error",err);note("Action failed: "..short(err));stopAll("Action failed") end""",
"""            local ok,err=pcall(fn);if not ok then log("button error",err);note("Action failed: "..short(err)) end""")

# --- farm page UI: attack timing, live status, attack-once probe, honest copy ---
patch("""    farmSec:Dropdown({Name="Weapon",Items={"Auto combat tool","Keep equipped","Slot 1","Slot 2","Slot 3","Slot 4","Slot 5"},Default=S.weapon,Flag="cam_weapon",Callback=function(v) S.weapon=v end})
    farmSec:Label("Regions scan -> stepped approach; attacks run inside the game's own input path (hold M1) or raw Combat_Service.")
    farmSec:Label("Defending targets (NpcCounter / Blocking) are skipped this pass.")""",
"""    farmSec:Dropdown({Name="Weapon",Items={"Auto combat tool","Keep equipped","Slot 1","Slot 2","Slot 3","Slot 4","Slot 5"},Default=S.weapon,Flag="cam_weapon",Callback=function(v) S.weapon=v end})
    farmSec:Dropdown({Name="Attack timing",Items={"Game client (swing delay)","Instant (no swing delay)"},Default=S.attackTiming,Flag="cam_atktiming",Callback=function(v) S.attackTiming=v end})
    farmStatusLabel=farmSec:Label("Farm: OFF")
    button(farmSec,"Attack once (Combat_Service probe)",function()
        loadNative();local ok,msg=actions.fastAttackTick(nil);note((ok and "Attack: " or "Not sent: ")..tostring(msg))
    end)
    farmSec:Label("Fast Attack = the game's Combat_Service packet after the preset swing delay (working-script protocol), combo 1..Max.")
    farmSec:Label("Hold M1 = Tool_Mouse Down/Up (tool activation channel; it does not swing melee weapons).")
    farmSec:Label("Weapon prep never blocks: Item_Equip / Toolbar_Equip are sent once, then the fight continues with the equipped tool.")
    farmSec:Label("Defending targets (NpcCounter / Blocking) are skipped this pass. Death keeps every toggle ON.")""")

# --- snapshot: direct farm diagnostics ---
patch("""                catalogNpcs=#CAM_CATALOG.npcs,catalogQuests=#CAM_CATALOG.quests,loadedHumanoids=C.snapshotHostiles,combatBusy=C.combatBusy==true},target=m and m:GetFullName() or "none",ownership=ownership(m),""",
"""                catalogNpcs=#CAM_CATALOG.npcs,catalogQuests=#CAM_CATALOG.quests,loadedHumanoids=C.snapshotHostiles,combatBusy=C.combatBusy==true,
                direct={status=S.farmStatus,attackMode=S.m1Mode,attackTiming=S.attackTiming,weaponMode=S.weapon,equipment=S.equipment,
                    combatServiceSent=C.fatk.sent or 0,skippedDefending=C.fatk.skipped or 0,comboResyncs=C.fatk.resyncs or 0,lastCombat=C.fatk.lastCombat,lastReason=C.fatk.reason,
                    signalPath=C.signalPath or "not resolved",serverLastCombo=serverCombo(),farmTarget=C.farmTarget and C.farmTarget.m and C.farmTarget.m.Name or "none"},
                callbackErrors=C.callbackErrors or 0,lastCallbackError=C.lastCallbackError},target=m and m:GetFullName() or "none",ownership=ownership(m),""")

p.write_text(s)
print('patched',len(s.encode()),'bytes')
