-- Decompiled with Potassium's decompiler.

local Debris = game:GetService("Debris");
game:GetService("Players");
local TweenService = game:GetService("TweenService");
game:GetService("RunService");
game:GetService("ReplicatedStorage");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Modules = ReplicatedStorage.CAM.Client.Modules;
local Cam_Shaker = require(Modules.Effects.Cam_Shaker);
local RaycastHelper = require(ReplicatedStorage.CAM.Global.RaycastHelper);
local CraterEffects = require(Modules.Effects.Craters.CraterEffects);
local workspace_Debree = workspace.Debree;
local Sounds = script:FindFirstChild("Sounds");
local vfxUtility = require(game.ReplicatedStorage.CAM.Client.Modules.Effects.vfxUtility);
local DebrisModule = require(game.ReplicatedStorage.CAM.DebrisModule);
local Ouwmit = require(game.ReplicatedStorage.CAM.Client.Modules.Effects.Ouwmit);
local TweenInfo_new_ret = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0);
local TweenInfo_new_ret2 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0);

local function LTN() -- Line: 31
    -- upvalues: TweenService (copy), TweenInfo_new_ret (copy), TweenInfo_new_ret2 (copy), DebrisModule (copy)
    local v1 = script.NewAssets.ColorCorrection:Clone();
    v1.Parent = workspace.Camera;
    TweenService:Create(v1, TweenInfo_new_ret, {
        TintColor = Color3.fromRGB(255, 255, 255)
    }):Play();
    TweenService:Create(v1, TweenInfo_new_ret2, {
        Brightness = 0,
        Contrast = 0,
        Saturation = 0
    }):Play();
    DebrisModule:AddItem(v1, 0.2);
end;

