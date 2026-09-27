from pathlib import Path
p=Path('cam_main_logic.lua');s=p.read_text()
def patch(old,new):
    global s
    assert old in s,'ANCHOR MISS: '+old[:90]
    s=s.replace(old,new,1)

# --- S defaults ---
patch("""        autoFish=false,fishDelay=1.0,fishNudge=8,wurfansClue="1"}""",
"""        autoFish=false,fishDelay=1.0,fishNudge=8,wurfansClue="1",treeNode="Max Health"}""")

# --- label decl ---
patch("    local statusLabel,targetLabel,resourceLabel,questLabel,nativeLabel,indexLabel,parryLabel,trainLabel,fishLabel",
"    local statusLabel,targetLabel,resourceLabel,questLabel,nativeLabel,indexLabel,parryLabel,trainLabel,fishLabel,treeLabel")

# --- helper: skill tree unlock (protocol captured live via probe: SignalFunction.ToServer("UnlockSkillTreeNode", name) -> true on server accept; deltas: SkillPoints / SkillPointsSpent / SkillTreeUnlockedList) ---
patch("""    -- v2.3.0 manual action helpers (explicit click only; no auto-spend loops)
    local function buyShop(withOre)""",
"""    -- v2.3.2 skill tree spend (protocol captured live by probe 1.1 on 2026-09-26).
    -- Manual single clicks only: spending real currency never runs in a loop here.
    local function treeRank(name)
        local d=data();if not d then return nil,nil end
        local points=d:FindFirstChild("SkillPoints")
        local rank=d:FindFirstChild("SkillTreeUnlockedList")
        if rank then rank=rank:FindFirstChild(name) end
        return (points and points.Value), (rank and type(rank.Value)=="number" and rank.Value or 0)
    end
    local function unlockTreeNode()
        local name=S.treeNode
        if not name or name=="" then return false,"Type the exact node name first (e.g. Max Health)" end
        local sf=C.modules.SignalF
        if not (sf and type(sf.ToServer)=="function") then return false,"Connect native controls first" end
        local beforePoints,beforeRank=treeRank(name)
        local ok,res=pcall(sf.ToServer,"UnlockSkillTreeNode",name)
        log("tree","UnlockSkillTreeNode "..name.." | sent="..tostring(ok).." | ret="..short(res))
        if not ok then return false,"Rejected: "..short(res) end
        if res==false then return false,"Server refused (no points / previous node missing / maxed)" end
        task.delay(0.4,function()
            local points,rank=treeRank(name)
            if points and beforePoints and points<beforePoints then
                note("Skill tree: accepted. Points "..beforePoints.." -> "..points..(rank and rank~=beforeRank and (", rank "..tostring(beforeRank).." -> "..tostring(rank)) or ""))
            else
                note("Unlock request sent; values unchanged yet (server-side check runs first)")
            end
        end)
        return true,"UnlockSkillTreeNode sent: "..name
    end
    -- v2.3.0 manual action helpers (explicit click only; no auto-spend loops)
    local function buyShop(withOre)""")

# --- heartbeat counters UI ---
patch("""            if fishLabel and fishLabel.SetText then fishLabel:SetText("Fishing: "..C.fish.casts.." casts / "..C.fish.bites.." bites / "..C.fish.wins.." wins") end""",
"""            if fishLabel and fishLabel.SetText then fishLabel:SetText("Fishing: "..C.fish.casts.." casts / "..C.fish.bites.." bites / "..C.fish.wins.." wins") end
            if treeLabel and treeLabel.SetText then
                local pts,rank=treeRank(S.treeNode)
                treeLabel:SetText("Skill points: "..tostring(pts).." | '"..tostring(S.treeNode).."' rank: "..tostring(rank))
            end""")

# --- UI section ---
patch("""    local pc=section(act,"auto parry (beta)")""",
"""    local tr=section(act,"skill tree (manual spend)",2)
    tr:Textbox({Name="Skill tree node (exact name)",Placeholder="e.g. Max Health",Default=S.treeNode,Callback=function(v) S.treeNode=v end})
    button(tr,"Unlock / level up node (UnlockSkillTreeNode)",function() loadNative();tell(unlockTreeNode()) end,true)
    treeLabel=tr:Label("Skill points: - | node rank: -")
    tr:Label("Single clicks only (real currency spend). Ack: points decrease + rank bump ~0.4s later.")
    tr:Label("Protocol captured live: SignalFunction ToServer UnlockSkillTreeNode(name), returns true on accept.")
    local pc=section(act,"auto parry (beta)")""")

# --- pending text ---
patch("""    pending:Label("Still not wired: skill-tree spend args (tree UI script absent from every dump), code redeem UI (no code remote exists in dumps), internal queue/wave scoring, gear scoring, instant-kill & infinite-stamina claims (server-side state; no client protocol found - claims rejected). One short probe run can finish the skill-tree case.")""",
"""    pending:Label("Still not wired: code redeem UI (no code remote exists in any dump), internal queue/wave scoring, gear scoring. Rejected as impossible client-side: instant-kill & infinite-stamina (server-authoritative). Everything else on the tracker ships in 2.2.x-2.3.x.")""")

# --- version bumps ---
patch("Version=\"2.3.1 / + fishing, quest, npc actions\"",'Version="2.3.2 / + skill tree spend"')
patch('Snapshot=snapshot,Version="2.3.1"}','Snapshot=snapshot,Version="2.3.2"}')
assert 'CAM Main Hub 2.3.1' in s;s=s.replace('CAM Main Hub 2.3.1','CAM Main Hub 2.3.2')
assert 'CAM Main 2.3.1 ready' in s;s=s.replace('CAM Main 2.3.1 ready','CAM Main 2.3.2 ready')
p.write_text(s)
print('v232 logic patched; size',len(s))
