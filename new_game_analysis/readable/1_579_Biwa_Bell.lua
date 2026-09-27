-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Checker = require(ReplicatedStorage.CAM.Global.Checker);
local InCombat = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.InCombat);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local MuzanSettings = require(ReplicatedStorage.CAM.Global.MuzanSettings);
local Worlds = require(ReplicatedStorage.CAM.Worlds);
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
local SequenceTeleport = require(ReplicatedStorage.CAM.Client.Modules.SequenceTeleport);
local Notification = ReplicatedStorage.Communication.CnC.Notifications.Notification;
local v1 = {};
local LocalPlayer = Players.LocalPlayer;
local u2 = script.Parent:WaitForChild("Biwa BellServer");
local u3 = MuzanSettings.LairRingLength - MuzanSettings.LairFallLead + MuzanSettings.LairFallDelay;
local u4 = u3 + MuzanSettings.LairTeleportAtFall;
local u5 = u3 + MuzanSettings.LairFallLength;
local u6 = u5 + MuzanSettings.LairRiseLength;
local u7 = nil;

local function setHeadCam() -- Line: 49
    -- upvalues: LocalPlayer (copy), Utility (copy), u7 (ref)
    local Character = LocalPlayer.Character;
    local v8 = Character ~= nil and Character:FindFirstChild("Head") or nil;
    local valuesfolder = Utility.getvaluesfolder(LocalPlayer);

    if v8 == nil or valuesfolder == nil then
        return;
    end;

    if u7 == nil or u7.Parent == nil then
        local ObjectValue = Instance.new("ObjectValue");
        ObjectValue.Name = "camsubject";
        ObjectValue.Parent = valuesfolder;
        u7 = ObjectValue;
    end;

    u7.Value = v8;
end;

local function clearHeadCam() -- Line: 62
    -- upvalues: u7 (ref)
    if u7 ~= nil then
        u7:Destroy();
        u7 = nil;
    end;
end;

local u9 = nil;

local function syncLairZoom(p10: userdata) -- Line: 76
    -- upvalues: Utility (copy), LocalPlayer (copy), u9 (ref), MuzanSettings (copy)
    if p10:GetAttribute("InMuzanLair") == true then
        local valuesfolder = Utility.getvaluesfolder(LocalPlayer);

        if valuesfolder == nil then
            return;
        end;

        if u9 == nil or u9.Parent == nil then
            local NumberValue = Instance.new("NumberValue");
            NumberValue.Name = "MaxZoom";
            NumberValue.Value = MuzanSettings.LairMaxZoom;
            NumberValue.Parent = valuesfolder;
            u9 = NumberValue;
        end;
    elseif u9 ~= nil then
        u9:Destroy();
        u9 = nil;
    end;
end;

local function hookLairZoom(u11: userdata) -- Line: 92
    -- upvalues: syncLairZoom (copy)
    u11:GetAttributeChangedSignal("InMuzanLair"):Connect(function() -- Line: 93
        -- upvalues: syncLairZoom (ref), u11 (copy)
        syncLairZoom(u11);
    end);
    syncLairZoom(u11);
end;

if LocalPlayer.Character ~= nil then
    local Character = LocalPlayer.Character;
    Character:GetAttributeChangedSignal("InMuzanLair"):Connect(function() -- Line: 93
        -- upvalues: syncLairZoom (copy), Character (copy)
        syncLairZoom(Character);
    end);
    syncLairZoom(Character);
end;

LocalPlayer.CharacterAdded:Connect(hookLairZoom);
local u12 = nil;
local u13 = 0;
local u14 = 0;

local function startSequence() -- Line: 108
    -- upvalues: u13 (ref), u7 (ref), u12 (ref), SequenceTeleport (copy), u2 (copy), MuzanSettings (copy), LocalPlayer (copy)
    u13 = os.clock();

    if u7 ~= nil then
        u7:Destroy();
        u7 = nil;
    end;

    u12 = SequenceTeleport.Start({
        CoverDelay = 0.5,
        UncoverLead = 0.5,
        Ring = u2:FindFirstChild("BiwaBellRing"),
        Fall = u2:FindFirstChild("TeleportFall"),
        Rise = u2:FindFirstChild("TeleportRise"),
        RingLength = MuzanSettings.LairRingLength,
        FallLead = MuzanSettings.LairFallLead,
        FallDelay = MuzanSettings.LairFallDelay,
        FallLength = MuzanSettings.LairFallLength,
        TeleportAtFall = MuzanSettings.LairTeleportAtFall,
        RiseLength = MuzanSettings.LairRiseLength,
        LockName = `{LocalPlayer.Name}_BiwaBellLock`,

        OnCovered = function() -- Line: 128, Name: OnCovered
            -- upvalues: LocalPlayer (ref), MuzanSettings (ref)
            local Character = LocalPlayer.Character;

            if Character ~= nil then
                Character:SetAttribute("InMuzanLair", LocalPlayer:GetAttribute(MuzanSettings.LairAttribute) == true);
            end;
        end
    });
end;

