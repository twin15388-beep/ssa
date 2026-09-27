-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Checker = require(ReplicatedStorage.CAM.Global.Checker);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local InCombat = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.InCombat);
local cleanit = require(ReplicatedStorage.Packages.cleanit);
local ClimbBar = require(ReplicatedStorage.CAM.Client.Components.NonePackagedMisc.ClimbBar);
local ServerClientPortal = require(ReplicatedStorage.CAM.Global.ServerClientPortal);
local RaycastHelper = require(ReplicatedStorage.CAM.Global.RaycastHelper);
local PlayerStatResolver = require(ReplicatedStorage.CAM.Global.PlayerStatResolver);
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local InputHandler = require(ReplicatedStorage.CAM.Client.Components.Client.InputHandler);
local Platform_Handler = require(ReplicatedStorage.CAM.Client.Controllers.Platform_Handler);
local LocalPlayer = Players.LocalPlayer;
local valuesfolder = Utility.getvaluesfolder(LocalPlayer, true);
local Notification = ReplicatedStorage.Communication.CnC.Notifications.Notification;
local u1 = { {
        Name = "Walk",
        Speed = 10,
        StaminaDrain = 0,
        Anim = "Walk"
    }, {
        Name = "Gallop",
        Speed = 36,
        StaminaDrain = 1,
        Anim = "Gallop"
    }, {
        Name = "Run",
        Speed = 54,
        StaminaDrain = 2,
        Anim = "Sprint"
    } };
local u2 = 0;

local function equipCooldownLeft() -- Line: 43
    -- upvalues: u2 (ref)
    local v3 = u2 - os.clock();

    return math.max(v3, 0);
end;

local function stampEquipCooldown() -- Line: 46
    -- upvalues: u2 (ref), gameSettings (copy)
    u2 = os.clock() + gameSettings.horseEquipCooldown;
end;

local UDim2_fromScale_ret = UDim2.fromScale(0.9, 0.25);
local Vector2_new_ret = Vector2.new(1, 0.5);
local v4 = {};
local u5 = nil;
local u6 = nil;
local u7 = 1;
local u8 = 45;

function v4.cycleSpeedMode() -- Line: 114
    -- upvalues: LocalPlayer (copy), u7 (ref), u1 (copy), u8 (ref)
    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChildOfClass("Humanoid");
    end;

    if Character == nil or Character.MoveDirection.Magnitude <= 0.001 then
        return;
    end;

    local v9 = u7 + 1;
    local v10 = #u1 < v9 and 1 or v9;
    u7 = u1[v10].StaminaDrain > 0 and u8 < 1 and 1 or v10;
end;

local function flatten(p11: vector) -- Line: 128
    return Vector3.new(p11.X, 0, p11.Z);
end;

local function stopDriving() -- Line: 132
    -- upvalues: u6 (ref)
    if u6 then
        u6:Destroy();
        u6 = nil;
    end;
end;

