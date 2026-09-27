-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Debris = game:GetService("Debris");
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local Checker = require(ReplicatedStorage.CAM.Global.Checker);
local InCombat = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.InCombat);
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
require(ReplicatedStorage.CAM.Global.RaycastHelper);
local ManuelCancel = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.ManuelCancel);
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);
local EffectsEvent = require(ReplicatedStorage.Communication.ServerAndClient.Effects.EffectsEvent);
local RideAnimator = require(script.Parent.RideAnimator);
local ServerClientPortal = require(ReplicatedStorage.CAM.Global.ServerClientPortal);
local HorseModel = ReplicatedStorage.Assets:FindFirstChild("HorseModel");
local u1 = {};

local function equipCooldownLeft(p2: userdata) -- Line: 27
    -- upvalues: u1 (copy)
    local v3 = (u1[p2] or 0) - os.clock();

    return math.max(v3, 0);
end;

local function stampEquipCooldown(p4: userdata) -- Line: 30
    -- upvalues: u1 (copy), gameSettings (copy)
    u1[p4] = os.clock() + gameSettings.horseEquipCooldown;
end;

Players.PlayerRemoving:Connect(function(p5) -- Line: 33
    -- upvalues: u1 (copy)
    u1[p5] = nil;
end);
local Animations = script.Parent:FindFirstChild("Animations");
local u6;

if Animations then
    u6 = Animations:FindFirstChild("Player");
else
    u6 = Animations;
end;

if Animations then
    Animations = Animations:FindFirstChild("Horse");
end;

local u7 = {
    Gallop = true,
    Sprint = true
};
local u8 = script:FindFirstChild("Sounds") or ReplicatedStorage.Effects.Misc.HorseEffects:FindFirstChild("Sounds");

if u8 == nil then
    warn("HorseServer: no Sounds folder found (checked HorseServer and Effects/Misc/HorseEffects) -- horse movement SFX disabled");
end;

local u9 = { "PS2horseWALK", "PS2horseGALLOP", "PS2horseSPRINT", "PS2horseMOVEMENT" };
local u10 = {
    Walk = {
        PS2horseWALK = true
    },
    Gallop = {
        PS2horseGALLOP = true,
        PS2horseMOVEMENT = true
    },
    Sprint = {
        PS2horseSPRINT = true,
        PS2horseMOVEMENT = true
    }
};
local v11 = {};

local function playAnim(p12: userdata?, p13: userdata?) -- Line: 85
    if p12 == nil or p13 == nil then
        return nil;
    end;

    local v14 = p12:FindFirstChildOfClass("Animator");

    if v14 == nil then
        v14 = Instance.new("Animator");
        v14.Parent = p12;
    end;

    local v15 = v14:LoadAnimation(p13);
    v15:Play();

    return v15;
end;

