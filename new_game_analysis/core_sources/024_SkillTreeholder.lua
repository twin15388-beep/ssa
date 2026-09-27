-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local Stats = require(script.Parent.Stats);
local script_SkillTreeConfig = require(script.SkillTreeConfig);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local Items = require(ReplicatedStorage.CAM.Global.Collectibles.Items);
local ItemRequirements = require(ReplicatedStorage.CAM.Global.Collectibles.ItemRequirements);
local DemonArts = require(ReplicatedStorage.CAM.Global.Powers.DemonArts);
local Breathings = require(ReplicatedStorage.CAM.Global.Powers.Breathings);
local FightingStyles = require(ReplicatedStorage.CAM.Global.Powers.FightingStyles);
local Clans = require(ReplicatedStorage.CAM.Clans);
local ClanSkills = require(ReplicatedStorage.CAM.Clans.ClanSkills);
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local u1 = {
    Default = { {
            Name = "Character",
            IsBranch = true,
            Locked = false,
            AdditionalOffset = 0.47123889803846897,
            Icon = "rbxassetid://99091529957184",
            {
                Name = "Innate Skills",
                IsBranch = true,
                Locked = false,
                Icon = "rbxassetid://79876196724691",
                {
                    Name = "Double Jump",
                    Icon = "rbxassetid://125038522401568"
                },
                {
                    Name = "Wall Climb",
                    Icon = "rbxassetid://92792306247710"
                }
            },
            {
                Name = "Stats",
                IsBranch = true,
                Locked = false,
                RotationBias = 0.7853981633974483,
                Icon = "rbxassetid://101406410024507"
            }
        } },
    RequirementsSolver = {
        SkillPoints = require(script.Requirements.SkillPoints),
        Mastery = require(script.Requirements.Mastery),
        Boss = require(script.Requirements.Boss)
    }
};
local u2 = {
    Blocking = true
};

for i, v in script_SkillTreeConfig do
    local v3 = i;
    local v4 = v;
    local v5 = nil;
    local v6 = nil;

    for i2 = 1, math.floor(gameSettings.maxLevel / v.Ratio) do
        local StatValue = Stats.GetStatValue(v4.Value, i2, v4.IsRatio);
        local v7;

        if v4.IsRatio or v5 == nil then
            v7 = StatValue;
        else
            v7 = StatValue - v5 or StatValue;
        end;

        local v8 = math.round(v7 * 100) / 100;
        local v9 = {
            Name = v3,
            Icon = v4.Icon,
            ProgressionIndex = i2,
            DisplayName = `{v4.Prefix or (v4.IsRatio and "" or "+")}{v8}{v4.Postfix or ""} {v3}`
        };
        local v10;

        if v6 == nil then
            v9.IsBranch = true;
            table.insert(u1.Default[1][2], v9);
            v6 = v9;
            v5 = StatValue;
            v10 = i2;
        else
            table.insert(v6, v9);
            v5 = StatValue;
            v10 = i2;
        end;
    end;
end;

