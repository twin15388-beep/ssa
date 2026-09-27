-- Decompiled with Potassium's decompiler.

game:GetService("Players");
local TweenService = game:GetService("TweenService");
game:GetService("RunService");
local CAM = game:GetService("ReplicatedStorage").CAM;
local Modules = CAM.Client.Modules;
local workspace_Debree = workspace.Debree;
local Assets = script:FindFirstChild("Assets");
local Sounds = script:FindFirstChild("Sounds");
local Token = Modules.Effects.Token;
local Ouwmit = require(CAM.Client.Modules.Effects.Ouwmit);
local DebrisModule = require(CAM.DebrisModule);
local OuwCraters = require(CAM.Client.Modules.Effects.Craters.OuwCraters);
local Cam_Shaker = require(Modules.Effects.Cam_Shaker);
require(Modules.Effects.Craters.CraterExtension);
local RaycastHelper = require(CAM.Global.RaycastHelper);
require(Modules.Effects.BoatTween);
require(Token.BezierCurve);
require(Token.TokenUtility);
local TokenKit = require(Token.TokenKit);
local vfxUtility = require(game.ReplicatedStorage.CAM.Client.Modules.Effects.vfxUtility);
local _ = game.Players.LocalPlayer;
local workspace_CurrentCamera = workspace.CurrentCamera;

