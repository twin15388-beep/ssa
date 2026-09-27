-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local faye = require(ReplicatedStorage.Packages.faye);
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);
local SlideBubbles = require(ReplicatedStorage.CAM.Client.Components.NonePackagedMisc.Minigames.SlideBubbles);
local valuesfolder = Utility.getvaluesfolder(Players.LocalPlayer, true);
local v1 = {};
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;

local function playMeditateSound(p6: string, p7: userdata?) -- Line: 19
    local v8 = script.Parent:FindFirstChild(p6);

    if v8 == nil then
        return;
    end;

    local u9 = v8:Clone();

    if not (p7 and (p7.Parent ~= nil and p7)) then
        p7 = script;
    end;

    u9.Parent = p7;
    u9:Play();
    u9.Ended:Once(function() -- Line: 25
        -- upvalues: u9 (copy)
        u9:Destroy();
    end);
end;

local function teardown() -- Line: 30
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), u5 (ref), playMeditateSound (copy)
    local u10 = u2;
    local v11 = u3;
    local v12 = u4;
    local v13 = u5;
    u2 = nil;
    u3 = nil;
    u4 = nil;
    u5 = nil;

    if u10 then
        playMeditateSound("PS2trainingPUSHUPSandMEDITATEstop", v13);
    end;

    if v12 then
        v12:Stop(0.3);
    end;

    if v11 then
        v11();
    end;

    if u10 then
        task.spawn(function() -- Line: 56
            -- upvalues: u10 (copy)
            task.wait(0.5);
            u10:Destroy();
        end);
    end;
end;

function v1.Do(p14: userdata, p15: userdata, p16: userdata, p17: userdata?) -- Line: 63
    -- upvalues: teardown (copy), u2 (ref), faye (copy), Utility (copy), valuesfolder (copy), u4 (ref), u5 (ref), playMeditateSound (copy), u3 (ref), SlideBubbles (copy), SignalEvent (copy)
    teardown();
    u2 = faye.new();
    u2:Add(Utility.AddValue(valuesfolder, "skill_stand_still"));
    u2:Add(Utility.AddValue(valuesfolder, "pause_gameplay"));
    u2:Add(Utility.AddValue(valuesfolder, "NR"));
    u4 = p15.Humanoid.Animator:LoadAnimation(script.Meditation);
    u4:Play();
    u5 = p15:FindFirstChild("HumanoidRootPart") or p15.PrimaryPart;
    playMeditateSound("PS2trainingPUSHUPSandMEDITATEstart", u5);
    local Misc = p14.PlayerGui:WaitForChild("Misc");
    local u18 = false;
    u3 = SlideBubbles(Misc, {
        Thread = u2,

        Stop = function(p19: boolean) -- Line: 92, Name: Stop
            -- upvalues: u18 (ref), SignalEvent (ref)
            if u18 then
                return;
            end;

            u18 = true;
            SignalEvent.ToServer("training_signaler", "Stop", p19 == true);
        end
    });
end;

function v1.Stop(p20: userdata, p21: userdata, p22: userdata) -- Line: 100
    -- upvalues: teardown (copy)
    teardown();
end;

return v1;