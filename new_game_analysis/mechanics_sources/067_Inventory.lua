-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local LocalPlayer = game:GetService("Players").LocalPlayer;
local DataValue = require(ReplicatedStorage.CAM.Client.Modules.DataValue);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local ItemSelected = LocalPlayer.MenuDestination.InventoryOption.ItemSelected;
local IdSelected = ItemSelected.IdSelected;
local Data = Utility.GetData(LocalPlayer, true);
local script_Item = require(script.Item);
local CircleButton = require(ReplicatedStorage.CAM.Client.Components.Misc.Buttons.CircleButton);
local script_SelectModeHandler = require(script.SelectModeHandler);
local Character_info_provider = require(ReplicatedStorage.CAM.Global.Character_info_provider);
local MenuConfig = require(ReplicatedStorage.CAM.Client.Components.Layout.NoneResetting.Menu.MenuConfig);
local script_ItemEquipepdFrame = require(script.ItemEquipepdFrame);
local Menum = require(ReplicatedStorage.CAM.Global.Menum);
local Items = require(ReplicatedStorage.CAM.Global.Collectibles.Items);
local u1 = {};
local u2 = {};
local u3 = DataValue.new("Misc/EquippedBaitId", 0);
local Searchbar = require(ReplicatedStorage.CAM.Client.Components.Misc.Utilities.Searchbar);
require(ReplicatedStorage.Packages.faye);
local u4 = {};
local ItemSearchbar = LocalPlayer.MenuDestination.InventoryOption.ItemSearchbar;
local script_Loadouts = require(script.Loadouts);
local CategoryBrowser = require(ReplicatedStorage.CAM.Client.Components.Misc.CategoryBrowser);
local ClassFilter = require(ReplicatedStorage.CAM.Client.Components.Misc.ClassFilter);
local script_ItemViewer = require(script.ItemViewer);

local function equippedIds() -- Line: 42
    -- upvalues: Data (copy), u3 (copy)
    local u5 = {};

    local function add(p6) -- Line: 44
        -- upvalues: u5 (copy)
        if type(p6) == "number" and p6 ~= 0 then
            u5[p6] = true;
        end;
    end;

    for _, child in Data.Inventory.Toolbar:GetChildren() do
        local Value = child.Value;

        if type(Value) == "number" and Value ~= 0 then
            u5[Value] = true;
        end;
    end;

    for _, child in Data.Inventory.Accessories.Stats:GetChildren() do
        local Value = child.Value;

        if type(Value) == "number" and Value ~= 0 then
            u5[Value] = true;
        end;
    end;

    for _, child in Data.Inventory.Accessories.Vanity:GetChildren() do
        local Value = child.Value;

        if type(Value) == "number" and Value ~= 0 then
            u5[Value] = true;
        end;
    end;

    local v7 = u3:Get();

    if type(v7) == "number" and v7 ~= 0 then
        u5[v7] = true;
    end;

    return u5;
end;

