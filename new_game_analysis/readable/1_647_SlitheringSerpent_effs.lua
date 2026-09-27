-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local ImpactFrames = require(ReplicatedStorage.CAM.Client.Modules.Effects.ImpactFrames);
local u1 = workspace.Debree:FindFirstChild(game.Players.LocalPlayer.Name .. "\'s effects debree thing213asdasdasdasd");
local vfxUtility = require(game.ReplicatedStorage.CAM.Client.Modules.Effects.vfxUtility);
local DebrisModule = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("DebrisModule"));

if u1 == nil then
    u1 = Instance.new("Folder", workspace.Debree);
    u1.Name = game.Players.LocalPlayer.Name .. "\'s effects debree thing213asdasdasdasd";
end;

local Assets = script:FindFirstChild("Assets");
local Sounds = script:FindFirstChild("Sounds");
local LocalPlayer = Players.LocalPlayer;
local AuraEffects = require(script.Parent.AuraEffects);
local Cam_Shaker = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Client"):WaitForChild("Modules"):WaitForChild("Effects"):WaitForChild("Cam_Shaker"));

return function(p2: userdata, p3: any, u4: any, p5: vector, p6: vector, p7: vector) -- Line: 27
    -- upvalues: AuraEffects (copy), u1 (ref), DebrisModule (copy), vfxUtility (copy), Sounds (copy), Assets (copy), LocalPlayer (copy), CollectionService (copy), TweenService (copy), Cam_Shaker (copy), ImpactFrames (copy)
    if p2 == nil or p3 == nil then
        return;
    end;

    local HumanoidRootPart = p2:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart == nil then
        return;
    end;

    if (HumanoidRootPart.Position - workspace.CurrentCamera.CFrame.Position).Magnitude >= 250 and p3 ~= "Cancel" then
        return;
    end;

    p2:FindFirstChild("RightHand");
    p2:FindFirstChild("LeftHand");
    local string_format_ret = string.format("%s SlitheringSerpentEffects", p2.Name);

    if p3 == "Start" then
        AuraEffects.TurnOnAura(p2);

        return;
    end;

    if p3 == "Cancel" then
        AuraEffects.TurnOffAura(p2);

        if u1:FindFirstChild(string_format_ret) then
            local v8 = u1:FindFirstChild(string_format_ret);
            v8.Name = "_";
            v8:SetAttribute("Active", false);
            DebrisModule:AddItem(v8, 2.5);

            return;
        end;

        return;
    end;

    if p3 ~= "Dash" then
        if p3 == "Success" then
            AuraEffects.TurnOffAura(p2);

            if u1:FindFirstChild(string_format_ret) then
                local v9 = u1:FindFirstChild(string_format_ret);
                v9.Name = "_";
                v9:SetAttribute("Active", false);
                DebrisModule:AddItem(v9, 2.5);
            end;

            local PlaySound = vfxUtility.PlaySound;
            local v10;

            if table.find(u4, LocalPlayer.Character) then
                v10 = workspace.CurrentCamera or HumanoidRootPart;
            else
                v10 = HumanoidRootPart;
            end;

            PlaySound(Sounds, "PS2snakeSlitheringSerpCINEMATIC2", v10, true);
            local v11 = Assets.Snake:Clone();
            v11.PrimaryPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(-0.000030517578125, -3.183990478515625, 7.029052734375) * CFrame.fromEulerAnglesYXZ(-2.154514698701933e-14, 3.141592502593994, -2.821300597588561e-7);
            vfxUtility.WeldConstraint(HumanoidRootPart, v11.PrimaryPart);
            v11.Parent = u1;
            v11.AnimationController:LoadAnimation(script.Animations["Main Snake"]):Play();
            local v12 = Assets.Snake:Clone();
            v12.PrimaryPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(-0.000030517578125, -3.183990478515625, 7.029052734375) * CFrame.fromEulerAnglesYXZ(-2.154514698701933e-14, 3.141592502593994, -2.821300597588561e-7);
            vfxUtility.WeldConstraint(HumanoidRootPart, v12.PrimaryPart);
            v12.Parent = u1;
            v12.AnimationController:LoadAnimation(script.Animations["Binding Snake"]):Play();
            p2.Archivable = true;
            local u13 = {};

            for i, v in { "First", "Second", "Third", "Fourth" } do
                local v14 = p2:Clone();
                local v15 = p2:FindFirstChild("Accessories") and p2.Accessories:FindFirstChild("CustomRig");

                for _, descendant in pairs(v14:GetDescendants()) do
                    if descendant:IsA("LocalScript") or (descendant:IsA("ModuleScript") or (descendant:isA("Script") or (descendant:IsA("LinearVelocity") or (descendant:IsA("AlignOrientation") or (descendant:IsA("ParticleEmitter") or (descendant:IsA("Trail") or (descendant:IsA("Beam") or (descendant:IsA("Sound") or (descendant:IsA("Light") or (descendant:IsA("BillboardGui") or (descendant:IsA("SurfaceGui") or (descendant:IsA("ProximityPrompt") or (descendant:IsA("Highlight") or descendant:IsA("ForceField")))))))))))))) then
                        descendant:Destroy();
                    elseif descendant:IsA("BasePart") or descendant:IsA("Decal") then
                        local Attribute = descendant:GetAttribute("istransparent");

                        if Attribute ~= nil and (v15 == nil or descendant.Parent ~= nil and descendant.Parent.Name == "CustomRig") then
                            descendant.Transparency = Attribute;
                            descendant:SetAttribute("istransparent", nil);
                        end;
                    end;
                end;

                if CollectionService:HasTag(v14, "Humanoid") then
                    CollectionService:RemoveTag(v14, "Humanoid");
                end;

                v14.Name = "SlitheringSerpentClone" .. tostring(i);
                v14.HumanoidRootPart.CFrame = HumanoidRootPart.CFrame;
                v14.Parent = u1;
                table.insert(u13, v14);

                if v14 and (v14:FindFirstChild("Tool_Accessories") and v14:FindFirstChild("Tool_Accessories"):FindFirstChild("Regular Katana")) then
                    local v16 = v14:FindFirstChild("Tool_Accessories"):FindFirstChild("Regular Katana");

                    if v16:FindFirstChild("Plane") then
                        local Plane = v16:FindFirstChild("Plane");
                        local v17 = Assets.Aura:Clone();
                        v17.CFrame = Plane.CFrame;
                        v17.Parent = u1;
                        vfxUtility.WeldConstraint(v17, Plane);
                        DebrisModule:AddItem(v17, 1);

                        for _, descendant in v17:GetDescendants() do
                            if descendant:IsA("Beam") then
                                descendant.Enabled = true;
                                local Width0 = descendant.Width0;
                                local Width1 = descendant.Width1;
                                descendant.Width0 = 0;
                                descendant.Width1 = 0;
                                TweenService:Create(descendant, TweenInfo.new(0.4), {
                                    Width0 = Width0,
                                    Width1 = Width1
                                }):Play();
                            end;
                        end;
                    end;
                end;

                v14:FindFirstChild("Humanoid"):LoadAnimation(script.Animations[v]):Play();
            end;

            local u18 = Assets.Trail:Clone();
            u18.CFrame = u13[1].UpperTorso.CFrame;
            u18.Parent = u1;
            vfxUtility.EnableAll(u18, true);
            vfxUtility.WeldConstraint(u18, u13[1].UpperTorso);
            p2.Archivable = false;
            task.spawn(function() -- Line: 217
                -- upvalues: Assets (ref), u13 (copy), u1 (ref), vfxUtility (ref), DebrisModule (ref), u18 (copy)
                task.wait(1.499);
                local v19 = Assets.Slash:Clone();
                v19.CFrame = u13[2].UpperTorso.CFrame * CFrame.Angles(0, 0, 1.5707963267948966);
                v19.Parent = u1;
                vfxUtility.EmitAll(v19:GetDescendants());
                DebrisModule:AddItem(v19, 4);
                u13[2]:Destroy();
                task.wait(0.2497);
                local v20 = Assets.Slash:Clone();
                v20.CFrame = u13[3].UpperTorso.CFrame * CFrame.Angles(0, 0, 1.5707963267948966);
                v20.Parent = u1;
                vfxUtility.EmitAll(v20:GetDescendants());
                DebrisModule:AddItem(v20, 4);
                u13[3]:Destroy();
                task.wait(0.3);
                local v21 = Assets.Slash:Clone();
                v21.CFrame = u13[4].UpperTorso.CFrame * CFrame.Angles(0, 0, 1.5707963267948966);
                v21.Parent = u1;
                vfxUtility.EmitAll(v21:GetDescendants());
                DebrisModule:AddItem(v21, 4);
                u13[4]:Destroy();
                task.wait(0.232);
                u18:FindFirstChild("WeldConstraint"):Destroy();
                u18.Anchored = true;
                vfxUtility.EnableAll(u18, false);
                DebrisModule:AddItem(u18, 2);
                u13[1]:Destroy();
            end);
            task.spawn(function() -- Line: 258
                -- upvalues: Assets (ref), HumanoidRootPart (copy), u1 (ref), vfxUtility (ref), DebrisModule (ref), Cam_Shaker (ref), LocalPlayer (ref), u4 (copy), ImpactFrames (ref)
                local v22 = Assets.Cutscene_VFX:Clone();
                v22:PivotTo(HumanoidRootPart.CFrame);
                v22.Parent = u1;
                local v23 = Assets.BigSlash:Clone();
                v23.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 5, 0) * CFrame.Angles(0, 0, 1.5707963267948966);
                v23.Parent = u1;
                vfxUtility.EmitAll(v23:GetDescendants());
                DebrisModule:AddItem(v23, 4);
                task.wait(1.21);
                vfxUtility.EmitAll(v22.Dash_1:GetDescendants());
                task.wait(0.34);
                vfxUtility.EmitAll(v22.Dash_2:GetDescendants());
                task.wait(0.216);
                vfxUtility.EmitAll(v22.Dash_3:GetDescendants());
                task.wait(0.3);
                vfxUtility.EmitAll(v22.Dash_4:GetDescendants());
                DebrisModule:AddItem(v22, 2);
                task.wait(0.233);
                local v24 = Assets.Eye:Clone();
                v24.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 5, 0);
                v24.Parent = u1;
                vfxUtility.EmitAll(v24:GetDescendants());
                DebrisModule:AddItem(v24, 4);
                Cam_Shaker(HumanoidRootPart.Position, "Medium_tiny_shake_preset");

                if LocalPlayer.Character and table.find(u4, LocalPlayer.Character) then
                    ImpactFrames.PlaySet({
                        FrameRate = 0.025,
                        FramesSetName = "SlitheringSerpent"
                    });
                end;
            end);
            task.wait(3.65);
            TweenService:Create(v11.PrimaryPart, TweenInfo.new(0.25), {
                Transparency = 1
            }):Play();
            DebrisModule:AddItem(v11, 0.5);
            TweenService:Create(v12.PrimaryPart, TweenInfo.new(0.25), {
                Transparency = 1
            }):Play();
            DebrisModule:AddItem(v12, 0.5);
            AuraEffects.TurnOffAura(p2);
        end;

        return;
    end;

    AuraEffects.TurnOffAura(p2);

    if u1:FindFirstChild(string_format_ret) then
        local v25 = u1:FindFirstChild(string_format_ret);
        v25.Name = "_";
        v25:SetAttribute("Active", false);
        DebrisModule:AddItem(v25, 2.5);
    end;

    vfxUtility.PlaySound(Sounds, "PS2snakeSlitheringSerpteledash", HumanoidRootPart, true);
    local Folder = Instance.new("Folder");
    Folder.Name = string_format_ret;
    Folder.Parent = u1;
    DebrisModule:AddItem(Folder, 10);
    local CFrame_lookAlong_ret = CFrame.lookAlong(p6, p5);
    local CFrame_lookAlong_ret2 = CFrame.lookAlong(p7, p5);
    Folder:SetAttribute("Active", true);
    local Magnitude = (CFrame_lookAlong_ret2.Position - CFrame_lookAlong_ret.Position).Magnitude;
    local v26 = Assets.Start_Dash_VFX:Clone();
    v26:PivotTo(CFrame_lookAlong_ret);
    v26.Parent = Folder;
    vfxUtility.EmitAll(v26:GetDescendants());
    DebrisModule:AddItem(v26, 3);
    local v27 = -10;

    for i = 1, math.floor(Magnitude / 10) do
        if not Folder:IsDescendantOf(workspace) or Folder:GetAttribute("Active") == false then
            return;
        end;

        v27 = v27 + 6;
        local v28 = Assets.Dash:Clone();
        local v29 = CFrame_lookAlong_ret * CFrame.new(0, 0, -v27);
        v28:PivotTo(CFrame.new(v29.Position.X, HumanoidRootPart.Position.Y, v29.Position.Z) * v29.Rotation);
        v28.Parent = Folder;
        vfxUtility.EmitAll(v28:GetDescendants());
        DebrisModule:AddItem(v28, 2);
        task.wait(0.4 / math.floor(Magnitude / 10));
        local _ = i;
    end;
end;