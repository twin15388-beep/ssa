-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local HttpService = game:GetService("HttpService");
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local Components = script:WaitForChild("Components");
local Dependencies = script:WaitForChild("Dependencies");
local ImOverlay = require(Dependencies:WaitForChild("Debug"):WaitForChild("ImOverlay"));
local Config = require(Dependencies:WaitForChild("Config"));
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
        ID = HttpService:GenerateGUID(false),
        BoneTrees = {},
        ColliderObjects = {}
    };

    return setmetatable(v5, u4);
end;

function u4.m_AppendBone(p6: table, p7: any, p8: userdata, p9: number, p10: number) -- Line: 96
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

function u4.m_CreateBoneTree(u15: table, p16: userdata, p17: userdata) -- Line: 135
    -- upvalues: BoneTree (copy), Utilities (copy), SB_VERBOSE_LOG (copy), SB_INDENT_LOG (copy), SB_UNINDENT_LOG (copy)
    local u18 = BoneTree.new(p17, p16, Utilities.GatherObjectSettings(p16));
    SB_VERBOSE_LOG((`Creating bone tree {p16.Name}; {p17.Name}`));
    SB_INDENT_LOG();

    local function AddChildren(p19, p20, p21) -- Line: 141
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

function u4.m_UpdateViewFrustum(p25) -- Line: 196
    -- upvalues: Config (copy), Frustum (copy)
    if shared.FrameCounter % Config.FRUSTUM_FREQ ~= 0 then
        return;
    end;

    local v26 = nil;
    local v27 = nil;
    local v28 = nil;
    local v29 = nil;
    local v30 = nil;
    local v31 = nil;
    local v32 = nil;
    local v33 = nil;
    local v34 = nil;

    for _, v in p25.BoneTrees do
        if not v.IsSkippingUpdates or math.floor(v.UpdateRate) ~= 0 then
            if not v26 then
                v26, v30, v31, v32, v33, v34, v27, v28, v29 = Frustum.GetCFrames(workspace.CurrentCamera, Config.FAR_PLANE);
            end;

            v.InView = Frustum.ObjectInFrustum({
                CFrame = v.BoundingBoxCFrame,
                Size = v.BoundingBoxSize
            }, v26, v30, v31, v32, v33, v34, v27, v28, v29);
        end;
    end;
end;

function u4.m_CleanColliders(p35) -- Line: 227
    -- upvalues: SB_VERBOSE_WARN (copy), SB_INDENT_LOG (copy), SB_UNINDENT_LOG (copy)
    local v36 = false;

    if #p35.ColliderObjects ~= 0 then
        for i, v in p35.ColliderObjects do
            if #v.Colliders == 0 or v.Destroyed == true then
                SB_VERBOSE_WARN("Deleting Collider Object");
                SB_INDENT_LOG();
                v:Destroy();
                SB_UNINDENT_LOG();
                table.remove(p35.ColliderObjects, i);
                v36 = true;
            end;
        end;
    end;
end;

function u4.m_UpdateBoneTree(p37: table, p38: any, p39: number, p40: number) -- Line: 259
    -- upvalues: SB_VERBOSE_LOG (copy)
    if p38.Destroyed then
        p38:Destroy();
        table.remove(p37.BoneTrees, p39);

        return;
    end;

    p38:PreUpdate(p40);

    if p38.InView and (math.floor(p38.UpdateRate) ~= 0 and p38.InWorkspace) then
        for _, v in p37.ColliderObjects do
            v:Step();
        end;

        local v41 = 1 / p38.UpdateRate;
        p38.AccumulatedDelta = p38.AccumulatedDelta + p40;
        local v42 = false;

        while v41 < p38.AccumulatedDelta do
            p38.AccumulatedDelta = p38.AccumulatedDelta - v41;
            p38:StepPhysics(v41);
            p38:Constrain(p37.ColliderObjects, v41);
            p38:SolveTransform(v41);
            v42 = true;
        end;

        return v42;
    end;

    local IsSkippingUpdates = p38.IsSkippingUpdates;
    p38:SkipUpdate();

    if not IsSkippingUpdates then
        SB_VERBOSE_LOG((`Skipping BoneTree, InView: {p38.InView}, Update Rate == 0: {math.floor(p38.UpdateRate) == 0}, InWorkspace: {p38.InWorkspace}`));

        return true;
    end;
end;

function u4.m_CheckDestroy(p43) -- Line: 317
    p43.ShouldDestroy = false;

    if #p43.BoneTrees ~= 0 then
        return false;
    end;

    p43.ShouldDestroy = true;

    return true;
