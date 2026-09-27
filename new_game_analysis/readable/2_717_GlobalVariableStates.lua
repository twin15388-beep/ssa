-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local LocalPlayer = Players.LocalPlayer;

if not LocalPlayer.Character then
    LocalPlayer.CharacterAdded:Wait();
end;

local Data = require(ReplicatedStorage.CAM.Global.Utility).GetData(LocalPlayer, true);
local Character_info_provider = require(ReplicatedStorage.CAM.Global.Character_info_provider);
local Equipped = LocalPlayer:WaitForChild("Items_Config"):WaitForChild("Equipped");

function updToolEquipped()
    -- upvalues: Character_info_provider (copy), LocalPlayer (copy)
    local _equipped_tool = Character_info_provider.Get_equipped_tool(LocalPlayer);
    Character_info_provider.EquippedTool = _equipped_tool and _equipped_tool.Name or nil;
end;

updToolEquipped();
Equipped.Changed:Connect(updToolEquipped);
local v1 = {
    One = 1,
    Two = 2,
    Three = 3,
    Four = 4,
    Five = 5
};

for _, child in pairs(Data.Inventory.Toolbar:GetChildren()) do
    local u2 = v1[child.Name];
    child.Changed:Connect(function() -- Line: 33
        -- upvalues: Equipped (copy), u2 (copy)
        if Equipped.Value == u2 then
            updToolEquipped();
        end;
    end);
end;