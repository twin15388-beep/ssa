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
local Config = require(script.Parent.Config);
local u2 = {
    Id = 0
};
local u3 = {};
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterDescendantsInstances = { workspace.Map };
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Include;

function u2.Hold(p4) -- Line: 26
    -- upvalues: u2 (copy), u1 (copy), u3 (copy), Platform_Handler (copy), Config (copy), Utility (copy), RunService (copy)
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

    local Id = u2.Id;
    u1:Add(Animator:LoadAnimation(script.Startup), "Stop"):Play();
    local v6 = script.Parent.Parent.Parent.holder.skill_stand_still:Clone();
    v6.Parent = u5;
    u3.mover = v6;
    local u7 = Platform_Handler.mousepos(Config.MOUSE_RANGE);
    local u8, v9 = Utility.CreateAlignOrientationWithAttachment(u5, "skill_look_at", {
        Responsiveness = 80,
        MaxTorque = 500000,
        AlignType = Enum.AlignType.PrimaryAxisParallel,
        CFrame = Utility.SafeLookAt(u5.Position, u7, u5.CFrame)
    });
    u1:Add(u8);
    u1:Add(v9);
    u1:Connect(RunService.Heartbeat, function(p10: number) -- Line: 58
        -- upvalues: u7 (ref), Platform_Handler (ref), Config (ref), u8 (copy), Utility (ref), u5 (copy)
        u7 = Platform_Handler.mousepos(Config.MOUSE_RANGE);
        u8.CFrame = Utility.SafeLookAt(u5.Position, Vector3.new(u7.X, u5.Position.Y, u7.Z), u8.CFrame);
    end);
    task.wait(Config.STARTUP_DUR);

    if Id ~= u2.Id then
        return;
    end;

    u1:Add(Animator:LoadAnimation(script.Hold), "Stop"):Play();
end;

function u2.UnHold(p11: userdata) -- Line: 71
    -- upvalues: u3 (copy), DebrisModule (copy), Config (copy), u1 (copy), u2 (copy)
    if u3.mover then
        DebrisModule:AddItem(u3.mover, Config.RELEASE_DELAY);
        u3.mover = nil;
    end;

    u1:Clean();

    if not p11 then
        return;
    end;

    local Character = p11.Character;

    if not Character then
        return;
    end;

    local v12 = Character:FindFirstChild("HumanoidRootPart") or Character.PrimaryPart;
    local Humanoid = Character:FindFirstChild("Humanoid");
    local Animator = Humanoid:FindFirstChild("Animator");

    if not (v12 and Humanoid) then
        return;
    end;

    local _ = u2.Id;
    local v13 = u1:Add(Animator:LoadAnimation(script.Release), "Stop");
    v13:Play();
    v13.Priority = Enum.AnimationPriority.Action2;
    task.wait(Config.RELEASE_DELAY);
end;

function u2.Cancel(p14) -- Line: 97
    -- upvalues: u3 (copy), u1 (copy)
    if u3.mover ~= nil then
        u3.mover:Destroy();
        u3.mover = nil;
    end;

    u1:Clean();
end;

return u2;