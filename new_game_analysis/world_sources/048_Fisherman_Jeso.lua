-- Decompiled with Potassium's decompiler.

local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Types"):WaitForChild("NpcTypes"));
local Shop = script:FindFirstChild("Shop");
local CFrame_new_ret = CFrame.new(
 -192.001,
 806.932,
 602.667,
 0,
 -0.012993624,
 0.9999156,
 -0.001577827,
 0.999914348,
 0.012993609,
 -1,
 -0.001577693,
 -0.0000205
);
local v1 = {
 Name = "Fisherman Jeso",
 Icon = "rbxassetid://89282262782460",
 Marker = true,
 RequiresQuestDone = "Ill find the permit stamp(Lv 45)",
 Type = Menum.npcType.Stationary,
 Appearance = script:FindFirstChild("Model"),
 ModelAttributes = {
 NoDialogueTurn = true,
 NoDialogueAnim = true
 },
 Animations = {
 idle = { "rbxassetid://121102714052854" }
 }
};
local v2 = {};
local v3 = {
 SuccessDialogue = "Jeso_PurchaseSuccess",
 FailDialogue = "Jeso_PurchaseFail"
};
local v4;

if Shop then
 v4 = Shop:FindFirstChild("Basic Fishing Rod");
else
 v4 = Shop;
end;

v3.Model = v4;
v2["Basic Fishing Rod"] = v3;
local v5 = {
 SuccessDialogue = "Jeso_RarePurchaseSuccess",
 FailDialogue = "Jeso_RarePurchaseFail"
};

if Shop then
 Shop = Shop:FindFirstChild("Rare Fishing Rod");
end;

v5.Model = Shop;
v2["Rare Fishing Rod"] = v5;
v2.Worm = {};
v1.Shop = v2;
v1.Spawns = { CFrame_new_ret };

return v1;