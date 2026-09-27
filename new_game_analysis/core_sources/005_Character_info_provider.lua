-- Decompiled with Potassium's decompiler.

local table_insert = table.insert;
local u1 = {
    BossInfo = {}
};
local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local u2 = RunService:IsClient();
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local Items = require(ReplicatedStorage.CAM.Global.Collectibles.Items);
local AiMimic = require(ReplicatedStorage.CAM.AiStuffGlobal.AiMimic);
local LocalPlayer = game.Players.LocalPlayer;
local u3 = {
    run = "walk"
};

function u1.Get_equipped_tool(p4) -- Line: 15
    -- upvalues: AiMimic (copy), u1 (copy)
    if p4 == nil then
        return;
    end;

    local v5;

    if p4.Parent == game.Players then
        v5 = p4;
    else
        v5 = game.Players:GetPlayerFromCharacter(p4);

        if v5 == nil then
            local v6 = AiMimic:Get(p4, "Equipped_Tool");

            if v6 then
                return {
                    Name = v6
                };
            end;

            return;
        end;
    end;

    local v7 = v5:FindFirstChild("Items_Config") or v5:FindFirstChild("Items_ConfigServer");

    if v7 and v7:FindFirstChild("Equipped") ~= nil then
        return u1.getEquippedItems(v5, v7.Equipped.Value);
    end;
end;

function u1.GetItemNameOnSlot(p8: string, p9: string) -- Line: 34
    -- upvalues: Utility (copy)
    if p8 == nil or p9 == nil then
        return "";
    end;

    local Data = Utility.GetData(p8, nil, true);

    if Data ~= nil and (Data:FindFirstChild("Inventory") and Data.Inventory:FindFirstChild("Inventory")) then
        for _, child in pairs(Data.Inventory.Inventory:GetChildren()) do
            if child.Id.Value == Data.Inventory.Toolbar[p9].Value then
                return child.Name;
            end;
        end;
    end;

    return "";
end;

function u1.GetItemOnSlot(p10: string, p11: string) -- Line: 46
    -- upvalues: Utility (copy)
    if p10 or p11 == nil then
        return nil;
    end;

    local Data = Utility.GetData(p10, nil, true);

    if Data ~= nil and (Data:FindFirstChild("Inventory") and Data.Inventory:FindFirstChild("Inventory")) then
        for _, child in pairs(Data.Inventory.Inventory:GetChildren()) do
            if child.Id.Value == Data.Inventory.Toolbar[p11].Value then
                return child;
            end;
        end;
    end;
end;

function u1.GetEquippedPowers(p12) -- Line: 57
    -- upvalues: Utility (copy)
    if p12 ~= nil then
        local Data = Utility.GetData(p12);

        if Data ~= nil then
            local Value = Data.Race.Value;
            local Value2 = Data.Powers.Breathing.Value;
            local Value3 = Data.Powers.DemonArt.Value;
            local v13 = {};

            if Value == "Hybrid" then
                table.insert(v13, Value2);
                table.insert(v13, Value3);

                return v13;
            end;

            if Value == "Demon" then
                table.insert(v13, Value3);

                return v13;
            end;

            table.insert(v13, Value2);

            return v13;
        end;
    end;

    return {};
end;

function u1.HasPowerAccess(p14: userdata, p15: string) -- Line: 80
    -- upvalues: ReplicatedStorage (copy), Utility (copy)
    if p14 == nil or p15 == nil then
        return false;
    end;

    local Breathings = require(ReplicatedStorage.CAM.Global.Powers.Breathings);
    local DemonArts = require(ReplicatedStorage.CAM.Global.Powers.DemonArts);
    local FightingStyles = require(ReplicatedStorage.CAM.Global.Powers.FightingStyles);
    local v16 = Breathings[p15] ~= nil;
    local v17 = DemonArts[p15] ~= nil;
    local v18 = FightingStyles[p15];

    if not (v16 or (v17 or v18 ~= nil)) then
        return true;
    end;

    local Data = Utility.GetData(p14);

    if Data == nil then
        return false;
    end;

    if v18 ~= nil then
        return require(ReplicatedStorage.CAM.Global.Collectibles.ItemRequirements).Passes(Data, v18.Requirements);
    end;

    local Value = Data.Race.Value;

    if Value == "Hybrid" then
        return true;
    end;

    if Value == "Demon" then
        return v17;
    end;

    return v16;
