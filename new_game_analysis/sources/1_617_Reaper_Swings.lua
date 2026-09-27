-- Decompiled with Potassium's decompiler.

local CAM = game:GetService("ReplicatedStorage").CAM;
local Cam_Shaker = require(CAM.Client.Modules.Effects.Cam_Shaker);
local Ouwmit = require(CAM.Client.Modules.Effects.Ouwmit);
local vfxUtility = require(CAM.Client.Modules.Effects.vfxUtility);
local RaycastHelper = require(CAM.Global.RaycastHelper);
local DebrisModule = require(CAM.DebrisModule);
local u1 = {
    [5] = true,
    [7] = true
};

local function pickSound(p2: number) -- Line: 29
    local Sounds = script:FindFirstChild("Sounds");

    if Sounds == nil then
        return nil;
    end;

    if p2 == 6 then
        return Sounds:FindFirstChild("PS2reaperSWINGSswing1uptilt");
    end;

    local Swings = Sounds:FindFirstChild("Swings");

    if Swings == nil then
        return nil;
    end;

    local Children = Swings:GetChildren();

    if #Children == 0 then
        return nil;
    end;

    table.sort(Children, function(p3, p4) -- Line: 39
        return p3.Name < p4.Name;
    end);

    if p2 == 1 or #Children == 1 then
        return Children[1];
    end;

    return Children[(p2 - 2) % (#Children - 1) + 2];
end;

return function(p5: userdata?, p6: number?, p7: boolean?) -- Line: 46
    -- upvalues: Cam_Shaker (copy), u1 (copy), pickSound (copy), DebrisModule (copy), vfxUtility (copy), RaycastHelper (copy), Ouwmit (copy)
    if p5 == nil or p6 == nil then
        return;
    end;

    local HumanoidRootPart = p5:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart == nil then
        return;
    end;

    if (HumanoidRootPart.Position - workspace.CurrentCamera.CFrame.Position).Magnitude > 100 then
        return;
    end;

    Cam_Shaker(HumanoidRootPart.Position, u1[p6] and "tinyshake_preset" or "punch_shake");
    local v8 = pickSound(p6);

    if v8 ~= nil then
        local v9 = v8:Clone();
        v9.Parent = HumanoidRootPart;
        v9:Play();
        DebrisModule:AddItem(v9, v9.TimeLength + 1);
    end;

    local v10 = vfxUtility.cloneAsset(script, workspace.Debree, "m" .. p6, HumanoidRootPart.CFrame, 3) or vfxUtility.cloneAsset(script, workspace.Debree, "m1", HumanoidRootPart.CFrame, 3);

    if v10 == nil then
        return;
    end;

    local v11 = workspace:Raycast(HumanoidRootPart.Position + Vector3.new(0, 5, 0), Vector3.new(-0, -15, -0), RaycastHelper.Crater);
    local v12 = v11 and vfxUtility.GetDustColorSettings(v11.Instance) or nil;
    Ouwmit.Emit(v10, v12);
end;