-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local DebrisModule = require(ReplicatedStorage.CAM.DebrisModule);
local vfxUtility = require(ReplicatedStorage.CAM.Client.Modules.Effects.vfxUtility);
local Ouwmit = require(ReplicatedStorage.CAM.Client.Modules.Effects.Ouwmit);
local Config = require(ReplicatedStorage.Skills["Water Breathing"]["Water Wheel"].Config);

local function SwordTrail(p1: userdata, p2: boolean) -- Line: 7
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
            task.delay(5, function() -- Line: 27
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
            task.delay(0.35, function() -- Line: 44
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

local TweenService = game:GetService("TweenService");
local Cam_Shaker = require(ReplicatedStorage.CAM.Client.Modules.Effects.Cam_Shaker);
local RaycastHelper = require(ReplicatedStorage.CAM.Global.RaycastHelper);

function CreateSlash(p7: userdata, p8: userdata, p9: string, p10: any, p11: any)
    -- upvalues: DebrisModule (copy), Cam_Shaker (copy), RaycastHelper (copy), vfxUtility (copy), TweenService (copy)
    local RootPart = p7.Humanoid.RootPart;
    local CFrame2 = RootPart.CFrame;
    local v12 = script.Assets:FindFirstChild(p9):Clone();
    v12:PivotTo(CFrame2);
    v12.Parent = p8;
    DebrisModule:AddItem(v12, 1);
    Cam_Shaker(CFrame2.Position, "activate_shake");
    local v13 = nil;
    local v14 = workspace:Raycast(CFrame2.Position, CFrame2.UpVector * -15, RaycastHelper.Crater);

    if v14 == nil or v14.Instance == nil then
        v12[p9].Ground:Destroy();
    else
        v13 = v14.Instance.Color;
        v12[p9].Ground.WorldCFrame = CFrame.new(v14.Position, v14.Position + v14.Normal) * CFrame.Angles(-1.5707963267948966, 0, 0);
    end;

    vfxUtility.EmitAll(v12, v13 ~= nil and ({
        ColorWhitelist = "Ground",
        Color = v13
    } or nil) or nil);
    local SerializedMeshAnim = v12.SlashBeams.SerializedMeshAnim;
    TweenService:Create(SerializedMeshAnim, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {
        CFrame = SerializedMeshAnim.CFrame * SerializedMeshAnim:GetAttribute("CFrameDiff")
    }):Play();

    for _, descendant in pairs(v12:GetDescendants()) do
        if descendant:IsA("Beam") then
            descendant.Enabled = true;
            TweenService:Create(descendant, TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
                TextureLength = 0.1,
                Width0 = 0,
                Width1 = 0
            }):Play();
        end;
    end;

    Cam_Shaker(RootPart, "punch_shake");

    if p11 then
        vfxUtility.PlaySound(script.Sounds, "PS2WBwaterwheelHOLDslash" .. p11, RootPart, true);
    end;
end;

local OuwCraters = require(ReplicatedStorage.CAM.Client.Modules.Effects.Craters.OuwCraters);
local CraterHandler = require(ReplicatedStorage.CAM.Client.Modules.Effects.Craters.CraterHandler);

function ClearWheel(p15)
    -- upvalues: vfxUtility (copy), DebrisModule (copy)
    local v16 = workspace.Debree:FindFirstChild(p15);

    if v16 ~= nil then
        v16.Name = "--";
        vfxUtility.EnableAll(v16, false);
        DebrisModule:AddItem(v16, 1.5);
    end;
end;

return function(p17: userdata, p18: string, ...) -- Line: 113
    -- upvalues: vfxUtility (copy), DebrisModule (copy), TweenService (copy), SwordTrail (copy), Config (copy), Cam_Shaker (copy), Ouwmit (copy), OuwCraters (copy), CraterHandler (copy), RaycastHelper (copy)
    if p17:FindFirstChild("Humanoid") == nil or p17:FindFirstChild("HumanoidRootPart") == nil then
        return;
    end;

    local HumanoidRootPart = p17.HumanoidRootPart;
    local v19 = `{script.Name}-{p17.Name}-WaterWheelWheel`;

    if vector.magnitude(workspace.CurrentCamera.CFrame.Position - p17.HumanoidRootPart.Position) > 250 and p18 ~= "Cancel" then
        return;
    end;

    if p18 ~= "Startup" then
        if p18 == "Cancel" then
            ClearWheel(v19);
            SwordTrail(p17, false);

            return;
        end;

        if p18 == "CreateSlash" then
            CreateSlash(p17, workspace.Debree, ...);

            return;
        end;

        if p18 == "Tap" then
            local RootPart = p17.Humanoid.RootPart;
            ClearWheel(v19);
            local Folder = Instance.new("Folder", workspace.Debree);
            Folder.Name = v19;
            DebrisModule:AddItem(Folder, Config.TAP_ROLL_VFX_DUR + 2.5);
            Cam_Shaker(RootPart, {
                FadeInTime = 0,
                Frequency = 0.3,
                Amplitude = 0.35,
                SustainTime = 0.4,
                FadeOutTime = 0.3,
                RotationInfluence = Vector3.new(0.1, 0.1, 0.1),
                PositionInfluence = Vector3.new(0.5, 0.5, 0.5)
            });
            local v20 = script.Assets.WaterWheelFXTap:Clone();
            local Weld = Instance.new("Weld", v20.Root);
            Weld.Part0 = RootPart;
            Weld.Part1 = v20.Root;
            Weld.Parent = v20;
            v20.Parent = Folder;
            local os_clock_ret = os.clock();
            local v21 = vfxUtility.PlaySound(script.Sounds, "PS2WBwaterwheelLOOP", v20.Root);

            while Folder.Parent ~= nil and (Folder.Name ~= "--" and os.clock() - os_clock_ret <= Config.TAP_ROLL_VFX_DUR) do
                task.wait();
            end;

            if v21 ~= nil then
                TweenService:Create(v21, TweenInfo.new(1), {
                    Volume = 1
                }):Play();
                DebrisModule:AddItem(v21, 1);
            end;

            Ouwmit.Enable(v20, false);
            SwordTrail(p17, false);

            if RootPart == nil or RootPart.Parent == nil then
                return;
            end;

            if Folder == nil or Folder.Name == "--" then
                return;
            end;

            local CFrame2 = RootPart.CFrame;
            local v22 = CFrame2 * CFrame.new(0, 0, -8);
            OuwCraters.Scales({
                Count = 7,
                Radius = 6.5,
                Center = v22.Position
            });
            local v23 = script.Assets.WaterWheelLasthit:Clone();
            v23.CFrame = CFrame2 * CFrame.new(0, -2.5, -3);
            v23.Parent = Folder;
            Ouwmit.Emit(v23);
            CraterHandler.new("Break", v22 * CFrame.new(0, 5, 0), {
                PartCount = 10,
                Range = 30,
                Radius = 10,
                HoldTime = 1.5,
                BlockSize = { 0.5, 1.5 },
                Height = { 30, 60 }
            });
            vfxUtility.PlaySound(script.Sounds, "PS2WBwaterwheelHOLDfinalslash", RootPart, true);
            Cam_Shaker(CFrame2.Position, "Medium_tiny_shake_preset");
            local v24 = workspace:Raycast((CFrame2 * CFrame.new(0, 0, -10)).Position, CFrame2.UpVector * -5, RaycastHelper.Crater);

            if v24 ~= nil and v24.Instance ~= nil then
                local v25 = script.Assets.WaterWheelGround:Clone();
                v25.CFrame = CFrame.new(v24.Position, v24.Position + v24.Normal) * CFrame.Angles(-1.5707963267948966, 0, 0);
                v25.Parent = Folder;
                Ouwmit.Emit(v25, {
                    Color = v24.Instance.Color,
                    ColorWhitelist = { "Smoke", "Smoke2" }
                });

                return;
            end;
        else
            if p18 == "Wheel" then
                ClearWheel(v19);
                local Folder = Instance.new("Folder", workspace.Debree);
                Folder.Name = v19;
                DebrisModule:AddItem(Folder, 3);
                local RootPart = p17.Humanoid.RootPart;
                local CFrame2 = RootPart.CFrame;
                local v26 = vfxUtility.PlaySound(script.Sounds, "PS2WBwaterwheelLOOP", RootPart);
                local v27 = script.Assets.WaterWheelFX:Clone();
                v27:PivotTo(CFrame2);
                v27.Parent = Folder;
                local v28 = workspace:Raycast(CFrame2.Position, CFrame2.UpVector * -5, RaycastHelper.Crater);
                local v29 = nil;

                if v28 == nil or v28.Instance == nil then
                    v27.GroundVFX.SmokeCast:Destroy();
                    v27.GroundVFX.GroundHitFX:Destroy();
                    v27.GroundVFX.Crack:Destroy();
                    v27.GroundVFX.Sparks:Destroy();
                else
                    v29 = v28.Instance.Color;
                    v27.GroundVFX.Position = v28.Position;
                end;

                vfxUtility.WeldConstraint(v27.PrimaryPart, RootPart);
                DebrisModule:AddItem(v27, 4);
                Ouwmit.Enable(v27, true, v29 ~= nil and ({
                    ColorWhitelist = "SmokeCast",
                    ColorBlacklist = "NoColorTing",
                    Color = v29
                } or nil) or nil);
                vfxUtility.TweenLight(v27, {
                    Time = 0.125,
                    Del = 0.225,
                    DelayTimer = 1.2
                });

                for _, descendant in v27.WheelVFX:GetDescendants() do
                    if descendant:IsA("Beam") then
                        descendant.Enabled = true;
                        local Width0 = descendant.Width0;
                        local Width1 = descendant.Width1;
                        descendant.Width0 = 0;
                        descendant.Width1 = 0;
                        TweenService:Create(descendant, TweenInfo.new(0.2), {
                            Width0 = Width0,
                            Width1 = Width1
                        }):Play();
                        task.delay(0.7, function() -- Line: 263
                            -- upvalues: descendant (copy), TweenService (ref)
                            if descendant.Name == "AnimeWind" then
                                TweenService:Create(descendant, TweenInfo.new(0.755), {
                                    Width0 = 0,
                                    Width1 = 0
                                }):Play();

                                return;
                            end;

                            TweenService:Create(descendant, TweenInfo.new(0.155), {
                                Width0 = 0,
                                Width1 = 0
                            }):Play();
                        end);
                    end;
                end;

                local v30 = Cam_Shaker(RootPart, {
                    FadeInTime = 0,
                    Frequency = 0.3,
                    Amplitude = 0.35,
                    SustainTime = 0.4,
                    FadeOutTime = 0.3,
                    RotationInfluence = Vector3.new(0.1, 0.1, 0.1),
                    PositionInfluence = Vector3.new(0.5, 0.5, 0.5)
                });
                local os_clock_ret = os.clock();

                while Folder.Parent ~= nil and (Folder.Name ~= "--" and os.clock() - os_clock_ret <= 0.6) do
                    task.wait();
                end;

                if v30 ~= nil then
                    v30:Destroy();
                end;

                if v26 then
                    v26:Destroy();
                end;

                if Folder.Parent ~= nil and Folder.Name ~= "--" then
                    vfxUtility.PlaySound(script.Sounds, "PS2WBwaterwheelSTOP", RootPart, true);
                end;

                vfxUtility.EnableAll(v27, false);

                return;
            end;

            if p18 == "MiddleSlash" then
                local RootPart = p17.Humanoid.RootPart;
                local CFrame2 = RootPart.CFrame;
                local v31 = script.Assets.MiddleSlash:Clone();
                v31:PivotTo(CFrame2);
                local v32 = workspace:Raycast(CFrame2.Position, CFrame2.UpVector * -10, RaycastHelper.Crater);
                local v33 = nil;

                if v32 == nil or v32.Instance == nil then
                    v31.SlashVFX.GroundRaycasting.Ground:Destroy();
                else
                    v33 = v32.Instance.Color;
                    local Position = v31.SlashVFX.GroundRaycasting.Ground.Position;
                    v31.SlashVFX.GroundRaycasting.Ground.Position = vector.create(Position.X, v32.Position.Y, Position.Z);
                end;

                v31.Parent = workspace.Debree;
                DebrisModule:AddItem(v31, 3);
                vfxUtility.EmitAll(v31.SlashVFX, v33 ~= nil and ({
                    Color = v33,
                    ColorWhitelist = { "Smoke", "Smoke2" }
                } or nil) or nil);
                vfxUtility.TweenBeams(v31.SlashBeams.SerializedMeshAnim, {
                    Time = 0.3,
                    Del = 0.3
                });
                Cam_Shaker(RootPart.Position, "medium_shake_preset");
                local v34 = CFrame2 * CFrame.new(0, 0, -8);
                OuwCraters.Scales({
                    Count = 7,
                    Radius = 6.5,
                    Center = v34.Position
                });
                CraterHandler.new("Break", v34 * CFrame.new(0, 5, 0), {
                    PartCount = 10,
                    Range = 30,
                    Radius = 10,
                    HoldTime = 1.5,
                    BlockSize = { 0.5, 1.5 },
                    Height = { 30, 60 }
                });
                local v35 = v31.SlashBeams.SerializedMeshAnim.CFrame * v31.SlashBeams.SerializedMeshAnim:GetAttribute("CFrameDiff");
                local WindyMeshy = v31.SlashVFX.GroundRaycasting.WindyMeshy;
                local v36 = WindyMeshy.SerializedMeshAnim.CFrame * WindyMeshy.SerializedMeshAnim:GetAttribute("CFrameDiff");
                local SerializedMeshAnim = v31.SlashVFX.GroundRaycasting.SwirlEffect.SerializedMeshAnim;
                local Attribute = SerializedMeshAnim:GetAttribute("EndPartSize");
                local v37 = SerializedMeshAnim.CFrame * SerializedMeshAnim:GetAttribute("CFrameDiff");
                TweenService:Create(v31.SlashBeams.SerializedMeshAnim, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {
                    CFrame = v35
                }):Play();
                TweenService:Create(WindyMeshy.SerializedMeshAnim, TweenInfo.new(2, Enum.EasingStyle.Quad), {
                    Position = v36.Position
                }):Play();
                TweenService:Create(WindyMeshy.SerializedMeshAnim.Mesh, TweenInfo.new(2, Enum.EasingStyle.Quad), {
                    Scale = Vector3.new(0.619, 0.56, 0.541)
                }):Play();
                TweenService:Create(WindyMeshy.SerializedMeshAnim, TweenInfo.new(2.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
                    Orientation = WindyMeshy.SerializedMeshAnim.Orientation + Vector3.new(0, -300, 0)
                }):Play();
                TweenService:Create(SerializedMeshAnim, TweenInfo.new(2, Enum.EasingStyle.Quad), {
                    Size = Attribute,
                    Position = v37.Position
                }):Play();
                TweenService:Create(SerializedMeshAnim, TweenInfo.new(2.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Orientation = SerializedMeshAnim.Orientation + Vector3.new(0, -300, 0)
                }):Play();
                TweenService:Create(SerializedMeshAnim, TweenInfo.new(2, Enum.EasingStyle.Quint), {
                    Transparency = 1
                }):Play();
                vfxUtility.PlaySound(script.Sounds, "PS2WBwaterwheelHOLDfinalslash", RootPart, true);
                Cam_Shaker(RootPart, "punch_shake");
                SwordTrail(p17, false);
            end;
        end;

        return;
    end;

    local v38 = script.Assets.Startup:Clone();
    v38.Parent = workspace.Debree;
    v38.CFrame = HumanoidRootPart.CFrame;
    vfxUtility.EmitAll(v38:GetDescendants());
    DebrisModule:AddItem(v38, 2);
    vfxUtility.PlaySound(script.Sounds, "PS2WBwaterwheelSTART", HumanoidRootPart, true);
    local v39 = script.Assets.StartHighlight:Clone();
    v39.Parent = p17;
    TweenService:Create(v39, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        OutlineTransparency = 1,
        FillTransparency = 1
    }):Play();
    DebrisModule:AddItem(v39, 2);
    SwordTrail(p17);
end;