local function startDriving(p12: userdata) -- Line: 144
    -- upvalues: u6 (ref), LocalPlayer (copy), RaycastHelper (copy), cleanit (copy), u7 (ref), InputHandler (copy), u1 (copy), u8 (ref), ServerClientPortal (copy), RunService (copy), PlayerStatResolver (copy)
    if u6 then
        u6:Destroy();
        u6 = nil;
    end;

    local HumanoidRootPart = p12:FindFirstChild("HumanoidRootPart");
    local Character = LocalPlayer.Character;
    local u13;

    if Character then
        u13 = Character:FindFirstChildOfClass("Humanoid");
    else
        u13 = Character;
    end;

    if HumanoidRootPart == nil or u13 == nil then
        return;
    end;

    local Attribute = p12:GetAttribute("hipheight");
    local math_max_ret = math.max((Attribute or 0) + 3, 6);
    local Head = Character:FindFirstChild("Head");

    local function groundHit() -- Line: 159
        -- upvalues: Head (copy), HumanoidRootPart (copy), math_max_ret (copy), RaycastHelper (ref)
        local v14;

        if Head then
            v14 = Head.Position.Y;
        else
            v14 = HumanoidRootPart.Position.Y + 3;
        end;

        local Position = HumanoidRootPart.Position;
        local Vector3_new_ret = Vector3.new(Position.X, v14, Position.Z);

        return workspace:Raycast(Vector3_new_ret, Vector3.new(0, -(v14 - Position.Y + math_max_ret + 6), 0), RaycastHelper.EverythingExceptPlayer);
    end;

    local function onGround(p15) -- Line: 175
        -- upvalues: HumanoidRootPart (copy), math_max_ret (copy)
        local v16;

        if p15 == nil then
            v16 = false;
        else
            v16 = HumanoidRootPart.Position.Y - p15.Position.Y <= math_max_ret;
        end;

        return v16;
    end;

    local function isGrounded() -- Line: 178
        -- upvalues: Head (copy), HumanoidRootPart (copy), math_max_ret (copy), RaycastHelper (ref)
        local v17;

        if Head then
            v17 = Head.Position.Y;
        else
            v17 = HumanoidRootPart.Position.Y + 3;
        end;

        local Position = HumanoidRootPart.Position;
        local Vector3_new_ret = Vector3.new(Position.X, v17, Position.Z);
        local v18 = workspace:Raycast(Vector3_new_ret, Vector3.new(0, -(v17 - Position.Y + math_max_ret + 6), 0), RaycastHelper.EverythingExceptPlayer);
        local v19;

        if v18 == nil then
            v19 = false;
        else
            v19 = HumanoidRootPart.Position.Y - v18.Position.Y <= math_max_ret;
        end;

        return v19;
    end;

    local u20 = p12:GetAttribute("RestHeight") or Attribute;

    if u20 == nil then
        warn("Horse: no RestHeight/hipheight on the horse -- hover off");
    end;

    u6 = cleanit.new();
    u7 = 1;
    u6:Add(InputHandler.ListenTo("Run", function(p21: string, p22: boolean) -- Line: 200
        -- upvalues: LocalPlayer (ref), u7 (ref), u1 (ref), u8 (ref)
        if p21 ~= "Down" or p22 then
            return;
        end;

        local Character2 = LocalPlayer.Character;

        if Character2 then
            Character2 = Character2:FindFirstChildOfClass("Humanoid");
        end;

        if Character2 ~= nil then
            if Character2.MoveDirection.Magnitude <= 0.001 then
                return;
            end;

            local v23 = u7 + 1;
            local v24 = #u1 < v23 and 1 or v23;
            u7 = u1[v24].StaminaDrain > 0 and u8 < 1 and 1 or v24;
        end;
    end));
    local u25 = ServerClientPortal.Link("HorseGait", -1);
    u6:Add(function() -- Line: 211
        -- upvalues: u25 (copy)
        if u25.__Active then
            u25:Destroy();
        end;
    end);
    local u26 = nil;
    local u27 = nil;
    local u28 = nil;
    local u29 = 0;
    local u30 = 0;
    u6:Add(InputHandler.ListenTo("Jump", function(p31: string, p32: boolean) -- Line: 226
        -- upvalues: u29 (ref), Head (copy), HumanoidRootPart (copy), math_max_ret (copy), RaycastHelper (ref), u30 (ref)
        if p31 ~= "Down" or p32 then
            return;
        end;

        if os.clock() - u29 < 2 then
            return;
        end;

        local v33;

        if Head then
            v33 = Head.Position.Y;
        else
            v33 = HumanoidRootPart.Position.Y + 3;
        end;

        local Position = HumanoidRootPart.Position;
        local Vector3_new_ret = Vector3.new(Position.X, v33, Position.Z);
        local v34 = workspace:Raycast(Vector3_new_ret, Vector3.new(0, -(v33 - Position.Y + math_max_ret + 6), 0), RaycastHelper.EverythingExceptPlayer);
        local v35;

        if v34 == nil then
            v35 = false;
        else
            v35 = HumanoidRootPart.Position.Y - v34.Position.Y <= math_max_ret;
        end;

        if not v35 then
            return;
        end;

        u29 = os.clock();
        u30 = os.clock() + 0.15;
        local AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity;
        local Attachment = Instance.new("Attachment");
        Attachment.Parent = HumanoidRootPart;
        local LinearVelocity = Instance.new("LinearVelocity");
        LinearVelocity.MaxForce = (1 / 0);
        LinearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World;
        LinearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector;
        LinearVelocity.VectorVelocity = Vector3.new(AssemblyLinearVelocity.X, 50, AssemblyLinearVelocity.Z);
        LinearVelocity.Attachment0 = Attachment;
        LinearVelocity.Parent = Attachment;
        task.delay(0.15, function() -- Line: 243
            -- upvalues: Attachment (copy)
            Attachment:Destroy();
        end);
    end));
    local Attachment = Instance.new("Attachment");
    Attachment.Name = "HorseMover";
    Attachment.Parent = HumanoidRootPart;
    u6:Add(Attachment);
    local LinearVelocity = Instance.new("LinearVelocity");
    LinearVelocity.Attachment0 = Attachment;
    LinearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World;
    LinearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane;
    LinearVelocity.PrimaryTangentAxis = Vector3.new(1, 0, 0);
    LinearVelocity.SecondaryTangentAxis = Vector3.new(0, 0, 1);
    LinearVelocity.PlaneVelocity = Vector2.zero;
    LinearVelocity.MaxForce = 25000;
    LinearVelocity.Parent = Attachment;
    local LinearVelocity2 = Instance.new("LinearVelocity");
    LinearVelocity2.Attachment0 = Attachment;
    LinearVelocity2.RelativeTo = Enum.ActuatorRelativeTo.World;
    LinearVelocity2.VelocityConstraintMode = Enum.VelocityConstraintMode.Line;
    LinearVelocity2.LineDirection = Vector3.new(0, 1, 0);
    LinearVelocity2.LineVelocity = 0;
    LinearVelocity2.MaxForce = 100000;
    LinearVelocity2.Enabled = false;
    LinearVelocity2.Parent = Attachment;
    local AlignOrientation = Instance.new("AlignOrientation");
    AlignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment;
    AlignOrientation.Attachment0 = Attachment;
    AlignOrientation.RigidityEnabled = false;
    AlignOrientation.Responsiveness = 150;
    AlignOrientation.MaxTorque = 30000;
    AlignOrientation.Parent = Attachment;
    local u36 = Vector3.new(0, 0, 0);
    local LookVector = HumanoidRootPart.CFrame.LookVector;
    local Unit = Vector3.new(LookVector.X, 0, LookVector.Z).Unit;
    local u37 = Vector3.new(0, 1, 0);
    local u38 = 0;

    local function applyOrientation() -- Line: 295
        -- upvalues: Unit (ref), u37 (ref), u38 (ref), AlignOrientation (copy)
        local v39 = Unit - u37 * Unit:Dot(u37);

        if v39.Magnitude > 0.001 then
            local Unit2 = v39.Unit;
            local v40 = u37;

            if math.abs(u38) > 0.001 then
                local v41 = Unit2:Cross(v40);
                v40 = (v40 * math.cos(u38) + v41 * math.sin(u38)).Unit;
            end;

            AlignOrientation.CFrame = CFrame.lookAlong(Vector3.new(0, 0, 0), Unit2, v40);
        end;
    end;

    applyOrientation();
    u6:Connect(RunService.Heartbeat, function(p42: number) -- Line: 311
        -- upvalues: HumanoidRootPart (copy), u13 (copy), u1 (ref), u7 (ref), Head (copy), math_max_ret (copy), RaycastHelper (ref), u30 (ref), u26 (ref), u27 (ref), u28 (ref), u25 (copy), u36 (ref), PlayerStatResolver (ref), LocalPlayer (ref), LinearVelocity (copy), Unit (ref), u38 (ref), u37 (ref), applyOrientation (copy), u20 (copy), LinearVelocity2 (copy)
        if HumanoidRootPart.Parent == nil then
            return;
        end;

        local MoveDirection = u13.MoveDirection;
        local Vector3_new_ret = Vector3.new(MoveDirection.X, 0, MoveDirection.Z);
        local v43 = Vector3_new_ret.Magnitude > 0.001;
        local v44 = not v43 and Vector3.new(0, 0, 0) or Vector3_new_ret.Unit;
        local v45 = u1[u7];
        local v46;

        if Head then
            v46 = Head.Position.Y;
        else
            v46 = HumanoidRootPart.Position.Y + 3;
        end;

        local Position = HumanoidRootPart.Position;
        local Vector3_new_ret2 = Vector3.new(Position.X, v46, Position.Z);
        local v47 = workspace:Raycast(Vector3_new_ret2, Vector3.new(0, -(v46 - Position.Y + math_max_ret + 6), 0), RaycastHelper.EverythingExceptPlayer);
        local v48;

        if v47 == nil then
            v48 = false;
        else
            v48 = HumanoidRootPart.Position.Y - v47.Position.Y <= math_max_ret;
        end;

        local v49 = not v48 or os.clock() < u30;

        if v43 ~= u26 or (v45.Anim ~= u27 or v49 ~= u28) then
            u26 = v43;
            u27 = v45.Anim;
            u28 = v49;

            if u25.__Active then
                u25:Server(v43, v45.Anim, v49);
            end;
        end;

        if v43 then
            local v50 = 1 - math.exp(p42 * -3);
            u36 = u36:Lerp(v44 * v45.Speed * PlayerStatResolver.GetMovementMultiplier(LocalPlayer), v50);
        else
            u36 = Vector3.new(0, 0, 0);
        end;

        if v43 then
            local v51 = workspace:Raycast(HumanoidRootPart.Position, v44 * 6, RaycastHelper.EverythingExceptPlayer);

            if v51 and v51.Normal.Y < 0.5 then
                local Vector3_new_ret3 = Vector3.new(v51.Normal.X, 0, v51.Normal.Z);

                if Vector3_new_ret3.Magnitude > 0.001 then
                    local Unit2 = Vector3_new_ret3.Unit;
                    local v52 = u36:Dot(Unit2);

                    if v52 < 0 then
                        u36 = u36 - Unit2 * v52;
                    end;
                end;
            end;
        end;

        local v53 = not (v47 and (not v49 and v47.Normal.Y > 0.5)) and Vector3.new(0, 1, 0) or v47.Normal;
        local Unit2 = (Vector3.new(1, 0, 0) - v53 * v53.X).Unit;
        local v54 = Unit2:Cross(v53);
        LinearVelocity.PrimaryTangentAxis = Unit2;
        LinearVelocity.SecondaryTangentAxis = v54;
        local v55 = u36:Dot(Unit2);
        local v56 = u36:Dot(v54);
        local math_sqrt_ret = math.sqrt(v55 * v55 + v56 * v56);
        local v57 = math_sqrt_ret <= 0.001 and 0 or u36.Magnitude / math_sqrt_ret;
        LinearVelocity.PlaneVelocity = Vector2.new(v55 * v57, v56 * v57);
        local v58 = Unit;

        if v43 then
            local v59 = Unit:Lerp(v44, 1 - math.exp(p42 * -2.5));

            if v59.Magnitude > 0.001 then
                Unit = v59.Unit;
            end;
        end;

        local Y = v58:Cross(Unit).Y;
        local v60;

        if p42 > 0 then
            local math_clamp_ret = math.clamp(Y, -1, 1);
            v60 = math.asin(math_clamp_ret) / p42;
        else
            v60 = 0;
        end;

        u38 = u38 + (math.clamp(-v60 * 0.35, -0.2617993877991494, 0.2617993877991494) - u38) * (1 - math.exp(p42 * -6));
        local v61 = 1 - math.exp(p42 * -6);
        local v62;

        if v47 == nil or v47.Normal.Y <= 0.5 then
            v62 = nil;
        else
            v62 = v47.Normal;
        end;

        u37 = u37:Lerp(v48 and v62 and v62 or Vector3.new(0, 1, 0), v61).Unit;
        applyOrientation();

        if not (v48 and (v47 and (u20 and u30 <= os.clock()))) then
            LinearVelocity2.Enabled = false;

            return;
        end;

        local v63 = (v47.Position.Y + u20 / math.max(v47.Normal.Y, 0.5) - HumanoidRootPart.Position.Y) * 12;
        LinearVelocity2.LineVelocity = math.clamp(v63, -40, 40);
        LinearVelocity2.Enabled = true;
    end);
