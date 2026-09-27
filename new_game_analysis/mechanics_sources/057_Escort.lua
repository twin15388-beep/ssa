-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
require(ReplicatedStorage.CAM.Global.Types.MiscTypes);
local script_Row = require(script.Row);
require(script.Types);
require(ReplicatedStorage.Packages.faye);
local u1 = RunService:IsStudio() and not RunService:IsRunning();
local LocalPlayer = Players.LocalPlayer;

local function visibleToMe(p2: userdata) -- Line: 39
    -- upvalues: LocalPlayer (copy)
    local Attribute = p2:GetAttribute("VisibleTo");

    if Attribute == nil then
        return true;
    end;

    if type(Attribute) ~= "string" then
        return false;
    end;

    local v3 = tostring(LocalPlayer == nil and 0 or LocalPlayer.UserId);

    for _, v in string.split(Attribute, ",") do
        if v == v3 then
            return true;
        end;
    end;

    return false;
end;

local function buildTestRun() -- Line: 57
    local Folder = Instance.new("Folder");
    Folder.Name = "TestEscortRun";
    Folder:SetAttribute("Icon", "rbxassetid://94727915573736");
    local Model = Instance.new("Model");
    Model.Name = "Escort";
    local Part = Instance.new("Part");
    Part.Name = "HumanoidRootPart";
    Part.Anchored = true;
    Part.Parent = Model;
    Model.PrimaryPart = Part;
    local Humanoid = Instance.new("Humanoid");
    Humanoid.MaxHealth = 500;
    Humanoid.Health = 310;
    Humanoid.Parent = Model;
    Model.Parent = Folder;
    local Configuration = Instance.new("Configuration");
    Configuration.Name = "EscortInfo";
    Configuration:SetAttribute("Title", "Mira");
    Configuration:SetAttribute("PathCount", 6);
    Configuration:SetAttribute("AmbushAt", "2,3,5");
    Configuration:SetAttribute("Reached", 3);
    Configuration:SetAttribute("Progress", 3);
    Configuration:SetAttribute("Phase", "Ambush");
    Configuration.Parent = Folder;

    return Configuration;
end;

local function bind(u4: any, u5: userdata) -- Line: 89
    local Parent = u5.Parent;
    local v6;

    if Parent == nil then
        v6 = nil;
    else
        v6 = Parent:FindFirstChildOfClass("Model");
    end;

    local u7;

    if v6 == nil then
        u7 = nil;
    else
        u7 = v6:FindFirstChildOfClass("Humanoid");
    end;

    local v8 = u5:GetAttribute("Title") or (v6 == nil and "Escort" or v6.Name);
    local v9 = u5:GetAttribute("PathCount") or 0;
    local math_max_ret = math.max(v9 - 1, 0);
    local v10 = {};
    local Attribute = u5:GetAttribute("AmbushAt");

    if type(Attribute) == "string" and Attribute ~= "" then
        for _, v in string.split(Attribute, ",") do
            local v11 = tonumber(v);

            if v11 ~= nil then
                table.insert(v10, v11);
            end;
        end;
    end;

    local u12 = u4:Value(u5:GetAttribute("Phase") or "Waiting");
    local u13 = u4:Value(u5:GetAttribute("Reached") or 1);

    local function watch(u14: string, u15: any, u16: any) -- Line: 113
        -- upvalues: u4 (copy), u5 (copy)
        u4:Connect(u5:GetAttributeChangedSignal(u14), function() -- Line: 114
            -- upvalues: u15 (copy), u5 (ref), u14 (copy), u16 (copy)
            u15:Set(u5:GetAttribute(u14) or u16);
        end);
    end;

    local u17 = "Phase";
    local u18 = "Waiting";
    u4:Connect(u5:GetAttributeChangedSignal("Phase"), function() -- Line: 114
        -- upvalues: u12 (copy), u5 (copy), u17 (copy), u18 (copy)
        u12:Set(u5:GetAttribute(u17) or u18);
    end);
    local u19 = "Reached";
    local u20 = 1;
    u4:Connect(u5:GetAttributeChangedSignal("Reached"), function() -- Line: 114
        -- upvalues: u13 (copy), u5 (copy), u19 (copy), u20 (copy)
        u13:Set(u5:GetAttribute(u19) or u20);
    end);

    local function alpha(p21) -- Line: 126
        -- upvalues: math_max_ret (copy)
        if math_max_ret < 1 then
            return 0;
        end;

        local v22 = ((tonumber(p21) or 1) - 1) / math_max_ret;

        return math.clamp(v22, 0, 1);
    end;

    local Attribute2 = u5:GetAttribute("Progress");
    local v23;

    if math_max_ret < 1 then
        v23 = 0;
    else
        local v24 = ((tonumber(Attribute2) or 1) - 1) / math_max_ret;
        v23 = math.clamp(v24, 0, 1);
    end;

    local u25 = u4:Value(v23);
    u4:Connect(u5:GetAttributeChangedSignal("Progress"), function() -- Line: 131
        -- upvalues: u25 (copy), u5 (copy), math_max_ret (copy)
        local Attribute3 = u5:GetAttribute("Progress");
        local v26;

        if math_max_ret < 1 then
            v26 = 0;
        else
            local v27 = ((tonumber(Attribute3) or 1) - 1) / math_max_ret;
            v26 = math.clamp(v27, 0, 1);
        end;

        u25:Set(v26);
    end);
    local u28 = u4:Value(1);
    local u29 = u4:Value(UDim2.fromScale(1, 1));
    local u30 = u4:Value("");
    local u31 = u4:Value(1);
    local u32 = u4:Value(0.85);

    if u7 ~= nil then
        local u33 = nil;

        local function upd() -- Line: 146
            -- upvalues: u7 (copy), u28 (copy), u29 (copy), u30 (copy), u33 (ref), u31 (copy), u32 (copy)
            local math_clamp_ret = math.clamp(u7.Health / (u7.MaxHealth <= 0 and 1 or u7.MaxHealth), 0, 1);
            u28:Set(math_clamp_ret);
            u29:Set(UDim2.fromScale(math_clamp_ret, 1));
            u30:Set(math.floor(u7.Health * 100) / 100 .. " / " .. u7.MaxHealth);

            if u33 ~= nil and math_clamp_ret < u33 then
                u31:Refresh();
                u32:Refresh();
            end;

            u33 = math_clamp_ret;
        end;

        upd();
        u4:Connect(u7.HealthChanged, upd);
    end;

    local v34 = {
        Info = u5,
        Folder = Parent,
        Rig = v6,
        Humanoid = u7
    };
    local v35;

    if Parent == nil then
        v35 = nil;
    else
        v35 = Parent:GetAttribute("Icon");
    end;

    v34.Icon = v35;
    v34.Title = v8;
    v34.PathCount = v9;
    v34.Legs = math_max_ret;
    v34.Ambushes = v10;
    v34.Phase = u12;
    v34.Reached = u13;
    v34.Progress = u25;
    v34.HealthPercent = u28;
    v34.HealthSize = u29;
    v34.HealthText = u30;
    v34.StrokeThickness = u31;
    v34.StrokeTransparency = u32;

    function v34.IsLive(p36: any, p37: number) -- Line: 190
        -- upvalues: u13 (copy), u12 (copy)
        local v38;

        if p36(u13) == p37 then
            v38 = p36(u12) == "Ambush";
        else
            v38 = false;
        end;

        return v38;
    end;

    function v34.IsCleared(p39: any, p40: number) -- Line: 193
        -- upvalues: u13 (copy), u12 (copy)
        local v41 = p39(u13);
        local v42;

        if p40 < v41 then
            v42 = true;
        elseif v41 == p40 then
            v42 = p39(u12) ~= "Ambush";
        else
            v42 = false;
        end;

        return v42;
    end;

    return v34;
