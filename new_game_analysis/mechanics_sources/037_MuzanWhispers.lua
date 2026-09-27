-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Global = ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global");
local Utility = require(Global:WaitForChild("Utility"));
local MuzanSettings = require(Global:WaitForChild("MuzanSettings"));
local BunchaIcons = require(Global:WaitForChild("BunchaIcons"));
local CenterLeft = ReplicatedStorage:WaitForChild("Communication"):WaitForChild("CnC"):WaitForChild("Notifications"):WaitForChild("CenterLeft");
local u1 = {};
local u2 = nil;

local function shout(p3) -- Line: 25
    -- upvalues: CenterLeft (copy), BunchaIcons (copy), MuzanSettings (copy)
    CenterLeft:Fire("Npc", {
        Icon = BunchaIcons.MuzanShoutIcon,
        Text = p3[math.random(#p3)],
        Duration = MuzanSettings.WhisperDuration
    });
end;

local function canHearWhispers(p4) -- Line: 35
    local v5 = p4 ~= nil and p4:FindFirstChild("Race") or nil;
    local v6;

    if v5 == nil then
        v6 = false;
    else
        v6 = v5.Value == "Human";
    end;

    return v6;
end;

local function bind() -- Line: 40
    -- upvalues: Utility (copy), Players (copy), u2 (ref), MuzanSettings (copy), u1 (copy), CenterLeft (copy), BunchaIcons (copy)
    local Data = Utility.GetData(Players.LocalPlayer, true);

    if u2 ~= nil then
        u2:Disconnect();
        u2 = nil;
    end;

    local Reputation = Data:WaitForChild("Reputation", 10);

    if Reputation == nil then
        return;
    end;

    local Value = Reputation.Value;
    u2 = Reputation.Changed:Connect(function(p7) -- Line: 49
        -- upvalues: Value (ref), Data (copy), MuzanSettings (ref), u1 (ref), CenterLeft (ref), BunchaIcons (ref)
        local v8 = Value;
        Value = p7;

        if v8 <= p7 then
            return;
        end;

        local v9 = Data;
        local v10;

        if v9 == nil then
            v10 = nil;
        else
            v10 = v9:FindFirstChild("Race") or nil;
        end;

        local v11;

        if v10 == nil then
            v11 = false;
        else
            v11 = v10.Value == "Human";
        end;

        if not v11 then
            return;
        end;

        local v12 = nil;

        for _, v in MuzanSettings.Whispers do
            if v.Threshold < v8 and (p7 <= v.Threshold and not u1[v.Threshold]) then
                u1[v.Threshold] = true;
                v12 = v;
            end;
        end;

        if v12 ~= nil then
            local Pool = v12.Pool;
            CenterLeft:Fire("Npc", {
                Icon = BunchaIcons.MuzanShoutIcon,
                Text = Pool[math.random(#Pool)],
                Duration = MuzanSettings.WhisperDuration
            });
        end;
    end);
end;

task.spawn(function() -- Line: 67
    -- upvalues: bind (copy), Utility (copy), Players (copy), MuzanSettings (copy), u1 (copy), CenterLeft (copy), BunchaIcons (copy)
    bind();
    local _, _, v13 = Utility.GetData(Players.LocalPlayer, true);
    v13.Changed:Connect(bind);
    task.wait(MuzanSettings.JoinReminderDelay);
    local Data = Utility.GetData(Players.LocalPlayer);

    if Data ~= nil then
        local v14;

        if Data == nil then
            v14 = nil;
        else
            v14 = Data:FindFirstChild("Race") or nil;
        end;

        local v15;

        if v14 == nil then
            v15 = false;
        else
            v15 = v14.Value == "Human";
        end;

        if v15 then
            local Reputation = Data:FindFirstChild("Reputation");
            local v16 = MuzanSettings.Whispers[#MuzanSettings.Whispers];

            if Reputation ~= nil and (Reputation.Value <= v16.Threshold and not u1[v16.Threshold]) then
                u1[v16.Threshold] = true;
                local Pool = v16.Pool;
                CenterLeft:Fire("Npc", {
                    Icon = BunchaIcons.MuzanShoutIcon,
                    Text = Pool[math.random(#Pool)],
                    Duration = MuzanSettings.WhisperDuration
                });
            end;
        end;
    end;
end);