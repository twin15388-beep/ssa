-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");
local BunchaIcons = require(ReplicatedStorage.CAM.Global.BunchaIcons);
local Checker = require(ReplicatedStorage.CAM.Global.Checker);
local InCombat = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.InCombat);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local MuzanSettings = require(ReplicatedStorage.CAM.Global.MuzanSettings);
local Worlds = require(ReplicatedStorage.CAM.Worlds);
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);
local EffectsEvent = require(ReplicatedStorage.Communication.ServerAndClient.Effects.EffectsEvent);
local ReputationHandler = require(ServerStorage.SAM.Services.ReputationHandler);
local v1 = {};
local u2 = {};
game:GetService("Players").PlayerRemoving:Connect(function(p3) -- Line: 45
    -- upvalues: u2 (copy)
    local v4 = u2[p3];

    if v4 ~= nil and (v4.SequenceThread ~= nil and not v4.SequenceCommitted) then
        task.cancel(v4.SequenceThread);
    end;

    u2[p3] = nil;
end);

local function stateFor(p5: userdata) -- Line: 52
    -- upvalues: u2 (copy)
    local v6 = u2[p5];

    if v6 == nil then
        v6 = {};
        u2[p5] = v6;
    end;

    return v6;
end;

local u7 = MuzanSettings.LairRingLength - MuzanSettings.LairFallLead + MuzanSettings.LairFallDelay;
local u8 = u7 + MuzanSettings.LairTeleportAtFall;
local u9 = u7 + MuzanSettings.LairFallLength;
local u10 = u9 + MuzanSettings.LairRiseLength;

local function fireDoorEffect(p11: userdata, p12: string) -- Line: 71
    -- upvalues: EffectsEvent (copy)
    local HumanoidRootPart = p11:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart == nil then
        return;
    end;

    EffectsEvent.ToAllInRange(HumanoidRootPart, "BiwaDoorEffects", p11, p12);
end;

local function cancelSequence(p13: userdata, p14: table) -- Line: 81
    if p14.SequenceCommitted then
        return;
    end;

    if p14.SequenceThread == nil then
        return;
    end;

    task.cancel(p14.SequenceThread);
    p14.SequenceThread = nil;

    if p14.SequencePause ~= nil then
        p14.SequencePause:Destroy();
        p14.SequencePause = nil;
    end;
end;

local function worldAllows() -- Line: 98
    -- upvalues: Worlds (copy)
    local v15 = Worlds.ById[game.PlaceId];
    local v16;

    if v15 == nil then
        v16 = false;
    else
        v16 = v15.BiwaBellEnabled == true;
    end;

    return v16;
end;

function v1.check(p17: userdata, p18: userdata, p19: table, p20: string) -- Line: 103
    -- upvalues: Worlds (copy), MuzanSettings (copy), InCombat (copy)
    local v21 = Worlds.ById[game.PlaceId];
    local v22;

    if v21 == nil then
        v22 = false;
    else
        v22 = v21.BiwaBellEnabled == true;
    end;

    if v22 then
        return (p17:GetAttribute(MuzanSettings.LairAttribute) == true or not InCombat.biasedCheck(p17)) and true or false;
    end;

    return false;
end;