end;

function u4.LoadObject(p44: table, p45: userdata) -- Line: 333
    local Attribute = p45:GetAttribute("Roots");

    if not Attribute then
        warn(p45, " fix this later ");
        warn((`[SmartBone2::LoadObject] Cannot load an object with no roots defined {p45.Name}`));

        return;
    end;

    local v46 = Attribute:split(",");
    local v47 = {};

    for _, descendant in p45:GetDescendants() do
        if descendant:IsA("Bone") and not v47[descendant.Name] then
            v47[descendant.Name] = descendant;
        end;
    end;

    for _, v in v46 do
        local v48 = v47[v];

        if v48 then
            p44:m_CreateBoneTree(p45, v48);
        end;
    end;
end;

function u4.LoadColliderModule(p49: table, p50: userdata, p51: userdata) -- Line: 379
    -- upvalues: HttpService (copy), ColliderObject (copy)
    assert(p50, "[SmartBone2::LoadColliderModule] No collider module passed in");
    local v52 = HttpService:JSONDecode((require(p50)));
    local v53 = ColliderObject.new(v52, p51);
    table.insert(p49.ColliderObjects, v53);
end;

function u4.LoadRawCollider(p54: table, p55: any, p56: userdata) -- Line: 394
    -- upvalues: ColliderObject (copy)
    local v57 = ColliderObject.new(p55, p56);
    table.insert(p54.ColliderObjects, v57);
end;

function u4.SkipUpdate(p58) -- Line: 402
    for _, v in p58.BoneTrees do
        v:SkipUpdate();
    end;
end;

function u4.StepBoneTrees(p59: table, p60: number) -- Line: 413
    -- upvalues: SB_VERBOSE_WARN (copy)
    if p59:m_CheckDestroy() then
        return;
    end;

    if p60 <= 0 then
        SB_VERBOSE_WARN("DeltaTime is zero or sub zero, not updating.");

        return;
    end;

    p59:m_CleanColliders();
    p59:m_UpdateViewFrustum();
    local v61 = false;

    for i, v in p59.BoneTrees do
        if p59:m_UpdateBoneTree(v, i, p60) then
            v.PendingApply = true;
            v61 = true;
        end;
    end;

    if not v61 then
        return;
    end;

    task.synchronize();

    for _, v in p59.BoneTrees do
        if v.PendingApply then
            v.PendingApply = false;
            v:ApplyTransform();
        end;
    end;
end;

function u4.DrawDebug(p62: table, p63: boolean, p64: boolean, p65: boolean, p66: boolean, p67: boolean, p68: boolean, p69: boolean, p70: boolean, p71: boolean, p72: boolean, p73: boolean, p74: boolean, p75: boolean) -- Line: 468
    for _, v in p62.BoneTrees do
        v:DrawDebug(p64, p65, p66, p67, p68, p73, p74, p75);
    end;

    if p63 then
        for _, v in p62.ColliderObjects do
            v:DrawDebug(p69, p70, p71, p72);
        end;
    end;
end;

function u4.DrawOverlay(p76: table, p77: table) -- Line: 507
    -- upvalues: Config (copy)
    if not Config.DEBUG_OVERLAY_ENABLED then
        return;
    end;

    local Color3_new_ret = Color3.new(1, 0.431373, 0.713725);
    local Color3_new_ret2 = Color3.new(1, 1, 1);
    local Color3_new_ret3 = Color3.new(0.486275, 0.431373, 1);
    local Color3_new_ret4 = Color3.new(1, 1, 1);
    p77.Begin(`SmartBone Instance ID: {p76.ID}`, Color3_new_ret, Color3_new_ret2);
    p77.Text((`Frame Counter: {shared.FrameCounter}`));

    if Config.DEBUG_OVERLAY_TREE then
        for i, v in p76.BoneTrees do
            if Config.DEBUG_OVERLAY_MAX_TREES > 0 and Config.DEBUG_OVERLAY_TREE_OFFSET + Config.DEBUG_OVERLAY_MAX_TREES <= i then
                break;
            end;

            if i >= Config.DEBUG_OVERLAY_TREE_OFFSET then
                p77.Begin(`Bone Tree {i}`, Color3_new_ret3, Color3_new_ret4);
                v:DrawOverlay(p77);
                p77.End();
            end;
        end;
    end;

    p77.End();
end;