local function startRideAnimation(p16: userdata, u17: userdata, u18: userdata) -- Line: 103
    -- upvalues: RideAnimator (copy), u6 (copy), Animations (copy), EffectsEvent (copy), u8 (copy), Debris (copy), u10 (copy), u9 (copy), ServerClientPortal (copy), u7 (copy)
    local u19 = u17:FindFirstChildOfClass("Humanoid");
    local Humanoid = u18:FindFirstChild("Humanoid");
    local u20 = RideAnimator.new({
        {
            animator = u19:FindFirstChildOfClass("Animator"),
            folder = u6
        },
        {
            animator = Humanoid:FindFirstChildOfClass("Animator"),
            folder = Animations
        }
    });
    local HumanoidRootPart = u18:FindFirstChild("HumanoidRootPart");

    local function fireHorseEffect(p21: string, p22: boolean?) -- Line: 118
        -- upvalues: EffectsEvent (ref), u17 (copy), u18 (copy), HumanoidRootPart (copy)
        if p22 then
            EffectsEvent.ToAll("HorseEffects", u17, u18, p21);

            return;
        end;

        local v23;

        if u18.Parent == nil then
            v23 = u17;
        else
            v23 = HumanoidRootPart or u18;
        end;

        EffectsEvent.ToAllInRange(v23, "HorseEffects", u17, u18, p21);
    end;

    local function playHorseSound(p24: string, p25: boolean) -- Line: 139
        -- upvalues: u8 (ref), HumanoidRootPart (copy), Debris (ref)
        if u8 == nil or HumanoidRootPart == nil then
            return;
        end;

        local v26 = u8:FindFirstChild(p24);

        if v26 == nil then
            return;
        end;

        local v27 = v26:Clone();
        v27.Looped = p25;
        v27.Parent = HumanoidRootPart;
        v27:Play();

        if not p25 then
            Debris:AddItem(v27, v27.TimeLength > 0 and v27.TimeLength or 3);
        end;
    end;

    local function reconcileLoops(p28: string) -- Line: 152
        -- upvalues: HumanoidRootPart (copy), u10 (ref), u9 (ref), u8 (ref)
        if HumanoidRootPart == nil then
            return;
        end;

        local v29 = u10[p28] or {};

        for _, v in u9 do
            local v30 = HumanoidRootPart:FindFirstChild(v);

            if v29[v] then
                if v30 == nil and u8 ~= nil then
                    if HumanoidRootPart ~= nil then
                        local v31 = u8:FindFirstChild(v);

                        if v31 ~= nil then
                            local v32 = v31:Clone();
                            v32.Looped = true;
                            v32.Parent = HumanoidRootPart;
                            v32:Play();
                        end;
                    end;
                end;
            elseif v30 then
                v30:Stop();
                v30:Destroy();
            end;
        end;
    end;

    local u33 = nil;
    local u34 = nil;
    local u35 = ServerClientPortal.Create(p16, "HorseGait", -1);
    local u36 = 0;
    local u37 = nil;
    local u38 = nil;
    local u39 = false;

    local function applyEffects() -- Line: 173
        -- upvalues: u37 (ref), u38 (ref), u33 (ref), u34 (ref), u36 (ref), u39 (ref), u35 (copy), applyEffects (copy), u7 (ref), EffectsEvent (ref), u17 (copy), u18 (copy), HumanoidRootPart (copy), reconcileLoops (copy), u19 (copy), playHorseSound (copy)
        local v40 = u37;
        local v41 = u38;

        if v40 ~= u33 or v41 ~= u34 then
            local v42 = 0.25 - (os.clock() - u36);

            if v42 > 0 then
                if not u39 then
                    u39 = true;
                    task.delay(v42, function() -- Line: 184
                        -- upvalues: u39 (ref), u35 (ref), applyEffects (ref)
                        u39 = false;

                        if u35.__Active then
                            applyEffects();
                        end;
                    end);
                end;

                return;
            end;

            u36 = os.clock();
        end;

        if v40 ~= u33 then
            local v43;

            if u7[u33] == true then
                v43 = u7[v40] ~= true;
            else
                v43 = false;
            end;

            u33 = v40;

            if v43 then
                EffectsEvent.ToAll("HorseEffects", u17, u18, v40);
            else
                local v44;

                if u18.Parent == nil then
                    v44 = u17;
                else
                    v44 = HumanoidRootPart or u18;
                end;

                EffectsEvent.ToAllInRange(v44, "HorseEffects", u17, u18, v40);
            end;

            reconcileLoops(v40);
        end;

        if u19.Health > 0 then
            if v41 == "Gallop" and u34 ~= "Gallop" then
                playHorseSound("PS2horseKICKOFFweak", false);
            elseif v41 == "Sprint" and u34 ~= "Sprint" then
                local v45;

                if u18.Parent == nil then
                    v45 = u17;
                else
                    v45 = HumanoidRootPart or u18;
                end;

                EffectsEvent.ToAllInRange(v45, "HorseEffects", u17, u18, "SprintActivated");
                playHorseSound("PS2horseKICKOFFstrong", false);
            end;
        end;

        u34 = v41;
    end;

    u35:Connect(function(p46: boolean, p47: string, p48: boolean) -- Line: 214
        -- upvalues: u19 (copy), u20 (copy), u37 (ref), u38 (ref), applyEffects (copy)
        if u19.Health <= 0 then
            p46 = false;
        end;

        u20:SetFalling(p48);
        u20:Update(p46, p47);
        u37 = (not p46 or p48) and "Idle" or p47;
        u38 = p47;
        applyEffects();
    end);
    local u49 = false;

    local function stop() -- Line: 233
        -- upvalues: u49 (ref), EffectsEvent (ref), u17 (copy), u18 (copy), reconcileLoops (copy), u35 (copy), u20 (copy)
        if u49 then
            return;
        end;

        u49 = true;
        EffectsEvent.ToAll("HorseEffects", u17, u18, "Idle");
        reconcileLoops("Idle");
        u35:Destroy();
        u20:Destroy();
    end;

    u18.Destroying:Connect(stop);

    return stop;
