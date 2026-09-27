-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Checker = require(ReplicatedStorage.CAM.Global.Checker);
local Character_info_provider = require(ReplicatedStorage.CAM.Global.Character_info_provider);
local RaycastHelper = require(ReplicatedStorage.CAM.Global.RaycastHelper);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local Combat_presets = require(ReplicatedStorage.CAM.Global.Combat_presets);
local PlayerStatResolver = require(ReplicatedStorage.CAM.Global.PlayerStatResolver);
local LocalPlayer = Players.LocalPlayer;
local Data = Utility.GetData(LocalPlayer, true);
local Skill_Info = require(ReplicatedStorage.CAM.Global.PlayerProfile.Skill_Info);
local Stats = require(ReplicatedStorage.CAM.Global.SkillService.Stats);
local u1 = false;
local u2 = Skill_Info["Wall Climb"];
local SkillTreeUnlockedList = Data:WaitForChild("SkillTreeUnlockedList");

local function refresh() -- Line: 24
    -- upvalues: u1 (ref), Stats (copy), LocalPlayer (copy)
    u1 = Stats.IsSkillUnlocked(LocalPlayer, "Wall Climb");
end;

local v3 = SkillTreeUnlockedList:FindFirstChild(u2.Category);

if v3 then
    v3.Changed:Connect(refresh);
else
    SkillTreeUnlockedList.ChildAdded:Connect(function(p4) -- Line: 31
        -- upvalues: u2 (copy), refresh (copy), u1 (ref), Stats (copy), LocalPlayer (copy)
        if p4.Name == u2.Category then
            p4.Changed:Connect(refresh);
            u1 = Stats.IsSkillUnlocked(LocalPlayer, "Wall Climb");
        end;
    end);
end;

u1 = Stats.IsSkillUnlocked(LocalPlayer, "Wall Climb");
local Parent = script.Parent.Parent;
local Humanoid = Parent:WaitForChild("Humanoid");
local HumanoidRootPart = Parent:WaitForChild("HumanoidRootPart");
assert(Humanoid ~= nil, "humanoid does not exist");
local u5 = {
    CurrentStamina = 7,
    MaxClimbTime = 7
};
local v6 = 1;
local Animator = Humanoid:WaitForChild("Animator");
local u7 = {};
local u8 = nil;
local u9 = false;
local u10 = nil;
local NumberValue = Instance.new("NumberValue");
local u11 = nil;
local TweenService = game:GetService("TweenService");
local ClimbBar = require(ReplicatedStorage.CAM.Client.Components.NonePackagedMisc.ClimbBar);
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local TweenInfo_new_ret = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
NumberValue.Changed:Connect(function(p12) -- Line: 74
    -- upvalues: u9 (ref), u11 (ref)
    if u9 and u11 then
        u11:AdjustSpeed(p12);
    end;
end);

for _, v in { "climbup", "climbdown", "climbleft", "climbright", "ledge" } do
    local _core_anim = Character_info_provider.get_core_anim(LocalPlayer, v);

    if _core_anim then
        local v13 = Animator:LoadAnimation(_core_anim);
        v13.Looped = v ~= "ledge";
        u7[v] = v13;
    end;
end;

local function playClimbAnim(p14: string) -- Line: 89
    -- upvalues: u10 (ref), u8 (ref), u9 (ref), u7 (copy)
    if u10 then
        u10:Cancel();
        u10 = nil;
    end;

    if u8 == p14 and not u9 then
        return;
    end;

    if u8 and (u8 ~= p14 and u7[u8]) then
        u7[u8]:Stop(0.15);
    end;

    if u7[p14] then
        if u8 == p14 and u9 then
            u7[p14]:AdjustSpeed(1);
        else
            u7[p14]:Play(0.15);
            u7[p14]:AdjustSpeed(1);
        end;
    end;

    u9 = false;
    u8 = p14;
end;

local function pauseClimbAnim() -- Line: 111
    -- upvalues: u8 (ref), u7 (copy), u9 (ref), u10 (ref), u11 (ref), NumberValue (copy), TweenService (copy), TweenInfo_new_ret (copy)
    if u8 and (u7[u8] and not u9) then
        u9 = true;

        if u10 then
            u10:Cancel();
        end;

        local v15 = u7[u8];
        u11 = v15;
        NumberValue.Value = v15.Speed;
        u10 = TweenService:Create(NumberValue, TweenInfo_new_ret, {
            Value = 0
        });
        u10:Play();
    end;
end;

