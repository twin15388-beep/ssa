-- Decompiled with Potassium's decompiler.

local CAM = game:GetService("ReplicatedStorage").CAM;
local Ouwmit = require(CAM.Client.Modules.Effects.Ouwmit);
local vfxUtility = require(CAM.Client.Modules.Effects.vfxUtility);
local RaycastHelper = require(CAM.Global.RaycastHelper);
script:WaitForChild("m5");
script.m5:WaitForChild("Impact");
Ouwmit.Preload(script.m5.Impact.Dash.Windbeams.Part.WindBeams.ASide.Beam, script.m5.Impact.Dash.Windbeams.Part.WindBeams.BSide.Beam);
local DebrisModule = require(CAM.DebrisModule);
local WeaponAuras = require(script.Parent:WaitForChild("WeaponAuras"));
local u1 = {
    skipTrails = true,
    skipSound = true,
    anchorParts = {
        RightForearm = true,
        LeftForearm = true,
        Forearm = true,
        ["Meshes/Gauntlet_Dummy15.001 (4)"] = true,
        ["Meshes/Gauntlet_Dummy15.003"] = true
    }
};

local function playSound(p2: userdata, p3: number) -- Line: 41
    -- upvalues: DebrisModule (copy)
    local Sounds = script:FindFirstChild("Sounds");

    if Sounds == nil then
        return;
    end;

    local v4 = nil;

    if p3 == 6 then
        v4 = Sounds:FindFirstChild("PS2gauntletswingsUPTILT");
    else
        local Swings = Sounds:FindFirstChild("Swings");
        local v5 = Swings == nil and {} or Swings:GetChildren();

        if #v5 > 0 then
            table.sort(v5, function(p6, p7) -- Line: 51
                return p6.Name < p7.Name;
            end);

            if p3 == 1 or #v5 == 1 then
                v4 = v5[1];
            else
                v4 = v5[(p3 - 2) % (#v5 - 1) + 2];
            end;
        end;
    end;

    if v4 == nil then
        return;
    end;

    local v8 = v4:Clone();
    v8.Parent = p2;
    v8:Play();
    DebrisModule:AddItem(v8, v8.TimeLength + 1);
end;

local function emit(p9: userdata, p10: string) -- Line: 62
    -- upvalues: vfxUtility (copy), RaycastHelper (copy), Ouwmit (copy)
    if p9.Parent == nil then
        return;
    end;

    local v11 = vfxUtility.cloneAsset(script, workspace.Debree, p10, p9.CFrame, 3);

    if not v11 then
        if p10 == "m-1" then
            v11 = nil;
        else
            v11 = vfxUtility.cloneAsset(script, workspace.Debree, "m1", p9.CFrame, 3) or nil;
        end;
    end;

    if v11 == nil then
        return;
    end;

    local v12 = workspace:Raycast(p9.Position + Vector3.new(0, 5, 0), Vector3.new(-0, -15, -0), RaycastHelper.Crater);
    local v13 = v12 and vfxUtility.GetDustColorSettings(v12.Instance) or nil;
    Ouwmit.Emit(v11, v13);
end;

return function(p14, p15, p16) -- Line: 73
    -- upvalues: playSound (copy), WeaponAuras (copy), u1 (copy), emit (copy)
    if p14 == nil or p15 == nil then
        return;
    end;

    local HumanoidRootPart = p14:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart == nil then
        return;
    end;

    if (HumanoidRootPart.Position - workspace.CurrentCamera.CFrame.Position).Magnitude > 100 then
        return;
    end;

    playSound(HumanoidRootPart, p15);
    WeaponAuras(p14, p15, p16, u1);

    if p16 == true and p15 == 1 then
        task.delay(0.2, emit, HumanoidRootPart, "m-1");

        return;
    end;

    emit(HumanoidRootPart, "m" .. p15);
end;