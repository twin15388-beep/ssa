-- Decompiled with Potassium's decompiler.

local LocalPlayer = game.Players.LocalPlayer;
local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local cleanit = require(ReplicatedStorage.Packages.cleanit);
local simplesignal = require(ReplicatedStorage.Packages.simplesignal);
local Character_info_provider = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Character_info_provider"));
local BunchaIcons = require(ReplicatedStorage.CAM.Global.BunchaIcons);
local ItemRequirements = require(ReplicatedStorage.CAM.Global.Collectibles.ItemRequirements);
local Items = require(ReplicatedStorage.CAM.Global.Collectibles.Items);
local MinigameSettings = require(ReplicatedStorage.CAM.Global.MinigameSettings);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);

local function minigameLocksItem(p1: userdata) -- Line: 13
    -- upvalues: MinigameSettings (copy), Items (copy)
    local v2 = MinigameSettings.Get("LockedItemCategories");
    local v3 = Items[p1.Name];
    local v4;

    if v2 == nil or v3 == nil then
        v4 = false;
    else
        v4 = v2[v3.Category] == true;
    end;

    return v4;
end;

local u16 = {
    Inventory = {
        Locked = {
            Desc = "Item is locked and can\'t be used",
            Icon = BunchaIcons.Locked
        },
        NoSave = {
            Desc = "When you leave and rejoin you won\'t have this item",
            Icon = BunchaIcons.NoSave
        },
        ActionsDisabled = {
            Icon = "",
            Desc = "Equiping and UnEquiping will be disabled"
        }
    },
    functions = {
        Locked = function(p5, p6) -- Line: 39, Name: Locked
            -- upvalues: MinigameSettings (copy), Items (copy), ItemRequirements (copy), Utility (copy)
            if p5 == nil or p6 == nil then
                return false;
            end;

            local v7 = MinigameSettings.Get("LockedItemCategories");
            local v8 = Items[p6.Name];
            local v9;

            if v7 == nil or v8 == nil then
                v9 = false;
            else
                v9 = v7[v8.Category] == true;
            end;

            return v9 and true or not ItemRequirements.SatisfiesEquip(Utility.GetData(p5), p6.Name);
        end,

        NoSave = function(p10, p11) -- Line: 45, Name: NoSave
            local v12;

            if p11 == nil then
                v12 = false;
            else
                v12 = p11:FindFirstChild("NoSave") ~= nil;
            end;

            return v12;
        end,

        ActionsDisabled = function(p13, p14) -- Line: 48, Name: ActionsDisabled
            if p14 == nil then
                return false;
            end;

            local v15 = game.ReplicatedStorage.Player_Service.Values:FindFirstChild(p13.Name);

            if v15 == nil then
                return false;
            end;

            local tooldisabled = v15:FindFirstChild("tooldisabled");

            if tooldisabled == nil then
                return false;
            end;

            local Value = tooldisabled.Value;

            if string.find(Value, "all") then
                if not string.find(Value, "except" .. p14.Name) then
                    return true;
                end;
            elseif string.find(Value, p14.Name) then
                return true;
            end;

            return false;
        end
    },
    Changed = RunService:IsClient() and (simplesignal.new() or "Not available on server") or "Not available on server"
};

function u16.GetCurrentRestrictions(p17, p18) -- Line: 66
    -- upvalues: Utility (copy), Character_info_provider (copy), u16 (copy)
    if p18 == nil then
        return {};
    end;

    local Data = Utility.GetData(p17);

    if Data == nil then
        return {};
    end;

    local v19 = Data.Inventory.Toolbar:FindFirstChild(p18);
    local ItemFromId = Character_info_provider.GetItemFromId(p17, v19.Value);
    local v20 = {};

    for i, v in pairs(u16.functions) do
        if v(p17, ItemFromId) == true then
            v20[tostring(i)] = true;
        end;
    end;

    return v20;
end;

