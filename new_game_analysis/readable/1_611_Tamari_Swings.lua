-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CAM = ReplicatedStorage.CAM;
local Cam_Shaker = require(CAM.Client.Modules.Effects.Cam_Shaker);
local Ouwmit = require(CAM.Client.Modules.Effects.Ouwmit);
local vfxUtility = require(CAM.Client.Modules.Effects.vfxUtility);
local RaycastHelper = require(CAM.Global.RaycastHelper);
local DebrisModule = require(ReplicatedStorage.CAM.DebrisModule);
local u1 = {
    [5] = true,
    [7] = true
};

return function(p2: userdata?, p3: number?, p4: boolean?) -- Line: 31
    -- upvalues: Cam_Shaker (copy), u1 (copy), vfxUtility (copy), DebrisModule (copy), RaycastHelper (copy), Ouwmit (copy)
    if p2 == nil then
        return;
    end;

    local HumanoidRootPart = p2:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart == nil then
        return;
    end;

    if (HumanoidRootPart.Position - workspace.CurrentCamera.CFrame.Position).Magnitude > 100 then
        return;
    end;

    if p4 == true and p3 == 1 then
        task.wait(0.065);

        if HumanoidRootPart.Parent == nil then
            return;
        end;
    end;

    Cam_Shaker(HumanoidRootPart.Position, u1[p3] and "tinyshake_preset" or "punch_shake");
    local v5 = vfxUtility.cloneAsset(script.Swings, workspace.Debree, p4 and p3 == 1 and "Runm" or "m" .. p3, HumanoidRootPart.CFrame, 3);
    local v6 = script.Swing:Clone();
    v6.Parent = HumanoidRootPart;
    v6:Play();
    DebrisModule:AddItem(v6, 1.5);
    local v7 = workspace:Raycast(HumanoidRootPart.Position + Vector3.new(0, 5, 0), Vector3.new(-0, -15, -0), RaycastHelper.Crater);
    local v8 = v7 and vfxUtility.GetDustColorSettings(v7.Instance) or nil;
    Ouwmit.Emit(v5, v8);
end;