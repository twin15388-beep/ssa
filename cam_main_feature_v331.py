from pathlib import Path
# CAM Main Hub 3.3.1 - server hitbox facts applied (reach-aware defaults + status), and the working-script
# Combat_Service channel offered to the classic path (Auto Level / classic farm / Auto M1 / Kill Aura) as
# "M1 input backend = Combat_Service (direct)" (default). Legacy backends stay selectable.
p=Path('cam_main_logic.lua');s=p.read_text()
def patch(old,new):
    global s
    assert old in s,'ANCHOR MISS: '+old[:90]
    s=s.replace(old,new,1)

# --- forward-declare `actions`: stopAll() (L~241) and attackOnce() run before `local actions={}` and used to hit a nil global
#     (pre-existing since 3.2.x: every stopAll() threw "attempt to index a nil value (global 'actions')" mid-cleanup) ---
patch("    local stopAll,clearESP,refreshTargets,refreshDestinations,refreshHunts,endTravel\n",
"    local stopAll,clearESP,refreshTargets,refreshDestinations,refreshHunts,endTravel,actions\n")
patch("\n    local actions={}\n","\n    actions={}\n")

# --- version strings ---
patch("-- CAM Main Hub 3.3.0 |","-- CAM Main Hub 3.3.1 |")
patch('return {format="CAM Main Hub 3.3.0",','return {format="CAM Main Hub 3.3.1",')
patch('Snapshot=snapshot,Version="3.3.0"}','Snapshot=snapshot,Version="3.3.1"}')
patch('Version="3.3.0 / + working-script combat core, live farm status"','Version="3.3.1 / + working-script combat core, reach-aware farm"')
patch('note("CAM Main 3.3.0 ready.','note("CAM Main 3.3.1 ready.')

# --- defaults: inside the server hitbox (Get_Players_For_Combat: fists reach ~5 studs, katana-type ~6) ---
patch('farmStyle="Behind",farmDist=6,farmHeight=7,','farmStyle="Behind",farmDist=4,farmHeight=5,')
patch('lookMode="Horizontal",inputMode="Auto (live punch / native input)",','lookMode="Horizontal",inputMode="Combat_Service (direct)",')

# --- combat core: reach estimate from the shared hitbox module ---
patch("""    local function playSwing(rc,combo,aspd)""",
"""    local function combatReach(preset,combo)
        -- Combat_presets.Get_Players_For_Combat (shared module, the server runs the same maths): standing still the hit
        -- box is (6+W) x (6.25+W) x (9+D) studs, centred 1 stud under the root and pushed forward only by
        -- MinHitboxSize/Reaches (lunge distance is 0 for a non-running hit). Forward extent = 4.5 + 1.25*reach + D/2 + Z.
        local function pick(field) local t=preset[field];if type(t)~="table" then return 0 end;return t[combo] or t.Default or 0 end
        local reach=(preset.MinHitboxSize or 0)+pick("Reaches")
        return 4.5+reach*1.25+pick("Depths")/2+pick("ZOffsets")
    end
    local function playSwing(rc,combo,aspd)""")
patch("""        local serverHitDelay,interval,swingDelay,aspd=combatTiming(cp,rc.preset,combo)
        playSwing(rc,combo,aspd)""",
"""        local serverHitDelay,interval,swingDelay,aspd=combatTiming(cp,rc.preset,combo)
        C.fatk.reach=combatReach(rc.preset,combo)
        playSwing(rc,combo,aspd)""")

# --- farmTick: reach hint in the live status (target root beyond the box -> say so, keep attacking; server decides) ---
patch("""            elseif not inRange then atkMsg="approaching"
            else local _,m=actions.fastAttackTick(t.m);atkMsg=m end
            pcall(actions.m1Up)""",
"""            elseif not inRange then atkMsg="approaching"
            else
                local _,m=actions.fastAttackTick(t.m);atkMsg=m
                if C.fatk.reach and dist>C.fatk.reach+0.5 then atkMsg=tostring(m).." | dist "..string.format("%.1f",dist).." > hitbox reach~"..string.format("%.1f",C.fatk.reach+0.5).." (lower Distance / height)" end
            end
            pcall(actions.m1Up)""")

