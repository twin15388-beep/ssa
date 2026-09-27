-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local PopUpCreator = require(ReplicatedStorage.CAM.Global.Subsets.Classes.PopUpCreator);

return function(p1: table) -- Line: 9
    -- upvalues: PopUpCreator (copy)
    if p1 == nil or p1.Text == nil then
        return;
    end;

    PopUpCreator.new({
        Type = "BigMessage",
        Content = p1.Text,
        Timout = p1.Timout,
        Color = p1.Color,
        BackgroundTransparency = p1.BackgroundTransparency,
        Sound = p1.Sound
    });
end;