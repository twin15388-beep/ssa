-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Items = require(ReplicatedStorage.CAM.Global.Collectibles.Items);
local PlayerProfile = require(ReplicatedStorage.CAM.Global.PlayerProfile);
local Breathings = require(ReplicatedStorage.CAM.Global.Powers.Breathings);
local DemonArts = require(ReplicatedStorage.CAM.Global.Powers.DemonArts);
local FightingStyles = require(ReplicatedStorage.CAM.Global.Powers.FightingStyles);
local Resolve = require(ReplicatedStorage.CAM.Global.Powers.Resolve);
require(ReplicatedStorage.CAM.Global.Types.ItemTypes);
require(ReplicatedStorage.CAM.Global.Types.MiscTypes);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local SkillTreeConfig = require(ReplicatedStorage.CAM.Global.SkillService.SkillTreeholder.SkillTreeConfig);
local Clans = require(ReplicatedStorage.CAM.Clans);
local ClanSkills = require(ReplicatedStorage.CAM.Clans.ClanSkills);
local MasterySource = require(ReplicatedStorage.CAM.Global.Collectibles.MasterySource);
local FightingStyles2 = require(ReplicatedStorage.CAM.Global.Collectibles.FightingStyles);
local PlayerProgression = require(ReplicatedStorage.CAM.Global.PlayerProgression);
local u1 = {};
local u2 = {
    SkillPoints = {
        Start = 3,
        IncrementAmount = 3,
        TreeIndexFactor = 1
    }
};
local u3 = {
    Start = 14,
    IncrementAmount = 1,
    TreeIndexFactor = 13,
    PositionOffset = -1
};

function u1.GetStatValue(p4: any, p5: number, p6: boolean?) -- Line: 22
    -- upvalues: gameSettings (copy)
    local v7 = p5 or 1;
    local v8 = p6 and v7 and v7 or v7 - 1;
    local v9 = p4 or 1 + (gameSettings.defaultSkillStatIncrementFactor or 0) * v8;

    if typeof(v9) == "table" then
        if v9.Custom ~= nil and v9.Custom[v7] then
            return v9.Custom[v7];
        end;

        v9 = (v9.Start or 1) + (v9.StepFactor or (gameSettings.defaultSkillStatIncrementFactor or 0)) * v8 + (v9.StepAccel or 0) * (v8 * (v8 - 1) / 2);
    end;

    return v9;
end;

function u1.IsSkillUnlocked(p10: userdata, p11: string, p12: number?) -- Line: 38
    -- upvalues: gameSettings (copy), Utility (copy), u1 (copy), Clans (copy), ReplicatedStorage (copy)
    if p10 == nil or p11 == nil then
        return false;
    end;

    if gameSettings.manuallyUnlockedSkills[p11] then
        return true;
    end;

    local Data = Utility.GetData(p10);

    if Data == nil then
        return false;
    end;

    local SkillInfoFor = u1.GetSkillInfoFor(p10, p11);

    if SkillInfoFor ~= nil and (SkillInfoFor.CategoryType == "Clan" and Clans.TestClans[SkillInfoFor.Category] ~= nil) then
        return true;
    end;

    if require(ReplicatedStorage.CAM.Global.CustomPower).Holds(p10, p11) then
        return true;
    end;

    if SkillInfoFor ~= nil then
        p11 = SkillInfoFor.Category or p11;
    end;

    local v13 = SkillInfoFor ~= nil and SkillInfoFor.Index or (p12 or 1);
    local SkillTreeUnlockedList = Data:FindFirstChild("SkillTreeUnlockedList");

    if SkillTreeUnlockedList then
        SkillTreeUnlockedList = SkillTreeUnlockedList:FindFirstChild(p11);
    end;

    local v14;

    if SkillTreeUnlockedList == nil then
        v14 = false;
    else
        v14 = v13 <= SkillTreeUnlockedList.Value;
    end;

    return v14;
end;