# --- classic attackOnce(): Combat_Service (direct) backend, weapon prep never blocks ---
patch("""        if d>S.hitRange then return false,"Travelling: target outside M1 range" end
        local ready,msg=ensureEquipment()
        if not ready then
            C.equipmentWait=C.equipmentWait or os.clock()""",
"""        if d>S.hitRange then return false,"Travelling: target outside M1 range" end
        if S.inputMode=="Combat_Service (direct)" then
            -- v3.3.1: same working-script channel as the direct farm (Combat_Service after the preset swing delay);
            -- weapon prep is best effort, the only stop left is the explicit "STOP after no target damage" slider.
            local eqMsg=actions.prepareWeapon()
            face(m);C.attackRequests=(C.attackRequests or 0)+1;C.inputBackend="Combat_Service (direct)"
            local h=m:FindFirstChildOfClass("Humanoid")
            if not C.damageWatch or C.damageWatch.target~=m then C.damageWatch={target=m,hp=h.Health,time=os.clock(),combo=comboTime()} end
            local watch=C.damageWatch
            if h.Health<watch.hp then C.damageEvents=(C.damageEvents or 0)+1;watch.time=os.clock();watch.hp=h.Health end
            if os.clock()-watch.time>S.noDamageTimeout then
                stopAll("No target HP decrease for "..S.noDamageTimeout.."s (Combat_Service sent "..(C.fatk.sent or 0)..", dist "..string.format("%.1f",d)..(C.fatk.reach and (", hitbox reach~"..string.format("%.1f",C.fatk.reach+0.5)) or "").."): lower distance/height or check the target")
                return false,S.status
            end
            local sent,msg=actions.fastAttackTick(m)
            if C.fatk.reach and d>C.fatk.reach+0.5 then msg=tostring(msg).." | dist "..string.format("%.1f",d).." > hitbox reach~"..string.format("%.1f",C.fatk.reach+0.5) end
            C.lastCombatResult=msg
            return sent,tostring(msg).." | "..eqMsg
        end
        local ready,msg=ensureEquipment()
        if not ready then
            C.equipmentWait=C.equipmentWait or os.clock()""")

# --- kill aura: direct backend uses the same channel (box is centred on the root, so any mob inside it is hit) ---
patch("""        if not best then return false,"No mob in aura range" end
        local punch=(S.inputMode~="Native input only") and findPunch() or nil""",
"""        if not best then return false,"No mob in aura range" end
        if S.inputMode=="Combat_Service (direct)" then
            local sent,msg=actions.fastAttackTick(best.n)
            return sent,"Aura "..tostring(msg).." -> "..tostring(best.n.Name).." @"..math.floor(bd)
        end
        local punch=(S.inputMode~="Native input only") and findPunch() or nil""")

# --- UI copy ---
patch("""    cfPos:Dropdown({Name="M1 input backend",Items={"Auto (live punch / native input)","Native input only"},Default=S.inputMode,Flag="cam_inputmode",Callback=function(v) S.inputMode=v;release("Combat");C.damageWatch=nil end})""",
"""    cfPos:Dropdown({Name="M1 input backend",Items={"Combat_Service (direct)","Auto (live punch / native input)","Native input only"},Default=S.inputMode,Flag="cam_inputmode",Callback=function(v) S.inputMode=v;release("Combat");C.damageWatch=nil end})
    cfPos:Label("Combat_Service (direct) = the working-script packet (preset timing, Attack timing option applies); M1 interval slider is for the input backends.")""")
patch("""    farmSec:Label("Defending targets (NpcCounter / Blocking) are skipped this pass. Death keeps every toggle ON.")""",
"""    farmSec:Label("Server hitbox (Get_Players_For_Combat): 9-stud box centred on you -> fists reach ~5 studs, katana-type ~6. Keep Distance <= 4; the status warns when the target is beyond reach.")
    farmSec:Label("Defending targets (NpcCounter / Blocking) are skipped this pass. Death keeps every toggle ON.")""")

# --- snapshot: reach + backend ---
patch("""signalPath=C.signalPath or "not resolved",serverLastCombo=serverCombo(),""",
"""signalPath=C.signalPath or "not resolved",serverLastCombo=serverCombo(),hitboxReach=C.fatk.reach,classicBackend=S.inputMode,""")

p.write_text(s)
print('patched',len(s.encode()),'bytes')
