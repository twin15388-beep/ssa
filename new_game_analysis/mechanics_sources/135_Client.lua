-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local faye = require(ReplicatedStorage.Packages.faye);
local MarkerHandler = require(ReplicatedStorage.CAM.Client.Modules.MarkerHandler);
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);
local BoulderPushUI = require(ReplicatedStorage.CAM.Client.Components.NonePackagedMisc.Training.BoulderPushUI);
local valuesfolder = Utility.getvaluesfolder(Players.LocalPlayer, true);
local v1 = {};
local u2 = nil;

local function teardown() -- Line: 35
    -- upvalues: u2 (ref)
    local v3 = u2;
    u2 = nil;

    if v3 then
        v3:Destroy();
    end;
end;

local function flatten(p4: vector) -- Line: 48
    return Vector3.new(p4.X, 0, p4.Z);
end;

local function openGates(p5) -- Line: 55
    -- upvalues: CollectionService (copy)
    for _, v in CollectionService:GetTagged("MazeGateTransparency") do
        for _, v2 in v:QueryDescendants("BasePart") do
            local Transparency = v2.Transparency;
            local CanCollide = v2.CanCollide;
            v2.Transparency = 0.6;
            v2.CanCollide = false;
            p5:Add(function() -- Line: 61
                -- upvalues: v2 (copy), Transparency (copy), CanCollide (copy)
                v2.Transparency = Transparency;
                v2.CanCollide = CanCollide;
            end);
        end;
    end;
end;