return function(p2: userdata, p3: any, p4: any) -- Line: 38
    -- upvalues: workspace_Debree (copy), DebrisModule (copy), vfxUtility (copy), Debris (copy), Sounds (copy), RaycastHelper (copy), Cam_Shaker (copy), Ouwmit (copy), CraterEffects (copy), TweenService (copy), LTN (copy)
    local HumanoidRootPart = p2:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local string_format_ret = string.format("%s_%s_Effects", p2.Name, script.Name);

    if p3 ~= "Cancel" and (HumanoidRootPart.Position - workspace.CurrentCamera.CFrame.Position).Magnitude > 250 then
        if p3 ~= "DashOrCancel" then
            return;
        end;

        p3 = "Cancel";
    end;

    local v5 = p3 == "DashOrCancel" and "Dash" or p3;

    if v5 == "Startup" then
        if workspace_Debree:FindFirstChild(string_format_ret) then
            local v6 = workspace_Debree:FindFirstChild(string_format_ret);
            v6.Name = "_";
            v6:SetAttribute("Active", false);
            DebrisModule:AddItem(v6, 3);
            vfxUtility.EnableAll(v6, false);
            vfxUtility.TweenLight(v6, {
                Time = 0.1,
                Off = true
            });
        end;

        local Folder = Instance.new("Folder");
        Folder.Name = string_format_ret;
        Folder.Parent = workspace_Debree;
        Debris:AddItem(Folder, 8);
        Folder:SetAttribute("Active", true);
        local u7 = vfxUtility.PlaySound(Sounds, "PS2thunderbreathTCaFholdloop", HumanoidRootPart);
        local v8 = script.NewAssets.ThunderDashStartUp:Clone();
        v8:PivotTo(HumanoidRootPart.CFrame);
        v8.Parent = Folder;
        DebrisModule:AddItem(v8, 2);
        vfxUtility.PlaySound(Sounds, "PS2thunderbreathTCaFstart", HumanoidRootPart, true);
        local v9 = workspace:Raycast(HumanoidRootPart.Position, Vector3.new(0, -50, 0), RaycastHelper.Crater);
        Cam_Shaker(HumanoidRootPart.Position, "activate_shake");
        local v10;

        if v9 then
            local v11 = CFrame.new(v9.Position, v9.Position + v9.Normal) * CFrame.Angles(-1.5707963267948966, 0, 0);
            v10 = v9.Instance.Color;
            v8.Startup.raycastdust.WorldCFrame = v11;
            v8.Startup.GroundCracks.WorldCFrame = v11;
            v8.GroundFX.CFrame = v11;
        else
            v10 = nil;
        end;

        Ouwmit.Emit(v8, v10 ~= nil and ({
            Color = v10,
            ColorWhitelist = { "raycastdust", "Dust", "Rocks" }
        } or nil) or nil);
        CraterEffects.new("RisingRocks", p2, {
            Iterations = "Held",
            BlockSize = { 0.5, 3 },
            Radius = 10,
            Height = { 8, 60 },
            AnimationSpeed = 4,
            IterationName = "CSI_" .. p2.Name,
            Range = 30,
            PartCount = 1,
            delayTime = 0.025
        });
        task.spawn(function() -- Line: 113
            -- upvalues: Folder (copy), u7 (copy), HumanoidRootPart (copy)
            while Folder ~= nil and (Folder.Parent ~= nil and Folder:GetAttribute("Active")) do
                task.wait(0.05);
            end;

            if u7.Parent == HumanoidRootPart then
                u7:Destroy();
            end;
        end);
        local v12 = script.NewAssets.ZenitsuthunderclapHighlight:Clone();
        v12.Parent = Folder;
        v12.Adornee = p2;
        v12.Name = "Zenitsu_Highlight";
        TweenService:Create(v12, TweenInfo.new(0.25), {
            OutlineTransparency = 0
        }):Play();
        local v13 = script.NewAssets.HoldCharge:Clone();
        v13:PivotTo(HumanoidRootPart.CFrame * CFrame.new(0, -2.2, 0));
        v13.Parent = Folder;
        Ouwmit.Enable(v13);

        return;
    end;

    if v5 == "Dash" then
        local table_unpack_ret, u14 = table.unpack(p4);
        local u15 = CFrame.new(table_unpack_ret.Position) * u14.Rotation;
        local u16 = workspace_Debree:FindFirstChild(string_format_ret);

        if u16 == nil then
            u16 = Instance.new("Folder");
            u16.Name = string_format_ret;
            u16.Parent = workspace_Debree;
            Debris:AddItem(u16, 4);
        else
            u16.Name = "_";
            DebrisModule:AddItem(u16, 4);

            if u16:GetAttribute("Active") then
                u16:SetAttribute("Active", false);
            end;

            local HoldCharge = u16:FindFirstChild("HoldCharge");

            if HoldCharge then
                DebrisModule:AddItem(HoldCharge, 2);
                Ouwmit.Enable(HoldCharge, false);
            end;
        end;

        local v17 = script.NewAssets.Startup:Clone();
        v17.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, -2.5, 0);
        v17.Parent = u16;
        TweenService:Create(v17.PointLight, TweenInfo.new(0.2), {
            Brightness = 0,
            Range = 0
        }):Play();
        CraterEffects.endConnection(p2, "CSI_" .. p2.Name);
        local Zenitsu_Highlight = u16:FindFirstChild("Zenitsu_Highlight");

        if Zenitsu_Highlight ~= nil then
            TweenService:Create(Zenitsu_Highlight, TweenInfo.new(0.15), {
                FillTransparency = 1.5
            }):Play();
            task.delay(0.35, function() -- Line: 168
                -- upvalues: Zenitsu_Highlight (copy), TweenService (ref), DebrisModule (ref)
                if Zenitsu_Highlight then
                    TweenService:Create(Zenitsu_Highlight, TweenInfo.new(0.15), {
                        OutlineTransparency = 1
                    }):Play();
                    DebrisModule:AddItem(Zenitsu_Highlight, 0.15);
                end;
            end);
        end;

        local v18 = workspace:Raycast(u15.Position, u15.UpVector * -50, RaycastHelper.Crater);
        Cam_Shaker(HumanoidRootPart.Position, "activate_shake");
        local v19;

        if v18 and v18.Instance then
            local v20 = CFrame.new(v18.Position, v18.Position + v18.Normal) * CFrame.Angles(-1.5707963267948966, 0, 0);
            v19 = v18.Instance.Color;
            v17.raycastdust.WorldCFrame = v20;
            v17.GroundCracks.CFrame = v20;
        else
            v19 = nil;
        end;

        Ouwmit.Emit(v17, v19 ~= nil and ({
            Color = v19,
            ColorWhitelist = { "raycastdust", "Rocks", "Dust" }
        } or nil) or nil);
        task.wait(0.1);
        Cam_Shaker(HumanoidRootPart.Position, "medium_shake_preset");
        local u21 = script.NewAssets.TpBeams:Clone();
        local CFrame_new_ret = CFrame.new(0, 3, -13);
        u21.PartBeam1.CFrame = u14 * CFrame_new_ret;
        u21.PartBeam2.CFrame = u15 * CFrame_new_ret;
        u21.Parent = u16;
        DebrisModule:AddItem(u21, 2);
        local v22 = script.NewAssets.EndEmit:Clone();
        v22:PivotTo(u14 * CFrame.new(0, 2, 3));
        v22.Parent = u16;
        task.spawn(function() -- Line: 200
            -- upvalues: u15 (copy), u14 (copy), u16 (ref), TweenService (ref)
            local v23 = script.NewAssets.DashBeams:Clone();
            v23:PivotTo(CFrame.new(u15.Position, u14.Position) * CFrame.new(0, 2, -vector.magnitude(u14.Position - u15.Position) + 25.5));
            v23.Parent = u16;
            local Dash2StartBeam = v23.Dash2StartBeam;
            local Dash2EndBeam = v23.Dash2EndBeam;
            local Beam = Dash2StartBeam.A1.Set1.Beam;
            local Lightning2 = Dash2StartBeam.A1.Set1.Lightning2;
            task.wait(0.033);
            TweenService:Create(Dash2EndBeam, TweenInfo.new(0.183, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
                CFrame = Dash2EndBeam.CFrame * CFrame.new(0, 0, -50)
            }):Play();
            TweenService:Create(Beam, TweenInfo.new(0.815), {
                TextureLength = 0
            }):Play();
            task.wait(0.35);
            TweenService:Create(Lightning2, TweenInfo.new(0.067), {
                TextureLength = 0,
                Width0 = 0,
                Width1 = 0
            }):Play();
            TweenService:Create(Dash2StartBeam, TweenInfo.new(0.467, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {
                CFrame = Dash2StartBeam.CFrame * CFrame.new(0, 0, -46.576)
            }):Play();
            task.wait(0.05);
            TweenService:Create(Beam, TweenInfo.new(0.067), {
                Width0 = 0,
                Width1 = 0
            }):Play();
        end);
        task.delay(0.2, function() -- Line: 227
            -- upvalues: TweenService (ref), u21 (copy), vfxUtility (ref)
            TweenService:Create(u21.PartBeam1.FrontSet.Left, TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
                TextureSpeed = 0
            }):Play();
            TweenService:Create(u21.PartBeam1.FrontSet.Right, TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
                TextureSpeed = 0
            }):Play();
            TweenService:Create(u21.PartBeam1.FrontSet.Left, TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
                TextureLength = 0
            }):Play();
            TweenService:Create(u21.PartBeam1.FrontSet.Right, TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
                TextureLength = 0
            }):Play();
            task.wait(0.2);
            vfxUtility.TweenBeamTransparency(u21.PartBeam2, 1, 0.2);
            vfxUtility.TweenBeamTransparency(u21.PartBeam1, 1, 0.5);
        end);
        local v24 = workspace:Raycast(u14.Position + u14.upVector * 5, u14.upVector * -50, RaycastHelper.Crater);
        local v25;

        if v24 == nil or v24.Instance == nil then
            v25 = nil;
        else
            local v26 = CFrame.new(v24.Position, v24.Position + v24.Normal) * CFrame.Angles(-1.5707963267948966, 0, 0);
            v25 = v24.Instance.Color;
            v22.Startup.CFrame = v26 * CFrame.Angles(3.141592653589793, 0, 0);
            v22.DashEnd.GroundVFX.CFrame = v26 * CFrame.new(0, 1.5, 0);
        end;

        TweenService:Create(v22.Root.PointLight, TweenInfo.new(0.2), {
            Brightness = 0,
            Range = 0
        }):Play();
        Ouwmit.Emit(v22, v25 ~= nil and ({
            Color = v25,
            ColorWhitelist = { "raycastdust", "Rocks", "Dust" }
        } or nil) or nil);

        if p2 == game.Players.LocalPlayer.Character or vector.magnitude(workspace.CurrentCamera.CFrame.Position - u14.Position) < 30 then
            LTN();
        end;

        vfxUtility.PlaySound(Sounds, "PS2thunderbreathTCaFlaunch", HumanoidRootPart, true);

        return;
    end;

    if v5 ~= "LastSlash" then
        if v5 == "DamageHit" then
            if p4 == nil then
                return;
            end;

            if p4 ~= nil then
                for _, v in ipairs(p4) do
                    local PrimaryPart = v.PrimaryPart;

                    if PrimaryPart ~= nil then
                        local v27 = script.NewAssets.EmitStun:Clone();
                        v27.Parent = PrimaryPart;
                        Ouwmit.Emit(v27);
                        DebrisModule:AddItem(v27, 0.6);
                        local v28 = script.Sounds.PS2thunderclapflashSECONDSLASHvictimexplode:Clone();
                        v28.Parent = v27;
                        v28:Play();
                    end;
                end;

                return;
            end;
        else
            if v5 == "WindUpvictimEFfect" then
                if p4 == nil then
                    return;
                end;

                local u29 = {};

                if p4 ~= nil then
                    for _, v in ipairs(p4) do
                        local LowerTorso = v:FindFirstChild("LowerTorso");

                        if LowerTorso ~= nil then
                            local v30 = script.NewAssets.StunVFX:Clone();
                            v30:PivotTo(LowerTorso.CFrame);
                            v30.Parent = LowerTorso;
                            v30.WeldConstraint.Part1 = LowerTorso;
                            local v31 = script.Sounds.PS2thunderclapflashSECONDSLASHvictimstun:Clone();
                            v31.Parent = v30;
                            v31:Play();
                            Ouwmit.Enable(v30);
                            local v32 = script.NewAssets.YellowHighlight:Clone();
                            v32.Parent = v30;
                            v32.Adornee = v;
                            table.insert(u29, v32);
                            table.insert(u29, v30);
                            DebrisModule:AddItem(v30, 4);
                        end;
                    end;
                end;

                task.delay(2.5, function() -- Line: 348
                    -- upvalues: u29 (copy), TweenService (ref), Ouwmit (ref)
                    for _, v in ipairs(u29) do
                        if v:IsA("Highlight") then
                            TweenService:Create(v, TweenInfo.new(1), {
                                FillTransparency = 1,
                                OutlineTransparency = 1
                            }):Play();
                        else
                            Ouwmit.Enable(v, false);
                        end;
                    end;
                end);

                return;
            end;

            if v5 == "Cancel" then
                local v33 = workspace_Debree:FindFirstChild(string_format_ret);

                if v33 == nil then
                    return;
                end;

                if v33 then
                    v33.Name = "_";
                    v33:SetAttribute("Active", false);
                    DebrisModule:AddItem(v33, 3);
                    Ouwmit.Enable(v33, false);
                    vfxUtility.TweenLight(v33, {
                        Time = 0.1,
                        Off = true
                    });
                end;

                local Zenitsu_Highlight = v33:FindFirstChild("Zenitsu_Highlight");

                if Zenitsu_Highlight then
                    TweenService:Create(Zenitsu_Highlight, TweenInfo.new(0.15), {
                        OutlineTransparency = 1,
                        FillTransparency = 1
                    }):Play();
                    DebrisModule:AddItem(Zenitsu_Highlight, 0.15);
                end;

                CraterEffects.endConnection(p2, "CSI_" .. p2.Name);
            end;
        end;

        return;
    end;

    local _, v34 = table.unpack(p4);
    local Folder = Instance.new("Folder");
    Folder.Name = string_format_ret .. "-Final";
    Folder.Parent = workspace.Debree;
    DebrisModule:AddItem(Folder, 3);
    local v35 = script.NewAssets.WindupSlash:Clone();
    v35.Startup.CFrame = v34 * CFrame.new(0, 0, 0);
    v35.Parent = Folder;
    Ouwmit.Emit(v35);
    Cam_Shaker(HumanoidRootPart.Position, "tinyshake_preset");
    local v36 = script.NewAssets.ZenitsuthunderclapHighlight:Clone();
    v36.Parent = p2;
    v36.Adornee = p2;
    v36.Name = "Zenitsu_Highlight";
    TweenService:Create(v36, TweenInfo.new(0.25), {
        OutlineTransparency = 0
    }):Play();
    local v37 = script.Sounds.PS2thunderclapflashSECONDSLASH:Clone();
    v37.Parent = v35.Startup;
    v37:Play();
    task.wait(0.55);
    Cam_Shaker(HumanoidRootPart.Position, "Medium_tiny_shake_preset");
    local v38 = script.NewAssets.LightningSlash:Clone();
    v38:PivotTo(v34);
    v38.Parent = Folder;
    Ouwmit.Emit(v38);
    TweenService:Create(v36, TweenInfo.new(0.5), {
        FillTransparency = 1.5
    }):Play();
    task.wait(0.55);
    Cam_Shaker(HumanoidRootPart.Position, {
        FadeInTime = 0,
        Frequency = 0.1,
        Amplitude = 0.65,
        SustainTime = 0.14,
        FadeOutTime = 0.5,
        RotationInfluence = Vector3.new(0.25, 0.25, 0.25),
        PositionInfluence = Vector3.new(3.5, 3.5, 3.5)
    });

    if v38 ~= nil then
        v38:Destroy();
    end;

    local v39 = workspace:Raycast(v34.Position + v34.upVector * 5, v34.upVector * -50, RaycastHelper.Crater);
    local v40;

    if v39 == nil or v39.Instance == nil then
        v40 = nil;
    else
        v40 = v39.Instance.Color;
    end;

    local v41 = script.NewAssets.LightningSlashEndEmit:Clone();
    v41:PivotTo(v34);
    v41.Parent = Folder;
    Ouwmit.Emit(v41, v40 ~= nil and {
        Color = v40,
        ColorWhitelist = { "raycastdust", "Rocks", "dusteffasd" }
    } or false);
    TweenService:Create(v36, TweenInfo.new(1), {
        OutlineTransparency = 1,
        FillTransparency = 1
    }):Play();
    DebrisModule:AddItem(v36, 1);
end;