end;

function u1.IsSkillAvailable(p19: userdata, p20: string) -- Line: 103
    -- upvalues: ReplicatedStorage (copy), u1 (copy), Utility (copy), Items (copy)
    if p19 == nil or p20 == nil then
        return false;
    end;

    local Stats = require(ReplicatedStorage.CAM.Global.SkillService.Stats);
    local SkillInfo = Stats.GetSkillInfo(p20);

    if SkillInfo == nil then
        return false;
    end;

    if SkillInfo.Category ~= nil and not u1.HasPowerAccess(p19, SkillInfo.Category) then
        return false;
    end;

    local Data = Utility.GetData(p19);

    if Data == nil then
        return false;
    end;

    if SkillInfo.CategoryType == "Weapon" and SkillInfo.Category ~= nil then
        local Inventory = Data:FindFirstChild("Inventory");

        if Inventory then
            Inventory = Inventory:FindFirstChild("Inventory");
        end;

        if Inventory == nil then
            return false;
        end;

        local v21 = false;

        for _, child in Inventory:GetChildren() do
            local v22 = Items[child.Name];

            if v22 ~= nil and (v22.SkillCategory or child.Name) == SkillInfo.Category then
                v21 = true;
                break;
            end;
        end;

        if not v21 then
            return false;
        end;
    end;

    if SkillInfo.CategoryType == "Fighting Style" and SkillInfo.Category ~= nil then
        local Powers = Data:FindFirstChild("Powers");
        local v23;

        if Powers == nil then
            v23 = nil;
        else
            v23 = Powers:FindFirstChild("FightingStyle") or nil;
        end;

        if v23 == nil or v23.Value ~= SkillInfo.Category then
            return false;
        end;
    end;

    local SkillTreeUnlockedList = Data:FindFirstChild("SkillTreeUnlockedList");

    if SkillTreeUnlockedList == nil then
        return false;
    end;

    local v24 = SkillInfo.Category or p20;
    local v25 = SkillInfo.Index or 1;

    if SkillInfo.Index == nil or SkillInfo.Category == nil then
        if SkillTreeUnlockedList:FindFirstChild(p20) == nil then
            return Data.MetRequirements.Boss:FindFirstChild(p20) == nil;
        end;

        return false;
    end;

    local v26 = SkillTreeUnlockedList:FindFirstChild(v24);
    local v27 = v26 and v26.Value or 0;

    if v25 <= v27 and SkillInfo.Boss == nil then
        return false;
    end;

    if Data.MetRequirements.Boss:FindFirstChild(p20) ~= nil then
        return false;
    end;

    if v25 <= 1 then
        return true;
    end;

    if v27 < v25 - 1 then
        return false;
    end;

    local _, v28 = Stats.GetRequirementsAt(p19, v24, v25 - 1);

    return select(2, Stats.GetRequirements(p19, v28)) == true;
end;

