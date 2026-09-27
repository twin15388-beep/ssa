-- Decompiled with Potassium's decompiler.

local Debris = game:GetService("Debris");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local Workspace = game:GetService("Workspace");
local v1 = {};
local u2 = {
    Interval = 0.065,
    Lifetime = 0.6,
    StartTransparency = 0.78,
    MaxViewDistance = 180,
    BlurExpansion = 0.96,
    BlurDrift = 0.7,
    RapidoDelay = 1.5,
    SpeedTrailLifetime = 0.22,
    SpeedTrailWidthScale = 0.45,
    DashTransparencyBoost = 0.38,
    OutlineTransparency = 0.72,
    DashCameraFovBoost = 8,
    DashCameraInSpeed = 6,
    DashCameraOutSpeed = 9,
    Color = Color3.fromRGB(10, 10, 15)
};

local function scaleNumberSequence(p3, p4) -- Line: 30
    local v5 = {};

    for _, v in ipairs(p3.Keypoints) do
        table.insert(v5, NumberSequenceKeypoint.new(v.Time, v.Value * p4, v.Envelope * p4));
    end;

    return NumberSequence.new(v5);
end;

local function increaseTransparency(p6, p7) -- Line: 42
    local v8 = {};

    for _, v in ipairs(p6.Keypoints) do
        local NumberSequenceKeypoint_new = NumberSequenceKeypoint.new;
        local Time = v.Time;
        local math_clamp_ret = math.clamp(v.Value + (1 - v.Value) * p7, 0, 1);
        table.insert(v8, NumberSequenceKeypoint_new(Time, math_clamp_ret, v.Envelope * (1 - p7)));
    end;

    return NumberSequence.new(v8);
end;

local u9 = false;
local u10 = setmetatable({}, {
    __mode = "k"
});
local u11 = setmetatable({}, {
    __mode = "k"
});
local u12 = setmetatable({}, {
    __mode = "k"
});
local u13 = setmetatable({}, {
    __mode = "k"
});
local u14 = setmetatable({}, {
    __mode = "k"
});
local u15 = setmetatable({}, {
    __mode = "k"
});
local Corrida = ReplicatedStorage:WaitForChild("Efeitos"):WaitForChild("Corrida");
local VampireFootSmoke = Corrida:WaitForChild("VampireFootSmoke");
local Speed = Corrida:WaitForChild("Speed");
local u16 = Corrida:WaitForChild("Rapido"):WaitForChild("Dash vfx");
local Rapido = ReplicatedStorage:WaitForChild("Efeitos"):WaitForChild("Corrida"):WaitForChild("Rapido");
local u17 = {
    Head = true,
    Torso = true,
    ["Left Arm"] = true,
    ["Right Arm"] = true,
    ["Left Leg"] = true,
    ["Right Leg"] = true,
    UpperTorso = true,
    LowerTorso = true,
    LeftUpperArm = true,
    LeftLowerArm = true,
    LeftHand = true,
    RightUpperArm = true,
    RightLowerArm = true,
    RightHand = true,
    LeftUpperLeg = true,
    LeftLowerLeg = true,
    LeftFoot = true,
    RightUpperLeg = true,
    RightLowerLeg = true,
    RightFoot = true
};

local function prepareGhostPart(u18) -- Line: 87
    -- upvalues: u2 (copy)
    if u18.Name == "HumanoidRootPart" or u18.Transparency >= 0.95 then
        return nil;
    end;

    local success, result = pcall(function() -- Line: 92
        -- upvalues: u18 (copy)
        return u18:Clone();
    end);

    if not (success and result) then
        return nil;
    end;

    for _, child in result:GetChildren() do
        if child:IsA("DataModelMesh") then
            if child:IsA("SpecialMesh") then
                child.TextureId = "";
                child.VertexColor = Vector3.new(0.12, 0.12, 0.16);
            end;
        else
            child:Destroy();
        end;
    end;

    result.Name = "VampireBlurGhost";
    result.Anchored = true;
    result.CanCollide = false;
    result.CanTouch = false;
    result.CanQuery = false;
    result.CastShadow = false;
    result.Massless = true;
    result.Material = Enum.Material.SmoothPlastic;
    result.Color = u2.Color;
    result.Transparency = math.max(u2.StartTransparency, u18.Transparency);

    if result:IsA("MeshPart") then
        result.TextureID = "";
    end;

    return result;
