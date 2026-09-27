-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local vfxUtility = require(ReplicatedStorage.CAM.Client.Modules.Effects.vfxUtility);
local DebrisModule = require(ReplicatedStorage.CAM.DebrisModule);
local Character_info_provider = require(ReplicatedStorage.CAM.Global.Character_info_provider);
local Checker = require(ReplicatedStorage.CAM.Global.Checker);
local MinigameSettings = require(ReplicatedStorage.CAM.Global.MinigameSettings);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local RaycastHelper = require(ReplicatedStorage.CAM.Global.RaycastHelper);
local PlayerStatResolver = require(ReplicatedStorage.CAM.Global.PlayerStatResolver);
local SwimmingBreathUI = require(ReplicatedStorage.CAM.Client.Components.NonePackagedMisc.SwimmingBreathUI);
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);
local ClientEffects = ReplicatedStorage.Communication.CnC.ClientEffects;
local LocalPlayer = Players.LocalPlayer;
local _core_anim = Character_info_provider.get_core_anim(LocalPlayer, "swimIdle");
local _core_anim2 = Character_info_provider.get_core_anim(LocalPlayer, "swimPaddle");
local _core_anim3 = Character_info_provider.get_core_anim(LocalPlayer, "swimDive Down");
local _core_anim4 = Character_info_provider.get_core_anim(LocalPlayer, "swimDrowning");
local Swim = ReplicatedStorage.Assets.Swim;
local SwimEffectIdle = Swim.SwimEffectIdle;
local SurfaceSwim = Swim.SurfaceSwim;
local BodyPartTrail = Swim.BodyPartTrail;
local DrowningEffect = Swim.DrowningEffect;
local BodyPartParticles = Swim.BodyPartParticles;
local Sounds = ReplicatedStorage.Assets.Swim.Sounds;
local Random_new_ret = Random.new();
Checker.Swimming = false;
Checker.ShallowWater = false;
local Parent = script.Parent.Parent;
local Humanoid = Parent:WaitForChild("Humanoid");
local HumanoidRootPart = Parent:WaitForChild("HumanoidRootPart");
local Head = Parent:WaitForChild("Head");
local Holder = Parent:WaitForChild("OverHead"):WaitForChild("Holder");
local valuesfolder = Utility.getvaluesfolder(Parent, true);

if valuesfolder ~= nil then
    for _, child in valuesfolder:GetChildren() do
        if child.Name == "WalkSpeed" and child:GetAttribute("SeabedWalk") then
            child:Destroy();
        end;
    end;
end;

local u1 = { "Stun", "Strict_Stun", "CombatStun", "RagDoll", "Ragdoll", "ragdoll", "ragDoll" };

local function isStunnedOrRagdolled() -- Line: 54
    -- upvalues: valuesfolder (copy), u1 (copy)
    if valuesfolder == nil then
        return false;
    end;

    for _, v in u1 do
        if valuesfolder:FindFirstChild(v) ~= nil then
            return true;
        end;
    end;

    return false;
end;

local function playOneShot(p2: userdata) -- Line: 64
    -- upvalues: HumanoidRootPart (copy), DebrisModule (copy)
    local v3 = p2:Clone();
    v3.Parent = HumanoidRootPart;
    v3:Play();
    DebrisModule:AddItem(v3, v3.TimeLength + 0.25);
end;

local u4 = 0;
local u5 = nil;

local function setSwimState(p6: number) -- Line: 77
    -- upvalues: Parent (copy), u4 (ref), SignalEvent (copy)
    if Parent:GetAttribute("SwimState") ~= p6 then
        Parent:SetAttribute("SwimState", p6);
    end;

    if p6 ~= u4 then
        u4 = p6;
        SignalEvent.ToServer("Swim", "State", p6);
    end;
end;

local u7 = false;

local function setCameraInSwimPart(p8: boolean) -- Line: 87
    -- upvalues: u5 (ref), Parent (copy), u7 (ref), Sounds (copy), HumanoidRootPart (copy), DebrisModule (copy)
    if p8 == u5 then
        return;
    end;

    u5 = p8;
    Parent:SetAttribute("CameraInSwimPart", p8);

    if p8 ~= u7 then
        u7 = p8;

        if p8 == true then
            local v9 = Sounds.PS2DP2waterDIVE:Clone();
            v9.Parent = HumanoidRootPart;
            v9:Play();
            DebrisModule:AddItem(v9, v9.TimeLength + 0.25);

            return;
        end;

        local v10 = Sounds.PS2DP2waterCOMEUP:Clone();
        v10.Parent = HumanoidRootPart;
        v10:Play();
        DebrisModule:AddItem(v10, v10.TimeLength + 0.25);
    end;
end;

if Parent:GetAttribute("SwimState") ~= 0 then
    Parent:SetAttribute("SwimState", 0);
end;

if u4 ~= 0 then
    u4 = 0;
    SignalEvent.ToServer("Swim", "State", 0);
end;

if u5 ~= false then
    u5 = false;
    Parent:SetAttribute("CameraInSwimPart", false);

    if u7 ~= false then
        u7 = false;
        local v11 = Sounds.PS2DP2waterCOMEUP:Clone();
        v11.Parent = HumanoidRootPart;
        v11:Play();
        DebrisModule:AddItem(v11, v11.TimeLength + 0.25);
    end;
end;

local u12 = {};

for _, v in { "LeftHand", "RightHand", "LeftFoot", "RightFoot" } do
    local v13 = Parent:FindFirstChild(v);

    if v13 then
        table.insert(u12, v13);
    end;
end;

local u14 = {
    Humanoid.Animator:LoadAnimation(_core_anim),
    Humanoid.Animator:LoadAnimation(_core_anim2),
    Humanoid.Animator:LoadAnimation(_core_anim3),
    Humanoid.Animator:LoadAnimation(_core_anim4)
};
local workspace_CurrentCamera = workspace.CurrentCamera;

local function maxBreath() -- Line: 143
    -- upvalues: PlayerStatResolver (copy), LocalPlayer (copy)
    local Stat = PlayerStatResolver.GetStat(LocalPlayer, "Breath Duration Factor");
    local v15 = typeof(Stat) ~= "number" and 0 or Stat;

    return math.max(17 * (1 + v15), 1);
end;

local u16 = {
    Breath = 1,
    Drowning = false,
    DiveStart = nil
};
local u17 = nil;
local u18 = nil;
local u19 = nil;
local u20 = nil;
local u21 = nil;
local u22 = nil;
local u23 = nil;

