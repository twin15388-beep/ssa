-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Situations = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Situations);
local LocalPlayer = Players.LocalPlayer;

for _, v in { "Situation", "SecondarySituation" } do
    local u1 = nil;

    local function upd() -- Line: 23
        -- upvalues: LocalPlayer (copy), v (copy), u1 (ref), Situations (copy)
        local Attribute = LocalPlayer:GetAttribute(v);

        if Attribute == u1 then
            return;
        end;

        local v2 = u1;
        u1 = Attribute;
        Situations.Swap(LocalPlayer, v2, Attribute);
    end;

    LocalPlayer:GetAttributeChangedSignal(v):Connect(upd);
    local Attribute = LocalPlayer:GetAttribute(v);

    if Attribute ~= u1 then
        local v3 = u1;
        u1 = Attribute;
        Situations.Swap(LocalPlayer, v3, Attribute);
    end;
end;