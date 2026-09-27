-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Teleporter = require(ReplicatedStorage.CAM.Client.Modules.Teleporter);

return function(p1: string, p2: any) -- Line: 12
    -- upvalues: Teleporter (copy)
    if p1 ~= "Show" then
        if p1 == "Hide" then
            Teleporter.HideCover();
        end;

        return;
    end;

    local ShowCover = Teleporter.ShowCover;

    if typeof(p2) ~= "table" then
        p2 = nil;
    end;

    ShowCover(p2);
end;