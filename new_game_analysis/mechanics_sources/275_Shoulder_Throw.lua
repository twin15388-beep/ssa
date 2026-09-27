-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local CAM = ReplicatedStorage.CAM;
local u1 = require(ReplicatedStorage.Packages.cleanit).new();
local Utility = require(CAM.Global.Utility);
local Platform_Handler = require(CAM.Client.Controllers.Platform_Handler);
local Config = require(script.Parent.Config);
local u2 = {
    Id = 0
};
local script_ShoulderThrowStartup = script.ShoulderThrowStartup;
local u3 = nil;

function u2.Hold(p4: userdata) -- Line: 28
    -- upvalues: u1 (copy), u3 (ref), u2 (copy), script_ShoulderThrowStartup (copy), Platform_Handler (copy), Config (copy), Utility (copy), RunService (copy)
    u1:Clean();

    if u3 then
        u3:Disconnect();
        u3 = nil;
    end;

    local Character = p4.Character;
    local v5;

    if Character then
        v5 = Character:FindFirstChild("Humanoid");
    else
        v5 = Character;
    end;

    if v5 then
        v5 = v5:FindFirstChildOfClass("Animator");
    end;

    if Character then
        Character = Character:FindFirstChild("HumanoidRootPart");
    end;

    if not (v5 and Character) then
        return;
    end;

    local Id = u2.Id;
    local v6 = v5:LoadAnimation(script_ShoulderThrowStartup);
    u1:Add(v6);
    v6:Play();
    local v7 = Platform_Handler.mousepos(Config.MOUSE_RANGE);
    local u8, v9 = Utility.CreateAlignOrientationWithAttachment(Character, "skill_look_at", {
        Responsiveness = 70,
        MaxTorque = 500000,
        AlignType = Enum.AlignType.PrimaryAxisParallel,
        CFrame = Utility.SafeLookAt(Character.Position, Vector3.new(v7.X, Character.Position.Y, v7.Z), Character.CFrame)
    });
    u1:Add(u8);
    u1:Add(v9);
    u3 = RunService.PostSimulation:Connect(function() -- Line: 55
        -- upvalues: u2 (ref), Id (copy), Platform_Handler (ref), Config (ref), u8 (copy), Utility (ref), Character (copy)
        if u2.Id ~= Id then
            return;
        end;

        local v10 = Platform_Handler.mousepos(Config.MOUSE_RANGE);
        u8.CFrame = Utility.SafeLookAt(Character.Position, Vector3.new(v10.X, Character.Position.Y, v10.Z), u8.CFrame);
    end);
    task.wait(0.6833333333333333);

    if u2.Id ~= Id then
        return;
    end;

    if u3 then
        u3:Disconnect();
        u3 = nil;
    end;

    u8:Destroy();
    v9:Destroy();
    task.wait(1.3833333333333335);

    if u2.Id ~= Id then
        return;
    end;

    u1:Clean();
end;

function u2.UnHold(p11: userdata) -- Line: 74
end;

function u2.Cancel(p12: userdata) -- Line: 76
    -- upvalues: u3 (ref), u1 (copy)
    if u3 then
        u3:Disconnect();
        u3 = nil;
    end;

    u1:Clean();
end;

return u2;