local function updateBreathBar() -- Line: 160
    -- upvalues: u16 (copy), u18 (ref), u19 (ref), u20 (ref), u21 (ref), u22 (ref), u23 (ref), SwimmingBreathUI (copy), Holder (copy)
    if u16.Breath < 1 and not u16.Drowning then
        local Breath = u16.Breath;

        if u18 == nil then
            local v24, v25, v26, v27, v28, v29 = SwimmingBreathUI(Holder, {
                ratio = Breath,
                bubbles = {
                    Breath > 0,
                    Breath > 0.2,
                    Breath > 0.4,
                    Breath > 0.6,
                    Breath > 0.8
                }
            });
            u18 = v24;
            u19 = v25;
            u20 = v26;
            u21 = v27;
            u22 = v28;
            u23 = v29;
        end;

        if u19 ~= nil then
            u19:Set(Breath);
        end;

        if u20 ~= nil then
            u20:Set(1 - Breath);
        end;

        if u21 ~= nil then
            u21:Set(UDim2.fromScale(Breath, 2));
        end;

        if u22 ~= nil then
            u22:Set(u16.Breath < 0.25 and 1 or 0);
        end;

        if u23 ~= nil then
            for i = 1, 5 do
                local v30 = u23[i];
                local v31;

                if v30 == nil then
                    v31 = i;
                else
                    v30:Set((i - 1) / 5 < Breath);
                    v31 = i;
                end;
            end;
        end;
    elseif u18 ~= nil then
        u18();
        u18 = nil;
        u19 = nil;
        u20 = nil;
        u21 = nil;
        u22 = nil;
        u23 = nil;
    end;
end;

local u32 = 0;

local function accumulateDrownDamage(p33: number) -- Line: 208
    -- upvalues: u32 (ref), SignalEvent (copy)
    u32 = u32 + p33;

    if u32 >= 0.5 then
        SignalEvent.ToServer("Swim", "DrownDamage", u32);
        u32 = 0;
    end;
end;

local function tickBreath(p34: number, p35: boolean) -- Line: 215
    -- upvalues: MinigameSettings (copy), u16 (copy), u17 (ref), valuesfolder (copy), u1 (copy), PlayerStatResolver (copy), LocalPlayer (copy), Humanoid (copy), u32 (ref), SignalEvent (copy), updateBreathBar (copy), Parent (copy)
    local v36 = MinigameSettings.Get("NoDrowning") == true;

    if v36 then
        p35 = false;
    end;

    local Drowning = u16.Drowning;
    local v37 = not v36;

    if v37 then
        if u17 == nil or u17.current <= 0 or valuesfolder == nil then
            v37 = false;
        else
            v37 = false;

            for _, v in u1 do
                if valuesfolder:FindFirstChild(v) ~= nil then
                    v37 = true;
                    break;
                end;
            end;
        end;
    end;

    if v37 then
        if u16.DiveStart == nil then
            u16.DiveStart = os.clock();
        end;

        local Breath = u16.Breath;
        local Stat = PlayerStatResolver.GetStat(LocalPlayer, "Breath Duration Factor");
        local v38 = typeof(Stat) ~= "number" and 0 or Stat;
        local v39 = Breath - p34 / math.max(17 * (1 + v38), 1);
        u16.Breath = math.max(0, v39);
        u16.Drowning = true;

        if Humanoid.Health > 0 then
            u32 = u32 + p34;

            if u32 >= 0.5 then
                SignalEvent.ToServer("Swim", "DrownDamage", u32);
                u32 = 0;
            end;
        end;
    elseif p35 then
        if u16.DiveStart == nil then
            u16.DiveStart = os.clock();
        end;

        if os.clock() - u16.DiveStart >= 1.5 then
            local Breath = u16.Breath;
            local Stat = PlayerStatResolver.GetStat(LocalPlayer, "Breath Duration Factor");
            local v40 = typeof(Stat) ~= "number" and 0 or Stat;
            local v41 = Breath - p34 / math.max(17 * (1 + v40), 1);
            u16.Breath = math.max(0, v41);

            if u16.Breath <= 0 then
                u16.Drowning = true;

                if Humanoid.Health > 0 then
                    u32 = u32 + p34;

                    if u32 >= 0.5 then
                        SignalEvent.ToServer("Swim", "DrownDamage", u32);
                        u32 = 0;
                    end;
                end;
            end;
        end;

        if u16.Breath > 0 then
            u16.Drowning = false;
        end;
    else
        u16.DiveStart = nil;
        u16.Drowning = false;

        if u16.Breath < 1 then
            local Breath = u16.Breath;
            local Stat = PlayerStatResolver.GetStat(LocalPlayer, "Breath Duration Factor");
            local v42 = typeof(Stat) ~= "number" and 0 or Stat;
            local v43 = Breath + p34 * 2 / math.max(17 * (1 + v42), 1);
            u16.Breath = math.min(1, v43);
        end;
    end;

    updateBreathBar();

    if not u16.Drowning then
        u32 = 0;
    end;

    if Drowning ~= u16.Drowning then
        Parent:SetAttribute("SwimDrowning", u16.Drowning);
        SignalEvent.ToServer("Swim", "Drowning", u16.Drowning);

        if u17 then
            u17.update();
            u17.updateCamera();
        end;
    end;
end;

local function fireSplash(p44: string, p45) -- Line: 283
    -- upvalues: ClientEffects (copy), SignalEvent (copy)
    ClientEffects:Fire(p44, p45);
    SignalEvent.ToServer("Swim", "Splash", p44, p45);
end;

local function getPartTopY(p46: userdata) -- Line: 288
    local CFrame2 = p46.CFrame;
    local Size = p46.Size;

    return CFrame2.Y + math.abs(CFrame2.RightVector.Y) * Size.X / 2 + math.abs(CFrame2.UpVector.Y) * Size.Y / 2 + math.abs(CFrame2.LookVector.Y) * Size.Z / 2 - 0.25;
end;

local u47 = nil;
local u48 = nil;
local u49 = nil;

local function setEffectPosition(p50: userdata, p51: vector) -- Line: 308
    if p50:IsA("Attachment") then
        p50.WorldPosition = p51;

        return;
    end;

    if p50:IsA("Model") then
        p50:PivotTo(CFrame.new(p51));

        return;
    end;

    if p50:IsA("BasePart") then
        p50.CFrame = CFrame.new(p51);
    end;
end;

local function stopWalkingIdle() -- Line: 318
    -- upvalues: u48 (ref), u47 (ref), vfxUtility (copy), DebrisModule (copy), u49 (ref)
    if u48 then
        u48:Disconnect();
        u48 = nil;
    end;

    if u47 then
        u47.Name = "--";
        vfxUtility.EnableAll(u47, false);
        DebrisModule:AddItem(u47, 1);
        u47 = nil;
    end;

    u49 = nil;
end;

local function startWalkingIdle(p52: userdata) -- Line: 332
    -- upvalues: u47 (ref), u49 (ref), u48 (ref), vfxUtility (copy), DebrisModule (copy), getPartTopY (copy), SwimEffectIdle (copy), HumanoidRootPart (copy), setEffectPosition (copy), RunService (copy)
    if u47 ~= nil and u49 == p52 then
        return;
    end;

    if u48 then
        u48:Disconnect();
        u48 = nil;
    end;

    if u47 then
        u47.Name = "--";
        vfxUtility.EnableAll(u47, false);
        DebrisModule:AddItem(u47, 1);
        u47 = nil;
    end;

    u49 = nil;
    u49 = p52;
    local v53 = p52.Parent and p52.Parent:FindFirstChild("Texture");

    if v53 ~= nil and v53:IsA("BasePart") then
        p52 = v53;
    end;

    local u54 = getPartTopY(p52) + 0.15;
    local u55 = SwimEffectIdle:Clone();
    u55.Name = "WalkingSwimEffectIdle";
    u55.Parent = p52;
    u47 = u55;
    local Position = HumanoidRootPart.Position;
    setEffectPosition(u55, (Vector3.new(Position.X, u54, Position.Z)));
    u48 = RunService.RenderStepped:Connect(function() -- Line: 351
        -- upvalues: u55 (copy), HumanoidRootPart (ref), setEffectPosition (ref), u54 (copy)
        if u55 == nil or u55.Parent == nil then
            return;
        end;

        if HumanoidRootPart == nil or HumanoidRootPart.Parent == nil then
            return;
        end;

        local Position2 = HumanoidRootPart.Position;
        setEffectPosition(u55, (Vector3.new(Position2.X, u54, Position2.Z)));
    end);
