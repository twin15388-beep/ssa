-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Character_info_provider = require(ReplicatedStorage.CAM.Global.Character_info_provider);
local Items = require(ReplicatedStorage.CAM.Global.Collectibles.Items);
local CurPower = ReplicatedStorage.CAM.Client.Controllers.Skills_Provider:WaitForChild("CurPower");
local Animations = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Animations");

return {
    Is = function() -- Line: 34, Name: Is
        -- upvalues: CurPower (copy), Animations (copy), Character_info_provider (copy), Players (copy), Items (copy)
        for _, v in string.split(CurPower.Value, ",") do
            if v ~= "" and Animations:FindFirstChild(v .. "_Combat_Anims") ~= nil then
                return true;
            end;
        end;

        local _equipped_tool = Character_info_provider.Get_equipped_tool(Players.LocalPlayer);

        if _equipped_tool == nil then
            return false;
        end;

        local v1 = Items[_equipped_tool.Name];

        return v1 ~= nil and v1.HasCombat == true and true or Animations:FindFirstChild(_equipped_tool.Name .. "_Combat_Anims") ~= nil;
    end
};