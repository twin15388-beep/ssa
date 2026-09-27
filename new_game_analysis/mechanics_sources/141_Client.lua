-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local faye = require(ReplicatedStorage.Packages.faye);
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);
local Shrinking = require(ReplicatedStorage.CAM.Client.Components.NonePackagedMisc.Minigames.Shrinking);
local valuesfolder = Utility.getvaluesfolder(Players.LocalPlayer, true);
local v1 = {};
local u2 = nil;
local u3 = nil;
local u4 = nil;

local function releaseFreeze() -- Line: 18
    -- upvalues: u4 (ref)
    if u4 == nil then
        return;
    end;

    local v5 = u4;
    u4 = nil;

    for _, v in v5 do
        if v and v.Parent then
            v:Destroy();
        end;
    end;
end;

local function teardown() -- Line: 29
    -- upvalues: u4 (ref), u2 (ref), u3 (ref)
    if u4 ~= nil then
        local v6 = u4;
        u4 = nil;

        for _, v in v6 do
            if v and v.Parent then
                v:Destroy();
            end;
        end;
    end;

    local u7 = u2;
    local v8 = u3;
    u2 = nil;
    u3 = nil;

    if v8 then
        v8();
    end;

    if u7 then
        task.spawn(function() -- Line: 46
            -- upvalues: u7 (copy)
            task.wait(0.5);
            u7:Destroy();
        end);
    end;
end;

function v1.Do(p9: userdata, p10: userdata, p11: userdata, p12: userdata?) -- Line: 53
    -- upvalues: u4 (ref), u2 (ref), u3 (ref), faye (copy), Utility (copy), valuesfolder (copy), Shrinking (copy), SignalEvent (copy)
    if u4 ~= nil then
        local v13 = u4;
        u4 = nil;

        for _, v in v13 do
            if v and v.Parent then
                v:Destroy();
            end;
        end;
    end;

    local u14 = u2;
    local v15 = u3;
    u2 = nil;
    u3 = nil;

    if v15 then
        v15();
    end;

    if u14 then
        task.spawn(function() -- Line: 46
            -- upvalues: u14 (copy)
            task.wait(0.5);
            u14:Destroy();
        end);
    end;

    u2 = faye.new();
    u4 = { Utility.AddValue(valuesfolder, "skill_stand_still"), Utility.AddValue(valuesfolder, "pause_gameplay"), Utility.AddValue(valuesfolder, "NR") };
    local Misc = p9.PlayerGui:WaitForChild("Misc");
    local u16 = false;
    u3 = Shrinking(Misc, {
        Thread = u2,

        Stop = function(p17: boolean) -- Line: 76, Name: Stop
            -- upvalues: u16 (ref), u4 (ref), SignalEvent (ref)
            if u16 then
                return;
            end;

            u16 = true;

            if p17 ~= true and u4 ~= nil then
                local v18 = u4;
                u4 = nil;

                for _, v in v18 do
                    if v and v.Parent then
                        v:Destroy();
                    end;
                end;
            end;

            SignalEvent.ToServer("training_signaler", "Stop", p17 == true);
        end
    });
end;

function v1.Stop(p19: userdata, p20: userdata, p21: userdata) -- Line: 90
    -- upvalues: u4 (ref), u2 (ref), u3 (ref)
    if u4 ~= nil then
        local v22 = u4;
        u4 = nil;

        for _, v in v22 do
            if v and v.Parent then
                v:Destroy();
            end;
        end;
    end;

    local u23 = u2;
    local v24 = u3;
    u2 = nil;
    u3 = nil;

    if v24 then
        v24();
    end;

    if u23 then
        task.spawn(function() -- Line: 46
            -- upvalues: u23 (copy)
            task.wait(0.5);
            u23:Destroy();
        end);
    end;
end;

return v1;