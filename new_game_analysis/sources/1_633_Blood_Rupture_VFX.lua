-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Lighting = game:GetService("Lighting");
local ReplicatedStorage2 = game:GetService("ReplicatedStorage");
local CAM = ReplicatedStorage.CAM;
local Modules = CAM.Client.Modules;
local workspace_Debree = workspace.Debree;
local Assets = script:FindFirstChild("Assets");
local Sounds = script:FindFirstChild("Sounds");
local Ouwmit = require(CAM.Client.Modules.Effects.Ouwmit);
local Token = Modules.Effects.Token;
local DebrisModule = require(CAM.DebrisModule);
local Cam_Shaker = require(Modules.Effects.Cam_Shaker);
local OuwCraters = require(ReplicatedStorage2.CAM.Client.Modules.Effects.Craters.OuwCraters);
local CraterEffects = require(Modules.Effects.Craters.CraterEffects);
local ImpactFrames = require(Modules.Effects.ImpactFrames);
local TokenKit = require(Token.TokenKit);
local vfxUtility = require(game.ReplicatedStorage.CAM.Client.Modules.Effects.vfxUtility);
local LocalPlayer = game.Players.LocalPlayer;
local workspace_CurrentCamera = workspace.CurrentCamera;
local u1 = {
    {
        SlashOffset = CFrame.new(-2.48, -0.75, -26.28) * CFrame.fromEulerAnglesYXZ(-0.41, 1.89, 0.52),
        HitOffset = CFrame.new(0.02, -2.5, -28.6) * CFrame.fromEulerAnglesYXZ(-0, -1.57, 0),
        WindOffset = CFrame.new(-0.04, -2.89, -28.11) * CFrame.fromEulerAnglesYXZ(-0, -1.57, 0)
    },
    {
        SlashOffset = CFrame.new(1.57, -1.37, -26.11) * CFrame.fromEulerAnglesYXZ(-0.24, -2.18, -0.61),
        HitOffset = CFrame.new(0.02, -2.505007028579712, -28.60369873046875) * CFrame.fromEulerAnglesYXZ(-0, -1.5707963705062866, 0),
        WindOffset = CFrame.new(-0.0425412654876709, -2.8950772285461426, -28.118410110473633) * CFrame.fromEulerAnglesYXZ(-0, -1.5707963705062866, 0)
    },
    {
        SlashOffset = CFrame.new(-1.3021240234375, -0.22738003730773926, -26.65362548828125) * CFrame.fromEulerAnglesYXZ(-0.44045478105545044, 1.9469565153121948, 0.5047235488891602),
        HitOffset = CFrame.new(0.0234375, -2.505007028579712, -28.60369873046875) * CFrame.fromEulerAnglesYXZ(-0, -1.5707963705062866, 0),
        WindOffset = CFrame.new(-0.0425412654876709, -2.8950772285461426, -28.118410110473633) * CFrame.fromEulerAnglesYXZ(-0, -1.5707963705062866, 0)
    },
    {
        SlashOffset = CFrame.new(0.58966064453125, -0.547738790512085, -25.675201416015625) * CFrame.fromEulerAnglesYXZ(-0.14927302300930023, -2.0481066703796387, -0.6423813104629517),
        HitOffset = CFrame.new(0.0234375, -2.505007028579712, -28.60369873046875) * CFrame.fromEulerAnglesYXZ(-0, -1.5707963705062866, 0),
        WindOffset = CFrame.new(0.33966684341430664, -2.447082996368408, -27.004589080810547) * CFrame.fromEulerAnglesYXZ(-0, -1.480425238609314, 0)
    },
    {
        SlashOffset = CFrame.new(-0.40532398223876953, 1.1341500282287598, -23.777034759521484) * CFrame.fromEulerAnglesYXZ(-0.1217319667339325, 2.8925249576568604, 0.10485552996397018),
        HitOffset = CFrame.new(0.0234375, -2.505007028579712, -28.60369873046875) * CFrame.fromEulerAnglesYXZ(-0, -1.5707963705062866, 0),
        WindOffset = CFrame.new(-0.0425412654876709, -2.8950772285461426, -28.118410110473633) * CFrame.fromEulerAnglesYXZ(-0, -1.5707963705062866, 0)
    }
};

