-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Stats = require(ReplicatedStorage.CAM.Global.SkillService.Stats);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local LiveConfig = require(ReplicatedStorage.CAM.Global.LiveConfig);

return {
    Persistent = true,
    HideValue = true,
    BackgroundImage = "rbxassetid://92426175647542",
    IconColor = Color3.new(1, 1, 1),
    IconCornerRadius = UDim.new(1, 0),

    DisplayName = function(p1: string) -- Line: 13, Name: DisplayName
        -- upvalues: Stats (copy)
        local SkillInfo = Stats.GetSkillInfo(p1);

        return "Defeat " .. (SkillInfo and SkillInfo.Boss or "Boss");
    end,

    Icon = function(p2: string) -- Line: 17, Name: Icon
        -- upvalues: Stats (copy), LiveConfig (copy)
        local SkillInfo = Stats.GetSkillInfo(p2);

        if SkillInfo ~= nil and SkillInfo.Boss ~= nil then
            local v3 = LiveConfig.get("NpcDataTable");

            if v3 then
                v3 = v3[SkillInfo.Boss];
            end;

            if v3 then
                return v3.Icon;
            end;
        end;

        return "";
    end,

    CanBuy = function(p4: userdata, p5: string, p6: string?) -- Line: 30, Name: CanBuy
        -- upvalues: Utility (copy)
        local Data = Utility.GetData(p4);

        if Data == nil then
            return false;
        end;

        return Data.MetRequirements.Boss:FindFirstChild(p5) ~= nil;
    end,

    Buy = function(p7: userdata, p8: string, p9: string?) -- Line: 36, Name: Buy
    end,

    Grant = function(p10: userdata, p11: string) -- Line: 40, Name: Grant
        -- upvalues: Utility (copy)
        local Data = Utility.GetData(p10);

        if Data == nil or Data.MetRequirements.Boss:FindFirstChild(p11) ~= nil then
            return false;
        end;

        local BoolValue = Instance.new("BoolValue");
        BoolValue.Name = p11;
        BoolValue.Parent = Data.MetRequirements.Boss;

        return true;
    end
};