local function buildRequirements(p15: any, p16: string, p17: number) -- Line: 63
    -- upvalues: Breathings (copy), DemonArts (copy), FightingStyles (copy), SkillTreeConfig (copy), Items (copy), u2 (copy), MasterySource (copy), u3 (copy), gameSettings (copy)
    local v18;

    if p15 == nil then
        v18 = nil;
    elseif p15.CategoryType == "Breathing" or (p15.CategoryType == "Evil Art" or p15.CategoryType == "Fighting Style") then
        v18 = Breathings[p15.Category] ~= nil and Breathings[p15.Category].SkillTreeRule or DemonArts[p15.Category] ~= nil and DemonArts[p15.Category].SkillTreeRule;

        if not v18 then
            if FightingStyles[p15.Category] == nil then
                v18 = false;
            else
                v18 = FightingStyles[p15.Category].SkillTreeRule;
            end;
        end;
    elseif SkillTreeConfig[p16] == nil then
        if Items[p15.Category] == nil then
            v18 = false;
        else
            v18 = Items[p15.Category].SkillTreeRule;
        end;
    else
        local v19 = SkillTreeConfig[p16];
        v18 = v19.Rule and {
            SkillPoints = v19.Rule
        };
    end;

    local v20 = v18 or u2;

    if p15 ~= nil and (p15.CategoryType == "Breathing" or (p15.CategoryType == "Evil Art" or (p15.CategoryType == "Weapon" or p15.CategoryType == "Fighting Style"))) then
        local v21 = MasterySource(p15.Category);

        if v21 and (v21.Mastery ~= false and v20.Mastery == nil) then
            v20 = table.clone(v20);
            v20.Mastery = u3;
        end;
    end;

    local v22 = {};

    for i, v in v20 do
        local v23 = p17 + (v.PositionOffset or 0);

        if v23 > 0 then
            local math_round_ret = math.round(v.Start + (v.CustomPosValues ~= nil and v.CustomPosValues[v23] or (v.IncrementAmount or gameSettings.defaultSkillTreeItemPointIncrement) * ((v.TreeIndexFactor or 1) * (v23 - 1))));

            if math_round_ret > 0 then
                v22[i] = math_round_ret;
            end;
        end;
    end;

    if p15 ~= nil and p15.Boss ~= nil then
        v22.Boss = p15.Boss;
    end;

    return v22;
end;

local function nodeInfoAt(p24: userdata, p25: string, p26: number) -- Line: 112
    -- upvalues: SkillTreeConfig (copy), ClanSkills (copy), Breathings (copy), DemonArts (copy), FightingStyles (copy), u1 (copy), PlayerProfile (copy), Items (copy)
    if SkillTreeConfig[p25] ~= nil then
        return p25, SkillTreeConfig[p25];
    end;

    local v27 = ClanSkills.SkillSets[p25] or Breathings[p25] or (DemonArts[p25] or FightingStyles[p25]);

    if v27 ~= nil then
        local v28 = 0;

        for _, v in v27.Skills do
            if v.Name ~= "Blocking" then
                v28 = v28 + 1;

                if v28 == p26 then
                    return v.Name, u1.GetSkillInfoFor(p24, v.Name);
                end;
            end;
        end;

        return nil, nil;
    end;

    for i, v in PlayerProfile.skill_info do
        if v.Category == p25 and v.Index == p26 then
            return i, v;
        end;
    end;

    local v29 = Items[p25];
    local v30;

    if v29 == nil then
        v30 = nil;
    else
        v30 = v29.Skills ~= nil and v29.Skills[p26] or nil;
    end;

    if v30 == nil then
        return nil, nil;
    end;

    return v30.Name, u1.GetSkillInfo(v30.Name);
end;

function u1.GetRequirementsAt(p31: userdata, p32: string, p33: number) -- Line: 141
    -- upvalues: nodeInfoAt (copy), buildRequirements (copy)
    local v34, v35 = nodeInfoAt(p31, p32, p33);

    return v35 ~= nil and v35.SkillTreeRequirements or buildRequirements(v35, p32, p33), v34 or p32;
end;

