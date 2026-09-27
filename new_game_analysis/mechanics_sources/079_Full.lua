-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local GridContent = require(script.Parent.GridContent);
require(ReplicatedStorage.Packages.faye);

return function(p1, p2, p3, p4, p5, p6) -- Line: 6
    -- upvalues: GridContent (copy)
    return p1:Create("Frame")({
        Name = p3.Name,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        GridContent(p1, p2, p3, p4, "Full", p5, p6)
    });
end;