end;

local function restorePlayerNetwork(p50: userdata, p51: userdata?) -- Line: 247
    if p51 then
        p51 = p51:FindFirstChild("HumanoidRootPart");
    end;

    if p51 and (p50.Parent ~= nil and p51:CanSetNetworkOwnership()) then
        p51:SetNetworkOwner(p50);
    end;
end;

local function addFreeze(p52: table, p53: userdata, p54: userdata, p55: number) -- Line: 258
    -- upvalues: Utility (copy)
    p52.Freeze = {
        Utility.AddValue(p53, "skill_stand_still"),
        Utility.AddValue(p53, "pause_gameplay"),
        Utility.AddValue(p53, "NR"),
        Utility.AddValue(p53, "NOMouvementlines"),
        Utility.AddValue(p53, "hip_height", nil, "NumberValue", p55)
    };
    local v56;

    if p54 then
        v56 = p54:FindFirstChild("Head");
    else
        v56 = p54;
    end;

    if v56 then
        table.insert(p52.Freeze, Utility.AddValue(p53, "camsubject", nil, "ObjectValue", v56));
    end;

    p54:SetAttribute("OnHorse", true);
end;

local function removeFreeze(p57: table?) -- Line: 282
    if p57 == nil then
        return;
    end;

    for _, v in p57 do
        if v.Name == "NOMouvementlines" then
            task.delay(0.1, function() -- Line: 286
                -- upvalues: v (copy)
                v:Destroy();
            end);
        else
            v:Destroy();
        end;
    end;
end;

local function groundParams(p58: userdata) -- Line: 308
    local v59 = { p58, workspace.Debree };
    local Humanoids = workspace:FindFirstChild("Humanoids");

    if Humanoids then
        table.insert(v59, Humanoids);
    end;

    local RaycastParams_new_ret = RaycastParams.new();
    RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Exclude;
    RaycastParams_new_ret.FilterDescendantsInstances = v59;

    return RaycastParams_new_ret;
end;

local function placeHorse(p60: userdata, p61: userdata, p62: userdata, p63: userdata) -- Line: 318
    -- upvalues: gameSettings (copy)
    local CFrame2 = p62.CFrame;
    local Position = gameSettings.horseRidingPlayerOffset.Position;
    local Position2 = (CFrame2 * CFrame.new(-Position.X, 0, -Position.Z)).Position;
    local v64 = workspace:Raycast(Position2 + Vector3.new(0, 5, 0), Vector3.new(0, -60, 0), p63);
    local v65 = p62.Position.Y - 3;

    if v64 then
        v65 = math.max(v64.Position.Y, v65);
    end;

    local Attribute = p60:GetAttribute("hipheight");

    if Attribute == nil then
        local BoundingBox, v66 = p60:GetBoundingBox();
        Attribute = p61.Position.Y - (BoundingBox.Position.Y - v66.Y / 2);
        warn("Horse: HorseModel has no hipheight attribute; falling back to the stored-pose bounding box (likely wrong -- author the attribute)");
    end;

    p60:SetAttribute("RestHeight", Attribute);
    p60.PrimaryPart = p61;
    local Vector3_new_ret = Vector3.new(Position2.X, v65 + Attribute, Position2.Z);
    p60:PivotTo(CFrame.lookAt(Vector3_new_ret, Vector3_new_ret + CFrame2.LookVector));