end;

local u64 = false;

local function refresh() -- Line: 431
    -- upvalues: valuesfolder (copy), u6 (ref), u64 (ref), u5 (ref), LocalPlayer (copy), startDriving (copy)
    local v65 = valuesfolder and valuesfolder:FindFirstChild("RidingHorse");

    if v65 == nil then
        if u6 then
            u6:Destroy();
            u6 = nil;
        end;

        return;
    end;

    if u6 ~= nil or u64 then
        return;
    end;

    u64 = true;
    task.spawn(function() -- Line: 439
        -- upvalues: u6 (ref), u5 (ref), valuesfolder (ref), LocalPlayer (ref), startDriving (ref), u64 (ref)
        while u6 == nil and u5 ~= nil do
            local v66 = valuesfolder and valuesfolder:FindFirstChild("RidingHorse");

            if v66 == nil then
                break;
            end;

            local Value = v66.Value;
            local Character = LocalPlayer.Character;

            if Character then
                Character = Character:FindFirstChildOfClass("Humanoid");
            end;

            if Value and (Value.Parent ~= nil and (Value:FindFirstChild("HumanoidRootPart") and Character)) then
                startDriving(Value);
            end;

            if u6 ~= nil then
                break;
            end;

            task.wait();
        end;

        u64 = false;
    end);
