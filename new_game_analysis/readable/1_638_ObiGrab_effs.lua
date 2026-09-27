-- Decompiled with Potassium's decompiler.

game:GetService("Players");
game:GetService("TweenService");
game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local workspace_Debree = workspace.Debree;
local Assets = script:FindFirstChild("Assets");
local Sounds = script:FindFirstChild("Sounds");
script:FindFirstChild("Rigs");
local CAM = ReplicatedStorage.CAM;
local Modules = CAM.Client.Modules;
local DebrisModule = require(CAM.DebrisModule);
local Cam_Shaker = require(Modules.Effects.Cam_Shaker);
require(Modules.Effects.Craters.CraterExtension);
local TokenKit = require(Modules.Effects.Token.TokenKit);
local Ouwmit = require(ReplicatedStorage.CAM.Client.Modules.Effects.Ouwmit);
local vfxUtility = require(game.ReplicatedStorage.CAM.Client.Modules.Effects.vfxUtility);
local RaycastHelper = require(ReplicatedStorage.CAM.Global.RaycastHelper);
local OuwCraters = require(ReplicatedStorage.CAM.Client.Modules.Effects.Craters.OuwCraters);
local _ = game.Players.LocalPlayer;
local workspace_CurrentCamera = workspace.CurrentCamera;
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterDescendantsInstances = { workspace.Map };
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Include;

