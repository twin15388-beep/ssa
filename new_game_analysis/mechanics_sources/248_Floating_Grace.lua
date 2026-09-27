-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local CAM = ReplicatedStorage.CAM;
local Skills = ReplicatedStorage.Skills;
local u1 = require(ReplicatedStorage.Packages.cleanit).new();
local DebrisModule = require(CAM.DebrisModule);
local Utility = require(CAM.Global.Utility);
local Platform_Handler = require(CAM.Client.Controllers.Platform_Handler);
local Config = require(script.Parent.Config);
local u2 = {
    Id = 0,
    holdStart = 0
};
local skill_stand_still = Skills.holder.skill_stand_still;
local script_FloatingGraceStartup = script.FloatingGraceStartup;
local script_FloatingGraceRelease = script.FloatingGraceRelease;
local script_UmbrellaStartup = script.UmbrellaStartup;
local script_UmbrellaRelease = script.UmbrellaRelease;
local u3 = nil;

function u2.Hold(p4: userdata) -- Line: 34
    -- upvalues: u1 (copy), u3 (ref), u2 (copy), Utility (copy), Config (copy), skill_stand_still (copy), DebrisModule (copy), Platform_Handler (copy), RunService (copy), script_FloatingGraceStartup (copy), script_UmbrellaStartup (copy)
    u1:Clean();

    if u3 then
        u3:Disconnect();
        u3 = nil;
    end;

    u2.holdStart = os.clock();
    local Id = u2.Id;
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

    local u6;

    if Character then
        u6 = Character:FindFirstChild("HumanoidRootPart");
    else
        u6 = Character;
    end;

    if not (v5 and u6) then
        return;
    end;

    local valuesfolder = Utility.getvaluesfolder(Character);
    u1:Add(Utility.AddValue(valuesfolder, "NR", Config.MAX_DURATION));
    local v7 = skill_stand_still:Clone();
    v7.Parent = u6;
    u1:Add(v7);
    DebrisModule:AddItem(v7, Config.MAX_DURATION + 0.2);
    local v8 = Platform_Handler.mousepos(Config.MOUSE_RANGE);
    local u9, v10 = Utility.CreateAlignOrientationWithAttachment(u6, "skill_look_at", {
        Responsiveness = 70,
        MaxTorque = 500000,
        AlignType = Enum.AlignType.AllAxes,
        CFrame = Utility.SafeLookAt(u6.Position, v8, u6.CFrame)
    });
    u1:Add(u9);
    u1:Add(v10);
    DebrisModule:AddItem(u9, Config.MAX_DURATION);
    DebrisModule:AddItem(v10, Config.MAX_DURATION);
    u3 = RunService.PostSimulation:Connect(function() -- Line: 70
        -- upvalues: u2 (ref), Id (copy), u3 (ref), Platform_Handler (ref), Config (ref), u9 (copy), Utility (ref), u6 (copy)
        if u2.Id ~= Id then
            if u3 then
                u3:Disconnect();
                u3 = nil;
            end;

            return;
        end;

        local v11 = Platform_Handler.mousepos(Config.MOUSE_RANGE);
        u9.CFrame = Utility.SafeLookAt(u6.Position, v11, u9.CFrame);
    end);
    local u12 = v5:LoadAnimation(script_FloatingGraceStartup);
    u1:Add(u12);
    u12:Play();
    task.delay(Config.DEPLOY_DELAY, function() -- Line: 83
        -- upvalues: u2 (ref), Id (copy), u12 (copy)
        if u2.Id ~= Id then
            return;
        end;

        if u12.IsPlaying then
            u12:AdjustSpeed(0);
        end;
    end);
    local v13 = v5:LoadAnimation(script_UmbrellaStartup);
    v13:Play();
    u1:Add(v13);
    task.wait(Config.DEPLOY_DELAY + 0.05);
end;

function u2.UnHold(p14: userdata) -- Line: 97
    -- upvalues: u3 (ref), u1 (copy), script_FloatingGraceRelease (copy), script_UmbrellaRelease (copy)
    if u3 then
        u3:Disconnect();
        u3 = nil;
    end;

    local Character = p14.Character;

    if Character then
        Character = Character:FindFirstChild("Humanoid");
    end;

    if Character then
        Character = Character:FindFirstChildOfClass("Animator");
    end;

    if Character == nil then
        u1:Clean();

        return true;
    end;

    u1:Clean();
    local v15 = Character:LoadAnimation(script_FloatingGraceRelease);
    u1:Add(v15);
    v15:Play();
    local v16 = Character:LoadAnimation(script_UmbrellaRelease);
    v16:Play();
    u1:Add(v16);

    return true;
end;

function u2.Cancel(p17: userdata) -- Line: 122
    -- upvalues: u3 (ref), u1 (copy)
    if u3 then
        u3:Disconnect();
        u3 = nil;
    end;

    u1:Clean();
end;

return u2;