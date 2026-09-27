-- Decompiled with Potassium's decompiler.

game:GetService("Players");
local TweenService = game:GetService("TweenService");
game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ReplicatedStorage2 = game:GetService("ReplicatedStorage");
local CAM = ReplicatedStorage.CAM;
local Modules = CAM.Client.Modules;
local workspace_Debree = workspace.Debree;
local Assets = script:FindFirstChild("Assets");
local Sounds = script:FindFirstChild("Sounds");
local DebrisModule = require(CAM.DebrisModule);
local Cam_Shaker = require(Modules.Effects.Cam_Shaker);
local CraterHandler = require(Modules.Effects.Craters.CraterHandler);
require(Modules.Effects.BoatTween);
local vfxUtility = require(game.ReplicatedStorage.CAM.Client.Modules.Effects.vfxUtility);
local _ = game.Players.LocalPlayer;
local workspace_CurrentCamera = workspace.CurrentCamera;

local function SwordTrail(p1: userdata, p2: boolean) -- Line: 40
    -- upvalues: vfxUtility (copy)
    local Has_Blade = p1:FindFirstChild("Has_Blade", true);
    local v3;

    if Has_Blade == nil or Has_Blade.Parent == nil then
        v3 = nil;
    else
        v3 = Has_Blade.Parent:FindFirstChild("Blade");
    end;

    if v3 == nil then
        return;
    end;

    if p2 == true or p2 == nil then
        local u4 = {};

        for _, child in pairs(script.Parent.SwordTrail:GetChildren()) do
            local v5 = child:Clone();
            v5.Name = "bladetfftians##asd";
            v5.Parent = v3;
            table.insert(u4, v5);

            if v5:IsA("Trail") then
                v5.Attachment0 = v3:FindFirstChild("Sword_At_A");
                v5.Attachment1 = v3:FindFirstChild("Sword_At_B");
            end;
        end;

        if u4 ~= nil and u4[1] ~= nil then
            task.delay(5, function() -- Line: 60
                -- upvalues: u4 (copy)
                if u4[1].Name ~= "--" then
                    for _, v in ipairs(u4) do
                        v:Destroy();
                    end;
                end;
            end);
        end;
    else
        local u6 = {};

        for _, child in pairs(v3:GetChildren()) do
            if child.Name == "bladetfftians##asd" then
                child.Name = "--";
                table.insert(u6, child);
            end;
        end;

        if #u6 > 0 then
            task.delay(0.35, function() -- Line: 77
                -- upvalues: u6 (copy)
                if u6 ~= nil then
                    for _, v in pairs(u6) do
                        v.Enabled = false;
                    end;
                end;

                task.wait(1);

                for _, v in ipairs(u6) do
                    v:Destroy();
                end;
            end);
        end;
    end;

    vfxUtility.EnableAll(v3, p2 or p2 == nil);
end;

local OuwCraters = require(ReplicatedStorage2.CAM.Client.Modules.Effects.Craters.OuwCraters);

