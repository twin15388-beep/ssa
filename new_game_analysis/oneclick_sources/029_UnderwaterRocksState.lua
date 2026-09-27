-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.CAM.Global.Types.MiscTypes);
local PickupState = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests.PickupState);
local u1 = ReplicatedStorage.Assets.Quests:FindFirstChild("Sea Crystal");

return function(p2: string) -- Line: 9
 -- upvalues: PickupState (copy), u1 (copy)
 return PickupState.forTask(p2, "Underwater Rocks", {
 ObjectText = "Sea Crystal",
 Model = u1
 });
end;