local function ParticlePull(p2: userdata, p3: userdata, p4: number, u5: number?) -- Line: 73
    -- upvalues: DebrisModule (copy)
    for _, child in p2:GetChildren() do
        child.Parent = p3;
        child.Enabled = true;
        task.delay(p4, function() -- Line: 78
            -- upvalues: child (copy), DebrisModule (ref), u5 (copy)
            child.Enabled = false;
            DebrisModule:AddItem(child, u5 or 2);
        end);
    end;
end;

local function BlurEffect(p6) -- Line: 86
    -- upvalues: DebrisModule (copy)
    local BlurEffect = Instance.new("BlurEffect");
    local game_Lighting = game.Lighting;
    BlurEffect.Size = 5;
    BlurEffect.Parent = game_Lighting;
    DebrisModule:AddItem(BlurEffect, p6 or 0.5);
end;

local function callSlashEffect(p7: userdata, p8: userdata, p9: number) -- Line: 93
    -- upvalues: Assets (copy), u1 (copy), vfxUtility (copy), DebrisModule (copy), TweenService (copy)
    local v10 = Assets.NezukoSlash1:Clone();
    v10.Parent = p8;
    v10:PivotTo(p7.CFrame * u1[p9].SlashOffset);
    vfxUtility.EmitAll(v10:GetDescendants());
    DebrisModule:AddItem(v10, 3);
    task.wait(0.1);
    local v11 = Assets.Hit:Clone();
    v11.Parent = p8;
    v11.CFrame = p7.CFrame * u1[p9].HitOffset;
    vfxUtility.EmitAll(v11:GetDescendants());
    DebrisModule:AddItem(v11, 6);
    local v12 = Assets.GroundWind:Clone();
    v12.Parent = p8;
    v12.CFrame = p7.CFrame * u1[p9].WindOffset;
    DebrisModule:AddItem(v12, 2);
    TweenService:Create(v12.Decal, TweenInfo.new(1), {
        Transparency = 1
    }):Play();
    TweenService:Create(v12, TweenInfo.new(1), {
        Orientation = Vector3.new(0, 230, 0)
    }):Play();
    TweenService:Create(v12, TweenInfo.new(0.5), {
        Size = Vector3.new(9.276, 0.07, 9.306)
    }):Play();
    TweenService:Create(v12.Mesh, TweenInfo.new(0.5), {
        Scale = Vector3.new(4.216, 0.268, 4.23)
    }):Play();

    if p9 ~= 4 then
        if p9 == 5 then
            local BlurEffect2 = Instance.new("BlurEffect");
            local game_Lighting = game.Lighting;
            BlurEffect2.Size = 5;
            BlurEffect2.Parent = game_Lighting;
            DebrisModule:AddItem(BlurEffect2, 0.5);
        end;

        return;
    end;

    local v13 = Assets.CamerDust2:Clone();
    v13.Parent = p8;
    v13.CFrame = p7.CFrame * CFrame.new(0.33966684341430664, -2.447082996368408, -27.004589080810547) * CFrame.fromEulerAnglesYXZ(-0, -1.480425238609314, 0);
    vfxUtility.EmitAll(v13:GetDescendants());
    DebrisModule:AddItem(v13, 6);
end;