function u1.GetPowers(p11: userdata?) -- Line: 90
    -- upvalues: Players (copy), Utility (copy), Items (copy), ItemRequirements (copy), DemonArts (copy), Breathings (copy), FightingStyles (copy), ClanSkills (copy), Clans (copy)
    if p11 == nil then
        p11 = Players.LocalPlayer;
    end;

    if p11 == nil then
        return;
    end;

    local Data = Utility.GetData(p11);

    if Data ~= nil then
        local v12 = {
            Weapons = {},
            Power = {},
            Clan = {}
        };
        local v13 = {};

        for _, child in ipairs(Data.Inventory.Inventory:GetChildren()) do
            local v14 = Items[child.Name];

            if ItemRequirements.SatisfiesEquip(Data, child.Name) then
                local v15 = v14 ~= nil and v14.SkillCategory or child.Name;
                local v16 = Items[v15] or v14;

                if not (v14 == nil or (v14.Skills == nil or #v14.Skills == 1 and v14.Skills[1].Name == "Blocking") or v13[v15]) then
                    v13[v15] = true;
                    table.insert(v12.Weapons, {
                        Name = v15,
                        Icon = v16.Icon,
                        Skills = v16.Skills
                    });
                end;
            end;
        end;

        if (Data.Race.Value == "Demon" or Data.Race.Value == "Hybrid") and DemonArts[Data.Powers.DemonArt.Value] ~= nil then
            local v17 = DemonArts[Data.Powers.DemonArt.Value];
            table.insert(v12.Power, {
                Name = Data.Powers.DemonArt.Value,
                Icon = v17.Icon,
                Skills = v17.Skills
            });
        end;

        if (Data.Race.Value == "Slayer" or (Data.Race.Value == "Human" or Data.Race.Value == "Hybrid")) and Breathings[Data.Powers.Breathing.Value] ~= nil then
            local v18 = Breathings[Data.Powers.Breathing.Value];
            table.insert(v12.Power, {
                Name = Data.Powers.Breathing.Value,
                Icon = v18.Icon,
                Skills = v18.Skills
            });
        end;

        local FightingStyle = Data.Powers:FindFirstChild("FightingStyle");
        local v19;

        if FightingStyle == nil then
            v19 = nil;
        else
            v19 = FightingStyles[FightingStyle.Value] or nil;
        end;

        if v19 ~= nil and ItemRequirements.Passes(Data, v19.Requirements) then
            table.insert(v12.Power, {
                Name = FightingStyle.Value,
                Icon = v19.Icon,
                Skills = v19.Skills
            });
        end;

        local Clan = Data:FindFirstChild("Clan");
        local v20;

        if Clan == nil then
            v20 = nil;
        else
            v20 = Clan.Value or nil;
        end;

        if ClanSkills.HasSkills(v20) then
            local Clan2 = Clans.GetClan(v20);
            local Clan3 = v12.Clan;
            local v21 = {
                Name = v20,
                Icon = Clan2 ~= nil and Clan2.icon or Items[ClanSkills.TOOL_NAME].Icon,
                Skills = ClanSkills.SkillsFor(v20, p11)
            };
            table.insert(Clan3, v21);
        end;

        return v12;
    end;
end;

function u1.GetBranches() -- Line: 144
    -- upvalues: u1 (copy), u2 (copy)
    local table_clone_ret = table.clone(u1.Default);
    local Powers = u1.GetPowers();

    if Powers ~= nil then
        if #Powers.Power > 0 then
            for _, v in ipairs(Powers.Power) do
                local v22 = {
                    IsBranch = true,
                    Locked = false,
                    Name = v.Name,
                    Icon = v.Icon
                };

                for _, v2 in ipairs(v.Skills) do
                    if not u2[v2.Name] then
                        table.insert(v22, {
                            Name = v2.Name
                        });
                    end;
                end;

                table.insert(table_clone_ret, v22);
            end;
        end;

        if #Powers.Weapons > 0 then
            for _, v in ipairs(Powers.Weapons) do
                local v23 = {
                    Locked = false,
                    IsBranch = true,
                    Name = v.Name,
                    Icon = v.Icon
                };

                for _, v2 in ipairs(v.Skills) do
                    if not u2[v2.Name] then
                        table.insert(v23, {
                            Name = v2.Name
                        });
                    end;
                end;

                table.insert(table_clone_ret, v23);
            end;
        end;

        if #Powers.Clan > 0 then
            for _, v in ipairs(Powers.Clan) do
                local v24 = {
                    Locked = false,
                    IsBranch = true,
                    Name = v.Name,
                    Icon = v.Icon
                };

                for _, v2 in ipairs(v.Skills) do
                    if not u2[v2.Name] then
                        table.insert(v24, {
                            Name = v2.Name
                        });
                    end;
                end;

                table.insert(table_clone_ret, v24);
            end;
        end;
    end;

    return table_clone_ret;
end;

function u1.ResetTree(p25: userdata, p26: string?) -- Line: 215
    -- upvalues: Utility (copy), u1 (copy), Stats (copy)
    local Data = Utility.GetData(p25);

    if Data == nil then
        return;
    end;

    local SkillPointsSpent = Data:FindFirstChild("SkillPointsSpent");

    for _, child in Data.SkillTreeUnlockedList:GetChildren() do
        if p26 == nil or child.Name == p26 then
            local v27;

            if SkillPointsSpent then
                v27 = SkillPointsSpent:FindFirstChild(child.Name);
            else
                v27 = SkillPointsSpent;
            end;

            local v28;

            if v27 == nil then
                v28 = child;

                for i = 1, child.Value do
                    local RequirementsAt, v29 = Stats.GetRequirementsAt(p25, v28.Name, i);
                    local _ = i;

                    for i2, v in RequirementsAt do
                        if not u1.RequirementsSolver[i2].Persistent then
                            u1.RequirementsSolver[i2].Reset(p25, v29, v);
                        end;
                    end;
                end;
            else
                u1.RequirementsSolver.SkillPoints.Reset(p25, child.Name, v27.Value);
                v27:Destroy();
                v28 = child;
            end;

            v28:Destroy();
        end;
    end;
end;

function u1.ResetPowerBranch(p30: userdata, p31: string) -- Line: 252
    -- upvalues: Utility (copy), u1 (copy)
    local Data = Utility.GetData(p30);

    if Data == nil then
        return nil;
    end;

    local Powers = Data:FindFirstChild("Powers");
    local v32;

    if Powers == nil then
        v32 = nil;
    else
        v32 = Powers:FindFirstChild(p31) or nil;
    end;

    local v33;

    if v32 == nil then
        v33 = nil;
    else
        v33 = v32.Value or nil;
    end;

    if v33 == nil or v33 == "" then
        return nil;
    end;

    u1.ResetTree(p30, v33);

    return v33;
end;

function u1.TransferBranch(p34: userdata, p35: string, p36: string) -- Line: 271
    -- upvalues: Utility (copy), ClanSkills (copy), DemonArts (copy), Breathings (copy), FightingStyles (copy), Stats (copy), u1 (copy)
    local Data = Utility.GetData(p34);

    if Data == nil or p35 == p36 then
        return;
    end;

    local SkillTreeUnlockedList = Data.SkillTreeUnlockedList;
    local v37 = SkillTreeUnlockedList:FindFirstChild(p35);

    if v37 == nil then
        return;
    end;

    local v38 = (ClanSkills.SkillSets[p36] or DemonArts[p36] or (Breathings[p36] or FightingStyles[p36])) == nil and 0 or math.min(v37.Value, Stats.GetMaxIndexForCategory(p36));
    local v39 = SkillTreeUnlockedList:FindFirstChild(p36);

    if v38 == 0 or v39 ~= nil and v38 <= v39.Value then
        u1.ResetTree(p34, p35);

        return;
    end;

    u1.ResetTree(p34, p36);
    local v40 = 0;

    for i = v38 + 1, v37.Value do
        v40 = v40 + (Stats.GetRequirementsAt(p34, p35, i).SkillPoints or 0);
        local _ = i;
    end;

    local SkillPointsSpent = Data:FindFirstChild("SkillPointsSpent");
    local v41;

    if SkillPointsSpent then
        v41 = SkillPointsSpent:FindFirstChild(p35);
    else
        v41 = SkillPointsSpent;
    end;

    if v41 ~= nil then
        v40 = math.min(v40, v41.Value);
        local v42 = SkillPointsSpent:FindFirstChild(p36);

        if v42 == nil then
            v42 = Instance.new("IntValue");
            v42.Name = p36;
            v42.Parent = SkillPointsSpent;
        end;

        v42.Value = v42.Value + (v41.Value - v40);
        v41:Destroy();
    end;

    local SkillPoints = Data.SkillPoints;
    SkillPoints.Value = SkillPoints.Value + v40;
    local IntValue = Instance.new("IntValue");
    IntValue.Name = p36;
    IntValue.Value = v38;
    IntValue.Parent = SkillTreeUnlockedList;
    v37:Destroy();
end;

return u1;