end;

local function fadeHorse(u67: userdata) -- Line: 359
    -- upvalues: TweenService (copy)
    local HumanoidRootPart = u67:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart then
        HumanoidRootPart.Anchored = true;
    end;

    task.spawn(function() -- Line: 366
        -- upvalues: u67 (copy), TweenService (ref)
        local TweenInfo_new_ret = TweenInfo.new(0.35);

        for _, descendant in u67:GetDescendants() do
            if (descendant:IsA("BasePart") or (descendant:IsA("Decal") or descendant:IsA("Texture"))) and descendant.Transparency < 1 then
                TweenService:Create(descendant, TweenInfo_new_ret, {
                    Transparency = 1
                }):Play();
            end;
        end;

        task.wait(0.35);
        u67:Destroy();
    end);
end;

local function forceCleanup(p68: userdata, p69: userdata, p70: table, p71: boolean?) -- Line: 381
    -- upvalues: removeFreeze (copy), TweenService (copy)
    if p70.CancelDestroy then
        p70.CancelDestroy();
        p70.CancelDestroy = nil;
    end;

    if p70.SwimWatch then
        p70.SwimWatch:Disconnect();
        p70.SwimWatch = nil;
    end;

    if p70.StopRideAnim then
        p70.StopRideAnim();
        p70.StopRideAnim = nil;
    end;

    if p70.RidingHorse then
        p70.RidingHorse:Destroy();
        p70.RidingHorse = nil;
    end;

    if p70.GetOnTrack then
        p70.GetOnTrack:Stop();
        p70.GetOnTrack = nil;
    end;

    if p70.Weld then
        p70.Weld:Destroy();
        p70.Weld = nil;
    end;

    local v72;

    if p69 then
        v72 = p69:FindFirstChild("HumanoidRootPart");
    else
        v72 = p69;
    end;

    if v72 and (p68.Parent ~= nil and v72:CanSetNetworkOwnership()) then
        v72:SetNetworkOwner(p68);
    end;

    removeFreeze(p70.Freeze);
    p70.Freeze = nil;
    p69:SetAttribute("OnHorse", nil);
    local Horse = p70.Horse;
    p70.Horse = nil;
    p70.HorseRoot = nil;
    p70.Sequencing = false;

    if Horse then
        if p71 then
            Horse:Destroy();

            return;
        end;

        local HumanoidRootPart = Horse:FindFirstChild("HumanoidRootPart");

        if HumanoidRootPart then
            HumanoidRootPart.Anchored = true;
        end;

        task.spawn(function() -- Line: 366
            -- upvalues: Horse (copy), TweenService (ref)
            local TweenInfo_new_ret = TweenInfo.new(0.35);

            for _, descendant in Horse:GetDescendants() do
                if (descendant:IsA("BasePart") or (descendant:IsA("Decal") or descendant:IsA("Texture"))) and descendant.Transparency < 1 then
                    TweenService:Create(descendant, TweenInfo_new_ret, {
                        Transparency = 1
                    }):Play();
                end;
            end;

            task.wait(0.35);
            Horse:Destroy();
        end);
    end;
end;

