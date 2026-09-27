-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local HttpService = game:GetService("HttpService");
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local Components = script:WaitForChild("Components");
local Dependencies = script:WaitForChild("Dependencies");
local ImOverlay = require(Dependencies:WaitForChild("Debug"):WaitForChild("ImOverlay"));
local Config = require(script:WaitForChild("Config"));
local Frustum = require(Dependencies:WaitForChild("Frustum"));
local Utilities = require(Dependencies:WaitForChild("Utilities"));
local u1 = nil;
local Bone = require(Components:WaitForChild("Bone"));
local BoneTree = require(Components:WaitForChild("BoneTree"));
local ColliderObject = require(Components:WaitForChild("Collision"):WaitForChild("ColliderObject"));
local Runtime = Dependencies:WaitForChild("Runtime");

local function CopyPasteAttributes(p2: userdata, p3: userdata) -- Line: 22
    for i, v in p2:GetAttributes() do
        p3:SetAttribute(i, v);
    end;
end;

local SB_INDENT_LOG = Utilities.SB_INDENT_LOG;
local SB_UNINDENT_LOG = Utilities.SB_UNINDENT_LOG;
local SB_VERBOSE_LOG = Utilities.SB_VERBOSE_LOG;
local SB_VERBOSE_WARN = Utilities.SB_VERBOSE_WARN;
local u4 = {};
u4.__index = u4;

function u4.new() -- Line: 73
    -- upvalues: HttpService (copy), u4 (copy)
    local v5 = {
        ShouldDestroy = false,
        m_SteppedColliders = false,
        ID = HttpService:GenerateGUID(false),
        BoneTrees = {},
        ColliderObjects = {},
        m_FrustumObject = {
            Size = Vector3.new(0, 0, 0),
            CFrame = CFrame.identity
        },
        m_PendingApply = {},
        m_PendingDestroy = {}
    };

    return setmetatable(v5, u4);
end;

function u4.m_AppendBone(p6: table, p7: any, p8: userdata, p9: number, p10: number) -- Line: 101
    -- upvalues: Utilities (copy), Bone (copy), SB_VERBOSE_LOG (copy)
    local v11 = Utilities.GatherBoneSettings(p8);
    local v12 = Bone.new(p8, p7.Root, p7.RootPart);

    for i, v in v11 do
        local v13;

        if v == "¬" or not v then
            v13 = nil;
        else
            v13 = v;
        end;

        v12[i] = v13;
    end;

    local v14 = p7.Bones[p9];

    if p9 > 0 then
        local Magnitude = (v14.Position - v12.Position).Magnitude;
        v12.FreeLength = Magnitude;
        v12.Weight = Magnitude * 0.7;
        v12.HeirarchyLength = p10;
        v14.HasChild = true;
    end;

    if p10 <= p7.Settings.AnchorDepth then
        SB_VERBOSE_LOG("Anchoring bone");
        v12.Anchored = true;
    end;

    v12.ParentIndex = p9;
    table.insert(p7.Bones, v12);
end;