return function(p1: userdata, p2: string, u3: userdata) -- Line: 48
    -- upvalues: workspace_CurrentCamera (copy), vfxUtility (copy), Sounds (copy), Assets (copy), workspace_Debree (copy), DebrisModule (copy), RaycastHelper (copy), Ouwmit (copy), Cam_Shaker (copy), TokenKit (copy), OuwCraters (copy)
    if p1 == nil then
        return;
    end;

    local HumanoidRootPart = p1:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart == nil then
        return;
    end;

    if (HumanoidRootPart.Position - workspace_CurrentCamera.CFrame.Position).Magnitude > 250 then
        return;
    end;

    if p2 ~= "Miss" then
        if p2 == "Grabbed" then
            vfxUtility.PlaySound(Sounds, "PS2FleshManiOBIGRABgrabSTART", HumanoidRootPart, true);

            if p1:FindFirstChild("RightFoot") == nil then
                return;
            end;

            vfxUtility.PlaySound(Sounds, "PS2FleshManiOBIGRABslam", HumanoidRootPart, true);
            local u4 = Assets.Grabbed:Clone();
            u4.Parent = workspace_Debree;
            u4.CFrame = HumanoidRootPart.CFrame * CFrame.new(-0.0373, -0.36, -7.508) * CFrame.fromEulerAnglesYXZ(-0, -1.57, 0);
            local v5 = workspace:Raycast(HumanoidRootPart.CFrame.Position + Vector3.new(0, 5, 0), Vector3.new(-0, -15, -0), RaycastHelper.Crater);
            local v6 = v5 and vfxUtility.GetDustColorSettings(v5.Instance) or nil;
            Ouwmit.Emit(u4, v6);
            DebrisModule:AddItem(u4, 6);
            Cam_Shaker(u4.Position, {
                FadeInTime = 0,
                Frequency = 0.1,
                Amplitude = 0.4,
                SustainTime = 0.1,
                FadeOutTime = 0.5,
                RotationInfluence = Vector3.new(0.25, 0.25, 0.25),
                PositionInfluence = Vector3.new(3.5, 3.5, 3.5)
            });
            task.delay(0.4, function() -- Line: 104
            end);
            task.delay(0.6, function() -- Line: 108
                -- upvalues: Assets (ref), workspace_Debree (ref), HumanoidRootPart (copy), RaycastHelper (ref), vfxUtility (ref), Ouwmit (ref), DebrisModule (ref), Cam_Shaker (ref), u3 (copy), TokenKit (ref), u4 (copy)
                local v7 = Assets.Jump:Clone();
                v7.Parent = workspace_Debree;
                v7:PivotTo(HumanoidRootPart.CFrame);
                local v8 = workspace:Raycast(HumanoidRootPart.CFrame.Position + Vector3.new(0, 5, 0), Vector3.new(-0, -15, -0), RaycastHelper.Crater);
                local v9 = v8 and vfxUtility.GetDustColorSettings(v8.Instance) or nil;
                Ouwmit.Emit(v7, v9);
                DebrisModule:AddItem(v7, 4);
                Cam_Shaker(v7.PrimaryPart.Position, {
                    FadeInTime = 0.05,
                    Frequency = 0.05,
                    Amplitude = 0.05,
                    SustainTime = 0.5,
                    FadeOutTime = 0.5,
                    RotationInfluence = Vector3.new(0.25, 0.25, 0.25),
                    PositionInfluence = Vector3.new(3.5, 3.5, 3.5)
                });
                local v10 = u3:FindFirstChild("LeftFoot") or (u3:FindFirstChild("Left Leg") or u3:FindFirstChild("HumanoidRootPart"));

                if v10 ~= nil then
                    TokenKit.ParticlePull(Assets.Footfx:Clone(), v10, 1, 0.5);
                end;

                local v11 = Assets.SpinFX.Slash1:Clone();
                v11.Parent = HumanoidRootPart;
                vfxUtility.EmitAll(v11);
                DebrisModule:AddItem(v11, 3);
                Cam_Shaker(u4.Position, {
                    FadeInTime = 0.05,
                    Frequency = 0.05,
                    Amplitude = 0.05,
                    SustainTime = 0.5,
                    FadeOutTime = 0.5,
                    RotationInfluence = Vector3.new(0.25, 0.25, 0.25),
                    PositionInfluence = Vector3.new(3.5, 3.5, 3.5)
                });
            end);
            task.delay(1.5, function() -- Line: 154
                -- upvalues: Assets (ref), workspace_Debree (ref), HumanoidRootPart (copy), RaycastHelper (ref), vfxUtility (ref), Ouwmit (ref), DebrisModule (ref), Cam_Shaker (ref), u4 (copy), OuwCraters (ref), TokenKit (ref)
                local u12 = Assets.Hit:Clone();
                u12.Parent = workspace_Debree;
                u12:PivotTo(HumanoidRootPart.CFrame * CFrame.new(-0.8037, -2.47614, -7.95) * CFrame.fromEulerAnglesYXZ(-0, -1.57079, 0));
                local v13 = workspace:Raycast(HumanoidRootPart.CFrame.Position + Vector3.new(0, 5, 0), Vector3.new(-0, -15, -0), RaycastHelper.Crater);
                local v14 = v13 and vfxUtility.GetDustColorSettings(v13.Instance) or nil;
                Ouwmit.Emit(u12, v14);
                DebrisModule:AddItem(u12, 6);
                Cam_Shaker(u4.Position, {
                    FadeInTime = 0.1,
                    Frequency = 0.5,
                    Amplitude = 0.5,
                    SustainTime = 0.1,
                    FadeOutTime = 0.7,
                    RotationInfluence = Vector3.new(0.25, 0.25, 0.25),
                    PositionInfluence = Vector3.new(3.5, 3.5, 3.5)
                });
                OuwCraters.Scales({
                    Duration = 2.5,
                    Radius = 9,
                    ScaleMult = 0.75,
                    Center = u12.Hit.CFrame
                });
                task.spawn(function() -- Line: 183
                    -- upvalues: TokenKit (ref), u12 (copy)
                    TokenKit.GroundRocks({
                        InnerRadius = 5,
                        OuterRadius = 10,
                        CF = u12.PrimaryPart.CFrame,
                        Velocity = {
                            Min = 10,
                            Max = 30
                        },
                        Size = {
                            Min = 1,
                            Max = 3
                        }
                    });
                end);
            end);
        end;

        return;
    end;

    vfxUtility.PlaySound(Sounds, "PS2FleshManiOBIGRABgrabSTART", HumanoidRootPart, true);
    local v15 = Assets.Sweep:Clone();
    v15.Parent = workspace_Debree;
    v15:PivotTo(HumanoidRootPart.CFrame);
    DebrisModule:AddItem(v15, 3);
    local v16 = workspace:Raycast(HumanoidRootPart.CFrame.Position + Vector3.new(0, 5, 0), Vector3.new(-0, -15, -0), RaycastHelper.Crater);
    local v17 = v16 and vfxUtility.GetDustColorSettings(v16.Instance) or nil;
    Ouwmit.Emit(v15, v17);
end;