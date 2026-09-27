-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
game:GetService("RunService");
game:GetService("ReplicatedStorage");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CAM = ReplicatedStorage.CAM;
local Modules = CAM.Client.Modules;
local LocalPlayer = Players.LocalPlayer;
local Assets = script:FindFirstChild("Assets");
local workspace_Debree = workspace.Debree;
local Sounds = script:FindFirstChild("Sounds");
local vfxUtility = require(game.ReplicatedStorage.CAM.Client.Modules.Effects.vfxUtility);
local DebrisModule = require(game.ReplicatedStorage.CAM.DebrisModule);
local ImpactFrames = require(CAM.Client.Modules.Effects.ImpactFrames);
require(Modules.Effects.BoatTween);
local _ = game.Players.LocalPlayer;
local _ = workspace.CurrentCamera;

local function Random_Number(p1, p2) -- Line: 34
    return Random.new():NextNumber(p1, p2);
end;

local Ouwmit = require(ReplicatedStorage.CAM.Client.Modules.Effects.Ouwmit);
local RaycastHelper = require(ReplicatedStorage.CAM.Global.RaycastHelper);
local Cam_Shaker = require(ReplicatedStorage.CAM.Client.Modules.Effects.Cam_Shaker);
local OuwCraters = require(ReplicatedStorage.CAM.Client.Modules.Effects.Craters.OuwCraters);
local TweenInfo_new_ret = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0);
local TweenInfo_new_ret2 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0);

local function LTN() -- Line: 44
    -- upvalues: TweenService (copy), TweenInfo_new_ret (copy), TweenInfo_new_ret2 (copy), DebrisModule (copy)
    local v3 = script.Assets.ColorCorrection:Clone();
    v3.Parent = workspace.Camera;
    TweenService:Create(v3, TweenInfo_new_ret, {
        TintColor = Color3.fromRGB(255, 255, 255)
    }):Play();
    TweenService:Create(v3, TweenInfo_new_ret2, {
        Brightness = 0,
        Contrast = 0,
        Saturation = 0
    }):Play();
    DebrisModule:AddItem(v3, 0.2);
end;

