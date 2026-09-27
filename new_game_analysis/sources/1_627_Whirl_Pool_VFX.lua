-- Decompiled with Potassium's decompiler.

game:GetService("Players");
local TweenService = game:GetService("TweenService");
game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ReplicatedStorage2 = game:GetService("ReplicatedStorage");
local CAM = ReplicatedStorage.CAM;
local Modules = CAM.Client.Modules;
local u1 = workspace.Debree:FindFirstChild(game.Players.LocalPlayer.Name .. "\'s effects debree thing213asdasdasdasd");

if u1 == nil then
    u1 = Instance.new("Folder", workspace.Debree);
    u1.Name = game.Players.LocalPlayer.Name .. "\'s effects debree thing213asdasdasdasd";
end;

local Assets = script:FindFirstChild("Assets");
local Sounds = script:FindFirstChild("Sounds");
local DebrisModule = require(CAM.DebrisModule);
local Cam_Shaker = require(Modules.Effects.Cam_Shaker);
require(Modules.Effects.Craters.CraterHandler);
require(Modules.Effects.BoatTween);
local OuwCraters = require(ReplicatedStorage2.CAM.Client.Modules.Effects.Craters.OuwCraters);
local vfxUtility = require(game.ReplicatedStorage.CAM.Client.Modules.Effects.vfxUtility);
local _ = game.Players.LocalPlayer;
local workspace_CurrentCamera = workspace.CurrentCamera;

local function SwordTrail(p2: userdata, p3: boolean) -- Line: 44
    -- upvalues: vfxUtility (copy)
    local Has_Blade = p2:FindFirstChild("Has_Blade", true);
    local v4;

    if Has_Blade == nil or Has_Blade.Parent == nil then
        v4 = nil;
    else
        v4 = Has_Blade.Parent:FindFirstChild("Blade");
    end;

    if v4 == nil then
        return;
    end;

    if p3 == true or p3 == nil then
        local u5 = {};

        for _, child in pairs(script.Parent.SwordTrail:GetChildren()) do
            local v6 = child:Clone();
            v6.Name = "bladetfftians##asd";
            v6.Parent = v4;
            table.insert(u5, v6);

            if v6:IsA("Trail") then
                v6.Attachment0 = v4:FindFirstChild("Sword_At_A");
                v6.Attachment1 = v4:FindFirstChild("Sword_At_B");
            end;
        end;

        if u5 ~= nil and u5[1] ~= nil then
            task.delay(5, function() -- Line: 64
                -- upvalues: u5 (copy)
                if u5[1].Name ~= "--" then
                    for _, v in ipairs(u5) do
                        v:Destroy();
                    end;
                end;
            end);
        end;
    else
        local u7 = {};

        for _, child in pairs(v4:GetChildren()) do
            if child.Name == "bladetfftians##asd" then
                child.Name = "--";
                table.insert(u7, child);
            end;
        end;

        if #u7 > 0 then
            task.delay(0.35, function() -- Line: 81
                -- upvalues: u7 (copy)
                if u7 ~= nil then
                    for _, v in pairs(u7) do
                        v.Enabled = false;
                    end;
                end;

                task.wait(1);

                for _, v in ipairs(u7) do
                    v:Destroy();
                end;
            end);
        end;
    end;

    vfxUtility.EnableAll(v4, p3 or p3 == nil);
end;

