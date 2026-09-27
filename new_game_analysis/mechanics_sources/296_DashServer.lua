-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local DebrisModule = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("DebrisModule"));
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Include;
RaycastParams_new_ret.FilterDescendantsInstances = { workspace.Map };
local v1 = {
    Id = {}
};
local EffectsEvent = require(ReplicatedStorage.Communication.ServerAndClient.Effects.EffectsEvent);
local Config = require(script.Parent.Config);

function v1.Hold(p2) -- Line: 11
    -- upvalues: RaycastParams_new_ret (copy), DebrisModule (copy), Config (copy), EffectsEvent (copy)
    if p2 ~= nil and (p2.Character ~= nil and p2.Character:FindFirstChild("HumanoidRootPart") ~= nil) then
        local SHCS = p2.Character:FindFirstChild("SHCS");

        if SHCS == nil then
            return;
        end;

        local v3 = game.ReplicatedStorage.Player_Service.Values:FindFirstChild(p2.Name) or p2.Character;
        local Attribute = SHCS:GetAttribute("CK");
        local HumanoidRootPart = p2.Character.HumanoidRootPart;
        local lookVector = HumanoidRootPart.CFrame.lookVector;

        if Attribute == "S" then
            lookVector = lookVector * -1;
        end;

        if Attribute == "A" then
            lookVector = HumanoidRootPart.CFrame.rightVector * -1;
        end;

        if Attribute == "D" then
            lookVector = HumanoidRootPart.CFrame.rightVector;
        end;

        local v4 = "Land";
        local v5 = workspace:Raycast(HumanoidRootPart.Position, Vector3.new(0, -10, 0), RaycastParams_new_ret);

        if v3:FindFirstChild("Blocking") ~= nil then
            local StringValue = Instance.new("StringValue");
            StringValue.Name = "escapeiframe";
            StringValue.Parent = v3;
            DebrisModule:AddItem(StringValue, Config.BLOCK_ESCAPE_IFRAME_DURATION);
        end;

        if v5 == nil or v5.Instance == nil then
            local BoolValue = Instance.new("BoolValue");
            BoolValue.Name = "AIRDASHASD123";
            BoolValue.Parent = v3;
            DebrisModule:AddItem(BoolValue, Config.AIR_DASH_FLAG_DURATION);
            v4 = "Air";
        end;

        EffectsEvent.ToOthersInRange(p2, "dash_effect", HumanoidRootPart, lookVector, v4 == "Air", Config.ResolveCustomDash(p2));
    end;
end;

function v1.UnHold(p6) -- Line: 51
end;

function v1.Cancel(p7) -- Line: 54
end;

return v1;