return function(p4: userdata, p5: any, p6: table) -- Line: 51
    -- upvalues: DebrisModule (copy), TweenService (copy), vfxUtility (copy), Sounds (copy), RaycastHelper (copy), Ouwmit (copy), OuwCraters (copy), Cam_Shaker (copy), LTN (copy), LocalPlayer (copy), Assets (copy), workspace_Debree (copy), ImpactFrames (copy)
    local HumanoidRootPart = p4:FindFirstChild("HumanoidRootPart");
    local LeftFoot = p4:FindFirstChild("LeftFoot");
    local RightFoot = p4:FindFirstChild("RightFoot");

    if not HumanoidRootPart then
        return;
    end;

    if not LeftFoot then
        return;
    end;

    if not RightFoot then
        return;
    end;

    if (HumanoidRootPart.Position - workspace.CurrentCamera.CFrame.Position).Magnitude > 250 then
        return;
    end;

    if p5 ~= "Start" then
        if p5 == "Attempt" then
            local v7 = script.Assets.MissEmit:Clone();
            v7:PivotTo(HumanoidRootPart.CFrame * CFrame.new(0, -2, 0));
            v7.Parent = workspace.Debree;
            DebrisModule:AddItem(v7, 2);
            vfxUtility.PlaySound(Sounds, "PS2flyingthundergodFAILwithlessimpact", HumanoidRootPart, true);
            local v8 = workspace:Raycast(HumanoidRootPart.Position, HumanoidRootPart.CFrame.upVector * -30, RaycastHelper.Crater);
            local v9;

            if v8 == nil or v8.Instance == nil then
                v9 = nil;
            else
                local _ = CFrame.new(v8.Position, v8.Position + v8.Normal) * CFrame.Angles(-1.5707963267948966, 0, 0) * CFrame.new(0, 1, 0);
                v9 = v8.Instance.Color;
            end;

            Ouwmit.Emit(v7, v9 ~= nil and ({
                Color = v9,
                ColorWhitelist = { "raycastdust", "Rocks", "Dust" }
            } or nil) or nil);
            OuwCraters.Scales({
                Duration = 2,
                Count = 6,
                ScaleMult = 0.65,
                Radius = 8,
                Center = HumanoidRootPart.CFrame
            });
            Cam_Shaker(HumanoidRootPart.Position, "tinyshake_preset");

            if p4 == game.Players.LocalPlayer.Character or vector.magnitude(workspace.CurrentCamera.CFrame.Position - HumanoidRootPart.Position) < 30 then
                LTN();

                return;
            end;
        elseif p5 == "Cutscene" then
            local v10 = p6 or {};
            table.insert(p6, p4);
            local v11 = LocalPlayer.Character and table.find(v10, LocalPlayer.Character);
            local v12;

            if v11 then
                v12 = workspace.CurrentCamera or HumanoidRootPart;
            else
                v12 = HumanoidRootPart;
            end;

            vfxUtility.PlaySound(Sounds, "PS2thunderbreathULT", v12, true);
            local v13 = Assets.FlamingThundergod:Clone();
            v13:PivotTo(HumanoidRootPart.CFrame);
            v13.Parent = workspace_Debree;
            vfxUtility.EmitAll(v13);
            DebrisModule:AddItem(v13, 8);

            for _, descendant in v13:GetDescendants() do
                if descendant:IsA("Beam") and (descendant:GetAttribute("EmitDuration") and descendant:GetAttribute("EmitDuration") ~= 0) then
                    if descendant:GetAttribute("EmitDelay") and descendant:GetAttribute("EmitDelay") ~= 0 then
                        task.delay(descendant:GetAttribute("EmitDelay"), function() -- Line: 139
                            -- upvalues: descendant (copy)
                            descendant.Enabled = true;
                            task.delay(descendant:GetAttribute("EmitDuration"), function() -- Line: 141
                                -- upvalues: descendant (ref)
                                if descendant == nil then
                                    return;
                                end;

                                descendant.Enabled = false;
                            end);
                        end);
                    else
                        descendant.Enabled = true;
                        task.delay(descendant:GetAttribute("EmitDuration"), function() -- Line: 149
                            -- upvalues: descendant (copy)
                            if descendant == nil then
                                return;
                            end;

                            descendant.Enabled = false;
                        end);
                    end;
                end;
            end;

            for _, v in { RightFoot, LeftFoot } do
                local v14 = Assets.Part.Trail:Clone();
                v14.Parent = v;
                DebrisModule:AddItem(v14, 9.5);

                for _, descendant in v14:GetDescendants() do
                    if descendant:IsA("Trail") and (descendant:GetAttribute("EmitDelay") and descendant:GetAttribute("EmitDelay") ~= 0) then
                        task.delay(descendant:GetAttribute("EmitDelay"), function() -- Line: 166
                            -- upvalues: descendant (copy)
                            descendant.Enabled = true;
                            task.delay(descendant:GetAttribute("EmitDuration"), function() -- Line: 168
                                -- upvalues: descendant (ref)
                                if descendant == nil then
                                    return;
                                end;

                                descendant.Enabled = false;
                            end);
                        end);
                    end;
                end;
            end;

            if v11 then
                local CFrame2 = HumanoidRootPart.CFrame;
                local Position = CFrame2.Position;
                task.delay(0.32, function() -- Line: 182
                    -- upvalues: Cam_Shaker (ref), Position (copy), LTN (ref), OuwCraters (ref), CFrame2 (copy)
                    Cam_Shaker(Position, "activate_shake");
                    task.wait(0.69);
                    LTN();
                    task.wait(0.10000000000000009);
                    LTN();
                    task.wait(0.05);
                    LTN();
                    task.wait(0.05);
                    task.wait(1.6099999999999999);
                    OuwCraters.Scales({
                        Duration = 2,
                        Count = 6,
                        ScaleMult = 1,
                        Radius = 6,
                        Center = CFrame2 * CFrame.new(0, 0, 3)
                    });
                    Cam_Shaker(Position, {
                        FadeInTime = 0,
                        Frequency = 0.15,
                        Amplitude = 0.3,
                        SustainTime = 1.2,
                        FadeOutTime = 0.5,
                        RotationInfluence = Vector3.new(0.25, 0.25, 0.25),
                        PositionInfluence = Vector3.new(1, 1, 1)
                    });
                    task.wait(1.7399999999999998);
                    OuwCraters.Scales({
                        Duration = 2,
                        Count = 6,
                        ScaleMult = 1,
                        Radius = 7,
                        Center = CFrame2 * CFrame.new(0, 0, 3)
                    });
                    Cam_Shaker(Position, {
                        FadeInTime = 0,
                        Frequency = 0.15,
                        Amplitude = 0.6,
                        SustainTime = 0.3,
                        FadeOutTime = 0.5,
                        RotationInfluence = Vector3.new(0.25, 0.25, 0.25),
                        PositionInfluence = Vector3.new(1, 1, 1)
                    });
                    task.wait(0.1900000000000004);
                    Cam_Shaker(Position, "activate_shake");
                    LTN();
                    task.wait(0.8599999999999994);
                    Cam_Shaker(Position, "Medium_tiny_shake_preset");
                end);
                task.delay(5.8, function() -- Line: 232
                    -- upvalues: ImpactFrames (ref)
                    ImpactFrames.PlaySet({
                        FrameRate = 0.022222222222222223,
                        FramesSetName = "Flaming_Thunder_God"
                    });
                end);
            end;
        end;

        return;
    end;

    local v15 = script.Assets.FlamingStartup:Clone();
    v15:PivotTo(HumanoidRootPart.CFrame * CFrame.new(0, -2, 0));
    v15.Parent = workspace.Debree;
    local u16 = script.Assets.YellowHighlight:Clone();
    DebrisModule:AddItem(u16, 1);
    u16.Parent = p4;
    TweenService:Create(u16, TweenInfo.new(0.4), {
        FillTransparency = 1.563,
        OutlineTransparency = 0,
        FillColor = Color3.fromRGB(30, 59, 250),
        OutlineColor = Color3.fromRGB(249, 243, 129)
    }):Play();
    task.delay(0.4, function() -- Line: 73
        -- upvalues: u16 (copy), TweenService (ref)
        if u16 ~= nil and u16.Parent ~= nil then
            TweenService:Create(u16, TweenInfo.new(0.3), {
                FillTransparency = 1,
                OutlineTransparency = 1,
                FillColor = script.Assets.YellowHighlight.FillColor,
                OutlineColor = script.Assets.YellowHighlight.OutlineColor
            }):Play();
        end;
    end);
    DebrisModule:AddItem(v15, 2);
    vfxUtility.PlaySound(Sounds, "PS2thunderbreathTCaFstart", HumanoidRootPart, true);
    local v17 = workspace:Raycast(HumanoidRootPart.Position, HumanoidRootPart.CFrame.upVector * -30, RaycastHelper.Crater);
    local v18;

    if v17 == nil or v17.Instance == nil then
        v18 = nil;
    else
        local _ = CFrame.new(v17.Position, v17.Position + v17.Normal) * CFrame.Angles(-1.5707963267948966, 0, 0) * CFrame.new(0, 1, 0);
        v18 = v17.Instance.Color;
    end;

    Ouwmit.Emit(v15, v18 ~= nil and ({
        Color = v18,
        ColorWhitelist = { "raycastdust", "Rocks", "Dust" }
    } or nil) or nil);
    OuwCraters.Scales({
        Duration = 2,
        Count = 6,
        ScaleMult = 0.5,
        Radius = 6,
        Center = HumanoidRootPart.CFrame
    });
    Cam_Shaker(HumanoidRootPart.Position, "activate_shake");
end;