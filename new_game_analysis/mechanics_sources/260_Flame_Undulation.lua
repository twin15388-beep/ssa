-- Decompiled with Potassium's decompiler.

local u1 = {
    Id = 0
};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local u2 = nil;
local u3 = nil;
local u4 = nil;
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local u5 = require(ReplicatedStorage.Packages.cleanit).new();
local RunService = game:GetService("RunService");
local Platform_Handler = require(ReplicatedStorage.CAM.Client.Controllers.Platform_Handler);
local ManuelCancel = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.ManuelCancel);
local SkillStats = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.StatsFetch.Modules.SkillStats);
local Config = require(script.Parent.Config);
local u6 = nil;

local function interrupted(p7: userdata?) -- Line: 21
    -- upvalues: SkillStats (copy), Utility (copy)
    if p7 == nil then
        return false;
    end;

    local v8 = SkillStats.Get(script.Parent.Name);

    if v8 ~= nil and v8.cancel_bypass then
        return false;
    end;

    for _, child in ipairs(p7:GetChildren()) do
        if Utility.Cancel_Values[child.Name] then
            return true;
        end;
    end;

    return false;
end;

local function teardown() -- Line: 33
    -- upvalues: u5 (copy), u2 (ref), u4 (ref), u6 (ref)
    u5:Clean();

    if u2 ~= nil then
        u2:Destroy();
        u2 = nil;
    end;

    if u4 ~= nil then
        u4:Destroy();
        u4 = nil;
    end;

    if u6 ~= nil then
        u6:Stop();
        u6 = nil;
    end;
end;

function u1.Hold(p9, u10) -- Line: 48
    -- upvalues: u1 (copy), u2 (ref), u3 (ref), u4 (ref), Utility (copy), u5 (copy), RunService (copy), Platform_Handler (copy), u6 (ref), Config (copy)
    local Character = p9.Character;
    local Id = u1.Id;

    if not Character then
        return;
    end;

    local u11 = Character:FindFirstChild("HumanoidRootPart") or Character.PrimaryPart;
    local Humanoid = Character:FindFirstChild("Humanoid");

    if not (u11 and Humanoid) then
        return;
    end;

    local Animator = Humanoid:FindFirstChild("Animator");
    u2 = script.Parent.Parent.Parent.holder.skill_stand_still:Clone();
    u2.Parent = u11;
    local v12, v13 = Utility.CreateAlignOrientationWithAttachment(u11, "skill_look_at", {
        Responsiveness = 80,
        MaxTorque = 500000,
        AlignType = Enum.AlignType.PrimaryAxisParallel,
        CFrame = Utility.SafeLookAt(u11.Position, u10, u11.CFrame)
    });
    u3 = v12;
    u4 = v13;
    u5:Connect(RunService.Heartbeat, function(p14: number) -- Line: 72
        -- upvalues: u10 (ref), Platform_Handler (ref), u3 (ref), Utility (ref), u11 (copy)
        u10 = Platform_Handler.mousepos();
        u3.CFrame = Utility.SafeLookAt(u11.Position, u10, u3.CFrame);
    end);
    u6 = Animator:LoadAnimation(script.Startup);
    u6:Play();
    task.wait(Config.HOLD_STARTUP_DUR);

    if u1.Id == Id then
        u6:Stop();
        u6 = Animator:LoadAnimation(script.Loop);
        u6:Play();
    end;
end;

function u1.UnHold(p15) -- Line: 85
    -- upvalues: u5 (copy), u2 (ref), u4 (ref), u6 (ref), Utility (copy), interrupted (copy), Config (copy), u1 (copy), ManuelCancel (copy)
    local Character = p15.Character;

    if Character == nil then
        return;
    end;

    local Humanoid = Character:FindFirstChild("Humanoid");

    if Humanoid == nil then
        u5:Clean();

        if u2 ~= nil then
            u2:Destroy();
            u2 = nil;
        end;

        if u4 ~= nil then
            u4:Destroy();
            u4 = nil;
        end;

        if u6 ~= nil then
            u6:Stop();
            u6 = nil;
        end;

        return;
    end;

    local Animator = Humanoid:FindFirstChild("Animator");

    if Animator == nil then
        u5:Clean();

        if u2 ~= nil then
            u2:Destroy();
            u2 = nil;
        end;

        if u4 ~= nil then
            u4:Destroy();
            u4 = nil;
        end;

        if u6 ~= nil then
            u6:Stop();
            u6 = nil;
        end;

        return;
    end;

    local valuesfolder = Utility.getvaluesfolder(Character);

    if interrupted(valuesfolder) then
        u5:Clean();

        if u2 ~= nil then
            u2:Destroy();
            u2 = nil;
        end;

        if u4 ~= nil then
            u4:Destroy();
            u4 = nil;
        end;

        if u6 ~= nil then
            u6:Stop();
            u6 = nil;
        end;

        return;
    end;

    if u6 ~= nil then
        u6:Stop();
        u6 = nil;
    end;

    local u16 = Animator:LoadAnimation(script.Release);
    u16:Play(nil, nil, 1.35);
    local u17 = Utility.AddValue(valuesfolder, "NR", Config.RELEASE_LOCK_DURATION);
    local u18 = Utility.AddValue(valuesfolder, "pause_gameplay", Config.RELEASE_LOCK_DURATION);
    u5:Clean();
    local Id = u1.Id;
    local v19, u20 = ManuelCancel.new(p15, Config.RELEASE_LOCK_DURATION, nil, script.Parent.Name);
    v19:Connect(function() -- Line: 112
        -- upvalues: Id (ref), u16 (copy), u17 (copy), u18 (copy), u5 (ref), u2 (ref), u4 (ref), u6 (ref), u20 (copy)
        Id = -1;
        u16:Stop();
        u17:Destroy();
        u18:Destroy();
        u5:Clean();

        if u2 ~= nil then
            u2:Destroy();
            u2 = nil;
        end;

        if u4 ~= nil then
            u4:Destroy();
            u4 = nil;
        end;

        if u6 ~= nil then
            u6:Stop();
            u6 = nil;
        end;

        u20();
    end);
    task.wait(Config.RELEASE_LOCK_DURATION);
    u20();

    if Id ~= u1.Id then
        return;
    end;

    u5:Clean();

    if u2 ~= nil then
        u2:Destroy();
        u2 = nil;
    end;

    if u4 ~= nil then
        u4:Destroy();
        u4 = nil;
    end;

    if u6 ~= nil then
        u6:Stop();
        u6 = nil;
    end;
end;

function u1.Cancel(p21) -- Line: 126
    -- upvalues: u5 (copy), u2 (ref), u4 (ref), u6 (ref)
    u5:Clean();

    if u2 ~= nil then
        u2:Destroy();
        u2 = nil;
    end;

    if u4 ~= nil then
        u4:Destroy();
        u4 = nil;
    end;

    if u6 ~= nil then
        u6:Stop();
        u6 = nil;
    end;
end;

function u1.Counter(p22, p23, p24) -- Line: 129
    -- upvalues: u1 (copy)
    u1.UnHold(p22);
end;

return u1;