-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("Players");
local RunService = game:GetService("RunService");
require(ReplicatedStorage.CAM.Global.ParticleTween);
local Bezier = require(ReplicatedStorage.CAM.Client.Modules.Effects.Bezier);
local vfxUtility = require(game.ReplicatedStorage.CAM.Client.Modules.Effects.vfxUtility);
local DebrisModule = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("DebrisModule"));
local u1 = workspace.Debree:FindFirstChild(game.Players.LocalPlayer.Name .. "\'s effects debree thing213asdasdasdasd");

if u1 == nil then
    u1 = Instance.new("Folder", workspace.Debree);
    u1.Name = game.Players.LocalPlayer.Name .. "\'s effects debree thing213asdasdasdasd";
end;

local Assets = script:FindFirstChild("Assets");
local Sounds = script:FindFirstChild("Sounds");

local function TrailWidthTweenDown(p2: any, u3: number) -- Line: 20
    -- upvalues: RunService (copy)
    for _, descendant in p2:GetDescendants() do
        if descendant.ClassName == "Trail" then
            local u4 = descendant;
            local v5 = {};
            local v6 = {};

            for _, v in descendant.WidthScale.Keypoints do
                table.insert(v5, NumberSequenceKeypoint.new(v.Time, v.Value, v.Envelope));
            end;

            local NumberSequence_new_ret = NumberSequence.new(v5);

            for _, v in ipairs(NumberSequence_new_ret.Keypoints) do
                local math_clamp_ret = math.clamp(v.Value + 1, 0, 1);
                table.insert(v6, NumberSequenceKeypoint.new(v.Time, math_clamp_ret));
            end;

            local Time = NumberSequence_new_ret.Keypoints[#NumberSequence_new_ret.Keypoints].Time;
            local u7 = tick();
            local u8 = 0;
            local u9 = nil;
            u9 = RunService.Heartbeat:Connect(function() -- Line: 44
                -- upvalues: u8 (ref), u7 (copy), Time (copy), u3 (copy), NumberSequence_new_ret (copy), u4 (copy), u9 (ref)
                u8 = tick() - u7;
                local math_min_ret = math.min(Time, u8);
                local v10 = math_min_ret / Time / u3;
                local v11 = {};

                for _, v in ipairs(NumberSequence_new_ret.Keypoints) do
                    table.insert(v11, NumberSequenceKeypoint.new(v.Time, v.Value + (0 - v.Value) * v10));
                end;

                u4.WidthScale = NumberSequence.new(v11);

                if Time <= math_min_ret then
                    u9:Disconnect();
                end;
            end);
        end;
    end;
end;

local AuraEffects = require(script.Parent.AuraEffects);
local Cam_Shaker = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Client"):WaitForChild("Modules"):WaitForChild("Effects"):WaitForChild("Cam_Shaker"));

return function(p12: userdata, p13: any, p14: vector, p15: vector, p16: vector) -- Line: 74
    -- upvalues: AuraEffects (copy), Assets (copy), u1 (ref), vfxUtility (copy), DebrisModule (copy), Sounds (copy), Cam_Shaker (copy), TweenService (copy), RunService (copy), Bezier (copy)
    if p12 == nil or p13 == nil then
        return;
    end;

    local HumanoidRootPart = p12:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart == nil then
        return;
    end;

    if (HumanoidRootPart.Position - workspace.CurrentCamera.CFrame.Position).Magnitude >= 250 and p13 ~= "Cancel" then
        return;
    end;

    p12:FindFirstChild("RightHand");
    p12:FindFirstChild("LeftHand");
    string.format("%s VenomFangsKatanaEffects", p12.Name);

    if p13 == "Start" then
        AuraEffects.TurnOnAura(p12);

        return;
    end;

    if p13 == "Cancel" then
        AuraEffects.TurnOffAura(p12);

        return;
    end;

    if p13 ~= "Teleport" then
        if p13 ~= "Slash" then
            if p13 == "Success" then
                AuraEffects.TurnOnAura(p12);
                local v17 = Assets.Snake:Clone();
                v17.Cube.CFrame = HumanoidRootPart.CFrame * CFrame.new(3.95166015625, -2.8153228759765625, 9.244232177734375) * CFrame.fromEulerAnglesYXZ(0.09455974400043488, -2.851161003112793, -0.0006289904122240841);
                vfxUtility.WeldConstraint(HumanoidRootPart, v17.PrimaryPart);
                v17.Parent = u1;
                v17.Cube.Transparency = 1;
                v17.AnimationController:LoadAnimation(script.Animations.Snake):Play();
                local v18 = Assets["Snake Head"]:Clone();
                v18:PivotTo(HumanoidRootPart.CFrame * CFrame.new(0, -2, 0));
                vfxUtility.WeldConstraint(HumanoidRootPart, v18.PrimaryPart);
                v18.Parent = u1;
                local v19 = v18.AnimationController:LoadAnimation(script.Animations["Skeleton Snake"]);
                v19:Play();
                v19:AdjustSpeed(1);
                task.wait(0.38333333333333336);
                local v20 = Assets.SwordThrust:Clone();
                v20.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 0, -3);
                v20.Parent = u1;
                vfxUtility.EmitAll(v20);
                DebrisModule:AddItem(v20, 2);

                for _, child in v18:GetChildren() do
                    if child:IsA("MeshPart") then
                        TweenService:Create(child, TweenInfo.new(0.2), {
                            Transparency = 1
                        }):Play();
                    end;
                end;

                DebrisModule:AddItem(v18, 2);
                Cam_Shaker(HumanoidRootPart.Position, "tinyshake_preset");
                TweenService:Create(v17.Cube, TweenInfo.new(0.45), {
                    Transparency = 0
                }):Play();
                vfxUtility.PlaySound(Sounds, "PS2snakeVFsnakebite", HumanoidRootPart, true);
                task.wait(0.45);
                local v21 = Assets.SnakeBiteHitEffect:Clone();
                v21.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 0, -5);
                v21.Parent = u1;
                vfxUtility.EmitAll(v21);
                DebrisModule:AddItem(v21, 3);
                Cam_Shaker(HumanoidRootPart.Position, "activate_shake");
                TweenService:Create(v17.Cube, TweenInfo.new(0.4), {
                    Transparency = 1
                }):Play();
                DebrisModule:AddItem(v17, 1);
                AuraEffects.TurnOffAura(p12);
            end;

            return;
        end;

        local v22 = Assets.Slash:Clone();
        v22:PivotTo(HumanoidRootPart.CFrame);
        v22.Parent = u1;
        vfxUtility.EmitAll(v22);
        DebrisModule:AddItem(v22, 2);
        vfxUtility.PlaySound(Sounds, "PS2snakeVFslashup", v22.PrimaryPart, true);

        for _, descendant in v22:GetDescendants() do
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
                task.delay(descendant:GetAttribute("EmitDuration"), function() -- Line: 131
                    -- upvalues: TweenService (ref), descendant (copy)
                    TweenService:Create(descendant, TweenInfo.new(0.3), {
                        Width0 = 0,
                        Width1 = 0
                    }):Play();
                end);
            end;
        end;

        Cam_Shaker(HumanoidRootPart.Position, "activate_shake");

        for i = 1, 6 do
            local u23 = Assets.SnakeTrail:Clone();
            u23.Parent = u1;
            vfxUtility.EnableAll(u23, true);
            local math_random_ret = math.random(5, 7);
            local u24 = 0;
            local u25 = HumanoidRootPart.CFrame * CFrame.new(math.random(-2, 2), -3, math.random(-8, -3));
            local u26 = HumanoidRootPart.CFrame * CFrame.new(math.random(-5, 5), math.random(8, 12), 3);
            local u27 = HumanoidRootPart.CFrame * CFrame.new(math.random(-6, 6), 4, math.random(-13, -9));
            local u28 = HumanoidRootPart.CFrame * CFrame.new(math.random(-6, 6), 8, math.random(-8, -5));
            local u29 = nil;
            u29 = RunService.Heartbeat:Connect(function(p30) -- Line: 154
                -- upvalues: u24 (ref), math_random_ret (copy), Bezier (ref), u25 (copy), u27 (copy), u28 (copy), u26 (copy), u29 (ref), u23 (copy), DebrisModule (ref)
                u24 = u24 + p30 * math_random_ret;
                local v31 = Bezier.CubicBezier(u24, u25.Position, u27.Position, u28.Position, u26.Position);
                local v32 = Bezier.CubicBezier(u24 + 0.01, u25.Position, u27.Position, u28.Position, u26.Position);

                if u24 < 1 then
                    u23.CFrame = CFrame.new(v31, v32);

                    return;
                end;

                u29:Disconnect();
                u23.Position = u26.Position;
                DebrisModule:AddItem(u23, 2);
            end);
            local _ = i;
        end;

        return;
    end;

    AuraEffects.TurnOffAura(p12);
    local CFrame_lookAlong_ret = CFrame.lookAlong(p14, p16);
    local CFrame_new_ret = CFrame.new(p15, p16);
    local v33 = Assets.Teleport:Clone();
    v33:PivotTo(CFrame_lookAlong_ret);
    v33.Parent = u1;
    vfxUtility.EmitAll(v33);
    DebrisModule:AddItem(v33, 2);
    local v34 = Assets.Teleport:Clone();
    v34:PivotTo(CFrame_new_ret);
    v34.Parent = u1;
    vfxUtility.EmitAll(v34);
    DebrisModule:AddItem(v34, 2);
    vfxUtility.PlaySound(Sounds, "PS2snakeVFtele1", v33.PrimaryPart, true);
    vfxUtility.PlaySound(Sounds, "PS2snakeVFtele2", v34.PrimaryPart, true);
    Cam_Shaker(CFrame_new_ret.Position, "tinyshake_preset");
end;