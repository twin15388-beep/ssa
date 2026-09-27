-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local LocalPlayer = Players.LocalPlayer;
local ArczisCombat = ReplicatedStorage:WaitForChild("ArczisCombat");
local HitReactionEvent = ArczisCombat:WaitForChild("Remotes"):WaitForChild("HitReactionEvent");
local CombatConfig = require(ArczisCombat:WaitForChild("CombatConfig"));
local u1 = nil;
local u2 = nil;
local u3 = nil;
local u4 = {};

local function clear() -- Line: 14
    -- upvalues: u4 (copy)
    for _, v in pairs(u4) do
        pcall(function() -- Line: 16
            -- upvalues: v (copy)
            v:Stop(0);
            v:Destroy();
        end);
    end;

    table.clear(u4);
end;

local function load(p5, p6) -- Line: 21
    -- upvalues: u3 (ref), u4 (copy)
    if not (u3 and p6) then
        return;
    end;

    local Animation = Instance.new("Animation");
    Animation.AnimationId = p6;
    local success, result = pcall(function() -- Line: 25
        -- upvalues: u3 (ref), Animation (copy)
        return u3:LoadAnimation(Animation);
    end);
    Animation:Destroy();

    if success and result then
        result.Priority = Enum.AnimationPriority.Action4;
        result.Looped = false;
        u4[p5] = result;
    end;
end;

local function setup(p7) -- Line: 34
    -- upvalues: u1 (ref), u2 (ref), u3 (ref), clear (copy), CombatConfig (copy), load (copy)
    u1 = p7;
    u2 = p7:WaitForChild("Humanoid", 10);
    local v8 = u2 and (u2:FindFirstChildOfClass("Animator") or u2:WaitForChild("Animator", 3));
    u3 = v8;
    clear();

    if not u3 then
        return;
    end;

    local Animations = CombatConfig.Animations;
    load("HitReactionM1_1", Animations.HitReactionM1_1);
    load("HitReactionM1_2", Animations.HitReactionM1_2);
    load("GuardBreak", Animations.GuardBreak);
    load("BlockHit", Animations.BlockHit);
end;

local function stopAll() -- Line: 47
    -- upvalues: u4 (copy)
    for _, v in pairs(u4) do
        if v.IsPlaying then
            v:Stop(0.06);
        end;
    end;
end;

HitReactionEvent.OnClientEvent:Connect(function(p9, p10) -- Line: 53
    -- upvalues: u1 (ref), u2 (ref), stopAll (copy), u4 (copy)
    if not (u1 and (u2 and u2.Health > 0)) then
        return;
    end;

    local IsInHitReaction = u1:FindFirstChild("IsInHitReaction");

    if p9 == "StunEnded" then
        stopAll();

        if IsInHitReaction and IsInHitReaction:IsA("BoolValue") then
            IsInHitReaction.Value = false;
        end;

        return;
    end;

    local u11 = u4[p9];

    if not u11 then
        return;
    end;

    stopAll();

    if IsInHitReaction and IsInHitReaction:IsA("BoolValue") then
        IsInHitReaction.Value = true;
    end;

    u11:Play(0.02);
    local v12 = tonumber(p10) or 0.4;
    local math_max_ret = math.max(0.05, v12);
    task.delay(math_max_ret, function() -- Line: 74
        -- upvalues: u11 (copy), u1 (ref), IsInHitReaction (copy)
        if u11.IsPlaying then
            u11:Stop(0.12);
        end;

        if u1 and (IsInHitReaction and IsInHitReaction.Parent == u1) then
            IsInHitReaction.Value = false;
        end;
    end);
end);

if LocalPlayer.Character then
    task.defer(setup, LocalPlayer.Character);
end;

LocalPlayer.CharacterAdded:Connect(setup);