function v1.MouseDown(u23: userdata, u24: userdata, p25: table, u26: string) -- Line: 111
    -- upvalues: u2 (copy), Worlds (copy), Checker (copy), Utility (copy), MuzanSettings (copy), ReputationHandler (copy), SignalEvent (copy), BunchaIcons (copy), Quests (copy), InCombat (copy), u10 (copy), EffectsEvent (copy), u7 (copy), u8 (copy), u9 (copy)
    local u27 = u2[u23];

    if u27 == nil then
        u27 = {};
        u2[u23] = u27;
    end;

    local v28 = Worlds.ById[game.PlaceId];
    local v29;

    if v28 == nil then
        v29 = false;
    else
        v29 = v28.BiwaBellEnabled == true;
    end;

    if not v29 then
        return;
    end;

    if not Checker.check(u23, nil, "BiwaBell") then
        return;
    end;

    local Data = Utility.GetData(u23);

    if Data == nil then
        return;
    end;

    if Data.Inventory.Inventory:FindFirstChild(u26) == nil then
        return;
    end;

    if u27.SequenceThread ~= nil then
        return;
    end;

    if u27.LastRing ~= nil and os.clock() - u27.LastRing < 1 then
        return;
    end;

    u27.LastRing = os.clock();
    local valuesfolder = Utility.getvaluesfolder(u24);

    if valuesfolder == nil then
        return;
    end;

    local u30 = u23:GetAttribute(MuzanSettings.LairAttribute) ~= true;

    if u30 then
        local v31 = ReputationHandler.Get(u23);

        if v31 == nil or MuzanSettings.LairEntryReputation <= v31 then
            SignalEvent.ToClient(u23, "NpcNotify", {
                Duration = 4,
                Icon = BunchaIcons.MuzanIcon,
                Text = `You are not evil enough. Return below {MuzanSettings.LairEntryReputation}.`
            });

            return;
        end;

        if Quests.GetPlayerQuestState(u23, MuzanSettings.LairBlockedQuest) == "Doing" then
            SignalEvent.ToClient(u23, "NpcNotify", {
                Text = "Finish your errand with the doctor first.",
                Duration = 4,
                Icon = BunchaIcons.MuzanIcon
            });

            return;
        end;

        if InCombat.biasedCheck(u23) then
            SignalEvent.ToClient(u23, "Notify", {
                Type = "Denied",
                Text = `Can't enter the lair while in combat ({Utility.formatTime(InCombat.biasedTimeLeft(u23))} left)`
            });

            return;
        end;
    end;

    local HumanoidRootPart = u24:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart == nil then
        return;
    end;

    local CFrame = HumanoidRootPart.CFrame;
    u27.SequencePause = Utility.AddValue(valuesfolder, "pause_gameplay", u10 + 0.5);
    local HumanoidRootPart2 = u24:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart2 ~= nil then
        EffectsEvent.ToAllInRange(HumanoidRootPart2, "BiwaDoorEffects", u24, "Ring");
    end;

    u27.SequenceThread = task.spawn(function() -- Line: 171
        -- upvalues: u7 (ref), u24 (copy), EffectsEvent (ref), u27 (copy), u8 (ref), Data (copy), u26 (copy), u30 (copy), ReputationHandler (ref), u23 (copy), MuzanSettings (ref), SignalEvent (ref), CFrame (copy), u9 (ref), u10 (ref)
        task.wait(u7 - 0.1);
        local v32 = u24;
        local HumanoidRootPart3 = v32:FindFirstChild("HumanoidRootPart");

        if HumanoidRootPart3 ~= nil then
            EffectsEvent.ToAllInRange(HumanoidRootPart3, "BiwaDoorEffects", v32, "JumpIn");
        end;

        task.wait(0.2);
        u27.SequenceCommitted = true;
        task.wait(u8 - u7);
        local v33 = u24:FindFirstChildOfClass("Humanoid");

        if u24.Parent ~= nil and (v33 ~= nil and (v33.Health > 0 and Data.Inventory.Inventory:FindFirstChild(u26) ~= nil)) then
            if u30 then
                ReputationHandler.Add(u23, MuzanSettings.LairEntryCost);
                SignalEvent.ToClient(u23, "Notify", {
                    Type = "Warn",
                    Duration = 6,
                    Text = `The lair takes its toll. {MuzanSettings.LairEntryCost} evil reputation spent.`
                });
                u23:SetAttribute(MuzanSettings.LairReturnAttribute, CFrame);
            end;

            u23:SetAttribute(MuzanSettings.LairAttribute, u30);
        end;

        task.wait(u9 - u8);
        local v34 = u24;
        local HumanoidRootPart4 = v34:FindFirstChild("HumanoidRootPart");

        if HumanoidRootPart4 ~= nil then
            EffectsEvent.ToAllInRange(HumanoidRootPart4, "BiwaDoorEffects", v34, "JumpOut");
        end;

        task.wait(u10 - u9);

        if u23:GetAttribute(MuzanSettings.LairAttribute) ~= true then
            u23:SetAttribute(MuzanSettings.LairReturnAttribute, nil);
        end;

        if u27.SequencePause ~= nil then
            u27.SequencePause:Destroy();
            u27.SequencePause = nil;
        end;

        u27.SequenceThread = nil;
        u27.SequenceCommitted = nil;
    end);

    if u30 then
        local os_clock_ret = os.clock();
        task.spawn(function() -- Line: 226
            -- upvalues: u27 (copy), os_clock_ret (copy), u7 (ref), InCombat (ref), u23 (copy), SignalEvent (ref)
            while u27.SequenceThread ~= nil and (not u27.SequenceCommitted and os.clock() - os_clock_ret < u7 - 0.3) do
                if InCombat.biasedCheck(u23) then
                    local v35 = u27;

                    if not v35.SequenceCommitted and v35.SequenceThread ~= nil then
                        task.cancel(v35.SequenceThread);
                        v35.SequenceThread = nil;

                        if v35.SequencePause ~= nil then
                            v35.SequencePause:Destroy();
                            v35.SequencePause = nil;
                        end;
                    end;

                    SignalEvent.ToClient(u23, "ForceEquip", 0);

                    return;
                end;

                task.wait(0.2);
            end;
        end);
    end;
end;

function v1.UnEquipped(p36: userdata, p37: userdata, p38: table, p39: string) -- Line: 240
    -- upvalues: u2 (copy)
    local v40 = u2[p36];

    if v40 == nil then
        v40 = {};
        u2[p36] = v40;
    end;

    if v40.SequenceCommitted then
        return;
    end;

    if v40.SequenceThread == nil then
        return;
    end;

    task.cancel(v40.SequenceThread);
    v40.SequenceThread = nil;

    if v40.SequencePause ~= nil then
        v40.SequencePause:Destroy();
        v40.SequencePause = nil;
    end;
end;

return v1;