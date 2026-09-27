"""CAM Main 2.2.0: farm-noclip fall-through fix, Highlight/Billboard ESP rework,
native bait equip (sourced EquipBait), and UI declutter. Applied after the 2.1.0 patch."""
def apply_feature(s):
    if 'Version="2.2.0"' in s:
        return s
    assert 'Version="2.1.0"' in s
    def patch(old,new):
        nonlocal s
        assert old in s, old[:140]
        s=s.replace(old,new,1)
    # ---- version ----
    assert s.count('2.1.0')==5, s.count('2.1.0')
    s=s.replace('2.1.0','2.2.0')
    s=s.replace('2.2.0 / farm noclip + auto potion','2.2.0 / ESP rework + farm clip fix')
    # ---- state: bait selection ----
    patch('potionChoice="Auto (strongest heal)",','potionChoice="Auto (strongest heal)",baitName="",')
    # ---- farm noclip: only while actually travelling to / holding a target ----
    # Standing stages (accept/turn-in/wait) and Walk mode keep collisions, so the
    # character no longer falls through the floor mid-farm.
    patch('        if S.noclip or (S.farmNoclip and (S.autoLevel or S.farm) and not S.fly) then',
          '''        local autoClip=S.farmNoclip and C.goal~=nil and (S.autoLevel or S.farm) and S.travelMode~="Walk" and not S.fly
        if S.noclip or autoClip then''')
    # ---- ESP rework: Highlight + world BillboardGui instead of projected 2D frames ----
    start=s.index('    -- Screen-space overlays, no Drawing API or external assets.')
    stop=s.index('    local function moveStep()',start)
    s=s[:start]+'''    -- World-anchored ESP: Highlight + BillboardGui live on the streamed objects.
    -- Scan runs on a slow clock; only tracer line positions update at render rate.
    local gui=Instance.new("ScreenGui");gui.Name="CAM_Main_Overlay";gui.ResetOnSpawn=false;gui.IgnoreGuiInset=true;gui.DisplayOrder=40;gui.Parent=LP:WaitForChild("PlayerGui")
    local colors={Player=Color3.fromRGB(90,174,255),Mob=Color3.fromRGB(255,120,90),Boss=Color3.fromRGB(255,80,110),NPC=Color3.fromRGB(200,180,255),Chest=Color3.fromRGB(255,218,95),Loot=Color3.fromRGB(95,240,160),Muzan=Color3.fromRGB(230,70,220),["Spider Lily"]=Color3.fromRGB(255,120,200),Lever=Color3.fromRGB(90,220,220),["Wild Horse"]=Color3.fromRGB(220,190,140)}
    local espFlags={Player="players",Mob="mobs",Boss="bosses",NPC="npcs",Chest="chests",Loot="drops",Muzan="muzan",["Spider Lily"]="lily",Lever="levers",["Wild Horse"]="horses"}
    local function make(class,props,parent)
        local o=Instance.new(class);for k,v in pairs(props or {}) do o[k]=v end;o.Parent=parent;return o
    end
    local function line(frame,a,b)
        local dx,dy=b.X-a.X,b.Y-a.Y
        frame.Position=UDim2.fromOffset((a.X+b.X)/2,(a.Y+b.Y)/2)
        frame.Size=UDim2.fromOffset(math.sqrt(dx*dx+dy*dy),1)
        frame.Rotation=math.deg(math.atan2(dy,dx));frame.Visible=true
    end
    local function clearVisual(v)
        if v.hl then v.hl:Destroy() end
        if v.bb then v.bb:Destroy() end
        if v.tracer then v.tracer:Destroy() end
    end
    clearESP=function() for o,v in pairs(C.esp) do clearVisual(v);C.esp[o]=nil end end
    local function visual(o,k)
        local color=colors[k] or Color3.fromRGB(130,240,220)
        local v={color=color}
        v.hl=make("Highlight",{Name="CAM_ESP",FillColor=color,OutlineColor=color,FillTransparency=0.8,OutlineTransparency=0,DepthMode=Enum.HighlightDepthMode.AlwaysOnTop},o)
        local anchor=o:IsA("BasePart") and o or (o:FindFirstChild("HumanoidRootPart") or part(o))
        if anchor then
            v.bb=make("BillboardGui",{Name="CAM_ESP",Size=UDim2.fromOffset(180,44),StudsOffsetWorldSpace=Vector3.new(0,3,0),AlwaysOnTop=true},anchor)
            v.label=make("TextLabel",{Size=UDim2.fromScale(1,0.62),BackgroundTransparency=1,TextColor3=color,TextStrokeTransparency=0.3,TextSize=12,Font=Enum.Font.GothamBold,Text=""},v.bb)
            v.bar=make("Frame",{AnchorPoint=Vector2.new(0.5,0),Position=UDim2.fromScale(0.5,0.74),Size=UDim2.new(0.8,0,0.14,0),BackgroundColor3=Color3.fromRGB(25,26,32),BorderSizePixel=0,Visible=false},v.bb)
            v.hp=make("Frame",{Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.fromRGB(85,225,125),BorderSizePixel=0},v.bar)
        end
        C.esp[o]=v;return v
    end
    local function refreshText(v,o,d)
        if not v.bb then return end
        local h=o:IsA("Model") and o:FindFirstChildOfClass("Humanoid")
        v.label.Text=S.names and (o.Name..(h and ("  "..math.floor(h.Health).."/"..math.floor(h.MaxHealth)) or "").."\\n"..math.floor(d).." st") or ""
        v.bar.Visible=S.hpbar and h~=nil
        if h then v.hp.Size=UDim2.fromScale(math.max(0,math.min(1,h.Health/math.max(h.MaxHealth,1))),1) end
    end
    local function renderESP()
        if not S.esp then if next(C.esp) then clearESP() end return end
        local _,_,r=char();if not r then return end
        local candidates={}
        for o,k in pairs(C.objects) do
            if live(o) and o~=LP.Character then
                if (k=="Mob" or k=="Boss" or k=="NPC" or k=="Player") and o:IsA("Model") and o:FindFirstChildOfClass("Humanoid") then k=kindOfNPC(o) end
                if espFlags[k] and S[espFlags[k]] then
                    local p=part(o)
                    if p then local d=(p.Position-r.Position).Magnitude;if d<=S.espRange then candidates[#candidates+1]={o=o,k=k,d=d,p=p} end end
                end
            end
        end
        table.sort(candidates,function(a,b) return a.d<b.d end)
        local kept={}
        for i=1,math.min(#candidates,S.espLimit) do
            local item=candidates[i];local o=item.o
            local v=C.esp[o] or visual(o,item.k);kept[o]=true
            refreshText(v,o,item.d)
        end
        for o,v in pairs(C.esp) do if not kept[o] then clearVisual(v);C.esp[o]=nil end end
    end
    local function tracerStep()
        if not (S.esp and S.tracer) then
            for _,v in pairs(C.esp) do if v.tracer then v.tracer.Visible=false end end
            return
        end
        local camera=workspace.CurrentCamera;local vp=camera and camera.ViewportSize
        if not vp then return end
        for o,v in pairs(C.esp) do
            local p=live(o) and part(o)
            local s=p and camera:WorldToViewportPoint(p.Position)
            if p and s.Z>0 and s.X>=0 and s.Y>=0 and s.X<=vp.X and s.Y<=vp.Y then
                if not v.tracer then v.tracer=make("Frame",{AnchorPoint=Vector2.new(0.5,0.5),BackgroundColor3=v.color,BorderSizePixel=0},gui) end
                line(v.tracer,Vector2.new(vp.X/2,vp.Y),Vector2.new(s.X,s.Y))
            elseif v.tracer then v.tracer.Visible=false end
        end
    end
'''+s[stop:]
    # ---- render cadence: tracers at render rate, Highlight scan at 0.45s ----
    patch('''        elapsed=elapsed+dt;uiTime=uiTime+dt;C.visualClock=C.visualClock+dt
        if C.visualClock>=0.08 then C.visualClock=0;renderESP() end''','''        elapsed=elapsed+dt;uiTime=uiTime+dt;C.visualClock=C.visualClock+dt;C.espClock=(C.espClock or 0)+dt
        if C.visualClock>=0.08 then C.visualClock=0;tracerStep() end
        if C.espClock>=0.45 then C.espClock=0;renderESP() end''')
    # ---- native bait equip (sourced: Bait tool -> SignalEvent.ToServer("EquipBait", id|0), ack Misc/EquippedBaitId) ----
    patch('    local directPotions=','''    local function baitScan()
        C.baitItems={};local names={}
        local d=data();local inv=d and at(d,{"Inventory","Inventory"})
        if inv then
            for _,item in ipairs(inv:GetChildren()) do
                local id=item:FindFirstChild("Id")
                if id and id:IsA("ValueBase") and item.Name:lower():find("bait",1,true) then
                    local label=item.Name.." #"..tostring(id.Value)
                    names[#names+1]=label;C.baitItems[label]=id.Value
                end
            end
        end
        table.sort(names);return names
    end
    local function equippedBait()
        local d=data();local v=d and at(d,{"Misc","EquippedBaitId"})
        return (v and v:IsA("ValueBase")) and v.Value or 0
    end
    local function baitRequest(id)
        local signal=C.modules.Signal
        if not signal or type(signal.ToServer)~="function" then return false,"Connect native controls first" end
        local ok,err=pcall(signal.ToServer,"EquipBait",id)
        if not ok then return false,short(err) end
        C.baitRequests=(C.baitRequests or 0)+1;C.baitWatch={id=id,deadline=os.clock()+3}
        log("bait","EquipBait "..tostring(id).." requested")
        return true,"Bait request sent; watching Misc/EquippedBaitId"
    end
    local directPotions=''')
    # ---- bait acknowledgement watch in the scheduler ----
    patch('        if S.autoPotion then usePotion(h) end','''        if S.autoPotion then usePotion(h) end
        if C.baitWatch then
            local d=data();local v=d and at(d,{"Misc","EquippedBaitId"})
            local cur=v and v:IsA("ValueBase") and v.Value
            if cur~=nil and cur==C.baitWatch.id then
                C.baitAcks=(C.baitAcks or 0)+1;log("bait","Misc/EquippedBaitId = "..tostring(cur).." acknowledged");C.baitWatch=nil
            elseif os.clock()>C.baitWatch.deadline then
                log("bait","No EquippedBaitId acknowledgement; server may have declined");C.baitWatch=nil
            end
        end''')
    # ---- diagnostics counters ----
    patch('damageObservations=C.damageEvents or 0,potionRequests=C.potionRequests or 0,potionAcks=C.potionAcks or 0,potionFailures=C.potionFailures or 0,',
          'damageObservations=C.damageEvents or 0,potionRequests=C.potionRequests or 0,potionAcks=C.potionAcks or 0,potionFailures=C.potionFailures or 0,baitRequests=C.baitRequests or 0,baitAcks=C.baitAcks or 0,')
    # ---- declutter: limits ----
    patch('''    limits:Label("All toggles start OFF; no config autoload.")
    limits:Label("Native modules load on Connect or enabling a combat mode.")
    limits:Label("Wrong place: gameplay controls locked.")
    limits:Label("47 source-backed hostiles; selected or nearest mode.")
    limits:Label("Other players are never farm targets.")
    limits:Label("No purchases, skill-point spending or race change.")
    limits:Label("Native checks and server validation still apply.")
    limits:Label("No real-client test performed by the author.")''','''    limits:Label("All toggles start OFF; wrong place locks gameplay controls.")
    limits:Label("47 source-backed hostiles; other players are never targets.")
    limits:Label("No purchases / spending / race change; native + server checks still apply.")''')
    # ---- declutter: auto level intro ----
    patch('''    al:Label("17 free repeatable kill routes; level thresholds 1-115.")
    al:Label("Checks current level, race and native requirements.")
    al:Label("Active supported quest is finished before switching.")
    al:Label("NPC -> AddQuest -> replicated holder -> kills -> closure.")
    al:Label("Native cooldown respected; no fake CompleteQuest call.")''','''    al:Label("17 repeatable kill routes by level; active quest finishes before switching.")
    al:Label("NPC -> AddQuest -> holder -> kills -> native closure. No fake CompleteQuest.")''')
    # ---- declutter: positions / equipment / skills / potion ----
    patch('''    posSec:Label("Above default: height 3, distance 2. Not immunity.")
    posSec:Label("Tween = speed-limited linear movement each frame.")
    posSec:Label("Walk cannot hover. High offsets can make M1 miss.")''',
          '    posSec:Label("Above default. Walk cannot hover; high offsets can make M1 miss.")')
    patch('''    eqSec:Label("Auto keeps usable weapon; otherwise prefers slot 3 / 1.")
    eqSec:Label("No item buying or toolbar rewriting. Native restrictions apply.")
    eqSec:Label("Live Combat.punch uses getsenv only if supported.")
    eqSec:Label("Fallback InputHandler is not called success until observed.")
    eqSec:Label("No mouse clicks that could accidentally press hub buttons.")''','''    eqSec:Label("Equips an existing toolbar weapon (prefers slot 3 / 1); native restrictions apply.")
    eqSec:Label("Native punch via getsenv when supported; success only from observed combos.")''')
    patch('''    sk:Label("Aim uses the game's native mouse/camera; no aim hook.")
    sk:Label("Slot 1 may be block; choose slots deliberately.")''',
          '    sk:Label("Native aim; slot 1 may be block - choose slots deliberately.")')
    patch('''    ps:Label("The potion must already sit on toolbar slot 1-5; drinking consumes the item.")
    ps:Label("Native equip + click path; acknowledged by HP increase or item consumption.")
    ps:Label("Keep 'Use below HP percent' above 'STOP at HP percent' or it never fires.")''','''    ps:Label("Potion must sit on toolbar slot 1-5; drinking consumes the item.")
    ps:Label("HP threshold must stay above the STOP threshold or it never fires.")''')
    patch('''    sk:Label("Low HP / menu / death pause or stop actions.")
    sk:Label("Hunt requests wait while combat mode is enabled.")\n''','')
    # ---- declutter: quests / hunts / loot / toolbar / movement / teleport notes ----
    patch('''    qs:Label("Requires Book of Guidance / native eligibility.")
    qs:Label("Use Auto Level page for the repeatable kill-quest loop.")
    qs:Label("Recommendation is NOT acceptance or completion.")''',
          '    qs:Label("Recommendation is not acceptance; the loop lives on the Auto Level page.")')
    patch('''    hs:Label("Race / expiry / CanAddQuest are checked.")
    hs:Label("No auto claim of a new ID; select it explicitly.")
    hs:Label("Farm boss separately; completion is server-controlled.")''',
          '    hs:Label("Claims the selected ID once; race/expiry checked; completion stays server-side.")')
    patch('''    ls:Label("No prompt = no supported automatic interaction.")
    ls:Label("No remote or touch-pickup payload is guessed.")
    ls:Label("Locked caches are skipped; no guard instant kill.")
    ls:Label("Instant hold applies to hub interactions only.")
    ls:Label("Not a server timing bypass.")''','''    ls:Label("No prompt = no supported automatic interaction; no payload guesses.")
    ls:Label("Locked caches are skipped; no guard instant kill.")''')
    patch('''    inv:Label("Same slot assignment as Utility.ForceEquip.")
    inv:Label("No invented 'best gear' scoring or inventory edits.")
    inv:Label("Auto Potion / Auto Buy are not wired in this build.")''',
          '    inv:Label("Equips existing toolbar slots only; no invented best-gear scoring.")')
    patch('''    ms:Label("Local movement can be corrected by the server.")
    ms:Label("Hold Run follows native toggle/hold preferences.")''',
          '    ms:Label("Local movement can be corrected by the server.")')
    patch('    farmNoclipRef:Set(S.farmNoclip,true)',
          '''    farmNoclipRef:Set(S.farmNoclip,true)
    ms:Label("Auto noclip only while travelling to / holding a target (not Walk mode).")''')
    # ---- ESP UI rework + declutter ----
    patch('''    local es=section(ep,"categories")
    toggle(es,"Enable ESP","esp",function(v) if not v then clearESP() end end,true)
    for _,row in ipairs({{"Player ESP","players"},{"Mob ESP (NPC candidates)","mobs"},{"Boss ESP","bosses"},{"NPC ESP (dialogue-tagged)","npcs"},{"Chest ESP","chests"},{"Loot ESP","drops"},{"Muzan ESP","muzan"},{"Spider Lily ESP","lily"},{"Lever ESP","levers"},{"Wild Horse ESP (exact name)","horses"}}) do toggle(es,row[1],row[2],nil,true) end
    button(es,"Enable basic mob / boss ESP",function()
        for _,key in ipairs({"esp","mobs","bosses","box","names","distance","health"}) do flag(key,true) end
    end)
    slider(es,"ESP range","espRange",50,2000);slider(es,"Max objects drawn","espLimit",5,80)
    es:Label("Only streamed objects; neutral NPC classification is conservative.")
    local ev=section(ep,"styles / local notifications",2)
    for _,row in ipairs({{"Box ESP","box"},{"Box Fill ESP","fill"},{"3D Box ESP","box3d"},{"Name ESP","names"},{"Distance ESP","distance"},{"Health Text ESP","health"},{"Health Bar ESP","hpbar"},{"Tracer ESP","tracer"}}) do toggle(ev,row[1],row[2],nil,true) end
    toggle(ev,"Boss streamed-in notification","notifyBoss",nil,true)
    toggle(ev,"Muzan streamed-in notification","notifyMuzan",nil,true)
    toggle(ev,"New eligible Boss Hunt notification","notifyHunts",nil,true)
    ev:Label("Stream-in is not proof of a new server-wide spawn.")
    ev:Label("No webhook / external upload is implemented.")''','''    local es=section(ep,"categories")
    toggle(es,"Enable ESP (Highlight chams)","esp",function(v) if not v then clearESP() end end,true)
    for _,row in ipairs({{"Player ESP","players"},{"Mob ESP","mobs"},{"Boss ESP","bosses"},{"NPC ESP","npcs"},{"Chest ESP","chests"},{"Loot ESP","drops"},{"Muzan ESP","muzan"},{"Spider Lily ESP","lily"},{"Lever ESP","levers"},{"Wild Horse ESP","horses"}}) do toggle(es,row[1],row[2],nil,true) end
    button(es,"Enable basic mob / boss ESP",function()
        for _,key in ipairs({"esp","mobs","bosses","names","hpbar"}) do flag(key,true) end
    end)
    slider(es,"ESP range","espRange",50,2000);slider(es,"Max objects drawn","espLimit",5,80)
    local ev=section(ep,"styles / notifications",2)
    toggle(ev,"Text: name / HP / distance","names",nil,true)
    toggle(ev,"Health bar","hpbar",nil,true)
    toggle(ev,"Tracers (screen lines)","tracer",nil,true)
    toggle(ev,"Boss streamed-in notification","notifyBoss",nil,true)
    toggle(ev,"Muzan streamed-in notification","notifyMuzan",nil,true)
    toggle(ev,"New eligible Boss Hunt notification","notifyHunts",nil,true)
    ev:Label("World-anchored Highlight ESP, streamed objects only; stream-in is not a server-wide spawn proof.")''')
    # ---- bait UI on the loot / interaction page ----
    patch('    inv:Label("Equips existing toolbar slots only; no invented best-gear scoring.")',
          '''    inv:Label("Equips existing toolbar slots only; no invented best-gear scoring.")
    local bs=section(lootpage,"fishing bait (native signal)",2)
    local baitDrop=bs:Dropdown({Name="Bait from inventory",Items={"Refresh bait list"},Default="Refresh bait list",Flag="cam_bait",Callback=function(v) S.baitName=v end})
    button(bs,"Refresh bait list",function() local names=baitScan();baitDrop:Refresh(#names>0 and names or {"No bait-named items found"});note("Bait items found: "..#names) end)
    button(bs,"Equip selected bait",function()
        local id=C.baitItems and C.baitItems[S.baitName]
        if not id then note("Refresh the bait list and select an item first") return end
        if equippedBait()==id then note("Already equipped; use Unequip to toggle off") return end
        tell(baitRequest(id))
    end,true)
    button(bs,"Unequip bait",function() if equippedBait()==0 then note("No bait equipped") return end tell(baitRequest(0)) end,true)
    bs:Label("Native EquipBait signal; ack via Misc/EquippedBaitId. Casting/minigame not wired yet.")''')
    # ---- diagnostics page declutter ----
    patch('''    ds:Label("Send this report if a native integration is unavailable.")
    ds:Label("Report is small; overview UTF-8 fallback is included.")''',
          '    ds:Label("Send this one-click report when a native integration misbehaves.")')
    old_pending_start=s.index('    for _,text in ipairs({"Delivery / escort / fishing quest automation"')
    old_pending_stop=s.index('    pending:Label("See the supplied feature matrix for exact limits.")',old_pending_start)+len('    pending:Label("See the supplied feature matrix for exact limits.")')
    s=s[:old_pending_start]+'    pending:Label("Not wired yet: delivery/escort quests; queues/cards/waves; breathing & skill-tree spending; training; fishing cast/minigame; purchases & gear scoring; parry; souls/schematics; codes; race change; instant-kill & stamina claims. They ship after targeted evidence, not as fake toggles.")'+s[old_pending_stop:]
    return s
