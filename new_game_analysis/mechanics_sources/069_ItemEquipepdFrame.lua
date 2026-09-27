-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Items = require(ReplicatedStorage.CAM.Global.Collectibles.Items);
local Menum = require(ReplicatedStorage.CAM.Global.Menum);
local u1 = {
    Toolbar = require(script.EquippedOptions.Toolbar),
    Accessories = require(script.EquippedOptions.Accessories),
    Bait = require(script.EquippedOptions.Bait)
};

return function(p2: any, u3: userdata, u4: any) -- Line: 20
    -- upvalues: Items (copy), Menum (copy), u1 (copy)
    local u5 = {};
    local u6 = p2:Value(u5);
    local u7 = p2:Value(UDim2.fromScale(1, 1));

    local function updateItem(p8) -- Line: 25
        -- upvalues: u5 (copy), Items (ref), Menum (ref), u7 (copy), u6 (copy)
        table.clear(u5);

        if p8 == nil then
            table.insert(u5, "Toolbar");
        else
            local v9 = Items[p8.Name];

            if v9.EquipType == Menum.ItemEquipType.Toolbar then
                table.insert(u5, "Toolbar");
            elseif v9.EquipType == Menum.ItemEquipType.Accessory or (v9.EquipType == Menum.ItemEquipType.Costume or v9.EquipType == Menum.ItemEquipType.Clothing) then
                table.insert(u5, "Accessories");
            elseif v9.EquipType == Menum.ItemEquipType.Bait then
                table.insert(u5, "Bait");
            end;
        end;

        u7:Refresh();
        u6:Refresh();
    end;

    updateItem(u4:Get());
    p2:Connect(u4.Changed, updateItem);

    return p2:Create("Frame")({
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = p2:Animation(u7, p2.SpringInfo(0.25, 1, 0.65), {
            AlwaysFrom = UDim2.fromScale(0.97, 0.97)
        }),
        BackgroundTransparency = 1,
        p2:Create("Frame")({
            Name = "Eq",
            Size = UDim2.fromScale(1, 0.5),
            Position = UDim2.fromScale(0.5, 0.415),
            AnchorPoint = Vector2.new(0.5),
            BackgroundTransparency = 1,
            p2:Create("UIListLayout")({
                Wraps = true,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                FillDirection = Enum.FillDirection.Vertical,
                Padding = UDim.new(0.05, 0),
                SortOrder = Enum.SortOrder.Name
            }),
            p2:Iterate(u6, function(p10, p11, p12) -- Line: 68
                -- upvalues: u1 (ref), u3 (copy), u4 (copy)
                return u1[p11](p12, u3, u4);
            end)
        })
    });
end;