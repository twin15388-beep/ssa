-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CAM = ReplicatedStorage.CAM;
local script_Assets = script.Assets;
local vfxUtility = require(CAM.Client.Modules.Effects.vfxUtility);
local Ouwmit = require(CAM.Client.Modules.Effects.Ouwmit);
local OuwCraters = require(CAM.Client.Modules.Effects.Craters.OuwCraters);
local Cam_Shaker = require(CAM.Client.Modules.Effects.Cam_Shaker);
local RaycastHelper = require(CAM.Global.RaycastHelper);
local Shotgun_Swings = require(ReplicatedStorage.Effects.Swings.Shotgun_Swings);

return function(p1: userdata, p2: string, p3, p4) -- Line: 23
    -- upvalues: RaycastHelper (copy), vfxUtility (copy), Cam_Shaker (copy), Ouwmit (copy), script_Assets (copy), OuwCraters (copy), Shotgun_Swings (copy)
    if p1 == nil then
        return;
    end;

    if p2 == "Cancel" or p2 == "Start" then
        return;
    end;

    local v5 = p1:FindFirstChild("HumanoidRootPart") or p1.PrimaryPart;

    if v5 == nil then
        return;
    end;

    local v6 = p3 or v5.CFrame;
    local v7 = workspace:Raycast(v6.Position + Vector3.new(0, 5, 0), Vector3.new(-0, -15, -0), RaycastHelper.Crater);
    local v8 = v7 and vfxUtility.GetDustColorSettings(v7.Instance) or nil;

    if p2 ~= "Grab" then
        if p2 == "Slam" then
            vfxUtility.PlaySound(script.Sounds, "PS2shotgunPOINTBLANKconnect", v5, true);
            local v9;

            if p4 then
                v9 = p4.Position;
            else
                v9 = v6.Position;
            end;

            local v10 = workspace:Raycast(v9 + Vector3.new(0, 5, 0), Vector3.new(-0, -15, -0), RaycastHelper.Crater);
            task.wait(0.6);

            if v5.Parent == nil then
                return;
            end;

            Ouwmit.Emit(vfxUtility.cloneAsset(script_Assets, workspace.Debree, "Slam", v6, 4), v8);
            Cam_Shaker(v6.Position, "Medium_tiny_shake_preset");

            if v10 then
                OuwCraters.Scales({
                    Radius = 5.5,
                    Count = 4,
                    ScaleMult = 1,
                    OffsetMargin = 2,
                    Center = v10.Position
                });
            end;

            task.wait(1.7333333333333334);

            if v5.Parent == nil then
                return;
            end;

            Shotgun_Swings.Flash(p1);
            Ouwmit.Emit(vfxUtility.cloneAsset(script_Assets, workspace.Debree, "Shot", v6, 4), v8);

            if v10 then
                OuwCraters.Scales({
                    Radius = 5,
                    Count = 3,
                    ScaleMult = 0.4,
                    OffsetMargin = 3,
                    Center = v10.Position
                });
                OuwCraters.Scales({
                    Radius = 8,
                    Count = 5,
                    ScaleMult = 0.6,
                    OffsetMargin = 4,
                    Center = v10.Position
                });
            end;

            Cam_Shaker(v9, "medium_shake_preset");
        end;

        return;
    end;

    vfxUtility.PlaySound(script.Sounds, "PS2shotgunPOINTBLANKattempt", v5, true);
    Cam_Shaker(v6.Position, "activate_shakelessaggresive");
    Ouwmit.Emit(vfxUtility.cloneAsset(script_Assets, workspace.Debree, "Grab", v6, 4), v8);
end;