local function mount(u73: userdata, u74: userdata, u75: table) -- Line: 405
    -- upvalues: HorseModel (copy), groundParams (copy), placeHorse (copy), startRideAnimation (copy), gameSettings (copy), Utility (copy), addFreeze (copy), forceCleanup (copy), SignalEvent (copy), ManuelCancel (copy)
    if u75.Horse ~= nil or u75.Sequencing then
        return;
    end;

    if HorseModel == nil then
        return;
    end;

    local HumanoidRootPart = u74:FindFirstChild("HumanoidRootPart");
    local u76 = u74:FindFirstChildOfClass("Humanoid");

    if HumanoidRootPart == nil or u76 == nil then
        return;
    end;

    local u77 = HorseModel:Clone();
    local HumanoidRootPart2 = u77:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart2 == nil then
        u77:Destroy();

        return;
    end;

    local LookVector = HumanoidRootPart.CFrame.LookVector;
    local Vector3_new_ret = Vector3.new(LookVector.X, 0, LookVector.Z);
    HumanoidRootPart.CFrame = CFrame.lookAt(HumanoidRootPart.Position, HumanoidRootPart.Position + (Vector3_new_ret.Magnitude < 0.0001 and Vector3.new(0, 0, -1) or Vector3_new_ret).Unit);
    local v78 = groundParams(u74);
    local v79 = workspace:Raycast(HumanoidRootPart.Position + Vector3.new(0, 5, 0), Vector3.new(0, -60, 0), v78);
    local LookVector2 = HumanoidRootPart.CFrame.LookVector;
    local Vector3_new_ret2 = Vector3.new(LookVector2.X, 0, LookVector2.Z);
    local v80 = Vector3_new_ret2.Magnitude < 0.001 and Vector3.new(-0, -0, -1) or Vector3_new_ret2;
    local Position = HumanoidRootPart.Position;

    if v79 then
        local X = Position.X;
        local math_max_ret = math.max(v79.Position.Y + 3, Position.Y);
        Position = Vector3.new(X, math_max_ret, Position.Z);
    end;

    HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
    HumanoidRootPart.CFrame = CFrame.lookAt(Position, Position + v80.Unit);
    u77.Parent = u74;
    placeHorse(u77, HumanoidRootPart2, HumanoidRootPart, v78);
    HumanoidRootPart2.Anchored = true;
    u75.StopRideAnim = startRideAnimation(u73, u74, u77);
    local Weld = Instance.new("Weld");
    Weld.Part0 = HumanoidRootPart2;
    Weld.Part1 = HumanoidRootPart;
    Weld.C0 = gameSettings.horseRidingPlayerOffset;
    Weld.Parent = HumanoidRootPart2;
    HumanoidRootPart.CFrame = HumanoidRootPart2.CFrame * Weld.C0;
    local valuesfolder = Utility.getvaluesfolder(u74);
    u75.Horse = u77;
    u75.HorseRoot = HumanoidRootPart2;
    u75.Weld = Weld;
    u75.Sequencing = true;
    local v81 = (u77:GetAttribute("RestHeight") or 0) + gameSettings.horseRidingPlayerOffset.Position.Y - HumanoidRootPart.Size.Y / 2;
    local math_max_ret = math.max(v81, 1.35);

    if valuesfolder then
        addFreeze(u75, valuesfolder, u74, math_max_ret);
    end;

    local function bail() -- Line: 491
        -- upvalues: forceCleanup (ref), u73 (copy), u74 (copy), u75 (copy), u76 (copy), SignalEvent (ref)
        forceCleanup(u73, u74, u75, true);

        if u76.Health <= 0 then
            return;
        end;

        SignalEvent.ToClient(u73, "ForceEquip", 0);
    end;

    local v82, v83 = ManuelCancel.new(u73, -1);
    u75.CancelDestroy = v83;

    if v82 then
        v82:Connect(bail);
    end;

    u75.SwimWatch = u74:GetAttributeChangedSignal("SwimState"):Connect(function() -- Line: 508
        -- upvalues: u74 (copy), forceCleanup (ref), u73 (copy), u75 (copy), u76 (copy), SignalEvent (ref)
        if (u74:GetAttribute("SwimState") or 0) > 0 then
            forceCleanup(u73, u74, u75, true);

            if u76.Health <= 0 then
                return;
            end;

            SignalEvent.ToClient(u73, "ForceEquip", 0);
        end;
    end);
    task.spawn(function() -- Line: 512
        -- upvalues: u75 (copy), u76 (copy), u77 (copy), HumanoidRootPart2 (copy), HumanoidRootPart (copy), u73 (copy), valuesfolder (copy), Utility (ref)
        local v84 = u76;
        local PlayerGetOn = script:FindFirstChild("PlayerGetOn");
        local v85;

        if v84 == nil or PlayerGetOn == nil then
            v85 = nil;
        else
            local v86 = v84:FindFirstChildOfClass("Animator");

            if v86 == nil then
                v86 = Instance.new("Animator");
                v86.Parent = v84;
            end;

            v85 = v86:LoadAnimation(PlayerGetOn);
            v85:Play();
        end;

        u75.GetOnTrack = v85;
        task.wait(1);

        if u75.Horse ~= u77 then
            return;
        end;

        HumanoidRootPart2.Anchored = false;
        HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
        task.spawn(function() -- Line: 527
            -- upvalues: u75 (ref), u77 (ref), HumanoidRootPart2 (ref), u73 (ref)
            while u75.Horse == u77 and u77.Parent ~= nil do
                if HumanoidRootPart2:CanSetNetworkOwnership() then
                    HumanoidRootPart2:SetNetworkOwner(u73);

                    return;
                end;

                task.wait(0.1);
            end;
        end);

        if valuesfolder then
            u75.RidingHorse = Utility.AddValue(valuesfolder, "RidingHorse", nil, "ObjectValue", u77);
        end;

        u75.Sequencing = false;
    end);