local function stopAllClimbAnims() -- Line: 125
    -- upvalues: u10 (ref), u11 (ref), u7 (copy), u8 (ref), u9 (ref)
    if u10 then
        u10:Cancel();
        u10 = nil;
    end;

    u11 = nil;

    for i, v in u7 do
        if i ~= "ledge" then
            v:Stop(0.2);
        end;
    end;

    u8 = nil;
    u9 = false;
end;

local function resolveClimbAnim(p16: number, p17: number) -- Line: 140
    local math_abs_ret = math.abs(p16);
    local math_abs_ret2 = math.abs(p17);

    return (math_abs_ret >= 0.25 or math_abs_ret2 >= 0.25) and (math_abs_ret >= 0.25 and (p16 > 0 and "climbup" or "climbdown") or (p17 > 0 and "climbright" or "climbleft")) or nil;
end;

local os_clock = os.clock;

local function shouldHidePrompt() -- Line: 157
    -- upvalues: Parent (copy), os_clock (copy), Combat_presets (copy)
    local v18 = Parent:FindFirstChild("SHC") or Parent:FindFirstChild("SHCS");

    return v18 and v18.Value ~= "" and true or (os_clock() - Combat_presets.Last_Punched <= 1.5 and true or Parent:GetAttribute("SwimDrowning") == true);
end;

local Attachment = Instance.new("Attachment");
Attachment.Name = "ClimbProximityAttachment";
local ProximityPrompt = Instance.new("ProximityPrompt");
ProximityPrompt.KeyboardKeyCode = Enum.KeyCode.T;
ProximityPrompt.ObjectText = "Wall";
ProximityPrompt:SetAttribute("ActionImage", "rbxassetid://76503830534647");
ProximityPrompt.RequiresLineOfSight = false;
ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom;
ProximityPrompt.ActionText = "Climb";
ProximityPrompt:SetAttribute("CoolDown", 0.5);
ProximityPrompt:AddTag("Dialogue");
ProximityPrompt.Parent = Attachment;
ProximityPrompt.MaxActivationDistance = 10;
ProximityPrompt.MaxIndicatorDistance = ProximityPrompt.MaxActivationDistance + gameSettings.indicatorAdditionalDistance;
local Attachment2 = Instance.new("Attachment");
Attachment2.Name = "ClimbAttachment";
local LinearVelocity = Instance.new("LinearVelocity");
LinearVelocity.MaxForce = 10000;
LinearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector;
LinearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World;
LinearVelocity.VectorVelocity = Vector3.new(0, 0, 0);
LinearVelocity.Attachment0 = Attachment2;
LinearVelocity.Parent = Attachment2;
local AlignOrientation = Instance.new("AlignOrientation");
AlignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment;
AlignOrientation.Attachment0 = Attachment2;
AlignOrientation.Responsiveness = 35;
AlignOrientation.MaxTorque = 40000;
AlignOrientation.Parent = Attachment2;
local u19 = {};
local u20 = nil;
local u21 = nil;
local u22 = false;
local v23 = false;
local v24 = 0;

local function updateState() -- Line: 220
    -- upvalues: u19 (copy), u20 (ref), AlignOrientation (copy), Attachment2 (copy), HumanoidRootPart (copy)
    local v25 = u19.Climbing and 1 or (u19.Part == nil and 3 or 2);

    if u19.CurrentState ~= v25 then
        u19.CurrentState = v25;

        if v25 == 1 then
            if u20 ~= nil then
                AlignOrientation.CFrame = CFrame.lookAt(Vector3.new(0, 0, 0), -u20.Normal);
            end;

            Attachment2.Parent = HumanoidRootPart;

            return;
        end;

        Attachment2.Parent = script;
    end;
end;

local u26 = nil;
local u27 = nil;
local u28 = nil;

local function isDrowningInWater() -- Line: 235
    -- upvalues: Parent (copy)
    return Parent:GetAttribute("SwimDrowning") == true;
end;

local function isUnderwater() -- Line: 244
    -- upvalues: Parent (copy)
    return Parent:GetAttribute("SwimUnderwater") == true;
end;