function u1.GetRequirements(p36: userdata, p37: string, p38: number?) -- Line: 147
    -- upvalues: Utility (copy), u1 (copy), buildRequirements (copy), MasterySource (copy), gameSettings (copy), ReplicatedStorage (copy), nodeInfoAt (copy)
    if p36 == nil or p37 == nil then
        return;
    end;

    local Data = Utility.GetData(p36);

    if Data ~= nil then
        local SkillInfoFor = u1.GetSkillInfoFor(p36, p37);
        local v39;

        if SkillInfoFor == nil then
            v39 = p37;
        else
            v39 = SkillInfoFor.Category or p37;
        end;

        local v40 = SkillInfoFor == nil and 1 or (SkillInfoFor.Index or (p38 or 1));
        local v41 = u1.IsSkillUnlocked(p36, p37, v40);
        local v42 = SkillInfoFor and SkillInfoFor.SkillTreeRequirements or buildRequirements(SkillInfoFor, v39, v40);

        if v41 and (v42 and v42.Mastery) then
            local v43;

            if SkillInfoFor then
                v43 = MasterySource(SkillInfoFor.Category);
            else
                v43 = SkillInfoFor;
            end;

            if v43 and v43.Mastery ~= false then
                local v44;

                if type(v43.Mastery) == "string" then
                    v44 = v43.Mastery;
                elseif type(v43.Mastery) == "table" then
                    v44 = v43.Mastery.Value or SkillInfoFor.Category;
                else
                    v44 = SkillInfoFor.Category;
                end;

                local v45 = type(v43.Mastery) == "table" and v43.Mastery.IncrementAmount or gameSettings.expPerMasteryDefault;
                local v46 = Data.MasteryProgressionList:FindFirstChild(v44);
                local v47 = 0;

                if v46 then
                    local Goal = v46:FindFirstChild("Goal");

                    if Goal then
                        v47 = math.floor(Goal.Value / v45);
                    end;
                end;

                if v47 < v42.Mastery then
                    v42 = {
                        Mastery = v42.Mastery
                    };
                    v41 = false;
                end;
            end;
        end;

        if v41 and (v42 and (v42.Boss and not require(ReplicatedStorage.CAM.Global.CustomPower).Holds(p36, p37))) then
            local Boss = Data.MetRequirements.Boss;

            if Boss:FindFirstChild(p37) == nil and Boss:FindFirstChild(nodeInfoAt(p36, v39, v40) or p37) == nil then
                v42 = {
                    Boss = v42.Boss
                };
                v41 = false;
            end;
        end;

        return v42, v41;
    end;
end;

local u48 = {
    Breathing = {
        Human = true,
        Slayer = true,
        Hybrid = true
    },
    ["Evil Art"] = {
        Demon = true,
        Hybrid = true
    }
};
local u49 = {
    Breathing = "Breathing",
    ["Evil Art"] = "DemonArt"
};
local u50 = {
    Breathing = Breathings,
    ["Evil Art"] = DemonArts
};

