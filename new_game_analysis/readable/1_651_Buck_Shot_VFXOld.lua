-- Decompiled with Potassium's decompiler.

local CAM = game:GetService("ReplicatedStorage").CAM;
local script_Assets = script.Assets;
local DebrisModule = require(CAM.DebrisModule);
local vfxUtility = require(CAM.Client.Modules.Effects.vfxUtility);
local Ouwmit = require(CAM.Client.Modules.Effects.Ouwmit);
local OuwCraters = require(CAM.Client.Modules.Effects.Craters.OuwCraters);
local Cam_Shaker = require(CAM.Client.Modules.Effects.Cam_Shaker);
local RaycastHelper = require(CAM.Global.RaycastHelper);

local function destroyRig(p1: userdata) -- Line: 26
    -- upvalues: vfxUtility (copy), DebrisModule (copy)
    local v2 = workspace.Debree:FindFirstChild((`{p1.Name}-BuckShotWindBeams`));

    if v2 and v2.Parent then
        vfxUtility.EnableAll(v2, false);
        v2.Name = "--";
        DebrisModule:AddItem(v2, 1.3);
    end;
end;

return function(p3: userdata, p4: string, p5, p6) -- Line: 35
    -- upvalues: vfxUtility (copy), DebrisModule (copy), RaycastHelper (copy), Ouwmit (copy), script_Assets (copy), Cam_Shaker (copy), OuwCraters (copy)
    if p3 == nil then
        return;
    end;

    local v7 = workspace.Debree:FindFirstChild((`{p3.Name}-BuckShotWindBeams`));

    if v7 and v7.Parent then
        vfxUtility.EnableAll(v7, false);
        v7.Name = "--";
        DebrisModule:AddItem(v7, 1.3);
    end;

    if p4 == "Cancel" or p4 == "Start" then
        return;
    end;

    local v8 = p3:FindFirstChild("HumanoidRootPart") or p3.PrimaryPart;

    if v8 == nil then
        return;
    end;

    local v9 = p5 or v8.CFrame;
    local v10;

    if p4 == "Kick" then
        v10 = nil;
    else
        local v11 = workspace:Raycast(v9.Position + Vector3.new(0, 5, 0), Vector3.new(-0, -15, -0), RaycastHelper.Crater);
        v10 = v11 and vfxUtility.GetDustColorSettings(v11.Instance) or nil;
    end;

    if p4 ~= "Shot" then
        if p4 ~= "Kick" then
            if p4 == "Slam" then
                vfxUtility.PlaySound(script.Sounds, "PS2shotgunBUCKSHOTslam", v8, true);
                Ouwmit.Emit(vfxUtility.cloneAsset(script_Assets, workspace.Debree, "Slam", v9, 4), v10);
                local v12;

                if p6 then
                    v12 = p6.Position;
                else
                    v12 = v9.Position;
                end;

                local v13 = workspace:Raycast(v12 + Vector3.new(0, 5, 0), Vector3.new(-0, -15, -0), RaycastHelper.Crater);

                if v13 then
                    local CFrame_new_ret = CFrame.new(v13.Position);
                    OuwCraters.Scales({
                        Radius = 4,
                        Count = 7,
                        ScaleMult = 0.4,
                        OffsetMargin = 3,
                        Center = CFrame_new_ret
                    });
                    OuwCraters.Scales({
                        Radius = 6,
                        Count = 9,
                        ScaleMult = 0.6,
                        OffsetMargin = 4,
                        Center = CFrame_new_ret
                    });
                end;

                Cam_Shaker(v12, "medium_shake_preset");
            end;

            return;
        end;

        vfxUtility.PlaySound(script.Sounds, "PS2shotgunBUCKSHOTspin", v8, true);
        Ouwmit.Emit(vfxUtility.cloneAsset(script_Assets, workspace.Debree, "Spin", v9, 4), v10);
        Cam_Shaker(v9.Position, "Medium_tiny_shake_preset");

        return;
    end;

    vfxUtility.PlaySound(script.Sounds, "PS2shotgunBUCKSHOTshoot", v8, true);
    Ouwmit.Emit(vfxUtility.cloneAsset(script_Assets, workspace.Debree, "Shot", v9, 4), v10);
    Ouwmit.Emit(vfxUtility.cloneAsset(script_Assets, workspace.Debree, "Dash", v9, 4), v10);
    local v14 = vfxUtility.cloneAsset(script_Assets, workspace.Debree, "WindBeams", v8.CFrame, 8);

    if v14 then
        v14.Name = `{p3.Name}-BuckShotWindBeams`;
        v14.Anchored = false;
        v14.Massless = true;
        local WeldConstraint = Instance.new("WeldConstraint");
        WeldConstraint.Part0 = v8;
        WeldConstraint.Part1 = v14;
        WeldConstraint.Parent = v14;
        vfxUtility.EnableAll(v14, true);
    end;

    Cam_Shaker(v9.Position, "activate_shake");
end;