-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local CAM = ReplicatedStorage.CAM;
local Skills = ReplicatedStorage.Skills;
local u1 = require(ReplicatedStorage.Packages.cleanit).new();
local Utility = require(CAM.Global.Utility);
local Platform_Handler = require(CAM.Client.Controllers.Platform_Handler);
local Config = require(script.Parent.Config);
local u2 = {
    Id = 0
};
local script_FlashFist = script.FlashFist;
local u3 = nil;
local u4 = nil;

function u2.Hold(p5: userdata) -- Line: 30
    -- upvalues: u1 (copy), u3 (ref), u4 (ref), u2 (copy), Skills (copy), Platform_Handler (copy), Config (copy), Utility (copy), RunService (copy), script_FlashFist (copy)
    u1:Clean();

    if u3 then
        u3:Stop();
        u3 = nil;
    end;

    if u4 then
        u4:Disconnect();
        u4 = nil;
    end;

    local Character = p5.Character;
    local v6;

    if Character then
        v6 = Character:FindFirstChild("Humanoid");
    else
        v6 = Character;
    end;

    if Character then
        Character = Character:FindFirstChild("HumanoidRootPart");
    end;

    if v6 then
        v6 = v6:FindFirstChildOfClass("Animator");
    end;

    if not (v6 and Character) then
        return;
    end;

    local Id = u2.Id;
    local v7 = Skills.holder.skill_stand_still:Clone();
    v7.Parent = Character;
    u1:Add(v7);
    local v8 = Platform_Handler.mousepos(Config.MOUSE_RANGE);
    local u9, v10 = Utility.CreateAlignOrientationWithAttachment(Character, "skill_look_at", {
        Responsiveness = 70,
        MaxTorque = 500000,
        AlignType = Enum.AlignType.PrimaryAxisParallel,
        CFrame = Utility.SafeLookAt(Character.Position, Vector3.new(v8.X, Character.Position.Y, v8.Z), Character.CFrame)
    });
    u1:Add(u9);
    u1:Add(v10);
    u4 = RunService.PostSimulation:Connect(function() -- Line: 59
        -- upvalues: u2 (ref), Id (copy), Platform_Handler (ref), Config (ref), u9 (copy), Utility (ref), Character (copy)
        if u2.Id ~= Id then
            return;
        end;

        local v11 = Platform_Handler.mousepos(Config.MOUSE_RANGE);
        u9.CFrame = Utility.SafeLookAt(Character.Position, Vector3.new(v11.X, Character.Position.Y, v11.Z), u9.CFrame);
    end);
    u3 = v6:LoadAnimation(script_FlashFist);
    u3:Play();
    task.delay(Config.HOLD_PAUSE, function() -- Line: 68
        -- upvalues: u2 (ref), Id (copy), u3 (ref)
        if u2.Id ~= Id then
            return;
        end;

        if u3 and u3.IsPlaying then
            u3:AdjustSpeed(0);
        end;
    end);
end;

function u2.UnHold(p12: userdata) -- Line: 74
    -- upvalues: u2 (copy), u4 (ref), u3 (ref), Config (copy), u1 (copy)
    local Id = u2.Id;

    if u4 then
        u4:Disconnect();
        u4 = nil;
    end;

    local v13;

    if u3 then
        v13 = math.max(0, Config.HOLD_PAUSE - u3.TimePosition);
        u3:AdjustSpeed(1);
    else
        v13 = 0;
    end;

    task.delay(v13 + Config.END_AT, function() -- Line: 88
        -- upvalues: u2 (ref), Id (copy), u1 (ref), u3 (ref)
        if u2.Id ~= Id then
            return;
        end;

        u1:Clean();

        if u3 then
            u3:Stop();
            u3 = nil;
        end;
    end);
end;

function u2.Cancel(p14: userdata) -- Line: 95
    -- upvalues: u4 (ref), u1 (copy), u3 (ref)
    if u4 then
        u4:Disconnect();
        u4 = nil;
    end;

    u1:Clean();

    if u3 then
        u3:Stop();
        u3 = nil;
    end;
end;

return u2;