local function startClimbing() -- Line: 247
    -- upvalues: u1 (ref), u5 (copy), Checker (copy), LocalPlayer (copy), u19 (copy), Parent (copy), u26 (ref), u27 (ref), u28 (ref), ClimbBar (copy), ProximityPrompt (copy), Attachment (copy), HumanoidRootPart (copy), u7 (copy), u8 (ref), u9 (ref), updateState (copy)
    if not u1 then
        return;
    end;

    if u5.CurrentStamina <= 1 then
        return;
    end;

    local check = Checker.check;
    local v29 = u19.Part and u19.Part:GetAttribute("ClimbBypass");

    if not check(LocalPlayer, "Climb", v29) then
        return;
    end;

    if Parent:GetAttribute("SwimDrowning") == true then
        return;
    end;

    if u26 == nil then
        local v30, v31, v32 = ClimbBar(Parent.HumanoidRootPart.BillboardComponents);
        u26 = v30;
        u27 = v31;
        u28 = v32;
    end;

    u19.Climbing = true;
    Checker.Climbing = true;
    ProximityPrompt.ActionText = "Stop Climbing";
    local WorldPosition = Attachment.WorldPosition;
    Attachment.Parent = HumanoidRootPart;
    Attachment.WorldPosition = WorldPosition;
    ProximityPrompt.Enabled = true;
    u7.climbup:Play(0.15);
    u7.climbup:AdjustSpeed(0);
    u7.climbup.TimePosition = 0;
    u8 = "climbup";
    u9 = true;
    updateState();
end;

local u33 = 0;

local function stopClimbing() -- Line: 271
    -- upvalues: u33 (ref), u19 (copy), Checker (copy), ProximityPrompt (copy), u22 (ref), LinearVelocity (copy), Combat_presets (copy), stopAllClimbAnims (copy), updateState (copy), Attachment (copy)
    local math_random_ret = math.random(1, 99);
    u33 = math_random_ret;
    u19.Climbing = false;
    u19.Part = nil;
    Checker.Climbing = false;
    ProximityPrompt.ActionText = "Climb";
    u22 = false;
    LinearVelocity.VectorVelocity = Vector3.new(0, 0, 0);
    ProximityPrompt.Enabled = false;
    Combat_presets.Last_Climb = os.clock();
    stopAllClimbAnims();
    updateState();
    task.delay(0.5, function() -- Line: 284
        -- upvalues: math_random_ret (copy), u33 (ref), u19 (ref), Attachment (ref)
        if math_random_ret ~= u33 then
            return;
        end;

        if not u19.Climbing and u19.Part == nil then
            Attachment.Parent = nil;
        end;
    end);
end;

local function startCliffing() -- Line: 293
    -- upvalues: u22 (ref), u21 (ref), playClimbAnim (copy), LinearVelocity (copy), stopClimbing (copy)
    if u22 or u21 == nil then
        return;
    end;

    u22 = true;
    playClimbAnim("ledge");
    local v34 = -Vector3.new(u21.X, 0, u21.Z);

    if v34.Magnitude > 0.01 then
        v34 = v34.Unit;
    end;

    LinearVelocity.VectorVelocity = (Vector3.new(0, 1, 0) + v34).Unit * 11.5;
    task.delay(0.35, function() -- Line: 302
        -- upvalues: u22 (ref), stopClimbing (ref)
        if u22 then
            u22 = false;
            stopClimbing();
        end;
    end);
end;

ProximityPrompt.Triggered:Connect(function() -- Line: 310
    -- upvalues: u19 (copy), stopClimbing (copy), startClimbing (copy)
    if u19.Climbing then
        stopClimbing();

        return;
    end;

    startClimbing();
end);
Parent:GetAttributeChangedSignal("SwimDrowning"):Connect(function() -- Line: 320
    -- upvalues: Parent (copy), u19 (copy), stopClimbing (copy), u26 (ref), u27 (ref), u28 (ref)
    if Parent:GetAttribute("SwimDrowning") ~= true then
        return;
    end;

    if u19.Climbing then
        stopClimbing();
    end;

    if u26 ~= nil then
        u26();
        u26 = nil;
        u27 = nil;
        u28 = nil;
    end;
end);
local v35 = 0;

