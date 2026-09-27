-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("Players");
local RunService = game:GetService("RunService");
require(ReplicatedStorage.CAM.Global.ParticleTween);
local CraterHandler = require(ReplicatedStorage.CAM.Client.Modules.Effects.Craters.CraterHandler);
local vfxUtility = require(game.ReplicatedStorage.CAM.Client.Modules.Effects.vfxUtility);
local DebrisModule = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("DebrisModule"));
local u1 = workspace.Debree:FindFirstChild(game.Players.LocalPlayer.Name .. "\'s effects debree thing213asdasdasdasd");

if u1 == nil then
    u1 = Instance.new("Folder", workspace.Debree);
    u1.Name = game.Players.LocalPlayer.Name .. "\'s effects debree thing213asdasdasdasd";
end;

local Assets = script:FindFirstChild("Assets");
local Sounds = script:FindFirstChild("Sounds");
local Cam_Shaker = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Client"):WaitForChild("Modules"):WaitForChild("Effects"):WaitForChild("Cam_Shaker"));
local u2 = {
    FadeInTime = 0,
    Frequency = 0.2,
    Amplitude = 0.25,
    SustainTime = 10,
    FadeOutTime = 0.5,
    RotationInfluence = Vector3.new(0.15, 0.15, 0.15),
    PositionInfluence = Vector3.new(1, 1, 1)
};
local AuraEffects = require(script.Parent.AuraEffects);
game.ReplicatedStorage:WaitForChild("Player_Service"):WaitForChild("Values"):WaitForChild(game.Players.LocalPlayer.Name);

local function folderAlive(p3: userdata?) -- Line: 36
    local v4;

    if p3 == nil or p3.Parent == nil then
        v4 = false;
    else
        v4 = p3:GetAttribute("Cancelled") ~= true;
    end;

    return v4;
end;

