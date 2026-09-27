-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local workspace_CurrentCamera = workspace.CurrentCamera;
local Ouwmit = require(ReplicatedStorage.CAM.Client.Modules.Effects.Ouwmit);
local RaycastHelper = require(ReplicatedStorage.CAM.Global.RaycastHelper);
local DebrisModule = require(ReplicatedStorage.CAM.DebrisModule);
local TweenService = game:GetService("TweenService");
local OuwCraters = require(ReplicatedStorage.CAM.Client.Modules.Effects.Craters.OuwCraters);
local Cam_Shaker = require(ReplicatedStorage.CAM.Client.Modules.Effects.Cam_Shaker);
local TweenInfo_new_ret = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0);
local TweenInfo_new_ret2 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0);

local function LTN() -- Line: 13
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

return function(p2: userdata, p3: string, p4: any, p5, p6: userdata) -- Line: 21
    -- upvalues: workspace_CurrentCamera (copy), DebrisModule (copy), Ouwmit (copy), TweenService (copy), RaycastHelper (copy), Cam_Shaker (copy), OuwCraters (copy), LTN (copy)
    if p2 == nil or p3 == nil then
        return;
    end;

    local v7 = `{p2.Name} - {script.Name}`;
    local HumanoidRootPart = p2:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart == nil then
        return;
    end;

    if p3 ~= "Cancel" and vector.magnitude(workspace_CurrentCamera.CFrame.Position - HumanoidRootPart.Position) >= 250 then
        return;
    end;

    local v8 = workspace.Debree:FindFirstChild(v7);

    if (p3 == "Cancel" or p3 == "Release") and v8 ~= nil then
        v8.Name = "--";
        DebrisModule:AddItem(v8, 2);
        local OrbRiceSpirit = v8:FindFirstChild("OrbRiceSpirit");

        if OrbRiceSpirit ~= nil then
            Ouwmit.Emit(OrbRiceSpirit.GroundVFX.PointLight);
        end;

        Ouwmit.Enable(v8, false);
        local CasterHighlight = v8:FindFirstChild("CasterHighlight");

        if CasterHighlight ~= nil then
            TweenService:Create(CasterHighlight, TweenInfo.new(0.5), {
                FillTransparency = 1,
                OutlineTransparency = 1
            }):Play();
        end;
    end;

    if p3 ~= "Init" then
        if p3 == "Cancel" then
            return;
        end;

        if p3 == "Disappear" then
            local v9 = script.NewAssets.DepartureEffect:Clone();
            v9:PivotTo(HumanoidRootPart.CFrame * CFrame.new(0, -2.5, 0));
            v9.Parent = workspace.Debree;
            local v10 = script.Sounds.Disappear:Clone();
            v10.Parent = v9.Startup;
            v10:Play();
            DebrisModule:AddItem(v9, 2);
            local v11 = workspace:Raycast(HumanoidRootPart.Position, HumanoidRootPart.CFrame.upVector * -25, RaycastHelper.Crater);
            local v12;

            if v11 == nil or v11.Instance == nil then
                v12 = nil;
            else
                local v13 = CFrame.new(v11.Position, v11.Position + v11.Normal) * CFrame.Angles(-1.5707963267948966, 0, 0) * CFrame.new(0, 0.25, 0);
                v9.Startup.CFrame = v13;
                v12 = v11.Instance.Color;
                v9.Startup.SpawnEmit.WorldCFrame = HumanoidRootPart.CFrame;
            end;

            Ouwmit.Emit(v9, v12 ~= nil and ({
                ColorBlacklist = "GroundShatter",
                Color = v12,
                ColorWhitelist = { "raycastdust", "Rocks" }
            } or nil) or nil);
            OuwCraters.Scales({
                Duration = 1,
                Count = 7,
                ScaleMult = 0.5,
                Radius = 5,
                Center = HumanoidRootPart.CFrame
            });
            Cam_Shaker(HumanoidRootPart.Position, "Medium_tiny_shake_preset");

            return;
        end;

        if p3 == "ReAppear" then
            local v14 = script.NewAssets.ReturnEffect:Clone();
            v14:PivotTo(HumanoidRootPart.CFrame * CFrame.new(0, -2.5, 0));
            v14.Parent = workspace.Debree;
            DebrisModule:AddItem(v14, 2);
            local v15 = script.Sounds.ReAppear:Clone();
            v15.Parent = v14.Startup;
            v15:Play();
            local v16 = workspace:Raycast(HumanoidRootPart.Position, HumanoidRootPart.CFrame.upVector * -25, RaycastHelper.Crater);
            local v17;

            if v16 == nil or v16.Instance == nil then
                v17 = nil;
            else
                local v18 = CFrame.new(v16.Position, v16.Position + v16.Normal) * CFrame.Angles(-1.5707963267948966, 0, 0) * CFrame.new(0, 0.25, 0);
                v14.Startup.CFrame = v18;
                v17 = v16.Instance.Color;
                v14.Startup.SpawnEmit.WorldCFrame = HumanoidRootPart.CFrame;
            end;

            Ouwmit.Emit(v14, v17 ~= nil and ({
                ColorBlacklist = "GroundShatter",
                Color = v17,
                ColorWhitelist = { "raycastdust", "Rocks" }
            } or nil) or nil);
            OuwCraters.Scales({
                Duration = 1,
                Count = 8,
                Center = HumanoidRootPart.CFrame
            });
            Cam_Shaker(HumanoidRootPart.Position, "Medium_tiny_shake_preset");

            return;
        end;

        if p3 == "TP" then
            if p4 == nil or (p5 == nil or p6 == nil) then
                return;
            end;

            local v19 = workspace.Debree:FindFirstChild(v7 .. " - TP CONTENT");

            if v19 == nil then
                v19 = Instance.new("Folder", workspace.Debree);
                v19.Name = v7 .. " - TP CONTENT";
                DebrisModule:AddItem(v19, 4);
            end;

            if p4 ~= nil and p5 ~= nil then
                local v20 = script.NewAssets.TetherBeam:Clone();
                v20.StartPart.CFrame = p4;
                v20.EndPart.CFrame = p5;
                v20.Parent = v19;
                Ouwmit.Emit(v20);
            end;

            local v21 = script.NewAssets.StunVFX:Clone();
            v21:PivotTo(p5 * CFrame.new(0, -3, 0));
            v21.Parent = v19;
            v21.EnableStun.WeldConstraint.Part1 = p6;
            local v22 = script.Sounds.TpToVictim:Clone();
            v22.Parent = v21.EnableStun;
            v22:Play();
            local v23 = workspace:Raycast(HumanoidRootPart.Position, HumanoidRootPart.CFrame.upVector * -25, RaycastHelper.Crater);
            local v24;

            if v23 == nil or v23.Instance == nil then
                v24 = nil;
            else
                v24 = v23.Instance.Color;
            end;

            Ouwmit.Emit(v21.HitEmit, v24 ~= nil and ({
                Color = v24,
                ColorWhitelist = { "raycastdust", "Rocks", "Dust" }
            } or nil) or nil);
            Ouwmit.Enable(v21.EnableStun, true, {
                Duration = 3
            });
            Cam_Shaker(HumanoidRootPart.Position, "activate_shake");

            return;
        end;

        if p3 ~= "FinalHit" then
            if v8 ~= nil then
                v8:Destroy();
            end;

            return;
        end;

        local v25 = script.NewAssets["AOE(Emit)"]:Clone();
        v25:PivotTo(HumanoidRootPart.CFrame * CFrame.new(0, -3, 0));
        v25.Parent = workspace.Debree;
        Ouwmit.Emit(v25);
        DebrisModule:AddItem(v25, 3);
        local v26 = workspace.Debree:FindFirstChild(v7 .. " - TP CONTENT");

        if v26 ~= nil then
            v26.Name = "--";
            Ouwmit.Enable(v26, false);
        end;

        local v27 = workspace:Raycast(HumanoidRootPart.Position, HumanoidRootPart.CFrame.upVector * -25, RaycastHelper.Crater);
        local v28;

        if v27 == nil or v27.Instance == nil then
            v28 = nil;
        else
            local v29 = CFrame.new(v27.Position, v27.Position + v27.Normal) * CFrame.Angles(-1.5707963267948966, 0, 0) * CFrame.new(0, 0.25, 0);
            v25.GroundFX.CFrame = v29;
            v25.Startup.CFrame = v29;
            v28 = v27.Instance.Color;
        end;

        Ouwmit.Emit(v25, v28 ~= nil and ({
            Color = v28,
            ColorWhitelist = { "raycastdust", "Rocks", "Dust" }
        } or nil) or nil);
        Cam_Shaker(HumanoidRootPart.Position, "medium_shake_preset");
        OuwCraters.Scales({
            Duration = 1,
            Count = 12,
            Radius = 20,
            ScaleMult = 3,
            Center = HumanoidRootPart.CFrame
        });

        if p2 == game.Players.LocalPlayer.Character or vector.magnitude(HumanoidRootPart.Position - workspace.CurrentCamera.CFrame.Position) < 30 then
            LTN();
        end;

        local v30 = script.Sounds.Explode:Clone();
        v30.Parent = v25.Startup;
        v30:Play();

        return;
    end;

    if v8 ~= nil then
        v8:Destroy();
    end;

    local Folder = Instance.new("Folder");
    Folder.Name = v7;
    Folder.Parent = workspace.Debree;
    DebrisModule:AddItem(Folder, 7);
    local v31 = script.NewAssets.YellowHighlight:Clone();
    v31.Parent = Folder;
    TweenService:Create(v31, TweenInfo.new(0.5), {
        FillTransparency = 1.35,
        OutlineTransparency = 0
    }):Play();
    v31.Name = "CasterHighlight";
    v31.Adornee = p2;
    local v32 = script.NewAssets.OrbRiceSpirit:Clone();
    v32:PivotTo(HumanoidRootPart.CFrame * CFrame.new(0, -2.6, 0));
    local v33 = tonumber(p4);

    if v33 ~= nil and v33 > 1 then
        v32:ScaleTo((math.min(v33, 3.5)));
    end;

    v32.Parent = Folder;
    local v34 = script.Sounds.Initiate:Clone();
    v34.Parent = v32.GroundVFX;
    v34:Play();
    local v35 = script.Sounds.LoopedThunder:Clone();
    v35.Parent = v32.GroundVFX;
    v35:Play();
    local v36 = workspace:Raycast(HumanoidRootPart.Position, HumanoidRootPart.CFrame.upVector * -30, RaycastHelper.Crater);
    local v37;

    if v36 == nil or v36.Instance == nil then
        v37 = nil;
    else
        local v38 = CFrame.new(v36.Position, v36.Position + v36.Normal) * CFrame.Angles(-1.5707963267948966, 0, 0) * CFrame.new(0, 1, 0);
        v32.Beams:PivotTo(v38);
        v32.GroundVFX.CFrame = v38;
        v37 = v36.Instance.Color;
    end;

    Ouwmit.Enable(v32, nil, v37 ~= nil and ({
        Color = v37,
        ColorWhitelist = { "raycastdust", "Rocks" }
    } or nil) or nil);
    local Pivot = v32.Beams:GetPivot();
    local CFrame2 = v32.GroundVFX.CFrame;
    local v39 = Cam_Shaker(HumanoidRootPart, {
        FadeInTime = 0,
        Frequency = 0.07,
        Amplitude = 0.25,
        SustainTime = 5,
        FadeOutTime = 0.2,
        RotationInfluence = Vector3.new(0.1, 0.1, 0.1),
        PositionInfluence = Vector3.new(0.5, 0.5, 0.5)
    });
    local v40;

    if v33 == nil or v33 <= 1 then
        v40 = 0.05;
    else
        v40 = 0.2;
    end;

    while Folder ~= nil and (Folder.Name ~= "--" and Folder.Parent ~= nil) do
        local Scale = v32:GetScale();

        if Scale < 3.5 then
            v32:ScaleTo(Scale + v40);
            v32.Beams:PivotTo(Pivot);
            v32.GroundVFX.CFrame = CFrame2;
            local PointLight = v32.GroundVFX.PointLight;
            PointLight.Range = PointLight.Range + 0.1;
        end;

        task.wait(0.1);
    end;

    TweenService:Create(v35, TweenInfo.new(0.5), {
        Volume = 0
    }):Play();
    v39:Destroy();
end;