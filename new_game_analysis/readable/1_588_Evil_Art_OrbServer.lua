-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");
local Checker = require(ReplicatedStorage.CAM.Global.Checker);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local ManuelCancel = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.ManuelCancel);
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
local EvilArtCores = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests.EvilArtCores);
local BunchaIcons = require(ReplicatedStorage.CAM.Global.BunchaIcons);
local MuzanSettings = require(ReplicatedStorage.CAM.Global.MuzanSettings);
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);
local EffectsEvent = require(ReplicatedStorage.Communication.ServerAndClient.Effects.EffectsEvent);
local Item = require(ServerStorage.SAM.Services.Removers.Item);
local v1 = {};

local function muzanSays(p2: userdata, p3: string) -- Line: 26
    -- upvalues: SignalEvent (copy), BunchaIcons (copy), MuzanSettings (copy)
    SignalEvent.ToClient(p2, "NpcNotify", {
        Icon = BunchaIcons.MuzanIcon,
        Text = p3,
        Duration = MuzanSettings.GrantShoutDuration
    });
end;

function v1.MouseDown(u4: userdata, u5: userdata, u6: table, u7: string) -- Line: 34
    -- upvalues: Checker (copy), Utility (copy), MuzanSettings (copy), SignalEvent (copy), BunchaIcons (copy), EffectsEvent (copy), ManuelCancel (copy), EvilArtCores (copy), Quests (copy), Item (copy)
    if not Checker.check(u4) then
        return;
    end;

    if u6.Thread ~= nil then
        return;
    end;

    local Data = Utility.GetData(u4);

    if Data == nil or Data.Inventory.Inventory:FindFirstChild(u7) == nil then
        return;
    end;

    if Data.Powers.DemonArt.Value ~= "" then
        SignalEvent.ToClient(u4, "NpcNotify", {
            Icon = BunchaIcons.MuzanIcon,
            Text = MuzanSettings.OrbHasArtText,
            Duration = MuzanSettings.GrantShoutDuration
        });

        return;
    end;

    local function cancelSqueeze() -- Line: 45
        -- upvalues: u6 (copy), EffectsEvent (ref), u5 (copy)
        if u6.Thread ~= nil then
            task.cancel(u6.Thread);
            u6.Thread = nil;
            EffectsEvent.ToAllInRange(u5, "EvilArtSqueeze", u5, "Cancel");
        end;
    end;

    local v8, u9 = ManuelCancel.new(u4, 0.9333333333333333);
    v8:Connect(cancelSqueeze);
    EffectsEvent.ToAllInRange(u5, "EvilArtSqueeze", u5);
    u6.Thread = task.spawn(function() -- Line: 57
        -- upvalues: u6 (copy), u9 (copy), Checker (ref), u5 (copy), EvilArtCores (ref), u7 (copy), Quests (ref), u4 (copy), SignalEvent (ref), BunchaIcons (ref), MuzanSettings (ref), Item (ref), Utility (ref)
        task.wait(0.8833333333333333);
        u6.Thread = nil;
        u9();

        if Checker.check_victim(script, u5, u5) == nil then
            return;
        end;

        local u10 = EvilArtCores.Key((u7:gsub(" Orb$", "")));
        local v11, _, v12 = Quests.CanAddQuest(u4, u10);

        if v11 == true then
            Quests.AddQuest(u4, u10);
            task.delay(1.1166666666666667, function() -- Line: 71
                -- upvalues: u4 (ref), Item (ref), u7 (ref), Utility (ref), u10 (copy), Quests (ref)
                if u4.Parent == nil then
                    return;
                end;

                if Item(u4, u7, nil, nil, "Consumed") then
                    return;
                end;

                local Data2 = Utility.GetData(u4);

                if Data2 == nil then
                    return;
                end;

                for _, child in Data2.Quests.Holder:GetChildren() do
                    local QuestString = child:FindFirstChild("QuestString");

                    if QuestString ~= nil and QuestString.Value == u10 then
                        Quests.DeleteQuest(u4, child);

                        return;
                    end;
                end;
            end);

            return;
        end;

        local v13 = v12 == nil and "Not now." or `Cancel '{v12}' first.`;
        SignalEvent.ToClient(u4, "NpcNotify", {
            Icon = BunchaIcons.MuzanIcon,
            Text = v13,
            Duration = MuzanSettings.GrantShoutDuration
        });
    end);
end;

function v1.MouseUp(p14: userdata, p15: userdata, p16: table) -- Line: 89
    -- upvalues: EffectsEvent (copy)
    if p16.Thread ~= nil then
        task.cancel(p16.Thread);
        p16.Thread = nil;
        EffectsEvent.ToAllInRange(p15, "EvilArtSqueeze", p15, "Cancel");
    end;
end;

return v1;