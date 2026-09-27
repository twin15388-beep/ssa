-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
game:GetService("RunService");
local Modules = game:GetService("ReplicatedStorage").CAM.Client.Modules;
local Cam_Shaker = require(Modules.Effects.Cam_Shaker);
local CraterHandler = require(Modules.Effects.Craters.CraterHandler);
require(Modules.Effects.Craters.CraterEffects);
local _ = Players.LocalPlayer;
local Assets = script:FindFirstChild("Assets");
local workspace_Debree = workspace.Debree;
local Sounds = script:FindFirstChild("Sounds");
local vfxUtility = require(game.ReplicatedStorage.CAM.Client.Modules.Effects.vfxUtility);
local DebrisModule = require(game.ReplicatedStorage.CAM.DebrisModule);
require(Modules.Effects.BoatTween);
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterDescendantsInstances = { workspace.Map };
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Include;
local _ = game.Players.LocalPlayer;
local _ = workspace.CurrentCamera;

local function SpawnSwordAura(p1) -- Line: 39
    -- upvalues: workspace_Debree (copy), vfxUtility (copy), DebrisModule (copy)
    local Sword_At_A = p1:FindFirstChild("Sword_At_A", true);

    if Sword_At_A ~= nil then
        local Parent = Sword_At_A.Parent;
        local v2 = script.Parent.SwordAura:Clone();
        v2.CFrame = Parent.CFrame;
        v2.Parent = workspace_Debree;
        vfxUtility.EnableAll(v2, true);
        vfxUtility.WeldConstraint(v2, Parent);
        DebrisModule:AddItem(v2, 10);

        return v2;
    end;
end;

local u3 = {
    FadeInTime = 0,
    Frequency = 0.055,
    Amplitude = 0.5,
    SustainTime = 0.14,
    FadeOutTime = 0.5,
    RotationInfluence = Vector3.new(0.25, 0.25, 0.25),
    PositionInfluence = Vector3.new(3.5, 3.5, 3.5)
};

