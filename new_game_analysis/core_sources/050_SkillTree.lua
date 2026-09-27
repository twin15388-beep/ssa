-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SkillTreeConfig = require(ReplicatedStorage.CAM.Global.SkillService.SkillTreeholder.SkillTreeConfig);
local Stats = require(ReplicatedStorage.CAM.Global.SkillService.Stats);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);

return function(p1: userdata, p2: string, p3: any, p4: boolean?) -- Line: 8
    -- upvalues: Utility (copy), SkillTreeConfig (copy), Stats (copy)
    local Data = Utility.GetData(p1);

    if Data == nil then
        return 0;
    end;

    local v5 = SkillTreeConfig[p2];

    if v5 == nil then
        return 0;
    end;

    local SkillTreeUnlockedList = Data:FindFirstChild("SkillTreeUnlockedList");

    if SkillTreeUnlockedList then
        SkillTreeUnlockedList = SkillTreeUnlockedList:FindFirstChild(p2);
    end;

    local v6 = SkillTreeUnlockedList and SkillTreeUnlockedList.Value or 0;

    if v6 <= 0 then
        return 0;
    end;

    local StatValue = Stats.GetStatValue(v5.Value, v6, v5.IsRatio);

    if p4 and v5.IsRatio then
        StatValue = StatValue - 1;
    end;

    return StatValue;
end;