if RunService:IsClient() then
    local Data = Utility.GetData(LocalPlayer, true);
    local u21 = nil;
    u16.CurrentRestrictions = {
        One = {
            Restrictions = {},
            Changed = simplesignal.new()
        },
        Two = {
            Restrictions = {},
            Changed = simplesignal.new()
        },
        Three = {
            Restrictions = {},
            Changed = simplesignal.new()
        },
        Four = {
            Restrictions = {},
            Changed = simplesignal.new()
        },
        Five = {
            Restrictions = {},
            Changed = simplesignal.new()
        }
    };

    local function updchar(p22) -- Line: 121
        -- upvalues: u21 (ref), cleanit (copy), u16 (copy), LocalPlayer (copy), Data (copy), ItemRequirements (copy)
        if u21 ~= nil then
            u21:Destroy();
            u21 = nil;
        end;

        u21 = cleanit.new();

        local function UpdateRestrictions() -- Line: 128
            -- upvalues: u16 (ref), LocalPlayer (ref)
            local v23 = false;

            for i, v in pairs(u16.CurrentRestrictions) do
                local v24 = u16.GetCurrentRestrictions(LocalPlayer, i) or {};
                local v25 = i;
                local v26 = v;
                local v27 = 0;
                local v28 = 0;
                local v29 = true;
                local v30 = true;

                for i2, v2 in pairs(v.Restrictions) do
                    v27 = v27 + 1;

                    if v24[i2] ~= v2 then
                        v29 = false;
                    end;
                end;

                for i2, v2 in pairs(v24) do
                    v28 = v28 + 1;

                    if v26.Restrictions[i2] ~= v2 then
                        v30 = false;
                    end;
                end;

                if (v27 ~= v28 and true or not (v29 and v30)) == true then
                    u16.CurrentRestrictions[v25].Restrictions = v24;
                    u16.CurrentRestrictions[v25].Changed:Fire();
                    v23 = true;
                end;
            end;

            if v23 == true then
                u16.Changed:Fire();
            end;
        end;

        local Inventory = Data:FindFirstChild("Inventory");

        if Inventory ~= nil then
            for _, child in pairs(Inventory.Toolbar:GetChildren()) do
                u21:Connect(child.Changed, UpdateRestrictions);
            end;
        end;

        local v31 = game.ReplicatedStorage.Player_Service.Values:FindFirstChild(LocalPlayer.Name);

        if v31 ~= nil then
            u21:Connect(v31.ChildAdded, function(p32) -- Line: 169
                -- upvalues: UpdateRestrictions (copy), u21 (ref)
                if p32.Name == "tooldisabled" then
                    UpdateRestrictions();
                    u21:Connect(p32.Changed, UpdateRestrictions);
                end;
            end);
            u21:Connect(v31.ChildRemoved, function(p33) -- Line: 175
                -- upvalues: UpdateRestrictions (copy)
                if p33.Name == "tooldisabled" then
                    UpdateRestrictions();
                end;
            end);
            local tooldisabled = v31:FindFirstChild("tooldisabled");

            if tooldisabled then
                u21:Connect(tooldisabled.Changed, UpdateRestrictions);
            end;
        end;

        for _, v in ipairs(ItemRequirements.Keys()) do
            local v34 = ItemRequirements.Resolve(Data, v == "Level" and "Exp.Goal" or v);

            if v34 ~= nil then
                u21:Connect(v34.Changed, UpdateRestrictions);
            end;
        end;

        UpdateRestrictions();
    end;

    local Character = LocalPlayer.Character;

    if Character ~= nil then
        task.spawn(function() -- Line: 202
            -- upvalues: LocalPlayer (copy), Character (copy), updchar (copy)
            task.wait();

            if LocalPlayer.Character == Character then
                updchar(LocalPlayer.Character);
            end;
        end);
    end;

    LocalPlayer.CharacterAdded:Connect(updchar);
end;

return u16;