function u1.GetSkillDimReason(p29: userdata, p30: string) -- Line: 153
    -- upvalues: ReplicatedStorage (copy), Utility (copy), u1 (copy), Items (copy)
    if p29 == nil or p30 == nil then
        return nil;
    end;

    local Stats = require(ReplicatedStorage.CAM.Global.SkillService.Stats);
    local Breathings = require(ReplicatedStorage.CAM.Global.Powers.Breathings);
    local DemonArts = require(ReplicatedStorage.CAM.Global.Powers.DemonArts);
    local SkillInfo = Stats.GetSkillInfo(p30);

    if SkillInfo == nil then
        return nil;
    end;

    local Data = Utility.GetData(p29);

    if Data == nil then
        return nil;
    end;

    local SkillTreeUnlockedList = Data:FindFirstChild("SkillTreeUnlockedList");
    local v31 = SkillInfo.Category or p30;
    local v32 = SkillInfo.Index or 1;

    if SkillTreeUnlockedList and (SkillInfo.Index ~= nil and SkillInfo.Category ~= nil) then
        local v33 = SkillTreeUnlockedList:FindFirstChild(v31);

        if v32 <= (v33 and v33.Value or 0) and (SkillInfo.Boss == nil or Data.MetRequirements.Boss:FindFirstChild(p30) ~= nil) then
            return nil;
        end;
    end;

    if Data.MetRequirements.Boss:FindFirstChild(p30) ~= nil then
        return "Already Have";
    end;

    if SkillInfo.Category ~= nil then
        local v34 = Breathings[SkillInfo.Category] ~= nil;
        local v35 = DemonArts[SkillInfo.Category] ~= nil;

        if v34 or v35 then
            if not u1.HasPowerAccess(p29, SkillInfo.Category) then
                return v35 and "Must be Demon" or "Must be Slayer";
            end;

            local Powers = Data:FindFirstChild("Powers");

            if Powers then
                if v34 and Powers.Breathing.Value ~= SkillInfo.Category then
                    return "Missing " .. SkillInfo.Category;
                end;

                if v35 and Powers.DemonArt.Value ~= SkillInfo.Category then
                    return "Missing " .. SkillInfo.Category;
                end;
            end;
        end;

        local v36 = require(ReplicatedStorage.CAM.Global.Powers.FightingStyles)[SkillInfo.Category];

        if v36 ~= nil then
            if not u1.HasPowerAccess(p29, SkillInfo.Category) then
                local v37 = v36.Requirements ~= nil and v36.Requirements.Race or nil;

                if typeof(v37) == "table" then
                    v37 = v37[1];
                end;

                return "Must be " .. tostring(v37);
            end;

            local Powers = Data:FindFirstChild("Powers");
            local v38;

            if Powers == nil then
                v38 = nil;
            else
                v38 = Powers:FindFirstChild("FightingStyle") or nil;
            end;

            if v38 == nil or v38.Value ~= SkillInfo.Category then
                return "Missing " .. SkillInfo.Category;
            end;
        end;
    end;

    if SkillInfo.CategoryType == "Weapon" and SkillInfo.Category ~= nil then
        local Inventory = Data:FindFirstChild("Inventory");

        if Inventory then
            Inventory = Inventory:FindFirstChild("Inventory");
        end;

        local v39 = false;

        if Inventory ~= nil then
            for _, child in Inventory:GetChildren() do
                local v40 = Items[child.Name];

                if v40 ~= nil and (v40.SkillCategory or child.Name) == SkillInfo.Category then
                    v39 = true;
                    break;
                end;
            end;
        end;

        if not v39 then
            return "Missing " .. SkillInfo.Category;
        end;
    end;

    if SkillTreeUnlockedList then
        if SkillInfo.Index == nil or SkillInfo.Category == nil then
            if SkillTreeUnlockedList:FindFirstChild(p30) == nil then
                return "Unlock Previous";
            end;
        else
            local v41 = SkillTreeUnlockedList:FindFirstChild(v31);
            local v42 = v41 and v41.Value or 0;

            if v32 > 1 then
                local _, v43 = Stats.GetRequirementsAt(p29, v31, v32 - 1);

                if v42 < v32 - 1 or not select(2, Stats.GetRequirements(p29, v43)) then
                    return "Unlock Previous";
                end;
            end;
        end;
    end;

    return nil;
end;

function u1.HasUnlockedSkills(p44: userdata, p45: table) -- Line: 249
    -- upvalues: ReplicatedStorage (copy)
    local v46 = {};

    if p44 == nil or p45 == nil then
        return false, v46;
    end;

    local Stats = require(ReplicatedStorage.CAM.Global.SkillService.Stats);

    for _, v in p45 do
        if typeof(v) == "string" and not Stats.IsSkillUnlocked(p44, v) then
            table.insert(v46, v);
        end;
    end;

    return #v46 == 0, v46;
end;

