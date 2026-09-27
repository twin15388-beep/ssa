-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local CAM = ReplicatedStorage:WaitForChild("CAM");
local Client = CAM:WaitForChild("Client");
local Global = CAM:WaitForChild("Global");
local Platform_Handler = require(Client:WaitForChild("Controllers"):WaitForChild("Platform_Handler"));
local Utility = require(Global:WaitForChild("Utility"));
local u1 = require(game:GetService("ReplicatedStorage").Packages.cleanit).new();
local DebrisModule = require(CAM:FindFirstChild("DebrisModule"));
local ManuelCancel = require(Global:FindFirstChild("Subsets"):FindFirstChild("Gameplay"):FindFirstChild("ManuelCancel"));
local Config = require(script.Parent.Config);
local valuesfolder = Utility.getvaluesfolder(game.Players.LocalPlayer, true);
local u2 = {};
local u3 = {
    Id = 0
};
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterDescendantsInstances = { workspace.Map };
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Include;

function u3.Hold(p4) -- Line: 27
    -- upvalues: u2 (copy), Platform_Handler (copy), Config (copy), Utility (copy), u1 (copy), RunService (copy)
    if not p4 then
        return;
    end;

    local Character = p4.Character;

    if not Character then
        return;
    end;

    local u5 = Character:FindFirstChild("HumanoidRootPart") or Character.PrimaryPart;
    local Humanoid = Character:FindFirstChild("Humanoid");
    local Animator = Humanoid:FindFirstChild("Animator");

    if not (u5 and Humanoid) then
        return;
    end;

    local v6 = script.Parent.Parent.Parent.holder.skill_stand_still:Clone();
    v6.Parent = u5;
    u2.mover = v6;
    local u7 = Platform_Handler.mousepos(Config.MOUSE_RANGE);
    local u8, v9 = Utility.CreateAlignOrientationWithAttachment(u5, "skill_look_at", {
        Responsiveness = 80,
        MaxTorque = 500000,
        AlignType = Enum.AlignType.PrimaryAxisParallel,
        CFrame = Utility.SafeLookAt(u5.Position, u7, u5.CFrame)
    });
    u1:Add(u8);
    u1:Add(v9);
    u1:Connect(RunService.Heartbeat, function(p10: number) -- Line: 54
        -- upvalues: u7 (ref), Platform_Handler (ref), Config (ref), u8 (copy), Utility (ref), u5 (copy)
        u7 = Platform_Handler.mousepos(Config.MOUSE_RANGE);
        u8.CFrame = Utility.SafeLookAt(u5.Position, Vector3.new(u7.X, u5.Position.Y, u7.Z), u8.CFrame);
    end);
    u1:Add(Animator:LoadAnimation(script.Loop), "Stop"):Play();
end;

function u3.UnHold(u11: userdata) -- Line: 63
    -- upvalues: u1 (copy), u3 (copy), ManuelCancel (copy), Config (copy), valuesfolder (copy), DebrisModule (copy), u2 (copy)
    u1:Clean();

    if not u11 then
        return;
    end;

    local Character = u11.Character;

    if not Character then
        return;
    end;

    local u12 = Character:FindFirstChild("HumanoidRootPart") or Character.PrimaryPart;
    local Humanoid = Character:FindFirstChild("Humanoid");
    local Animator = Humanoid:FindFirstChild("Animator");

    if not (u12 and Humanoid) then
        return;
    end;

    local Id = u3.Id;
    local v13, _ = ManuelCancel.new(Character, Config.UNHOLD_CANCEL_WINDOW);
    v13:Connect(function() -- Line: 80
        -- upvalues: Id (ref), u3 (ref), u11 (copy)
        Id = -1;
        u3.Cancel(u11);
    end);
    u1:Add(Animator:LoadAnimation(script.End), "Stop"):Play();
    task.wait(Config.DASH_START_AT);

    if Id ~= u3.Id then
        return;
    end;

    local BoolValue = Instance.new("BoolValue");
    BoolValue.Name = "NOMouvementlines";
    BoolValue.Parent = valuesfolder;
    DebrisModule:AddItem(BoolValue, Config.DASH_DURATION);
    local mover = u2.mover;
    mover.LinearVelocity.VectorVelocity = u12.CFrame.LookVector * Config.DASH_SPEED * Vector3.new(1, 0, 1);
    DebrisModule:AddItem(mover, Config.DASH_DURATION);
    u1:Add(mover);
    task.delay(Config.DASH_DURATION, function() -- Line: 100
        -- upvalues: u12 (copy)
        u12.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
        u12.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
    end);
end;

function u3.Cancel(p14) -- Line: 107
    -- upvalues: u1 (copy), u2 (copy)
    if not p14 then
        return;
    end;

    local Character = p14.Character;

    if not Character then
        return;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");
    u1:Clean();

    if u2.mover then
        u2.mover:Destroy();
        u2.mover = nil;

        if HumanoidRootPart then
            HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
            HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
        end;
    end;
end;

return u3;