return function(p1: userdata, p2: string, p3: any) -- Line: 46
    -- upvalues: workspace_CurrentCamera (copy), workspace_Debree (copy), DebrisModule (copy), Assets (copy), vfxUtility (copy), Sounds (copy), Cam_Shaker (copy), Ouwmit (copy), TweenService (copy), OuwCraters (copy), TokenKit (copy), RaycastHelper (copy)
    local u4 = p1:FindFirstChild("HumanoidRootPart") or p1.PrimaryPart;
    p1:FindFirstChild("UpperTorso");

    if p2 ~= "Cancel" and (u4.Position - workspace_CurrentCamera.CFrame.Position).Magnitude > 250 then
        return;
    end;

    local string_format_ret = string.format("%s Heel_Bash_Effects", p1.Name);
    local u5 = workspace_Debree:FindFirstChild(string_format_ret);

    if p2 == "Start" then
        if u5 ~= nil then
            u5:Destroy();
        end;

        u5 = Instance.new("Folder");
        u5.Name = string_format_ret;
        u5.Parent = workspace_Debree;
        DebrisModule:AddItem(u5, 10);
        local v6 = Assets.SkillInitialFX:Clone();
        v6.Parent = u5;
        v6.CFrame = u4.CFrame * CFrame.new(0, -1, 0);
        vfxUtility.EmitAll(v6:GetDescendants());
        DebrisModule:AddItem(v6, 6);
        vfxUtility.PlaySound(Sounds, "Attempt", u4, true);
        Cam_Shaker(u4.Position, {
            FadeInTime = 0,
            Frequency = 0.2,
            Amplitude = 0.075,
            SustainTime = 0.5,
            FadeOutTime = 0.2,
            RotationInfluence = Vector3.new(0.25, 0.25, 0.25),
            PositionInfluence = Vector3.new(1, 1, 1)
        });
    elseif u5 == nil then
        return;
    end;

    if p2 == "Teleport" then
        local u7 = Assets.TeleportLines:Clone();
        u7.CFrame = u4.CFrame;
        u7.Parent = u5;
        vfxUtility.EmitAll(u7:GetDescendants());
        DebrisModule:AddItem(u7, 5);
        vfxUtility.PlaySound(Sounds, "Teleport", u4, true);

        for _, descendant in p1:GetDescendants() do
            if (descendant:IsA("MeshPart") or descendant:IsA("Part")) and descendant.Transparency == 0 then
                descendant.Transparency = 1;
                task.delay(0.1, function() -- Line: 105
                    -- upvalues: descendant (copy)
                    descendant.Transparency = 0;
                end);
            end;
        end;

        task.delay(0.1, function() -- Line: 112
            -- upvalues: u7 (copy), u4 (copy), vfxUtility (ref)
            u7.CFrame = u4.CFrame * CFrame.new(0, -2, 0);
            vfxUtility.EmitAll(u7:GetDescendants());
        end);
    elseif p2 == "Punch" then
        local v8 = Assets.Impact2:Clone();
        v8:PivotTo(u4.CFrame * CFrame.new(-0.2056884765625, -0.15644621849060059, -3.944091796875) * CFrame.fromEulerAnglesYXZ(-0, -1.5707963705062866, 1.5707963705062866));
        v8.Parent = u5;
        Ouwmit.Emit(v8);
        DebrisModule:AddItem(v8, 6);
        TweenService:Create(v8.Impact2.SurfaceLight, TweenInfo.new(0.3), {
            Brightness = 0
        }):Play();
        TweenService:Create(v8.Impact2.PointLight, TweenInfo.new(1), {
            Brightness = 0
        }):Play();
        Cam_Shaker(v8.Impact2.Position, {
            FadeInTime = 0,
            Frequency = 0.1,
            Amplitude = 0.5,
            SustainTime = 0.1,
            FadeOutTime = 0.3,
            RotationInfluence = Vector3.new(0.25, 0.25, 0.25),
            PositionInfluence = Vector3.new(3.5, 3.5, 3.5)
        });
    elseif p2 == "Kick" then
        local RightFoot = p1:FindFirstChild("RightFoot");
        task.delay(0.2, function() -- Line: 138
            -- upvalues: Assets (ref), RightFoot (copy), u5 (ref), vfxUtility (ref), DebrisModule (ref)
            local v9 = Assets.FireRFoot:Clone();
            v9:PivotTo(RightFoot.CFrame);
            v9.Anchored = false;
            v9.Parent = u5;
            local Weld = Instance.new("Weld");
            Weld.Part0 = RightFoot;
            Weld.Part1 = v9;
            Weld.Parent = RightFoot;
            vfxUtility.EnableAll(v9, true);
            DebrisModule:AddItem(v9, 4);
            local v10 = Assets.HandInirial:Clone();
            v10.CFrame = v9.CFrame;
            v10.Parent = u5;
            vfxUtility.EmitAll(v10:GetDescendants());
            DebrisModule:AddItem(v10, 6);
            task.wait(0.5);
            vfxUtility.EnableAll(v9, false);
        end);
    elseif p2 == "Slam" then
        local v11 = CFrame.new(p3 or u4.Position - Vector2.new(0, 2.5, 0)) * u4.CFrame.Rotation;
        local u12 = Assets.NezGroundCrater3:Clone();
        u12.CFrame = v11 * CFrame.new(0, -1.5, 0);
        u12.Parent = u5;
        Ouwmit.Emit(u12);
        DebrisModule:AddItem(u12, 6);
        OuwCraters.Scales({
            Radius = 10,
            Count = 15,
            ScaleMult = 1.3,
            OffsetMargin = 4,
            Center = u4
        });
        OuwCraters.Scales({
            Radius = 19,
            Count = 15,
            ScaleMult = 0.9,
            OffsetMargin = 4,
            Center = u4
        });
        OuwCraters.Scales({
            Radius = 22,
            Count = 18,
            ScaleMult = 1.1,
            OffsetMargin = 7,
            Center = u4
        });
        task.spawn(function() -- Line: 194
            -- upvalues: TokenKit (ref), u12 (copy), RaycastHelper (ref)
            TokenKit.GroundRocks({
                InnerRadius = 19,
                OuterRadius = 21,
                CF = u12.CFrame,
                Velocity = {
                    Min = 20,
                    Max = 40
                },
                Size = {
                    Min = 1,
                    Max = 3
                },
                RayParams = RaycastHelper.Crater
            });
        end);
        TweenService:Create(u12.PointLightAtt.PointLight, TweenInfo.new(1), {
            Brightness = 0
        }):Play();
        Cam_Shaker(v11.Position, {
            FadeInTime = 0,
            Frequency = 0.125,
            Amplitude = 1.1,
            SustainTime = 0.2,
            FadeOutTime = 0.5,
            RotationInfluence = Vector3.new(0.25, 0.25, 0.25),
            PositionInfluence = Vector3.new(3.5, 3.5, 3.5)
        });
    end;
end;