end;

local function createAfterimage(p19, p20) -- Line: 128
    -- upvalues: u17 (copy), prepareGhostPart (copy), u2 (copy), TweenService (copy), Debris (copy)
    local HumanoidRootPart = p19:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local Vector3_new_ret = Vector3.new(HumanoidRootPart.AssemblyLinearVelocity.X, 0, HumanoidRootPart.AssemblyLinearVelocity.Z);

    if Vector3_new_ret.Magnitude < 2 then
        return;
    end;

    local v21 = -Vector3_new_ret.Unit;
    local Model = Instance.new("Model");
    Model.Name = "VampireAfterimage";
    Model.Parent = p20;
    local v22 = 0;

    for _, child in p19:GetChildren() do
        if child:IsA("BasePart") and u17[child.Name] then
            local v23 = prepareGhostPart(child);

            if v23 then
                v23.CFrame = child.CFrame;
                v23.Parent = Model;
                v22 = v22 + 1;
                local v24 = v23.CFrame + v21 * u2.BlurDrift;
                local v25 = v23.Size * u2.BlurExpansion;
                TweenService:Create(v23, TweenInfo.new(u2.Lifetime, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                    Transparency = 1,
                    CFrame = v24,
                    Size = v25
                }):Play();
            end;
        end;
    end;

    if v22 == 0 then
        Model:Destroy();

        return;
    end;

    Debris:AddItem(Model, u2.Lifetime + 0.08);
end;

local function isVisibleFromLocalPlayer(p26) -- Line: 180
    -- upvalues: Players (copy), u2 (copy)
    local LocalPlayer = Players.LocalPlayer;

    if LocalPlayer then
        LocalPlayer = LocalPlayer.Character;
    end;

    if LocalPlayer then
        LocalPlayer = LocalPlayer:FindFirstChild("HumanoidRootPart");
    end;

    local HumanoidRootPart = p26:FindFirstChild("HumanoidRootPart");

    if LocalPlayer and HumanoidRootPart then
        return (LocalPlayer.Position - HumanoidRootPart.Position).Magnitude <= u2.MaxViewDistance;
    end;

    return false;
end;

local function isBroomFlight(p27) -- Line: 193
    local Character = p27.Character;
    local v28;

    if p27.Team == nil or (p27.Team.Name ~= "Witches" or Character == nil) then
        v28 = false;
    else
        v28 = Character:GetAttribute("FlyingBroom") == true;
    end;

    return v28;
end;

local function isBroomMovingFast(p29) -- Line: 201
    local Character = p29.Character;
    local v30;

    if p29.Team == nil or (p29.Team.Name ~= "Witches" or Character == nil) then
        v30 = false;
    else
        v30 = Character:GetAttribute("FlyingBroom") == true;
    end;

    if not v30 then
        return false;
    end;

    local Character2 = p29.Character;
    local v31;

    if Character2 then
        v31 = Character2:FindFirstChild("HumanoidRootPart");
    else
        v31 = Character2;
    end;

    if v31 then
        return Character2:GetAttribute("BroomMoving") == true and true or v31.AssemblyLinearVelocity.Magnitude >= 8;
    end;

    return false;
end;

local function getSprintStates(p32) -- Line: 214
    -- upvalues: Players (copy), u2 (copy)
    local Character = p32.Character;

    if p32:GetAttribute("IsSprinting") ~= true then
        return false, false;
    end;

    local v33;

    if p32.Team == nil then
        v33 = false;
    else
        v33 = p32.Team.Name == "Vampires" and true or p32.Team.Name == "Cannibal Raised";
    end;

    local v34;

    if Character then
        v34 = Character:FindFirstChildOfClass("Humanoid");
    else
        v34 = Character;
    end;

    if not (Character and (v34 and v34.Health > 0)) then
        return false, false;
    end;

    if Character:GetAttribute("ActionLocked") == true or (Character:GetAttribute("HypnosisPossessing") == true or (Character:GetAttribute("Hibernating") == true or Character:GetAttribute("FlyingBroom") == true)) then
        return false, false;
    end;

    local State = v34:GetState();
    local v35 = State == Enum.HumanoidStateType.Running and true or State == Enum.HumanoidStateType.RunningNoPhysics;

    if v35 then
        local LocalPlayer = Players.LocalPlayer;

        if LocalPlayer then
            LocalPlayer = LocalPlayer.Character;
        end;

        if LocalPlayer then
            LocalPlayer = LocalPlayer:FindFirstChild("HumanoidRootPart");
        end;

        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

        if LocalPlayer and HumanoidRootPart then
            v35 = (LocalPlayer.Position - HumanoidRootPart.Position).Magnitude <= u2.MaxViewDistance;
        else
            v35 = false;
        end;
    end;

    return v35, v35 and v33;
