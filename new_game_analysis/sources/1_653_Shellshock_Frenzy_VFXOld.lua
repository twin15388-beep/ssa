-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CAM = ReplicatedStorage.CAM;
local script_Assets = script.Assets;
local DebrisModule = require(CAM.DebrisModule);
local vfxUtility = require(CAM.Client.Modules.Effects.vfxUtility);
local Ouwmit = require(CAM.Client.Modules.Effects.Ouwmit);
local OuwCraters = require(CAM.Client.Modules.Effects.Craters.OuwCraters);
local Cam_Shaker = require(CAM.Client.Modules.Effects.Cam_Shaker);
local RaycastHelper = require(CAM.Global.RaycastHelper);
local Shotgun_Swings = require(ReplicatedStorage.Effects.Swings.Shotgun_Swings);

local function destroyRig(p1: userdata) -- Line: 28
    -- upvalues: vfxUtility (copy), DebrisModule (copy)
    local v2 = workspace.Debree:FindFirstChild((`{p1.Name}-ShellshockBarrageGround`));

    if v2 and v2.Parent then
        vfxUtility.EnableAll(v2, false, nil, true);
        v2.Name = "--";
        DebrisModule:AddItem(v2, 1.3);
    end;
end;

return function(p3: userdata, p4: string, p5, p6: any) -- Line: 37
    -- upvalues: destroyRig (copy), vfxUtility (copy), RaycastHelper (copy), Shotgun_Swings (copy), script_Assets (copy), Ouwmit (copy), Cam_Shaker (copy), OuwCraters (copy)
    if p3 == nil then
        return;
    end;

    if p4 == "Cancel" or p4 == "Start" then
        destroyRig(p3);
        local v7 = p4 == "Start" and (p3:FindFirstChild("HumanoidRootPart") or p3.PrimaryPart);

        if v7 then
            vfxUtility.PlaySound(script.Sounds, "PS2shotgunSHELLSHOCKFRENZYstart", v7, true);
        end;

        return;
    end;

    local v8 = p3:FindFirstChild("HumanoidRootPart") or p3.PrimaryPart;

    if v8 == nil then
        return;
    end;

    local v9 = p5 or v8.CFrame;
    local v10 = workspace:Raycast(v9.Position + Vector3.new(0, 5, 0), Vector3.new(-0, -15, -0), RaycastHelper.Crater);
    local v11 = v10 and vfxUtility.GetDustColorSettings(v10.Instance) or nil;

    if p4 ~= "Burst" then
        if p4 == "Jump" then
            destroyRig(p3);
            vfxUtility.PlaySound(script.Sounds, "PS2shotgunSHELLSHOCKFRENZYstop", v8, true);
            Ouwmit.Emit(vfxUtility.cloneAsset(script_Assets, workspace.Debree, "Jump", v9, 4), v11);
            Cam_Shaker(v9.Position, "activate_shake");

            return;
        end;

        if p4 ~= "Shell" then
            if p4 == "Explosion" then
                if typeof(p6) == "CFrame" then
                    v9 = p6;
                end;

                local v12 = workspace:Raycast(v9.Position + Vector3.new(0, 5, 0), Vector3.new(-0, -15, -0), RaycastHelper.Crater);
                local v13;

                if v12 then
                    v13 = vfxUtility.GetDustColorSettings(v12.Instance) or nil;
                else
                    v13 = nil;
                end;

                vfxUtility.PlaySound(script.Sounds, "PS2shotgunSHELLSHOCKFRENZYexplode", v8, true);
                Ouwmit.Emit(vfxUtility.cloneAsset(script_Assets, workspace.Debree, "Explosion", v9, 4), v13);

                if v12 then
                    local CFrame_new_ret = CFrame.new(v12.Position);
                    OuwCraters.Scales({
                        Radius = 6,
                        Count = 8,
                        ScaleMult = 0.9,
                        OffsetMargin = 3,
                        Center = CFrame_new_ret
                    });
                    OuwCraters.Scales({
                        Radius = 10,
                        Count = 10,
                        ScaleMult = 1.1,
                        OffsetMargin = 4,
                        Center = CFrame_new_ret
                    });
                end;

                Cam_Shaker(v9.Position, {
                    FadeInTime = 0,
                    Frequency = 0.12,
                    Amplitude = 1.1,
                    SustainTime = 0.14,
                    FadeOutTime = 0.4,
                    RotationInfluence = Vector3.new(0.25, 0.25, 0.25),
                    PositionInfluence = Vector3.new(1, 1, 1)
                });
            end;

            return;
        end;

        vfxUtility.PlaySound(script.Sounds, "PS2shotgunSHELLSHOCKFRENZYfinalshoot", v8, true);
        Ouwmit.Emit(vfxUtility.cloneAsset(script_Assets, workspace.Debree, "Shot", v9, 4), v11);
        Ouwmit.Emit(vfxUtility.cloneAsset(script_Assets, workspace.Debree, "ExplosiveShell", v9, 4), v11);

        return;
    end;

    local v14 = typeof(p6) == "number" and p6 % 2 == 0 and "PS2shotgunSHELLSHOCKFRENZYshot2" or "PS2shotgunSHELLSHOCKFRENZYshot1";
    vfxUtility.PlaySound(script.Sounds, v14, v8, true);
    Shotgun_Swings.Flash(p3);
    local RightFoot = p3:FindFirstChild("RightFoot");

    if RightFoot then
        local v15 = workspace.Debree:FindFirstChild((`{p3.Name}-ShellshockBarrageGround`));

        if v15 == nil then
            v15 = vfxUtility.cloneAsset(script_Assets, workspace.Debree, "BarrageGround", RightFoot.CFrame, 9);
            v15.Name = `{p3.Name}-ShellshockBarrageGround`;
            local Motor6D = Instance.new("Motor6D");
            Motor6D.Part0 = RightFoot;
            Motor6D.Part1 = v15;
            Motor6D.Parent = v15;
            vfxUtility.PlaySound(script.Sounds, "PS2shotgunSHELLSHOCKFRENZYloop", v15, false);
        end;

        Ouwmit.Emit(v15, v11);
    end;

    Cam_Shaker(v9.Position, "punch_shake");
end;