function u1.SourceCheck(p51: userdata, u52: string) -- Line: 229
    -- upvalues: PlayerProgression (copy), PlayerProfile (copy), Utility (copy), u49 (copy), u50 (copy), Items (copy), u48 (copy), Resolve (copy), FightingStyles2 (copy), ClanSkills (copy)
    local v53 = PlayerProgression.GrantedSkills[u52];
    local v54;

    if v53 == nil then
        v54 = nil;
    else
        v54 = v53.Side;
    end;

    if v54 ~= nil then
        if PlayerProgression.Get(p51, v54) == nil then
            return true;
        end;

        if PlayerProgression.HasGrantedSkill(p51, u52) then
            return true;
        end;

        return false, {
            SkillCategoryType = "Progression",
            Skill = u52,
            SkillCategory = `{v54} ladder`
        };
    end;

    local u55 = PlayerProfile.skill_info[u52];

    if u55 == nil or (u55.CategoryType == nil or u55.Category == nil) then
        return true;
    end;

    local CategoryType = u55.CategoryType;

    if CategoryType ~= "Weapon" and (CategoryType ~= "Breathing" and (CategoryType ~= "Evil Art" and (CategoryType ~= "Fighting Style" and CategoryType ~= "Clan"))) then
        return true;
    end;

    local Data = Utility.GetData(p51);

    if Data == nil then
        return true;
    end;

    local Inventory = Data:FindFirstChild("Inventory");
    local v56;

    if Inventory == nil then
        v56 = nil;
    else
        v56 = Inventory:FindFirstChild("Inventory") or nil;
    end;

    if v56 == nil then
        return true;
    end;

    local Powers = Data:FindFirstChild("Powers");
    local Race = Data:FindFirstChild("Race");
    local u57;

    if Race == nil then
        u57 = nil;
    else
        u57 = Race.Value or nil;
    end;

    for i, v in u49 do
        local v58;

        if Powers == nil then
            v58 = nil;
        else
            v58 = Powers:FindFirstChild(v) or nil;
        end;

        local v59;

        if v58 == nil then
            v59 = nil;
        else
            v59 = u50[i][v58.Value] or nil;
        end;

        if type(v59) == "table" and (v59.CustomPower == true and type(v59.Skills) == "table") then
            for _, v2 in v59.Skills do
                if v2.Name == u52 then
                    return true;
                end;

                if v2.State == true then
                    for _, v3 in v2 do
                        if typeof(v3) == "table" and v3.Name == u52 then
                            return true;
                        end;
                    end;
                end;
            end;
        end;
    end;

    local function fail() -- Line: 287
        -- upvalues: Data (copy), Powers (copy), u52 (copy), u55 (copy), CategoryType (copy), u57 (copy)
        local Clan = Data:FindFirstChild("Clan");
        local v60;

        if Powers == nil then
            v60 = nil;
        else
            v60 = Powers:FindFirstChild("Breathing") or nil;
        end;

        local v61;

        if Powers == nil then
            v61 = nil;
        else
            v61 = Powers:FindFirstChild("DemonArt") or nil;
        end;

        local v62;

        if Powers == nil then
            v62 = nil;
        else
            v62 = Powers:FindFirstChild("FightingStyle") or nil;
        end;

        local v63 = {
            Skill = u52,
            SkillCategory = u55.Category,
            SkillCategoryType = CategoryType,
            Race = u57
        };
        local v64;

        if v60 == nil then
            v64 = nil;
        else
            v64 = v60.Value or nil;
        end;

        v63.Breathing = v64;
        local v65;

        if v61 == nil then
            v65 = nil;
        else
            v65 = v61.Value or nil;
        end;

        v63.EvilArt = v65;
        local v66;

        if v62 == nil then
            v66 = nil;
        else
            v66 = v62.Value or nil;
        end;

        v63.FightingStyle = v66;
        local v67;

        if Clan == nil then
            v67 = nil;
        else
            v67 = Clan.Value or nil;
        end;

        v63.Clan = v67;

        return false, v63;
    end;

    if CategoryType == "Weapon" then
        if v56:FindFirstChild(u55.Category) ~= nil then
            return true;
        end;

        for _, child in v56:GetChildren() do
            local v68 = Items[child.Name];

            if v68 ~= nil and v68.SkillCategory == u55.Category then
                return true;
            end;
        end;

        return fail();
    end;

    if CategoryType == "Breathing" or CategoryType == "Evil Art" then
        local v69;

        if Powers == nil then
            v69 = nil;
        else
            v69 = Powers:FindFirstChild(u49[CategoryType]) or nil;
        end;

        local v70;

        if v69 == nil then
            v70 = nil;
        else
            v70 = v69.Value or nil;
        end;

        if v70 ~= u55.Category then
            return fail();
        end;

        if u57 ~= nil and u48[CategoryType][u57] ~= true then
            return fail();
        end;

        local v71 = u50[CategoryType][v70];

        for _, child in v56:GetChildren() do
            local v72 = Items[child.Name];
            local v73;

            if v72 == nil then
                v73 = nil;
            else
                v73 = v72[u49[CategoryType]] or nil;
            end;

            if v73 ~= nil and (Resolve.LaneCarries(v73, v70) and (v71 == nil or (v71.Category == nil or v71.Category == v72.Category))) then
                return true;
            end;
        end;

        return fail();
    end;

    if CategoryType == "Fighting Style" then
        return FightingStyles2.For(p51) == u55.Category and true or fail();
    end;

    if CategoryType ~= "Clan" then
        return true;
    end;

    if v56:FindFirstChild(ClanSkills.TOOL_NAME) == nil then
        return fail();
    end;

    local Clan = Data:FindFirstChild("Clan");
    local v74;

    if Clan == nil then
        v74 = nil;
    else
        v74 = Clan.Value or nil;
    end;

    for _, v in ClanSkills.SkillsFor(v74, p51) do
        if v.Name == u52 then
            return true;
        end;

        if v.State == true then
            for _, v2 in v do
                if typeof(v2) == "table" and v2.Name == u52 then
                    return true;
                end;
            end;
        end;
    end;

    return fail();
