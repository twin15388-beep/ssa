-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CAM = ReplicatedStorage:WaitForChild("CAM");
local Global = CAM:WaitForChild("Global");
local Powers = Global:WaitForChild("Powers");
local Items = ReplicatedStorage:WaitForChild("Items");
local PlayerProfile = require(Global:WaitForChild("PlayerProfile"));
require(Global.Types.ItemTypes);
local v1 = {};

for _, v in ipairs(Items:QueryDescendants("ModuleScript:not([$ignore])")) do
    v1[v.Name] = require(v);
    local v2 = v:FindFirstAncestorOfClass("Folder");

    if v1[v.Name].Category == nil then
        v1[v.Name].Category = v2 == nil and "Items" or (v2.Name or "Items");
    end;

    if v1[v.Name].InventoryCategory == nil then
        local v3;

        if v2 == nil then
            v3 = nil;
        else
            v3 = v2:GetAttribute("Category");
        end;

        local v4 = v1[v.Name];

        if type(v3) ~= "string" or v3 == "" then
            v3 = v2 == nil and "Items" or v2.Name;
        end;

        v4.InventoryCategory = v3;
    end;
end;

function doSkillThing(p5: string, p6: any, p7: string, p8: number)
    -- upvalues: PlayerProfile (copy)
    if not PlayerProfile.skill_info[p6.Name] then
        PlayerProfile.skill_info[p6.Name] = {
            Cooldown = p6.CoolDown,
            Icon = p6.icon or nil,
            Max_Hold_Time = p6.Max_Hold or nil,
            UnholdStatus = p6.UnholdStatus,
            CoolDownName = p6.CoolDownName,
            CooldownGroup = p6.CooldownGroup,
            SkillTreeRequirements = p6.SkillTreeRequirements,
            Boss = p6.Boss,
            Stamina = p6.Stamina,
            RequiresModeBar = p6.RequiresModeBar,
            RequiresAura = p6.RequiresAura,
            Index = p8,
            CategoryType = p7 or "Weapon",
            Category = p5
        };
    end;
end;

function lookInside(p9: string, p10: any, p11: string)
    -- upvalues: PlayerProfile (copy)
    if p10 == nil or p9 == nil then
        return;
    end;

    if PlayerProfile.mastery_categories._index == nil then
        PlayerProfile.mastery_categories._index = {};
    end;

    if not PlayerProfile.mastery_categories._index[p9] then
        PlayerProfile.mastery_categories._index[p9] = true;
        table.insert(PlayerProfile.mastery_categories, p9);
    end;

    if type(p10.Mastery) == "string" then
        PlayerProfile.mastery_name_set[p10.Mastery] = true;
    end;

    if p10.Skills then
        local v12 = p10.SkillCategory or p9;
        local v13 = 0;

        if p10.Skills[1].Name == "Blocking" then
            v13 = v13 + 1;
        end;

        for i, v in p10.Skills do
            if not PlayerProfile.skill_info[v.Name] then
                if v.State then
                    local v14 = v;
                    local v15 = i;

                    for _, v2 in pairs(v) do
                        if typeof(v2) == "table" then
                            v2.CoolDownName = v2.CoolDownName or v14.Name;
                            doSkillThing(v12, v2, p11, v15 - v13);
                        end;
                    end;
                else
                    doSkillThing(v12, v, p11, i - v13);
                end;
            end;
        end;
    end;
end;

for i, v in require(Powers.DemonArts) do
    lookInside(i, v, "Evil Art");
end;

for i, v in require(Powers.Breathings) do
    lookInside(i, v, "Breathing");
end;

for i, v in require(Powers.FightingStyles) do
    lookInside(i, v, "Fighting Style");
end;

for i, v in require(Global:WaitForChild("PlayerProgression")).GrantedSkills do
    doSkillThing(i, v.Skill, "Progression", 1);
end;

for i, v in v1 do
    lookInside(i, v, "Weapon");
end;

for i, v in require(CAM:WaitForChild("Clans"):WaitForChild("ClanSkills")).SkillSets do
    lookInside(i, v, "Clan");
end;

return v1;