return function(u8: any, u9: userdata) -- Line: 62
    -- upvalues: ClassFilter (copy), equippedIds (copy), Data (copy), Items (copy), Character_info_provider (copy), LocalPlayer (copy), IdSelected (copy), ItemSelected (copy), MenuConfig (copy), u4 (copy), ItemSearchbar (copy), u3 (copy), Menum (copy), u2 (copy), u1 (copy), Searchbar (copy), CategoryBrowser (copy), script_ItemViewer (copy), script_SelectModeHandler (copy), script_ItemEquipepdFrame (copy), CircleButton (copy), script_Item (copy), script_Loadouts (copy)
    local u10 = {
        Enabled = u8:Value(false),
        Selected = u8:Value({})
    };
    local u11 = u8:Value(false);
    local u12 = u8:Value(false);
    local u13 = {};
    local u14 = u8:Value({});
    local u15 = {};
    local u16 = 1;
    local u17 = false;

    local function feedTiles() -- Line: 86
        -- upvalues: u17 (ref), u8 (copy), u16 (ref), u15 (copy), u13 (copy), u14 (copy)
        if u17 then
            return;
        end;

        u17 = true;
        u8:Spawn(function() -- Line: 89
            -- upvalues: u16 (ref), u15 (ref), u13 (ref), u14 (ref), u17 (ref)
            while u16 <= #u15 do
                for i = 1, 20 do
                    local v18 = u15[u16];

                    if v18 == nil then
                        break;
                    end;

                    u16 = u16 + 1;
                    local v19 = u13[v18];
                    local v20;

                    if v19 == nil then
                        v20 = i;
                    else
                        u14:Add(v18, v19);
                        v20 = i;
                    end;
                end;

                if u16 > #u15 then
                    break;
                end;

                task.wait();
            end;

            table.clear(u15);
            u16 = 1;
            u17 = false;
        end);
    end;

    local function refreshTiles() -- Line: 111
        -- upvalues: u14 (copy), u13 (copy), u15 (copy), u16 (ref), u17 (ref), u8 (copy)
        for i in u14:Get() do
            if u13[i] == nil then
                u14:Remove(i);
            end;
        end;

        table.clear(u15);
        u16 = 1;

        for i in u13 do
            table.insert(u15, i);
        end;

        if u17 then
            return;
        end;

        u17 = true;
        u8:Spawn(function() -- Line: 89
            -- upvalues: u16 (ref), u15 (ref), u13 (ref), u14 (ref), u17 (ref)
            while u16 <= #u15 do
                for i = 1, 20 do
                    local v21 = u15[u16];

                    if v21 == nil then
                        break;
                    end;

                    u16 = u16 + 1;
                    local v22 = u13[v21];
                    local v23;

                    if v22 == nil then
                        v23 = i;
                    else
                        u14:Add(v21, v22);
                        v23 = i;
                    end;
                end;

                if u16 > #u15 then
                    break;
                end;

                task.wait();
            end;

            table.clear(u15);
            u16 = 1;
            u17 = false;
        end);
    end;

    local v24 = u8:Value(UDim2.new(1, -10, 1, -10));
    local u25 = u8:Value(UDim2.fromScale(0, 0));
    local u26 = u8:Value("All");
    local u27 = u8:Value(ClassFilter.ALL);
    local v28 = equippedIds();
    local v29 = {};
    local v30 = {
        All = 0,
        Equipped = 0
    };
    local u31 = {};
    local v32 = {};
    local v33 = {};

    for _, child in Data.Inventory.Inventory:GetChildren() do
        local v34 = Items[child.Name];

        if v34 ~= nil and v34.InventoryCategory ~= nil then
            if table.find(v29, v34.InventoryCategory) == nil then
                table.insert(v29, v34.InventoryCategory);
            end;

            if not v32[child.Name] then
                v32[child.Name] = true;
                v30[v34.InventoryCategory] = (v30[v34.InventoryCategory] or 0) + 1;
                v30.All = v30.All + 1;
                ClassFilter.Tally(u31, child.Name);
            end;

            local Id = child:FindFirstChild("Id");

            if Id ~= nil and (v28[Id.Value] and not v33[child.Name]) then
                v33[child.Name] = true;
                v30.Equipped = v30.Equipped + 1;
            end;
        end;
    end;

    table.sort(v29);
    table.insert(v29, 1, "All");
    table.insert(v29, 2, "Equipped");
    local u35 = u8:Value(nil);

    local function u38() -- Line: 165
        -- upvalues: u12 (copy), Character_info_provider (ref), LocalPlayer (ref), IdSelected (ref), ItemSelected (ref), Data (ref), u35 (copy)
        local v36, v37;

        if u12:Compare(true) then
            v36 = Character_info_provider.GetItemFromId(LocalPlayer, IdSelected.Value);

            if v36 ~= nil and v36.Name ~= ItemSelected.Value then
                v36 = nil;
            end;

            if v36 == nil then
                if IdSelected.Value ~= 0 then
                    IdSelected.Value = 0;
                end;

                if IdSelected.ItemName.Value ~= "" then
                    IdSelected.ItemName.Value = "";
                end;
            end;

            v37 = IdSelected.Value;
        else
            v36 = Data.Inventory.Inventory:FindFirstChild(ItemSelected.Value);

            if v36 == nil and u12:Compare(false) then
                v36 = Character_info_provider.GetItemFromId(LocalPlayer, IdSelected.Value);
                v37 = IdSelected.Value;
            else
                v37 = v36.Id.Value;
            end;
        end;

        ItemSelected.ItemId.Value = v37;
        u35:Set(v36);
    end;

    local function updateItems() -- Line: 196
        -- upvalues: MenuConfig (ref), Data (ref), ItemSelected (ref), u13 (copy), u4 (ref), u26 (copy), equippedIds (ref), Items (ref), ItemSearchbar (ref), u27 (copy), ClassFilter (ref), u11 (copy), u12 (copy), refreshTiles (copy)
        local v39 = MenuConfig.inventoryRepsExceeds(Data.Inventory.Inventory, ItemSelected.Value);
        table.clear(u13);
        table.clear(u4);
        local v40 = false;

        if v39 == false then
            v40 = true;
            local v41;

            if u26:Get() == "Equipped" then
                v41 = equippedIds();
            else
                v41 = nil;
            end;

            for _, child in pairs(Data.Inventory.Inventory:GetChildren()) do
                if Items[child.Name] ~= nil then
                    local string_gsub_ret = string.gsub(child.Name, "_", " ");

                    if table.find(u4, string_gsub_ret) == nil then
                        table.insert(u4, string_gsub_ret);
                    end;

                    if ItemSearchbar.Value == "" or string.lower(ItemSearchbar.Value) == string.lower((string.sub(string_gsub_ret, 0, #ItemSearchbar.Value))) then
                        local v42, v43;

                        if v41 == nil then
                            if u26:Get() == "All" or Items[child.Name].InventoryCategory == u26:Get() then
                                if u27:Get() == ClassFilter.ALL or Items[child.Name].Class == u27:Get() then
                                    if u13[child.Name] == nil then
                                        u13[child.Name] = {
                                            DestinctAmount = 1,
                                            Name = child.Name,
                                            Amount = child:FindFirstChild("Amount") == nil and 1 or (child.Amount.Value or 1),
                                            ItemId = child.Id.Value,
                                            RefineLevel = child:FindFirstChild("RefineLevel") == nil and 0 or (child.RefineLevel.Value or 0)
                                        };
                                    else
                                        v42 = u13[child.Name];
                                        v42.DestinctAmount = v42.DestinctAmount + 1;
                                        v43 = u13[child.Name];
                                        v43.Amount = v43.Amount + (child:FindFirstChild("Amount") == nil and 1 or (child.Amount.Value or 1));
                                    end;
                                end;
                            end;
                        elseif v41[child.Id.Value] then
                            if u27:Get() == ClassFilter.ALL or Items[child.Name].Class == u27:Get() then
                                if u13[child.Name] == nil then
                                    u13[child.Name] = {
                                        DestinctAmount = 1,
                                        Name = child.Name,
                                        Amount = child:FindFirstChild("Amount") == nil and 1 or (child.Amount.Value or 1),
                                        ItemId = child.Id.Value,
                                        RefineLevel = child:FindFirstChild("RefineLevel") == nil and 0 or (child.RefineLevel.Value or 0)
                                    };
                                else
                                    v42 = u13[child.Name];
                                    v42.DestinctAmount = v42.DestinctAmount + 1;
                                    v43 = u13[child.Name];
                                    v43.Amount = v43.Amount + (child:FindFirstChild("Amount") == nil and 1 or (child.Amount.Value or 1));
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        else
            for _, child in pairs(Data.Inventory.Inventory:GetChildren()) do
                if Items[child.Name] ~= nil and (u13[child.Id.Value] == nil and child.Name == ItemSelected.Value) then
                    u13[child.Id.Value] = {
                        DestinctAmount = 1,
                        Name = child.Name,
                        Id = child.Id.Value,
                        Amount = child:FindFirstChild("Amount") == nil and 1 or (child.Amount.Value or 1),
                        RefineLevel = child:FindFirstChild("RefineLevel") == nil and 0 or (child.RefineLevel.Value or 0)
                    };
                end;
            end;
        end;

        local v44 = {};

        for _, v in u13 do
            table.insert(v44, v);
        end;

        table.sort(v44, function(p45, p46) -- Line: 263
            -- upvalues: Items (ref)
            local v47 = Items[p45.Name].Rarity or 0;
            local v48 = Items[p46.Name].Rarity or 0;

            if v47 ~= v48 then
                return v47 < v48;
            end;

            if p45.Name == p46.Name then
                return (p45.Id or (p45.ItemId or 0)) < (p46.Id or (p46.ItemId or 0));
            end;

            return p45.Name < p46.Name;
        end);

        for i, v in v44 do
            v.Order = i;
        end;

        u11:Set(v40);
        u12:Set(v39);
        refreshTiles();
    end;

    updateItems();
    u8:Connect(ItemSelected.Changed, function(p49) -- Line: 283
        -- upvalues: u13 (copy), u12 (copy), updateItems (copy), u38 (copy)
        if u13 == nil or (u13[p49] == nil or u13[p49].Amount <= 1) then
            if u12:Compare(true) then
                updateItems();
            end;
        elseif u12:Compare(false) then
            updateItems();
        end;

        u38();
    end);
    u38();
    u8:Connect(IdSelected.Changed, function() -- Line: 296
        -- upvalues: u12 (copy), u38 (copy)
        if u12:Compare(true) then
            u38();
        end;
    end);
    u8:Connect(ItemSearchbar:GetPropertyChangedSignal("Value"), updateItems);
    u8:Connect(u26.Changed, updateItems);
    u8:Connect(u27.Changed, updateItems);

    local function refreshEquippedTab() -- Line: 305
        -- upvalues: u26 (copy), updateItems (copy)
        if u26:Get() == "Equipped" then
            updateItems();
        end;
    end;

    for _, child in Data.Inventory.Toolbar:GetChildren() do
        u8:Connect(child.Changed, refreshEquippedTab);
    end;

    for _, child in Data.Inventory.Accessories.Stats:GetChildren() do
        u8:Connect(child.Changed, refreshEquippedTab);
    end;

    for _, child in Data.Inventory.Accessories.Vanity:GetChildren() do
        u8:Connect(child.Changed, refreshEquippedTab);
    end;

    u8:Add(u3.Changed:Connect(refreshEquippedTab));
    u8:Connect(Data.Inventory.Inventory.ChildAdded, updateItems);
    u8:Connect(Data.Inventory.Inventory.ChildRemoved, updateItems);
    local u50 = {};

    local function watchAmounts() -- Line: 337
        -- upvalues: u50 (copy), u8 (copy), Data (ref), updateItems (copy)
        for _, v in u50 do
            u8:Remove(v);
            v:Disconnect();
        end;

        table.clear(u50);

        for _, child in Data.Inventory.Inventory:GetChildren() do
            local Amount = child:FindFirstChild("Amount");

            if Amount ~= nil and Amount:IsA("ValueBase") then
                table.insert(u50, u8:Connect(Amount.Changed, updateItems));
            end;
        end;
    end;

    u8:Connect(Data.Inventory.Inventory.ChildAdded, watchAmounts);
    u8:Connect(Data.Inventory.Inventory.ChildRemoved, watchAmounts);
    watchAmounts();
    local u51 = u8.SpringInfo(0.4, 1, 0.6);
    local u52 = u8:Value(UDim2.fromScale(0.5, 0.45));
    local u53 = 0;
    local u54 = u8:Value(true);
    u35.Changed:Connect(function(p55: userdata) -- Line: 362, Name: updateEq
        -- upvalues: u53 (ref), u54 (copy), u52 (copy)
        if u53 ~= 1 then
            u54:Set(true);
            u52:Set(UDim2.fromScale(0.5, 0.45));
            u53 = 1;
        end;
    end);
    u35:Get();

    if u53 ~= 1 then
        u54:Set(true);
        u52:Set(UDim2.fromScale(0.5, 0.45));
        u53 = 1;
    end;

    local u78 = u8:Space(function(p56: table, p57: any, p58: any, p59: any, p60: any, p61: any, p62: any, p63: any, p64: any, p65: any, p66: any, p67: any) -- Line: 373
        -- upvalues: u10 (copy), Items (ref), Menum (ref), Data (ref), Character_info_provider (ref), LocalPlayer (ref), u3 (ref), u2 (ref), u1 (ref), u12 (copy), IdSelected (ref), ItemSelected (ref)
        local v68 = nil;
        local Item = u10.Selected:GetItem(p57.Name);
        local v69 = u10.Enabled:Compare(true) and (Item == nil and 2 or (Item[p57.Id or p57.ItemId] == nil and (Item.Count <= 0 or p57.Id ~= nil) and 2 or 1)) or 0;
        p58:Set(v69 == 0);
        local v70;

        if v69 == 0 then
            if Items[p57.Name].EquipType == Menum.ItemEquipType.Accessory or (Items[p57.Name].EquipType == Menum.ItemEquipType.Costume or Items[p57.Name].EquipType == Menum.ItemEquipType.Clothing) then
                v70 = {
                    Vanity = false,
                    Stats = false
                };

                if p57.Folder then
                    for _, child in ipairs(Data.Inventory.Accessories.Stats:GetChildren()) do
                        if child.Value ~= 0 and Character_info_provider.GetItemFromId(LocalPlayer, child.Value).Name == p57.Name then
                            v70.Stats = true;
                            break;
                        end;
                    end;

                    for _, child in ipairs(Data.Inventory.Accessories.Vanity:GetChildren()) do
                        if child.Value ~= 0 and Character_info_provider.GetItemFromId(LocalPlayer, child.Value).Name == p57.Name then
                            v70.Vanity = true;
                            break;
                        end;
                    end;
                else
                    for _, child in ipairs(Data.Inventory.Accessories.Stats:GetChildren()) do
                        if child.Value == p57.ItemId then
                            v70.Stats = true;
                            break;
                        end;
                    end;

                    for _, child in ipairs(Data.Inventory.Accessories.Vanity:GetChildren()) do
                        if child.Value == p57.ItemId then
                            v70.Vanity = true;
                            break;
                        end;
                    end;
                end;

                if not (v70.Vanity or v70.Stats) then
                    v70 = v68;
                end;
            elseif Items[p57.Name].EquipType == Menum.ItemEquipType.Bait then
                local v71 = u3:Get();

                if v71 == 0 then
                    v70 = v68;
                elseif (p57.Id or p57.ItemId) == v71 then
                    v70 = "Bait";
                else
                    v70 = v68;
                end;
            elseif p57.Folder then
                local v72 = 0;
                v70 = v68;

                for i, v in pairs(u2) do
                    if v == p57.Name then
                        v72 = v72 + 1;
                        local v73 = v70 == nil and "" or v70;

                        if v72 == 1 then
                            v68 = v73 .. i;
                        else
                            v68 = v73 .. "," .. i;
                        end;
                    else
                        v68 = v70;
                    end;

                    v70 = v68;
                end;
            else
                local v74 = 0;
                v70 = v68;

                for i, v in pairs(u1) do
                    if v == (p57.Id or p57.ItemId) then
                        v74 = v74 + 1;
                        local v75 = v70 == nil and "" or v70;

                        if v74 == 1 then
                            v68 = v75 .. i;
                        else
                            v68 = v75 .. "," .. i;
                        end;
                    else
                        v68 = v70;
                    end;

                    v70 = v68;
                end;
            end;
        else
            v70 = nil;
        end;

        p66:Set(v70);
        local v76 = not p57.Folder;

        if v76 then
            if p57.Amount > 1 and Item ~= nil and Item[p57.Id or p57.ItemId] ~= nil then
                v76 = v69 == 1 and p56.In and not p57.Folder;

                if not v76 then
                    if v69 == 1 or v69 == 2 then
                        v76 = p67.Value > 1;
                    else
                        v76 = false;
                    end;
                end;
            else
                v76 = false;
            end;
        end;

        p65:Set(v76);
        local v77;

        if v69 == 0 then
            v77 = (u12:Compare(true) and IdSelected.Value == p57.Id or u12:Compare(false) and (ItemSelected.Value == p57.Name or p57.Name == IdSelected.ItemName.Value)) and 1 or (p56.In == true and 2 or 3);
        else
            v77 = v69 == 1 and 4 or 5;
        end;

        if v77 ~= p56.LastState then
            if v77 == 4 or v77 == 5 then
                p62:Reset();

                if v77 == 4 then
                    p63:Reset();
                    p59:Reset();
                    p64:Reset();
                    p60:Set(0.5);
                    p61:Set(0.25);
                else
                    p63:Set(0.75);
                    p64:Set(0.5);
                    p59:Set(0.75);
                    p60:Set(0.9);
                    p61:Set(0.9);
                end;
            else
                p63:Reset();
                p63:Reset();
                p64:Reset();
                p62:Set(p56.RarityColor);

                if v77 == 1 then
                    p59:Set(0.25);
                    p60:Set(0.1);
                    p61:Set(0.15);
                elseif v77 == 2 then
                    p59:Set(0.25);
                    p60:Set(0.185);
                    p61:Reset();
                else
                    p61:Reset();
                    p59:Reset();
                    p60:Reset();
                end;
            end;

            p56.LastState = v77;
        end;
    end);
    u78:Connect(u12.Changed);
    u78:Connect(ItemSelected:GetPropertyChangedSignal("Value"));
    u78:Connect(IdSelected:GetPropertyChangedSignal("Value"));
    math.random(1, 9999);

    for _, child in ipairs(Data.Inventory.Toolbar:GetChildren()) do
        u1[child.Name] = child.Value;
        u2[child.Name] = Character_info_provider.GetItemNameOnSlot(LocalPlayer.Name, child.Name);
        u8:Connect(child.Changed, function() -- Line: 539
            -- upvalues: u1 (ref), child (copy), u2 (ref), Character_info_provider (ref), LocalPlayer (ref), u78 (copy)
            u1[child.Name] = child.Value;
            u2[child.Name] = Character_info_provider.GetItemNameOnSlot(LocalPlayer.Name, child.Name);
            u78:Call();
        end);
    end;

    for _, child in ipairs(Data.Inventory.Accessories.Stats:GetChildren()) do
        u8:Connect(child.Changed, function() -- Line: 548
            -- upvalues: u78 (copy)
            u78:Call();
        end);
    end;

    for _, child in ipairs(Data.Inventory.Accessories.Vanity:GetChildren()) do
        u8:Connect(child.Changed, function() -- Line: 553
            -- upvalues: u78 (copy)
            u78:Call();
        end);
    end;

    u8:Add(u3.Changed:Connect(function() -- Line: 560
        -- upvalues: u78 (copy)
        u78:Call();
    end));
    u8:Connect(u10.Selected.Changed, function(p79) -- Line: 564
        -- upvalues: u78 (copy)
        u78:Call();
    end);
    u8:Connect(u10.Enabled.Changed, function(p80) -- Line: 568
        -- upvalues: u10 (copy), u35 (copy), Items (ref), ItemSelected (ref)
        if p80 ~= true then
            u10.Selected:Set({});

            return;
        end;

        local v81 = u35:Get();

        if v81 == nil or Items[v81.Name] == nil then
            return;
        end;

        if Items[v81.Name].NoDelete == true then
            return;
        end;

        local v82 = v81:FindFirstChild("Id") ~= nil and v81.Id.Value or ItemSelected.ItemId.Value;

        if v82 == nil or v82 == 0 then
            return;
        end;

        local Item = u10.Selected:GetItem(v81.Name);

        if Item == nil then
            u10.Selected:Add(v81.Name, {
                [v82] = 1,
                Count = 1
            });

            return;
        end;

        if Item[v82] == nil then
            Item.Count = Item.Count + 1;
            Item[v82] = 1;
            u10.Selected:Refresh();
        end;
    end);
    u78:Connect(u10.Enabled.Changed);
    local v83 = {};

    for i, child in Data.ItemLoadouts:GetChildren() do
        if child.Name ~= "Counter" then
            v83[i] = child;
        end;
    end;

    local u84 = u8:Value(v83);
    u8:Connect(Data.ItemLoadouts.ChildAdded, function(p85) -- Line: 609
        -- upvalues: u84 (ref)
        u84 = u84 + p85;
    end);

    return u8:Create("Frame")({
        Name = "CharactersMain",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.fromScale(0.44, 0.75),
        Position = u8:Animation(u52, u51),
        u8:Create("UIAspectRatioConstraint")({
            AspectRatio = 1
        }),
        BackgroundTransparency = 1,
        u8:Create("Frame")({
            Name = "SearchbarHolder",
            Size = UDim2.fromScale(0.3, 0.05),
            Position = UDim2.fromScale(0, -0.015),
            AnchorPoint = Vector2.new(0, 1),
            BackgroundTransparency = 1,
            u8:State(function(p86, p87) -- Line: 631
                -- upvalues: u11 (copy), Searchbar (ref), u4 (ref), ItemSearchbar (ref)
                if p86(u11) then
                    return Searchbar(p87, u4, ItemSearchbar);
                end;
            end)
        }),
        CategoryBrowser(u8, u9, u26, v29, {
            TabHeight = 0.12,
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.fromScale(-0.05, 0),
            Size = UDim2.fromScale(0.35, 0.5),
            Counts = v30
        }),
        u8:State(function(p88, p89) -- Line: 650
            -- upvalues: u11 (copy), ClassFilter (ref), u27 (copy), u31 (copy)
            if p88(u11) then
                return ClassFilter.Pick(p89, u27, u31, 0.05);
            end;

            return nil;
        end),
        script_ItemViewer(u8, u9, u35),
        u8:Create("Frame")({
            u8:Create("UIListLayout")({
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Right,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                Padding = UDim.new(0.15)
            }),
            Name = "SelectModeButtons",
            Size = UDim2.fromScale(0.1, 0.035),
            AnchorPoint = Vector2.new(1, 1),
            Position = UDim2.fromScale(1, -0.015),
            BackgroundTransparency = 1,
            script_SelectModeHandler(u8, u10)
        }),
        u8:State(function(p90, p91) -- Line: 675
            -- upvalues: u54 (copy), u10 (copy), u51 (copy), script_ItemEquipepdFrame (ref), u9 (copy), u35 (copy), ItemSelected (ref)
            if p90(u54) == true and p90(u10.Enabled) ~= true then
                local u92 = p91:Animation(UDim2.fromScale(1, 0.165), u51, {
                    From = UDim2.fromScale(0.8, 0.132)
                });

                return p91:Create("Frame")({
                    Position = UDim2.fromScale(0.5, 1.01),
                    AnchorPoint = Vector2.new(0.5, 0),
                    BackgroundTransparency = 1,
                    Size = u92,

                    OnClean = function(p93, p94) -- Line: 686, Name: OnClean
                        -- upvalues: u92 (copy)
                        if u92 ~= nil and u92.Destroy then
                            u92:Destroy();
                        end;

                        p93:Configure(p94)({
                            Size = p93:Animation(UDim2.fromScale(0, 0), p93.Info(0.1))
                        });
                    end,

                    script_ItemEquipepdFrame(p91, u9, u35, ItemSelected.ItemId)
                });
            end;
        end),
        u8:State(function(p95, p96) -- Line: 699
            -- upvalues: u12 (copy), CircleButton (ref), ItemSelected (ref)
            if p95(u12) == true then
                return p96:Create("Frame")({
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.fromOffset(0, -5) + UDim2.fromScale(0.035, -0.035),
                    Size = p96:Animation(UDim2.fromScale(0.07, 0.07), p96.SpringInfo(0.25, 1, 0.6), {
                        From = UDim2.fromScale(0.035, 0.035)
                    }),
                    BackgroundTransparency = 1,
                    CleanDelay = 0.1,

                    CleanFunction = function(p97, p98) -- Line: 711, Name: CleanFunction
                        p97:Configure(p98)({
                            Size = p97:Animation(UDim2.fromScale(0, 0), p97.Info(0.2))
                        });
                    end,

                    CircleButton(p96, {
                        Image = "rbxassetid://140427393388249",

                        Clicked = function() -- Line: 718, Name: Clicked
                            -- upvalues: ItemSelected (ref)
                            ItemSelected.Value = "";
                        end
                    })
                });
            end;
        end),
        u8:Create("ScrollingFrame")({
            Name = "CharHolder",
            CanvasSize = u25,
            ScrollBarThickness = 0,
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            u8:Create("UIStroke")({
                Color = Color3.new(1, 1, 1),
                u8:Create("UIGradient")({
                    Rotation = 90,
                    Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.75), NumberSequenceKeypoint.new(0.4, 0.92), NumberSequenceKeypoint.new(1, 0.99) })
                })
            }),
            u8:Create("UICorner")({
                CornerRadius = UDim.new(0.0225)
            }),
            u8:Create("Frame")({
                Name = "ActualHolder",
                Size = u8:Animation(v24, u8.SpringInfo(0.35, 1, 0.65), {
                    AlwaysFrom = UDim2.new(0.885, -10, 0.885, -10)
                }),
                Position = UDim2.fromScale(0.5, 0.5),
                AnchorPoint = Vector2.new(0.5, 0.5),
                u8:Create("UICorner")({
                    CornerRadius = UDim.new(0.0225)
                }),
                BackgroundColor3 = Color3.new(0.25, 0.25, 0.25),
                u8:Create("UIGradient")({
                    Rotation = 90,
                    Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.4, 0.7), NumberSequenceKeypoint.new(1, 0.9) })
                }),
                BackgroundTransparency = 1,
                u8:Create("UIListLayout")({
                    Wraps = true,
                    HorizontalAlignment = Enum.HorizontalAlignment.Left,
                    VerticalAlignment = Enum.VerticalAlignment.Top,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDim.new(0.012945),

                    AbsoluteContentSizeOnChangedInit = function(p99: userdata) -- Line: 776, Name: AbsoluteContentSizeOnChangedInit
                        -- upvalues: u25 (copy)
                        u25:Set(UDim2.fromOffset(0, p99.AbsoluteContentSize.Y + 50));
                    end
                }),
                u8:AdvancedIterate(u14, function(p100, p101, p102) -- Line: 783
                    -- upvalues: script_Item (ref), u12 (copy), IdSelected (ref), ItemSelected (ref), u10 (copy), u78 (copy)
                    return script_Item(p102, p101, u12, IdSelected, ItemSelected, u10, u78);
                end)
            })
        }),
        script_Loadouts(u8, u84)
    });
end;