function u1.GetItemFromId(p47: userdata, p48: number) -- Line: 261
    -- upvalues: Utility (copy)
    if p47 == nil or p48 == nil then
        return;
    end;

    local v49 = tonumber(p48);

    if v49 == nil then
        return;
    end;

    local Data = Utility.GetData(p47, false);

    if Data == nil then
        return;
    end;

    for _, child in pairs(Data.Inventory.Inventory:GetChildren()) do
        if child.Id.Value == v49 then
            return child;
        end;
    end;
end;

local u50 = { "One", "Two", "Three", "Four", "Five" };

function u1.getEquippedAccessoryVanity(p51, p52) -- Line: 278
    -- upvalues: Utility (copy), u50 (copy), u1 (copy), table_insert (copy)
    if p51 == nil then
        return {};
    end;

    local Data = Utility.GetData(p51, false);

    if Data == nil then
        return {};
    end;

    if p52 == nil then
        local v53 = {};

        for _, child in pairs(Data.Inventory.Accessories.Vanity:GetChildren()) do
            local Value = child.Value;

            if Value ~= 0 then
                local ItemFromId = u1.GetItemFromId(p51, Value);

                if ItemFromId then
                    table_insert(v53, ItemFromId.Name);
                end;
            end;
        end;

        return v53;
    end;

    if u50[p52] then
        p52 = u50[p52];
    end;

    if Data.Inventory.Accessories.Vanity:FindFirstChild(p52) ~= nil then
        return u1.GetItemFromId(p51, Data.Inventory.Accessories.Vanity:FindFirstChild(p52).Value);
    end;
end;

function u1.getEquippedAccessoryStats(p54, p55) -- Line: 303
    -- upvalues: Utility (copy), u50 (copy), u1 (copy), table_insert (copy)
    if p54 == nil then
        return {};
    end;

    local Data = Utility.GetData(p54, false);

    if Data == nil then
        return {};
    end;

    if p55 == nil then
        local v56 = {};

        for _, child in pairs(Data.Inventory.Accessories.Stats:GetChildren()) do
            local Value = child.Value;

            if Value ~= 0 then
                local ItemFromId = u1.GetItemFromId(p54, Value);

                if ItemFromId then
                    table_insert(v56, ItemFromId.Name);
                end;
            end;
        end;

        return v56;
    end;

    if u50[p55] then
        p55 = u50[p55];
    end;

    if Data.Inventory.Accessories.Stats:FindFirstChild(p55) ~= nil then
        return u1.GetItemFromId(p54, Data.Inventory.Accessories.Stats:FindFirstChild(p55).Value);
    end;
end;

function u1.getEquippedItems(p57, p58) -- Line: 328
    -- upvalues: Utility (copy), u50 (copy), u1 (copy), table_insert (copy)
    if p57 == nil then
        return {};
    end;

    local Data = Utility.GetData(p57, false);

    if Data == nil then
        return {};
    end;

    if not p58 then
        local v59 = {};

        for _, child in pairs(Data.Inventory.Toolbar:GetChildren()) do
            local Value = child.Value;

            if Value ~= 0 then
                local ItemFromId = u1.GetItemFromId(p57, Value);

                if ItemFromId then
                    table_insert(v59, ItemFromId.Name);
                end;
            end;
        end;

        return v59;
    end;

    if u50[p58] then
        p58 = u50[p58];
    end;

    if Data.Inventory.Toolbar:FindFirstChild(p58) ~= nil then
        return u1.GetItemFromId(p57, Data.Inventory.Toolbar:FindFirstChild(p58).Value);
    end;
end;

local CurPower = game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Client"):WaitForChild("Controllers"):WaitForChild("Skills_Provider"):WaitForChild("CurPower");
local u60 = nil;
local u61 = nil;

