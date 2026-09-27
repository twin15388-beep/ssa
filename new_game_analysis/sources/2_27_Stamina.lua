-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local script_Parent = script.Parent;
local Humanoid = script.Parent:WaitForChild("Humanoid");
require(ReplicatedStorage.CAM.Global.Utility);
local StaminaComponent = require(ReplicatedStorage.CAM.Client.Components.Client.StaminaComponent);
local HumanoidRootPart = script_Parent:WaitForChild("HumanoidRootPart");
local BillboardGui = Instance.new("BillboardGui");
BillboardGui.Name = "Stamina";
BillboardGui.AlwaysOnTop = true;
BillboardGui:AddTag("Billboards");
BillboardGui.StudsOffset = Vector3.new(0, -3.25, 0);
BillboardGui.Size = UDim2.fromScale(1.65, 0.14);
BillboardGui.Parent = HumanoidRootPart;
local u1 = StaminaComponent(BillboardGui);
local u2 = nil;
u2 = Humanoid.Died:Connect(function() -- Line: 20
    -- upvalues: u2 (ref), u1 (ref)
    if u2 then
        u2:Disconnect();
        u2 = nil;
    end;

    if u1 ~= nil then
        u1();
        u1 = nil;
    end;
end);