function v1.Do(p6: userdata, p7: userdata, p8: userdata, p9: userdata?) -- Line: 69
    -- upvalues: u2 (ref), faye (copy), Utility (copy), valuesfolder (copy), openGates (copy), MarkerHandler (copy), BoulderPushUI (copy), SignalEvent (copy), RunService (copy)
    local v10 = u2;
    u2 = nil;

    if v10 then
        v10:Destroy();
    end;

    u2 = faye.new();
    u2:Add(Utility.AddValue(valuesfolder, "skill_stand_still"));
    u2:Add(Utility.AddValue(valuesfolder, "pause_gameplay"));
    u2:Add(Utility.AddValue(valuesfolder, "NR"));
    u2:Add(Utility.AddValue(valuesfolder, "boulder_push"));

    if p8:GetAttribute("WagasaRoute") then
        openGates(u2);
    end;

    local v11;

    if p9 and p9.Parent then
        v11 = p9.Parent.Parent;
    else
        v11 = nil;
    end;

    local Attribute = p8:GetAttribute("GoalName");
    local v12;

    if v11 == nil or Attribute == nil then
        v12 = nil;
    else
        v12 = v11:FindFirstChild(Attribute);
    end;

    local u13;

    if v12 == nil then
        u13 = nil;
    else
        u13 = v12:FindFirstChild("MainAt", true);
    end;

    if u13 ~= nil then
        u13.Beam.Enabled = true;
        u13.Beam1.Enabled = true;
        u2:Add(function() -- Line: 94
            -- upvalues: u13 (copy)
            u13.Beam.Enabled = false;
            u13.Beam1.Enabled = false;
        end);
    end;

    local Attribute2 = p8:GetAttribute("GoalPosition");

    if Attribute2 ~= nil then
        MarkerHandler.addMarker("boulder_push_goal", {
            style = "Simple",
            img = "rbxassetid://78675452486649",
            tag = "BoulderPushMarker",
            markerType = MarkerHandler.markerType.Regular,
            position = Attribute2 + Vector3.new(0, 3, 0)
        });
        u2:Add(function() -- Line: 111
            -- upvalues: MarkerHandler (ref)
            MarkerHandler.removeMarker("boulder_push_goal");
        end);
    end;

    u2:Add(BoulderPushUI(p6.PlayerGui.ComponentsHolder, function() -- Line: 117
        -- upvalues: SignalEvent (ref)
        SignalEvent.ToServer("training_signaler", "Stop");
    end));
    local HumanoidRootPart = p7:FindFirstChild("HumanoidRootPart");
    local u14 = p7:FindFirstChildOfClass("Humanoid");

    if HumanoidRootPart == nil or u14 == nil then
        return;
    end;

    local AutoRotate = u14.AutoRotate;
    u14.AutoRotate = false;
    u2:Add(function() -- Line: 129
        -- upvalues: u14 (copy), AutoRotate (copy)
        if u14 ~= nil then
            u14.AutoRotate = AutoRotate;
        end;
    end);
    local Attachment = Instance.new("Attachment");
    Attachment.Name = "BoulderPushMover";
    Attachment.Parent = HumanoidRootPart;
    u2:Add(Attachment);
    local LinearVelocity = Instance.new("LinearVelocity");
    LinearVelocity.Attachment0 = Attachment;
    LinearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World;
    LinearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane;
    LinearVelocity.PrimaryTangentAxis = Vector3.new(1, 0, 0);
    LinearVelocity.SecondaryTangentAxis = Vector3.new(0, 0, 1);
    LinearVelocity.PlaneVelocity = Vector2.zero;
    LinearVelocity.MaxForce = 10000;
    LinearVelocity.Parent = Attachment;
    local AlignOrientation = Instance.new("AlignOrientation");
    AlignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment;
    AlignOrientation.Attachment0 = Attachment;
    AlignOrientation.RigidityEnabled = false;
    AlignOrientation.Responsiveness = 200;
    AlignOrientation.MaxTorque = 10000;
    AlignOrientation.Parent = Attachment;
    local u15 = Vector3.new(0, 0, 0);
    local LookVector = HumanoidRootPart.CFrame.LookVector;
    local Vector3_new_ret = Vector3.new(LookVector.X, 0, LookVector.Z);
    local u16 = Vector3_new_ret.Magnitude <= 0.001 and Vector3.new(0, 0, -1) or Vector3_new_ret.Unit;
    AlignOrientation.CFrame = CFrame.lookAt(Vector3.new(0, 0, 0), u16);
    local v17 = u14:FindFirstChildOfClass("Animator");
    local Idle = script:FindFirstChild("Idle");
    local Walk = script:FindFirstChild("Walk");
    local u18;

    if v17 and Idle then
        u18 = v17:LoadAnimation(Idle) or nil;
    else
        u18 = nil;
    end;

    local u19 = v17 and (Walk and v17:LoadAnimation(Walk)) or nil;

    if u18 then
        u18.Looped = true;
        u18.Priority = Enum.AnimationPriority.Movement;
    end;

    if u19 then
        u19.Looped = true;
        u19.Priority = Enum.AnimationPriority.Movement;
    end;

    u2:Add(function() -- Line: 182
        -- upvalues: u18 (copy), u19 (copy)
        if u18 then
            u18:Stop(0.2);
        end;

        if u19 then
            u19:Stop(0.2);
        end;
    end);
    local u20 = nil;
    u2:Add(RunService.Heartbeat:Connect(function(p21: number) -- Line: 188
        -- upvalues: HumanoidRootPart (copy), u14 (copy), u20 (ref), SignalEvent (ref), u18 (copy), u19 (copy), u15 (ref), LinearVelocity (copy), u16 (ref), AlignOrientation (copy)
        if HumanoidRootPart.Parent == nil then
            return;
        end;

        local MoveDirection = u14.MoveDirection;
        local Vector3_new_ret2 = Vector3.new(MoveDirection.X, 0, MoveDirection.Z);
        local v22 = Vector3_new_ret2.Magnitude > 0.001;
        local v23 = not v22 and Vector3.new(0, 0, 0) or Vector3_new_ret2.Unit;

        if v22 ~= u20 then
            u20 = v22;
            SignalEvent.ToServer("training_signaler", "StateChanged", v22);

            if v22 then
                if u18 then
                    u18:Stop(0.2);
                end;

                if u19 then
                    u19:Play(0.2);
                end;
            else
                if u19 then
                    u19:Stop(0.2);
                end;

                if u18 then
                    u18:Play(0.2);
                end;
            end;
        end;

        if v22 then
            local v24 = 1 - math.exp(p21 * -3);
            u15 = u15:Lerp(v23 * 16, v24);
        else
            u15 = Vector3.new(0, 0, 0);
        end;

        LinearVelocity.PlaneVelocity = Vector2.new(u15.X, u15.Z);

        if v22 then
            local v25 = u16:Lerp(v23, 1 - math.exp(p21 * -1.75));

            if v25.Magnitude > 0.001 then
                u16 = v25.Unit;
                AlignOrientation.CFrame = CFrame.lookAt(Vector3.new(0, 0, 0), u16);
            end;
        end;
    end));
end;

function v1.Stop(p26: userdata, p27: userdata, p28: userdata) -- Line: 236
    -- upvalues: u2 (ref)
    local v29 = u2;
    u2 = nil;

    if v29 then
        v29:Destroy();
    end;
end;

return v1;