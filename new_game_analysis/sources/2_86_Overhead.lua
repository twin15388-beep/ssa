-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local cleanit = require(ReplicatedStorage.Packages.cleanit);
local StatsFetch = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.StatsFetch);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local RigEffectScale = require(ReplicatedStorage.CAM.Global.RigEffectScale);
local TitleParticles = require(ReplicatedStorage.CAM.Client.Modules.TitleParticles);
local RunService = game:GetService("RunService");
local u1 = {};
local u2 = {};
local u3 = {};
local u4 = {};

for _, child in script:GetChildren() do
    table.insert(u1, child.Name);
    u2[child.Name] = require(child);
end;

local UDim2_fromScale_ret = UDim2.fromScale(4, 1.5);

local function overheadMetrics(p5: userdata, p6: userdata) -- Line: 47
    -- upvalues: UDim2_fromScale_ret (copy), Players (copy), RigEffectScale (copy)
    if p6 == nil then
        return 3.4, UDim2_fromScale_ret;
    end;

    if Players:GetPlayerFromCharacter(p5) ~= nil then
        return 3.4, UDim2_fromScale_ret;
    end;

    local v7, v8, v9 = pcall(RigEffectScale.BodyBox, p5);

    if not (v7 and (typeof(v8) == "Vector3" and typeof(v9) == "Vector3")) then
        return 3.4, UDim2_fromScale_ret;
    end;

    local Attribute = p5:GetAttribute("OverheadOffset");
    local Attribute2 = p5:GetAttribute("OverheadHeadGap");

    if type(Attribute) ~= "number" then
        if type(Attribute2) == "number" then
            local Attribute3 = p5:GetAttribute("OverheadTopMargin");
            local v10 = type(Attribute3) ~= "number" and 1 or Attribute3;
            Attribute = math.max(Attribute2 + 1.2 + v10, 3.4);
        else
            Attribute = math.max(v9.Y - p6.Position.Y + 1.2, 3.4);
        end;
    end;

    local math_clamp_ret = math.clamp((v9 - v8).Y / 6, 1, 1.75);

    return Attribute, UDim2.fromScale(UDim2_fromScale_ret.X.Scale * math_clamp_ret, UDim2_fromScale_ret.Y.Scale * math_clamp_ret);
end;

function CreateBillboard(p11: userdata, p12: userdata, p13: boolean?)
    -- upvalues: overheadMetrics (copy)
    local BillboardGui = Instance.new("BillboardGui");
    BillboardGui.Name = "OverHead";
    BillboardGui.MaxDistance = 200;
    BillboardGui.LightInfluence = 0;
    BillboardGui.AlwaysOnTop = p13 == true;
    local v14, v15 = overheadMetrics(p11, p12);
    BillboardGui.Size = v15;
    BillboardGui.Adornee = p12;
    BillboardGui.Parent = p11;
    BillboardGui.StudsOffsetWorldSpace = vector.create(0, v14, 0);
    local Frame = Instance.new("Frame");
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.Parent = BillboardGui;
    Frame.Name = "Holder";
    Frame.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame.BackgroundTransparency = 1;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "List";
    UIListLayout.Parent = Frame;
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom;
    UIListLayout.FillDirection = Enum.FillDirection.Vertical;

    return Frame;
end;

ReplicatedStorage:WaitForChild("CAM");
local Overhead = ReplicatedStorage.CAM.Client.Components.Layout.Visibility.Overhead;

local function componentVisible(p16: string) -- Line: 131
    -- upvalues: Overhead (copy)
    if Overhead.All.Value ~= true then
        return false;
    end;

    local v17 = Overhead:FindFirstChild(p16);

    return v17 == nil and true or v17.Value == true;
end;

function updateVisibilities()
    -- upvalues: u3 (copy), u1 (copy), Overhead (copy)
    for _, v in u3 do
        local v18 = v;

        for _, v2 in u1 do
            local v19;

            if Overhead.All.Value == true then
                local v20 = Overhead:FindFirstChild(v2);
                v19 = v20 == nil and true or v20.Value == true;
            else
                v19 = false;
            end;

            v18(v2, v19);
        end;
    end;
end;

for _, child in ipairs(Overhead:GetChildren()) do
    child.Changed:Connect(updateVisibilities);
end;

updateVisibilities();