end;

local u56 = {};
local u57 = {
    Equipped = nil
};
local u58 = {};
local TweenInfo_new_ret = TweenInfo.new(1);

local function tweenTransparency(p59: userdata, p60: number) -- Line: 365
    -- upvalues: u58 (copy), TweenService (copy), TweenInfo_new_ret (copy)
    local v61 = u58[p59];

    if v61 then
        v61:Cancel();
    end;

    local v62 = TweenService:Create(p59, TweenInfo_new_ret, {
        Transparency = p60
    });
    u58[p59] = v62;
    v62:Play();
end;

local function getTexture(p63: userdata) -- Line: 388
    local Parent2 = p63.Parent;

    if Parent2 == nil then
        return nil;
    end;

    return Parent2:FindFirstChild("Texture");
end;

local function forEachFadeTarget(p64: userdata, p65: function) -- Line: 393
    local Parent2 = p64.Parent;
    local v66;

    if Parent2 == nil then
        v66 = nil;
    else
        v66 = Parent2:FindFirstChild("Texture");
    end;

    if v66 == nil then
        return;
    end;

    p65(v66);

    for _, child in v66:GetChildren() do
        if child:IsA("Texture") or child:IsA("Decal") then
            p65(child);
        end;
    end;
end;

local u67 = false;
local u68 = nil;
local u69 = nil;

local function refreshFade(p70: userdata?) -- Line: 411
    -- upvalues: u69 (ref), u67 (ref), u68 (ref), forEachFadeTarget (copy), tweenTransparency (copy)
    if p70 == nil then
        return;
    end;

    local u71 = u69 == p70 and 0.7 or (u67 and u68 == p70 and 0.3 or 0);
    forEachFadeTarget(p70, function(p72) -- Line: 421
        -- upvalues: tweenTransparency (ref), u71 (ref)
        local Attribute = p72:GetAttribute("OriginalTransparency");

        if typeof(Attribute) ~= "number" then
            Attribute = p72.Transparency;
            p72:SetAttribute("OriginalTransparency", Attribute);
        end;

        tweenTransparency(p72, Attribute + (1 - Attribute) * u71);
    end);
end;

local u73 = 0;
local Attachment = Instance.new("Attachment");
Attachment.Name = "SwimAttachment";
local LinearVelocity = Instance.new("LinearVelocity");
LinearVelocity.MaxForce = 20000;
LinearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector;
LinearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World;
LinearVelocity.VectorVelocity = Vector3.new(0, 0, 0);
LinearVelocity.Attachment0 = Attachment;
LinearVelocity.Parent = Attachment;
LinearVelocity.Enabled = false;
local AlignPosition = Instance.new("AlignPosition");
AlignPosition.Mode = Enum.PositionAlignmentMode.OneAttachment;
AlignPosition.Attachment0 = Attachment;
AlignPosition.ForceLimitMode = Enum.ForceLimitMode.PerAxis;
AlignPosition.MaxAxesForce = Vector3.new(0, 20000, 0);
AlignPosition.Responsiveness = 20;
AlignPosition.Enabled = false;
AlignPosition.Parent = Attachment;
local AlignOrientation = Instance.new("AlignOrientation");
AlignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment;
AlignOrientation.Attachment0 = Attachment;
AlignOrientation.Responsiveness = 20;
AlignOrientation.MaxTorque = 40000;
AlignOrientation.Parent = Attachment;

local function hasFloorBelow() -- Line: 467
    -- upvalues: HumanoidRootPart (copy), RaycastHelper (copy)
    return workspace:Raycast(HumanoidRootPart.Position, Vector3.new(0, -3.5, 0), RaycastHelper.Crater) ~= nil;
end;

local function isCameraInsidePart(p74: userdata) -- Line: 471
    -- upvalues: workspace_CurrentCamera (copy)
    if not (p74 and p74.Parent) then
        return false;
    end;

    local v75 = p74.CFrame:PointToObjectSpace(workspace_CurrentCamera.CFrame.Position);
    local v76 = p74.Size / 2;
    local v77;

    if math.abs(v75.X) <= v76.X and math.abs(v75.Y) <= v76.Y then
        v77 = math.abs(v75.Z) <= v76.Z;
    else
        v77 = false;
    end;

    return v77;
end;

local u78 = false;
local u79 = nil;
local u80 = nil;
local u81 = nil;
local TweenInfo_new_ret2 = TweenInfo.new(0.3);
local Color3_new_ret = Color3.new(0.4, 0.635294, 0.854902);
local Color3_new_ret2 = Color3.new(1, 0.2, 0.2);
local u82 = nil;
local TweenInfo_new_ret3 = TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true);
local u83 = false;

local function applyCCEState() -- Line: 491
    -- upvalues: u79 (ref), u16 (copy), u82 (ref), Color3_new_ret (copy), TweenService (copy), TweenInfo_new_ret3 (copy), Color3_new_ret2 (copy), TweenInfo_new_ret2 (copy)
    if not u79 then
        return;
    end;

    if not u16.Drowning then
        if u82 then
            u82:Cancel();
            u82 = nil;
        end;

        TweenService:Create(u79, TweenInfo_new_ret2, {
            TintColor = Color3_new_ret
        }):Play();

        return;
    end;

    if u82 then
        u82:Cancel();
    end;

    u79.TintColor = Color3_new_ret;
    u82 = TweenService:Create(u79, TweenInfo_new_ret3, {
        TintColor = Color3_new_ret2
    });
    u82:Play();
end;

local swimcorrection = workspace_CurrentCamera:FindFirstChild("swimcorrection");

if swimcorrection then
    swimcorrection:Destroy();
end;

local swimblur = workspace_CurrentCamera:FindFirstChild("swimblur");

if swimblur then
    swimblur:Destroy();
end;

local swimdepth = workspace_CurrentCamera:FindFirstChild("swimdepth");

if swimdepth then
    swimdepth:Destroy();
end;

local function addBodyPartTrails() -- Line: 525
    -- upvalues: u12 (copy), BodyPartTrail (copy)
    for _, v in u12 do
        local v84 = BodyPartTrail:Clone();
        v84.Parent = v;
        v84.Name = "BodyPartTrialForSwimming";
    end;
end;

local function removeBodyPartTrails() -- Line: 533
    -- upvalues: u12 (copy)
    for _, v in u12 do
        for _, child in ipairs(v:GetChildren()) do
            if child.Name == "BodyPartTrialForSwimming" then
                child.Name = "--";
                child.Trail.Enabled = false;
                task.delay(1, child.Destroy, child);
            end;
        end;
    end;
end;