function u4.Destroy(p78) -- Line: 543
    -- upvalues: SB_VERBOSE_LOG (copy)
    SB_VERBOSE_LOG("Deleting SmartBone Object");

    for _, v in p78.BoneTrees do
        v:Destroy();
    end;

    for _, v in p78.ColliderObjects do
        v:Destroy();
    end;

    setmetatable(p78, nil);
end;

function u4.Start() -- Line: 561
    -- upvalues: RunService (copy), u4 (copy), Config (copy), Players (copy), u1 (ref), CollectionService (copy), SB_VERBOSE_LOG (copy), SB_INDENT_LOG (copy), Utilities (copy), Runtime (copy), SB_UNINDENT_LOG (copy), ImOverlay (copy)
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
        BindableEvent.Event:Connect(function(p79, ...) -- Line: 589
            -- upvalues: Config (ref), u1 (ref)
            if not Config.DEBUG_OVERLAY_ENABLED then
                return;
            end;

            if p79 == "Text" then
                u1:Text(...);

                return;
            end;

            if p79 == "Begin" then
                u1:Begin(...);

                return;
            end;

            if p79 == "End" then
                u1:End();
            end;
        end);

        local function GatherColliders() -- Line: 603
            -- upvalues: CollectionService (ref), SB_VERBOSE_LOG (ref), Config (ref)
            local v80 = {
                Key = {},
                Raw = {}
            };

            for _, v in CollectionService:GetTagged("SmartCollider") do
                if v:IsA("BasePart") then
                    local Attribute = v:GetAttribute("ColliderKey");

                    if Attribute then
                        Attribute = tostring(Attribute);

                        if not v80.Key[Attribute] then
                            v80.Key[Attribute] = {};
                        end;

                        table.insert(v80.Key[Attribute], v);
                    end;

                    SB_VERBOSE_LOG((`Adding collider: {v.Name}, Collider Key: {Attribute}`));
                    table.insert(v80.Raw, v);

                    if Config.YIELD_ON_COLLIDER_GATHER then
                        task.wait();
                    end;
                end;
            end;

            return v80;
        end;

        local function SetupObject(u81: userdata) -- Line: 637
            -- upvalues: SetupObject (copy), SB_VERBOSE_LOG (ref), SB_INDENT_LOG (ref), GatherColliders (copy), Utilities (ref), Runtime (ref), Folder (copy), SB_UNINDENT_LOG (ref)
            if not u81:IsA("BasePart") then
                return;
            end;

            if not u81:IsDescendantOf(workspace) then
                local u82 = nil;
                u82 = u81.AncestryChanged:Connect(function() -- Line: 647
                    -- upvalues: u81 (copy), u82 (ref), SetupObject (ref)
                    if u81:IsDescendantOf(workspace) then
                        u82:Disconnect();
                        SetupObject(u81);
                    end;
                end);

                return;
            end;

            SB_VERBOSE_LOG((`Setup Object: {u81.Name}`));
            SB_INDENT_LOG();
            local v83 = GatherColliders();
            local Attribute = u81:GetAttribute("ColliderKey");
            local v84;

            if Attribute then
                v84 = v83.Key[tostring(Attribute)] or {};
            else
                v84 = v83.Raw or {};
            end;

            local v85 = {};

            for _, v in v84 do
                local v86 = { Utilities.GetCollider(v), v };
                table.insert(v85, v86);
            end;

            local Actor = Instance.new("Actor");
            local v87 = Runtime:Clone();
            v87.Parent = Actor;
            v87.Enabled = true;
            Actor.Parent = Folder;
            task.wait();
            Actor:SendMessage("Setup", u81, v85, script);
            SB_VERBOSE_LOG("Runtime Started");
            SB_UNINDENT_LOG();
        end;

        connection = CollectionService:GetInstanceAddedSignal("SmartBone"):Connect(SetupObject);

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
            RunService.RenderStepped:Connect(function() -- Line: 711
                -- upvalues: u1 (ref)
                u1:Render();
            end);
        end;

        return {
            Stop = function() -- Line: 717, Name: Stop
                -- upvalues: u4 (ref), Config (ref), Folder (copy)
                u4.Running = false;

                if not Config.RESET_BONE_ON_DESTROY then
                    Folder:Destroy();

                    return;
                end;

                for _, child in Folder:GetChildren() do
                    child:SendMessage("Destroy");
                end;

                if connection then
                    connection:Disconnect();
                    connection = nil;
                end;
            end
        };
    end;

    warn("Cannot call Smartbone.Start() multiple times");
end;

return u4;