return function(p4: userdata, p5: any, p6: any) -- Line: 63
    -- upvalues: vfxUtility (copy), Sounds (copy), workspace_Debree (copy), DebrisModule (copy), SpawnSwordAura (copy), Assets (copy), TweenService (copy), Cam_Shaker (copy), u3 (copy), CraterHandler (copy)
    local HumanoidRootPart = p4:FindFirstChild("HumanoidRootPart");
    local RightHand = p4:FindFirstChild("RightHand");

    if not HumanoidRootPart then
        return;
    end;

    local string_format_ret = string.format("%s_%s_Effects", p4.Name, script.Name);

    if p5 ~= "Cancel" and (HumanoidRootPart.Position - workspace.CurrentCamera.CFrame.Position).Magnitude > 250 then
        return;
    end;

    local v7 = game.Workspace.Debree:FindFirstChild(string_format_ret);

    if p5 == "Hold" then
        if v7 ~= nil then
            v7:Destroy();
        end;

        vfxUtility.PlaySound(Sounds, "PS2insectTFstart", HumanoidRootPart, true);
        local Folder = Instance.new("Folder");
        Folder.Name = string_format_ret;
        Folder.Parent = workspace_Debree;
        Folder:SetAttribute("Active", true);
        DebrisModule:AddItem(Folder, 5);
        SpawnSwordAura(p4).Parent = Folder;
        local v8 = workspace:Raycast(HumanoidRootPart.Position, Vector3.new(0, -20, 0), vfxUtility.RayParams.Map);
        local v9;

        if v8 then
            v9 = v8.Instance;
        else
            v9 = nil;
        end;

        local v10 = Assets.StartupEmit:Clone();
        v10:PivotTo(HumanoidRootPart.CFrame * CFrame.new(0, 0.5, 0));
        v10.Parent = workspace_Debree;
        vfxUtility.EmitAll(v10);
        vfxUtility.ChangeDustColor(v9, v10.Startup.raycastdust);
        vfxUtility.TweenLight(v10, {
            Time = 0.25,
            Del = 0.4
        });
        DebrisModule:AddItem(v10, 2);
        local v11 = Assets.FakeRightHand:Clone();
        v11.CFrame = RightHand.CFrame;
        v11.Parent = workspace_Debree;
        vfxUtility.EmitAll(v11);
        vfxUtility.WeldConstraint(v11, RightHand);
        DebrisModule:AddItem(v11, 2);
    elseif v7 == nil and p5 ~= "Explosion" then
        return;
    end;

    if p5 == "Dash" then
        local v12, v13 = unpack(p6);

        if v7 then
            v7:SetAttribute("Active", false);
            v7.Name = "_";
        end;

        vfxUtility.PlaySound(Sounds, "PS2insectTFthrust", HumanoidRootPart, true);
        local v14 = Assets.Wind_Beams:Clone();
        v14:PivotTo(CFrame.new(v12.Position, v13.Position));
        v14.Parent = v7;
        DebrisModule:AddItem(v14, 1);
        v14.EndRootPart:PivotTo(v14.StartRootPart.StartRootStuff.CFrame);
        TweenService:Create(v14.EndRootPart.EndRootStuff, TweenInfo.new(0.13, Enum.EasingStyle.Quint), {
            CFrame = v13
        }):Play();
        vfxUtility.TweenBeams(v14, {
            Time = 0.12
        });
        vfxUtility.TweenBeamTransparency(v14, 1, 1);

        for _, descendant in v14:GetDescendants() do
            if descendant.ClassName == "Beam" then
                TweenService:Create(descendant, TweenInfo.new(1.1), {
                    TextureSpeed = 0
                }):Play();
            end;
        end;

        local v15 = workspace:Raycast(CFrame.new(v12.Position, v13.Position).Position, Vector3.new(0, -20, 0), vfxUtility.RayParams.Map);
        local v16;

        if v15 then
            v16 = v15.Instance;
        else
            v16 = nil;
        end;

        local v17 = Assets.DashStart:Clone();
        v17:PivotTo(CFrame.new(v12.Position, v13.Position));
        v17.Parent = v7;
        vfxUtility.EmitAll(v17);
        vfxUtility.ChangeDustColor(v16, { v17.GroundVFX.raycastdust, v17.GroundVFX.raycastdust2 });
        DebrisModule:AddItem(v17, 3);
        vfxUtility.TweenLight(v17, {
            Time = 0.2,
            Del = 0.3,
            DelayTimer = 0.15
        });
        vfxUtility.TweenBeams(v17, {
            Time = 0.05
        });
        local u18 = Assets.Thrust:Clone();
        u18:PivotTo(CFrame.new(v12.Position, v13.Position));
        u18.Parent = v7;
        vfxUtility.EmitAll(u18);
        Cam_Shaker(HumanoidRootPart.Position, u3);
        local Meshes = u18.Meshes;
        local GlowMesh = Meshes.GlowMesh;
        local Ring = Meshes.Ring;
        local Twirl = Meshes.Twirl;
        local SkinnyMesh = Meshes.SkinnyMesh;
        GlowMesh.Main.Decal.Transparency = 0;
        TweenService:Create(GlowMesh.Main, TweenInfo.new(0.75, Enum.EasingStyle.Quint), {
            CFrame = GlowMesh.End_Values.CFrame
        }):Play();
        TweenService:Create(GlowMesh.Main.Mesh, TweenInfo.new(0.75, Enum.EasingStyle.Quint), {
            Scale = GlowMesh.Main.Mesh.Scale
        }):Play();
        Ring.SerializedMeshAnim.Transparency = 0.75;
        TweenService:Create(Ring.SerializedMeshAnim, TweenInfo.new(0.355, Enum.EasingStyle.Quad), {
            Size = Ring.SerializedMeshAnim:GetAttribute("EndPartSize"),
            CFrame = Ring.SerializedMeshAnim.CFrame * Ring.SerializedMeshAnim:GetAttribute("CFrameDiff")
        }):Play();
        SkinnyMesh.SerializedMeshAnim.Transparency = 0;
        TweenService:Create(SkinnyMesh.SerializedMeshAnim, TweenInfo.new(0.155, Enum.EasingStyle.Quad), {
            Size = SkinnyMesh.SerializedMeshAnim:GetAttribute("EndPartSize"),
            CFrame = SkinnyMesh.SerializedMeshAnim.CFrame * SkinnyMesh.SerializedMeshAnim:GetAttribute("CFrameDiff")
        }):Play();
        Twirl.SerializedMeshAnim.Transparency = 0.45;
        TweenService:Create(Twirl.SerializedMeshAnim, TweenInfo.new(0.955, Enum.EasingStyle.Quad), {
            Size = Twirl.SerializedMeshAnim:GetAttribute("EndPartSize"),
            Position = Twirl.SerializedMeshAnim.Position + Twirl.SerializedMeshAnim:GetAttribute("CFrameDiff").Position
        }):Play();
        task.delay(0.1, function() -- Line: 187
            -- upvalues: TweenService (ref), GlowMesh (copy), Ring (copy), SkinnyMesh (copy), Twirl (copy), DebrisModule (ref), u18 (copy)
            TweenService:Create(GlowMesh.Main.Decal, TweenInfo.new(0.155, Enum.EasingStyle.Sine), {
                Transparency = 1
            }):Play();
            TweenService:Create(Ring.SerializedMeshAnim, TweenInfo.new(0.125, Enum.EasingStyle.Quad), {
                Transparency = 1
            }):Play();
            TweenService:Create(SkinnyMesh.SerializedMeshAnim, TweenInfo.new(0.125, Enum.EasingStyle.Quad), {
                Transparency = 1
            }):Play();
            TweenService:Create(Twirl.SerializedMeshAnim, TweenInfo.new(0.855, Enum.EasingStyle.Quad), {
                Transparency = 1
            }):Play();
            DebrisModule:AddItem(u18, 1);
        end);
        local v19 = (v12.Position - v13.Position).Magnitude + 5;
        local v20 = 12 * (v19 / 30);
        local math_clamp_ret = math.clamp(v19, 0, v19);
        CraterHandler.new("Path", CFrame.lookAt(v12.Position, v13.Position), {
            HoldTime = 0.7,
            BlockSize = { 2, 2 },
            Distance = math_clamp_ret,
            Width = { 5, 5 },
            StepSize = math_clamp_ret * (1 / v20),
            IterateSpeed = {
                Entrance = "Stepped",
                EntranceDivision = "Iterate",
                EntranceSpeed = 0.1 / v20
            },
            FlourishTypes = {
                Exit = "Melt",
                ExitDivision = "Iterate",
                ExitSpeed = 1
            }
        });
        vfxUtility.TweenBeams(v17, {
            Time = 0.4,
            Off = true
        });
        task.wait(0.1);
        local v21 = workspace:Raycast(v13.Position, Vector3.new(0, -20, 0), vfxUtility.RayParams.Map);
        local v22;

        if v21 then
            v22 = v21.Instance;
        else
            v22 = nil;
        end;

        local v23 = Assets.DashEnd:Clone();
        v23:PivotTo(v13);
        v23.Parent = v7;
        vfxUtility.EmitAll(v23);
        DebrisModule:AddItem(v23, 3);
        vfxUtility.TweenLight(v23, {
            Time = 0.05,
            Del = 0.1,
            DelayTimer = 0.15
        });
        vfxUtility.ChangeDustColor(v22, { v23.GroundVFX.raycastdust, v23.GroundVFX.raycastdust2, v23.GroundVFX.raycastdust3 });

        if v7 then
            vfxUtility.EnableAll(v7, false);
            DebrisModule:AddItem(v7, 2);
        end;
    else
        if p5 == "Explosion" then
            local v24 = unpack(p6);
            workspace:Raycast(v24.Position, Vector3.new(0, -20, 0), vfxUtility.RayParams.Map);
            local v25 = Assets.PoisonExplosion:Clone();
            v25:PivotTo(v24);
            v25.Parent = workspace.Debree;
            vfxUtility.PlaySound(Sounds, "PS2insectTFpop", v25.PrimaryPart, true);
            vfxUtility.EmitAll(v25);
            DebrisModule:AddItem(v25, 3);
            vfxUtility.TweenLight(v25, {
                Time = 0.2,
                Del = 0.3
            });

            return;
        end;

        if p5 == "Uppercut" then
            if v7 then
                v7.Name = "_";
                vfxUtility.EnableAll(v7, false);
                DebrisModule:AddItem(v7, 2);
            end;

            local v26 = workspace:Raycast(HumanoidRootPart.Position, Vector3.new(0, -20, 0), vfxUtility.RayParams.Map);
            local v27;

            if v26 then
                v27 = v26.Instance;
            else
                v27 = nil;
            end;

            vfxUtility.PlaySound(Sounds, "PS2insectTFuppercut", HumanoidRootPart, true);
            local v28 = Assets.Uppercut:Clone();
            v28:PivotTo(HumanoidRootPart.CFrame);
            v28.Parent = v7;
            vfxUtility.EmitAll(v28);
            vfxUtility.TweenLight(v28, {
                Time = 0.2,
                Del = 0.3
            });
            DebrisModule:AddItem(v28, 2);
            vfxUtility.ChangeDustColor(v27, { v28.Jump.raycastdust, v28.Jump.raycastdust2 });
            Cam_Shaker(HumanoidRootPart.Position, u3);
            local Meshes = v28.Thrust.Meshes;
            local GlowMesh = Meshes.GlowMesh;
            local Ring = Meshes.Ring;
            local Twirl = Meshes.Twirl;
            local SkinnyMesh = Meshes.SkinnyMesh;
            GlowMesh.Main.Decal.Transparency = 0;
            SkinnyMesh.SerializedMeshAnim.Transparency = 0;
            Twirl.SerializedMeshAnim.Transparency = 0.45;
            Ring.SerializedMeshAnim.Transparency = 0.75;
            TweenService:Create(GlowMesh.Main, TweenInfo.new(0.75, Enum.EasingStyle.Quint), {
                CFrame = GlowMesh.End_Values.CFrame
            }):Play();
            TweenService:Create(GlowMesh.Main.Mesh, TweenInfo.new(0.75, Enum.EasingStyle.Quint), {
                Scale = GlowMesh.End_Values.Mesh.Scale
            }):Play();
            TweenService:Create(Ring.SerializedMeshAnim, TweenInfo.new(0.255, Enum.EasingStyle.Quad), {
                Size = Ring.SerializedMeshAnim:GetAttribute("EndPartSize"),
                CFrame = Ring.SerializedMeshAnim.CFrame * Ring.SerializedMeshAnim:GetAttribute("CFrameDiff")
            }):Play();
            TweenService:Create(SkinnyMesh.SerializedMeshAnim, TweenInfo.new(0.155, Enum.EasingStyle.Quad), {
                Size = SkinnyMesh.SerializedMeshAnim:GetAttribute("EndPartSize"),
                CFrame = SkinnyMesh.SerializedMeshAnim.CFrame * SkinnyMesh.SerializedMeshAnim:GetAttribute("CFrameDiff")
            }):Play();
            TweenService:Create(Twirl.SerializedMeshAnim, TweenInfo.new(0.855, Enum.EasingStyle.Quad), {
                Size = Twirl.SerializedMeshAnim:GetAttribute("EndPartSize"),
                Position = Twirl.SerializedMeshAnim.Position + Twirl.SerializedMeshAnim:GetAttribute("CFrameDiff").Position
            }):Play();
            TweenService:Create(Twirl.SerializedMeshAnim, TweenInfo.new(1.85, Enum.EasingStyle.Quint), {
                CFrame = Ring.SerializedMeshAnim.CFrame * Ring.SerializedMeshAnim:GetAttribute("CFrameDiff").Rotation * CFrame.Angles(0, 2.827433388230814, 0)
            }):Play();
            task.delay(0.1, function() -- Line: 308
                -- upvalues: TweenService (ref), GlowMesh (copy), Ring (copy), Twirl (copy)
                TweenService:Create(GlowMesh.Main.Decal, TweenInfo.new(0.255, Enum.EasingStyle.Sine), {
                    Transparency = 1
                }):Play();
                TweenService:Create(Ring.SerializedMeshAnim, TweenInfo.new(0.125, Enum.EasingStyle.Quad), {
                    Transparency = 1
                }):Play();
                TweenService:Create(Twirl.SerializedMeshAnim, TweenInfo.new(0.655, Enum.EasingStyle.Quad), {
                    Transparency = 1
                }):Play();
            end);

            return;
        end;

        if p5 == "Cancel" and v7 then
            v7.Name = "_";
            DebrisModule:AddItem(v7, 2);
            v7:SetAttribute("Active", nil);
            vfxUtility.EnableAll(v7, false);
            vfxUtility.TweenLight(v7, {
                Time = 0.01,
                Off = true
            });
        end;
    end;
end;