while true do
    local v36, v37;

    while true do
        local u20, v35, v36, u21;
        local v38 = 0;

        while true do
            if v38 == 0 then
                v38 = -1;

                while true do
                    if Parent == nil or Parent.Parent == nil then
                        return;
                    end;

                    if u1 then
                        break;
                    end;

                    v35 = task.wait(0.5);
                end;

                v36 = nil;
                v37 = HumanoidRootPart.CFrame;

                if u19.Climbing then
                    break;
                end;

                if u5.CurrentStamina < u5.MaxClimbTime then
                    u5.CurrentStamina = math.clamp(u5.CurrentStamina + v35 / 2, 0, u5.MaxClimbTime);

                    if u27 ~= nil then
                        u27:Set(1 - u5.CurrentStamina / u5.MaxClimbTime);
                    end;

                    if u28 ~= nil then
                        u28:Set(0);
                    end;

                    if u5.CurrentStamina >= u5.MaxClimbTime and u26 ~= nil then
                        u26();
                        u26 = nil;
                        u27 = nil;
                        u28 = nil;
                    end;
                end;

                u20 = workspace:Raycast(HumanoidRootPart.Position, v37.LookVector * 4, RaycastHelper.Crater);

                if u20 == nil or (u20.Instance == nil or u20.Normal:Dot(Vector3.new(0, 1, 0)) >= 0.5) then
                    if u20 ~= nil and u20.Normal:Dot(Vector3.new(0, 1, 0)) >= 0.5 then
                        u20 = nil;
                    end;
                else
                    v36 = u20.Instance;
                    u21 = u20.Normal;
                end;

                v38 = 1;
                continue;
            elseif v38 == 1 then
                v38 = -1;

                if u19.Climbing and (LinearVelocity.VectorVelocity.Y < -8.049999999999999 and Humanoid.FloorMaterial ~= Enum.Material.Air) then
                    stopClimbing();
                    v35 = task.wait();
                elseif u20 == nil and u19.Climbing then
                    if u22 or (u21 == nil or LinearVelocity.VectorVelocity.Y <= 0.1) then
                        if not u22 then
                            stopClimbing();
                        end;
                    else
                        u22 = true;
                        playClimbAnim("ledge");
                        local v39 = -Vector3.new(u21.X, 0, u21.Z);

                        if v39.Magnitude > 0.01 then
                            v39 = v39.Unit;
                        end;

                        LinearVelocity.VectorVelocity = (Vector3.new(0, 1, 0) + v39).Unit * 11.5;
                        task.delay(0.35, function() -- Line: 441
                            -- upvalues: u22 (ref), stopClimbing (copy)
                            if u22 then
                                u22 = false;
                                stopClimbing();
                            end;
                        end);
                    end;

                    v35 = task.wait();
                else
                    local v40 = not u19.Climbing and shouldHidePrompt();

                    if not (u19.Climbing or (v36 == nil or (v36 ~= u19.Part or (v23 or v24 > os.clock())))) then
                        v24 = os.clock() + 0.25;

                        if v36:GetAttribute("NoClimb") == true then
                            v23 = false;
                        else
                            v23 = Checker.check(LocalPlayer, "Climb", v36:GetAttribute("ClimbBypass"));
                        end;
                    end;

                    if u19.Part == v36 then
                        if not (u19.Climbing or (u20 == nil or not v23)) then
                            ProximityPrompt.Enabled = not v40;

                            if v36 ~= nil then
                                Attachment.WorldPosition = Attachment.WorldPosition:Lerp(u20.Position, 0.1);
                            end;
                        end;

                        goto l0;
                    end;

                    if u19.Climbing and v36 ~= nil and (u21 and u21:Dot(Vector3.new(0, 1, 0)) >= 0.5 or v36:GetAttribute("NoClimb") == true) then
                        stopClimbing();
                        v35 = task.wait();
                    else
                        if v36 == nil then
                            v23 = false;
                        elseif v36:GetAttribute("NoClimb") == true then
                            v23 = false;
                        else
                            v23 = Checker.check(LocalPlayer, "Climb", v36:GetAttribute("ClimbBypass"));
                        end;

                        if not u19.Climbing then
                            if u20 == nil or not v23 then
                                ProximityPrompt.Enabled = false;
                                Attachment.Parent = nil;
                            else
                                Attachment.Parent = workspace.Terrain;
                                Attachment.WorldPosition = u20.Position;
                                ProximityPrompt.Enabled = not v40;
                            end;
                        end;

                        u19.Part = v36;
                        updateState();

                        if u19.Climbing and u20 ~= nil then
                            Attachment.WorldPosition = u20.Position;
                        end;

                        if u19.Climbing then
                            local v41;

                            if u20 then
                                v41 = u20.Normal;
                            else
                                v41 = u21;
                            end;

                            local v42 = nil;
                            local v43 = (Parent:GetAttribute("SwimUnderwater") == true and 0.6 or 1) * 11.5 * PlayerStatResolver.GetMovementMultiplier(LocalPlayer);
                            local v44 = (Vector3.new(0, 1, 0)):Cross(v41);

                            if v44.Magnitude > 0.01 then
                                v44 = v44.Unit;
                            end;

                            local MoveDirection = Humanoid.MoveDirection;
                            local v45, v46;

                            if MoveDirection.Magnitude > 0.01 then
                                local LookVector = workspace.CurrentCamera.CFrame.LookVector;
                                local Vector3_new_ret = Vector3.new(LookVector.X, 0, LookVector.Z);

                                if Vector3_new_ret.Magnitude > 0.01 then
                                    Vector3_new_ret = Vector3_new_ret.Unit;
                                end;

                                local Vector3_new_ret2 = Vector3.new(-Vector3_new_ret.Z, 0, Vector3_new_ret.X);
                                v45 = MoveDirection:Dot(Vector3_new_ret);
                                local v47 = MoveDirection:Dot(Vector3_new_ret2);
                                v46 = math.abs(v47) <= 0.5 and 0 or math.sign(v47);
                                v42 = (Vector3.new(0, 1, 0) * v45 + v44 * v46).Unit * v43;
                                v6 = v46;
                            else
                                v45 = 0;
                                v46 = 0;
                            end;

                            if not u22 then
                                local math_abs_ret = math.abs(v45);
                                local math_abs_ret2 = math.abs(v46);
                                local v48;

                                if math_abs_ret < 0.25 and math_abs_ret2 < 0.25 then
                                    v48 = nil;
                                elseif math_abs_ret >= 0.25 then
                                    v48 = v45 > 0 and "climbup" or "climbdown";
                                else
                                    v48 = v46 > 0 and "climbright" or "climbleft";
                                end;

                                if v48 then
                                    playClimbAnim(v48);
                                else
                                    pauseClimbAnim();
                                end;
                            end;

                            if u20 then
                                v42 = (v42 or Vector3.new(0, 0, 0)) + -v41 * (u20.Distance - 1.45) * 11.5;
                            end;

                            LinearVelocity.VectorVelocity = v42 or Vector3.new(0, 0, 0);
                            AlignOrientation.CFrame = CFrame.lookAt(Vector3.new(0, 0, 0), -v41);
                        end;

                        if v36 == nil and u5.CurrentStamina >= u5.MaxClimbTime then
                            v35 = task.wait(0.35);
                        else
                            v35 = task.wait();
                        end;
                    end;
                end;

                break;
            else
                break;
            end;
        end;
    end;

    if not u22 then
        u5.CurrentStamina = math.clamp(u5.CurrentStamina - v35, 0, u5.MaxClimbTime);
    end;

    local v49 = 1 - u5.CurrentStamina / u5.MaxClimbTime;

    if u27 ~= nil then
        u27:Set(v49);
    end;

    if u28 ~= nil then
        u28:Set(u5.CurrentStamina < u5.MaxClimbTime * 0.25 and 1 or 0);
    end;

    if u5.CurrentStamina > 0 then
        local v50 = false;
        local v51 = v37 * CFrame.Angles(0, 1.413716694115407 * -v6, 0);
        u20 = workspace:Raycast(v37.Position, v51.lookVector * 4, RaycastHelper.Crater);

        if u20 == nil or u20.Normal:Dot(Vector3.new(0, 1, 0)) < 0.5 then
            if u20 == nil then
                u20 = workspace:Raycast(HumanoidRootPart.Position, v37.LookVector * 4, RaycastHelper.Crater);

                if u20 == nil or u20.Normal:Dot(Vector3.new(0, 1, 0)) < 0.5 then
                    if u20 == nil or u20.Instance == nil then
                        local v52 = v37 * vector.create(v6 * 4 / 4, 0, 0);
                        u20 = workspace:Raycast(v52, (v37 * Vector3.new(0, 0, -2) - v52).Unit * 4, RaycastHelper.Crater);

                        if u20 == nil or u20.Normal:Dot(Vector3.new(0, 1, 0)) < 0.5 then
                            if u20 ~= nil then
                                v36 = u20.Instance;
                                u21 = u20.Normal;
                            end;
                        else
                            v50 = true;
                            u20 = nil;
                        end;
                    else
                        v36 = u20.Instance;
                        u21 = u20.Normal;
                    end;
                else
                    v50 = true;
                    u20 = nil;
                end;
            else
                v36 = u20.Instance;
                u21 = u20.Normal;
            end;
        else
            v50 = true;
            u20 = nil;
        end;

        if v50 then
            startCliffing();
        end;

        goto l1;
    end;

    stopClimbing();
end;