local function addBodyPartParticles() -- Line: 545
    -- upvalues: u12 (copy), BodyPartParticles (copy)
    for _, v in u12 do
        local v85 = v;

        for _, child in BodyPartParticles:GetChildren() do
            local v86 = child:Clone();
            v86.Parent = v85;
            v86.Name = "BodyPartTrailParticlesForSwim";
        end;
    end;
end;

local function removeBodyPartParticles() -- Line: 555
    -- upvalues: u12 (copy)
    for _, v in u12 do
        for _, child in ipairs(v:GetChildren()) do
            if child.Name == "BodyPartTrailParticlesForSwim" then
                child.Enabled = false;
                child.Name = "--";
                task.delay(1, child.Destroy, child);
            end;
        end;
    end;
end;

local function hasTrails(p87: number) -- Line: 567
    return (p87 == 2 or p87 == 3) and true or p87 == 4;
end;

local function hasParticles(p88: number) -- Line: 571
    return p88 == 3 and true or p88 == 4;
end;

local TweenInfo_new_ret4 = TweenInfo.new(0.45);

local function clearDrownEffects() -- Line: 582
    -- upvalues: Head (copy), TweenService (copy), TweenInfo_new_ret4 (copy), vfxUtility (copy), DebrisModule (copy)
    for _, child in Head:GetChildren() do
        if child.Name == "SwimDrownEffect" then
            child.Name = "--";
            local DP2PS2waterDROWNloop = child:FindFirstChild("DP2PS2waterDROWNloop");

            if DP2PS2waterDROWNloop ~= nil and DP2PS2waterDROWNloop:IsA("Sound") then
                TweenService:Create(DP2PS2waterDROWNloop, TweenInfo_new_ret4, {
                    Volume = 0
                }):Play();
            end;

            vfxUtility.EnableAll(child, false);
            DebrisModule:AddItem(child, 1);
        end;
    end;
end;

local u104 = {
    {
        Add = function() -- Line: 597, Name: Add
            -- upvalues: SwimEffectIdle (copy), HumanoidRootPart (copy)
            local v89 = SwimEffectIdle:Clone();
            v89.Parent = HumanoidRootPart;
            v89.Name = "SwimEffectIdle";
        end,

        Remove = function() -- Line: 602, Name: Remove
            -- upvalues: HumanoidRootPart (copy), vfxUtility (copy), DebrisModule (copy)
            local SwimEffectIdle2 = HumanoidRootPart:FindFirstChild("SwimEffectIdle");

            if SwimEffectIdle2 ~= nil then
                SwimEffectIdle2.Name = "--";
                vfxUtility.EnableAll(SwimEffectIdle2, false);
                DebrisModule:AddItem(SwimEffectIdle2, 1);
            end;
        end
    },
    {
        Add = function(p90) -- Line: 612, Name: Add
            -- upvalues: SurfaceSwim (copy), HumanoidRootPart (copy), Sounds (copy), TweenService (copy), TweenInfo_new_ret4 (copy), u12 (copy), BodyPartTrail (copy)
            local v91 = SurfaceSwim:Clone();
            v91.Parent = HumanoidRootPart;
            v91.Name = "SwimEffectSurfaceSwim";
            local v92 = Sounds.PS2swimloopTRUE:Clone();
            v92.Parent = v91;
            v92:Play();
            local Volume = v92.Volume;
            v92.Volume = 0;
            TweenService:Create(v92, TweenInfo_new_ret4, {
                Volume = Volume
            }):Play();

            if p90 ~= 2 and p90 ~= 3 and p90 ~= 4 then
                for _, v in u12 do
                    local v93 = BodyPartTrail:Clone();
                    v93.Parent = v;
                    v93.Name = "BodyPartTrialForSwimming";
                end;
            end;
        end,

        Remove = function(p94) -- Line: 626, Name: Remove
            -- upvalues: HumanoidRootPart (copy), TweenService (copy), TweenInfo_new_ret4 (copy), vfxUtility (copy), DebrisModule (copy), removeBodyPartTrails (copy)
            local SwimEffectSurfaceSwim = HumanoidRootPart:FindFirstChild("SwimEffectSurfaceSwim");

            if SwimEffectSurfaceSwim ~= nil then
                TweenService:Create(SwimEffectSurfaceSwim.PS2swimloopTRUE, TweenInfo_new_ret4, {
                    Volume = 0
                }):Play();
                SwimEffectSurfaceSwim.Name = "--";
                vfxUtility.EnableAll(SwimEffectSurfaceSwim, false);
                DebrisModule:AddItem(SwimEffectSurfaceSwim, 1);
            end;

            if p94 ~= 2 and p94 ~= 3 and p94 ~= 4 then
                removeBodyPartTrails();
            end;
        end
    },
    {
        Add = function(p95) -- Line: 640, Name: Add
            -- upvalues: u12 (copy), BodyPartTrail (copy), addBodyPartParticles (copy)
            if p95 ~= 2 and p95 ~= 3 and p95 ~= 4 then
                for _, v in u12 do
                    local v96 = BodyPartTrail:Clone();
                    v96.Parent = v;
                    v96.Name = "BodyPartTrialForSwimming";
                end;
            end;

            if p95 ~= 3 and p95 ~= 4 then
                addBodyPartParticles();
            end;
        end,

        Remove = function(p97) -- Line: 648, Name: Remove
            -- upvalues: removeBodyPartTrails (copy), removeBodyPartParticles (copy)
            if p97 ~= 2 and p97 ~= 3 and p97 ~= 4 then
                removeBodyPartTrails();
            end;

            if p97 ~= 3 and p97 ~= 4 then
                removeBodyPartParticles();
            end;
        end
    },
    {
        Add = function(p98) -- Line: 658, Name: Add
            -- upvalues: u12 (copy), BodyPartTrail (copy), addBodyPartParticles (copy), Head (copy), DrowningEffect (copy), Sounds (copy), HumanoidRootPart (copy), DebrisModule (copy), TweenService (copy), TweenInfo_new_ret4 (copy)
            if p98 ~= 2 and p98 ~= 3 and p98 ~= 4 then
                for _, v in u12 do
                    local v99 = BodyPartTrail:Clone();
                    v99.Parent = v;
                    v99.Name = "BodyPartTrialForSwimming";
                end;
            end;

            if p98 ~= 3 and p98 ~= 4 then
                addBodyPartParticles();
            end;

            if Head:FindFirstChild("SwimDrownEffect") ~= nil then
                return;
            end;

            local v100 = DrowningEffect:Clone();
            v100.Name = "SwimDrownEffect";
            v100.Parent = Head;
            local v101 = Sounds.PS2waterDROWNstart:Clone();
            v101.Parent = HumanoidRootPart;
            v101:Play();
            DebrisModule:AddItem(v101, v101.TimeLength + 0.25);
            local v102 = Sounds.DP2PS2waterDROWNloop:Clone();
            v102.Parent = v100;
            v102.Looped = true;
            local Volume = v102.Volume;
            v102.Volume = 0;
            v102:Play();
            TweenService:Create(v102, TweenInfo_new_ret4, {
                Volume = Volume
            }):Play();
        end,

        Remove = function(p103) -- Line: 680, Name: Remove
            -- upvalues: removeBodyPartTrails (copy), removeBodyPartParticles (copy), clearDrownEffects (copy)
            if p103 ~= 2 and p103 ~= 3 and p103 ~= 4 then
                removeBodyPartTrails();
            end;

            if p103 ~= 3 and p103 ~= 4 then
                removeBodyPartParticles();
            end;

            clearDrownEffects();
        end
    }
};

