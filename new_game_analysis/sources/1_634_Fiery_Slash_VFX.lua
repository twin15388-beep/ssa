-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local DebrisModule = require(ReplicatedStorage.CAM.DebrisModule);
game:GetService("RunService");
require(ReplicatedStorage.CAM.Client.Modules.Effects.Craters.CraterEffects);
local Cam_Shaker = require(ReplicatedStorage.CAM.Client.Modules.Effects.Cam_Shaker);
require(ReplicatedStorage.CAM.Client.Modules.Effects.Craters.CraterExtension);
local TokenKit = require(ReplicatedStorage.CAM.Client.Modules.Effects.Token.TokenKit);
Random.new();
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Include;
RaycastParams_new_ret.FilterDescendantsInstances = { workspace.Map };
local u1 = workspace.Debree:FindFirstChild(game.Players.LocalPlayer.Name .. "\'s effects debree thing213asdasdasdasd");

if u1 == nil then
    u1 = Instance.new("Folder", workspace.Debree);
    u1.Name = game.Players.LocalPlayer.Name .. "\'s effects debree thing213asdasdasdasd";
end;

local function EmitAllSpec(p2, p3) -- Line: 26
    -- upvalues: TweenService (copy)
    for _, descendant in pairs(p2:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            task.delay(descendant:GetAttribute("EmitDelay") or 0, function() -- Line: 29
                -- upvalues: descendant (copy)
                descendant:Emit(descendant:GetAttribute("EmitCount") or 30);
            end);
        end;

        if descendant:IsA("PointLight") then
            TweenService:Create(descendant, TweenInfo.new(p3), {
                Brightness = 0
            }):Play();
        end;
    end;
end;

local function Toggle(p4, p5) -- Line: 40
    local Descendants = p4:GetDescendants();

    for _, v in ipairs(Descendants) do
        if v:IsA("ParticleEmitter") then
            v.Enabled = p5;
        end;

        if v:IsA("PointLight") or v:IsA("SurfaceLight") then
            v.Enabled = p5;
        end;

        if v:IsA("Beam") then
            v.Enabled = p5;
        end;

        if v:IsA("Trail") then
            v.Enabled = p5;
        end;
    end;
end;

local u6 = {
    Animations = {
        NezukoSlash = { "rbxassetid://16772444701", "rbxassetid://16772445208", "rbxassetid://16772445394", "rbxassetid://16772445551", "rbxassetid://16772445718", "rbxassetid://16772445890", "rbxassetid://16772446007" }
    }
};

local function PlaySlash(p7, u8, p9) -- Line: 82
    local u10 = p9 or 60;
    local Decal = p7.Decal;
    task.spawn(function() -- Line: 85
        -- upvalues: u8 (copy), Decal (copy), u10 (ref)
        for _, v in u8 do
            Decal.Texture = v;
            task.wait(1 / u10);
        end;

        Decal.Transparency = 1;
    end);
end;

function ImpactFrame(p11)
    -- upvalues: DebrisModule (copy)
    local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect");
    ColorCorrectionEffect.TintColor = Color3.new(1, 1, 1);
    local game_Lighting = game.Lighting;
    ColorCorrectionEffect.Contrast = -50;
    ColorCorrectionEffect.Saturation = -1;
    ColorCorrectionEffect.Parent = game_Lighting;
    DebrisModule:AddItem(ColorCorrectionEffect, p11 or 0.08333333333333333);
end;

function BlurEffect(p12)
    -- upvalues: DebrisModule (copy)
    local BlurEffect2 = Instance.new("BlurEffect");
    local game_Lighting = game.Lighting;
    BlurEffect2.Size = 3;
    BlurEffect2.Parent = game_Lighting;
    DebrisModule:AddItem(BlurEffect2, p12 or 0.08333333333333333);
end;

return function(p13, p14, u15) -- Line: 109
    -- upvalues: DebrisModule (copy), u1 (ref), EmitAllSpec (copy), u6 (copy), TokenKit (copy), Cam_Shaker (copy), Toggle (copy), RaycastParams_new_ret (copy), TweenService (copy)
    local HumanoidRootPart = p13:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart == nil then
        return;
    end;

    local Magnitude = (p13.HumanoidRootPart.Position - workspace.CurrentCamera.CFrame.Position).Magnitude;

    if Magnitude >= 250 then
        return;
    end;

    if p14 ~= "StarterSlash" then
        if p14 == "Slash1" then
            local v16 = script.NezukoSlash1:Clone();
            v16:PivotTo(HumanoidRootPart.CFrame * CFrame.new(-0.18743896484375, -1.4835057258605957, -1.59686279296875) * CFrame.fromEulerAnglesYXZ(-0.057513587176799774, -3.0886170864105225, 1.1774322986602783));
            v16.Parent = u1;
            DebrisModule:AddItem(v16, 1.5);
            EmitAllSpec(v16, 1);
            local NezukoSlash = u6.Animations.NezukoSlash;
            local u17 = 30 or 60;
            local Decal = v16.Slash1.Decal;
            task.spawn(function() -- Line: 85
                -- upvalues: NezukoSlash (copy), Decal (copy), u17 (ref)
                for _, v in NezukoSlash do
                    Decal.Texture = v;
                    task.wait(1 / u17);
                end;

                Decal.Transparency = 1;
            end);
            local NezukoSlash2 = u6.Animations.NezukoSlash;
            local u18 = 30 or 60;
            local Decal2 = v16.Slash2.Decal;
            task.spawn(function() -- Line: 85
                -- upvalues: NezukoSlash2 (copy), Decal2 (copy), u18 (ref)
                for _, v in NezukoSlash2 do
                    Decal2.Texture = v;
                    task.wait(1 / u18);
                end;

                Decal2.Transparency = 1;
            end);
            local NezukoSlash3 = u6.Animations.NezukoSlash;
            local u19 = 30 or 60;
            local Decal3 = v16.Slash3.Decal;
            task.spawn(function() -- Line: 85
                -- upvalues: NezukoSlash3 (copy), Decal3 (copy), u19 (ref)
                for _, v in NezukoSlash3 do
                    Decal3.Texture = v;
                    task.wait(1 / u19);
                end;

                Decal3.Transparency = 1;
            end);

            if Magnitude <= 50 then
                BlurEffect(0.1);

                return;
            end;
        elseif p14 == "Slash2" then
            local v20 = script.NezukoSlash1:Clone();
            v20:PivotTo(HumanoidRootPart.CFrame * CFrame.new(1, -1.3675274848937988, -0.43023681640625) * CFrame.fromEulerAnglesYXZ(-0.12331271171569824, 3.0492522716522217, -0.8966320157051086));
            v20.Parent = u1;
            DebrisModule:AddItem(v20, 1.5);
            EmitAllSpec(v20, 1);
            local NezukoSlash = u6.Animations.NezukoSlash;
            local u21 = 30 or 60;
            local Decal = v20.Slash1.Decal;
            task.spawn(function() -- Line: 85
                -- upvalues: NezukoSlash (copy), Decal (copy), u21 (ref)
                for _, v in NezukoSlash do
                    Decal.Texture = v;
                    task.wait(1 / u21);
                end;

                Decal.Transparency = 1;
            end);
            local NezukoSlash2 = u6.Animations.NezukoSlash;
            local u22 = 30 or 60;
            local Decal2 = v20.Slash2.Decal;
            task.spawn(function() -- Line: 85
                -- upvalues: NezukoSlash2 (copy), Decal2 (copy), u22 (ref)
                for _, v in NezukoSlash2 do
                    Decal2.Texture = v;
                    task.wait(1 / u22);
                end;

                Decal2.Transparency = 1;
            end);
            local NezukoSlash3 = u6.Animations.NezukoSlash;
            local u23 = 30 or 60;
            local Decal3 = v20.Slash3.Decal;
            task.spawn(function() -- Line: 85
                -- upvalues: NezukoSlash3 (copy), Decal3 (copy), u23 (ref)
                for _, v in NezukoSlash3 do
                    Decal3.Texture = v;
                    task.wait(1 / u23);
                end;

                Decal3.Transparency = 1;
            end);

            if Magnitude <= 50 then
                BlurEffect(0.1);

                return;
            end;
        elseif p14 == "Slash3" then
            local v24 = script.NezukoSlash1:Clone();
            v24:PivotTo(HumanoidRootPart.CFrame * CFrame.new(2.5667724609375, -1.0992112159729004, -0.2515869140625) * CFrame.fromEulerAnglesYXZ(0.07966601103544235, 3.0933125019073486, -1.313460111618042));
            v24.Parent = u1;
            DebrisModule:AddItem(v24, 1.5);
            EmitAllSpec(v24, 1);
            local NezukoSlash = u6.Animations.NezukoSlash;
            local u25 = 30 or 60;
            local Decal = v24.Slash1.Decal;
            task.spawn(function() -- Line: 85
                -- upvalues: NezukoSlash (copy), Decal (copy), u25 (ref)
                for _, v in NezukoSlash do
                    Decal.Texture = v;
                    task.wait(1 / u25);
                end;

                Decal.Transparency = 1;
            end);
            local NezukoSlash2 = u6.Animations.NezukoSlash;
            local u26 = 30 or 60;
            local Decal2 = v24.Slash2.Decal;
            task.spawn(function() -- Line: 85
                -- upvalues: NezukoSlash2 (copy), Decal2 (copy), u26 (ref)
                for _, v in NezukoSlash2 do
                    Decal2.Texture = v;
                    task.wait(1 / u26);
                end;

                Decal2.Transparency = 1;
            end);
            local NezukoSlash3 = u6.Animations.NezukoSlash;
            local u27 = 30 or 60;
            local Decal3 = v24.Slash3.Decal;
            task.spawn(function() -- Line: 85
                -- upvalues: NezukoSlash3 (copy), Decal3 (copy), u27 (ref)
                for _, v in NezukoSlash3 do
                    Decal3.Texture = v;
                    task.wait(1 / u27);
                end;

                Decal3.Transparency = 1;
            end);
            local v28 = script.NezukoSlash1:Clone();
            v28:PivotTo(HumanoidRootPart.CFrame * CFrame.new(-2.21319580078125, -1.0364785194396973, -0.25) * CFrame.fromEulerAnglesYXZ(0.08501958101987839, -3.088571310043335, 1.339966893196106));
            v28.Parent = u1;
            DebrisModule:AddItem(v28, 1.5);
            EmitAllSpec(v28, 1);
            local NezukoSlash4 = u6.Animations.NezukoSlash;
            local u29 = 30 or 60;
            local Decal4 = v28.Slash1.Decal;
            task.spawn(function() -- Line: 85
                -- upvalues: NezukoSlash4 (copy), Decal4 (copy), u29 (ref)
                for _, v in NezukoSlash4 do
                    Decal4.Texture = v;
                    task.wait(1 / u29);
                end;

                Decal4.Transparency = 1;
            end);
            local NezukoSlash5 = u6.Animations.NezukoSlash;
            local u30 = 30 or 60;
            local Decal5 = v28.Slash2.Decal;
            task.spawn(function() -- Line: 85
                -- upvalues: NezukoSlash5 (copy), Decal5 (copy), u30 (ref)
                for _, v in NezukoSlash5 do
                    Decal5.Texture = v;
                    task.wait(1 / u30);
                end;

                Decal5.Transparency = 1;
            end);
            local NezukoSlash6 = u6.Animations.NezukoSlash;
            local u31 = 30 or 60;
            local Decal6 = v28.Slash3.Decal;
            task.spawn(function() -- Line: 85
                -- upvalues: NezukoSlash6 (copy), Decal6 (copy), u31 (ref)
                for _, v in NezukoSlash6 do
                    Decal6.Texture = v;
                    task.wait(1 / u31);
                end;

                Decal6.Transparency = 1;
            end);

            if Magnitude <= 50 then
                BlurEffect(0.1);

                return;
            end;
        elseif p14 == "Slash4" then
            local v32 = script.NezukoSlash1:Clone();
            v32:PivotTo(HumanoidRootPart.CFrame * CFrame.new(1.97894287109375, 1.7392258644104004, -0.3804931640625) * CFrame.fromEulerAnglesYXZ(0.07384803146123886, 3.016101360321045, 3.018805742263794));
            v32.Parent = u1;
            DebrisModule:AddItem(v32, 1.5);
            EmitAllSpec(v32, 1);
            local NezukoSlash = u6.Animations.NezukoSlash;
            local u33 = 30 or 60;
            local Decal = v32.Slash1.Decal;
            task.spawn(function() -- Line: 85
                -- upvalues: NezukoSlash (copy), Decal (copy), u33 (ref)
                for _, v in NezukoSlash do
                    Decal.Texture = v;
                    task.wait(1 / u33);
                end;

                Decal.Transparency = 1;
            end);
            local NezukoSlash2 = u6.Animations.NezukoSlash;
            local u34 = 30 or 60;
            local Decal2 = v32.Slash2.Decal;
            task.spawn(function() -- Line: 85
                -- upvalues: NezukoSlash2 (copy), Decal2 (copy), u34 (ref)
                for _, v in NezukoSlash2 do
                    Decal2.Texture = v;
                    task.wait(1 / u34);
                end;

                Decal2.Transparency = 1;
            end);
            local NezukoSlash3 = u6.Animations.NezukoSlash;
            local u35 = 30 or 60;
            local Decal3 = v32.Slash3.Decal;
            task.spawn(function() -- Line: 85
                -- upvalues: NezukoSlash3 (copy), Decal3 (copy), u35 (ref)
                for _, v in NezukoSlash3 do
                    Decal3.Texture = v;
                    task.wait(1 / u35);
                end;

                Decal3.Transparency = 1;
            end);
            local v36 = script.NezukoSlash1:Clone();
            v36:PivotTo(HumanoidRootPart.CFrame * CFrame.new(-2.15863037109375, 1.6343369483947754, -0.750732421875) * CFrame.fromEulerAnglesYXZ(0.08203065395355225, 3.1171817779541016, -2.9184024333953857));
            v36.Parent = u1;
            DebrisModule:AddItem(v36, 1.5);
            EmitAllSpec(v36, 1);
            local NezukoSlash4 = u6.Animations.NezukoSlash;
            local u37 = 30 or 60;
            local Decal4 = v36.Slash1.Decal;
            task.spawn(function() -- Line: 85
                -- upvalues: NezukoSlash4 (copy), Decal4 (copy), u37 (ref)
                for _, v in NezukoSlash4 do
                    Decal4.Texture = v;
                    task.wait(1 / u37);
                end;

                Decal4.Transparency = 1;
            end);
            local NezukoSlash5 = u6.Animations.NezukoSlash;
            local u38 = 30 or 60;
            local Decal5 = v36.Slash2.Decal;
            task.spawn(function() -- Line: 85
                -- upvalues: NezukoSlash5 (copy), Decal5 (copy), u38 (ref)
                for _, v in NezukoSlash5 do
                    Decal5.Texture = v;
                    task.wait(1 / u38);
                end;

                Decal5.Transparency = 1;
            end);
            local NezukoSlash6 = u6.Animations.NezukoSlash;
            local u39 = 30 or 60;
            local Decal6 = v36.Slash3.Decal;
            task.spawn(function() -- Line: 85
                -- upvalues: NezukoSlash6 (copy), Decal6 (copy), u39 (ref)
                for _, v in NezukoSlash6 do
                    Decal6.Texture = v;
                    task.wait(1 / u39);
                end;

                Decal6.Transparency = 1;
            end);

            if Magnitude <= 50 then
                BlurEffect(0.1);

                return;
            end;
        else
            if p14 == "Jump" then
                local v40 = script.Jump:Clone();
                v40.CFrame = HumanoidRootPart.CFrame * CFrame.new(-0.100616455078125, -2.5, 0.5013885498046875);
                v40.Parent = u1;
                TokenKit.EmitAll(v40);
                DebrisModule:AddItem(v40, 6);
                Cam_Shaker(HumanoidRootPart.Position, {
                    FadeInTime = 0,
                    Frequency = 0.1,
                    Amplitude = 0.3,
                    SustainTime = 0.1,
                    FadeOutTime = 0.5,
                    RotationInfluence = Vector3.new(0.25, 0.25, 0.25),
                    PositionInfluence = Vector3.new(3.5, 3.5, 3.5)
                });

                return;
            end;

            if p14 == "Kick1" then
                local v41 = script.Kick1:Clone();
                v41:PivotTo(HumanoidRootPart.CFrame * CFrame.new(0.35980224609375, -0.7034642696380615, 1.76177978515625) * CFrame.fromEulerAnglesYXZ(-0.0575135312974453, -3.0886170864105225, 1.177432656288147));
                v41.Parent = u1;
                DebrisModule:AddItem(v41, 3);
                EmitAllSpec(v41, 1);
                local NezukoSlash = u6.Animations.NezukoSlash;
                local u42 = 30 or 60;
                local Decal = v41.Slash2.Decal;
                task.spawn(function() -- Line: 85
                    -- upvalues: NezukoSlash (copy), Decal (copy), u42 (ref)
                    for _, v in NezukoSlash do
                        Decal.Texture = v;
                        task.wait(1 / u42);
                    end;

                    Decal.Transparency = 1;
                end);

                return;
            end;

            if p14 == "Kick2" then
                local v43 = script.HandInirial:Clone();
                v43.CFrame = u15.CFrame;
                v43.Parent = u1;
                DebrisModule:AddItem(v43, 3);
                EmitAllSpec(v43, 1);
                Cam_Shaker(v43.Position, {
                    FadeInTime = 0.05,
                    Frequency = 0.1,
                    Amplitude = 0.3,
                    SustainTime = 0.1,
                    FadeOutTime = 0.5,
                    RotationInfluence = Vector3.new(0.25, 0.25, 0.25),
                    PositionInfluence = Vector3.new(1.5, 1.5, 1.5)
                });
                task.delay(0.2, function() -- Line: 278
                    -- upvalues: u15 (copy), u1 (ref), DebrisModule (ref), Toggle (ref), EmitAllSpec (ref)
                    local v44 = script.WindupSparkles:Clone();
                    v44.CFrame = u15.CFrame;
                    v44.Parent = u1;
                    DebrisModule:AddItem(v44, 3);
                    task.wait(0.2);
                    Toggle(v44, false);
                    task.wait(0.1);
                    EmitAllSpec(v44, 1);
                end);
                task.wait(0.6);

                if Magnitude <= 50 then
                    ImpactFrame(0.02);
                    BlurEffect(0.5, HumanoidRootPart);
                end;

                Cam_Shaker(HumanoidRootPart.Position, {
                    FadeInTime = 0,
                    Frequency = 0.1,
                    Amplitude = 0.1,
                    SustainTime = 3,
                    FadeOutTime = 0.5,
                    RotationInfluence = Vector3.new(0.25, 0.25, 0.25),
                    PositionInfluence = Vector3.new(2.5, 2.5, 2.5)
                });
                task.spawn(function() -- Line: 308
                    -- upvalues: u15 (copy), u1 (ref), DebrisModule (ref), TokenKit (ref), Cam_Shaker (ref), HumanoidRootPart (copy)
                    for i = 1, 5 do
                        local v45 = script.HitFXBigger:Clone();
                        v45:PivotTo(u15.CFrame);
                        v45.Parent = u1;
                        DebrisModule:AddItem(v45, 3);
                        TokenKit.EmitAll(v45);
                        Cam_Shaker(HumanoidRootPart.Position, {
                            FadeInTime = 0,
                            Frequency = 0.1,
                            Amplitude = 0.3,
                            SustainTime = 0.1,
                            FadeOutTime = 0.2,
                            RotationInfluence = Vector3.new(0.25, 0.25, 0.25),
                            PositionInfluence = Vector3.new(1.5, 1.5, 1.5)
                        });
                        task.wait(0.5);
                        local _ = i;
                    end;
                end);
                local v46 = script.FinalTornadoRevamp:Clone();
                v46:PivotTo(u15.CFrame * CFrame.new(0.814, -12, 1.259) * CFrame.Angles(3.142, -1.516, 1.571));
                v46.Parent = u1;
                Toggle(v46, true);
                local u47 = true;
                task.delay(3, function() -- Line: 336
                    -- upvalues: u47 (ref)
                    u47 = false;
                end);
                TokenKit.EmitAll(v46);
                local v48 = nil;

                while u47 do
                    v46.Part.CFrame = v46.Part.CFrame * CFrame.Angles(0.08726646259971647 * (v48 or 0.016) * 90, 0, 0);
                    v48 = task.wait(0.0025);
                end;

                local CFrame2 = u15.CFrame;
                local v49 = workspace:Raycast(CFrame2 * CFrame.new(0, 1, 0).Position, CFrame2.UpVector * -30, RaycastParams_new_ret);

                if v49 ~= nil and v49.Instance ~= nil then
                    local v50 = script.NezTornadoAfter:Clone();
                    v50.TopSurface = Enum.SurfaceType.Hinge;
                    v50.CFrame = CFrame.new(v49.Position, v49.Position + v49.Normal) * CFrame.new(0, 0, -0.1) * CFrame.Angles(1.5707963267948966, 0, 0);
                    v50.Parent = u1;
                    DebrisModule:AddItem(v50, 7);
                    EmitAllSpec(v50, 1);
                end;

                if Magnitude <= 50 then
                    ImpactFrame(0.02);
                    BlurEffect(0.5);
                end;

                Cam_Shaker(HumanoidRootPart.Position, {
                    FadeInTime = 0,
                    Frequency = 0.3,
                    Amplitude = 0.6,
                    SustainTime = 0.1,
                    FadeOutTime = 0.9,
                    RotationInfluence = Vector3.new(0.25, 0.25, 0.25),
                    PositionInfluence = Vector3.new(1.5, 1.5, 1.5)
                });
                local Descendants = v46:GetDescendants();

                for _, v in ipairs(Descendants) do
                    if v:IsA("Trail") then
                        TweenService:Create(v, TweenInfo.new(2), {
                            TextureLength = 0.1
                        }):Play();
                    end;
                end;

                task.wait();
                Toggle(v46, false);
                local Descendants2 = v46:GetDescendants();

                for _, v in ipairs(Descendants2) do
                    if v:IsA("MeshPart") then
                        TweenService:Create(v, TweenInfo.new(0.05), {
                            Size = Vector3.new(0.01, 0.01, 0.01)
                        }):Play();
                    end;
                end;

                DebrisModule:AddItem(v46, 3);

                return;
            end;

            if p14 == "Drag" then
                local u51 = true;
                local v52 = script.Finish:Clone();
                v52.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, -2.615440607070923, 2.89837646484375) * CFrame.fromEulerAnglesYXZ(-0, 3.1415927410125732, 0);
                v52.Parent = u1;
                Toggle(v52, true);
                DebrisModule:AddItem(v52, 6);
                local Weld = Instance.new("Weld");
                Weld.Part0 = HumanoidRootPart;
                Weld.Part1 = v52;
                Weld.Parent = HumanoidRootPart;
                Weld.C0 = CFrame.new(0, -2.615440607070923, 2.89837646484375) * CFrame.fromEulerAnglesYXZ(-0, 3.1415927410125732, 0);
                task.delay(0.5, function() -- Line: 496
                    -- upvalues: u51 (ref)
                    u51 = false;
                end);

                while u51 do
                    task.wait();
                end;

                Toggle(v52, false);

                return;
            end;

            if p14 == "HitFX" then
                local v53 = u15:FindFirstChild("UpperTorso") or (u15:FindFirstChild("Torso") or u15:FindFirstChild("HumanoidRootPart"));

                if v53 == nil then
                    return;
                end;

                local v54 = script.HitFX:Clone();
                v54.CFrame = v53.CFrame;
                v54.Parent = u1;
                game.Debris:AddItem(v54, 2);
                TokenKit.EmitAll(v54);
                Cam_Shaker(v54.Position, {
                    FadeInTime = 0.05,
                    Frequency = 0.1,
                    Amplitude = 0.2,
                    SustainTime = 0.1,
                    FadeOutTime = 0.5,
                    RotationInfluence = Vector3.new(0.25, 0.25, 0.25),
                    PositionInfluence = Vector3.new(1.5, 1.5, 1.5)
                });
            end;
        end;

        return;
    end;

    local v55 = script.Attempt:Clone();
    v55.Parent = HumanoidRootPart;
    v55:Play();
    DebrisModule:AddItem(v55, v55.TimeLength);
    local v56 = script.NezukoSlash1:Clone();
    v56:PivotTo(HumanoidRootPart.CFrame * CFrame.new(-0.31, -0.59, -0.39) * CFrame.fromEulerAnglesYXZ(0.498, 3.08, 1.37));
    v56.Parent = u1;
    DebrisModule:AddItem(v56, 1.5);
    EmitAllSpec(v56, 1);
    local NezukoSlash = u6.Animations.NezukoSlash;
    local u57 = 30 or 60;
    local Decal = v56.Slash1.Decal;
    task.spawn(function() -- Line: 85
        -- upvalues: NezukoSlash (copy), Decal (copy), u57 (ref)
        for _, v in NezukoSlash do
            Decal.Texture = v;
            task.wait(1 / u57);
        end;

        Decal.Transparency = 1;
    end);
    local NezukoSlash2 = u6.Animations.NezukoSlash;
    local u58 = 30 or 60;
    local Decal2 = v56.Slash2.Decal;
    task.spawn(function() -- Line: 85
        -- upvalues: NezukoSlash2 (copy), Decal2 (copy), u58 (ref)
        for _, v in NezukoSlash2 do
            Decal2.Texture = v;
            task.wait(1 / u58);
        end;

        Decal2.Transparency = 1;
    end);
    local NezukoSlash3 = u6.Animations.NezukoSlash;
    local u59 = 30 or 60;
    local Decal3 = v56.Slash3.Decal;
    task.spawn(function() -- Line: 85
        -- upvalues: NezukoSlash3 (copy), Decal3 (copy), u59 (ref)
        for _, v in NezukoSlash3 do
            Decal3.Texture = v;
            task.wait(1 / u59);
        end;

        Decal3.Transparency = 1;
    end);
    local v60 = script.ScratchMark:Clone();
    v60.CFrame = HumanoidRootPart.CFrame * CFrame.new(-5.18, -2.5, -5.9) * CFrame.fromEulerAnglesYXZ(-0, 2.4, 0);
    v60.Parent = u1;
    TokenKit.EmitAll(v60);
    DebrisModule:AddItem(v60, 1.5);
    local v61 = script.NezukoSlash1:Clone();
    v61:PivotTo(HumanoidRootPart.CFrame * CFrame.new(-0.27, -0.43, -0.43) * CFrame.fromEulerAnglesYXZ(0.34, -3.04, -1.35));
    v61.Parent = u1;
    DebrisModule:AddItem(v61, 1.5);
    EmitAllSpec(v61, 1);
    TokenKit.EmitAll(v61);
    local NezukoSlash4 = u6.Animations.NezukoSlash;
    local u62 = 30 or 60;
    local Decal4 = v61.Slash1.Decal;
    task.spawn(function() -- Line: 85
        -- upvalues: NezukoSlash4 (copy), Decal4 (copy), u62 (ref)
        for _, v in NezukoSlash4 do
            Decal4.Texture = v;
            task.wait(1 / u62);
        end;

        Decal4.Transparency = 1;
    end);
    local NezukoSlash5 = u6.Animations.NezukoSlash;
    local u63 = 30 or 60;
    local Decal5 = v61.Slash2.Decal;
    task.spawn(function() -- Line: 85
        -- upvalues: NezukoSlash5 (copy), Decal5 (copy), u63 (ref)
        for _, v in NezukoSlash5 do
            Decal5.Texture = v;
            task.wait(1 / u63);
        end;

        Decal5.Transparency = 1;
    end);
    local NezukoSlash6 = u6.Animations.NezukoSlash;
    local u64 = 30 or 60;
    local Decal6 = v61.Slash3.Decal;
    task.spawn(function() -- Line: 85
        -- upvalues: NezukoSlash6 (copy), Decal6 (copy), u64 (ref)
        for _, v in NezukoSlash6 do
            Decal6.Texture = v;
            task.wait(1 / u64);
        end;

        Decal6.Transparency = 1;
    end);
    local v65 = script.ScratchMark:Clone();
    v65.CFrame = HumanoidRootPart.CFrame * CFrame.new(3.82, -2.5, -5.9) * CFrame.fromEulerAnglesYXZ(-0, -2.06, 0);
    v65.Parent = u1;
    TokenKit.EmitAll(v65);
    DebrisModule:AddItem(v65, 1.5);
end;