end;

local function destroyOutline(p36) -- Line: 245
    -- upvalues: u10 (copy)
    local v37 = u10[p36];

    if not v37 then
        return;
    end;

    if v37.highlight and v37.highlight.Parent then
        v37.highlight:Destroy();
    end;

    u10[p36] = nil;
end;

local function ensureOutline(p38) -- Line: 254
    -- upvalues: u10 (copy), u2 (copy)
    local Character = p38.Character;
    local v39 = u10[p38];

    if v39 and (v39.character == Character and (v39.highlight and v39.highlight.Parent)) then
        return v39;
    end;

    local v40 = u10[p38];

    if v40 then
        if v40.highlight and v40.highlight.Parent then
            v40.highlight:Destroy();
        end;

        u10[p38] = nil;
    end;

    if not Character then
        return nil;
    end;

    local Highlight = Instance.new("Highlight");
    Highlight.Name = "VampireSprintOutline";
    Highlight.Adornee = Character;
    Highlight.FillTransparency = 1;
    Highlight.OutlineColor = Color3.fromRGB(0, 0, 0);
    Highlight.OutlineTransparency = u2.OutlineTransparency;
    Highlight.DepthMode = Enum.HighlightDepthMode.Occluded;
    Highlight.Enabled = false;
    Highlight.Parent = Character;
    local v41 = {
        active = false,
        character = Character,
        highlight = Highlight
    };
    u10[p38] = v41;

    return v41;
end;

local function setOutlineEnabled(p42, p43) -- Line: 285
    -- upvalues: u10 (copy), ensureOutline (copy)
    local v44 = u10[p42];

    if v44 and v44.character ~= p42.Character then
        local v45 = u10[p42];

        if v45 then
            if v45.highlight and v45.highlight.Parent then
                v45.highlight:Destroy();
            end;

            u10[p42] = nil;
            v44 = nil;
        else
            v44 = nil;
        end;
    end;

    if p43 then
        v44 = v44 or ensureOutline(p42);
    end;

    if not v44 then
        return;
    end;

    if v44.active ~= p43 then
        v44.active = p43;

        if v44.highlight and v44.highlight.Parent then
            v44.highlight.Enabled = p43;
        end;
    end;
end;

local function destroySpeed(p46) -- Line: 304
    -- upvalues: u12 (copy)
    local v47 = u12[p46];

    if not v47 then
        return;
    end;

    for _, v in ipairs(v47.parts) do
        if v.speed and v.speed.Parent then
            v.speed:Destroy();
        end;

        if v.b and v.b.Parent then
            v.b:Destroy();
        end;
    end;

    u12[p46] = nil;
end;