function u1.get_core_anim(p62, p63, p64) -- Line: 357
    -- upvalues: u2 (copy), LocalPlayer (copy), u1 (copy), u3 (copy), CurPower (copy), Utility (copy), u60 (ref), u61 (ref), Items (copy)
    if p62 == nil or p63 == nil then
        return;
    end;

    local v65 = u2 and p62 == LocalPlayer;
    local v66 = v65 and u1.EquippedTool or "";
    local v67 = nil;

    if p64 ~= true then
        p63 = u3[p63] or p63;
    end;

    local v68;

    if v65 then
        v68 = CurPower.Value;
    else
        v68 = nil;
    end;

    if not v65 and p62:HasTag("Players") then
        p62 = game.Players:GetPlayerFromCharacter(p62) or p62;
    end;

    if p62.Parent == game.Players then
        if not v65 then
            local v69 = p62:FindFirstChild("Items_Config") or p62:FindFirstChild("Items_ConfigServer");

            if v69 ~= nil and (v69:FindFirstChild("Equipped") ~= nil and Utility.GetData(p62) ~= nil) then
                local _equipped_tool = u1.Get_equipped_tool(p62);

                if _equipped_tool ~= nil then
                    v66 = _equipped_tool.Name;
                end;
            end;
        end;
    else
        local _equipped_tool = u1.Get_equipped_tool(p62);

        if _equipped_tool ~= nil then
            v66 = _equipped_tool.Name;
        end;
    end;

    if v65 then
        local v70 = `{p63}-{v66}-{v68}`;

        if u60 == v70 then
            return u61;
        end;

        u60 = v70;
    end;

    if v66 then
        local v71 = game.ReplicatedStorage.Assets.Animations.Default_Core:FindFirstChild("Toolbar_" .. v66) or game.ReplicatedStorage.Assets.Animations.Default_Core:FindFirstChild(v66);

        if v71 and v71:FindFirstChild(p63) then
            v67 = v71[p63];
        elseif v71 == nil or not (Utility.IsMeshRig(p62) and (p63 ~= "Run_Hit" and not string.match(p63, "^Swing_"))) then
            local v72 = Items[v66];

            if v72 and v72.CombatPreset then
                v71 = game.ReplicatedStorage.Assets.Animations.Default_Core:FindFirstChild("Toolbar_" .. v72.CombatPreset) or v71;
            elseif v72 and v72.Breathing ~= nil then
                v71 = game.ReplicatedStorage.Assets.Animations.Default_Core:FindFirstChild("Toolbar_Regular Katana");
            end;

            if v71 and v71:FindFirstChild(p63) then
                v67 = v71[p63];
            elseif v72 and (v72.CombatPreset and v72.Breathing ~= nil) then
                local v73 = game.ReplicatedStorage.Assets.Animations.Default_Core:FindFirstChild("Toolbar_Regular Katana");

                if v73 and v73:FindFirstChild(p63) then
                    v67 = v73[p63];
                end;
            end;
        else
            v67 = v71:FindFirstChild("walk") or v71:FindFirstChild("idle");
        end;
    end;

    local v74;

    if v66 == nil or v66 == "" then
        v74 = false;
    else
        local v75 = Items[v66];

        if v75 == nil or v75.CombatPreset == nil then
            v74 = false;
        else
            v74 = v75.CombatPreset ~= "Combat";
        end;
    end;

    if v67 == nil and not (v74 or (v68 == nil or #v68 <= 0)) then
        for _, v in ipairs(string.split(v68, ",")) do
            local v76 = game.ReplicatedStorage.Assets.Animations.Default_Core:FindFirstChild(v);

            if v76 and v76:FindFirstChild(p63) then
                v67 = v76[p63];
                break;
            end;
        end;
    end;

    if v67 == nil then
        local Default = game.ReplicatedStorage.Assets.Animations.Default_Core:FindFirstChild("Default");

        if Default and Default:FindFirstChild(p63) then
            v67 = Default[p63];
        end;
    end;

    if v67 == nil and (game.StarterPlayer:FindFirstChild("StarterCharacterScripts") and game.StarterPlayer.StarterCharacterScripts:FindFirstChild("Animate")) then
        local v77 = game.StarterPlayer.StarterCharacterScripts.Animate:FindFirstChild(p63);

        if v77 then
            v67 = v77:FindFirstChildOfClass("Animation");
        end;
    end;

    if v65 then
        u61 = v67;
    end;

    return v67;
end;

return u1;