function Added(u21: userdata)
    -- upvalues: u4 (copy), cleanit (copy), Players (copy), u2 (copy), u3 (copy), u1 (copy), Overhead (copy), Utility (copy), StatsFetch (copy)
    if u21:GetAttribute("NoOverhead") == true then
        task.spawn(function() -- Line: 157
            -- upvalues: u21 (copy)
            local Humanoid = u21:WaitForChild("Humanoid", 9999);

            if Humanoid == nil then
                return;
            end;

            Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None;
            Humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff;
        end);

        return;
    end;

    if u4[u21] ~= nil then
        Removed(u21);
    end;

    local u22 = cleanit.new();
    u4[u21] = u22;
    u22:Add(task.spawn(function() -- Line: 173
        -- upvalues: u21 (copy), Players (ref), u22 (copy), u2 (ref), u3 (ref), u1 (ref), Overhead (ref), Utility (ref), StatsFetch (ref)
        local Humanoid = u21:WaitForChild("Humanoid", 9999);
        local HumanoidRootPart = u21:WaitForChild("HumanoidRootPart", 9999);

        if Humanoid == nil or (HumanoidRootPart == nil or u21.Parent == nil) then
            return;
        end;

        local v23 = u21 == Players.LocalPlayer.Character;

        if HumanoidRootPart.Parent == nil or u21.Parent == nil then
            return;
        end;

        local u24 = CreateBillboard(u21, HumanoidRootPart, v23);
        u22:Add(u24.Parent);
        Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None;
        Humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff;
        local u25 = {};
        u22:Add(function() -- Line: 195
            -- upvalues: u25 (copy)
            for _, v in u25 do
                v();
            end;

            table.clear(u25);
        end);
        local u26 = {};

        if v23 then
            u26.Health = true;
            u26._Name = true;
            u26.AFaction = true;
            u26.Debuffs = true;
        end;

        local u27 = {};

        u3[u21] = function(p28: string, p29: boolean) -- Line: 214, Name: updateVisibility
            -- upvalues: u26 (copy), u27 (copy), u25 (copy), u2 (ref), u24 (copy), u21 (ref), Humanoid (copy), HumanoidRootPart (copy), u22 (ref)
            if u26[p28] then
                p29 = false;
            end;

            if u27[p28] ~= p29 then
                if u25[p28] then
                    u25[p28]();
                end;

                u27[p28] = p29;

                if p29 == true then
                    u25[p28] = u2[p28](u24, u21, Humanoid, HumanoidRootPart, u22);
                end;
            end;
        end;

        for _, v in u1 do
            local v30;

            if Overhead.All.Value == true then
                local v31 = Overhead:FindFirstChild(v);
                v30 = v31 == nil and true or v31.Value == true;
            else
                v30 = false;
            end;

            if u26[v] then
                v30 = false;
            end;

            if u27[v] ~= v30 then
                if u25[v] then
                    u25[v]();
                end;

                u27[v] = v30;

                if v30 == true then
                    u25[v] = u2[v](u24, u21, Humanoid, HumanoidRootPart, u22);
                end;
            end;
        end;

        if not v23 then
            local PlayerFromCharacter = Players:GetPlayerFromCharacter(u21);
            local valuesfolder = Utility.getvaluesfolder(u21);
            local u32 = nil;

            local function refreshInvis() -- Line: 245
                -- upvalues: valuesfolder (copy), PlayerFromCharacter (copy), StatsFetch (ref), u21 (ref), u32 (ref), u26 (copy), Overhead (ref), u27 (copy), u25 (copy), u2 (ref), u24 (copy), Humanoid (copy), HumanoidRootPart (copy), u22 (ref)
                local v33 = valuesfolder and (valuesfolder:FindFirstChild("Invisibility") ~= nil or valuesfolder:FindFirstChild("Transparent") ~= nil) and true or false;
                local v34 = not (v33 or (not PlayerFromCharacter or StatsFetch.HasInvisibility(u21) ~= true)) and true or v33;

                if v34 == u32 then
                    return;
                end;

                u32 = v34;
                u26.Health = v34;
                u26._Name = v34;
                u26.Debuffs = v34;
                u26.AFaction = v34;
                u26.VanityTitle = v34;
                u26.Reputation = v34;

                for _, v in { "Health", "_Name", "Debuffs", "AFaction", "VanityTitle", "Reputation" } do
                    local v35;

                    if Overhead.All.Value == true then
                        local v36 = Overhead:FindFirstChild(v);
                        v35 = v36 == nil and true or v36.Value == true;
                    else
                        v35 = false;
                    end;

                    if u26[v] then
                        v35 = false;
                    end;

                    if u27[v] ~= v35 then
                        if u25[v] then
                            u25[v]();
                        end;

                        u27[v] = v35;

                        if v35 == true then
                            u25[v] = u2[v](u24, u21, Humanoid, HumanoidRootPart, u22);
                        end;
                    end;
                end;
            end;

            if valuesfolder then
                u22:Add(valuesfolder.ChildAdded:Connect(function(p37) -- Line: 271
                    -- upvalues: refreshInvis (copy)
                    if p37.Name == "Invisibility" or p37.Name == "Transparent" then
                        refreshInvis();
                    end;
                end));
                u22:Add(valuesfolder.ChildRemoved:Connect(function(p38) -- Line: 274
                    -- upvalues: refreshInvis (copy)
                    if p38.Name == "Invisibility" or p38.Name == "Transparent" then
                        refreshInvis();
                    end;
                end));
            end;

            if PlayerFromCharacter then
                local function hookSHC(p39: userdata) -- Line: 279
                    -- upvalues: u22 (ref), refreshInvis (copy)
                    u22:Add(p39:GetPropertyChangedSignal("Value"):Connect(refreshInvis));
                    u22:Add(p39:GetAttributeChangedSignal("last_performed"):Connect(refreshInvis));
                end;

                local v40 = u21:FindFirstChild("SHC") or u21:FindFirstChild("SHCS");

                if v40 then
                    hookSHC(v40);
                else
                    local u41 = nil;
                    u41 = u21.ChildAdded:Connect(function(p42) -- Line: 288
                        -- upvalues: u41 (ref), hookSHC (copy), refreshInvis (copy)
                        if p42.Name == "SHC" or p42.Name == "SHCS" then
                            if u41 then
                                u41:Disconnect();
                                u41 = nil;
                            end;

                            hookSHC(p42);
                            refreshInvis();
                        end;
                    end);
                    u22:Add(u41);
                end;
            end;

            refreshInvis();
        end;
    end));