function u4.m_CreateBoneTree(u15: table, p16: userdata, p17: userdata) -- Line: 140
    -- upvalues: BoneTree (copy), Utilities (copy), SB_VERBOSE_LOG (copy), SB_INDENT_LOG (copy), SB_UNINDENT_LOG (copy)
    local u18 = BoneTree.new(p17, p16, Utilities.GatherObjectSettings(p16));
    SB_VERBOSE_LOG((`Creating bone tree {p16.Name}; {p17.Name}`));
    SB_INDENT_LOG();

    local function AddChildren(p19, p20, p21) -- Line: 146
        -- upvalues: SB_VERBOSE_LOG (ref), SB_INDENT_LOG (ref), u15 (copy), u18 (copy), AddChildren (copy), SB_UNINDENT_LOG (ref)
        SB_VERBOSE_LOG((`Adding bone: {p19.Name}; {p20}; {p21}`));
        SB_INDENT_LOG();
        local v22 = false;

        for _, child in p19:GetChildren() do
            if child:IsA("Bone") then
                u15:m_AppendBone(u18, child, p20, p21);
                AddChildren(child, #u18.Bones, p21 + 1);
                v22 = true;
            end;
        end;

        if not (string.sub(p19.Name, #p19.Name - 3, #p19.Name) == "_end" or string.sub(p19.Name, #p19.Name - 4, #p19.Name) == "_Tail" or v22) then
            SB_VERBOSE_LOG("Adding tail bone");
            local Parent = p19.Parent;
            local v23 = Parent:IsA("Bone") and Parent.WorldPosition or Parent.Position;
            local v24 = p19.WorldCFrame + p19.WorldCFrame.UpVector.Unit * (p19.WorldPosition - v23).Magnitude;
            local Bone2 = Instance.new("Bone");
            Bone2.Parent = p19;
            Bone2.Name = p19.Name .. "_Tail";
            Bone2.WorldCFrame = v24;

            for i, v in p19:GetAttributes() do
                Bone2:SetAttribute(i, v);
            end;

            u15:m_AppendBone(u18, Bone2, #u18.Bones, p21);
        end;

        SB_UNINDENT_LOG();
    end;

    u15:m_AppendBone(u18, p17, 0, 0);
    AddChildren(p17, 1, 1);
    table.insert(u15.BoneTrees, u18);
    SB_UNINDENT_LOG();
end;

function u4.m_UpdateViewFrustum(p25) -- Line: 199
    -- upvalues: Config (copy), Frustum (copy)
    if shared.FrameCounter % Config.FRUSTUM_FREQ ~= 0 then
        return;
    end;

    local CFrames, v26, v27, v28, v29, v30, v31, v32, v33 = Frustum.GetCFrames(workspace.CurrentCamera, Config.FAR_PLANE);
    local m_FrustumObject = p25.m_FrustumObject;

    for _, v in p25.BoneTrees do
        m_FrustumObject.CFrame = v.BoundingBoxCFrame;
        m_FrustumObject.Size = v.BoundingBoxSize;
        v.InView = Frustum.ObjectInFrustum(m_FrustumObject, CFrames, v26, v27, v28, v29, v30, v31, v32, v33);
    end;
end;

function u4.m_DetachDead(p34) -- Line: 228
    local m_PendingDestroy = p34.m_PendingDestroy;

    for i = #p34.ColliderObjects, 1, -1 do
        local v35 = p34.ColliderObjects[i];
        local v36;

        if #v35.Colliders == 0 or v35.Destroyed == true then
            table.insert(m_PendingDestroy, v35);
            table.remove(p34.ColliderObjects, i);
            v36 = i;
        else
            v36 = i;
        end;
    end;

    for i = #p34.BoneTrees, 1, -1 do
        local v37 = p34.BoneTrees[i];
        local v38;

        if v37.Destroyed then
            table.insert(m_PendingDestroy, v37);
            table.remove(p34.BoneTrees, i);
            v38 = i;
        else
            v38 = i;
        end;
    end;
end;

function u4.m_FlushPending(p39) -- Line: 258
    local m_PendingDestroy = p39.m_PendingDestroy;

    if #m_PendingDestroy == 0 then
        return;
    end;

    for _, v in m_PendingDestroy do
        v:Destroy();
    end;

    table.clear(m_PendingDestroy);
end;

function u4.m_StepColliders(p40) -- Line: 280
    if p40.m_SteppedColliders then
        return;
    end;

    p40.m_SteppedColliders = true;

    for _, v in p40.ColliderObjects do
        v:Step();
    end;
end;

function u4.m_UpdateBoneTree(p41: table, p42: any, p43: number) -- Line: 303
    -- upvalues: SB_VERBOSE_LOG (copy), Config (copy)
    p42:PreUpdate(p43);

    if not (p42.InView and (math.floor(p42.UpdateRate) ~= 0 and p42.InWorkspace)) then
        local IsSkippingUpdates = p42.IsSkippingUpdates;
        p42:SkipUpdate();

        if IsSkippingUpdates then
            return false;
        end;

        SB_VERBOSE_LOG((`Skipping BoneTree, InView: {p42.InView}, Update Rate == 0: {math.floor(p42.UpdateRate) == 0}, InWorkspace: {p42.InWorkspace}`));

        return true;
    end;

    p41:m_StepColliders();
    local v44 = 1 / p42.UpdateRate;
    p42.AccumulatedDelta = p42.AccumulatedDelta + p43;
    local v45 = 0;
    local v46 = false;

    while v44 < p42.AccumulatedDelta and v45 < Config.MAX_SUBSTEPS do
        p42.AccumulatedDelta = p42.AccumulatedDelta - v44;
        v45 = v45 + 1;
        p42:StepPhysics(v44);
        p42:Constrain(p41.ColliderObjects, v44);
        p42:SolveTransform(v44);
        v46 = true;
    end;

    if v44 < p42.AccumulatedDelta then
        p42.AccumulatedDelta = 0;
    end;

    return v46;
end;

function u4.m_CheckDestroy(p47) -- Line: 358
    p47.ShouldDestroy = false;

    if #p47.BoneTrees ~= 0 then
        return false;
    end;

    p47.ShouldDestroy = true;

    return true;
end;

function u4.LoadObject(p48: table, p49: userdata) -- Line: 374
    -- upvalues: Config (copy)
    local Attribute = p49:GetAttribute("Roots");

    if not Attribute then
        warn((`[SmartBone2::LoadObject] Cannot load an object with no roots defined {p49.Name}`));

        return;
    end;

    local v50 = Attribute:split(",");
    local v51 = {};
    local v52 = {};

    for _, v in v50 do
        v51[v] = true;
    end;

    for _, v in p49:QueryDescendants("Bone") do
        if v52[v.Name] then
            warn((`[SmartBone2::LoadObject] Duplicate bones of name: {v.Name} in RootPart: {p49.Name}`));
        else
            v51[v.Name] = nil;
            v52[v.Name] = v;
        end;
    end;

    if next(v51) then
        for i, _ in v51 do
            local v53 = p49:WaitForChild(i, Config.ROOT_BONE_WAIT_TIME or 5);

            if v53 and v53:IsA("Bone") then
                v51[v53.Name] = nil;
                v52[v53.Name] = v53;
            end;
        end;

        if next(v51) then
            warn((`[SmartBone2::LoadObject] Couldn't find all roots defined {p49.Name}`));
        end;
    end;

    for _, v in v50 do
        local v54 = v52[v];

        if v54 then
            p48:m_CreateBoneTree(p49, v54);
        else
            warn((`[SmartBone2::LoadObject] Couldn't find Root Bone of name: {v} in RootPart: {p49.Name}`));
        end;
    end;
end;

function u4.LoadColliderModule(p55: table, p56: userdata, p57: userdata) -- Line: 433
    -- upvalues: HttpService (copy), ColliderObject (copy)
    assert(p56, "[SmartBone2::LoadColliderModule] No collider module passed in");
    local v58 = HttpService:JSONDecode((require(p56)));
    local v59 = ColliderObject.new(v58, p57);
    table.insert(p55.ColliderObjects, v59);
end;

function u4.LoadRawCollider(p60: table, p61: any, p62: userdata) -- Line: 448
    -- upvalues: ColliderObject (copy)
    local v63 = ColliderObject.new(p61, p62);
    table.insert(p60.ColliderObjects, v63);
end;

function u4.SkipUpdate(p64) -- Line: 456
    for _, v in p64.BoneTrees do
        v:SkipUpdate();
    end;
end;

function u4.StepParallel(p65: table, p66: number) -- Line: 472
    -- upvalues: SB_VERBOSE_WARN (copy)
    if p65:m_CheckDestroy() then
        return false;
    end;

    if p66 <= 0 then
        SB_VERBOSE_WARN("DeltaTime is zero or sub zero, not updating.");

        return false;
    end;

    p65.m_SteppedColliders = false;
    local m_PendingApply = p65.m_PendingApply;
    table.clear(m_PendingApply);
    p65:m_DetachDead();
    p65:m_UpdateViewFrustum();

    for _, v in p65.BoneTrees do
        if p65:m_UpdateBoneTree(v, p66) then
            table.insert(m_PendingApply, v);
        end;
    end;

    return #m_PendingApply > 0 and true or #p65.m_PendingDestroy > 0;
end;

function u4.ApplyPending(p67) -- Line: 501
    local m_PendingApply = p67.m_PendingApply;

    if #m_PendingApply ~= 0 then
        for _, v in m_PendingApply do
            v:ApplyTransform();
        end;

        table.clear(m_PendingApply);
    end;

    p67:m_FlushPending();
end;

function u4.StepBoneTrees(p68: table, p69: number) -- Line: 520
    if not p68:StepParallel(p69) then
        return;
    end;

    task.synchronize();
    p68:ApplyPending();
end;

function u4.DrawDebug(p70: table, p71: boolean, p72: boolean, p73: boolean, p74: boolean, p75: boolean, p76: boolean, p77: boolean, p78: boolean, p79: boolean, p80: boolean, p81: boolean, p82: boolean, p83: boolean) -- Line: 545
    for _, v in p70.BoneTrees do
        v:DrawDebug(p72, p73, p74, p75, p76, p81, p82, p83);
    end;

    if p71 then
        for _, v in p70.ColliderObjects do
            v:DrawDebug(p77, p78, p79, p80);
        end;
    end;
end;

function u4.DrawOverlay(p84: table, p85: table) -- Line: 584
    -- upvalues: Config (copy)
    if not Config.DEBUG_OVERLAY_ENABLED then
        return;
    end;

    local Color3_new_ret = Color3.new(1, 0.431373, 0.713725);
    local Color3_new_ret2 = Color3.new(1, 1, 1);
    local Color3_new_ret3 = Color3.new(0.486275, 0.431373, 1);
    local Color3_new_ret4 = Color3.new(1, 1, 1);
    p85.Begin(`SmartBone Instance ID: {p84.ID}`, Color3_new_ret, Color3_new_ret2);
    p85.Text((`Frame Counter: {shared.FrameCounter}`));

    if Config.DEBUG_OVERLAY_TREE then
        for i, v in p84.BoneTrees do
            if Config.DEBUG_OVERLAY_MAX_TREES > 0 and Config.DEBUG_OVERLAY_TREE_OFFSET + Config.DEBUG_OVERLAY_MAX_TREES <= i then
                break;
            end;

            if i >= Config.DEBUG_OVERLAY_TREE_OFFSET then
                p85.Begin(`Bone Tree {i}`, Color3_new_ret3, Color3_new_ret4);
                v:DrawOverlay(p85);
                p85.End();
            end;
        end;
    end;

    p85.End();
end;

function u4.Destroy(p86) -- Line: 620
    -- upvalues: SB_VERBOSE_LOG (copy)
    SB_VERBOSE_LOG("Deleting SmartBone Object");
    p86:m_FlushPending();

    for _, v in p86.BoneTrees do
        v:Destroy();
    end;

    for _, v in p86.ColliderObjects do
        v:Destroy();
    end;

    setmetatable(p86, nil);
end;

function u4.Start() -- Line: 640
    -- upvalues: RunService (copy), u4 (copy), Config (copy), Players (copy), u1 (ref), Runtime (copy), CollectionService (copy), SB_VERBOSE_LOG (copy), SB_INDENT_LOG (copy), Utilities (copy), SB_UNINDENT_LOG (copy), ImOverlay (copy)
    if not RunService:IsClient() then
        warn("Smartbone.Start() can only be called in client context.");

        return;
    end;

    if not u4.Running then
        if Config.STARTUP_PRINT_ENABLED or Config.LOG_VERBOSE then
            print((`SmartBone2 v{Config.VERSION} Starting`));
        end;

        u4.Running = true;
        local PlayerScripts = Players.LocalPlayer:WaitForChild("PlayerScripts");
        local Folder = Instance.new("Folder");
        Folder.Name = "SmartBone-Actors";
        Folder.Parent = PlayerScripts;
        local BindableEvent = Instance.new("BindableEvent");
        BindableEvent.Name = "OverlayEvent";
        BindableEvent.Parent = script;
        BindableEvent.Event:Connect(function(p87, ...) -- Line: 668
            -- upvalues: Config (ref), u1 (ref)
            if not Config.DEBUG_OVERLAY_ENABLED then
                return;
            end;

            if p87 == "Text" then
                u1:Text(...);

                return;
            end;

            if p87 == "Begin" then
                u1:Begin(...);

                return;
            end;

            if p87 == "End" then
                u1:End();
            end;
        end);
        local u88 = {};
        local u89 = {};
        local u90 = {};
        local u91 = {};

        local function CreateWorker() -- Line: 687
            -- upvalues: Runtime (ref), u89 (copy), u90 (copy), u91 (copy), Folder (copy)
            local Actor = Instance.new("Actor");
            local v92 = Runtime:Clone();
            v92.Parent = Actor;
            v92.Enabled = true;
            Actor.Name = `SmartBone Worker {#u89 + 1}`;
            table.insert(u89, Actor);
            u90[Actor] = 0;
            u91[Actor] = false;
            Actor.Parent = Folder;
            task.wait();
            u91[Actor] = true;

            return Actor;
        end;

        local function GetWorker() -- Line: 711
            -- upvalues: Config (ref), u89 (copy), CreateWorker (copy), u90 (copy), u91 (copy)
            local MAX_ACTORS = Config.MAX_ACTORS;

            if MAX_ACTORS <= 0 or #u89 < MAX_ACTORS then
                return CreateWorker();
            end;

            local v93 = u89[1];

            for _, v in u89 do
                if u90[v] < u90[v93] then
                    v93 = v;
                end;
            end;

            while not u91[v93] do
                task.wait();
            end;

            return v93;
        end;

        local u94 = nil;

        local function GatherColliders() -- Line: 749
            -- upvalues: u94 (ref), CollectionService (ref), SB_VERBOSE_LOG (ref), Config (ref)
            if u94 then
                return u94;
            end;

            local v95 = {
                Key = {},
                Raw = {}
            };

            for _, v in CollectionService:GetTagged("SmartCollider") do
                if v:IsA("BasePart") then
                    local Attribute = v:GetAttribute("ColliderKey");

                    if Attribute then
                        Attribute = tostring(Attribute);

                        if not v95.Key[Attribute] then
                            v95.Key[Attribute] = {};
                        end;

                        table.insert(v95.Key[Attribute], v);
                    end;

                    SB_VERBOSE_LOG((`Adding collider: {v.Name}, Collider Key: {Attribute}`));
                    table.insert(v95.Raw, v);

                    if Config.YIELD_ON_COLLIDER_GATHER then
                        task.wait();
                    end;
                end;
            end;

            u94 = v95;

            return v95;
        end;

        local function InvalidateColliders() -- Line: 789
            -- upvalues: u94 (ref)
            u94 = nil;
        end;

        local u96 = CollectionService:GetInstanceAddedSignal("SmartCollider"):Connect(InvalidateColliders);
        local u97 = CollectionService:GetInstanceRemovedSignal("SmartCollider"):Connect(InvalidateColliders);

        local function SetupObject(u98: userdata) -- Line: 796
            -- upvalues: SB_VERBOSE_LOG (ref), SB_INDENT_LOG (ref), GatherColliders (copy), Utilities (ref), GetWorker (copy), u88 (copy), u90 (copy), SB_UNINDENT_LOG (ref)
            if not u98:IsA("BasePart") then
                return;
            end;

            SB_VERBOSE_LOG((`Setup Object: {u98.Name}`));
            SB_INDENT_LOG();
            local v99 = GatherColliders();
            local Attribute = u98:GetAttribute("ColliderKey");
            local v100;

            if Attribute then
                v100 = v99.Key[tostring(Attribute)] or {};
            else
                v100 = v99.Raw or {};
            end;

            local v101 = {};

            for _, v in v100 do
                local v102 = { Utilities.GetCollider(v), v };
                table.insert(v101, v102);
            end;

            local v103 = GetWorker();
            u88[u98] = v103;
            local v104 = u90;
            v104[v103] = v104[v103] + 1;
            v103:SendMessage("Setup", u98, v101, script);
            u98:GetPropertyChangedSignal("Parent"):Connect(function() -- Line: 829
                -- upvalues: u98 (copy), u88 (ref), u90 (ref)
                if u98.Parent ~= nil then
                    return;
                end;

                local v105 = u98;
                local v106 = u88[v105];
                u88[v105] = nil;

                if not v106 then
                    return;
                end;

                u90[v106] = math.max(u90[v106] - 1, 0);
                v106:SendMessage("Free", v105);
            end);
            SB_VERBOSE_LOG("Runtime Started");
            SB_UNINDENT_LOG();
        end;

        local u107 = CollectionService:GetInstanceAddedSignal("SmartBone"):Connect(SetupObject);
        local u110 = CollectionService:GetInstanceRemovedSignal("SmartBone"):Connect(function(p108: userdata) -- Line: 734, Name: OnObjectFreed
            -- upvalues: u88 (copy), u90 (copy)
            local v109 = u88[p108];
            u88[p108] = nil;

            if not v109 then
                return;
            end;

            u90[v109] = math.max(u90[v109] - 1, 0);
            v109:SendMessage("Free", p108);
        end);

        for _, v in CollectionService:GetTagged("SmartBone") do
            SetupObject(v);
        end;

        if Config.DEBUG_OVERLAY_ENABLED then
            u1 = ImOverlay.new();
            local PlayerGui = Players.LocalPlayer.PlayerGui;
            local ScreenGui = Instance.new("ScreenGui");
            ScreenGui.Name = "SmartBoneDebugOverlay";
            ScreenGui.IgnoreGuiInset = true;
            ScreenGui.ResetOnSpawn = false;
            ScreenGui.Parent = PlayerGui;
            u1.BackFrame.Parent = ScreenGui;
            RunService.RenderStepped:Connect(function() -- Line: 861
                -- upvalues: u1 (ref)
                u1:Render();
            end);
        end;

        return {
            Stop = function() -- Line: 867, Name: Stop
                -- upvalues: u4 (ref), u107 (copy), u110 (copy), u96 (copy), u97 (copy), Config (ref), Folder (copy)
                u4.Running = false;

                if u107 then
                    u107:Disconnect();
                end;

                if u110 then
                    u110:Disconnect();
                end;

                u96:Disconnect();
                u97:Disconnect();

                if Config.RESET_BONE_ON_DESTROY then
                    for _, child in Folder:GetChildren() do
                        child:SendMessage("Destroy");
                    end;

                    return;
                end;

                Folder:Destroy();
            end
        };
    end;

    warn("Cannot call Smartbone.Start() multiple times");
end;

return u4;