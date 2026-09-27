-- Decompiled with Potassium's decompiler.

local CAM = game:GetService("ReplicatedStorage").CAM;
local Ouwmit = require(CAM.Client.Modules.Effects.Ouwmit);
local vfxUtility = require(CAM.Client.Modules.Effects.vfxUtility);
local RaycastHelper = require(CAM.Global.RaycastHelper);
local DebrisModule = require(CAM.DebrisModule);
local Combat_Swings = require(script.Parent:WaitForChild("Combat_Swings"));
local u1 = {
    [6] = "Uptilt",
    [7] = "Downslam"
};

local function emit(p2: userdata, p3: string) -- Line: 31
    -- upvalues: vfxUtility (copy), RaycastHelper (copy), Ouwmit (copy)
    if p2.Parent == nil then
        return;
    end;

    local v4 = vfxUtility.cloneAsset(script, workspace.Debree, p3, p2.CFrame, 3) or vfxUtility.cloneAsset(script, workspace.Debree, "m1", p2.CFrame, 3);

    if v4 == nil then
        return;
    end;

    local v5 = workspace:Raycast(p2.Position + Vector3.new(0, 5, 0), Vector3.new(-0, -15, -0), RaycastHelper.Crater);
    local v6 = v5 and vfxUtility.GetDustColorSettings(v5.Instance) or nil;
    Ouwmit.Emit(v4, v6);
end;

local function playSound(p7: userdata) -- Line: 42
    -- upvalues: DebrisModule (copy)
    local v8 = script:FindFirstChildOfClass("Sound");

    if v8 == nil then
        return false;
    end;

    local v9 = v8:Clone();
    v9.Parent = p7;
    v9:Play();
    DebrisModule:AddItem(v9, v9.TimeLength + 1);

    return true;
end;

return function(p10, p11, p12) -- Line: 53
    -- upvalues: DebrisModule (copy), Combat_Swings (copy), emit (copy), u1 (copy)
    if p10 == nil or p11 == nil then
        return;
    end;

    local HumanoidRootPart = p10:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart == nil then
        return;
    end;

    if (HumanoidRootPart.Position - workspace.CurrentCamera.CFrame.Position).Magnitude > 100 then
        return;
    end;

    local v13 = script:FindFirstChildOfClass("Sound");
    local v14;

    if v13 == nil then
        v14 = false;
    else
        local v15 = v13:Clone();
        v15.Parent = HumanoidRootPart;
        v15:Play();
        DebrisModule:AddItem(v15, v15.TimeLength + 1);
        v14 = true;
    end;

    if v14 == false then
        Combat_Swings(p10, p11, p12);
    end;

    if p12 == true and p11 == 1 then
        task.delay(0.05, emit, HumanoidRootPart, "RunHit");

        return;
    end;

    emit(HumanoidRootPart, u1[p11] or "m" .. p11);
end;