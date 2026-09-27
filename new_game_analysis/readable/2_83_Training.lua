-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local LocalPlayer = game.Players.LocalPlayer;
local valuesfolder = Utility.getvaluesfolder(LocalPlayer, true);
local u1 = {};

for _, v in ipairs(ReplicatedStorage.CAM.Global.Training:QueryDescendants("ModuleScript#Client")) do
    local success, result = pcall(require, v);

    if success then
        u1[v.Parent.Name] = result;
    else
        warn((`[Training] client module {v.Parent.Name} failed to load: {result}`));
    end;
end;

local u2 = {};
valuesfolder.ChildAdded:Connect(function(p3: userdata) -- Line: 22
    -- upvalues: u1 (copy), LocalPlayer (copy), u2 (copy)
    if p3.Name ~= "Training" then
        return;
    end;

    local Attribute = p3:GetAttribute("Type");

    if u1[Attribute] == nil then
        return;
    end;

    local v4 = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait();
    local Items_Config = LocalPlayer:FindFirstChild("Items_Config");

    if Items_Config and Items_Config:FindFirstChild("Equipped") then
        Items_Config.Equipped.Value = 0;
    end;

    u2[p3] = {
        Type = Attribute,
        Character = v4
    };
    local Prompt = p3:WaitForChild("Prompt", 5);

    if u2[p3] == nil then
        return;
    end;

    if Prompt then
        Prompt = Prompt.Value;
    end;

    u1[Attribute].Do(LocalPlayer, v4, p3, Prompt);
end);
valuesfolder.ChildRemoved:Connect(function(p5: userdata) -- Line: 46
    -- upvalues: u2 (copy), u1 (copy), LocalPlayer (copy)
    local v6 = u2[p5];

    if v6 == nil then
        return;
    end;

    u2[p5] = nil;
    u1[v6.Type].Stop(LocalPlayer, v6.Character, p5);
end);