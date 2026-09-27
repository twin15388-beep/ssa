"""Small, reproducible patch on the source-backed v2 engine. Does not change combat/quest rules."""
def apply_hotfix(s):
    if 'Version="2.0.1"' in s:
        return s
    def patch(old,new):
        nonlocal s
        assert old in s,old[:140]
        s=s.replace(old,new,1)
    patch('humanoids={},objects={},prompts={},esp={},cooldowns={},huntSent={},huntSeen={},',
          'humanoids={},humanoidOwners=setmetatable({}, {__mode="k"}),objects={},prompts={},esp={},cooldowns={},huntSent={},huntSeen={},')
    patch('''        if o:IsA("Humanoid") and o.Parent:IsA("Model") then
            C.humanoids[o.Parent]=true;C.objects[o.Parent]=kindOfNPC(o.Parent)
            local m=o.Parent;local k=C.objects[m]''','''        local owner=o.Parent
        if o:IsA("Humanoid") and owner and owner:IsA("Model") then
            -- Cache ownership before removal: Parent may already be nil when destruction is observed.
            C.humanoids[owner]=o;C.humanoidOwners[o]=owner;C.objects[owner]=kindOfNPC(owner)
            local m=owner;local k=C.objects[m]''')
    patch('''    local function remove(o)
        C.humanoids[o]=nil;C.objects[o]=nil;C.prompts[o]=nil;C.seen[o]=nil;C.cooldowns[o]=nil
        if o:IsA("Humanoid") then C.humanoids[o.Parent]=nil end
        if C.activePrompt==o then endPrompt() end
    end''','''    local function remove(o)
        if not o then return end
        local removedModel
        if o:IsA("Humanoid") then
            local owner=C.humanoidOwners[o] or o.Parent
            C.humanoidOwners[o]=nil
            -- A late callback for an old Humanoid must not erase a newly indexed replacement.
            if owner and C.humanoids[owner]==o then
                C.humanoids[owner]=nil;C.objects[owner]=nil;C.seen[owner]=nil;C.cooldowns[owner]=nil
                removedModel=owner
            end
        elseif o:IsA("Model") then
            local humanoid=C.humanoids[o]
            if humanoid then C.humanoidOwners[humanoid]=nil end
            C.humanoids[o]=nil;removedModel=o
        end
        C.objects[o]=nil;C.prompts[o]=nil;C.seen[o]=nil;C.cooldowns[o]=nil
        if removedModel then
            if S.target==removedModel then S.target=nil;C.damageWatch=nil;release("Combat") end
            if C.goalTarget==removedModel and endTravel then endTravel() end
        end
        if C.activePrompt==o then endPrompt() end
    end''')
    patch('local function connect(signal,fn)', 'local function connect(signal,fn,label)')
    patch('if not ok then log("callback error",err);if stopAll then stopAll("Callback failed; see diagnostics") end end',
          'if not ok then log("callback error",(label or "Callback")..": "..tostring(err));if stopAll then stopAll("Callback failed; see diagnostics") end end')
    patch('connect(workspace.DescendantAdded,add)', 'connect(workspace.DescendantAdded,add,"Workspace.DescendantAdded")')
    patch('connect(workspace.DescendantRemoving,remove)', 'connect(workspace.DescendantRemoving,remove,"Workspace.DescendantRemoving")')
    patch('''    stopAll=function(reason)
        S.epoch=S.epoch+1''','''    stopAll=function(reason)
        local _,h=char();local v=values();local stamina=v and v:FindFirstChild("Stamina")
        C.lastStop={reason=reason or "Stopped",timeUTC=os.date("!%Y-%m-%dT%H:%M:%SZ"),
            autoLevelWasOn=S.autoLevel,farmWasOn=S.farm,questStage=S.questStage,questName=S.questName,
            hp=h and h.Health or nil,maxHp=h and h.MaxHealth or nil,stamina=stamina and stamina.Value or nil,
            backend=C.inputBackend or "not used"}
        S.epoch=S.epoch+1''')
    patch('''        note("Loading allowlisted native controls. No gameplay action is requested by the hub.")''','''        local ready,total=0,0
        for key in pairs(modulePaths) do total=total+1;if C.modules[key] then ready=ready+1 end end
        note(ready==total and "Native controls ready. Enabled modes continue automatically." or
            ("Connecting native controls: "..ready.."/"..total.." ready. See dashboard for progress."))''')
    patch('''        C.snapshotHostiles=loaded
        return {format="CAM Main Hub 2.0"''','''        C.snapshotHostiles=loaded
        -- Freeze this snapshot's log; later messages must not rewrite a recorder's runtimeBefore.
        local frozenLog={}
        for _,entry in ipairs(C.logs) do frozenLog[#frozenLog+1]={time=entry.time,kind=entry.kind,text=entry.text} end
        return {format="CAM Main Hub 2.0"''')
    patch('state=state,modules=modules,log=C.logs,', 'state=state,modules=modules,log=frozenLog,lastStop=C.lastStop,')
    s=s.replace('CAM Main Hub 2.0','CAM Main Hub 2.0.1').replace('CAM Main 2.0 ready','CAM Main 2.0.1 ready')
    s=s.replace('Version="2.0"','Version="2.0.1"').replace('Version="2.0 / content 5354"','Version="2.0.1 / streaming fix"')
    return s

if __name__=='__main__':
    from pathlib import Path
    p=Path('cam_main_logic.lua');s=p.read_text()
    backup=Path('cam_main_v2_0_before_hotfix.lua')
    if not backup.exists():backup.write_text(s)
    p.write_text(apply_hotfix(s))
    print('Applied v2.0.1 streaming hotfix')
