-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local DebrisModule = require(ReplicatedStorage.CAM.DebrisModule);
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Include;
RaycastParams_new_ret.FilterDescendantsInstances = { workspace.Map };
local v1 = {
    Id = {}
};
local EffectsEvent = require(ReplicatedStorage.Communication.ServerAndClient.Effects.EffectsEvent);

function v1.Hold(p2) -- Line: 10
    -- upvalues: DebrisModule (copy), EffectsEvent (copy)
    if p2 ~= nil and (p2.Character ~= nil and p2.Character:FindFirstChild("HumanoidRootPart") ~= nil) then
        if p2.Character:FindFirstChild("SHCS") == nil then
            return;
        end;

        local v3 = game.ReplicatedStorage.Player_Service.Values:FindFirstChild(p2.Name) or p2.Character;
        local HumanoidRootPart = p2.Character.HumanoidRootPart;
        local UpVector = HumanoidRootPart.CFrame.UpVector;

        if v3:FindFirstChild("Blocking") ~= nil then
            local StringValue = Instance.new("StringValue");
            StringValue.Name = "escapeiframe";
            StringValue.Parent = v3;
            DebrisModule:AddItem(StringValue, 0.125);
        end;

        EffectsEvent.ToOthersInRange(p2, "Double_Jump_Effect", HumanoidRootPart, UpVector);
    end;
end;

function v1.UnHold(p4) -- Line: 28
end;

function v1.Cancel(p5) -- Line: 31
end;

return v1;