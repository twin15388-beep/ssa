-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local RunService = game:GetService("RunService");
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
local RaycastParams_new_ret2 = RaycastParams.new();
RaycastParams_new_ret2.FilterType = Enum.RaycastFilterType.Include;
RaycastParams_new_ret2.FilterDescendantsInstances = { workspace.Map };
local u1 = {};

local function Random_Number(p2, p3) -- Line: 45
    return Random.new():NextNumber(p2, p3);
end;

return function(p4: userdata, p5: any, p6: any) -- Line: 49
    -- upvalues: workspace_Debree (copy), DebrisModule (copy), u1 (copy), Assets (copy), vfxUtility (copy), Sounds (copy), RaycastParams_new_ret2 (copy), Random_Number (copy), TweenService (copy), RunService (copy), CraterHandler (copy), Cam_Shaker (copy)
    local HumanoidRootPart = p4:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local string_format_ret = string.format("%s_%s_Effects", p4.Name, script.Name);

    if p5 ~= "Cancel" and (HumanoidRootPart.Position - workspace.CurrentCamera.CFrame.Position).Magnitude > 250 then
        return;
    end;

    if HumanoidRootPart then
        if p5 == "Start" then
            if not workspace_Debree:FindFirstChild(string_format_ret) then
                local Folder = Instance.new("Folder");
                Folder.Name = string_format_ret;
                Folder.Parent = workspace_Debree;
                DebrisModule:AddItem(Folder, 12);
            end;

            if u1[p4] then
                u1[p4] = nil;
                u1[p4] = {};
            else
                u1[p4] = {};
            end;

            local v7 = u1[p4];
            local v8 = workspace_Debree:FindFirstChild(string_format_ret);
            v8:SetAttribute("Active", true);
            local v9 = Assets.EightFoldsStartup:Clone();
            v9:PivotTo(HumanoidRootPart.CFrame * CFrame.new(0, -2.6, 0) * CFrame.Angles(-1.5707963267948966, 0, 0));
            v9.Parent = v8;
            vfxUtility.EmitAll(v9.Part3);
            vfxUtility.EmitAll(v9.Part);
            vfxUtility.PlaySound(Sounds, "PS2thunderbreath8Flaunch", HumanoidRootPart, true);
            table.insert(v7, vfxUtility.PlaySound(Sounds, "PS2thunderbreath8Fholdloop", HumanoidRootPart));

            if workspace:Raycast(HumanoidRootPart.Position, Vector3.new(0, -10, 0), RaycastParams_new_ret2) then
                vfxUtility.EmitAll(v9.GroundParticleEmit);
            end;

            local v10 = Assets.ConstantBubble:Clone();
            v10.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, -2.25, 0) * CFrame.Angles(1.5707963267948966, 0, 0);
            v10.Parent = v8;
            vfxUtility.EnableAll(v10, true);
            vfxUtility.TweenBeams(v10, {
                Time = 0.25
            });
            local CFrame2 = HumanoidRootPart.CFrame;
            local u11 = Assets.Dash:Clone();
            u11.CFrame = CFrame2;
            u11.Parent = v8;

            local function CheckForObjectsAbove(p12, p13) -- Line: 113
                -- upvalues: RaycastParams_new_ret2 (ref)
                local v14 = p12 * CFrame.new(0, math.random(-2, p13), 0);
                local Magnitude = (p12.Position - v14.Position).Magnitude;
                local v15 = workspace:Raycast(p12.Position, (v14.Position - p12.Position).Unit * Magnitude, RaycastParams_new_ret2);

                if v15 then
                    Magnitude = (p12.Position - v15.Position).Magnitude;
                end;

                return p12 * CFrame.new(0, Magnitude, 0);
            end;

            local function CheckForObjectsAround(p16, p17) -- Line: 126
                -- upvalues: Random_Number (ref), RaycastParams_new_ret2 (ref)
                local v18 = p16 * CFrame.new(Random.new():NextNumber(-15, 15), 0, Random_Number(-15, 15));
                local v19 = CFrame.new(p16.Position, v18.Position) * CFrame.new(0, 0, -p17);
                local Magnitude = (p16.Position - v19.Position).Magnitude;
                local v20 = workspace:Raycast(p16.Position, (v19.Position - p16.Position).Unit * Magnitude, RaycastParams_new_ret2);

                if v20 then
                    Magnitude = (p16.Position - v20.Position).Magnitude;
                end;

                return CFrame.new(p16.Position, v19.Position) * CFrame.new(0, 0, -Magnitude);
            end;

            local function CheckForObjectsBetweenGoalAndThunder(p21, p22) -- Line: 140
                -- upvalues: RaycastParams_new_ret2 (ref)
                local Magnitude = (p21.Position - p22.Position).Magnitude;
                local v23 = workspace:Raycast(p21.Position, (p22.Position - p21.Position).Unit * Magnitude, RaycastParams_new_ret2);

                if v23 then
                    Magnitude = (v23.Position - p21.Position).Magnitude;
                end;

                return CFrame.new(p21.Position, p22.Position) * CFrame.new(0, 0, -Magnitude);
            end;

            local v24 = CFrame2;

            while v8 ~= nil and (v8.Parent ~= nil and v8:GetAttribute("Active")) do
                if not HumanoidRootPart then
                    return;
                end;

                local math_random_ret = math.random(20, 25);
                v24 = CheckForObjectsBetweenGoalAndThunder(v24, (CheckForObjectsAround(CheckForObjectsAbove(CFrame2, math_random_ret), math_random_ret)));
                TweenService:Create(u11, TweenInfo.new(0.035, Enum.EasingStyle.Quint), {
                    CFrame = v24
                }):Play();
                task.delay(0.03325, function() -- Line: 166
                    -- upvalues: vfxUtility (ref), u11 (copy)
                    vfxUtility.EmitAll(u11);
                end);
                task.wait(0.035);
            end;
        elseif p5 == "End" then
            local v25 = workspace_Debree:FindFirstChild(string_format_ret);
            local v26 = u1[p4];

            if v26 then
                for _, v in v26 do
                    v:Destroy();
                end;
            end;

            if v25 then
                v25.Name = "_";
                v25:SetAttribute("Active", nil);
                DebrisModule:AddItem(v25, 2);
                local EightFoldsStartup = v25:FindFirstChild("EightFoldsStartup");

                if EightFoldsStartup then
                    DebrisModule:AddItem(EightFoldsStartup, 1);
                    vfxUtility.EnableAll(EightFoldsStartup, false);
                    vfxUtility.TweenLight(EightFoldsStartup, {
                        Time = 0.1,
                        Off = true
                    });
                end;

                local ConstantBubble = v25:FindFirstChild("ConstantBubble");

                if ConstantBubble then
                    vfxUtility.EnableAll(ConstantBubble, false);
                    vfxUtility.TweenBeams(ConstantBubble, {
                        Time = 0.25,
                        Off = true
                    });
                    DebrisModule:AddItem(ConstantBubble, 2);
                end;

                local v27 = Assets.ThunderBolt:Clone();
                v27:PivotTo(HumanoidRootPart.CFrame * CFrame.new(0, -2.6, 0) * CFrame.Angles(-1.5707963267948966, 0, 0));
                v27.Parent = v25;
                vfxUtility.EmitAll(v27);
                DebrisModule:AddItem(v27, 4);
                vfxUtility.PlaySound(Sounds, "PS2thunderbreath8Fend", HumanoidRootPart, true);

                for _, descendant in v27:GetDescendants() do
                    if descendant:IsA("Beam") then
                        descendant.Enabled = true;
                        local Width0 = descendant.Width0;
                        local Width1 = descendant.Width1;
                        descendant.Width0 = 0;
                        descendant.Width1 = 0;
                        TweenService:Create(descendant, TweenInfo.new(0.1), {
                            Width0 = Width0,
                            Width1 = Width1
                        }):Play();
                        task.delay(0.4, function() -- Line: 227
                            -- upvalues: TweenService (ref), descendant (copy)
                            TweenService:Create(descendant, TweenInfo.new(0.15), {
                                Width0 = 0,
                                Width1 = 0
                            }):Play();
                        end);
                    end;
                end;

                for i, child in v27.Meshes.Twirl:GetChildren() do
                    local v28 = Random.new():NextNumber(0.25, 0.5);
                    local u30 = RunService.Heartbeat:Connect(function() -- Line: 236
                        -- upvalues: child (copy), i (copy)
                        local v29 = child;
                        local CFrame2 = v29.CFrame;
                        local CFrame_Angles = CFrame.Angles;
                        local _ = math.random(1, 2) % i == 0;
                        v29.CFrame = CFrame2 * CFrame_Angles(0, math.rad(2.3 * 1), 0);
                    end);
                    task.delay(v28 / 2, function() -- Line: 240
                        -- upvalues: TweenService (ref), child (copy), u30 (copy)
                        TweenService:Create(child, TweenInfo.new(Random.new():NextNumber(0.1, 0.2), Enum.EasingStyle.Exponential), {
                            Transparency = 1
                        }):Play();
                        task.delay(0.4, function() -- Line: 243
                            -- upvalues: u30 (ref)
                            u30:Disconnect();
                        end);
                    end);
                end;

                TweenService:Create(v27.Meshes.MeshSpecial.Start, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {
                    Transparency = 1,
                    Position = v27.Meshes.MeshSpecial.End.Position
                }):Play();
                TweenService:Create(v27.Meshes.MeshSpecial.Start.Mesh, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {
                    Scale = v27.Meshes.MeshSpecial.End.Mesh.Scale
                }):Play();
                TweenService:Create(v27.Meshes.MeshSpecial.StartBlack, TweenInfo.new(0.125, Enum.EasingStyle.Linear), {
                    Transparency = 1,
                    Position = v27.Meshes.MeshSpecial.End.Position
                }):Play();
                TweenService:Create(v27.Meshes.MeshSpecial.StartBlack.Mesh, TweenInfo.new(0.125, Enum.EasingStyle.Linear), {
                    Scale = v27.Meshes.MeshSpecial.End.Mesh.Scale
                }):Play();
                DebrisModule:AddItem(v27.Meshes.MeshSpecial.Start, 0.1);
                DebrisModule:AddItem(v27.Meshes.MeshSpecial.StartBlack, 0.125);
                CraterHandler.new("Crater", CFrame.new(HumanoidRootPart.Position) * CFrame.new(0, 3, 0), {
                    Radius = 40,
                    PartCount = 25,
                    HoldTime = 1.5,
                    Range = 30,
                    BlockSize = { 4, 6 },
                    Angle = { 45, 69 },
                    Height = { -1.5, -1 },
                    Tilt = { -10, 10 },
                    FlourishTypes = {
                        Exit = "Melt",
                        ExitDivision = "Iterate",
                        ExitSpeed = 1
                    }
                });
                CraterHandler.new("Crater", CFrame.new(HumanoidRootPart.Position) * CFrame.new(0, 3, 0), {
                    Radius = 60,
                    PartCount = 45,
                    HoldTime = 1.5,
                    Range = 30,
                    BlockSize = { 5, 7 },
                    Angle = { 45, 69 },
                    Height = { -1.5, -1 },
                    Tilt = { -10, 10 },
                    FlourishTypes = {
                        Exit = "Melt",
                        ExitDivision = "Iterate",
                        ExitSpeed = 1
                    }
                });
                CraterHandler.new("Break", CFrame.new(HumanoidRootPart.Position) * CFrame.new(0, 3, 0), {
                    PartCount = 35,
                    Range = 30,
                    Radius = 60,
                    HoldTime = 1.5,
                    BlockSize = { 0.5, 2.5 },
                    Height = { 30, 150 }
                });
                Cam_Shaker(HumanoidRootPart.Position, "medium_shake_preset");
            end;
        elseif p5 == "Cancel" then
            local v31 = workspace_Debree:FindFirstChild(string_format_ret);
            local v32 = u1[p4];

            if v31 then
                v31.Name = "_";
                v31:SetAttribute("Active", nil);
                DebrisModule:AddItem(v31, 2);

                for _, child in v31:GetChildren() do
                    vfxUtility.EnableAll(child, false);
                    vfxUtility.TweenLight(child, {
                        Time = 0.1,
                        Off = true
                    });
                end;
            end;

            if v32 then
                for _, v in v32 do
                    v:Destroy();
                end;

                u1[p4] = nil;
            end;
        end;
    end;
end;