return function(p14: userdata, p15: any, p16: userdata, p17: userdata) -- Line: 139
    -- upvalues: workspace_CurrentCamera (copy), workspace_Debree (copy), DebrisModule (copy), Assets (copy), vfxUtility (copy), Cam_Shaker (copy), Sounds (copy), Ouwmit (copy), TweenService (copy), ParticlePull (copy), callSlashEffect (copy), OuwCraters (copy), CraterEffects (copy), LocalPlayer (copy), ImpactFrames (copy), Lighting (copy), TokenKit (copy)
    local u18 = p14:FindFirstChild("HumanoidRootPart") or p14.PrimaryPart;

    if p15 ~= "Cancel" and (u18.Position - workspace_CurrentCamera.CFrame.Position).Magnitude > 100 then
        return;
    end;

    local u19 = { p14, p16 };
    local string_format_ret = string.format("%s Blood_Rupture_Effects", p14.Name);
    local u20 = workspace_Debree:FindFirstChild(string_format_ret);

    if p15 == "Start" then
        if u20 ~= nil then
            u20:Destroy();
        end;

        u20 = Instance.new("Folder");
        u20.Name = string_format_ret;
        u20.Parent = workspace_Debree;
        DebrisModule:AddItem(u20, 15);
        local v21 = Assets.StartEffect:Clone();
        v21.Parent = u20;
        v21.CFrame = u18.CFrame * CFrame.new(0, -1, 0);
        vfxUtility.EmitAll(v21:GetDescendants());
        DebrisModule:AddItem(v21, 6);
        Cam_Shaker(u18.Position, {
            FadeInTime = 0,
            Frequency = 0.1,
            Amplitude = 0.02,
            SustainTime = 0.5,
            FadeOutTime = 0.2,
            RotationInfluence = Vector3.new(0.25, 0.25, 0.25),
            PositionInfluence = Vector3.new(1, 1, 1)
        });
        vfxUtility.PlaySound(Sounds, "Start", u18, true);
    elseif u20 == nil then
        return;
    end;

    if p15 == "Movement" then
        local v22 = Assets.Dash:Clone();
        v22.Parent = u20;
        v22:PivotTo(u18.CFrame);
        Ouwmit.Emit(v22);
        DebrisModule:AddItem(v22, 6);
        vfxUtility.PlaySound(Sounds, "Dash", u18, true);
        local v23 = Assets.MovementThingy:Clone();
        v23.Parent = u20;
        v23.CFrame = u18.CFrame * CFrame.new(0.51, -1.39, 6.63);
        vfxUtility.EnableAll(v23, true);
        DebrisModule:AddItem(v23, 6);
        local Weld = Instance.new("Weld");
        Weld.Part0 = u18;
        Weld.Part1 = v23;
        Weld.Parent = u18;
        Weld.C0 = CFrame.new(0.51, -1.39, -0.63);
        DebrisModule:AddItem(Weld, 6);
    elseif p15 == "MovementStop" then
        local MovementThingy = u20:WaitForChild("MovementThingy", 2);

        if MovementThingy then
            MovementThingy.Parent = u20.Parent;

            for _, descendant in MovementThingy:GetDescendants() do
                if descendant:IsA("Beam") and descendant.Brightness == 1 then
                    TweenService:Create(descendant, TweenInfo.new(0.1), {
                        Brightness = 0
                    }):Play();
                end;
            end;

            task.wait(0.1);
            vfxUtility.EnableAll(MovementThingy, false);
            DebrisModule:AddItem(MovementThingy, 1.5);
        end;
    elseif p15 == "Hit" then
        local v24 = Assets.MaceHitfr:Clone();
        v24.Parent = u20;
        v24.CFrame = u18.CFrame * CFrame.new(-0.27, -1.45, -1.87) * CFrame.fromEulerAnglesYXZ(-0, -1.57, 1.56);
        vfxUtility.EmitAll(v24:GetDescendants());
        DebrisModule:AddItem(v24, 6);
        Cam_Shaker(u18.Position, {
            FadeInTime = 0,
            Frequency = 0.1,
            Amplitude = 0.06,
            SustainTime = 0.5,
            FadeOutTime = 0.2,
            RotationInfluence = Vector3.new(0.25, 0.25, 0.25),
            PositionInfluence = Vector3.new(1, 1, 1)
        });
    elseif p15 == "Initial" then
        local v25 = p16:FindFirstChild("LeftFoot") or (p16:FindFirstChild("Left Leg") or p16:FindFirstChild("HumanoidRootPart"));

        if v25 ~= nil then
            ParticlePull(Assets.FootDust:Clone(), v25, 1.5, 0.5);
        end;

        task.delay(0.3, function() -- Line: 255
            -- upvalues: Assets (ref), u20 (ref), u18 (copy), vfxUtility (ref), DebrisModule (ref)
            local v26 = Assets.CamerDust:Clone();
            v26.Parent = u20;
            v26.CFrame = u18.CFrame * CFrame.new(0.33, -2.44, -27) * CFrame.fromEulerAnglesYXZ(-0, -1.48, 0);
            vfxUtility.EmitAll(v26:GetDescendants());
            DebrisModule:AddItem(v26, 6);
            task.wait(0.5);
            local BlurEffect2 = Instance.new("BlurEffect");
            local game_Lighting = game.Lighting;
            BlurEffect2.Size = 5;
            BlurEffect2.Parent = game_Lighting;
            DebrisModule:AddItem(BlurEffect2, 0.9);
        end);
    elseif p15 == "Slashes" then
        task.spawn(function() -- Line: 269
            -- upvalues: callSlashEffect (ref), u18 (copy), u20 (ref)
            local v27 = 0;

            for _, v in { 2.048, 0.715, 0.587, 0.377, 0.586 } do
                task.wait(v - 0.025);
                v27 = v27 + 1;
                task.spawn(callSlashEffect, u18, u20, v27);
            end;
        end);
    elseif p15 == "Stomp" then
        local u28 = Assets.FinalKick:Clone();
        u28.Parent = u20;
        u28:PivotTo(u18.CFrame * CFrame.new(-0.5455322265625, -2.9995005130767822, -27.00384521484375));
        Ouwmit.Emit(u28);
        DebrisModule:AddItem(u28, 5);
        local v29 = Assets.GroundWind:Clone();
        v29.CFrame = u18.CFrame * CFrame.new(-0.0425412654876709, -2.8950772285461426, -28.118410110473633) * CFrame.fromEulerAnglesYXZ(-0, -1.5707963705062866, 0);
        v29.Parent = u20;
        DebrisModule:AddItem(v29, 2);
        TweenService:Create(v29.Decal, TweenInfo.new(1), {
            Transparency = 1
        }):Play();
        TweenService:Create(v29, TweenInfo.new(1), {
            Orientation = Vector3.new(0, 230, 0)
        }):Play();
        TweenService:Create(v29, TweenInfo.new(0.5), {
            Size = Vector3.new(30.835, 4.039, 30.936)
        }):Play();
        TweenService:Create(v29.Mesh, TweenInfo.new(0.5), {
            Scale = Vector3.new(14.016, 15.467, 14.062)
        }):Play();
        local v30 = Assets.ShockGroundWind:Clone();
        v30.CFrame = u18.CFrame * CFrame.new(-0.4298224449157715, -0.11100435256958008, -28.766132354736328) * CFrame.fromEulerAnglesYXZ(-0, 3.1415927410125732, 0);
        v30.Parent = u20;
        DebrisModule:AddItem(v30, 3);
        TweenService:Create(v30.Decal, TweenInfo.new(2), {
            Transparency = 1
        }):Play();
        TweenService:Create(v30, TweenInfo.new(2), {
            Orientation = Vector3.new(0, 230, 0)
        }):Play();
        TweenService:Create(v30, TweenInfo.new(0.5), {
            Size = Vector3.new(20.632, 7.579, 20.698)
        }):Play();
        TweenService:Create(v30.Mesh, TweenInfo.new(0.5), {
            Scale = Vector3.new(9.378, 29.02, 9.408)
        }):Play();
        OuwCraters.Scales({
            Radius = 10,
            ScaleMult = 0.5,
            Duration = 4.5,
            Center = u28.PrimaryPart.CFrame
        });
        task.spawn(function() -- Line: 318
            -- upvalues: CraterEffects (ref), u28 (copy)
            CraterEffects.new("RisingRocks", u28.PrimaryPart.Position, {
                Iterations = 30,
                BlockSize = { 0.5, 1 },
                Radius = 12,
                Height = { 2, 9 },
                HoldTime = 1,
                AnimationSpeed = 0.1,
                Range = 100,
                delayTime = 0.01
            });
        end);
        TweenService:Create(u28.Crater.PointLight, TweenInfo.new(0.5), {
            Brightness = 30
        }):Play();
        task.wait(0.1);
        task.delay(0.25, function() -- Line: 335
            -- upvalues: LocalPlayer (ref), u19 (copy), ImpactFrames (ref)
            if LocalPlayer.Character and table.find(u19, LocalPlayer.Character) then
                ImpactFrames.PlaySet({
                    FrameRate = 0.03333333333333333,
                    FramesSetName = "Pyro_Part2"
                });
            end;
        end);
        local BlurEffect2 = Instance.new("BlurEffect");
        local game_Lighting = game.Lighting;
        BlurEffect2.Size = 5;
        BlurEffect2.Parent = game_Lighting;
        DebrisModule:AddItem(BlurEffect2, 0.5);
        task.wait(0.35);
        TweenService:Create(u28.Crater.BrightOne, TweenInfo.new(0.1), {
            Transparency = 0
        }):Play();
        task.spawn(function() -- Line: 352
            -- upvalues: Assets (ref), Lighting (ref)
            local v31 = Assets.ColorCorrection1:Clone();
            v31.Parent = Lighting;
            task.wait(0.05);
            v31:Destroy();
            local v32 = Assets.ColorCorrection2:Clone();
            v32.Parent = Lighting;
            task.wait(0.05);
            v32:Destroy();
        end);
        local BlurEffect3 = Instance.new("BlurEffect");
        local game_Lighting2 = game.Lighting;
        BlurEffect3.Size = 5;
        BlurEffect3.Parent = game_Lighting2;
        DebrisModule:AddItem(BlurEffect3, 0.5);
        task.spawn(function() -- Line: 370
            -- upvalues: Cam_Shaker (ref), u28 (copy), OuwCraters (ref), TokenKit (ref)
            Cam_Shaker(u28.PrimaryPart.Position, {
                FadeInTime = 0,
                Frequency = 0.1,
                Amplitude = 0.4,
                SustainTime = 0.1,
                FadeOutTime = 0.5,
                RotationInfluence = Vector3.new(0.25, 0.25, 0.25),
                PositionInfluence = Vector3.new(3.5, 3.5, 3.5)
            });
            OuwCraters.Scales({
                ScaleMult = 1.5,
                Radius = 15,
                Duration = 3.5,
                Center = u28.PrimaryPart.CFrame
            });

            for i = 1, 8 do
                task.spawn(function() -- Line: 388
                    -- upvalues: TokenKit (ref), u28 (ref), i (copy)
                    TokenKit.GroundRocks({
                        CF = u28.PrimaryPart.CFrame,
                        InnerRadius = i * 5 / 2,
                        OuterRadius = i * 10 / 2,
                        Velocity = {
                            Min = 10,
                            Max = 60
                        },
                        Size = {
                            Min = 2,
                            Max = 4
                        }
                    });
                    task.wait(0.1);
                end);
                local _ = i;
            end;
        end);
        task.wait(3);
        TweenService:Create(u28.Crater.BrightOne, TweenInfo.new(0.5), {
            Transparency = 1
        }):Play();
        TweenService:Create(u28.Crater.notBrightOne, TweenInfo.new(0.5), {
            Transparency = 1
        }):Play();
    elseif p15 == "UltimateCamera" then
        local u33 = p17 or workspace_Debree:WaitForChild(p14.Name .. "_BloodRuptureCam", 0.2);

        if u33 == nil then
            return;
        end;

        local u34 = Assets.CameraVFX:Clone();
        u34.Parent = u20;
        u34:PivotTo(u33.PrimaryPart.CFrame);
        local RigidConstraint = u34.Bone.Attachment.RigidConstraint;
        local camattach = u34.Bone.camattach;
        DebrisModule:AddItem(u34, 6);
        camattach.Parent = u33:FindFirstChild("Bone");
        RigidConstraint.Attachment1 = camattach;
        Ouwmit.Emit(u34.WindStuff1);
        task.delay(2, function() -- Line: 427
            -- upvalues: Assets (ref), u20 (ref), u18 (copy), DebrisModule (ref), Ouwmit (ref), u33 (ref), u34 (copy)
            local morebgfx = Assets:FindFirstChild("morebgfx");

            if morebgfx then
                local v35 = morebgfx:Clone();
                v35.Parent = u20;
                v35:PivotTo(u18.CFrame);
                DebrisModule:AddItem(v35, 7);
                Ouwmit.Emit(v35);
                DebrisModule:AddItem(v35.Extras, 4.5);
            end;

            local v36 = Assets.Camera_VFX:Clone();
            v36.Parent = u20;
            v36:PivotTo(u33.PrimaryPart.CFrame);
            local RigidConstraint2 = v36.Bone.Attachment.RigidConstraint;
            local camattach2 = v36.Bone.camattach;
            DebrisModule:AddItem(v36, 6);
            camattach2.Parent = u33:FindFirstChild("Bone");
            RigidConstraint2.Attachment1 = camattach2;
            Ouwmit.Emit(v36.CameraAuraFX);
            task.wait(1);
            Ouwmit.Emit(u34.FireAura);
        end);
    elseif p15 == "Cancel" then
        u20:Destroy();
    end;
end;