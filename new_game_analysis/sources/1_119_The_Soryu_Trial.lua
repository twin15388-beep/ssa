-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local PickupState = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests.PickupState);
local Scroll = ReplicatedStorage.Assets.Quests:FindFirstChild("Scroll");

return PickupState.forTask("Ill learn the Soryu Style(Lv 62)", "Soryu Scroll", {
    ObjectText = "Soryu Scroll",
    Model = Scroll
});