return function(u7: userdata, p8: any, p9: any) -- Line: 94
    -- upvalues: workspace_CurrentCamera (copy), workspace_Debree (copy), DebrisModule (copy), Assets (copy), vfxUtility (copy), TweenService (copy), SwordTrail (copy), Sounds (copy), Cam_Shaker (copy), OuwCraters (copy), CraterHandler (copy)
    local v10 = u7:FindFirstChild("HumanoidRootPart") or u7.PrimaryPart;
    local UpperTorso = u7:FindFirstChild("UpperTorso");

    if v10 == nil or UpperTorso == nil then
        return;
    end;

    if p8 ~= "Cancel" and (v10.Position - workspace_CurrentCamera.CFrame.Position).Magnitude > 250 then
        return;
    end;

    local string_format_ret = string.format("%s Constant_Flux_Effects", u7.Name);
    local v11 = workspace_Debree:FindFirstChild(string_format_ret);

    if p8 == "Activate" then
        if v11 then
            v11:SetAttribute("Active", false);
            v11.Name = "_";
            DebrisModule:AddItem(v11, 2);
        end;

        local Folder = Instance.new("Folder");
        Folder.Name = string_format_ret;
        Folder.Parent = workspace_Debree;
        DebrisModule:AddItem(Folder, 8);
        Folder:SetAttribute("Active", true);
        local v12 = Assets.Dragon:Clone();
        v12["Plane.003"].CFrame = v10.CFrame * CFrame.new(0.05541229248046875, -2.5835342407226562, 8.55291748046875) * CFrame.fromEulerAnglesYXZ(-1.2545099202889484e-14, 3.141592502593994, -1.6292068494294654e-7);
        v12.Parent = Folder;
        vfxUtility.WeldConstraint(v12["Plane.003"], v10);
        TweenService:Create(v12.PrimaryPart, TweenInfo.new(2), {
            Transparency = 0
        }):Play();
        v12.AnimationController:LoadAnimation(Assets.Dragon_Animation):Play();
        local v13 = script.Sounds.PS2WBblitzDASH:Clone();
        v13.Parent = v12.PrimaryPart;
        v13:Play();
        SwordTrail(u7);
        task.wait(1);

        if Folder ~= nil and Folder.Name ~= "_" then
            vfxUtility.EnableAll(v12, true);
            vfxUtility.TweenBeams(v12, {
                Time = 0.2
            });
            vfxUtility.TweenLight(v12, {
                Time = 0.2
            });
        end;
    else
        if p8 == "Slash" then
            if v11 == nil then
                return;
            end;

            local v14 = Assets.Slash:Clone();
            v14:PivotTo(v10.CFrame);
            v14.Parent = v11;
            vfxUtility.EmitAll(v14);
            DebrisModule:AddItem(v14, 2);
            vfxUtility.PlaySound(Sounds, "PS2WBconstantfluxSLASHtrue" .. p9, v14.PrimaryPart, true);
            local RotatingSlashesEnd = v14.SlashBeams.RotatingSlashesEnd;
            TweenService:Create(v14.SlashBeams.RotatingSlashes, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {
                CFrame = RotatingSlashesEnd.CFrame
            }):Play();

            for _, descendant in pairs(v14:GetDescendants()) do
                if descendant:IsA("Beam") then
                    descendant.Enabled = true;
                    TweenService:Create(descendant, TweenInfo.new(0.4, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
                        TextureLength = 0.1,
                        Width0 = 0,
                        Width1 = 0
                    }):Play();
                end;
            end;

            local PointLight = v14.Swing.PointLightAttachment.PointLight;
            local SerializedMeshAnim = v14.SwirlEffect.SerializedMeshAnim;
            local SerializedMeshAnim2 = v14.WindMesh.SerializedMeshAnim;
            TweenService:Create(SerializedMeshAnim, TweenInfo.new(1, Enum.EasingStyle.Quad), {
                Size = SerializedMeshAnim:GetAttribute("EndPartSize"),
                Position = SerializedMeshAnim.Position + SerializedMeshAnim:GetAttribute("CFrameDiff").Position
            }):Play();
            TweenService:Create(SerializedMeshAnim, TweenInfo.new(1.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Orientation = SerializedMeshAnim.Orientation + Vector3.new(0, -550, 0)
            }):Play();
            TweenService:Create(SerializedMeshAnim2, TweenInfo.new(1.3, Enum.EasingStyle.Sine), {
                Size = SerializedMeshAnim2:GetAttribute("EndPartSize"),
                Position = SerializedMeshAnim2.Position + SerializedMeshAnim2:GetAttribute("CFrameDiff").Position
            }):Play();
            TweenService:Create(SerializedMeshAnim2, TweenInfo.new(1.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Orientation = SerializedMeshAnim2.Orientation + Vector3.new(0, -550, 0)
            }):Play();
            TweenService:Create(PointLight, TweenInfo.new(1, Enum.EasingStyle.Linear), {
                Range = 25,
                Brightness = 0
            }):Play();
            task.delay(0.1, function() -- Line: 198
                -- upvalues: TweenService (ref), SerializedMeshAnim (copy), SerializedMeshAnim2 (copy)
                TweenService:Create(SerializedMeshAnim, TweenInfo.new(0.755, Enum.EasingStyle.Quint), {
                    Transparency = 1
                }):Play();
                TweenService:Create(SerializedMeshAnim2, TweenInfo.new(1.255, Enum.EasingStyle.Quint), {
                    Transparency = 1
                }):Play();
            end);
            Cam_Shaker(v10.Position, "Medium_tiny_shake_preset");

            return;
        end;

        if p8 == "Impact" then
            if v11 then
                v11.Name = "_";
                DebrisModule:AddItem(v11, 3);
                v11:SetAttribute("Active", false);
                local Dragon = v11:FindFirstChild("Dragon");

                if Dragon then
                    DebrisModule:AddItem(Dragon, 2);
                    vfxUtility.EnableAll(Dragon, false);
                    vfxUtility.TweenBeams(Dragon, {
                        Time = 0.02,
                        Off = true
                    });
                    vfxUtility.TweenLight(Dragon, {
                        Time = 0.2,
                        Off = true
                    });
                    TweenService:Create(Dragon.PrimaryPart, TweenInfo.new(0.5), {
                        Transparency = 1
                    }):Play();
                end;

                SwordTrail(u7, false);
            end;

            local v15 = Assets.Impact:Clone();
            v15:PivotTo(v10.CFrame * CFrame.new(0, -3.5, -6.5) * CFrame.Angles(0, 3.141592653589793, 0));
            v15.Parent = v11;
            vfxUtility.EmitAll(v15);
            Cam_Shaker(v15.Smash.Position, "medium_shake_preset");
            DebrisModule:AddItem(v15, 3);
            vfxUtility.PlaySound(Sounds, "PS2WBconstantfluxSLASHtrue3IMPACT", v15.PrimaryPart, true);
            local SerializedMeshAnim = v15.SwirlEffect.SerializedMeshAnim;
            TweenService:Create(SerializedMeshAnim, TweenInfo.new(2, Enum.EasingStyle.Quad), {
                Size = SerializedMeshAnim:GetAttribute("EndPartSize"),
                Position = SerializedMeshAnim.Position + SerializedMeshAnim:GetAttribute("CFrameDiff").Position
            }):Play();
            TweenService:Create(SerializedMeshAnim, TweenInfo.new(2.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Orientation = SerializedMeshAnim.Orientation + Vector3.new(0, -300, 0)
            }):Play();
            local SerializedMeshAnim2 = v15.WindMesh.SerializedMeshAnim;
            TweenService:Create(SerializedMeshAnim2, TweenInfo.new(1.3, Enum.EasingStyle.Sine), {
                Size = SerializedMeshAnim2:GetAttribute("EndPartSize"),
                Position = SerializedMeshAnim2.Position + SerializedMeshAnim2:GetAttribute("CFrameDiff").Position
            }):Play();
            TweenService:Create(SerializedMeshAnim2, TweenInfo.new(1.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Orientation = SerializedMeshAnim2.Orientation + Vector3.new(0, -550, 0)
            }):Play();
            local SerializedMeshAnim3 = v15.BlueMesh.SerializedMeshAnim;
            TweenService:Create(SerializedMeshAnim3, TweenInfo.new(1.355, Enum.EasingStyle.Quad), {
                Position = SerializedMeshAnim3.Position + SerializedMeshAnim3:GetAttribute("CFrameDiff").Position
            }):Play();
            TweenService:Create(SerializedMeshAnim3.Mesh, TweenInfo.new(1.5, Enum.EasingStyle.Quad), {
                Scale = SerializedMeshAnim3:GetAttribute("EndMeshScale")
            }):Play();
            TweenService:Create(SerializedMeshAnim3, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Orientation = SerializedMeshAnim3.Orientation + Vector3.new(0, -100, 0)
            }):Play();
            local SerializedMeshAnim4 = v15.NewWindMesh.SerializedMeshAnim;
            TweenService:Create(SerializedMeshAnim4, TweenInfo.new(1.2, Enum.EasingStyle.Quad), {
                Position = SerializedMeshAnim4.Position + SerializedMeshAnim4:GetAttribute("CFrameDiff").Position
            }):Play();
            TweenService:Create(SerializedMeshAnim4.Mesh, TweenInfo.new(1.3, Enum.EasingStyle.Linear), {
                Scale = SerializedMeshAnim4:GetAttribute("EndMeshScale")
            }):Play();
            TweenService:Create(SerializedMeshAnim4, TweenInfo.new(1.4, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
                Orientation = SerializedMeshAnim4.Orientation + Vector3.new(0, -50, 0)
            }):Play();
            local SerializedMeshAnim5 = v15.WindyMeshy.SerializedMeshAnim;
            TweenService:Create(SerializedMeshAnim5, TweenInfo.new(1.5, Enum.EasingStyle.Quad), {
                Position = SerializedMeshAnim5.Position + SerializedMeshAnim5:GetAttribute("CFrameDiff").Position
            }):Play();
            TweenService:Create(SerializedMeshAnim5.Mesh, TweenInfo.new(1.5, Enum.EasingStyle.Quad), {
                Scale = SerializedMeshAnim5:GetAttribute("EndMeshScale")
            }):Play();
            TweenService:Create(SerializedMeshAnim5, TweenInfo.new(2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Orientation = SerializedMeshAnim5.Orientation + Vector3.new(0, -75, 0)
            }):Play();
            local PointLight = v15.Root.Attachment.PointLight;
            PointLight.Brightness = 8;
            PointLight.Range = 25;
            task.delay(0.1, function() -- Line: 324
                -- upvalues: TweenService (ref), SerializedMeshAnim (copy), SerializedMeshAnim2 (copy), SerializedMeshAnim3 (copy), SerializedMeshAnim4 (copy), SerializedMeshAnim5 (copy), PointLight (copy), SwordTrail (ref), u7 (copy)
                TweenService:Create(SerializedMeshAnim, TweenInfo.new(2, Enum.EasingStyle.Quint), {
                    Transparency = 1
                }):Play();
                TweenService:Create(SerializedMeshAnim2, TweenInfo.new(1.255, Enum.EasingStyle.Quint), {
                    Transparency = 1
                }):Play();
                TweenService:Create(SerializedMeshAnim3.Decal, TweenInfo.new(1.5, Enum.EasingStyle.Quint), {
                    Transparency = 1
                }):Play();
                TweenService:Create(SerializedMeshAnim4.Decal, TweenInfo.new(1, Enum.EasingStyle.Sine), {
                    Transparency = 1
                }):Play();
                TweenService:Create(SerializedMeshAnim5.Decal, TweenInfo.new(1.5, Enum.EasingStyle.Quint), {
                    Transparency = 1
                }):Play();
                TweenService:Create(PointLight, TweenInfo.new(0.455, Enum.EasingStyle.Linear), {
                    Range = 4,
                    Brightness = 0
                }):Play();
                SwordTrail(u7, false);
            end);
            local v16 = CFrame.new(v15.Smash.Position) * CFrame.new(0, 5, 0);
            OuwCraters.Scales({
                Center = v16
            });
            CraterHandler.new("Break", v16, {
                PartCount = 15,
                Range = 30,
                Radius = 15,
                HoldTime = 1.5,
                BlockSize = { 0.5, 1.5 },
                Height = { 30, 90 }
            });

            return;
        end;

        if p8 == "Cancel" then
            if v11 then
                v11.Name = "_";
                DebrisModule:AddItem(v11, 3);
                v11:SetAttribute("Active", false);
            end;

            if not v11 then
                return;
            end;

            local Dragon = v11:FindFirstChild("Dragon");

            if Dragon then
                DebrisModule:AddItem(Dragon, 2);
                vfxUtility.EnableAll(Dragon, false);
                vfxUtility.TweenBeams(Dragon, {
                    Time = 0.02,
                    Off = true
                });
                vfxUtility.TweenLight(Dragon, {
                    Time = 0.2,
                    Off = true
                });
                TweenService:Create(Dragon.PrimaryPart, TweenInfo.new(0.5), {
                    Transparency = 1
                }):Play();
            end;

            SwordTrail(u7, false);
        end;
    end;
end;