end;

local function dismount(u87: userdata, u88: userdata, p89: table) -- Line: 546
    -- upvalues: restorePlayerNetwork (copy), TweenService (copy)
    if p89.Horse == nil then
        return;
    end;

    local Horse = p89.Horse;
    local HorseRoot = p89.HorseRoot;
    local Weld = p89.Weld;
    local RidingHorse = p89.RidingHorse;
    local Freeze = p89.Freeze;
    local GetOnTrack = p89.GetOnTrack;
    local StopRideAnim = p89.StopRideAnim;

    if p89.CancelDestroy then
        p89.CancelDestroy();
        p89.CancelDestroy = nil;
    end;

    if p89.SwimWatch then
        p89.SwimWatch:Disconnect();
        p89.SwimWatch = nil;
    end;

    p89.StopRideAnim = nil;
    p89.Horse = nil;
    p89.HorseRoot = nil;
    p89.Weld = nil;
    p89.RidingHorse = nil;
    p89.Freeze = nil;
    p89.GetOnTrack = nil;
    p89.Sequencing = false;

    if RidingHorse then
        RidingHorse:Destroy();
    end;

    if GetOnTrack then
        GetOnTrack:Stop();
    end;

    HorseRoot.Anchored = true;

    for _, v in Freeze do
        if v.Name == "hip_height" then
            v:Destroy();
        end;
    end;

    local u90 = u88:FindFirstChildOfClass("Humanoid");
    task.spawn(function() -- Line: 592
        -- upvalues: u88 (copy), restorePlayerNetwork (ref), u87 (copy), Freeze (copy), Horse (copy), TweenService (ref), u90 (copy), StopRideAnim (copy), Weld (copy)
        local HumanoidRootPart = u88:FindFirstChild("HumanoidRootPart");
        local u91 = false;

        local function release() -- Line: 601
            -- upvalues: u91 (ref), HumanoidRootPart (copy), restorePlayerNetwork (ref), u87 (ref), u88 (ref), Freeze (ref), Horse (ref), TweenService (ref)
            if u91 then
                return;
            end;

            u91 = true;

            if HumanoidRootPart ~= nil and HumanoidRootPart.Parent ~= nil then
                HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
                HumanoidRootPart.Anchored = false;
            end;

            pcall(restorePlayerNetwork, u87, u88);

            for _, v in Freeze do
                if v ~= nil then
                    v:Destroy();
                end;
            end;

            if u88 ~= nil then
                u88:SetAttribute("OnHorse", nil);
            end;

            local u92 = Horse;
            local HumanoidRootPart2 = u92:FindFirstChild("HumanoidRootPart");

            if HumanoidRootPart2 then
                HumanoidRootPart2.Anchored = true;
            end;

            task.spawn(function() -- Line: 366
                -- upvalues: u92 (copy), TweenService (ref)
                local TweenInfo_new_ret = TweenInfo.new(0.35);

                for _, descendant in u92:GetDescendants() do
                    if (descendant:IsA("BasePart") or (descendant:IsA("Decal") or descendant:IsA("Texture"))) and descendant.Transparency < 1 then
                        TweenService:Create(descendant, TweenInfo_new_ret, {
                            Transparency = 1
                        }):Play();
                    end;
                end;

                task.wait(0.35);
                u92:Destroy();
            end);
        end;

        local success, result = pcall(function() -- Line: 616
            -- upvalues: u90 (ref), StopRideAnim (ref), Weld (ref), HumanoidRootPart (copy), u87 (ref), u88 (ref)
            local v93 = u90;
            local PlayerGetOff = script:FindFirstChild("PlayerGetOff");
            local v94;

            if v93 == nil or PlayerGetOff == nil then
                v94 = nil;
            else
                local v95 = v93:FindFirstChildOfClass("Animator");

                if v95 == nil then
                    v95 = Instance.new("Animator");
                    v95.Parent = v93;
                end;

                v94 = v95:LoadAnimation(PlayerGetOff);
                v94:Play();
            end;

            if StopRideAnim then
                StopRideAnim();
            end;

            Weld:Destroy();

            if HumanoidRootPart then
                HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
                HumanoidRootPart.Anchored = true;
            end;

            task.wait(0.5);

            if HumanoidRootPart then
                HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
                HumanoidRootPart.Anchored = false;
            end;

            local v96 = u87;
            local v97 = u88;

            if v97 then
                v97 = v97:FindFirstChild("HumanoidRootPart");
            end;

            if v97 and (v96.Parent ~= nil and v97:CanSetNetworkOwnership()) then
                v97:SetNetworkOwner(v96);
            end;

            task.wait(0.833);

            if v94 then
                v94:Stop();
            end;
        end);

        if not success then
            warn("[Horse] dismount choreography failed, releasing rider anyway:", result);
        end;

        release();
    end);