return function(u8: userdata, p9: any, p10: any, p11) -- Line: 97
    -- upvalues: workspace_CurrentCamera (copy), Assets (copy), u1 (ref), vfxUtility (copy), DebrisModule (copy), Sounds (copy), TweenService (copy), SwordTrail (copy), Cam_Shaker (copy), OuwCraters (copy)
    local v12 = u8:FindFirstChild("HumanoidRootPart") or u8.PrimaryPart;
    local UpperTorso = u8:FindFirstChild("UpperTorso");

    if v12 == nil or UpperTorso == nil then
        return;
    end;

    if p9 ~= "Cancel" and (v12.Position - workspace_CurrentCamera.CFrame.Position).Magnitude > 250 then
        return;
    end;

    if p9 == "Start" then
        local v13 = Assets.Startup:Clone();
        v13.Parent = u1;
        v13.CFrame = v12.CFrame;
        vfxUtility.EmitAll(v13:GetDescendants());
        DebrisModule:AddItem(v13, 2);
        vfxUtility.PlaySound(Sounds, "Hold", v12, true);
        local v14 = Assets.StartHighlight:Clone();
        v14.Parent = u8;
        TweenService:Create(v14, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            OutlineTransparency = 1,
            FillTransparency = 1
        }):Play();
        DebrisModule:AddItem(v14, 2);
        SwordTrail(u8);

        return;
    end;

    if p9 == "Release" then
        local v15 = Assets.WhirlPoolVFX:Clone();
        v15:PivotTo(v12.CFrame);
        v15.Parent = u1;
        DebrisModule:AddItem(v15, 2);
        vfxUtility.EmitAll(v15.JumpVFX);
        vfxUtility.EmitAll(v15.BeamParticlesEmit);
        vfxUtility.TweenLight(v15, {
            Time = 0.2,
            Del = 0.1,
            DelayTimer = 0.455
        });
        vfxUtility.PlaySound(Sounds, "Release", v12, true);
        task.delay(0.455, function() -- Line: 140
            -- upvalues: SwordTrail (ref), u8 (copy)
            SwordTrail(u8, false);
        end);
        Cam_Shaker(v15.Root.Position, "medium_shake_preset");
        TweenService:Create(v15.SlashBeam, TweenInfo.new(0.9, Enum.EasingStyle.Sine), {
            Orientation = v15.SlashBeam.Orientation + Vector3.new(0, 350, 0)
        }):Play();

        for _, descendant in v15:GetDescendants() do
            if descendant:IsA("Beam") then
                descendant.Enabled = true;
                local Width0 = descendant.Width0;
                local Width1 = descendant.Width1;
                local TextureLength = descendant.TextureLength;
                descendant.Width0 = 0;
                descendant.Width1 = 0;
                local v16 = TweenService:Create(descendant, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
                    Width0 = Width0 + 5,
                    Width1 = Width1 + 5
                });
                v16:Play();
                v16.Completed:Connect(function() -- Line: 158
                    -- upvalues: TweenService (ref), descendant (copy), TextureLength (copy)
                    TweenService:Create(descendant, TweenInfo.new(0.325, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
                        Width0 = 0,
                        Width1 = 0,
                        TextureLength = TextureLength / 3
                    }):Play();
                end);
            end;
        end;

        local Meshes = v15.Meshes;
        TweenService:Create(Meshes.Swirl, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
            Orientation = Meshes.Swirl.Orientation + Vector3.new(0, 350, 0)
        }):Play();
        TweenService:Create(Meshes.Swirl, TweenInfo.new(0.755, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = Meshes.SwirlEnd.Size,
            Position = Meshes.SwirlEnd.Position
        }):Play();
        task.delay(0.1, function() -- Line: 178
            -- upvalues: TweenService (ref), Meshes (copy)
            TweenService:Create(Meshes.Swirl, TweenInfo.new(0.455, Enum.EasingStyle.Sine), {
                Transparency = 1
            }):Play();
        end);

        return;
    end;

    if p9 ~= "Basin Start" then
        if p9 == "Basin Slam" then
            OuwCraters.Scales({
                ScaleMult = 1.15,
                Count = 8,
                Duration = 1.5,
                TweenInInfo = TweenInfo.new(0.25),
                Center = v12.CFrame * CFrame.new(0, 0, -10)
            });
            local v17 = p11 * CFrame.new(0, 0, 13);
            local v18 = Assets.WaterFallBasinEnabling:Clone();
            v18:PivotTo(v17);
            v18.Parent = u1;
            vfxUtility.EnableAll(v18, true, 0.3);
            DebrisModule:AddItem(v18, 3);
            local v19 = Assets.WaterFallBasinEmit:Clone();
            v19:PivotTo(v17);
            v19.Parent = u1;
            vfxUtility.EmitAll(v19);
            DebrisModule:AddItem(v19, 3);
            vfxUtility.PlaySound(Sounds, "PS2WBwaterbasinBASIN" .. p10, v19.PrimaryPart, true);
            vfxUtility.TweenBeams(v19, {
                Time = 0.2,
                Del = 0.2,
                DelayTimer = 0.25
            });
            vfxUtility.TweenLight(v19, {
                Time = 1.5,
                Del = 0.35
            });
            Cam_Shaker(v12.Position, "Medium_tiny_shake_preset");

            if p10 == 2 then
                SwordTrail(u8, false);

                return;
            end;
        elseif p9 == "Cancel" then
            SwordTrail(u8, false);
        end;

        return;
    end;

    local v20 = Assets.WAterFallBasinStartup:Clone();
    v20:PivotTo(v12.CFrame);
    v20.Parent = u1;
    vfxUtility.EmitAll(v20);
    DebrisModule:AddItem(v20, 2);
    vfxUtility.PlaySound(Sounds, "PS2WBwaterbasinSTARTSWING", v20.PrimaryPart, true);
    local SerializedMeshAnim = v20.SwirlEffect.SerializedMeshAnim;
    local SerializedMeshAnim2 = v20.Shockwave.SerializedMeshAnim;
    local PointLight = v20.Startup.PointLight;
    PointLight.Brightness = 6;
    PointLight.Range = 3;
    vfxUtility.EmitAll(v20.Startup);
    TweenService:Create(SerializedMeshAnim, TweenInfo.new(0.755, Enum.EasingStyle.Quad), {
        Size = SerializedMeshAnim:GetAttribute("EndPartSize"),
        Position = SerializedMeshAnim.Position + SerializedMeshAnim:GetAttribute("CFrameDiff").Position
    }):Play();
    TweenService:Create(SerializedMeshAnim, TweenInfo.new(1.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Orientation = SerializedMeshAnim.Orientation + Vector3.new(0, 550, 0)
    }):Play();
    TweenService:Create(SerializedMeshAnim2, TweenInfo.new(0.7, Enum.EasingStyle.Sine), {
        Size = SerializedMeshAnim2:GetAttribute("EndPartSize"),
        Position = SerializedMeshAnim2.Position + SerializedMeshAnim2:GetAttribute("CFrameDiff").Position
    }):Play();
    TweenService:Create(SerializedMeshAnim2, TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Orientation = SerializedMeshAnim2.Orientation + Vector3.new(0, 550, 0)
    }):Play();
    task.delay(0.1, function() -- Line: 217
        -- upvalues: TweenService (ref), SerializedMeshAnim (copy), SerializedMeshAnim2 (copy), PointLight (copy)
        TweenService:Create(SerializedMeshAnim, TweenInfo.new(0.755, Enum.EasingStyle.Quint), {
            Transparency = 1
        }):Play();
        TweenService:Create(SerializedMeshAnim2, TweenInfo.new(0.655, Enum.EasingStyle.Quint), {
            Transparency = 1
        }):Play();
        TweenService:Create(PointLight, TweenInfo.new(1, Enum.EasingStyle.Linear), {
            Brightness = 0,
            Range = 25
        }):Play();
    end);
    Cam_Shaker(v12.Position, "tinyshake_preset");
end;