end;

function u1.GetSkillInfo(p75: string) -- Line: 346
    -- upvalues: SkillTreeConfig (copy), PlayerProfile (copy)
    if p75 ~= nil then
        return SkillTreeConfig[p75] or PlayerProfile.skill_info[p75];
    end;
end;

function u1.GetSkillInfoFor(p76: userdata, p77: string) -- Line: 362
    -- upvalues: u1 (copy), Utility (copy), ClanSkills (copy)
    local SkillInfo = u1.GetSkillInfo(p77);

    if SkillInfo == nil or (SkillInfo.CategoryType ~= "Clan" or p76 == nil) then
        return SkillInfo;
    end;

    local Data = Utility.GetData(p76);
    local v78;

    if Data == nil then
        v78 = nil;
    else
        v78 = Data:FindFirstChild("Clan") or nil;
    end;

    local v79;

    if v78 == nil then
        v79 = nil;
    else
        v79 = v78.Value or nil;
    end;

    if v79 == nil or v79 == SkillInfo.Category then
        return SkillInfo;
    end;

    local v80 = ClanSkills.SkillSets[v79];

    if v80 == nil then
        return SkillInfo;
    end;

    local v81 = 0;

    for _, v in v80.Skills do
        if v.Name ~= "Blocking" then
            v81 = v81 + 1;

            if v.Name == p77 then
                local table_clone_ret = table.clone(SkillInfo);
                table_clone_ret.Category = v79;
                table_clone_ret.Index = v81;

                return table_clone_ret;
            end;
        end;
    end;

    return SkillInfo;
end;

function u1.GetMaxIndexForCategory(p82: string) -- Line: 389
    -- upvalues: SkillTreeConfig (copy), gameSettings (copy), ClanSkills (copy), Breathings (copy), DemonArts (copy), FightingStyles (copy), Items (copy), PlayerProfile (copy)
    if SkillTreeConfig[p82] ~= nil then
        return math.floor(gameSettings.maxLevel / SkillTreeConfig[p82].Ratio);
    end;

    local v83 = ClanSkills.SkillSets[p82] or Breathings[p82] or (DemonArts[p82] or FightingStyles[p82]);

    if v83 ~= nil then
        local v84 = 0;

        for _, v in v83.Skills do
            if v.Name ~= "Blocking" then
                v84 = v84 + 1;
            end;
        end;

        return v84;
    end;

    local v85 = Items[p82];

    if v85 ~= nil and v85.Skills ~= nil then
        return #v85.Skills;
    end;

    local v86 = 0;

    for _, v in PlayerProfile.skill_info do
        if v.Category == p82 and (typeof(v.Index) == "number" and v86 < v.Index) then
            v86 = v.Index;
        end;
    end;

    return v86 <= 0 and 1 or v86;
end;

function u1.GetSkillCategory(p87: string) -- Line: 418
    -- upvalues: PlayerProfile (copy)
    if p87 ~= nil then
        if PlayerProfile.skill_info[p87] == nil then
            return nil;
        end;

        return PlayerProfile.skill_info[p87].CategoryType;
    end;
end;

return u1;