end;

function Removed(p43: userdata)
    -- upvalues: u3 (copy), u4 (copy)
    if u3[p43] then
        u3[p43] = nil;
    end;

    if u4[p43] then
        u4[p43]:Destroy();
        u4[p43] = nil;
    end;
end;

for _, v in CollectionService:GetTagged("Humanoids") do
    Added(v);
end;

CollectionService:GetInstanceAddedSignal("Humanoids"):Connect(Added);
CollectionService:GetInstanceRemovedSignal("Humanoids"):Connect(Removed);
local u44 = nil;

local function runPromoted() -- Line: 326
    -- upvalues: TitleParticles (copy)
    for _, v in TitleParticles.Runners do
        if v.Promoted then
            v:Run();
        end;
    end;
end;

local function tickTitleParticles() -- Line: 333
    -- upvalues: TitleParticles (copy), u44 (ref), RunService (copy), runPromoted (copy)
    local workspace_CurrentCamera = workspace.CurrentCamera;
    local v45 = false;

    for i, v in TitleParticles.Runners do
        if i.Parent == nil or v.Root.Parent == nil then
            TitleParticles.Remove(i);
        else
            local v46;

            if workspace_CurrentCamera == nil then
                v46 = false;
            else
                v46 = (workspace_CurrentCamera.CFrame.Position - v.Root.Position).Magnitude <= TitleParticles.PROMOTE_DISTANCE;
            end;

            v.Promoted = v46;

            if v.Promoted then
                v45 = true;
            else
                v:Run();
            end;
        end;
    end;

    if v45 and u44 == nil then
        u44 = RunService.RenderStepped:Connect(runPromoted);

        return;
    end;

    if not v45 and u44 ~= nil then
        u44:Disconnect();
        u44 = nil;
    end;
end;

task.spawn(function() -- Line: 356
    -- upvalues: tickTitleParticles (copy), TitleParticles (copy)
    while true do
        tickTitleParticles();
        task.wait(TitleParticles.TICK);
    end;
end);