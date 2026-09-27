-- Decompiled with Potassium's decompiler.

game:GetService("CollectionService");
local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
require(ReplicatedStorage.CAM.Global.ParticleTween);
local Bezier = require(ReplicatedStorage.CAM.Client.Modules.Effects.Bezier);
local u1 = workspace.Debree:FindFirstChild(game.Players.LocalPlayer.Name .. "\'s effects debree thing213asdasdasdasd");
local vfxUtility = require(game.ReplicatedStorage.CAM.Client.Modules.Effects.vfxUtility);
local DebrisModule = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("DebrisModule"));

if u1 == nil then
    u1 = Instance.new("Folder", workspace.Debree);
    u1.Name = game.Players.LocalPlayer.Name .. "\'s effects debree thing213asdasdasdasd";
end;

local Assets = script:FindFirstChild("Assets");
local Sounds = script:FindFirstChild("Sounds");
local _ = Players.LocalPlayer;

function MakeCharacterTransparent(p2)
    local v3 = {};

    for _, descendant in p2:GetDescendants() do
        if (descendant:IsA("MeshPart") or (descendant:IsA("BasePart") or (descendant:IsA("Part") or descendant:IsA("Decal")))) and (descendant.Name ~= "HumanoidRootPart" and descendant.Transparency ~= 1) then
            local Transparency = descendant.Transparency;
            descendant.Transparency = 1;
            table.insert(v3, {
                Part = descendant,
                Transparency = Transparency
            });
        end;

        if descendant:IsA("ParticleEmitter") and descendant.Enabled == true then
            local Transparency = descendant.Transparency;
            descendant.Transparency = NumberSequence.new(1, 1);
            descendant.Enabled = false;
            table.insert(v3, {
                Particle = descendant,
                Particle_Saved_Transparency = Transparency
            });
        end;

        if descendant:IsA("Beam") and descendant.Enabled == true then
            descendant.Enabled = false;
            table.insert(v3, {
                Beam = descendant
            });
        end;

        if descendant:IsA("Trail") and descendant.Enabled == true then
            descendant.Enabled = false;
            table.insert(v3, {
                Trail = descendant
            });
        end;

        if descendant:IsA("PointLight") or (descendant:IsA("SpotLight") or descendant:IsA("SurfaceLight")) then
            local Range = descendant.Range;
            local Brightness = descendant.Brightness;
            descendant.Range = 0;
            descendant.Brightness = 0;
            table.insert(v3, {
                Light = descendant,
                Range = Range,
                Brightness = Brightness
            });
        end;
    end;

    return v3;
end;

function ReturnCharacterTransparency(p4)
    for _, v in p4 do
        if typeof(v) == "table" then
            if v.Part then
                v.Part.Transparency = v.Transparency;
            end;

            if v.Particle then
                v.Particle.Enabled = true;
                v.Transparency = v.Particle_Saved_Transparency;
            end;

            if v.Beam then
                v.Beam.Enabled = true;
            end;

            if v.Trail then
                v.Trail.Enabled = true;
            end;

            if v.Light then
                v.Light.Brightness = v.Brightness;
                v.Light.Range = v.Range;
            end;
        end;
    end;
end;

local AuraEffects = require(script.Parent.AuraEffects);
local Cam_Shaker = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Client"):WaitForChild("Modules"):WaitForChild("Effects"):WaitForChild("Cam_Shaker"));

