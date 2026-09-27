-- Decompiled with Potassium's decompiler.

game:GetService("CollectionService");
game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local ImpactFrames = require(ReplicatedStorage.CAM.Client.Modules.Effects.ImpactFrames);
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
local LocalPlayer = Players.LocalPlayer;

local function lerp(p2, p3, p4) -- Line: 23
    return p2 + (p3 - p2) * p4;
end;

local function QuadBezier(p5, p6, p7, p8) -- Line: 27
    local v9 = p6 + (p7 - p6) * p5;

    return v9 + (p7 + (p8 - p7) * p5 - v9) * p5;
end;

local function TransparencyTween(u10: any, u11: userdata, u12: number) -- Line: 34
    -- upvalues: RunService (copy)
    local u13 = {};

    for _, v in ipairs(u11.Keypoints) do
        local math_clamp_ret = math.clamp(v.Value + 1, 0, 1);
        table.insert(u13, NumberSequenceKeypoint.new(v.Time, math_clamp_ret));
    end;

    local Time = u11.Keypoints[#u11.Keypoints].Time;
    local u14 = tick();
    local u15 = 0;
    local u16 = nil;
    u16 = RunService.Heartbeat:Connect(function() -- Line: 48
        -- upvalues: u15 (ref), u14 (copy), Time (copy), u12 (copy), u11 (copy), u13 (copy), u10 (copy), u16 (ref)
        u15 = tick() - u14;
        local math_min_ret = math.min(Time, u15);
        local v17 = math_min_ret / Time * u12;
        local v18 = {};

        for i, v in ipairs(u11.Keypoints) do
            table.insert(v18, NumberSequenceKeypoint.new(v.Time, v.Value + (u13[i].Value - v.Value) * v17));
        end;

        u10.Transparency = NumberSequence.new(v18);

        if Time <= math_min_ret then
            u16:Disconnect();
        end;
    end);
end;

local Cam_Shaker = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Client"):WaitForChild("Modules"):WaitForChild("Effects"):WaitForChild("Cam_Shaker"));

return function(u19: userdata, p20: any, u21: any) -- Line: 75
    -- upvalues: vfxUtility (copy), Sounds (copy), LocalPlayer (copy), Assets (copy), u1 (ref), DebrisModule (copy), ImpactFrames (copy), TransparencyTween (copy), Cam_Shaker (copy), RunService (copy), Bezier (copy)
    if u19 == nil or p20 == nil then
        return;
    end;

    local HumanoidRootPart = u19:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart == nil then
        return;
    end;

    if (HumanoidRootPart.Position - workspace.CurrentCamera.CFrame.Position).Magnitude >= 250 and p20 ~= "Cancel" then
        return;
    end;

    local UpperTorso = u19:FindFirstChild("UpperTorso");
    local LeftHand = u19:FindFirstChild("LeftHand");

    if p20 ~= "Success" then
        if p20 ~= "Throw" then
            if p20 == "Comeback" then
                for _, v in pairs({ "Left", "Right" }) do
                    task.spawn(function() -- Line: 309
                        -- upvalues: HumanoidRootPart (copy), Assets (ref), u1 (ref), DebrisModule (ref), vfxUtility (ref), u21 (copy), v (copy), RunService (ref), Bezier (ref), Sounds (ref)
                        local CFrame_lookAlong_ret = CFrame.lookAlong(HumanoidRootPart.Position, HumanoidRootPart.CFrame.LookVector * -1);
                        local u22 = Assets.Sickles:Clone();
                        u22.Parent = u1;
                        u22.CFrame = CFrame_lookAlong_ret;
                        DebrisModule:AddItem(u22, 3);
                        vfxUtility.EmitAll(u22);
                        local u23 = 0;
                        local u24 = u21;
                        local u25 = CFrame.new((CFrame_lookAlong_ret.Position + u24) / 2, CFrame_lookAlong_ret.LookVector) * CFrame.new(v == "Right" and 15 or -15, 0, 0);
                        local u26 = false;
                        local u27 = nil;
                        u27 = RunService.Heartbeat:Connect(function(p28) -- Line: 330
                            -- upvalues: u23 (ref), CFrame_lookAlong_ret (ref), HumanoidRootPart (ref), Bezier (ref), u24 (copy), u25 (copy), u26 (ref), vfxUtility (ref), u22 (copy), u27 (ref), DebrisModule (ref)
                            u23 = u23 + p28 * 2.857142857142857;
                            CFrame_lookAlong_ret = CFrame.lookAlong(HumanoidRootPart.Position, HumanoidRootPart.CFrame.LookVector * -1);
                            local v29 = Bezier.QuadBezier(u23, u24, u25.Position, CFrame_lookAlong_ret.Position);
                            local v30 = Bezier.QuadBezier(u23 + 0.01, u24, u25.Position, CFrame_lookAlong_ret.Position);

                            if u23 > 0.7 and not u26 then
                                u26 = true;
                                vfxUtility.EnableAll(u22, false);
                            end;

                            if u23 < 1 then
                                u22.CFrame = CFrame.new(v29, v30);

                                return;
                            end;

                            u27:Disconnect();
                            u22.CFrame = CFrame_lookAlong_ret;
                            DebrisModule:AddItem(u22, 2);
                            vfxUtility.EnableAll(u22, false);
                        end);
                        task.delay(0.35, function() -- Line: 351
                            -- upvalues: Assets (ref), HumanoidRootPart (ref), u1 (ref), vfxUtility (ref), DebrisModule (ref), Sounds (ref)
                            local v31 = Assets.Startup:Clone();
                            v31.CFrame = HumanoidRootPart.CFrame;
                            v31.Parent = u1;
                            vfxUtility.EmitAll(v31);
                            DebrisModule:AddItem(v31, 1.25);
                            vfxUtility.PlaySound(Sounds, "PS2bloodsickBENDreturn", HumanoidRootPart, true);
                        end);
                    end);
                end;
            end;

            return;
        end;

        local v32 = Assets.ThrowEffect:Clone();
        v32.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 0, -3) * CFrame.Angles(-1.5707963267948966, 0, 0);
        v32.Parent = u1;
        vfxUtility.EmitAll(v32);
        DebrisModule:AddItem(v32, 2);
        vfxUtility.PlaySound(Sounds, "PS2bloodsickCIRCULARSLASHESthrow", v32, true);
        Cam_Shaker(HumanoidRootPart.Position, "activate_shake");

        for _, v in pairs({ "Left", "Right" }) do
            task.spawn(function() -- Line: 264
                -- upvalues: Assets (ref), u1 (ref), HumanoidRootPart (copy), DebrisModule (ref), u21 (copy), v (copy), RunService (ref), Bezier (ref), vfxUtility (ref)
                local u33 = Assets.Sickles:Clone();
                u33.Parent = u1;
                u33.CFrame = HumanoidRootPart.CFrame;
                DebrisModule:AddItem(u33, 3);
                local u34 = 0;
                local CFrame2 = HumanoidRootPart.CFrame;
                local CFrame_lookAlong_ret = CFrame.lookAlong(u21, HumanoidRootPart.CFrame.LookVector);
                local u35 = CFrame.new((CFrame_lookAlong_ret.Position + HumanoidRootPart.Position) / 2, CFrame_lookAlong_ret.LookVector) * CFrame.new(v == "Right" and 15 or -15, 0, 0);
                local u36 = false;
                local u37 = nil;
                u37 = RunService.Heartbeat:Connect(function(p38) -- Line: 283
                    -- upvalues: u34 (ref), Bezier (ref), CFrame2 (copy), u35 (copy), CFrame_lookAlong_ret (copy), u36 (ref), vfxUtility (ref), u33 (copy), u37 (ref), DebrisModule (ref)
                    u34 = u34 + p38 * 2.2222222222222223;
                    local v39 = Bezier.QuadBezier(u34, CFrame2.Position, u35.Position, CFrame_lookAlong_ret.Position);
                    local v40 = Bezier.QuadBezier(u34 + 0.01, CFrame2.Position, u35.Position, CFrame_lookAlong_ret.Position);

                    if u34 > 0.7 and not u36 then
                        u36 = true;
                        vfxUtility.EnableAll(u33, false);
                    end;

                    if u34 < 1 then
                        u33.CFrame = CFrame.new(v39, v40);

                        return;
                    end;

                    u37:Disconnect();
                    u33.CFrame = CFrame_lookAlong_ret;
                    DebrisModule:AddItem(u33, 2);
                    vfxUtility.EnableAll(u33, false);
                end);
            end);
        end;

        return;
    end;

    local PlaySound = vfxUtility.PlaySound;
    local v41;

    if table.find(u21, LocalPlayer.Character) then
        v41 = workspace.CurrentCamera or HumanoidRootPart;
    else
        v41 = HumanoidRootPart;
    end;

    PlaySound(Sounds, "PS2bloodsickCIRCULARSLASHEScine", v41, true);
    local u42 = Assets.Bullet:Clone();
    u42.CFrame = UpperTorso.CFrame;
    u42.Parent = u1;
    vfxUtility.EnableAll(u42, true);
    local WeldConstraint = Instance.new("WeldConstraint");
    WeldConstraint.Part0 = u42;
    WeldConstraint.Part1 = UpperTorso;
    WeldConstraint.Parent = u42;
    local u43 = Assets.UltVFX:Clone();
    u43:PivotTo(HumanoidRootPart.CFrame * CFrame.new(0, -3.192424774169922, -11.68400764465332) * CFrame.Angles(0, 3.141592653589793, 0));
    vfxUtility.WeldConstraint(HumanoidRootPart, u43.PrimaryPart);
    u43.Parent = u1;
    task.delay(0.45, function() -- Line: 104
        -- upvalues: vfxUtility (ref), u43 (copy)
        vfxUtility.EmitAll(u43.Drift1);
    end);
    task.delay(0.68, function() -- Line: 108
        -- upvalues: Assets (ref), UpperTorso (copy), u1 (ref), vfxUtility (ref), u19 (copy), DebrisModule (ref)
        local v44 = Assets.Wind:Clone();
        v44.CFrame = UpperTorso.CFrame;
        v44.Parent = u1;
        vfxUtility.EnableAll(v44, true);
        local WeldConstraint2 = Instance.new("WeldConstraint");
        local UpperTorso2 = u19:FindFirstChild("UpperTorso");
        WeldConstraint2.Part0 = v44;
        WeldConstraint2.Part1 = UpperTorso2;
        WeldConstraint2.Parent = v44;
        task.wait(0.5);
        vfxUtility.EnableAll(v44, false);
        DebrisModule:AddItem(v44, 2);
    end);
    task.delay(0.866, function() -- Line: 124
        -- upvalues: vfxUtility (ref), u43 (copy), u42 (copy), Assets (ref), LeftHand (copy), u1 (ref), LocalPlayer (ref), u21 (copy), ImpactFrames (ref), TransparencyTween (ref), DebrisModule (ref)
        vfxUtility.EmitAll(u43.Drift2);
        task.wait(0.3);
        vfxUtility.EnableAll(u42, false);
        local v45 = Assets.HandVFX:Clone();
        v45.CFrame = LeftHand.CFrame;
        v45.Parent = u1;
        local WeldConstraint2 = Instance.new("WeldConstraint");
        WeldConstraint2.Part0 = v45;
        WeldConstraint2.Part1 = LeftHand;
        WeldConstraint2.Parent = v45;
        task.wait(0.3);

        if LocalPlayer.Character and table.find(u21, LocalPlayer.Character) then
            ImpactFrames.PlaySet({
                FrameRate = 0.016666666666666666,
                FramesSetName = "BloodSickles_Part1"
            });
        end;

        for _, descendant in v45:GetDescendants() do
            if descendant:IsA("Beam") then
                TransparencyTween(descendant, NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(0.0261519, 1),
                    NumberSequenceKeypoint.new(0.420922, 0.51875),
                    NumberSequenceKeypoint.new(0.803238, 0.95),
                    NumberSequenceKeypoint.new(0.858032, 0.975),
                    NumberSequenceKeypoint.new(1, 1)
                }), 2);
            end;
        end;

        DebrisModule:AddItem(v45, 1);
        task.wait(0.4);
        vfxUtility.EnableAll(u42, true);
    end);
    task.delay(2.2, function() -- Line: 182
        -- upvalues: vfxUtility (ref), u43 (copy)
        vfxUtility.EmitAll(u43["First Slash"]);
    end);
    task.delay(2.25, function() -- Line: 186
        -- upvalues: vfxUtility (ref), u43 (copy)
        vfxUtility.EmitAll(u43.GroundLand);
    end);
    task.delay(2.85, function() -- Line: 190
        -- upvalues: vfxUtility (ref), u43 (copy)
        vfxUtility.EmitAll(u43["Second Slash"]);
    end);
    task.delay(2.8, function() -- Line: 194
        -- upvalues: vfxUtility (ref), u43 (copy)
        vfxUtility.EmitAll(u43.Drift3);
    end);
    task.delay(3.2659, function() -- Line: 198
        -- upvalues: vfxUtility (ref), u43 (copy)
        vfxUtility.EmitAll(u43.Drift4);
    end);
    task.delay(3.417, function() -- Line: 202
        -- upvalues: vfxUtility (ref), u43 (copy)
        vfxUtility.EnableAll(u43["Third Slash ( Enable )"], true);
        task.wait(0.566);
        vfxUtility.EnableAll(u43["Third Slash ( Enable )"], false);
    end);
    task.delay(3.983, function() -- Line: 210
        -- upvalues: vfxUtility (ref), u43 (copy)
        vfxUtility.EmitAll(u43.Drift5);
    end);
    task.delay(4.667, function() -- Line: 214
        -- upvalues: vfxUtility (ref), u43 (copy)
        vfxUtility.EnableAll(u43["Ground ( Enable )"], true);
        task.delay(0.3, function() -- Line: 217
            -- upvalues: vfxUtility (ref), u43 (ref)
            vfxUtility.EnableAll(u43["Ground ( Enable )"], false);
        end);
    end);
    task.delay(5.2, function() -- Line: 222
        -- upvalues: vfxUtility (ref), u43 (copy), LocalPlayer (ref), u21 (copy), ImpactFrames (ref)
        vfxUtility.EmitAll(u43["Final Slash"]);

        if LocalPlayer.Character and table.find(u21, LocalPlayer.Character) then
            ImpactFrames.PlaySet({
                FrameRate = 0.01818181818181818,
                FramesSetName = "BloodSickles_Part2"
            });
        end;
    end);
    task.delay(5.82, function() -- Line: 243
        -- upvalues: DebrisModule (ref), u43 (copy), vfxUtility (ref), u42 (copy)
        DebrisModule:AddItem(u43, 1);
        vfxUtility.EnableAll(u42, false);
        DebrisModule:AddItem(u42, 3);
    end);
end;