end;

function v11.check(p98: userdata, p99: userdata, p100: table, p101: string) -- Line: 658
    -- upvalues: Checker (copy), u1 (copy), InCombat (copy)
    if not Checker.check(p98) then
        return false;
    end;

    local v102 = (u1[p98] or 0) - os.clock();

    if math.max(v102, 0) > 0 then
        return false;
    end;

    return not InCombat.biasedCheck(p98);
end;

function v11.Equipped(p103: userdata, p104: userdata, p105: table, p106: string) -- Line: 673
    -- upvalues: mount (copy)
    mount(p103, p104, p105);
end;

function v11.UnEquipped(p107: userdata, p108: userdata, p109: table, p110: string) -- Line: 679
    -- upvalues: u1 (copy), gameSettings (copy), forceCleanup (copy), dismount (copy)
    if p109.Horse == nil then
        return;
    end;

    u1[p107] = os.clock() + gameSettings.horseEquipCooldown;
    local v111;

    if p108 then
        v111 = p108:FindFirstChildOfClass("Humanoid");
    else
        v111 = p108;
    end;

    local v112;

    if v111 == nil or v111.Health <= 0 then
        v112 = false;
    else
        v112 = p108.Parent ~= nil;
    end;

    if p109.Sequencing or not v112 then
        forceCleanup(p107, p108, p109, not v112);

        return;
    end;

    dismount(p107, p108, p109);
end;

function v11.MouseDown(p113: userdata, p114: userdata, p115: table, p116: string) -- Line: 697
end;

function v11.MouseUp(p117: userdata, p118: userdata, p119: table, p120: string) -- Line: 701
end;

return v11;