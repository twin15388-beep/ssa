-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local faye = require(ReplicatedStorage.Packages.faye);
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);
local Shrinking = require(ReplicatedStorage.CAM.Client.Components.NonePackagedMisc.Minigames.Shrinking);
local valuesfolder = Utility.getvaluesfolder(Players.LocalPlayer, true);
local v1 = {};
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;

local function teardown() -- Line: 17
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), u5 (ref), TweenService (copy)
    local u6 = u2;
    local v7 = u3;
    local v8 = u4;
    local u9 = u5;
    u2 = nil;
    u3 = nil;
    u4 = nil;
    u5 = nil;

    if v8 then
        v8:Stop(0.3);
    end;

    if u9 then
        local u10 = TweenService:Create(u9, TweenInfo.new(0.3), {
            Volume = 0
        });
        u10:Play();
        task.spawn(function() -- Line: 33
            -- upvalues: u10 (copy), u9 (copy)
            u10.Completed:Wait();
            u9:Destroy();
        end);
    end;

    if v7 then
        v7();
    end;

    if u6 then
        task.spawn(function() -- Line: 46
            -- upvalues: u6 (copy)
            task.wait(0.5);
            u6:Destroy();
        end);
    end;
end;

function v1.Do(p11: userdata, p12: userdata, p13: userdata, p14: userdata?) -- Line: 53
    -- upvalues: teardown (copy), u2 (ref), faye (copy), Utility (copy), valuesfolder (copy), u4 (ref), u5 (ref), u3 (ref), Shrinking (copy), SignalEvent (copy)
    teardown();
    u2 = faye.new();
    u2:Add(Utility.AddValue(valuesfolder, "skill_stand_still"));
    u2:Add(Utility.AddValue(valuesfolder, "pause_gameplay"));
    u2:Add(Utility.AddValue(valuesfolder, "NR"));
    u4 = p12.Humanoid.Animator:LoadAnimation(script.Pushups);
    u4:Play();
    local v15 = p12:FindFirstChild("HumanoidRootPart") or p12.PrimaryPart;

    if v15 then
        u5 = script.Parent.PS2trainingPUSHUPSloop:Clone();
        u5.Looped = true;
        u5.Parent = v15;
        u5:Play();
    end;

    local Misc = p11.PlayerGui:WaitForChild("Misc");
    local u16 = false;
    u3 = Shrinking(Misc, {
        Thread = u2,

        Stop = function(p17: boolean) -- Line: 89, Name: Stop
            -- upvalues: u16 (ref), SignalEvent (ref)
            if u16 then
                return;
            end;

            u16 = true;
            SignalEvent.ToServer("training_signaler", "Stop", p17 == true);
        end
    });
end;

function v1.Stop(p18: userdata, p19: userdata, p20: userdata) -- Line: 97
    -- upvalues: teardown (copy)
    teardown();
end;

return v1;