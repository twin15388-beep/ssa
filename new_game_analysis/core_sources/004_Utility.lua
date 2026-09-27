-- Decompiled with Potassium's decompiler.

local DebrisModule = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("DebrisModule"));
local CollectionService = game:GetService("CollectionService");
local RunService = game:GetService("RunService");
local gameSettings = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("gameSettings"));
local u1 = RunService:IsStudio();
local u2 = RunService:IsRunning();
local HitboxVisuals = workspace.Debree:FindFirstChild("HitboxVisuals");
local MarketplaceService = game:GetService("MarketplaceService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RaycastHelper = require(ReplicatedStorage.CAM.Global.RaycastHelper);
local EffectsEvent = require(ReplicatedStorage.Communication.ServerAndClient.Effects.EffectsEvent);
local u3 = RunService:IsServer();
local Humanoids = RaycastHelper.Humanoids;
local OverlapParams_new_ret = OverlapParams.new();

function dotreefilter()
    -- upvalues: OverlapParams_new_ret (copy)
    local v4 = {};
    local v5;

    if workspace:FindFirstChild("Map") == nil then
        v5 = nil;
    else
        v5 = workspace.Map:FindFirstChild("Trees") or nil;
    end;

    local v6;

    if workspace.Map:FindFirstChild("DetachedMaps") == nil or workspace.Map.DetachedMaps:FindFirstChild("ParkourTraining") == nil then
        v6 = nil;
    else
        v6 = workspace.Map.DetachedMaps.ParkourTraining:FindFirstChild("Trees") or nil;
    end;

    local v7;

    if workspace.Map:FindFirstChild("Minigame Map") == nil then
        v7 = nil;
    else
        v7 = workspace.Map["Minigame Map"]:FindFirstChild("Trees") or nil;
    end;

    v4[1], v4[2], v4[3] = v5, v6, v7;
    OverlapParams_new_ret.FilterDescendantsInstances = v4;
end;

if gameSettings.IsMinigame then
    task.spawn(function() -- Line: 31
        workspace.Map:WaitForChild("Minigame Map");
        dotreefilter();
    end);
else
    dotreefilter();
end;

OverlapParams_new_ret.FilterType = Enum.RaycastFilterType.Include;
OverlapParams_new_ret.MaxParts = 20;
local os_clock = os.clock;
local math_clamp = math.clamp;
local u8 = {
    Cancel_Values = {
        KnockedOut = true,
        Cancel = true,
        RagDoll = true,
        Stun = true,
        CombatStun = true,
        Strict_Stun = true
    }
};
local TweenService = game:GetService("TweenService");
local TweenInfo_new_ret = TweenInfo.new(0.15, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0);

function u8.clean_part_before_air_combo(p9) -- Line: 63
    if p9 == nil then
        return;
    end;

    if p9:FindFirstChild("Velocity", true) ~= nil then
        for _, child in pairs(p9:GetChildren()) do
            if child:FindFirstChild("Velocity") then
                child:Destroy();
            end;
        end;
    end;
end;

function u8.StreamingEnabledTeleport(p10: any, p11: number?) -- Line: 78
    -- upvalues: Players (copy), u8 (copy)
    local LocalPlayer = Players.LocalPlayer;
    local Character = LocalPlayer.Character;

    if Character == nil or p10 == nil then
        return false;
    end;

    local u12 = p11 or 60;
    local Pivot = Character:GetPivot();

    if typeof(p10) == "Vector3" then
        p10 = CFrame.new(p10) or p10;
    end;

    local Position = p10.Position;
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");
    local v13;

    if HumanoidRootPart == nil then
        v13 = false;
    else
        v13 = HumanoidRootPart.Anchored or false;
    end;

    Character:PivotTo(p10);

    if HumanoidRootPart and HumanoidRootPart.Parent then
        HumanoidRootPart.Anchored = true;
    end;

    local v14 = u8.Tick();
    local RaycastParams_new_ret = RaycastParams.new();
    RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Exclude;
    RaycastParams_new_ret.FilterDescendantsInstances = { Character };
    RaycastParams_new_ret.RespectCanCollide = true;
    pcall(function() -- Line: 113
        -- upvalues: LocalPlayer (copy), Position (copy), u12 (ref)
        LocalPlayer:RequestStreamAroundAsync(Position, u12);
    end);

    while true do
        local v15 = workspace:Raycast(Position + Vector3.new(0, 10, 0), Vector3.new(0, -60, 0), RaycastParams_new_ret);

        if v15 and v15.Instance then
            break;
        end;

        task.wait(0.1);

        if u12 < u8.Tick() - v14 then
            Character:PivotTo(Pivot);

            if HumanoidRootPart and HumanoidRootPart.Parent then
                HumanoidRootPart.Anchored = v13;
            end;

            return false;
        end;
    end;

    if HumanoidRootPart and HumanoidRootPart.Parent then
        HumanoidRootPart.Anchored = v13;
    end;

    return true;
end;

function u8.ForceUnequip() -- Line: 144
    -- upvalues: Players (copy)
    local LocalPlayer = Players.LocalPlayer;

    if LocalPlayer == nil then
        return;
    end;

    local Items_Config = LocalPlayer:FindFirstChild("Items_Config");

    if Items_Config == nil then
        return;
    end;

    local Equipped = Items_Config:FindFirstChild("Equipped");

    if Equipped == nil then
        return;
    end;

    if Equipped.Value ~= 0 then
        Equipped.Value = 0;
    end;
end;

function u8.ForceEquip(p16: number?) -- Line: 163
    -- upvalues: Players (copy)
    if p16 == nil or (p16 < 1 or p16 > 5) then
        return;
    end;

    local LocalPlayer = Players.LocalPlayer;

    if LocalPlayer == nil then
        return;
    end;

    local Items_Config = LocalPlayer:FindFirstChild("Items_Config");

    if Items_Config == nil then
        return;
    end;

    local Equipped = Items_Config:FindFirstChild("Equipped");

    if Equipped == nil then
        return;
    end;

    if Equipped.Value ~= p16 then
        Equipped.Value = p16;
    end;
end;

function u8.formatTime(p17: number) -- Line: 175
    local math_floor_ret = math.floor(p17);

    if math_floor_ret <= 0 then
        return "0s";
    end;

    if math_floor_ret < 60 then
        return `{math_floor_ret}s`;
    end;

    local v18 = math_floor_ret % 60;

    if math_floor_ret < 3600 then
        return `{math.floor(math_floor_ret / 60)}:{string.format("%02d", v18)}`;
    end;

    local math_floor_ret2 = math.floor(math_floor_ret / 3600);
    local math_floor_ret3 = math.floor(math_floor_ret % 3600 / 60);

    return `{math_floor_ret2}:{string.format("%02d", math_floor_ret3)}:{string.format("%02d", v18)}`;
end;

local u19 = { { "h", 3600 }, { "m", 60 }, { "s", 1 } };

function u8.formatTimeUnits(p20: number, p21: string?, p22: number?, p23: boolean?) -- Line: 195
    -- upvalues: u19 (copy)
    local math_floor_ret = math.floor(p20);
    local math_max_ret = math.max(math_floor_ret, 0);
    local math_clamp_ret = math.clamp(p22 or 3, 1, 3);
    local v24 = not p23 and 1 or 4 - math_clamp_ret;
    local table_move_ret = table.move(u19, v24, v24 + math_clamp_ret - 1, 1, {});
    local v25 = {};

    for i, v in table_move_ret do
        local math_floor_ret2 = math.floor(math_max_ret / v[2]);
        math_max_ret = math_max_ret % v[2];

        if math_floor_ret2 > 0 or #v25 == 0 and i == #table_move_ret then
            local v26 = `{math_floor_ret2}{v[1]}`;
            table.insert(v25, v26);
        end;
    end;

    return table.concat(v25, p21 or "");
end;

local u27 = { { "d", 86400 }, { "h", 3600 }, { "m", 60 }, { "s", 1 } };

function u8.formatTimeVerbose(p28: number) -- Line: 216
    -- upvalues: u27 (copy)
    local math_floor_ret = math.floor(p28);
    local math_max_ret = math.max(math_floor_ret, 0);
    local v29 = {};

    for i, v in u27 do
        local math_floor_ret2 = math.floor(math_max_ret / v[2]);
        math_max_ret = math_max_ret % v[2];

        if math_floor_ret2 > 0 or #v29 == 0 and i == #u27 then
            local v30 = `{math_floor_ret2}{v[1]}`;
            table.insert(v29, v30);
        end;
    end;

    if #v29 <= 1 then
        return v29[1];
    end;

    return `{table.concat(v29, " ", 1, #v29 - 1)} and {v29[#v29]}`;
end;

local u31 = { { "year", 31536000 }, { "month", 2592000 }, { "week", 604800 }, { "day", 86400 }, { "hour", 3600 }, { "minute", 60 } };

function u8.formatTimeAgo(p32: number) -- Line: 245
    -- upvalues: u31 (copy)
    local v33 = os.time() - math.floor(p32);
    local math_max_ret = math.max(v33, 0);

    for _, v in u31 do
        local math_floor_ret = math.floor(math_max_ret / v[2]);

        if math_floor_ret >= 1 then
            return `{math_floor_ret} {v[1]}{math_floor_ret > 1 and "s" or ""} ago`;
        end;
    end;

    return "Just now";
end;

function u8.calcvel(p34, p35, p36, p37) -- Line: 255
    return (p34 - p35 - 0.5 * p36 * p37 * p37) / p37;
end;

local TextService = game:GetService("TextService");
game:GetService("Workspace");
local gameSettings2 = require(ReplicatedStorage.CAM.Global.gameSettings);

function u8.AddTag(p38: userdata, p39: string) -- Line: 261
    p38:AddTag(p39);

    return p38;
end;

function u8.CreatePrompt(p40: table) -- Line: 269
    -- upvalues: gameSettings2 (copy)
    local ProximityPrompt = Instance.new("ProximityPrompt");
    ProximityPrompt.ActionText = p40.ActionText or "Interact";
    ProximityPrompt.ObjectText = p40.ObjectText or "";
    ProximityPrompt.Name = p40.Name or ((p40.ObjectText == nil or p40.ObjectText == "") and "ProximityPrompt" or (p40.ObjectText or "ProximityPrompt"));
    ProximityPrompt.HoldDuration = p40.HoldDuration or 0;
    ProximityPrompt.MaxActivationDistance = p40.MaxActivationDistance or 8;
    ProximityPrompt.MaxIndicatorDistance = p40.MaxIndicatorDistance or ProximityPrompt.MaxActivationDistance + gameSettings2.indicatorAdditionalDistance;
    ProximityPrompt.KeyboardKeyCode = p40.KeyboardKeyCode or Enum.KeyCode.T;
    ProximityPrompt.Style = p40.Style or Enum.ProximityPromptStyle.Custom;
    local v41;

    if p40.RequiresLineOfSight == nil then
        v41 = false;
    else
        v41 = p40.RequiresLineOfSight;
    end;

    ProximityPrompt.RequiresLineOfSight = v41;

    if p40.Enabled ~= nil then
        ProximityPrompt.Enabled = p40.Enabled;
    end;

    if p40.Tags ~= nil then
        for _, v in p40.Tags do
            ProximityPrompt:AddTag(v);
        end;
    end;

    if p40.Attributes ~= nil then
        for i, v in p40.Attributes do
            ProximityPrompt:SetAttribute(i, v);
        end;
    end;

    ProximityPrompt.Parent = p40.Parent;

    return ProximityPrompt;
end;

function u8.CreateOuwWeld(p42: userdata, p43: userdata, p44, p45: number?) -- Line: 316
    -- upvalues: DebrisModule (copy)
    if p42 ~= nil and p43 ~= nil then
        local ObjectValue = Instance.new("ObjectValue");
        ObjectValue.Parent = p42;
        ObjectValue.Value = p43;

        if p44 ~= nil then
            ObjectValue:SetAttribute("Offset", p44);
        end;

        local ObjectValue2 = Instance.new("ObjectValue", ObjectValue);
        ObjectValue2.Name = "To";
        ObjectValue2.Value = p42;
        task.defer(ObjectValue.AddTag, ObjectValue, "OuwWeld");

        if p45 ~= nil then
            DebrisModule:AddItem(ObjectValue, p45);
        end;

        return ObjectValue;
    end;

    warn("Unable to create weld");
end;

function u8.filterText(p46: userdata, u47: string) -- Line: 338
    -- upvalues: TextService (copy)
    if p46 ~= nil and (typeof(u47) == "string" and #u47 <= 200) then
        local UserId = p46.UserId;
        local u48 = nil;
        pcall(function() -- Line: 342
            -- upvalues: TextService (ref), u47 (copy), UserId (copy), u48 (ref)
            u48 = TextService:FilterStringAsync(u47, UserId):GetNonChatStringForUserAsync(UserId);
        end);

        return u48;
    end;
end;

function u8.addCommasToNumber(p49: number) -- Line: 348
    local v50 = tostring(p49);
    local v51 = v50:sub(1, 1) == "-";

    if v51 then
        v50 = v50:sub(2);
    end;

    local v52, v53 = v50:match("^(%d+)(%.%d*)$");
    local v54 = (v52 or v50):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");

    if v53 then
        v54 = v54 .. v53;
    end;

    if v51 then
        v54 = "-" .. v54;
    end;

    return v54;
end;

local u55 = { "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen", "Eighteen", "Nineteen" };
local u56 = { "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninety" };
local u57 = { "Thousand", "Million", "Billion", "Trillion" };

function u8.numberToWords(p58: number) -- Line: 376
    -- upvalues: u55 (copy), u56 (copy), u57 (copy)
    local math_round_ret = math.round(p58);

    if math_round_ret == 0 then
        return "Zero";
    end;

    local u59 = {};

    if math_round_ret < 0 then
        table.insert(u59, "Negative");
        math_round_ret = -math_round_ret;
    end;

    local function underThousand(p60: number) -- Line: 384
        -- upvalues: u59 (copy), u55 (ref), u56 (ref)
        if p60 >= 100 then
            local v61 = u55[math.floor(p60 / 100)];
            table.insert(u59, v61);
            table.insert(u59, "Hundred");
            p60 = p60 % 100;
        end;

        if p60 >= 20 then
            local v62 = u56[math.floor(p60 / 10) - 1];
            table.insert(u59, v62);
            p60 = p60 % 10;
        end;

        if p60 > 0 then
            table.insert(u59, u55[p60]);
        end;
    end;

    local v63 = {};

    while math_round_ret > 0 do
        table.insert(v63, 1, math_round_ret % 1000);
        math_round_ret = math.floor(math_round_ret / 1000);
    end;

    for i, v in v63 do
        if v > 0 then
            local v64;

            if v >= 100 then
                local v65 = u55[math.floor(v / 100)];
                table.insert(u59, v65);
                table.insert(u59, "Hundred");
                v64 = v % 100;
            else
                v64 = v;
            end;

            if v64 >= 20 then
                local v66 = u56[math.floor(v64 / 10) - 1];
                table.insert(u59, v66);
                v64 = v64 % 10;
            end;

            if v64 > 0 then
                table.insert(u59, u55[v64]);
            end;

            local v67 = u57[#v63 - i];

            if v67 ~= nil then
                table.insert(u59, v67);
            end;
        end;
    end;

    return table.concat(u59, " ");
end;

function u8.Damagehighlight(p68, p69) -- Line: 415
    -- upvalues: DebrisModule (copy), TweenService (copy), TweenInfo_new_ret (copy)
    if p68 == nil or p68.Parent == nil then
        return;
    end;

    if p68.Parent:FindFirstChild("Hit_Highlight123asd") then
        p68.Parent.Hit_Highlight123asd:Destroy();
    end;

    local Highlight = Instance.new("Highlight");
    Highlight.FillTransparency = p69 == -1 and 0.4 or -0.3;
    Highlight.Name = "Hit_Highlight123asd";
    Highlight.DepthMode = Enum.HighlightDepthMode.Occluded;
    Highlight.OutlineTransparency = 1;
    Highlight.FillColor = Color3.fromRGB(255, 0, 0);
    Highlight.Parent = p68.Parent;
    DebrisModule:AddItem(Highlight, 0.15);
    TweenService:Create(Highlight, TweenInfo_new_ret, {
        FillTransparency = 1
    }):Play();
end;

function u8.Tick() -- Line: 431
    return workspace:GetServerTimeNow();
end;

function u8.GetPosInBeam(p70, p71, p72, p73, p74) -- Line: 435
    return (1 - p70) ^ 3 * p71 + 3 * (1 - p70) ^ 2 * p70 * p72 + 3 * (1 - p70) * p70 ^ 2 * p73 + p70 ^ 3 * p74;
end;

function u8.Bezier_Curve_beam_curve_calc(p75: vector, p76: vector, p77: number) -- Line: 439
    local v78 = (p75 + p76) / 2;
    local Vector3_new_ret = Vector3.new(v78.x, v78.y + p77, v78.z);

    return Vector3_new_ret * 0.6666666666666666 + p75 * 0.3333333333333333, Vector3_new_ret * 0.6666666666666666 + p76 * 0.3333333333333333;
end;

function u8.ClearChildren(p79: userdata?) -- Line: 487
    if p79 == nil then
        return;
    end;

    for _, child in ipairs(p79:GetChildren()) do
        child:Destroy();
    end;
end;

local u80 = {
    swimbv = true
};
local u81 = {
    air_combo_bp = true
};

function u8.ClearMovers(p82) -- Line: 500
    -- upvalues: u80 (copy), u81 (copy)
    if p82 == nil then
        return;
    end;

    for _, child in pairs(p82:GetChildren()) do
        if u80[child.Name] == nil and (child:FindFirstChildOfClass("LinearVelocity") or u81[child.Name]) then
            child:Destroy();
        end;
    end;

    p82.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
    p82.Velocity = Vector3.new(0, 0, 0);
end;

local u83 = {
    combat_knockbackLast = "combat_knockback"
};

function u8.IsMeshRig(p84: userdata?) -- Line: 520
    if p84 == nil or not p84:IsA("Model") then
        return false;
    end;

    local Attribute = p84:GetAttribute("IsMeshRig");

    if Attribute ~= nil then
        return Attribute;
    end;

    local v85;

    if p84:FindFirstChild("Torso") == nil then
        v85 = p84:FindFirstChild("UpperTorso") == nil;
    else
        v85 = false;
    end;

    p84:SetAttribute("IsMeshRig", v85 and true or nil);

    return v85;
end;

function u8.bv(p86, p87, p88, p89) -- Line: 533
    -- upvalues: u8 (copy), u83 (copy), u80 (copy), os_clock (copy), math_clamp (copy), DebrisModule (copy)
    if p86 == nil then
        return;
    end;

    if p87.Magnitude ~= p87.Magnitude or p87.Magnitude == (1 / 0) then
        return;
    end;

    local valuesfolder = u8.getvaluesfolder(p86.Parent);

    if valuesfolder == nil then
        return;
    end;

    if valuesfolder:FindFirstChild("Swapping") then
        return;
    end;

    local v90 = p89 or "regular_bv";
    local v91 = u83[v90] or v90;

    if p86:FindFirstChild("dash_thang_123asd") ~= nil then
        p86.dash_thang_123asd:Destroy();
    end;

    local Y = p87.Y;
    local v92 = true;

    if p89 == "delete" then
        for _, child in pairs(p86:GetChildren()) do
            if u80[child.Name] == nil and (child:FindFirstChild("Velocity") and child.Velocity:IsA("LinearVelocity")) then
                child:Destroy();
            end;
        end;

        return;
    end;

    if p86:FindFirstChild(v91) ~= nil then
        local v93 = true;

        for _, child in pairs(p86:GetChildren()) do
            if child.Name == v91 then
                local Velocity = child:FindFirstChild("Velocity");
                local v94;

                if Velocity == nil then
                    v94 = 0;
                elseif Velocity.VelocityConstraintMode == Enum.VelocityConstraintMode.Line then
                    v94 = Velocity.LineVelocity;
                else
                    v94 = Velocity.VectorVelocity.Magnitude;
                end;

                if v94 <= p87.Magnitude then
                    child:Destroy();
                else
                    v93 = false;
                end;
            end;
        end;

        if v93 ~= true then
            v92 = false;
        end;
    end;

    if v92 == true then
        local Attachment = Instance.new("Attachment");
        Attachment.Name = v91;
        Attachment:SetAttribute("Added", os_clock());
        Attachment:SetAttribute("Duration", p88);
        local LinearVelocity = Instance.new("LinearVelocity");
        Attachment.Parent = p86;
        LinearVelocity.Name = "Velocity";
        LinearVelocity.Parent = Attachment;
        local v95 = math_clamp(p86.AssemblyMass / 2.2, 1, 999) * 20000;

        if u8.IsMeshRig(p86.Parent) then
            v95 = math.max(v95, 40000);
        end;

        LinearVelocity.ForceLimitMode = Enum.ForceLimitMode.PerAxis;

        if Y == 0 then
            LinearVelocity.MaxAxesForce = Vector3.new(v95, 0, v95);
        else
            LinearVelocity.MaxAxesForce = Vector3.new(v95, v95, v95);
        end;

        LinearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector;
        LinearVelocity.VectorVelocity = p87;
        LinearVelocity.Attachment0 = Attachment;
        DebrisModule:AddItem(Attachment, p88);
    end;
end;

function u8.SinglePartHitbox(p96: table) -- Line: 657
    -- upvalues: RaycastHelper (copy), gameSettings (copy), u1 (copy)
    if p96 ~= nil and (p96.Caster ~= nil and (p96.BoxSize ~= nil and p96.ParamsName ~= nil)) then
        local DynamicOverlapParams, v97 = RaycastHelper.GetDynamicOverlapParams(p96.ParamsName, 5);

        if v97 then
            DynamicOverlapParams.FilterDescendantsInstances = { p96.Caster, workspace.Map, workspace.Debree };
            DynamicOverlapParams.FilterType = Enum.RaycastFilterType.Exclude;
            DynamicOverlapParams.MaxParts = p96.MaxParts or 16;
        end;

        local v98 = p96.Within or { workspace:FindFirstChild("Humanoids") };

        if (gameSettings.hitboxVisualiserEnabled or p96.Visualize) and u1 then
            local Part = Instance.new("Part");
            Part.CanCollide = false;
            Part.Anchored = true;
            Part.Color = Color3.new(0, 1, 0);
            Part.CanQuery = false;
            Part.CFrame = p96.Origin;
            Part.Size = p96.BoxSize;
            Part.Parent = workspace.Debree;
            Part.TopSurface = Enum.SurfaceType.SmoothNoOutlines;
            Part.BottomSurface = Enum.SurfaceType.SmoothNoOutlines;
            Part.Transparency = 0.9;
            game:GetService("Debris"):AddItem(Part, 1);
        end;

        local PartBoundsInBox = workspace:GetPartBoundsInBox(p96.Origin, p96.BoxSize, DynamicOverlapParams);

        if v98[1] == nil then
            return PartBoundsInBox[1];
        end;

        for _, v in PartBoundsInBox do
            local v99 = v;

            for _, v2 in v98 do
                if v99:IsDescendantOf(v2) then
                    return v99;
                end;
            end;
        end;

        return nil;
    end;
end;

function u8.TreeDestruction(p100: table) -- Line: 699
    -- upvalues: OverlapParams_new_ret (copy), gameSettings (copy), u3 (copy), EffectsEvent (copy)
    if p100 == nil then
        return;
    end;

    if p100.CFrame == nil then
        return;
    end;

    if p100.Size == nil then
        return;
    end;

    p100.Level = p100.Level or 2;
    local PartBoundsInBox = workspace:GetPartBoundsInBox(p100.CFrame, p100.Size, OverlapParams_new_ret);
    local v101 = #PartBoundsInBox > 0;
    local v102, u103, u104;

    if v101 then
        v102 = {};
        u103 = {};
        u104 = {};
        task.delay(gameSettings.TreeDestructionRespawnTime, function() -- Line: 722
            -- upvalues: u104 (ref), u103 (ref)
            for i, v in u104 do
                if i.Parent == workspace.Debree and v.Parent ~= nil then
                    i.Parent = v;
                end;
            end;

            for _, v in u103 do
                if v.Parent ~= nil then
                    v.CanCollide = true;
                end;
            end;
        end);
    else
        v102 = nil;
        u104 = nil;
        u103 = nil;
    end;

    for _, v in PartBoundsInBox do
        if v:GetAttribute("IsBush") then
            if v102.Bush == nil then
                v102.Bush = {};
            end;

            if v.CanCollide == true then
                table.insert(u103, v);
                v.CanCollide = false;
            end;

            u104[v] = v.Parent;
            v.Parent = workspace.Debree;
            table.insert(v102.Bush, v);
        else
            local Parent = v.Parent;
            local v105 = v;
            local v106 = false;

            for _, child in Parent:GetChildren() do
                if child:IsA("Model") then
                    v106 = true;
                    break;
                end;
            end;

            if v106 then
                if v105.Parent ~= workspace.Debree then
                    if v102.Bush == nil then
                        v102.Bush = {};
                    end;

                    if v105.CanCollide == true then
                        table.insert(u103, v105);
                        v105.CanCollide = false;
                    end;

                    u104[v105] = v105.Parent;
                    v105.Parent = workspace.Debree;
                    table.insert(v102.Bush, v105);
                end;
            elseif Parent.Parent ~= workspace.Debree then
                if v102.Others == nil then
                    v102.Others = {};
                end;

                u104[Parent] = Parent.Parent;
                Parent.Parent = workspace.Debree;
                table.insert(v102.Others, Parent);

                for _, descendant in Parent:GetDescendants() do
                    if descendant:IsA("BasePart") and descendant.CanCollide == true then
                        table.insert(u103, descendant);
                        descendant.CanCollide = false;
                    end;
                end;
            end;
        end;
    end;

    if v101 and (u3 and (v102.Bush ~= nil or v102.Others ~= nil)) then
        EffectsEvent.ToAllInRange(p100.CFrame, "TreeDestruction", v102);
    end;
end;

function u8.ProcessHitboxTarget(p107: table, p108: userdata) -- Line: 805
    -- upvalues: u8 (copy)
    if p108 == p107.caster then
        return false, false;
    end;

    local Humanoid = p108:FindFirstChild("Humanoid");
    local v109;

    if Humanoid == nil then
        v109 = nil;
    else
        v109 = Humanoid.RootPart or nil;
    end;

    if not (Humanoid and v109) then
        return false, false;
    end;

    local valuesfolder = u8.getvaluesfolder(p108);
    local v110 = p107.checker.check_victim(script, p107.caster, p108);

    if v110 == nil then
        return false, false, valuesfolder;
    end;

    if p107.hitPriorityHandler and p107.hitPriorityHandler.callback(valuesfolder, p107.hitPriorityHandler.data) == true then
        return false, false, valuesfolder, v110;
    end;

    if p107.specificStateResult and v110 ~= p107.specificStateResult then
        return false, false, valuesfolder, v110;
    end;

    return true, p107.hitDetected(p108, valuesfolder, v110, p107.extraArgs or {}) == true, valuesfolder, v110;
end;

function u8.ProcessHitboxTargets(p111: table, p112: table) -- Line: 825
    -- upvalues: u8 (copy)
    if p111.targets then
        if typeof(p111.targets) == "table" then
            for _, v in pairs(p111.targets) do
                if table.find(p112, v) == nil then
                    table.insert(p112, v);
                end;
            end;
        elseif table.find(p112, p111.targets) == nil then
            table.insert(p112, p111.targets);
        end;
    end;

    local v113 = {};

    for _, v in p112 do
        local v114, v115, _, v116 = u8.ProcessHitboxTarget(p111, v);

        if v114 and v116 == true then
            table.insert(v113, v);
        end;

        if v115 then
            break;
        end;
    end;

    local v117 = v113[1] ~= nil;

    if p111.After ~= nil then
        p111.After(v117, v113);
    end;

    return v117, v113;
end;

function u8.SnapAimToTarget(p118: table) -- Line: 869
    -- upvalues: u8 (copy)
    local v119 = u8.SinglePartHitbox({
        Caster = p118.Caster,
        ParamsName = p118.ParamsName,
        Origin = CFrame.new(p118.Aim),
        BoxSize = Vector3.new(1, 1, 1) * p118.Radius
    });

    if v119 == nil then
        return p118.Aim, nil;
    end;

    local v120 = u8.find_character_from_descendant(v119);

    if v120 == nil or v120 == p118.Caster then
        return p118.Aim, nil;
    end;

    if p118.Checker.check_can_select(script, p118.Caster, v120) ~= true then
        return p118.Aim, nil;
    end;

    local HumanoidRootPart = v120:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart == nil then
        return p118.Aim, nil;
    end;

    if p118.Feet == true then
        return HumanoidRootPart.Position - Vector3.new(0, HumanoidRootPart.Size.Y / 2, 0), v120;
    end;

    return HumanoidRootPart.Position, v120;
end;

function u8.CreateHitbox(p121: table) -- Line: 897
    -- upvalues: u8 (copy)
    if p121.TreeDestructionLevel ~= nil or p121.TreeDestruction then
        u8.TreeDestruction({
            Level = p121.TreeDestructionLevel or 2,
            CFrame = p121.hitboxCFrame,
            Size = p121.hitboxSize
        });
    end;

    local ModelInRegion = u8.GetModelInRegion(p121.hitboxCFrame, p121.hitboxSize, p121.customTagName, p121.maxParts, p121.visualize);

    return u8.ProcessHitboxTargets(p121, ModelInRegion);
end;

function u8.lock(p122: userdata, p123, p124: number?, p125: string?) -- Line: 908
    -- upvalues: DebrisModule (copy)
    p122:PivotTo(p123);
    local v126;

    if p125 then
        v126 = workspace.Debree:FindFirstChild(p125);
    else
        v126 = p125;
    end;

    if not v126 then
        v126 = script.LOCK:Clone();
        v126.Name = p125 or "LOCK";
        v126.Anchored = true;
        v126.Parent = workspace.Debree;
        v126.Transparency = 1;
    end;

    v126:PivotTo(p123);

    if p124 then
        DebrisModule:AddItem(v126, p124);
    end;

    local Weld = v126.Weld;
    Weld.Part0 = v126;
    Weld.Part1 = p122;

    return v126;
end;

function u8.AddValue(p127: userdata, p128: string, p129: number?, p130: userdata?, p131: any) -- Line: 933
    -- upvalues: DebrisModule (copy)
    local v132 = p130 and Instance.new(p130) or Instance.new("BoolValue");
    v132.Name = p128;
    v132.Value = p131 or (v132.ClassName == "BoolValue" and true or v132.Value);
    v132.Parent = p127;

    if p129 ~= nil then
        DebrisModule:AddItem(v132, p129);
    end;

    return v132;
end;

function u8.AddTimedValue(p133: userdata, p134: string, p135: number?, p136: string?, p137: any) -- Line: 955
    -- upvalues: u8 (copy)
    local v138 = u8.AddValue(p133, p134, p135, p136, p137);
    v138:SetAttribute("_Started", workspace:GetServerTimeNow());
    v138:SetAttribute("_Duration", p135 or 0);

    return v138;
end;

u8.DODGE_VALUE = "Dodge";

function u8.AddDodges(p139: userdata, p140: number, p141: number?, p142: boolean?, p143: string?) -- Line: 979
    -- upvalues: u8 (copy)
    if p139 == nil or (p140 == nil or p140 <= 0) then
        return nil;
    end;

    if p139:IsA("Player") then
        p139 = p139.Character;

        if p139 == nil then
            return nil;
        end;
    end;

    local valuesfolder = u8.getvaluesfolder(p139);

    if valuesfolder == nil then
        return nil;
    end;

    local v144 = u8.AddTimedValue(valuesfolder, u8.DODGE_VALUE, p141, "IntValue", p140);
    v144:SetAttribute("Mode", p142 == true and "All" or "Combat");

    if p143 ~= nil then
        v144:SetAttribute("Skill", p143);
    end;

    return v144;
end;

function u8.bg(p145: userdata, p146, p147: number, p148: number) -- Line: 993
    -- upvalues: u8 (copy), DebrisModule (copy)
    local v149 = u8.getvaluesfolder(p145.Parent) or p145.Parent;
    u8.AddValue(v149, "NR", p147);

    if p145:FindFirstChild("rotremove123asdasd") ~= nil then
        for _, child in p145:GetChildren() do
            if child.Name == "rotremove123asdasd" then
                child:Destroy();
            end;
        end;
    end;

    local Attachment = Instance.new("Attachment", p145);
    local Part = Instance.new("Part");
    Part.Name = "P";
    Part.Size = Vector3.new(1, 1, 1);
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanTouch = false;
    Part.CanQuery = false;
    Part.Transparency = 1;
    Part.CFrame = p146;
    Part.Parent = p145;
    local AlignOrientation = Instance.new("AlignOrientation");

    if p148 ~= nil then
        AlignOrientation.Responsiveness = p148;
    end;

    AlignOrientation.Attachment0 = Attachment;
    DebrisModule:AddItem(AlignOrientation, p147);
    local Attachment2 = Instance.new("Attachment", Part);
    AlignOrientation.Attachment1 = Attachment2;
    AlignOrientation.Parent = p145;
    DebrisModule:AddItem(Attachment, p147);
    DebrisModule:AddItem(Attachment2, p147);
    DebrisModule:AddItem(Part, p147);
    AlignOrientation.Name = "rotremove123asdasd";
    Attachment.Name = "rotremove123asdasd";
    Attachment2.Name = "rotremove123asdasd";
    Part.Name = "rotremove123asdasd";
end;

function u8.GetRoot(p150: any, p151: boolean?) -- Line: 1058
    -- upvalues: u2 (copy)
    if typeof(p150) == "Instance" then
        p150 = p150.Name;
    end;

    if p150 == nil or p150 == "" then
        return nil;
    end;

    if u2 == false then
        p150 = p150 .. "-Studio";
    end;

    local Data = game.ReplicatedStorage.Player_Service.Data;

    if p151 == true then
        return Data:WaitForChild(p150);
    end;

    return Data:FindFirstChild(p150);
end;

function u8.GetData(p152: userdata, p153: boolean, p154: string) -- Line: 1070
    -- upvalues: u2 (copy)
    if p152 == nil then
        if u2 == false then
            local Player_Service = game.ReplicatedStorage:FindFirstChild("Player_Service");
            local v155;

            if Player_Service == nil then
                v155 = nil;
            else
                v155 = Player_Service:FindFirstChild("Data");
            end;

            if v155 == nil then
                return;
            end;

            for _, child in v155:GetChildren() do
                if string.sub(child.Name, -7) == "-Studio" then
                    return child;
                end;
            end;
        end;

        return;
    end;

    if not p154 then
        p152 = p152.Name or p152;
    end;

    local v156;

    if u2 == false then
        if p153 == true then
            v156 = game.ReplicatedStorage.Player_Service.Data:WaitForChild(p152 .. "-Studio");
        else
            v156 = game.ReplicatedStorage.Player_Service.Data:FindFirstChild(p152 .. "-Studio");
        end;
    elseif p153 == true then
        v156 = game.ReplicatedStorage.Player_Service.Data:WaitForChild(p152);
    else
        v156 = game.ReplicatedStorage.Player_Service.Data:FindFirstChild(p152);
    end;

    if not v156 then
        return;
    end;

    if p153 == true then
        local slotEquipped = v156:WaitForChild("slotEquipped");

        return v156:WaitForChild("slots"):WaitForChild("Slot" .. slotEquipped.Value), v156, slotEquipped;
    end;

    local slotEquipped = v156:FindFirstChild("slotEquipped");
    local slots = v156:FindFirstChild("slots");
    local v157;

    if slotEquipped == nil or slots == nil then
        v157 = nil;
    else
        v157 = slots:FindFirstChild("Slot" .. slotEquipped.Value);
    end;

    if v157 ~= nil then
        return v157, v156, slotEquipped;
    end;
end;

function u8.SafeLookAt(p158: vector, p159: vector, p160) -- Line: 1156
    local v161 = p159 - p158;
    local Magnitude = v161.Magnitude;

    if Magnitude ~= Magnitude or Magnitude < 0.05 then
        return p160;
    end;

    if math.abs(v161.Unit.Y) > 0.999 then
        return CFrame.lookAt(p158, p159, p160.RightVector);
    end;

    return CFrame.lookAt(p158, p159);
end;

function u8.SafeMoverTarget(p162: vector, p163: vector) -- Line: 1184
    local Magnitude = p162.Magnitude;

    if Magnitude == Magnitude and Magnitude ~= (1 / 0) then
        return p162;
    end;

    return p163;
end;

function u8.SafeDirection(p164: vector, p165: vector) -- Line: 1197
    local v166 = p165 - p164;
    local Magnitude = v166.Magnitude;

    if Magnitude == Magnitude and (Magnitude ~= (1 / 0) and Magnitude >= 0.05) then
        return v166 / Magnitude;
    end;

    return nil;
end;

function u8.getvaluesfolder(p167: userdata, p168: boolean?) -- Line: 1205
    -- upvalues: u2 (copy)
    if p167 == nil then
        return nil;
    end;

    local v169 = p167.Name or p167;

    if not u2 then
        v169 = v169 .. "-Studio";
    end;

    if v169 ~= nil then
        local v170;

        if p168 then
            v170 = game.ReplicatedStorage.Player_Service.Values:WaitForChild(v169);
        else
            v170 = game.ReplicatedStorage.Player_Service.Values:FindFirstChild(v169) or p167;
        end;

        if p167.Parent == nil then
            p167 = v170;
        elseif not p167:FindFirstChild("Clone_Owner") then
            p167 = v170;
        end;

        return p167;
    end;
end;

function u8.GetModelInRegion(p171, p172: vector, p173: string?, p174: number?, p175: boolean?) -- Line: 1224
    -- upvalues: Humanoids (copy), CollectionService (copy), gameSettings (copy), u1 (copy), HitboxVisuals (copy)
    local v176 = Humanoids;

    if p173 ~= nil and p173 ~= "Humanoids" then
        v176 = OverlapParams.new();
        v176.FilterType = Enum.RaycastFilterType.Include;
        v176.FilterDescendantsInstances = CollectionService:GetTagged(p173);
        v176.MaxParts = p174 or 350;
    end;

    local v177 = {};

    for _, v in workspace:GetPartBoundsInBox(p171, p172, v176) do
        local Parent = v.Parent;

        if Parent:IsA("Model") and (Parent.PrimaryPart ~= nil and table.find(v177, Parent) == nil) then
            table.insert(v177, Parent);
        end;
    end;

    if (gameSettings.hitboxVisualiserEnabled == true or p175 == true) and u1 == true then
        local Part = Instance.new("Part");
        Part.Anchored = true;
        Part.CanCollide = false;
        Part.CastShadow = false;
        Part.CanQuery = false;
        Part.TopSurface = Enum.SurfaceType.SmoothNoOutlines;
        Part.BottomSurface = Enum.SurfaceType.SmoothNoOutlines;
        Part.Transparency = gameSettings.HitBoxTransparency or 0.85;
        Part.Color = Color3.fromRGB(255, 0, 0);
        Part.Name = "HitboxVisual";
        Part.Size = p172;
        Part.CFrame = p171;
        Part.Parent = HitboxVisuals or workspace.Debree;
        game:GetService("Debris"):AddItem(Part, 1);
    end;

    return v177;
end;

function u8.checkGamePassOwnership(p178, u179, u180) -- Line: 1262
    -- upvalues: MarketplaceService (copy)
    local success, result = pcall(function() -- Line: 1266
        -- upvalues: MarketplaceService (ref), u179 (copy), u180 (copy)
        return MarketplaceService:UserOwnsGamePassAsync(u179.UserId, u180);
    end);

    if success then
        return result;
    end;

    warn("Failed to check game pass ownership for player " .. u179.Name);

    return false;
end;

local math_clamp2 = math.clamp;
local Vector3_new = Vector3.new;
local math_floor = math.floor;

function u8.Lerp(p181: table, p182: any, p183: any, p184: number) -- Line: 1282
    return p182 + (p183 - p182) * p184;
end;

function u8.Lerp_Color(p185, p186, p187: number) -- Line: 1285
    -- upvalues: u8 (copy), math_clamp2 (copy), math_floor (copy), Vector3_new (copy)
    local v188 = u8:Lerp(Vector3.new(p185.R * 255, p185.G * 255, p185.B * 255), Vector3.new(p186.R * 255, p186.G * 255, p186.B * 255), p187);

    return Vector3_new(math_floor((math_clamp2(v188.X, 0, 255))), math_floor((math_clamp2(v188.Y, 0, 255))), (math_floor((math_clamp2(v188.Z, 0, 255)))));
end;

function u8.Lerp_Color2(p189, p190, p191: number) -- Line: 1291
    -- upvalues: u8 (copy), math_clamp2 (copy), math_floor (copy)
    local v192 = u8:Lerp(Vector3.new(p189.R * 255, p189.G * 255, p189.B * 255), Vector3.new(p190.R * 255, p190.G * 255, p190.B * 255), p191);

    return Color3.fromRGB(math_floor((math_clamp2(v192.X, 0, 255))), math_floor((math_clamp2(v192.Y, 0, 255))), (math_floor((math_clamp2(v192.Z, 0, 255)))));
end;

function u8.Add_No_GP(p193: userdata, p194: userdata, p195: userdata, p196: number) -- Line: 1297
    -- upvalues: u8 (copy)
    if p194 ~= nil and p195 ~= nil then
        return u8.AddValue(p195, "pause_gameplay", p196);
    end;
end;

function u8.StunClear(p197: userdata, p198: any) -- Line: 1305
    if p198:FindFirstChild("SkillToggle") ~= nil then
        for _, child in pairs(p198:GetChildren()) do
            if child.Name == "SkillToggle" and child:GetAttribute("OnlySkill") == nil then
                child:Destroy();
            end;
        end;
    end;
end;

u8.TEMPORARY_BOOST = "TemporaryBoost";
local u199 = nil;

local function perHitShare(p200: userdata?) -- Line: 1337
    -- upvalues: u199 (ref), ReplicatedStorage (copy)
    if p200 == nil then
        return 1;
    end;

    if u199 == nil then
        u199 = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.StatsFetch.Modules.SkillStats);
    end;

    local v201;

    if p200.Parent == nil then
        v201 = nil;
    else
        v201 = u199.Get(p200.Parent.Name) or nil;
    end;

    if v201 == nil then
        v201 = u199.Get(p200.Name);
    end;

    return v201 and v201.additional_damage_scale or 1;
end;

function u8.StunChainBoost(p202: userdata?, p203: userdata?, p204: userdata?, p205: string) -- Line: 1352
    -- upvalues: u3 (copy), gameSettings2 (copy), Players (copy), perHitShare (copy), u8 (copy)
    if not u3 or p204 == nil then
        return;
    end;

    local StunChainBoost = gameSettings2.StunChainBoost;

    if StunChainBoost == nil or StunChainBoost.Enabled ~= true then
        return;
    end;

    local v206 = Players:FindFirstChild(p204.Name);
    local v207;

    if v206 == nil then
        v207 = false;
    else
        v207 = v206:IsA("Player");
    end;

    if not v207 and StunChainBoost.Npcs ~= true then
        return;
    end;

    local v208 = StunChainBoost[p205] or 1;

    if p205 == "Stun" then
        v208 = 1 + (v208 - 1) * perHitShare(p202);
    end;

    if v208 <= 1 then
        return;
    end;

    local u209 = nil;

    for _, child in p204:GetChildren() do
        if child.Name == u8.TEMPORARY_BOOST and (child:GetAttribute("Stat") == StunChainBoost.Stat and child:IsA("NumberValue")) then
            u209 = child;
            break;
        end;
    end;

    local ServerTimeNow = workspace:GetServerTimeNow();

    if u209 == nil then
        u209 = Instance.new("NumberValue");
        u209.Name = u8.TEMPORARY_BOOST;
        u209.Value = math.min(v208, StunChainBoost.Cap);
        u209:SetAttribute("Stat", StunChainBoost.Stat);
        u209:SetAttribute("_Duration", StunChainBoost.Duration);
        u209:SetAttribute("_Started", ServerTimeNow);
        u209:AddTag("OuwDebris");
        u209:SetAttribute("_OuwDebrisAt", ServerTimeNow + StunChainBoost.Duration);
        u209.Parent = p204;
    else
        u209.Value = math.min(u209.Value * v208, StunChainBoost.Cap);
        u209:SetAttribute("_Started", ServerTimeNow);
        u209:SetAttribute("_OuwDebrisAt", ServerTimeNow + StunChainBoost.Duration);
    end;

    if v207 and (p203 ~= nil and Players:GetPlayerFromCharacter(p203) ~= nil) then
        u209:SetAttribute("PvP", true);
    end;

    task.delay(StunChainBoost.Duration, function() -- Line: 1397
        -- upvalues: u209 (copy), ServerTimeNow (copy)
        if u209.Parent ~= nil and u209:GetAttribute("_Started") == ServerTimeNow then
            u209:Destroy();
        end;
    end);
end;

function u8.TemporaryBoostOf(p210: userdata?, p211: string) -- Line: 1404
    -- upvalues: u8 (copy)
    if p210 == nil then
        return 1;
    end;

    for _, child in p210:GetChildren() do
        if child.Name == u8.TEMPORARY_BOOST and (child:GetAttribute("Stat") == p211 and child:IsA("NumberValue")) then
            return child.Value;
        end;
    end;

    return 1;
end;

function u8.Add_Strict_Stun(p212: userdata, p213: any, p214: any, p215: any, p216: boolean?) -- Line: 1416
    -- upvalues: u8 (copy), DebrisModule (copy)
    if p213 ~= nil and p214 ~= nil then
        u8.StunClear(p212, p214);
        u8.StunChainBoost(p212, p213, p214, "StrictStun");
        local ObjectValue = Instance.new("ObjectValue");
        ObjectValue.Name = "Strict_Stun";
        ObjectValue.Value = p213;

        if p216 then
            ObjectValue:SetAttribute("PerfectBlock", true);
        end;

        ObjectValue.Parent = p214;
        DebrisModule:AddItem(ObjectValue, p215);

        return ObjectValue;
    end;
end;

function u8.AddStun(p217: userdata, p218: any, p219: any, p220: any) -- Line: 1431
    -- upvalues: u8 (copy), DebrisModule (copy)
    if p218 ~= nil and p219 ~= nil then
        u8.StunClear(p217, p219);
        u8.StunChainBoost(p217, p218, p219, "Stun");
        local ObjectValue = Instance.new("ObjectValue");
        ObjectValue.Name = "Stun";
        ObjectValue.Value = p218;
        ObjectValue.Parent = p219;
        DebrisModule:AddItem(ObjectValue, p220);

        return ObjectValue;
    end;
end;

function u8.AddCombatStun(p221: userdata, p222: any, p223: any, p224: any) -- Line: 1443
    -- upvalues: u8 (copy), DebrisModule (copy)
    if p222 ~= nil and p223 ~= nil then
        u8.StunClear(p221, p223);
        u8.StunChainBoost(p221, p222, p223, "CombatStun");
        local ObjectValue = Instance.new("ObjectValue");
        ObjectValue.Name = "CombatStun";
        ObjectValue.Value = p222;
        ObjectValue.Parent = p223;
        DebrisModule:AddItem(ObjectValue, p224);

        return ObjectValue;
    end;
end;

local u225 = {
    Mode = Enum.OrientationAlignmentMode.OneAttachment
};

function u8.CreateAlignOrientationWithAttachment(p226: userdata, p227: string, p228: table) -- Line: 1470
    -- upvalues: u225 (copy)
    local Attachment = Instance.new("Attachment");
    Attachment.Name = p227;
    local AlignOrientation = Instance.new("AlignOrientation");
    AlignOrientation.Name = p227;

    for i, v in pairs(u225) do
        AlignOrientation[i] = v;
    end;

    AlignOrientation.Attachment0 = Attachment;

    for i, v in pairs(p228) do
        AlignOrientation[i] = v;
    end;

    AlignOrientation.Parent = Attachment;
    Attachment.Parent = p226;

    return AlignOrientation, Attachment;
end;

function u8.FindPlayerByTypedName(p229: string) -- Line: 1503
    -- upvalues: Players (copy)
    if type(p229) ~= "string" or p229 == "" then
        return nil;
    end;

    local v230 = Players:FindFirstChild(p229);

    if v230 ~= nil and v230:IsA("Player") then
        return v230;
    end;

    local string_lower_ret = string.lower(p229);

    for _, v in Players:GetPlayers() do
        if string.lower(v.Name) == string_lower_ret then
            return v;
        end;
    end;

    local v231 = nil;

    for _, v in Players:GetPlayers() do
        if string.lower(v.DisplayName) == string_lower_ret then
            if v231 ~= nil then
                return nil;
            end;

            v231 = v;
        end;
    end;

    return v231;
end;

function u8.NameTag(p232: string, p233: boolean?) -- Line: 1520
    -- upvalues: gameSettings (copy)
    local RichTextPopularConfigs = gameSettings.RichTextPopularConfigs;

    if p233 then
        return `<font {string.lower(RichTextPopularConfigs.SoroundColorRBX)}>'{p232}'</font>`;
    end;

    return `['{p232}']<{RichTextPopularConfigs.SoroundColor}>`;
end;

u8.find_character_from_descendant = require(script.find_character_from_descendant);

return u8;