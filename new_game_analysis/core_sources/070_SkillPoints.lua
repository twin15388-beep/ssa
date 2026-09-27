-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local BunchaIcons = require(ReplicatedStorage.CAM.Global.BunchaIcons);
local Stats = require(ReplicatedStorage.CAM.Global.SkillService.Stats);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local v1 = {
    DisplayName = "Skill Points",
    Persistent = false,
    Icon = BunchaIcons.SkillPoints
};
local script_Name = script.Name;

function v1.CanBuy(p2: userdata, p3: string, p4: number?) -- Line: 11
    -- upvalues: Utility (copy), Stats (copy), script_Name (copy)
    if p2 == nil or p3 == nil then
        return;
    end;

    local Data = Utility.GetData(p2);

    if Data ~= nil then
        if p4 == nil then
            p4 = Stats.GetRequirements(p2, p3)[script_Name];
        end;

        return p4 ~= nil and p4 <= Data.SkillPoints.Value;
    end;
end;

function v1.Buy(p5: userdata, p6: string, p7: number?) -- Line: 27
    -- upvalues: Utility (copy), Stats (copy), script_Name (copy)
    if p5 == nil or p6 == nil then
        return;
    end;

    local Data = Utility.GetData(p5);

    if Data == nil then
        return;
    end;

    if p7 == nil then
        p7 = Stats.GetRequirements(p5, p6)[script_Name];
    end;

    if p7 ~= nil then
        local SkillPoints = Data.SkillPoints;
        SkillPoints.Value = SkillPoints.Value - p7;
    end;
end;

function v1.Reset(p8: userdata, p9: string, p10: number) -- Line: 39
    -- upvalues: Utility (copy)
    local Data = Utility.GetData(p8);

    if Data == nil then
        return;
    end;

    local SkillPoints = Data.SkillPoints;
    SkillPoints.Value = SkillPoints.Value + p10;
end;

return v1;