return function(p5: userdata, p6: any, u7: vector, u8: vector, p9: vector) -- Line: 116
    -- upvalues: AuraEffects (copy), u1 (ref), DebrisModule (copy), vfxUtility (copy), Sounds (copy), Assets (copy), Cam_Shaker (copy), TweenService (copy), RunService (copy), Bezier (copy)
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
    local string_format_ret = string.format("%s TwinHeadedReptileEffects", p5.Name);

    if p6 == "Start" then
        AuraEffects.TurnOnAura(p5);

        return;
    end;

    if p6 ~= "Dash" then
        if p6 == "Cancel" then
            AuraEffects.TurnOffAura(p5);
            local v10 = u1:FindFirstChild(string_format_ret);

            if v10 then
                v10.Name = "_";
                v10:SetAttribute("Active", false);
                DebrisModule:AddItem(v10, 2.5);

                for _, child in v10:GetChildren() do
                    vfxUtility.EnableAll(child, false);
                    DebrisModule:AddItem(child, 2);
                end;

                return;
            end;
        elseif p6 == "Success" then
            AuraEffects.TurnOffAura(p5);
            local v11 = u1:FindFirstChild(string_format_ret);

            if v11 then
                v11.Name = "_";
                v11:SetAttribute("Active", false);
                DebrisModule:AddItem(v11, 2.5);

                for _, child in v11:GetChildren() do
                    vfxUtility.EnableAll(child, false);
                    DebrisModule:AddItem(child, 2);
                end;
            end;

            local v12 = u1:FindFirstChild(string_format_ret);

            if v12 then
                v12.Name = "_";
                v12:SetAttribute("Active", false);
                DebrisModule:AddItem(v12, 2.5);

                for _, child in v12:GetChildren() do
                    vfxUtility.EnableAll(child, false);
                    DebrisModule:AddItem(child, 2);
                end;
            end;

            vfxUtility.PlaySound(Sounds, "PS2snakeTHSsuccess", HumanoidRootPart, true);
            local u13 = HumanoidRootPart.CFrame * CFrame.new(0, 0, 5);
            task.delay(0.5, function() -- Line: 344
                -- upvalues: Assets (ref), u8 (copy), u7 (copy), u1 (ref), vfxUtility (ref), TweenService (ref), u13 (copy), DebrisModule (ref)
                local u14 = Assets.Strike:Clone();
                u14.CFrame = CFrame.lookAlong(u8, u7) * CFrame.new(0, -2, 10);
                u14.Parent = u1;
                vfxUtility.EnableAll(u14, true);
                local u15 = TweenService:Create(u14, TweenInfo.new(0.8, Enum.EasingStyle.Quint), {
                    CFrame = u13 * CFrame.new(0, -2, -3)
                });
                u15:Play();
                task.delay(0.4, function() -- Line: 353
                    -- upvalues: vfxUtility (ref), u14 (copy), DebrisModule (ref), u15 (copy)
                    vfxUtility.EnableAll(u14, false);
                    DebrisModule:AddItem(u14, 2);
                    u15:Pause();
                end);
            end);
            local u16 = Assets.Snake:Clone();
            u16.Cube.CFrame = HumanoidRootPart.CFrame * CFrame.new(-0.38543701171875, -3.7476654052734375, 5.309661865234375) * CFrame.fromEulerAnglesYXZ(-0.09161286056041718, 3.141502618789673, -0.001621622359380126);
            u16.Parent = u1;
            u16.AnimationController:LoadAnimation(script.Animations["Snake 1"]):Play();
            local u17 = Assets.Snake:Clone();
            u17.Cube.CFrame = HumanoidRootPart.CFrame * CFrame.new(-0.38543701171875, -3.7476654052734375, 5.309661865234375) * CFrame.fromEulerAnglesYXZ(-0.09161286056041718, 3.141502618789673, -0.001621622359380126);
            u17.Parent = u1;
            u17.AnimationController:LoadAnimation(script.Animations["Snake 2"]):Play();
            u16.Cube.Transparency = 1;
            u17.Cube.Transparency = 1;
            vfxUtility.EnableAll(u16, false);
            vfxUtility.EnableAll(u17, false);
            local v18 = Assets.TickDMG:Clone();
            v18.CFrame = u13;
            v18.Parent = u1;
            vfxUtility.EnableAll(v18, true);
            Cam_Shaker(HumanoidRootPart.Position, {
                FadeInTime = 0,
                Frequency = 0.07,
                Amplitude = 0.25,
                SustainTime = 1,
                FadeOutTime = 0.2,
                RotationInfluence = Vector3.new(0.1, 0.1, 0.1),
                PositionInfluence = Vector3.new(0.5, 0.5, 0.5)
            });
            task.wait(1);
            vfxUtility.EnableAll(v18, false);
            DebrisModule:AddItem(v18, 2);
            task.wait(0.3333);
            local v19 = Assets.SwordDismiss:Clone();
            v19.CFrame = RightHand.CFrame;
            v19.Parent = u1;
            vfxUtility.EmitAll(v19);
            DebrisModule:AddItem(v19, 2);
            AuraEffects.TurnOffAura(p5);
            task.wait(0.5);
            TweenService:Create(u17.Cube, TweenInfo.new(0.2), {
                Transparency = 0
            }):Play();
            TweenService:Create(u16.Cube, TweenInfo.new(0.2), {
                Transparency = 0
            }):Play();
            vfxUtility.EnableAll(u16, true);
            vfxUtility.EnableAll(u17, true);
            task.wait(0.266);
            task.delay(0.35, function() -- Line: 424
                -- upvalues: vfxUtility (ref), u16 (copy), u17 (copy)
                vfxUtility.EnableAll(u16, false);
                vfxUtility.EnableAll(u17, false);
            end);
            Cam_Shaker(HumanoidRootPart.Position, "Medium_tiny_shake_preset");
            local v20 = Assets.KnockBack:Clone();
            v20.CFrame = u13;
            v20.Parent = u1;
            vfxUtility.EmitAll(v20);
            DebrisModule:AddItem(v20, 2);
            TweenService:Create(u16.Cube, TweenInfo.new(0.8), {
                Transparency = 1
            }):Play();
            TweenService:Create(u17.Cube, TweenInfo.new(0.8), {
                Transparency = 1
            }):Play();
            DebrisModule:AddItem(u16, 2);
            DebrisModule:AddItem(u17, 2);
        end;

        return;
    end;

    AuraEffects.TurnOffAura(p5);
    local v21 = u1:FindFirstChild(string_format_ret);

    if v21 then
        v21.Name = "_";
        v21:SetAttribute("Active", false);
        DebrisModule:AddItem(v21, 2.5);

        for _, child in v21:GetChildren() do
            vfxUtility.EnableAll(child, false);
            DebrisModule:AddItem(child, 2);
        end;
    end;

    local CFrame_lookAlong_ret = CFrame.lookAlong(u8, u7);
    local CFrame_lookAlong_ret2 = CFrame.lookAlong(p9, u7);
    local Folder = Instance.new("Folder");
    Folder.Name = string_format_ret;
    Folder.Parent = u1;
    DebrisModule:AddItem(Folder, 10);
    Folder:SetAttribute("Active", true);
    vfxUtility.PlaySound(Sounds, "PS2snakeTHSlungeslash", HumanoidRootPart, true);
    local u22 = {};

    local function v23() -- Line: 158
        -- upvalues: u22 (copy)
        for _, v in u22 do
            v:Disconnect();
        end;
    end;

    table.insert(u22, Folder.AttributeChanged:Connect(v23));
    table.insert(u22, Folder.Destroying:Connect(v23));
    local u24 = Assets["Dash and Slash"]:Clone();
    u24:PivotTo(CFrame.new(CFrame_lookAlong_ret.Position, CFrame_lookAlong_ret2.Position));
    u24.Parent = u1;
    DebrisModule:AddItem(u24, 5);
    Cam_Shaker(HumanoidRootPart.Position, "tinyshake_preset");
    vfxUtility.EmitAll(u24.Dash);
    vfxUtility.EmitAll(u24.Slashes.Slash1);

    for _, v in { u24.Dash, u24.Slashes.Slash1 } do
        for _, descendant in v:GetDescendants() do
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
                task.delay(descendant:GetAttribute("EmitDuration"), function() -- Line: 186
                    -- upvalues: TweenService (ref), descendant (copy)
                    TweenService:Create(descendant, TweenInfo.new(0.5), {
                        Width0 = 0,
                        Width1 = 0
                    }):Play();
                end);
            end;
        end;
    end;

    task.delay(0.1, function() -- Line: 193
        -- upvalues: Folder (copy), vfxUtility (ref), u24 (copy), TweenService (ref)
        if Folder:GetAttribute("Active") == true then
            vfxUtility.EmitAll(u24.Slashes.Slash2);

            for _, descendant in u24.Slashes.Slash2:GetDescendants() do
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
                    task.delay(descendant:GetAttribute("EmitDuration"), function() -- Line: 206
                        -- upvalues: TweenService (ref), descendant (copy)
                        TweenService:Create(descendant, TweenInfo.new(0.5), {
                            Width0 = 0,
                            Width1 = 0
                        }):Play();
                    end);
                end;
            end;
        elseif Folder:GetAttribute("Active") == false then
            return;
        end;

        task.wait(0.05);

        if Folder:GetAttribute("Active") == true then
            vfxUtility.EmitAll(u24.Slashes.Slash3);

            for _, descendant in u24.Slashes.Slash3:GetDescendants() do
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
                    task.delay(descendant:GetAttribute("EmitDuration"), function() -- Line: 230
                        -- upvalues: TweenService (ref), descendant (copy)
                        TweenService:Create(descendant, TweenInfo.new(0.5), {
                            Width0 = 0,
                            Width1 = 0
                        }):Play();
                    end);
                end;
            end;
        elseif Folder:GetAttribute("Active") == false then
            return;
        end;

        task.wait(0.05);

        if Folder:GetAttribute("Active") == true then
            vfxUtility.EmitAll(u24.Slashes.FinalSlash);

            for _, descendant in u24.Slashes.FinalSlash:GetDescendants() do
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
                    task.delay(descendant:GetAttribute("EmitDuration"), function() -- Line: 253
                        -- upvalues: TweenService (ref), descendant (copy)
                        TweenService:Create(descendant, TweenInfo.new(0.5), {
                            Width0 = 0,
                            Width1 = 0
                        }):Play();
                    end);
                end;
            end;
        end;
    end);

    for i = 1, 6 do
        local u25 = Assets.SnakeTrail:Clone();
        u25.CFrame = u24.PrimaryPart.CFrame * CFrame.new(math.random(-10, 10), math.random(5, 5), math.random(-2, 2));
        u25.Parent = u1:FindFirstChild(string_format_ret);
        vfxUtility.EnableAll(u25, true);
        local u26 = math.random(200, 350) / 100;
        local u27 = 0;
        local CFrame2 = u25.CFrame;
        local u28 = CFrame_lookAlong_ret2 * CFrame.new(math.random(-5, 5), math.random(-2, 3), math.random(-3, 3));
        local Position = (CFrame.lookAt(u25.Position:Lerp(u28.Position, 0.25), u28.Position) * CFrame.new(math.random(-30, 30), math.random(-10, 15), math.random(-10, 5))).Position;
        local Position2 = (CFrame.lookAt(u25.Position:Lerp(u28.Position, 0.75), u28.Position) * CFrame.new(math.random(-30, 30), math.random(-10, 15), math.random(-10, 5))).Position;
        local u29 = nil;
        u29 = RunService.Heartbeat:Connect(function(p30) -- Line: 275
            -- upvalues: u27 (ref), u26 (copy), Bezier (ref), CFrame2 (copy), Position (copy), Position2 (copy), u28 (copy), u29 (ref), u25 (copy), vfxUtility (ref), DebrisModule (ref)
            u27 = u27 + p30 * u26;
            local v31 = Bezier.CubicBezier(u27, CFrame2.Position, Position, Position2, u28.Position);
            local v32 = Bezier.CubicBezier(u27 + 0.01, CFrame2.Position, Position, Position2, u28.Position);

            if u27 < 1 then
                u25.CFrame = CFrame.new(v31, v32);

                return;
            end;

            u29:Disconnect();
            u25.Position = u28.Position;
            vfxUtility.EnableAll(u25, false);
            DebrisModule:AddItem(u25, 2);
        end);
        table.insert(u22, u29);
        local _ = i;
    end;
end;