LocalPlayer:GetAttributeChangedSignal(MuzanSettings.LairAttribute):Connect(function() -- Line: 142
    -- upvalues: LocalPlayer (copy), MuzanSettings (copy), u12 (ref), u7 (ref), u5 (copy), u4 (copy), setHeadCam (copy), u6 (copy), clearHeadCam (copy), SequenceTeleport (copy)
    local v15 = LocalPlayer:GetAttribute(MuzanSettings.LairAttribute) == true;
    local Character = LocalPlayer.Character;
    local v16;

    if Character == nil then
        v16 = nil;
    else
        v16 = Character:FindFirstChild("HumanoidRootPart") or nil;
    end;

    if Character == nil or v16 == nil then
        return;
    end;

    local v17;

    if v15 then
        v17 = MuzanSettings.LairArrival;
    else
        v17 = LocalPlayer:GetAttribute(MuzanSettings.LairReturnAttribute);

        if typeof(v17) ~= "CFrame" then
            if u12 ~= nil and u12.IsActive() then
                u12.Cancel();
                u12 = nil;
            end;

            Character:SetAttribute("InMuzanLair", false);

            if u7 ~= nil then
                u7:Destroy();
                u7 = nil;
            end;

            return;
        end;
    end;

    if u12 == nil or not u12.IsActive() then
        Character:SetAttribute("InMuzanLair", v15);
        Character:PivotTo(SequenceTeleport.GroundSnap(v17));

        if u7 ~= nil then
            u7:Destroy();
            u7 = nil;
        end;

        return;
    end;

    u12.SetDestination(v17);
    task.delay(u5 - u4, setHeadCam);
    task.delay(u6 - u4 + 0.5, clearHeadCam);
end);

local function worldAllows() -- Line: 192
    -- upvalues: Worlds (copy), Notification (copy)
    local v18 = Worlds.ById[game.PlaceId];

    if v18 ~= nil and v18.BiwaBellEnabled == true then
        return true;
    end;

    Notification:Fire("Notify", {
        Text = "Can\'t use biwa bell here",
        Type = "Denied"
    });

    return false;
end;

function v1.check(p19: userdata, p20: string) -- Line: 202
    -- upvalues: Worlds (copy), Notification (copy), LocalPlayer (copy), MuzanSettings (copy), InCombat (copy), Utility (copy)
    local v21 = Worlds.ById[game.PlaceId];
    local v22;

    if v21 == nil or v21.BiwaBellEnabled ~= true then
        Notification:Fire("Notify", {
            Text = "Can\'t use biwa bell here",
            Type = "Denied"
        });
        v22 = false;
    else
        v22 = true;
    end;

    if not v22 then
        return false;
    end;

    if LocalPlayer:GetAttribute(MuzanSettings.LairAttribute) == true or not InCombat.biasedCheck(LocalPlayer) then
        return true;
    end;

    Notification:Fire("Notify", {
        Type = "Denied",
        Text = `Can't enter the lair while in combat ({Utility.formatTime(InCombat.biasedTimeLeft(LocalPlayer))} left)`
    });

    return false;
end;

function v1.MouseDown(p23: userdata, p24: string) -- Line: 214
    -- upvalues: Worlds (copy), Notification (copy), Checker (copy), LocalPlayer (copy), Utility (copy), u12 (ref), u14 (ref), MuzanSettings (copy), Quests (copy), InCombat (copy), startSequence (copy)
    local v25 = Worlds.ById[game.PlaceId];
    local v26;

    if v25 == nil or v25.BiwaBellEnabled ~= true then
        Notification:Fire("Notify", {
            Text = "Can\'t use biwa bell here",
            Type = "Denied"
        });
        v26 = false;
    else
        v26 = true;
    end;

    if not v26 then
        return;
    end;

    if p23 == nil then
        return;
    end;

    local v27 = p23:FindFirstChildOfClass("Humanoid");

    if v27 == nil or v27.Health <= 0 then
        return;
    end;

    if not Checker.check(LocalPlayer, nil, "BiwaBell") then
        return;
    end;

    local Data = Utility.GetData(LocalPlayer);

    if Data == nil then
        return;
    end;

    if Data.Inventory.Inventory:FindFirstChild(p24) == nil then
        return;
    end;

    if u12 ~= nil and u12.IsActive() then
        return;
    end;

    if os.clock() - u14 < 1 then
        return;
    end;

    u14 = os.clock();

    if LocalPlayer:GetAttribute(MuzanSettings.LairAttribute) ~= true then
        local Reputation = Data:FindFirstChild("Reputation");

        if Reputation == nil or Reputation.Value >= MuzanSettings.LairEntryReputation then
            return;
        end;

        if Quests.GetPlayerQuestState(LocalPlayer, MuzanSettings.LairBlockedQuest) == "Doing" then
            return;
        end;

        if InCombat.biasedCheck(LocalPlayer) then
            return;
        end;
    end;

    startSequence();
end;

function v1.UnEquipped(p28: userdata?, p29: string?) -- Line: 245
    -- upvalues: u12 (ref), u13 (ref), u3 (copy)
    if u12 == nil then
        return;
    end;

    if u3 <= os.clock() - u13 then
        return;
    end;

    u12.Cancel();
    u12 = nil;
end;

return v1;