local function onDiveStateChange(p105: number, p106: number) -- Line: 692
    -- upvalues: Sounds (copy), HumanoidRootPart (copy), DebrisModule (copy)
    local v107 = Sounds.PS2DP2waterMOVE:Clone();
    v107.Parent = HumanoidRootPart;
    v107:Play();
    DebrisModule:AddItem(v107, v107.TimeLength + 0.25);
end;

local function onDiveIdle(p108: number) -- Line: 699
    -- upvalues: Sounds (copy), HumanoidRootPart (copy), DebrisModule (copy)
    local v109 = Sounds.PS2DP2waterSTOPMOVING:Clone();
    v109.Parent = HumanoidRootPart;
    v109:Play();
    DebrisModule:AddItem(v109, v109.TimeLength + 0.25);
end;

u17 = {
    current = 0,
    prevCurrent = 0,
    jumping = false,
    animState = 0,
    effectState = 0,

    update = function() -- Line: 710, Name: update
        -- upvalues: u17 (ref), u16 (copy), u104 (copy), u14 (copy), Sounds (copy), HumanoidRootPart (copy), DebrisModule (copy)
        local v110 = 0;
        local v111;

        if u17.current > 0 then
            if u16.Drowning then
                v110 = 4;
                v111 = 4;
            else
                v111 = (u17.current == 1 or u17.current == 3) and 1 or (u17.current == 2 and 2 or 3);

                if u17.current == 3 or u17.current == 4 then
                    v110 = 3;
                elseif u17.current <= 2 then
                    v110 = u17.current;
                end;
            end;
        else
            v111 = 0;
        end;

        if v110 ~= u17.effectState then
            local effectState = u17.effectState;
            local v112 = u104[effectState];
            local v113 = u104[v110];
            u17.effectState = v110;

            if v112 then
                v112.Remove(v110);
            end;

            if v113 then
                v113.Add(effectState);
            end;
        end;

        if v111 ~= u17.animState then
            if u14[u17.animState] then
                u14[u17.animState]:Stop();
            end;

            u17.animState = v111;

            if u14[v111] then
                u14[v111]:Play();
            end;
        end;

        local prevCurrent = u17.prevCurrent;
        local current = u17.current;

        if prevCurrent ~= current then
            local v114 = prevCurrent == 3 and true or prevCurrent == 4;
            local v115 = current == 3 and true or current == 4;

            if not u16.Drowning then
                if prevCurrent == 4 and current == 3 then
                    local v116 = Sounds.PS2DP2waterSTOPMOVING:Clone();
                    v116.Parent = HumanoidRootPart;
                    v116:Play();
                    DebrisModule:AddItem(v116, v116.TimeLength + 0.25);
                elseif v115 and not v114 or prevCurrent == 3 and current == 4 then
                    local v117 = Sounds.PS2DP2waterMOVE:Clone();
                    v117.Parent = HumanoidRootPart;
                    v117:Play();
                    DebrisModule:AddItem(v117, v117.TimeLength + 0.25);
                end;
            end;

            u17.prevCurrent = current;
        end;
    end,

    updateCamera = function() -- Line: 777, Name: updateCamera
        -- upvalues: u69 (ref), isCameraInsidePart (copy), u56 (copy), u67 (ref), u68 (ref), forEachFadeTarget (copy), tweenTransparency (copy), u5 (ref), Parent (copy), u7 (ref), Sounds (copy), HumanoidRootPart (copy), DebrisModule (copy), u16 (copy), u78 (ref), u79 (ref), workspace_CurrentCamera (copy), u80 (ref), u81 (ref), TweenService (copy), TweenInfo_new_ret2 (copy), applyCCEState (copy), u83 (ref), u82 (ref)
        local v118 = u69;

        if not (u69 and isCameraInsidePart(u69)) then
            u69 = nil;

            for i in pairs(u56) do
                if isCameraInsidePart(i) then
                    u69 = i;
                    break;
                end;
            end;
        end;

        if v118 ~= u69 then
            if v118 ~= nil then
                local u119 = u69 == v118 and 0.7 or (u67 and u68 == v118 and 0.3 or 0);
                forEachFadeTarget(v118, function(p120) -- Line: 421
                    -- upvalues: tweenTransparency (ref), u119 (ref)
                    local Attribute = p120:GetAttribute("OriginalTransparency");

                    if typeof(Attribute) ~= "number" then
                        Attribute = p120.Transparency;
                        p120:SetAttribute("OriginalTransparency", Attribute);
                    end;

                    tweenTransparency(p120, Attribute + (1 - Attribute) * u119);
                end);
            end;

            local v121 = u69;

            if v121 ~= nil then
                local u122 = u69 == v121 and 0.7 or (u67 and u68 == v121 and 0.3 or 0);
                forEachFadeTarget(v121, function(p123) -- Line: 421
                    -- upvalues: tweenTransparency (ref), u122 (ref)
                    local Attribute = p123:GetAttribute("OriginalTransparency");

                    if typeof(Attribute) ~= "number" then
                        Attribute = p123.Transparency;
                        p123:SetAttribute("OriginalTransparency", Attribute);
                    end;

                    tweenTransparency(p123, Attribute + (1 - Attribute) * u122);
                end);
            end;
        end;

        local v124 = u69 ~= nil;

        if v124 ~= u5 then
            u5 = v124;
            Parent:SetAttribute("CameraInSwimPart", v124);

            if v124 ~= u7 then
                u7 = v124;

                if v124 == true then
                    local v125 = Sounds.PS2DP2waterDIVE:Clone();
                    v125.Parent = HumanoidRootPart;
                    v125:Play();
                    DebrisModule:AddItem(v125, v125.TimeLength + 0.25);
                else
                    local v126 = Sounds.PS2DP2waterCOMEUP:Clone();
                    v126.Parent = HumanoidRootPart;
                    v126:Play();
                    DebrisModule:AddItem(v126, v126.TimeLength + 0.25);
                end;
            end;
        end;

        local v127 = u69 ~= nil and true or u16.Drowning;

        if not v127 or u78 then
            if v127 or not u78 then
                if u78 and u16.Drowning ~= u83 then
                    applyCCEState();
                    u83 = u16.Drowning;
                end;
            else
                u78 = false;

                if u82 then
                    u82:Cancel();
                    u82 = nil;
                end;

                if u80 ~= nil then
                    TweenService:Create(u80, TweenInfo_new_ret2, {
                        Size = 0
                    }):Play();
                    task.delay(TweenInfo_new_ret2.Time, u80.Destroy, u80);
                    u80 = nil;
                end;

                if u81 ~= nil then
                    TweenService:Create(u81, TweenInfo_new_ret2, {
                        FarIntensity = 0,
                        InFocusRadius = 10
                    }):Play();
                    task.delay(TweenInfo_new_ret2.Time, u81.Destroy, u81);
                    u81 = nil;
                end;

                if u79 ~= nil then
                    TweenService:Create(u79, TweenInfo_new_ret2, {
                        TintColor = Color3.new(1, 1, 1)
                    }):Play();
                    task.delay(TweenInfo_new_ret2.Time, u79.Destroy, u79);
                    u79 = nil;

                    return;
                end;
            end;

            return;
        end;

        u78 = true;
        u79 = Instance.new("ColorCorrectionEffect", workspace_CurrentCamera);
        u79.Name = "swimcorrection";
        u80 = Instance.new("BlurEffect", workspace_CurrentCamera);
        u80.Name = "swimblur";
        u80.Size = 0;
        u81 = Instance.new("DepthOfFieldEffect", workspace_CurrentCamera);
        u81.Name = "swimdepth";
        u81.FarIntensity = 0;
        u81.InFocusRadius = 10;
        TweenService:Create(u81, TweenInfo_new_ret2, {
            FarIntensity = 1,
            InFocusRadius = 9.05
        }):Play();
        TweenService:Create(u80, TweenInfo_new_ret2, {
            Size = 8
        }):Play();
        applyCCEState();
        u83 = u16.Drowning;
    end
};
local u128 = 0;
local u129 = false;
local u130 = 0;
local u131 = false;

