-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Dialogue = require(ReplicatedStorage.CAM.Client.Modules.GamePlay.Dialogue);

return function(p1: string) -- Line: 11
    -- upvalues: Dialogue (copy)
    if typeof(p1) ~= "string" then
        return;
    end;

    Dialogue.OpenDialogue:Fire(p1);
end;