end;

local u67 = nil;
local u68 = nil;

local function killStaminaBar() -- Line: 462
    -- upvalues: u67 (ref), u68 (ref)
    if u67 then
        u67.destroy();
    end;

    u67 = nil;
    u68 = nil;
end;

local function ensureStaminaBar() -- Line: 466
    -- upvalues: LocalPlayer (copy), u67 (ref), u68 (ref), ClimbBar (copy), UDim2_fromScale_ret (copy), Vector2_new_ret (copy)
    local Character = LocalPlayer.Character;

    if u67 and u68 == Character then
        return;
    end;

    if u67 then
        u67.destroy();
    end;

    u67 = nil;
    u68 = nil;
    local v69;

    if Character then
        v69 = Character:FindFirstChild("HumanoidRootPart");
    else
        v69 = Character;
    end;

    if v69 then
        v69 = v69:FindFirstChild("BillboardComponents");
    end;

    if v69 == nil then
        return;
    end;

    local v70, v71, v72 = ClimbBar(v69, UDim2_fromScale_ret, Vector2_new_ret);
    u67 = {
        destroy = v70,
        value = v71,
        shake = v72
    };
    u68 = Character;
end;

RunService.Heartbeat:Connect(function(p73: number) -- Line: 477
    -- upvalues: u6 (ref), u8 (ref), u67 (ref), u1 (copy), u7 (ref), LocalPlayer (copy), ensureStaminaBar (copy), u68 (ref)
    if u6 == nil and (u8 >= 45 and u67 == nil) then
        return;
    end;

    local v74 = false;

    if u6 then
        local v75 = u1[u7];

        if v75.StaminaDrain > 0 then
            local v76 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid");

            if v76 then
                local MoveDirection = v76.MoveDirection;

                if Vector3.new(MoveDirection.X, 0, MoveDirection.Z).Magnitude > 0.001 then
                    u8 = math.max(0, u8 - v75.StaminaDrain * p73);
                    v74 = true;

                    if u8 <= 0 then
                        u7 = 1;
                    end;
                end;
            end;
        end;
    end;

    if not v74 and u8 < 45 then
        u8 = math.min(45, u8 + p73 * 2);
    end;

    if u8 < 45 then
        ensureStaminaBar();

        if u67 then
            local v77 = u8 / 45;
            u67.value:Set(1 - v77);
            u67.shake:Set(v77 < 0.25 and 1 or 0);
        end;
    else
        if u67 then
            u67.destroy();
        end;

        u67 = nil;
        u68 = nil;
    end;
end);