local function ensureSpeed(p48) -- Line: 320
    -- upvalues: u12 (copy), destroySpeed (copy), u17 (copy), Speed (copy), u2 (copy), scaleNumberSequence (copy)
    local Character = p48.Character;
    local v49 = u12[p48];

    if v49 and v49.character == Character then
        local v50 = true;

        for _, v in ipairs(v49.parts) do
            if not (v.speed.Parent and v.b.Parent) then
                v50 = false;
                break;
            end;
        end;

        if v50 then
            return v49;
        end;
    end;

    destroySpeed(p48);

    if not Character then
        return nil;
    end;

    local v51 = {
        active = false,
        character = Character,
        parts = {}
    };

    for _, child in ipairs(Character:GetChildren()) do
        if child:IsA("BasePart") and (u17[child.Name] and child.Name ~= "HumanoidRootPart") then
            local v52 = Speed:Clone();
            v52.Name = "VampireSpeed";
            v52.Position = Vector3.new(0, -child.Size.Y * 0.5 + 0.02, 0);
            v52.Parent = child;
            local Attachment = Instance.new("Attachment");
            Attachment.Name = "B";
            Attachment.Position = Vector3.new(0, child.Size.Y * 0.5 - 0.02, 0);
            Attachment.Parent = child;

            for _, child2 in ipairs(v52:GetChildren()) do
                if child2:IsA("Trail") then
                    child2.Attachment0 = v52;
                    child2.Attachment1 = Attachment;
                    child2.Lifetime = math.min(child2.Lifetime, u2.SpeedTrailLifetime);
                    child2.MinLength = math.min(child2.MinLength, 0.1);
                    child2.WidthScale = scaleNumberSequence(child2.WidthScale, u2.SpeedTrailWidthScale);
                    child2.Enabled = false;
                end;
            end;

            table.insert(v51.parts, {
                part = child,
                speed = v52,
                b = Attachment
            });
        end;
    end;

    if #v51.parts == 0 then
        return nil;
    end;

    u12[p48] = v51;

    return v51;
end;

local function setSpeedEnabled(p53, p54) -- Line: 386
    -- upvalues: u12 (copy), destroySpeed (copy), ensureSpeed (copy)
    local v55 = u12[p53];

    if v55 and v55.character ~= p53.Character then
        destroySpeed(p53);
        v55 = nil;
    end;

    if p54 then
        v55 = v55 or ensureSpeed(p53);
    end;

    if not v55 then
        return;
    end;

    if v55.active ~= p54 then
        v55.active = p54;

        for _, v in ipairs(v55.parts) do
            if v.speed and v.speed.Parent then
                for _, child in ipairs(v.speed:GetChildren()) do
                    if child:IsA("Trail") then
                        child.Enabled = p54;
                    end;
                end;
            end;
        end;
    end;
end;

local function destroyFootSmoke(p56) -- Line: 413
    -- upvalues: u11 (copy)
    local v57 = u11[p56];

    if not v57 then
        return;
    end;

    for _, v in ipairs(v57.attachments) do
        if v.Parent then
            v:Destroy();
        end;
    end;

    u11[p56] = nil;
end;

local function ensureFootSmoke(p58) -- Line: 426
    -- upvalues: u11 (copy), destroyFootSmoke (copy), VampireFootSmoke (copy)
    local Character = p58.Character;
    local v59 = u11[p58];

    if v59 and v59.character == Character then
        local v60 = true;

        for _, v in ipairs(v59.attachments) do
            if not v.Parent then
                v60 = false;
                break;
            end;
        end;

        if v60 then
            return v59;
        end;
    end;

    destroyFootSmoke(p58);

    if not Character then
        return nil;
    end;

    local v61 = { Character:FindFirstChild("LeftFoot") or (Character:FindFirstChild("Left Leg") or Character:FindFirstChild("LeftLowerLeg")), Character:FindFirstChild("RightFoot") or (Character:FindFirstChild("Right Leg") or Character:FindFirstChild("RightLowerLeg")) };
    local v62 = {
        character = Character,
        attachments = {},
        emitters = {}
    };

    for i, v in ipairs(v61) do
        if v and v:IsA("BasePart") then
            local VampireSprintSmokeAttachment = v:FindFirstChild("VampireSprintSmokeAttachment");

            if VampireSprintSmokeAttachment then
                VampireSprintSmokeAttachment:Destroy();
            end;

            local Attachment = Instance.new("Attachment");
            Attachment.Name = "VampireSprintSmokeAttachment";
            Attachment.Position = Vector3.new(0, -v.Size.Y * 0.5 + 0.04, 0);
            Attachment.Parent = v;
            local v63 = VampireFootSmoke:Clone();
            v63.Name = i == 1 and "LeftFootSmoke" or "RightFootSmoke";
            v63.Enabled = false;
            v63.Parent = Attachment;
            table.insert(v62.attachments, Attachment);
            table.insert(v62.emitters, v63);
        end;
    end;

    if #v62.emitters == 0 then
        return nil;
    end;

    u11[p58] = v62;

    return v62;
end;