end;

local function rowHeight(p43: number) -- Line: 201
    return math.min(p43 * 0.345, 50);
end;

return function(u44: any, p45: userdata, p46: any, u47: number) -- Line: 205
    -- upvalues: visibleToMe (copy), CollectionService (copy), u1 (copy), buildTestRun (copy), script_Row (copy), bind (copy)
    local u48 = `Escort - {p45.Name}`;
    local u49 = u44:Value(nil);

    local function claims(p50: userdata) -- Line: 212
        -- upvalues: u48 (copy), visibleToMe (ref)
        local Parent = p50.Parent;

        if Parent == nil or Parent.Name ~= u48 then
            return false;
        end;

        if Parent:FindFirstChildOfClass("Model") == nil then
            return false;
        end;

        return visibleToMe(p50);
    end;

    local function rescan() -- Line: 222
        -- upvalues: CollectionService (ref), u48 (copy), visibleToMe (ref), u49 (copy)
        for _, v in CollectionService:GetTagged("EscortTag") do
            local Parent = v.Parent;
            local v51;

            if Parent == nil or Parent.Name ~= u48 or Parent:FindFirstChildOfClass("Model") == nil then
                v51 = false;
            else
                v51 = visibleToMe(v);
            end;

            if v51 then
                u49:Set(v);

                return;
            end;
        end;

        u49:Set(nil);
    end;

    local function follow(u52: userdata) -- Line: 231
        -- upvalues: u44 (copy), rescan (copy)
        u44:Connect(u52:GetAttributeChangedSignal("VisibleTo"), rescan);
        local u53 = nil;
        u44:Connect(u52.AncestryChanged, function() -- Line: 241, Name: hookFolder
            -- upvalues: u52 (copy), u53 (ref), u44 (ref), rescan (ref)
            local Parent = u52.Parent;

            if Parent == nil or Parent == u53 then
                return;
            end;

            u53 = Parent;
            u44:Connect(Parent.ChildAdded, rescan);
            rescan();
        end);
        local Parent = u52.Parent;

        if Parent ~= nil and Parent ~= u53 then
            u53 = Parent;
            u44:Connect(Parent.ChildAdded, rescan);
            rescan();
        end;
    end;

    for _, v in CollectionService:GetTagged("EscortTag") do
        follow(v);
    end;

    u44:Connect(CollectionService:GetInstanceAddedSignal("EscortTag"), function(p54: userdata) -- Line: 255
        -- upvalues: follow (copy), rescan (copy)
        follow(p54);
        rescan();
    end);
    u44:Connect(CollectionService:GetInstanceRemovedSignal("EscortTag"), rescan);
    rescan();

    if u1 and u49:Get() == nil then
        u49:Set((buildTestRun()));
    end;

    return u44:Create("Frame")({
        Name = "AEvent",
        BackgroundTransparency = 1,
        Size = u44:Do(function(p55: any, p56: any, p57: userdata?) -- Line: 268
            -- upvalues: u49 (copy), u47 (copy)
            return UDim2.new(1, 0, 0, p55(u49) == nil and 0 or math.min(u47 * 0.345, 50));
        end),
        u44:State(function(p58: any, p59: any, p60: userdata?) -- Line: 273
            -- upvalues: u49 (copy), script_Row (ref), bind (ref), u47 (copy)
            local v61 = p58(u49);

            if v61 == nil then
                return nil;
            end;

            return script_Row(p59, bind(p59, v61), u47);
        end)
    });
end;