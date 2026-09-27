-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local faye = require(ReplicatedStorage.Packages.faye);
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);
local ClientEffects = ReplicatedStorage.Communication.CnC.ClientEffects;
local Slider = require(ReplicatedStorage.CAM.Client.Components.NonePackagedMisc.Minigames.Slider);
local valuesfolder = Utility.getvaluesfolder(Players.LocalPlayer, true);
local v1 = {};
local u2 = nil;

local function teardown() -- Line: 16
    -- upvalues: u2 (ref)
    local v3 = u2;
    u2 = nil;

    if v3 then
        v3:Destroy();
    end;
end;

function v1.Do(p4: userdata, u5: userdata, p6: userdata, p7: userdata?) -- Line: 24
    -- upvalues: u2 (ref), faye (copy), Utility (copy), valuesfolder (copy), ClientEffects (copy), SignalEvent (copy), Slider (copy)
    local v8 = u2;
    u2 = nil;

    if v8 then
        v8:Destroy();
    end;

    u2 = faye.new();
    u2:Add(Utility.AddValue(valuesfolder, "skill_stand_still"));
    u2:Add(Utility.AddValue(valuesfolder, "pause_gameplay"));
    u2:Add(Utility.AddValue(valuesfolder, "NR"));
    local v9 = u5:FindFirstChildOfClass("Humanoid");

    if v9 then
        v9 = v9:FindFirstChildOfClass("Animator");
    end;

    local Idle = script.Parent:FindFirstChild("Idle");
    local Slash = script.Parent:FindFirstChild("Slash");
    local u10;

    if v9 and Idle then
        u10 = v9:LoadAnimation(Idle) or nil;
    else
        u10 = nil;
    end;

    local u11 = v9 and (Slash and v9:LoadAnimation(Slash)) or nil;

    if u10 then
        u10.Looped = true;
        u10.Priority = Enum.AnimationPriority.Idle;
        u10:Play(0.1);
    end;

    if u11 then
        u11.Looped = false;
        u11.Priority = Enum.AnimationPriority.Action;
    end;

    u2:Add(function() -- Line: 50
        -- upvalues: u10 (copy), u11 (copy)
        if u10 then
            u10:Stop(0.1);
        end;

        if u11 then
            u11:Stop(0.1);
        end;
    end);
    local u12 = false;

    local function playSlash() -- Line: 58
        -- upvalues: u11 (copy), u12 (ref), ClientEffects (ref), u5 (copy), SignalEvent (ref)
        if u11 == nil or u12 then
            return;
        end;

        u12 = true;
        u11:Play(0.1);
        ClientEffects:Fire("BoulderSlashFailed", u5);
        SignalEvent.ToServer("training_signaler", "StateChanged");
    end;

    if u11 then
        u2:Connect(u11.Stopped, function() -- Line: 68
            -- upvalues: u12 (ref)
            u12 = false;
        end);
    end;

    local Misc = p4.PlayerGui:WaitForChild("Misc");
    local u13 = false;
    Slider(Misc, {
        Thread = u2,

        OnComplete = function(p14: boolean) -- Line: 82, Name: OnComplete
            -- upvalues: u11 (copy), u12 (ref), ClientEffects (ref), u5 (copy), SignalEvent (ref)
            if u11 ~= nil then
                if u12 then
                    return;
                end;

                u12 = true;
                u11:Play(0.1);
                ClientEffects:Fire("BoulderSlashFailed", u5);
                SignalEvent.ToServer("training_signaler", "StateChanged");
            end;
        end,

        Stop = function(p15: boolean) -- Line: 85, Name: Stop
            -- upvalues: u13 (ref), SignalEvent (ref)
            if u13 then
                return;
            end;

            u13 = true;
            SignalEvent.ToServer("training_signaler", "Stop", p15 == true);
        end
    });
end;

function v1.Stop(p16: userdata, p17: userdata, p18: userdata) -- Line: 93
    -- upvalues: u2 (ref)
    local v19 = u2;
    u2 = nil;

    if v19 then
        v19:Destroy();
    end;
end;

return v1;