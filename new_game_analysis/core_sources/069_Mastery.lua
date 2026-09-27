-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local BunchaIcons = require(ReplicatedStorage.CAM.Global.BunchaIcons);
local Stats = require(ReplicatedStorage.CAM.Global.SkillService.Stats);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local MasterySource = require(ReplicatedStorage.CAM.Global.Collectibles.MasterySource);
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local v1 = {
    DisplayName = "Mastery",
    Persistent = true,
    Icon = BunchaIcons.Mastery
};
local script_Name = script.Name;

local function getMasteryInfo(p2: string) -- Line: 15
    -- upvalues: Stats (copy), gameSettings (copy), MasterySource (copy)
    local SkillInfo = Stats.GetSkillInfo(p2);

    if SkillInfo == nil then
        return nil, gameSettings.expPerMasteryDefault;
    end;

    local v3 = MasterySource(SkillInfo.Category);

    if v3 == nil or v3.Mastery == false then
        return nil, gameSettings.expPerMasteryDefault;
    end;

    local v4;

    if type(v3.Mastery) == "string" then
        v4 = v3.Mastery;
    elseif type(v3.Mastery) == "table" then
        v4 = v3.Mastery.Value or SkillInfo.Category;
    else
        v4 = SkillInfo.Category;
    end;

    return v4, type(v3.Mastery) == "table" and v3.Mastery.IncrementAmount or gameSettings.expPerMasteryDefault;
end;

function v1.CanBuy(p5: userdata, p6: string, p7: number?) -- Line: 35
    -- upvalues: Utility (copy), Stats (copy), script_Name (copy), getMasteryInfo (copy)
    if p5 == nil or p6 == nil then
        return;
    end;

    local Data = Utility.GetData(p5);

    if Data ~= nil then
        if p7 == nil then
            p7 = Stats.GetRequirements(p5, p6);

            if p7 then
                p7 = p7[script_Name];
            end;
        end;

        if p7 == nil or p7 <= 0 then
            return true;
        end;

        local v8, v9 = getMasteryInfo(p6);

        if v8 == nil then
            return true;
        end;

        local v10 = Data.MasteryProgressionList:FindFirstChild(v8);

        if v10 == nil then
            return false;
        end;

        local Goal = v10:FindFirstChild("Goal");

        if Goal == nil then
            return false;
        end;

        return p7 <= math.floor(Goal.Value / v9);
    end;
end;

function v1.Buy(p11: userdata, p12: string, p13: number?) -- Line: 54
end;

return v1;