local function setFootSmokeEnabled(p64, p65) -- Line: 490
    -- upvalues: u11 (copy), destroyFootSmoke (copy), ensureFootSmoke (copy)
    local v66 = u11[p64];

    if v66 and v66.character ~= p64.Character then
        destroyFootSmoke(p64);
        v66 = nil;
    end;

    if p65 then
        v66 = v66 or ensureFootSmoke(p64);
    end;

    if not v66 then
        return;
    end;

    if v66.active ~= p65 then
        v66.active = p65;

        for _, v in ipairs(v66.emitters) do
            if v.Parent then
                v.Enabled = p65;
            end;
        end;
    end;
end;

local function destroyRapido(p67) -- Line: 513
    -- upvalues: u13 (copy)
    local v68 = u13[p67];

    if v68 then
        if v68.attachment and v68.attachment.Parent then
            v68.attachment:Destroy();
        end;

        u13[p67] = nil;
    end;
end;

local function destroyDashVfx(p69) -- Line: 523
    -- upvalues: u14 (copy)
    local v70 = u14[p69];

    if v70 then
        if v70.part and v70.part.Parent then
            v70.part:Destroy();
        end;

        u14[p69] = nil;
    end;
end;

local function ensureDashVfx(p71) -- Line: 533
    -- upvalues: u14 (copy), u16 (copy), increaseTransparency (copy), u2 (copy)
    local Character = p71.Character;
    local v72 = u14[p71];

    if v72 and (v72.character == Character and (v72.part and v72.part.Parent)) then
        return v72;
    end;

    local v73 = u14[p71];

    if v73 then
        if v73.part and v73.part.Parent then
            v73.part:Destroy();
        end;

        u14[p71] = nil;
    end;

    if not Character then
        return nil;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return nil;
    end;

    local v74 = u16:Clone();
    local v75 = v74:FindFirstChild("Player ( DASHING )");

    if v75 then
        v75:Destroy();
    end;

    v74.Name = "VampireDashVFX";
    v74.Anchored = false;
    v74.CanCollide = false;
    v74.CanTouch = false;
    v74.CanQuery = false;
    v74.CastShadow = false;
    v74.Massless = true;
    v74.CFrame = HumanoidRootPart.CFrame * CFrame.new(0.5, -1, 0) * CFrame.Angles(-0.17453292519943295, 0, 0);
    v74.Parent = Character;
    local WeldConstraint = Instance.new("WeldConstraint");
    WeldConstraint.Part0 = HumanoidRootPart;
    WeldConstraint.Part1 = v74;
    WeldConstraint.Parent = v74;
    local v76 = {};
    local v77 = {};

    for _, descendant in ipairs(v74:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            descendant.Transparency = increaseTransparency(descendant.Transparency, u2.DashTransparencyBoost);
            descendant.Enabled = false;
            table.insert(v76, descendant);
        elseif descendant:IsA("Beam") then
            descendant.Transparency = increaseTransparency(descendant.Transparency, u2.DashTransparencyBoost);
            descendant.Enabled = false;
            table.insert(v77, descendant);
        end;
    end;

    local v78 = {
        active = false,
        character = Character,
        part = v74,
        emitters = v76,
        beams = v77
    };
    u14[p71] = v78;

    return v78;
end;

local function setDashVfxEnabled(u79, p80) -- Line: 597
    -- upvalues: u14 (copy), ensureDashVfx (copy), RunService (copy)
    local u81 = u14[u79];

    if u81 and u81.character ~= u79.Character then
        local v82 = u14[u79];

        if v82 then
            if v82.part and v82.part.Parent then
                v82.part:Destroy();
            end;

            u14[u79] = nil;
            u81 = nil;
        else
            u81 = nil;
        end;
    end;

    if p80 then
        u81 = u81 or ensureDashVfx(u79);
    end;

    if not u81 then
        return;
    end;

    if u81.active == p80 then
        return;
    end;

    u81.active = p80;

    if p80 then
        local os_clock_ret = os.clock();

        for _, v in ipairs(u81.emitters) do
            if v.Parent then
                v.Enabled = true;

                if v:GetAttribute("VampireDashOriginalTransparency") == nil then
                    v:SetAttribute("VampireDashOriginalTransparency", v.Transparency);
                end;
            end;
        end;

        for _, v in ipairs(u81.beams) do
            if v.Parent then
                v.Enabled = true;
            end;
        end;

        task.spawn(function() -- Line: 623
            -- upvalues: u81 (ref), u79 (copy), os_clock_ret (copy), RunService (ref)
            while u81.active and u81.character == u79.Character do
                local v83 = (os.clock() - os_clock_ret) / 0.28;
                local math_clamp_ret = math.clamp(v83, 0, 1);

                for _, v in ipairs(u81.emitters) do
                    if v.Parent then
                        local Attribute = v:GetAttribute("VampireDashOriginalTransparency");

                        if typeof(Attribute) == "NumberSequence" then
                            local v84 = {};

                            for _, v2 in ipairs(Attribute.Keypoints) do
                                table.insert(v84, NumberSequenceKeypoint.new(v2.Time, 1 + (v2.Value - 1) * math_clamp_ret, v2.Envelope));
                            end;

                            v.Transparency = NumberSequence.new(v84);
                        end;
                    end;
                end;

                if math_clamp_ret >= 1 then
                    break;
                end;

                RunService.RenderStepped:Wait();
            end;

            if u81.active then
                for _, v in ipairs(u81.emitters) do
                    if v.Parent then
                        local Attribute = v:GetAttribute("VampireDashOriginalTransparency");

                        if typeof(Attribute) == "NumberSequence" then
                            v.Transparency = Attribute;
                        end;
                    end;
                end;
            end;
        end);
    else
        for _, v in ipairs(u81.emitters) do
            if v.Parent then
                v.Enabled = false;
            end;
        end;

        for _, v in ipairs(u81.beams) do
            if v.Parent then
                v.Enabled = false;
            end;
        end;
    end;
end;

local function ensureRapido(p85) -- Line: 660
    -- upvalues: u13 (copy), Rapido (copy)
    local Character = p85.Character;
    local v86 = u13[p85];

    if v86 and (v86.character == Character and (v86.attachment and v86.attachment.Parent)) then
        return v86;
    end;

    local v87 = u13[p85];

    if v87 then
        if v87.attachment and v87.attachment.Parent then
            v87.attachment:Destroy();
        end;

        u13[p85] = nil;
    end;

    if not Character then
        return nil;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return nil;
    end;

    local Attachment = Instance.new("Attachment");
    Attachment.Name = "RapidoEffectAttachment";
    Attachment.Parent = HumanoidRootPart;
    local v88 = {};

    for _, descendant in Rapido:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            local v89 = descendant:Clone();
            v89.Enabled = false;
            v89.Parent = Attachment;
            table.insert(v88, v89);
        end;
    end;

    local Sound = Instance.new("Sound");
    Sound.Name = "RapidoWindSound";
    Sound.SoundId = "rbxassetid://139095330035399";
    Sound.Looped = true;
    Sound.Volume = 0.8;
    Sound.Parent = Attachment;
    local v90 = {
        active = false,
        character = Character,
        attachment = Attachment,
        emitters = v88,
        sound = Sound
    };
    u13[p85] = v90;

    return v90;
end;

local function setRapidoEnabled(p91, p92) -- Line: 708
    -- upvalues: u13 (copy), ensureRapido (copy)
    local v93 = u13[p91];

    if v93 and v93.character ~= p91.Character then
        local v94 = u13[p91];

        if v94 then
            if v94.attachment and v94.attachment.Parent then
                v94.attachment:Destroy();
            end;

            u13[p91] = nil;
            v93 = nil;
        else
            v93 = nil;
        end;
    end;

    if p92 then
        v93 = v93 or ensureRapido(p91);
    end;

    if not v93 then
        return;
    end;

    if v93.active ~= p92 then
        v93.active = p92;

        for _, v in ipairs(v93.emitters) do
            v.Enabled = p92;
        end;

        if v93.sound then
            if p92 then
                v93.sound:Play();

                return;
            end;

            v93.sound:Stop();
        end;
    end;
end;

function v1.Start() -- Line: 736
    -- upvalues: u9 (ref), Workspace (copy), RunService (copy), u14 (copy), Players (copy), u2 (copy), getSprintStates (copy), u15 (copy), setRapidoEnabled (copy), setDashVfxEnabled (copy), setFootSmokeEnabled (copy), setSpeedEnabled (copy), setOutlineEnabled (copy), destroyFootSmoke (copy), destroySpeed (copy), u10 (copy), u13 (copy)
    if u9 then
        return;
    end;

    u9 = true;
    local _LocalVampireAfterimages = Workspace:FindFirstChild("_LocalVampireAfterimages");

    if _LocalVampireAfterimages then
        _LocalVampireAfterimages:Destroy();
    end;

    local Folder = Instance.new("Folder");
    Folder.Name = "_LocalVampireAfterimages";
    Folder.Parent = Workspace;
    local u95 = 0;
    local u96 = nil;
    local u97 = 0;
    RunService.RenderStepped:Connect(function(p98) -- Line: 755
        -- upvalues: Workspace (ref), u96 (ref), u97 (ref), u14 (ref), Players (ref), u2 (ref), u95 (ref), getSprintStates (ref), u15 (ref), setRapidoEnabled (ref), setDashVfxEnabled (ref), setFootSmokeEnabled (ref), setSpeedEnabled (ref), setOutlineEnabled (ref)
        local CurrentCamera = Workspace.CurrentCamera;

        if CurrentCamera ~= u96 then
            u96 = CurrentCamera;
            u97 = 0;
        end;

        if CurrentCamera then
            local v99 = u14[Players.LocalPlayer];
            local v100 = v99 and v99.active and v99.character == Players.LocalPlayer.Character;
            local v101 = v100 and u2.DashCameraInSpeed or u2.DashCameraOutSpeed;
            local v102 = (v100 and u2.DashCameraFovBoost or 0) - u97;
            local v103 = -math.max(p98, 0) * v101;
            local v104 = u97 + v102 * (1 - math.exp(v103));
            local v105 = CurrentCamera.FieldOfView - u97;
            CurrentCamera.FieldOfView = math.clamp(v105 + v104, 40, 100);
            u97 = CurrentCamera.FieldOfView - v105;
        end;

        u95 = u95 + p98;

        if u95 < u2.Interval then
            return;
        end;

        local v106 = u95;
        u95 = 0;

        for _, v in Players:GetPlayers() do
            local v107, v108 = getSprintStates(v);

            if v107 then
                u15[v] = (u15[v] or 0) + v106;
            else
                u15[v] = 0;
            end;

            local Character = v.Character;
            local v109;

            if v.Team == nil or (v.Team.Name ~= "Witches" or Character == nil) then
                v109 = false;
            else
                v109 = Character:GetAttribute("FlyingBroom") == true;
            end;

            local v110;

            if v109 then
                local Character2 = v.Character;
                local v111;

                if Character2 then
                    v111 = Character2:FindFirstChild("HumanoidRootPart");
                else
                    v111 = Character2;
                end;

                if v111 then
                    v110 = Character2:GetAttribute("BroomMoving") == true and true or v111.AssemblyLinearVelocity.Magnitude >= 8;
                else
                    v110 = false;
                end;
            else
                v110 = false;
            end;

            if not v110 then
                if v108 then
                    v110 = u15[v] >= u2.RapidoDelay;
                else
                    v110 = v108;
                end;
            end;

            setRapidoEnabled(v, v110);
            setDashVfxEnabled(v, v110 and v108);
            setFootSmokeEnabled(v, false);
            setSpeedEnabled(v, v108);
            setOutlineEnabled(v, v107);
        end;
    end);
    Players.PlayerRemoving:Connect(function(p112) -- Line: 806
        -- upvalues: destroyFootSmoke (ref), destroySpeed (ref), u10 (ref), u13 (ref), u14 (ref), u15 (ref)
        destroyFootSmoke(p112);
        destroySpeed(p112);
        local v113 = u10[p112];

        if v113 then
            if v113.highlight and v113.highlight.Parent then
                v113.highlight:Destroy();
            end;

            u10[p112] = nil;
        end;

        local v114 = u13[p112];

        if v114 then
            if v114.attachment and v114.attachment.Parent then
                v114.attachment:Destroy();
            end;

            u13[p112] = nil;
        end;

        local v115 = u14[p112];

        if v115 then
            if v115.part and v115.part.Parent then
                v115.part:Destroy();
            end;

            u14[p112] = nil;
        end;

        u15[p112] = nil;
    end);
end;

return v1;