function v4.check(p78: userdata, p79: string) -- Line: 517
    -- upvalues: Checker (copy), LocalPlayer (copy), u2 (ref), Notification (copy), InCombat (copy), Utility (copy)
    if not Checker.check(LocalPlayer) then
        return false;
    end;

    local v80 = u2 - os.clock();
    local math_max_ret = math.max(v80, 0);

    if math_max_ret > 0 then
        Notification:Fire("Notify", {
            Type = "Denied",
            Text = `Wait {math.ceil(math_max_ret)} seconds`
        });

        return false;
    end;

    if not InCombat.biasedCheck(LocalPlayer) then
        return true;
    end;

    local v81 = InCombat.biasedTimeLeft(LocalPlayer);
    Notification:Fire("Notify", {
        Type = "Denied",
        Text = `Can't mount while in combat ({Utility.formatTime(v81)} left)`
    });

    return false;
end;

function v4.Equipped(p82: userdata, p83: string) -- Line: 544
    -- upvalues: u5 (ref), u6 (ref), valuesfolder (copy), cleanit (copy), refresh (copy), stopDriving (copy)
    if u5 then
        u5:Destroy();
        u5 = nil;
    end;

    if u6 then
        u6:Destroy();
        u6 = nil;
    end;

    if valuesfolder == nil then
        return;
    end;

    u5 = cleanit.new();
    u5:Connect(valuesfolder.ChildAdded, function(p84: userdata) -- Line: 552
        -- upvalues: refresh (ref)
        if p84.Name == "RidingHorse" then
            refresh();
        end;
    end);
    u5:Connect(valuesfolder.ChildRemoved, function(p85: userdata) -- Line: 555
        -- upvalues: u6 (ref)
        if p85.Name == "RidingHorse" and u6 then
            u6:Destroy();
            u6 = nil;
        end;
    end);
    u5:Add(stopDriving);
    refresh();
end;

function v4.UnEquipped(p86: userdata, p87: string) -- Line: 562
    -- upvalues: u5 (ref), u6 (ref), u2 (ref), gameSettings (copy)
    if u5 then
        u5:Destroy();
        u5 = nil;
    end;

    if u6 then
        u6:Destroy();
        u6 = nil;
    end;

    u2 = os.clock() + gameSettings.horseEquipCooldown;
end;

function v4.MouseDown(p88: userdata, p89: string) -- Line: 571
    -- upvalues: Platform_Handler (copy), LocalPlayer (copy), u7 (ref), u1 (copy), u8 (ref)
    if Platform_Handler.Platform.Value ~= "Mobile" then
        return;
    end;

    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChildOfClass("Humanoid");
    end;

    if Character ~= nil then
        if Character.MoveDirection.Magnitude <= 0.001 then
            return;
        end;

        local v90 = u7 + 1;
        local v91 = #u1 < v90 and 1 or v90;
        u7 = u1[v91].StaminaDrain > 0 and u8 < 1 and 1 or v91;
    end;
end;

function v4.MouseUp(p92: userdata, p93: string) -- Line: 586
end;

return v4;