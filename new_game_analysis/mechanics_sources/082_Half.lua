-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local GridContent = require(script.Parent.GridContent);
require(ReplicatedStorage.Packages.faye);

return function(p1: any, p2: any, p3: any, p4: table, p5: any, p6: any, p7: any) -- Line: 7
    -- upvalues: GridContent (copy)
    return p1:Create("Frame")({
        Name = p3.Name,
        Size = UDim2.fromScale(1, 0.5),
        p4,
        BackgroundTransparency = 1,
        p1:Create("UIAspectRatioConstraint")({
            AspectRatio = 1
        }),
        GridContent(p1, p2, p3, p5, "Half", p6, p7)
    });
end;