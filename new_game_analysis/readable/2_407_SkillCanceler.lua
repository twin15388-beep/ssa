-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local SignalEvent = require(game:GetService("ReplicatedStorage").Communication.ServerAndClient.Signals.SignalEvent);

if not RunService:IsStudio() then
    return;
end;

local script_CancelSkillIndicator = script.CancelSkillIndicator;
script_CancelSkillIndicator.Parent = Players.LocalPlayer.PlayerGui;
script_CancelSkillIndicator.ResetOnSpawn = false;
script_CancelSkillIndicator.TextLabel.TextTransparency = 1;
local ContextActionService = game:GetService("ContextActionService");
local TweenService = game:GetService("TweenService");
local TweenInfo_new_ret = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
local u1 = nil;
local u2 = nil;
ContextActionService:BindActionAtPriority("CancelSkill", function(p3, p4, p5) -- Line: 23
    -- upvalues: SignalEvent (copy), u1 (ref), script_CancelSkillIndicator (copy), u2 (ref), TweenService (copy), TweenInfo_new_ret (copy)
    if p3 ~= "CancelSkill" or p4 ~= Enum.UserInputState.Begin then
        return Enum.ContextActionResult.Pass;
    end;

    SignalEvent.ToServer("CancelSkill");

    if u1 then
        u1:Pause();
        u1:Destroy();
    end;

    script_CancelSkillIndicator.TextLabel.TextTransparency = 0;

    if u2 then
        task.cancel(u2);
    end;

    u2 = task.delay(0.1, function() -- Line: 38
        -- upvalues: u1 (ref), TweenService (ref), script_CancelSkillIndicator (ref), TweenInfo_new_ret (ref)
        u1 = TweenService:Create(script_CancelSkillIndicator.TextLabel, TweenInfo_new_ret, {
            TextTransparency = 1
        });
        u1:Play();
    end);

    return Enum.ContextActionResult.Sink;
end, false, Enum.ContextActionPriority.High.Value, Enum.KeyCode.T);