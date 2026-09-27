-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");
local Checker = require(ReplicatedStorage.CAM.Global.Checker);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local ManuelCancel = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.ManuelCancel);
local EffectsEvent = require(ReplicatedStorage.Communication.ServerAndClient.Effects.EffectsEvent);
local Item = require(ServerStorage.SAM.Services.Removers.Item);
local Progression = require(ServerStorage.SAM.Services.Adders.Progression);
local PlayerProgression = require(ReplicatedStorage.CAM.Global.PlayerProgression);
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);
local v1 = {};

local function findGourd(p2: userdata) -- Line: 29
    local Tool_Accessories = p2:FindFirstChild("Tool_Accessories");

    if Tool_Accessories == nil then
        return nil;
    end;

    for _, child in ipairs(Tool_Accessories:GetChildren()) do
        if child:GetAttribute("_ClanAccessory") ~= true then
            return child;
        end;
    end;

    return nil;
end;

function v1.Equipped(p3: userdata, p4: userdata, p5: table, p6: string) -- Line: 40
end;

function v1.UnEquipped(p7: userdata, p8: userdata, p9: table, p10: string) -- Line: 44
end;

function v1.MouseDown(u11: userdata, u12: userdata, u13: table, u14: string) -- Line: 48
    -- upvalues: Checker (copy), Utility (copy), ManuelCancel (copy), findGourd (copy), Item (copy), Progression (copy), PlayerProgression (copy), SignalEvent (copy), EffectsEvent (copy)
    if not Checker.check(u11) then
        return;
    end;

    if u13.Thread ~= nil then
        return;
    end;

    local Data = Utility.GetData(u11);

    if Data == nil then
        return;
    end;

    local v15 = Data.Inventory.Inventory:FindFirstChild(u14);

    if v15 == nil then
        return;
    end;

    local Amount = v15:FindFirstChild("Amount");
    local u16 = Amount == nil and true or Amount.Value <= 1;
    local v17, u18 = ManuelCancel.new(u11, 5);
    v17:Connect(function() -- Line: 62
        -- upvalues: u13 (copy)
        if u13.Thread then
            task.cancel(u13.Thread);
            u13.Thread = nil;
        end;
    end);
    u13.Thread = task.spawn(function() -- Line: 69
        -- upvalues: u16 (copy), u13 (copy), u12 (copy), Checker (ref), u18 (copy), findGourd (ref), Item (ref), u11 (copy), u14 (copy), Progression (ref), PlayerProgression (ref), SignalEvent (ref), EffectsEvent (ref)
        task.wait((u16 and 1.26 or 0.4166666666666667) - 0.05);
        u13.Thread = nil;
        local v19 = u12:FindFirstChildOfClass("Humanoid");

        if Checker.check_victim(script, u12, u12) == nil or (v19 == nil or v19.Health <= 0) then
            u18();

            return;
        end;

        local v20;

        if u16 then
            v20 = findGourd(u12);
        else
            v20 = nil;
        end;

        local v21;

        if v20 == nil then
            v21 = nil;
        else
            v21 = v20:GetPivot();
        end;

        local v22 = (v20 == nil or not v20:IsA("Model")) and 1 or v20:GetScale();

        if not Item(u11, u14, nil, nil, "Consumed") then
            u18();

            return;
        end;

        local v23 = Progression(u11, "Slayer", PlayerProgression.ProgressValue("Slayer", u14));

        if v23 ~= nil then
            SignalEvent.ToClient(u11, "CurrencyNotification", {
                Time = 5,
                Content = v23
            });
        end;

        if v21 ~= nil then
            EffectsEvent.ToAllInRange(u12, "Gourdbreak", v21, v22);
        end;

        u18();
    end);
end;

function v1.MouseUp(p24: userdata, p25: userdata, p26: table) -- Line: 113
    if p26.Thread then
        task.cancel(p26.Thread);
        p26.Thread = nil;
    end;
end;

return v1;