local function setDiveJumpBlock(p132: boolean) -- Line: 867
    -- upvalues: u131 (ref), Humanoid (copy)
    if p132 == u131 then
        return;
    end;

    u131 = p132;
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, not p132);

    if p132 then
        Humanoid.Jump = false;
    end;
end;

local function surfaceJumpImpulse() -- Line: 880
    -- upvalues: u17 (ref), Attachment (copy), HumanoidRootPart (copy), u57 (copy), getPartTopY (copy), ClientEffects (copy), SignalEvent (copy)
    if u17.jumping then
        return;
    end;

    u17.jumping = true;
    Attachment.Parent = HumanoidRootPart;
    local Equipped = u57.Equipped;

    if typeof(Equipped) == "Instance" then
        local Position = HumanoidRootPart.Position;
        local CFrame_new_ret = CFrame.new(Position.X, getPartTopY(Equipped), Position.Z);
        ClientEffects:Fire("SplashLeave", CFrame_new_ret);
        SignalEvent.ToServer("Swim", "Splash", "SplashLeave", CFrame_new_ret);
    end;

    local Attachment2 = Instance.new("Attachment", HumanoidRootPart);
    local LinearVelocity2 = Instance.new("LinearVelocity");
    LinearVelocity2.MaxForce = 20000;
    LinearVelocity2.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector;
    LinearVelocity2.RelativeTo = Enum.ActuatorRelativeTo.World;
    LinearVelocity2.VectorVelocity = Vector3.new(0, 65, 0);
    LinearVelocity2.Attachment0 = Attachment2;
    LinearVelocity2.Parent = Attachment2;
    LinearVelocity2.Enabled = true;
    task.wait(0.125);
    Attachment2:Destroy();
    task.wait(0.1);
    u17.jumping = false;
end;

Humanoid:GetPropertyChangedSignal("Jump"):Connect(function() -- Line: 907
    -- upvalues: Humanoid (copy), u17 (ref), u129 (ref), u57 (copy), u128 (ref), AlignPosition (copy), surfaceJumpImpulse (copy)
    if not Humanoid.Jump then
        return;
    end;

    if u17.jumping then
        return;
    end;

    if u129 then
        return;
    end;

    local v133;

    if Humanoid.FloorMaterial == nil then
        v133 = false;
    else
        v133 = Humanoid.FloorMaterial ~= Enum.Material.Air;
    end;

    if u57.Equipped ~= nil and (u17.current ~= 3 and u17.current ~= 4 and (v133 or (u17.current == 1 or u17.current == 2))) then
        u128 = os.clock() + 0.45;
    end;

    if u17.current ~= 1 and u17.current ~= 2 then
        return;
    end;

    if v133 then
        AlignPosition.Enabled = false;

        return;
    end;

    surfaceJumpImpulse();
end);

local function getSwimDirection() -- Line: 951
    -- upvalues: Humanoid (copy), workspace_CurrentCamera (copy)
    local MoveDirection = Humanoid.MoveDirection;

    if MoveDirection.Magnitude == 0 then
        return Vector3.new(0, 0, 0);
    end;

    local LookVector = workspace_CurrentCamera.CFrame.LookVector;
    local Vector3_new_ret = Vector3.new(LookVector.X, 0, LookVector.Z);

    if Vector3_new_ret.Magnitude > 0 then
        Vector3_new_ret = Vector3_new_ret.Unit;
    end;

    local v134 = MoveDirection:Dot(Vector3_new_ret);
    local v135 = LookVector * v134 + (MoveDirection - Vector3_new_ret * v134);

    return v135.Magnitude > 0 and v135.Unit or Vector3.new(0, 0, 0);
end;

local u136 = -11;
local u137 = false;

local function rootWithinPart(p138: userdata) -- Line: 977
    -- upvalues: HumanoidRootPart (copy)
    local v139 = p138.CFrame:PointToObjectSpace(HumanoidRootPart.Position);
    local v140 = p138.Size / 2;
    local v141;

    if math.abs(v139.X) <= v140.X + 5 and math.abs(v139.Y) <= v140.Y + 5 then
        v141 = math.abs(v139.Z) <= v140.Z + 5;
    else
        v141 = false;
    end;

    return v141;
end;

