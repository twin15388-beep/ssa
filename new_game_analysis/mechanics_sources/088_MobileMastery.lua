-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Packages.faye);
local GetMasteryStatus = require(ReplicatedStorage.CAM.Global.SkillService.GetMasteryStatus);
local MasteryItem = require(script.Parent.Toolbar.MasteryItem);

return function(p1: any, p2: userdata, p3: userdata) -- Line: 29
    -- upvalues: GetMasteryStatus (copy), MasteryItem (copy)
    local u4 = p1:Value(GetMasteryStatus.GetMasteries());
    p1:Connect(GetMasteryStatus.Changed, function(p5) -- Line: 31
        -- upvalues: u4 (copy)
        u4:Set(p5);
    end);

    return p1:Create("Frame")({
        Name = "MasteryHolder",
        Parent = p2,
        LayoutOrder = 10,
        Size = UDim2.fromScale(1, 0.6579999999999999),
        BackgroundTransparency = 1,
        Visible = p1:Do(function(p6) -- Line: 40
            -- upvalues: u4 (copy)
            local v7 = p6(u4);
            local v8;

            if v7 == nil then
                v8 = false;
            else
                v8 = #v7 > 0;
            end;

            return v8;
        end),
        p1:Create("Frame")({
            Name = "Actual",
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            p1:Create("UIListLayout")({
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                Padding = UDim.new(0, 5)
            }),
            p1:State(function(p9, p10, p11) -- Line: 54
                -- upvalues: u4 (copy), MasteryItem (ref)
                local v12 = p9(u4);

                if v12 ~= nil then
                    local v13 = {};

                    for _, v in ipairs(v12) do
                        table.insert(v13, MasteryItem(p10, v));
                    end;

                    return v13;
                end;
            end)
        })
    });
end;