-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local faye = require(ReplicatedStorage.Packages.faye);
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);
local BarKeepup = require(ReplicatedStorage.CAM.Client.Components.NonePackagedMisc.Minigames.BarKeepup);
local valuesfolder = Utility.getvaluesfolder(Players.LocalPlayer, true);
local v1 = {};
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;

local function playSquatSound(p7: string, p8: userdata?) -- Line: 21
    local v9 = script.Parent:FindFirstChild(p7);

    if v9 == nil then
        return;
    end;

    local u10 = v9:Clone();

    if not (p8 and (p8.Parent ~= nil and p8)) then
        p8 = script;
    end;

    u10.Parent = p8;
    u10:Play();
    u10.Ended:Once(function() -- Line: 27
        -- upvalues: u10 (copy)
        u10:Destroy();
    end);
end;

local function teardown() -- Line: 32
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), u5 (ref), u6 (ref), playSquatSound (copy), TweenService (copy)
    local u11 = u2;
    local v12 = u3;
    local v13 = u4;
    local u14 = u5;
    local v15 = u6;
    u2 = nil;
    u3 = nil;
    u4 = nil;
    u5 = nil;
    u6 = nil;

    if u11 then
        playSquatSound("PS2trainingWEIGHTSputdown", v15);
    end;

    if u14 then
        local u16 = TweenService:Create(u14, TweenInfo.new(0.3), {
            Volume = 0
        });
        u16:Play();
        task.spawn(function() -- Line: 48
            -- upvalues: u16 (copy), u14 (copy)
            u16.Completed:Wait();
            u14:Destroy();
        end);
    end;

    if v13 then
        v13:Stop(0.3);
    end;

    if v12 then
        v12();
    end;

    if u11 then
        task.spawn(function() -- Line: 67
            -- upvalues: u11 (copy)
            task.wait(0.5);
            u11:Destroy();
        end);
    end;
end;

function v1.Do(p17: userdata, p18: userdata, p19: userdata, p20: userdata?) -- Line: 74
    -- upvalues: teardown (copy), u2 (ref), faye (copy), Utility (copy), valuesfolder (copy), u4 (ref), u6 (ref), playSquatSound (copy), u5 (ref), u3 (ref), BarKeepup (copy), SignalEvent (copy)
    teardown();
    u2 = faye.new();
    u2:Add(Utility.AddValue(valuesfolder, "skill_stand_still"));
    u2:Add(Utility.AddValue(valuesfolder, "pause_gameplay"));
    u2:Add(Utility.AddValue(valuesfolder, "NR"));
    u4 = p18.Humanoid.Animator:LoadAnimation(script.Squat);
    u4:Play();
    u6 = p18:FindFirstChild("HumanoidRootPart") or p18.PrimaryPart;
    playSquatSound("PS2trainingWEIGHTSpickup", u6);

    if u6 then
        u5 = script.Parent.PS2trainingWEIGHTSloop:Clone();
        u5.Looped = true;
        u5.Parent = u6;
        u5:Play();
    end;

    local Misc = p17.PlayerGui:WaitForChild("Misc");
    local u21 = false;
    u3 = BarKeepup(Misc, {
        Thread = u2,

        Stop = function(p22: boolean) -- Line: 112, Name: Stop
            -- upvalues: u21 (ref), SignalEvent (ref)
            if u21 then
                return;
            end;

            u21 = true;
            SignalEvent.ToServer("training_signaler", "Stop", p22 == true);
        end
    });
end;

function v1.Stop(p23: userdata, p24: userdata, p25: userdata) -- Line: 120
    -- upvalues: teardown (copy)
    teardown();
end;

return v1;