function updatePart()
    -- upvalues: u57 (copy), u136 (ref), Random_new_ret (copy), u73 (ref), LinearVelocity (copy), AlignPosition (copy), AlignOrientation (copy), u17 (ref), u128 (ref), u129 (ref), u131 (ref), Humanoid (copy), Checker (copy), Parent (copy), u4 (ref), SignalEvent (copy), Attachment (copy), clearDrownEffects (copy), u48 (ref), u47 (ref), vfxUtility (copy), DebrisModule (copy), u49 (ref), u68 (ref), u69 (ref), u67 (ref), forEachFadeTarget (copy), tweenTransparency (copy), tickBreath (copy), getPartTopY (copy), u137 (ref), HumanoidRootPart (copy), rootWithinPart (copy), workspace_CurrentCamera (copy), getSwimDirection (copy), RaycastHelper (copy), valuesfolder (copy), u1 (copy), u130 (ref), surfaceJumpImpulse (copy), u16 (copy), startWalkingIdle (copy), PlayerStatResolver (copy), LocalPlayer (copy)
    if u57.Equipped == nil then
        for i in pairs(u57) do
            if i ~= "Equipped" then
                u57.Equipped = i;
                break;
            end;
        end;
    end;

    if u136 ~= u57.Equipped then
        local v142 = u136;
        local Equipped = u57.Equipped;
        u136 = Equipped;
        local v143 = Random_new_ret:NextNumber();
        u73 = v143;
        LinearVelocity.Enabled = false;
        AlignPosition.Enabled = false;
        AlignOrientation.Enabled = false;
        LinearVelocity.VectorVelocity = Vector3.new(0, 0, 0);
        u17.jumping = false;
        u128 = 0;
        u17.current = 0;
        u129 = false;

        if u131 ~= false then
            u131 = false;
            Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true);
        end;

        Checker.Swimming = false;
        Checker.ShallowWater = false;

        if Parent:GetAttribute("SwimState") ~= 0 then
            Parent:SetAttribute("SwimState", 0);
        end;

        if u4 ~= 0 then
            u4 = 0;
            SignalEvent.ToServer("Swim", "State", 0);
        end;

        u17.update();
        Attachment.Parent = script;
        clearDrownEffects();

        if u48 then
            u48:Disconnect();
            u48 = nil;
        end;

        if u47 then
            u47.Name = "--";
            vfxUtility.EnableAll(u47, false);
            DebrisModule:AddItem(u47, 1);
            u47 = nil;
        end;

        u49 = nil;
        Parent:SetAttribute("SwimUnderwater", false);

        if typeof(v142) == "Instance" then
            if u68 == v142 then
                u68 = nil;
            end;

            if v142 ~= nil then
                local u144 = u69 == v142 and 0.7 or (u67 and u68 == v142 and 0.3 or 0);
                forEachFadeTarget(v142, function(p145) -- Line: 421
                    -- upvalues: tweenTransparency (ref), u144 (ref)
                    local Attribute = p145:GetAttribute("OriginalTransparency");

                    if typeof(Attribute) ~= "number" then
                        Attribute = p145.Transparency;
                        p145:SetAttribute("OriginalTransparency", Attribute);
                    end;

                    tweenTransparency(p145, Attribute + (1 - Attribute) * u144);
                end);
            end;
        end;

        if Equipped == nil then
            while u73 == v143 do
                local task_wait_ret = task.wait(0.25);
                u17.updateCamera();
                tickBreath(task_wait_ret, false);
            end;

            return;
        end;

        local v146 = getPartTopY(Equipped);
        local v147 = nil;
        local v148 = u137;
        u137 = false;
        local v149 = false;

        while u73 == v143 and (Humanoid ~= nil and (HumanoidRootPart ~= nil and HumanoidRootPart.Parent ~= nil)) do
            if not rootWithinPart(Equipped) then
                u57[Equipped] = nil;

                if u57.Equipped == Equipped then
                    u57.Equipped = nil;
                end;

                task.spawn(updatePart);

                return;
            end;

            local v150 = 0;
            local v151 = Humanoid.MoveDirection.magnitude >= 0.01;
            local v152, v153, v154, v155;

            if u17.jumping then
                v152 = false;
                v153 = false;
                v154 = nil;
                v155 = nil;
            else
                v153 = true;
                local Position = HumanoidRootPart.Position;
                v155 = workspace_CurrentCamera.CFrame;
                local v156 = v155:ToOrientation();
                local v157 = Position.Y - v146;
                v154 = getSwimDirection();
                local Vector3_new_ret = Vector3.new(v155.LookVector.X, 0, v155.LookVector.Z);

                if Vector3_new_ret.Magnitude > 0 then
                    Vector3_new_ret = Vector3_new_ret.Unit;
                end;

                local v158 = Humanoid.MoveDirection:Dot(Vector3_new_ret) > 0;

                if v156 > -0.9 then
                    v158 = false;
                end;

                v152 = v157 <= -1.5;

                if v148 then
                    if v158 then
                        v148 = false;
                    elseif v152 then
                        v149 = true;
                    elseif v149 then
                        v148 = false;
                    end;
                end;

                local v159;

                if Humanoid.FloorMaterial == nil then
                    v159 = false;
                else
                    v159 = Humanoid.FloorMaterial ~= Enum.Material.Air;
                end;

                if v159 and (Humanoid.Jump and not v152) then
                    u128 = os.clock() + 0.45;
                end;

                v150 = v157 > 0 and workspace:Raycast(HumanoidRootPart.Position, Vector3.new(0, -3.5, 0), RaycastHelper.Crater) ~= nil and 2 or (v148 and v152 and 1 or ((v152 or v158) and 3 or (v157 > -1.5 and v157 <= 0.75 and 1 or v150)));

                if not (v150 ~= 1 and v150 ~= 3 or (v159 or u128 == 0)) then
                    if os.clock() < u128 or not v152 and HumanoidRootPart.AssemblyLinearVelocity.Y > 1 then
                        v150 = 0;
                    else
                        u128 = 0;
                    end;
                end;

                if v150 == 1 and not (v159 or (v152 or HumanoidRootPart.AssemblyLinearVelocity.Y <= 8)) then
                    v150 = 0;
                end;
            end;

            if v150 > 0 then
                local v160;

                if valuesfolder == nil then
                    v160 = false;
                else
                    v160 = false;

                    for _, v in u1 do
                        if valuesfolder:FindFirstChild(v) ~= nil then
                            v160 = true;
                            break;
                        end;
                    end;
                end;

                if v160 then
                    v150 = 3;
                end;
            end;

            Parent:SetAttribute("SwimUnderwater", v152);

            if Humanoid.Jump then
                u130 = os.clock();
            end;

            local v161 = os.clock() - u130 <= 0.2;

            if not v161 then
                u129 = false;
            end;

            local v162;

            if v150 == 3 then
                if v152 then
                    v162 = v161;
                else
                    v162 = v152;
                end;
            else
                v162 = false;
            end;

            if v162 then
                u129 = true;
            elseif u129 and (v161 and (not v152 and v153)) then
                u129 = false;

                if u57.Equipped ~= nil and (Humanoid.FloorMaterial == nil or Humanoid.FloorMaterial == Enum.Material.Air) then
                    u128 = os.clock() + 0.45;
                    task.spawn(surfaceJumpImpulse);
                end;
            end;

            local v163;

            if v150 == 1 then
                v163 = v151 and 2 or v150;
            else
                v163 = v150 == 3 and ((v151 or v162) and 4 or 3) or 0;
            end;

            if Checker.Climbing and not u16.Drowning then
                Checker.Swimming = false;
                Checker.ShallowWater = false;

                if Parent:GetAttribute("SwimState") ~= 0 then
                    Parent:SetAttribute("SwimState", 0);
                end;

                if u4 ~= 0 then
                    u4 = 0;
                    SignalEvent.ToServer("Swim", "State", 0);
                end;

                if u131 ~= false then
                    u131 = false;
                    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true);
                end;

                if u17.current ~= 0 then
                    u17.current = 0;
                    u17.update();
                end;

                LinearVelocity.Enabled = false;
                AlignPosition.Enabled = false;
                AlignOrientation.Enabled = false;
                v147 = nil;
            else
                local v164;

                if v150 > 0 then
                    v164 = v150 ~= 2;
                else
                    v164 = false;
                end;

                Checker.Swimming = v164;
                Checker.ShallowWater = v150 == 2;

                if Parent:GetAttribute("SwimState") ~= v150 then
                    Parent:SetAttribute("SwimState", v150);
                end;

                if v150 ~= u4 then
                    u4 = v150;
                    SignalEvent.ToServer("Swim", "State", v150);
                end;

                if v153 then
                    local v165 = v150 == 3 and true or u129;

                    if v165 ~= u131 then
                        u131 = v165;
                        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, not v165);

                        if v165 then
                            Humanoid.Jump = false;
                        end;
                    end;
                end;

                if v163 ~= u17.current then
                    u17.current = v163;
                    u17.update();
                end;

                if v150 ~= v147 then
                    if v150 > 0 then
                        Attachment.Parent = HumanoidRootPart;
                    else
                        Attachment.Parent = script;
                    end;

                    if v150 == 1 then
                        LinearVelocity.Enabled = false;
                        AlignPosition.Position = vector.create(0, v146, 0);
                        AlignPosition.Enabled = true;
                        AlignOrientation.Enabled = false;
                    elseif v150 == 3 then
                        AlignOrientation.Enabled = true;
                        AlignOrientation.CFrame = v155;
                        LinearVelocity.Enabled = true;
                        AlignPosition.Enabled = false;
                    else
                        AlignOrientation.Enabled = false;
                        LinearVelocity.Enabled = false;
                        AlignPosition.Enabled = false;
                    end;

                    if v150 == 2 then
                        startWalkingIdle(Equipped);
                    else
                        if u48 then
                            u48:Disconnect();
                            u48 = nil;
                        end;

                        if u47 then
                            u47.Name = "--";
                            vfxUtility.EnableAll(u47, false);
                            DebrisModule:AddItem(u47, 1);
                            u47 = nil;
                        end;

                        u49 = nil;
                    end;

                    u67 = v150 == 3;
                    local v166;

                    if u67 then
                        v166 = Equipped;
                    else
                        v166 = nil;
                    end;

                    u68 = v166;

                    if Equipped == nil then
                        v147 = v150;
                    else
                        local u167 = u69 == Equipped and 0.7 or (u67 and u68 == Equipped and 0.3 or 0);
                        forEachFadeTarget(Equipped, function(p168) -- Line: 421
                            -- upvalues: tweenTransparency (ref), u167 (ref)
                            local Attribute = p168:GetAttribute("OriginalTransparency");

                            if typeof(Attribute) ~= "number" then
                                Attribute = p168.Transparency;
                                p168:SetAttribute("OriginalTransparency", Attribute);
                            end;

                            tweenTransparency(p168, Attribute + (1 - Attribute) * u167);
                        end);
                        v147 = v150;
                    end;
                end;

                if v150 == 3 then
                    local v169 = u16.Drowning and 4 or 16 * PlayerStatResolver.GetMovementMultiplier(LocalPlayer);

                    if v162 then
                        v151 = false;
                        v154 = Vector3.new(0, 1, 0);
                    end;

                    if v162 then
                        v151 = v162;
                    elseif v151 then
                        v151 = v154.Magnitude > 0;
                    end;

                    if u16.Drowning then
                        AlignOrientation.Enabled = false;
                    else
                        AlignOrientation.Enabled = v151;

                        if v151 and v154.Magnitude > 0 then
                            local v170 = math.abs(v154.Y) > 0.99 and Vector3.new(0, 0, 1) or Vector3.new(0, 1, 0);
                            AlignOrientation.CFrame = CFrame.lookAt(Vector3.new(0, 0, 0), v154, v170);
                        end;
                    end;

                    if v151 and v154.Magnitude > 0 then
                        local v171 = v154 * v169;

                        if v171.Y > 0 then
                            v171 = Vector3.new(v171.X, v171.Y * 0.4, v171.Z);
                        end;

                        LinearVelocity.VectorVelocity = v171;
                    elseif u16.Drowning then
                        local v172;

                        if Humanoid.FloorMaterial == nil then
                            v172 = false;
                        else
                            v172 = Humanoid.FloorMaterial ~= Enum.Material.Air;
                        end;

                        LinearVelocity.VectorVelocity = v172 and Vector3.new(0, 0, 0) or Vector3.new(0, -4, 0);
                    else
                        LinearVelocity.VectorVelocity = Vector3.new(0, 0, 0);
                    end;
                end;
            end;

            u17.updateCamera();
            tickBreath(task.wait(0.05), v152);
        end;
    end;