return function(p5: userdata, p6: any, p7: vector) -- Line: 40
    -- upvalues: u1 (ref), DebrisModule (copy), AuraEffects (copy), Assets (copy), vfxUtility (copy), Cam_Shaker (copy), Sounds (copy), TweenService (copy), RunService (copy), CraterHandler (copy), u2 (copy)
    if p5 == nil or p6 == nil then
        return;
    end;

    local HumanoidRootPart = p5:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart == nil then
        return;
    end;

    if (HumanoidRootPart.Position - workspace.CurrentCamera.CFrame.Position).Magnitude >= 250 and p6 ~= "Cancel" then
        return;
    end;

    local RightHand = p5:FindFirstChild("RightHand");
    p5:FindFirstChild("LeftHand");
    local string_format_ret = string.format("%s SerpentSlashEffects", p5.Name);
    local string_format_ret2 = string.format("%s SerpentSlashSnake", p5.Name);
    local u8 = string_format_ret2 .. " Flight";
    local string_format_ret3 = string.format("%s SerpentSlashSuccessEffects", p5.Name);

    local function destroySnakes() -- Line: 57
        -- upvalues: u1 (ref), string_format_ret2 (copy), u8 (copy)
        for _, child in u1:GetChildren() do
            if child.Name == string_format_ret2 or child.Name == u8 then
                child:Destroy();
            end;
        end;
    end;

    if p6 ~= "Start" then
        if p6 == "Cancel" then
            AuraEffects.TurnOffAura(p5);
            destroySnakes();

            if u1:FindFirstChild(string_format_ret) then
                local v9 = u1:FindFirstChild(string_format_ret);
                v9.Name = "_";
                v9:SetAttribute("Cancelled", true);
                v9:SetAttribute("Active", false);
                DebrisModule:AddItem(v9, 2.5);
                vfxUtility.EnableAll(v9, false);
            end;

            if u1:FindFirstChild(string_format_ret3) then
                local v10 = u1:FindFirstChild(string_format_ret3);
                v10.Name = "_";
                v10:SetAttribute("Cancelled", true);
                v10:SetAttribute("Active", false);
                DebrisModule:AddItem(v10, 2.5);
                vfxUtility.EnableAll(v10, false);

                for _, descendant in pairs(v10:GetDescendants()) do
                    if table.find({ "MeshPart", "Part", "BasePart" }, descendant.ClassName) and descendant.Transparency ~= 1 then
                        TweenService:Create(descendant, TweenInfo.new(0.1), {
                            Transparency = 1
                        }):Play();
                    end;

                    if descendant:IsA("Sound") and descendant.IsPlaying then
                        TweenService:Create(descendant, TweenInfo.new(0.1), {
                            Volume = 0
                        }):Play();
                        task.delay(0.1, function() -- Line: 236
                            -- upvalues: descendant (copy)
                            if descendant and descendant.IsPlaying then
                                descendant:Stop();
                            end;
                        end);
                    end;
                end;

                return;
            end;
        else
            if p6 == "Shoot" then
                Cam_Shaker(HumanoidRootPart.Position, "tinyshake_preset");

                if typeof(p7) == "Instance" then
                    p7 = p7.Position;
                end;

                vfxUtility.PlaySound(Sounds, "PS2snakeSSshoot", RightHand, true);
                local v11 = Assets.SwordThrow:Clone();
                v11.CFrame = CFrame.new(RightHand.Position, p7);
                v11.Parent = u1;
                vfxUtility.EmitAll(v11:GetDescendants());
                DebrisModule:AddItem(v11, 3);
                destroySnakes();
                local v12 = Assets.Snake:Clone();
                v12.Parent = u1;
                v12.Name = u8;
                v12.Cube.Anchored = true;
                v12.Cube.CFrame = CFrame.new(RightHand.Position, p7) * CFrame.Angles(0, 3.141592653589793, 0);
                v12.AnimationController:LoadAnimation(script.Animations["Snake Loop"]):Play();
                TweenService:Create(v12.Cube, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {
                    CFrame = CFrame.lookAlong(p7, v11.CFrame.LookVector) * CFrame.Angles(0, 3.141592653589793, 0)
                }):Play();
                DebrisModule:AddItem(v12, 0.25);

                return;
            end;

            if p6 == "Explode" then
                local v13 = Assets.SwordImpact:Clone();
                v13.CFrame = CFrame.new(p7);
                v13.Parent = u1;
                vfxUtility.EmitAll(v13:GetDescendants());
                DebrisModule:AddItem(v13, 3);
                vfxUtility.PlaySound(Sounds, "PS2snakeSSgroundimp", v13, true);

                for _, descendant in v13:GetDescendants() do
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
                        task.delay(descendant:GetAttribute("EmitDuration"), function() -- Line: 293
                            -- upvalues: TweenService (ref), descendant (copy)
                            TweenService:Create(descendant, TweenInfo.new(0.5), {
                                Width0 = 0,
                                Width1 = 0
                            }):Play();
                        end);
                    end;
                end;

                CraterHandler.new("Crater", v13.CFrame * CFrame.new(0, 5, 0), {
                    Radius = 12,
                    Range = 59,
                    PartCount = 12,
                    HoldTime = 1,
                    BlockSize = { 2, 4 },
                    Angle = { 45, 90 },
                    Height = { -2, -1.5 },
                    Tilt = { -14, 14 },
                    FlourishTypes = {
                        Exit = "Melt",
                        ExitDivision = "Iterate",
                        ExitSpeed = 2
                    }
                });
                CraterHandler.new("Break", v13.CFrame * CFrame.new(0, 5, 0), {
                    PartCount = 10,
                    Range = 15,
                    Radius = 15,
                    HoldTime = 1.5,
                    BlockSize = { 0.5, 1.5 },
                    Height = { 30, 60 }
                });
                Cam_Shaker(v13.Position, "medium_shake_preset");
                AuraEffects.TurnOffAura(p5);

                return;
            end;

            if p6 == "Success" then
                AuraEffects.TurnOnAura(p5);
                local Folder = Instance.new("Folder");
                Folder.Name = string_format_ret3;
                Folder.Parent = u1;
                DebrisModule:AddItem(Folder, 10);
                Folder:SetAttribute("Active", true);
                local v14 = Assets.SwordImpact:Clone();
                v14.CFrame = CFrame.new(p7);
                v14.Parent = Folder;
                vfxUtility.EmitAll(v14:GetDescendants());
                DebrisModule:AddItem(v14, 2.25);
                Cam_Shaker(v14.Position, "medium_shake_preset");
                vfxUtility.PlaySound(Sounds, "PS2snakeSSgroundimp", v14, true);
                local u15 = vfxUtility.PlaySound(Sounds, "PS2snakeSScombo", HumanoidRootPart, true);
                local u16 = Cam_Shaker(HumanoidRootPart.Position, u2);
                local u17 = {};

                local function v18() -- Line: 355
                    -- upvalues: u17 (copy), u16 (ref), u15 (copy)
                    for _, v in u17 do
                        v:Disconnect();
                    end;

                    if u16 then
                        u16:Stop();
                        u16:Destroy();
                        u16 = nil;
                    end;

                    if u15 and u15.IsPlaying then
                        u15:Stop();
                    end;
                end;

                table.insert(u17, Folder.AttributeChanged:Connect(v18));
                table.insert(u17, Folder.Destroying:Connect(v18));

                for _, descendant in v14:GetDescendants() do
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
                        task.delay(descendant:GetAttribute("EmitDuration"), function() -- Line: 381
                            -- upvalues: TweenService (ref), descendant (copy)
                            TweenService:Create(descendant, TweenInfo.new(0.5), {
                                Width0 = 0,
                                Width1 = 0
                            }):Play();
                        end);
                    end;
                end;

                CraterHandler.new("Crater", v14.CFrame * CFrame.new(0, 5, 0), {
                    Radius = 12,
                    Range = 59,
                    PartCount = 12,
                    HoldTime = 1,
                    BlockSize = { 2, 4 },
                    Angle = { 45, 90 },
                    Height = { -2, -1.5 },
                    Tilt = { -14, 14 },
                    FlourishTypes = {
                        Exit = "Melt",
                        ExitDivision = "Iterate",
                        ExitSpeed = 2
                    }
                });
                CraterHandler.new("Break", v14.CFrame * CFrame.new(0, 5, 0), {
                    PartCount = 10,
                    Range = 15,
                    Radius = 15,
                    HoldTime = 1.5,
                    BlockSize = { 0.5, 1.5 },
                    Height = { 30, 60 }
                });

                if p5 and (p5:FindFirstChild("Basic Katana") and p5:FindFirstChild("Basic Katana"):FindFirstChild("Right"):FindFirstChild("Plane")) then
                    for _, descendant in p5:FindFirstChild("Basic Katana"):FindFirstChild("Right"):FindFirstChild("Plane"):GetDescendants() do
                        if descendant:IsA("Beam") then
                            TweenService:Create(descendant, TweenInfo.new(0.4), {
                                Width0 = 0,
                                Width1 = 0
                            }):Play();
                        end;
                    end;
                end;

                local v19 = Assets.Huge_Snake:Clone();
                v19.Cube.CFrame = HumanoidRootPart.CFrame * CFrame.new(2.848, -6.723, 16.212) * CFrame.fromEulerAnglesYXZ(0, 3.141592653589793, -0);
                v19.Parent = Folder;
                vfxUtility.EnableAll(v19, true);
                vfxUtility.WeldConstraint(v19.PrimaryPart, HumanoidRootPart);
                local v20 = v19.AnimationController:LoadAnimation(script.Animations["Snake Attack"]);
                v20:Play();
                local v21 = Assets.Slashes:Clone();
                v21.CFrame = HumanoidRootPart.CFrame;
                v21.Parent = Folder;
                vfxUtility.EnableAll(v21, true);
                vfxUtility.WeldConstraint(v21, HumanoidRootPart);
                task.wait(2.25);

                if not (Folder:IsDescendantOf(workspace) and Folder:GetAttribute("Active")) then
                    return;
                end;

                if u16 then
                    u16:Stop();
                    u16:Destroy();
                    u16 = nil;
                end;

                vfxUtility.EnableAll(v21, false);
                DebrisModule:AddItem(v21, 3);
                task.wait(0.25);

                if not (Folder:IsDescendantOf(workspace) and Folder:GetAttribute("Active")) then
                    return;
                end;

                local v22 = Assets.LeftToRightSlash:Clone();
                v22:PivotTo(CFrame.lookAlong(HumanoidRootPart.Position + Vector3.new(0, 1, 0), HumanoidRootPart.CFrame.LookVector) * CFrame.Angles(0, -0.7853981633974483, 0));
                v22.Parent = Folder;
                vfxUtility.EmitAll(v22:GetDescendants());
                Cam_Shaker(RightHand.Position, "activate_shake");
                AuraEffects.TurnOffAura(p5);
                task.wait(0.4);

                if not (Folder:IsDescendantOf(workspace) and Folder:GetAttribute("Active")) then
                    return;
                end;

                v20:Stop();
                DebrisModule:AddItem(v19, 0.1);
                TweenService:Create(v19.Cube, TweenInfo.new(0.1), {
                    Transparency = 1
                }):Play();
            end;
        end;

        return;
    end;

    destroySnakes();
    local Folder = Instance.new("Folder");
    Folder.Name = string_format_ret;
    Folder.Parent = u1;
    DebrisModule:AddItem(Folder, 7.5);
    AuraEffects.TurnOnAura(p5);
    local v23 = Assets.Snake:Clone();
    v23.Cube.CFrame = HumanoidRootPart.CFrame * CFrame.new(1.89013671875, -3.1768875122070312, 7.566436767578125) * CFrame.fromEulerAnglesYXZ(-1.2545078027065802e-14, 3.141592502593994, -1.6292032967157866e-7);
    v23.Parent = u1;
    v23.Name = string_format_ret2;
    DebrisModule:AddItem(v23, 7.5);
    vfxUtility.WeldConstraint(v23.Cube, HumanoidRootPart);
    local u24 = v23.AnimationController:LoadAnimation(script.Animations["Snake Startup"]);
    u24:Play();
    task.delay(1.08, function() -- Line: 86
        -- upvalues: u24 (copy)
        u24:AdjustSpeed(0);
    end);
    local v25 = Assets.Jump:Clone();
    v25.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, -10, 0);
    v25.Parent = Folder;
    vfxUtility.EmitAll(v25:GetDescendants());
    DebrisModule:AddItem(v25, 3);
    Cam_Shaker(HumanoidRootPart.Position, "Medium_tiny_shake_preset");
    vfxUtility.PlaySound(Sounds, "PS2snakeSSleapstart", HumanoidRootPart, true);
    local u26 = Assets.BeamsSwirl:Clone();
    u26:PivotTo(HumanoidRootPart.CFrame);
    u26.Parent = Folder;
    DebrisModule:AddItem(u26, 3);
    local v27 = Assets.Wind:Clone();
    v27.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 3, 0);
    v27.Parent = Folder;
    DebrisModule:AddItem(v27, 3);

    for _, descendant in v27:GetDescendants() do
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
            task.delay(descendant:GetAttribute("EmitDuration"), function() -- Line: 117
                -- upvalues: TweenService (ref), descendant (copy)
                TweenService:Create(descendant, TweenInfo.new(0.5), {
                    Width0 = 0,
                    Width1 = 0
                }):Play();
            end);
        end;
    end;

    task.spawn(function() -- Line: 123
        -- upvalues: Folder (copy), u26 (copy), TweenService (ref)
        for i = 1, 4 do
            local v28 = Folder;
            local v29;

            if v28 == nil or v28.Parent == nil then
                v29 = false;
            else
                v29 = v28:GetAttribute("Cancelled") ~= true;
            end;

            if not v29 then
                return;
            end;

            local _ = i;

            for _, descendant in u26["Section" .. i]:GetDescendants() do
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
                    task.delay(descendant:GetAttribute("EmitDuration"), function() -- Line: 137
                        -- upvalues: TweenService (ref), descendant (copy)
                        TweenService:Create(descendant, TweenInfo.new(0.5), {
                            Width0 = 0,
                            Width1 = 0
                        }):Play();
                    end);
                end;

                if descendant:IsA("MeshPart") then
                    TweenService:Create(descendant, TweenInfo.new(1), {
                        CFrame = descendant.CFrame * CFrame.Angles(0, 4.363323129985824, 0)
                    }):Play();
                end;
            end;

            task.wait(0.15);
        end;
    end);
    task.spawn(function() -- Line: 151
        -- upvalues: HumanoidRootPart (copy), Folder (copy), Assets (ref), RunService (ref), vfxUtility (ref), DebrisModule (ref)
        local CFrame2 = HumanoidRootPart.CFrame;

        for i = 1, 5 do
            local v30 = Folder;
            local v31;

            if v30 == nil or v30.Parent == nil then
                v31 = false;
            else
                v31 = v30:GetAttribute("Cancelled") ~= true;
            end;

            if not v31 then
                return;
            end;

            local math_random_ret = math.random(8, 15);
            local u32 = i * 1.5707963267948966;
            local u33 = 0;
            local math_random_ret2 = math.random(4, 9);
            local u34 = i * 2.5;
            local u35 = Assets.SnakeTrail:Clone();
            u35.Parent = Folder;
            local os_clock_ret = os.clock();
            local u36 = nil;
            u36 = RunService.Heartbeat:Connect(function(p37) -- Line: 167
                -- upvalues: Folder (ref), u36 (ref), vfxUtility (ref), u35 (copy), u33 (ref), math_random_ret2 (copy), u34 (ref), CFrame2 (copy), math_random_ret (copy), u32 (copy), os_clock_ret (copy), DebrisModule (ref)
                local v38 = Folder;
                local v39;

                if v38 == nil or v38.Parent == nil then
                    v39 = false;
                else
                    v39 = v38:GetAttribute("Cancelled") ~= true;
                end;

                if not v39 then
                    u36:Disconnect();
                    vfxUtility.EnableAll(u35, false);

                    return;
                end;

                u33 = u33 + p37 * math_random_ret2;
                u34 = u34 + 0.1;
                local v40 = math_random_ret * math.sin(u33 + u32);
                local v41 = math_random_ret * math.cos(u33 + u32);
                u35.CFrame = CFrame2 + Vector3.new(v40, u34, v41);

                if os.clock() - os_clock_ret >= 1 then
                    u36:Disconnect();
                    vfxUtility.EnableAll(u35, false);
                    DebrisModule:AddItem(u35, 2);
                end;
            end);
            task.wait(0.05);
            local _ = i;
        end;
    end);
    task.delay(0.5, function() -- Line: 190
        -- upvalues: Folder (copy), Cam_Shaker (ref), RightHand (copy), Assets (ref), vfxUtility (ref), DebrisModule (ref)
        local v42 = Folder;
        local v43;

        if v42 == nil or v42.Parent == nil then
            v43 = false;
        else
            v43 = v42:GetAttribute("Cancelled") ~= true;
        end;

        if not v43 then
            return;
        end;

        Cam_Shaker(RightHand.Position, "tinyshake_less_aggresive_preset");
        local v44 = Assets.SwordChargeEmit:Clone();
        v44.CFrame = RightHand.CFrame;
        v44.Parent = Folder;
        vfxUtility.EmitAll(v44:GetDescendants());
        DebrisModule:AddItem(v44, 2);
        local v45 = Assets.SwordThrowCharge:Clone();
        v45.CFrame = RightHand.CFrame;
        v45.Parent = Folder;
        vfxUtility.EnableAll(v45, true);
        vfxUtility.WeldConstraint(v45, RightHand);
    end);
end;