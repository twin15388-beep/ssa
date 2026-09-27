-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
game:GetService("RunService");
local Modules = game:GetService("ReplicatedStorage").CAM.Client.Modules;
local Cam_Shaker = require(Modules.Effects.Cam_Shaker);
require(Modules.Effects.Craters.CraterHandler);
require(Modules.Effects.Craters.CraterEffects);
local ImpactFrames = require(Modules.Effects.ImpactFrames);
local LocalPlayer = Players.LocalPlayer;
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
local RaycastParams_new_ret2 = RaycastParams.new();
RaycastParams_new_ret2.FilterType = Enum.RaycastFilterType.Include;
RaycastParams_new_ret2.FilterDescendantsInstances = { workspace.Map };

local function SpawnSwordAura(p1) -- Line: 47
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

local function SetPartCFrame(p3, p4, p5) -- Line: 62
    return p3.CFrame * p4.CFrame:ToObjectSpace(p5.CFrame);
end;

local function Random_Number(p6, p7) -- Line: 66
    return Random.new():NextNumber(p6, p7);
end;

return function(p8: userdata, p9: any, p10: any) -- Line: 70
    -- upvalues: workspace_Debree (copy), vfxUtility (copy), Sounds (copy), DebrisModule (copy), Cam_Shaker (copy), SpawnSwordAura (copy), Assets (copy), LocalPlayer (copy), ImpactFrames (copy), TweenService (copy)
    local HumanoidRootPart = p8:FindFirstChild("HumanoidRootPart");
    local UpperTorso = p8:FindFirstChild("UpperTorso");

    if not HumanoidRootPart then
        return;
    end;

    if not UpperTorso then
        return;
    end;

    local string_format_ret = string.format("%s_%s_Effects", p8.Name, script.Name);

    if p9 ~= "Cancel" and (HumanoidRootPart.Position - workspace.CurrentCamera.CFrame.Position).Magnitude > 250 then
        return;
    end;

    if p9 == "Hold" then
        if workspace_Debree:FindFirstChild(string_format_ret) then
            workspace_Debree:FindFirstChild(string_format_ret):Destroy();
        end;

        vfxUtility.PlaySound(Sounds, "PS2insectILstart", HumanoidRootPart, true);
        local Folder = Instance.new("Folder");
        Folder.Name = string_format_ret;
        Folder.Parent = workspace_Debree;
        Folder:SetAttribute("Active", true);
        DebrisModule:AddItem(Folder, 12);
        Cam_Shaker(HumanoidRootPart.Position, "activate_shakelessaggresive");
        local v11 = workspace_Debree:FindFirstChild(string_format_ret);
        SpawnSwordAura(p8).Parent = v11;
        local v12 = Assets.StartupEmit:Clone();
        v12:PivotTo(HumanoidRootPart.CFrame * CFrame.new(0.10357666015625, -1.1841049194335938, -0.58538818359375) * CFrame.fromEulerAnglesYXZ(1.2218952178955078e-6, 3.141592264175415, -3.2782460834823723e-7));
        v12.Parent = v11;
        local v13 = vfxUtility.CheckForGround(HumanoidRootPart.Position, Vector3.new(0, -20, 0), vfxUtility.RayParams.Map);
        vfxUtility.ChangeDustColor(v13, v12.Startup.raycastdust);
        vfxUtility.EmitAll(v12);
        DebrisModule:AddItem(v12, 2);

        return;
    end;

    if p9 == "Thrust" then
        local v14 = workspace_Debree:FindFirstChild(string_format_ret);

        if v14 == nil then
            return;
        end;

        local CFrame2 = HumanoidRootPart.CFrame;
        Cam_Shaker(CFrame2.Position, "Medium_tiny_shake_preset");
        vfxUtility.PlaySound(Sounds, "PS2insectULTjab", HumanoidRootPart, true);
        local v15 = script.Assets.EndEmit:Clone();
        v15.CFrame = CFrame2 * CFrame.new(0, 0, -3) * CFrame.Angles(0, -1.5707963267948966, 0);
        v15.Parent = v14;
        DebrisModule:AddItem(v15, 3);
        vfxUtility.EmitAll(v15);
        local v16 = workspace:Raycast(CFrame2 * CFrame.new(0, 2, 0).Position, CFrame2.UpVector * -20, vfxUtility.RayParams.Map);
        local v17 = CFrame2 * CFrame.new(0, -2.7, 0);
        local v18 = script.Assets.GroundFX:Clone();
        v18.Parent = v14;

        if v16 == nil or v16.Instance == nil then
            v18.CFrame = v17;
            vfxUtility.EmitAll(v18.raycastdust2.grass_blade14);
        else
            v18.CFrame = CFrame.new(v16.Position) * v17.Rotation;
            vfxUtility.EmitAll(v18.raycastdust.Attachment, {
                Color = v16.Instance.Color
            });
            vfxUtility.EmitAll(v18.raycastdust2, {
                ColorBlacklist = "grass_blade14",
                Color = v16.Instance.Color
            });
        end;

        vfxUtility.EmitAll(v18.keep);
        vfxUtility.EmitAll(v18.raycastdust.Debree);

        if v14 then
            v14.Name = "_";
            DebrisModule:AddItem(v14, 2);
            v14:SetAttribute("Active", nil);
            vfxUtility.EnableAll(v14, false);
            vfxUtility.TweenLight(v14, {
                Time = 0.01,
                Off = true
            });
        end;
    else
        if p9 == "Cutscene" then
            local v19, v20, v21 = unpack(p10);

            if v19 == nil or (v20 == nil or v21 == nil) then
                return;
            end;

            local u22 = workspace_Debree:FindFirstChild(string_format_ret);

            if not u22 then
                u22 = Instance.new("Folder");
                u22.Name = string_format_ret;
                u22.Parent = workspace_Debree;
                u22:SetAttribute("Active", true);
                DebrisModule:AddItem(u22, 5);
            end;

            local u23 = {};
            local v24 = workspace_Debree:FindFirstChild(v19);
            local v25 = nil;

            if v24 then
                local Bone = v24:FindFirstChild("Bone");

                if Bone then
                    v25 = Assets.VFX.CameraVFX:Clone();
                    v25:PivotTo(Bone.CFrame);
                    v25.Parent = u22;

                    for _, child in v25:GetChildren() do
                        if child ~= v25.PrimaryPart then
                            vfxUtility.WeldConstraint(child, Bone);
                        end;
                    end;

                    DebrisModule:AddItem(v25, v20 + 2);
                end;
            end;

            if v25 then
                vfxUtility.EmitAll(v25.CameraVFXZoom);
            end;

            local v26 = Assets["Insect Ultimate PS2"]:Clone();
            v26:PivotTo(HumanoidRootPart.CFrame * CFrame.new(-0.00006103515625, -1.9204254150390625, 0.04986572265625) * CFrame.fromEulerAnglesYXZ(-1.4923540447853156e-7, -3.141592502593994, 1.119348951306165e-7));
            v26.Parent = u22;
            DebrisModule:AddItem(v26, v20);
            v26.AnimationController:LoadAnimation(Assets.Butterfly):Play();
            vfxUtility.PlaySound(Sounds, "PS2insectILcinematic", HumanoidRootPart, true);
            task.wait(0.05);

            if not u22:GetAttribute("Active") then
                return;
            end;

            local v27 = Assets.VFX.Thrust1:Clone();
            v27:PivotTo(HumanoidRootPart.CFrame * Assets.VFX.Root.CFrame:ToObjectSpace(Assets.VFX.Thrust1.PrimaryPart.CFrame));
            v27.Parent = u22;
            DebrisModule:AddItem(v27, 2);
            local v28 = vfxUtility.CheckForGround(v27.PrimaryPart.Position + Vector3.new(0, 2, 0), Vector3.new(0, -20, 0), vfxUtility.RayParams.Map);
            vfxUtility.ChangeDustColor(v28, v27.GroundFX);
            vfxUtility.EmitAll(v27);
            task.wait(0.483);

            if not u22:GetAttribute("Active") then
                return;
            end;

            local v29 = Assets.VFX.LandFX:Clone();
            v29.CFrame = HumanoidRootPart.CFrame * Assets.VFX.Root.CFrame:ToObjectSpace(Assets.VFX.LandFX.CFrame);
            v29.Parent = u22;
            local v30 = vfxUtility.CheckForGround(v29.Position + Vector3.new(0, 2, 0), Vector3.new(0, -20, 0), vfxUtility.RayParams.Map);
            vfxUtility.ChangeDustColor(v30, { v29.raycastdust, v29.raycastdust2 });
            vfxUtility.EmitAll(v29);
            DebrisModule:AddItem(v29, 2);
            task.wait(0.234);

            if not u22:GetAttribute("Active") then
                return;
            end;

            local v31 = Assets.VFX.JumpTest1:Clone();
            v31:PivotTo(HumanoidRootPart.CFrame * Assets.VFX.Root.CFrame:ToObjectSpace(Assets.VFX.JumpTest1.PrimaryPart.CFrame));
            v31.Parent = u22;
            local v32 = vfxUtility.CheckForGround(v31.PrimaryPart.Position + Vector3.new(0, 2, 0), Vector3.new(0, -20, 0), vfxUtility.RayParams.Map);
            vfxUtility.ChangeDustColor(v32, { v31.LandFX.raycastdust, v31.LandFX.raycastdust2 });
            vfxUtility.EmitAll(v31);
            DebrisModule:AddItem(v31, v20);
            local u33 = Assets.VFX.Dashtrail:Clone();
            u33.CFrame = UpperTorso.CFrame;
            u33.Parent = u22;
            vfxUtility.WeldConstraint(u33, UpperTorso);
            vfxUtility.EmitAll(u33);
            DebrisModule:AddItem(u33, v20);
            u33.A0.bodytrail1.Enabled = true;
            task.delay(0.3, function() -- Line: 243
                -- upvalues: u33 (copy)
                if u33 then
                    u33.A0.bodytrail1.Enabled = false;
                end;
            end);

            if v25 then
                vfxUtility.EmitAll(v25.CameraVFX);
                vfxUtility.EmitAll(v25.CameraVFX2);
            end;

            task.wait(0.216);

            if not u22:GetAttribute("Active") then
                return;
            end;

            if v25 then
                vfxUtility.EmitAll(v25.ButterFlies);
            end;

            local v34 = table.find(v21, LocalPlayer.Character) ~= nil;

            if v34 then
                local v35 = Assets.VFX.spotlight:Clone();
                v35.CFrame = HumanoidRootPart.CFrame * Assets.VFX.Root.CFrame:ToObjectSpace(Assets.VFX.spotlight.CFrame);
                v35.Parent = u22;
                vfxUtility.EmitAll(v35);
                DebrisModule:AddItem(v35, 3);
            end;

            task.wait(0.067);

            if not u22:GetAttribute("Active") then
                return;
            end;

            local v36 = Assets.VFX.CapriceCharge:Clone();
            v36.CFrame = HumanoidRootPart.CFrame * Assets.VFX.Root.CFrame:ToObjectSpace(Assets.VFX.CapriceCharge.CFrame);
            v36.Parent = u22;
            vfxUtility.EmitAll(v36);
            DebrisModule:AddItem(v36, 2);
            task.wait(1.017);

            if not u22:GetAttribute("Active") then
                return;
            end;

            if v25 then
                vfxUtility.EmitAll(v25.ButterFlies2);
            end;

            local v37 = Assets.VFX.BodyEmit:Clone();
            v37.CFrame = HumanoidRootPart.CFrame * Assets.VFX.Root.CFrame:ToObjectSpace(Assets.VFX.BodyEmit.CFrame);
            v37.Parent = u22;
            vfxUtility.EmitAll(v37);
            DebrisModule:AddItem(v37, 3);
            vfxUtility.EmitAll(v26);

            for _, v in v21 do
                if LocalPlayer.Character == v then
                    local v38 = Assets.VFX.backdrop:Clone();
                    v38.CFrame = HumanoidRootPart.CFrame * Assets.VFX.Root.CFrame:ToObjectSpace(Assets.VFX.backdrop.CFrame);
                    v38.Parent = u22;
                    vfxUtility.EmitAll(v38);
                    DebrisModule:AddItem(v38, 3);
                    break;
                end;
            end;

            if v34 then
                local v39 = Assets.VFX.backdrop:Clone();
                v39.CFrame = HumanoidRootPart.CFrame * Assets.VFX.Root.CFrame:ToObjectSpace(Assets.VFX.backdrop.CFrame);
                v39.Parent = u22;
                vfxUtility.EmitAll(v39);
                DebrisModule:AddItem(v39, 3);
            end;

            task.wait(0.766);

            if not u22:GetAttribute("Active") then
                return;
            end;

            if v25 then
                vfxUtility.EmitAll(v25.CameraVFXZoom2);
            end;

            task.wait(0.784);

            if not u22:GetAttribute("Active") then
                return;
            end;

            local v40 = Assets.VFX.Flap1:Clone();
            v40.CFrame = HumanoidRootPart.CFrame * Assets.VFX.Root.CFrame:ToObjectSpace(Assets.VFX.Flap1.CFrame);
            v40.Parent = u22;
            vfxUtility.EmitAll(v40);
            DebrisModule:AddItem(v40, 3);
            task.wait(0.883);

            if not u22:GetAttribute("Active") then
                return;
            end;

            local v41 = Assets.VFX.Flap2:Clone();
            v41.CFrame = HumanoidRootPart.CFrame * Assets.VFX.Root.CFrame:ToObjectSpace(Assets.VFX.Flap2.CFrame);
            v41.Parent = u22;
            vfxUtility.EmitAll(v41);
            DebrisModule:AddItem(v41, 3);
            task.wait(0.133);

            if not u22:GetAttribute("Active") then
                return;
            end;

            local Sword_At_A = p8:FindFirstChild("Sword_At_A", true);

            if Sword_At_A ~= nil then
                local Parent = Sword_At_A.Parent;

                if u22:FindFirstChild("SwordAura") then
                    vfxUtility.EnableAll(u22:FindFirstChild("SwordAura"), false);
                end;

                local v42 = Assets.VFX.SwordAura2:Clone();
                v42.CFrame = Parent.CFrame;
                v42.Parent = u22;
                vfxUtility.EnableAll(v42, true);
                vfxUtility.WeldConstraint(v42, Parent);
                DebrisModule:AddItem(v42, v20);
            end;

            task.wait(0.55);

            if not u22:GetAttribute("Active") then
                return;
            end;

            if table.find(v21, LocalPlayer.Character) then
                task.delay(0.11666666666666667, function() -- Line: 366
                    -- upvalues: u22 (ref), ImpactFrames (ref)
                    if not u22:GetAttribute("Active") then
                        return;
                    end;

                    local u43 = ImpactFrames.PlaySet({
                        FrameRate = 0.02857142857142857,
                        FramesSetName = "Illusory_Light"
                    });
                    local u44 = nil;
                    local task_delay_ret = task.delay(3, function() -- Line: 374
                        -- upvalues: u44 (ref)
                        if u44 and u44.Connected then
                            u44:Disconnect();
                        end;
                    end);
                    u44 = u22.AttributeChanged:Connect(function(p45: string) -- Line: 380
                        -- upvalues: u22 (ref), u43 (copy), u44 (ref), task_delay_ret (copy)
                        if u22:GetAttribute("Active") then
                            return;
                        end;

                        u43();
                        u44:Disconnect();
                        task.cancel(task_delay_ret);
                    end);
                end);
            end;

            local v46 = Assets.VFX.EndImpact1:Clone();
            v46.CFrame = HumanoidRootPart.CFrame * Assets.VFX.Root.CFrame:ToObjectSpace(Assets.VFX.EndImpact1.CFrame);
            v46.Parent = u22;
            vfxUtility.EmitAll(v46);
            local v47 = vfxUtility.CheckForGround(v46.Position + Vector3.new(0, 2, 0), Vector3.new(0, -20, 0), vfxUtility.RayParams.Map);
            vfxUtility.ChangeDustColor(v47, { v46.raycastdust, v46.raycastdust2 });
            DebrisModule:AddItem(v46, 6);
            local u48 = Assets.VFX.RockAtlasModule.RockDebree1:Clone();
            u48:PivotTo(HumanoidRootPart.CFrame * Assets.VFX.Root.CFrame:ToObjectSpace(Assets.VFX.RockAtlasModule.RockDebree1.PrimaryPart.CFrame));
            u48.Parent = u22;
            DebrisModule:AddItem(u48, 6);
            task.spawn(function() -- Line: 402
                -- upvalues: u48 (copy), vfxUtility (ref), TweenService (ref), u23 (copy)
                for _, child in u48:GetChildren() do
                    if child ~= u48.PrimaryPart then
                        local v49 = workspace:Raycast(child.Position + Vector3.new(0, 5, 0), Vector3.new(0, -15, 0), vfxUtility.RayParams.Map);
                        local v50;

                        if v49 then
                            child.Color = v49.Instance.Color;
                            child.Transparency = v49.Instance.Transparency;
                            child.Material = v49.Instance.Material;
                            child.Reflectance = v49.Instance.Reflectance;
                            v50 = child;

                            for _, child2 in v49.Instance:GetChildren() do
                                if child2:IsA("Decal") or child2:IsA("Texture") then
                                    child2:Clone().Parent = v50;
                                end;
                            end;
                        else
                            v50 = child;
                        end;

                        v50.Position = v50.Position + Vector3.new(0, -20, 0);
                        TweenService:Create(v50, TweenInfo.new(Random.new():NextNumber(0.2, 0.4), Enum.EasingStyle.Sine), {
                            Position = v50.Position + Vector3.new(0, 20, 0)
                        }):Play();
                        table.insert(u23, v50);
                    end;
                end;
            end);
            task.wait(0.567);

            if not u22:GetAttribute("Active") then
                return;
            end;

            local v51 = Assets.VFX.EndImpact2:Clone();
            v51.CFrame = HumanoidRootPart.CFrame * Assets.VFX.Root.CFrame:ToObjectSpace(Assets.VFX.EndImpact2.CFrame);
            v51.Parent = u22;
            local v52 = vfxUtility.CheckForGround(v51.Position + Vector3.new(0, 2, 0), Vector3.new(0, -20, 0), vfxUtility.RayParams.Map);
            vfxUtility.ChangeDustColor(v52, v51.raycastdust);
            vfxUtility.EmitAll(v51);
            DebrisModule:AddItem(v51, 6);

            if v25 then
                vfxUtility.EmitAll(v25.FinalCameraZoom);
            end;

            local u53 = Assets.VFX.RockAtlasModule.Main_Rocks:Clone();
            u53:PivotTo(HumanoidRootPart.CFrame * Assets.VFX.Root.CFrame:ToObjectSpace(Assets.VFX.RockAtlasModule.Main_Rocks.PrimaryPart.CFrame));
            u53.Parent = u22;
            DebrisModule:AddItem(u53, 6);
            task.spawn(function() -- Line: 452
                -- upvalues: u53 (copy), vfxUtility (ref), TweenService (ref), u23 (copy)
                for _, descendant in u53:GetDescendants() do
                    if descendant ~= u53.PrimaryPart and descendant:IsA("Part") then
                        local v54 = workspace:Raycast(descendant.Position + Vector3.new(0, 5, 0), Vector3.new(0, -15, 0), vfxUtility.RayParams.Map);
                        local v55;

                        if v54 then
                            descendant.Color = v54.Instance.Color;
                            descendant.Transparency = v54.Instance.Transparency;
                            descendant.Material = v54.Instance.Material;
                            descendant.Reflectance = v54.Instance.Reflectance;
                            v55 = descendant;

                            for _, child in v54.Instance:GetChildren() do
                                if child:IsA("Decal") or child:IsA("Texture") then
                                    child:Clone().Parent = v55;
                                end;
                            end;
                        else
                            v55 = descendant;
                        end;

                        v55.Position = v55.Position + Vector3.new(0, -20, 0);
                        TweenService:Create(v55, TweenInfo.new(Random.new():NextNumber(0.2, 0.4), Enum.EasingStyle.Sine), {
                            Position = v55.Position + Vector3.new(0, 20, 0)
                        }):Play();
                        table.insert(u23, v55);
                    end;
                end;
            end);
            task.wait(0.017);

            if not u22:GetAttribute("Active") then
                return;
            end;

            for _, v in u23 do
                vfxUtility.EnableAll(v, true);
            end;

            task.wait(1.067);

            if not u22:GetAttribute("Active") then
                return;
            end;

            for _, v in u23 do
                vfxUtility.EnableAll(v, false);
                task.delay(1.5, function() -- Line: 495
                    -- upvalues: TweenService (ref), v (copy), DebrisModule (ref)
                    TweenService:Create(v, TweenInfo.new(2, Enum.EasingStyle.Sine), {
                        Position = v.Position + Vector3.new(0, -15, 0)
                    }):Play();
                    DebrisModule:AddItem(v, 0.3);
                end);
            end;

            if v26 then
                v26:Destroy();
            end;

            if u22 then
                u22.Name = "_";
                DebrisModule:AddItem(u22, 6);
                u22:SetAttribute("Active", nil);
                vfxUtility.EnableAll(u22, false);
                vfxUtility.TweenLight(u22, {
                    Time = 0.01,
                    Off = true
                });
            end;

            return;
        end;

        if p9 == "Cancel" then
            local v56 = workspace_Debree:FindFirstChild(string_format_ret);
            local PS2insectILcinematic = HumanoidRootPart:FindFirstChild("PS2insectILcinematic");

            if PS2insectILcinematic ~= nil then
                PS2insectILcinematic:Destroy();
            end;

            if v56 then
                v56.Name = "_";
                DebrisModule:AddItem(v56, 2);
                v56:SetAttribute("Active", nil);
                vfxUtility.EnableAll(v56, false);
                vfxUtility.TweenLight(v56, {
                    Time = 0.01,
                    Off = true
                });
            end;
        end;
    end;
end;