end;

function Added(u173: userdata)
    -- upvalues: forEachFadeTarget (copy), u56 (copy), Parent (copy), u57 (copy), HumanoidRootPart (copy), getPartTopY (copy), ClientEffects (copy), SignalEvent (copy), u137 (ref)
    Removed(u173);
    forEachFadeTarget(u173, function(p174) -- Line: 1327
        local Attribute = p174:GetAttribute("OriginalTransparency");

        if Attribute == nil then
            p174:SetAttribute("OriginalTransparency", p174.Transparency);

            return;
        end;

        p174.Transparency = Attribute;
    end);
    u56[u173] = {};
    local u175 = {};
    local u176 = nil;
    table.insert(u56[u173], u173.Touched:Connect(function(p177: userdata) -- Line: 1348
        -- upvalues: Parent (ref), u175 (copy), u176 (ref), u57 (ref), u173 (copy), HumanoidRootPart (ref), getPartTopY (ref), ClientEffects (ref), SignalEvent (ref), u137 (ref)
        if p177.Parent == Parent then
            u175[p177] = true;
            u176 = nil;

            if u57[u173] == nil then
                local v178;

                if HumanoidRootPart == nil then
                    v178 = false;
                else
                    v178 = -HumanoidRootPart.AssemblyLinearVelocity.Y >= 30;
                end;

                if v178 then
                    local Position = HumanoidRootPart.Position;
                    local CFrame_new_ret = CFrame.new(Position.X, getPartTopY(u173), Position.Z);
                    ClientEffects:Fire("SplashEnter", CFrame_new_ret);
                    SignalEvent.ToServer("Swim", "Splash", "SplashEnter", CFrame_new_ret);
                end;

                u137 = v178;
                u57[u173] = true;
                updatePart();
            end;
        end;
    end));
    table.insert(u56[u173], u173.TouchEnded:Connect(function(p179: userdata) -- Line: 1366
        -- upvalues: Parent (ref), u175 (copy), u57 (ref), u173 (copy), u176 (ref)
        if p179.Parent == Parent then
            u175[p179] = nil;

            if next(u175) == nil and u57[u173] ~= nil then
                local os_clock_ret = os.clock();
                u176 = os_clock_ret;
                task.delay(0.08, function() -- Line: 1372
                    -- upvalues: u176 (ref), os_clock_ret (copy), u175 (ref), u57 (ref), u173 (ref)
                    if u176 ~= os_clock_ret then
                        return;
                    end;

                    if next(u175) ~= nil then
                        return;
                    end;

                    if u57[u173] == nil then
                        return;
                    end;

                    u176 = nil;
                    u57[u173] = nil;

                    if u57.Equipped == u173 then
                        u57.Equipped = nil;
                        updatePart();
                    end;
                end);
            end;
        end;
    end));
end;

function Removed(p180: userdata)
    -- upvalues: u56 (copy), u57 (copy)
    if u56[p180] then
        if u57.Equipped == p180 then
            u57.Equipped = nil;
            updatePart();
        end;

        if u57[p180] then
            u57[p180] = nil;
        end;

        for _, v in u56[p180] do
            v:Disconnect();
        end;

        u56[p180] = nil;
    end;
end;

for _, v in CollectionService:GetTagged("SwimParts") do
    Added(v);
end;

CollectionService:GetInstanceRemovedSignal("SwimParts"):Connect(Removed);
CollectionService:GetInstanceAddedSignal("SwimParts"):Connect(Added);
updatePart();