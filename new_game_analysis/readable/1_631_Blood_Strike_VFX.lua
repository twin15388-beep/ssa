-- Decompiled with Potassium's decompiler.

game:GetService("Players");
local TweenService = game:GetService("TweenService");
game:GetService("RunService");
local CAM = game:GetService("ReplicatedStorage").CAM;
local Modules = CAM.Client.Modules;
local workspace_Debree = workspace.Debree;
local Assets = script:FindFirstChild("Assets");
local Sounds = script:FindFirstChild("Sounds");
local Ouwmit = require(CAM.Client.Modules.Effects.Ouwmit);
local Token = Modules.Effects.Token;
local DebrisModule = require(CAM.DebrisModule);
local Cam_Shaker = require(Modules.Effects.Cam_Shaker);
local CraterExtension = require(Modules.Effects.Craters.CraterExtension);
require(Modules.Effects.BoatTween);
local BezierCurve = require(Token.BezierCurve);
local TokenUtility = require(Token.TokenUtility);
require(Token.TokenKit);
local vfxUtility = require(game.ReplicatedStorage.CAM.Client.Modules.Effects.vfxUtility);
local _ = game.Players.LocalPlayer;
local workspace_CurrentCamera = workspace.CurrentCamera;
local u1 = {
    Min = {
        X = 5,
        Y = 5,
        Z = 5
    },
    Max = {
        X = 10,
        Y = 10,
        Z = 10
    }
};
local u2 = {
    Duration = 0.1,
    LookAt = true,
    EasingStyle = Enum.EasingStyle.Linear,
    EasingDirection = Enum.EasingDirection.InOut
};

local function createBezier(p3: userdata, p4: userdata) -- Line: 65
    -- upvalues: u1 (copy), TokenUtility (copy), BezierCurve (copy), u2 (copy)
    local Position = p4.Position;
    local Position2 = p3.Position;
    local Min = u1.Min;
    local Max = u1.Max;
    local v5 = TokenUtility.GetRandomNumber(Min.X, Max.X, true) * TokenUtility.GetRandomSign();
    local v6 = TokenUtility.GetRandomNumber(Min.Y, Max.Y, true) * TokenUtility.GetRandomSign();
    local v7 = TokenUtility.GetRandomNumber(Min.Z, Max.Z, true) * TokenUtility.GetRandomSign();
    local RandomNumber = TokenUtility.GetRandomNumber(0.4, 0.6, true);
    local CFrame_Angles_ret = CFrame.Angles(CFrame.lookAt(p4.Position, Position2):ToEulerAnglesXYZ());
    local v8 = CFrame.new(Position:Lerp(Position2, RandomNumber)) * CFrame_Angles_ret * CFrame.new(v5, v6, v7);
    BezierCurve.Play(p4, { Position, v8.Position, Position2 }, false, u2);
    p4.Transparency = 1;
    TokenUtility.DelayDestruction(0.5, p4);
end;

return function(p9: userdata, p10: string, p11: userdata) -- Line: 89
    -- upvalues: workspace_Debree (copy), workspace_CurrentCamera (copy), DebrisModule (copy), Assets (copy), vfxUtility (copy), Sounds (copy), createBezier (copy), Cam_Shaker (copy), CraterExtension (copy), TweenService (copy), Ouwmit (copy)
    local v12 = p9:FindFirstChild("HumanoidRootPart") or p9.PrimaryPart;
    p9:FindFirstChild("UpperTorso");
    local string_format_ret = string.format("%s Blood_Strike_Effects", p9.Name);
    local u13 = workspace_Debree:FindFirstChild(string_format_ret);

    if p10 ~= "Cancel" and (v12.Position - workspace_CurrentCamera.CFrame.Position).Magnitude > 250 then
        return;
    end;

    if (u13 == nil or u13.Parent == nil) and p10 ~= "Start" then
        return;
    end;

    if p10 == "Start" then
        if u13 ~= nil then
            u13:Destroy();
        end;

        u13 = Instance.new("Folder");
        u13.Name = string_format_ret;
        u13.Parent = workspace_Debree;
        DebrisModule:AddItem(u13, 5);
        local RightHand = p9:FindFirstChild("RightHand");

        if not RightHand then
            return;
        end;

        local u14 = Assets.HandInirial:Clone();
        u14.Parent = u13;
        u14.CFrame = RightHand.CFrame;
        vfxUtility.EmitAll(u14:GetDescendants());
        DebrisModule:AddItem(u14, 2);
        vfxUtility.PlaySound(Sounds, "Start", v12, true);
        task.spawn(function() -- Line: 127
            -- upvalues: Assets (ref), u14 (copy), u13 (ref), createBezier (ref), RightHand (copy)
            for i = 1, 8 do
                local v15 = Assets.trail:Clone();
                local Position = u14.Position;
                local math_random_ret = math.random(-10, 10);
                local math_random_ret2 = math.random(-10, 10);
                v15.Position = Position + Vector3.new(math_random_ret, math_random_ret2, math.random(-10, 10));
                v15.Parent = u13;
                createBezier(RightHand, v15);
                task.wait(0.01);
                local _ = i;
            end;
        end);
        task.wait(0.1);
        local v16 = Assets.FireHand:Clone();
        v16.Parent = u13;
        v16:PivotTo(RightHand.CFrame);
        vfxUtility.EnableAll(v16, true);
        local Weld = Instance.new("Weld");
        Weld.Part0 = RightHand;
        Weld.Part1 = v16;
        Weld.Parent = RightHand;
    elseif u13 == nil then
        return;
    end;

    if p10 == "Dash" then
        local v17 = Assets.DashnHit:Clone();
        v17.CFrame = v12.CFrame * CFrame.new(-0.1171875, -2.9046151638031006, 0.09063720703125);
        v17.Parent = u13;
        vfxUtility.EmitAll(v17:GetDescendants());
        DebrisModule:AddItem(v17, 6);
        Cam_Shaker(v17.Position, {
            FadeInTime = 0,
            Frequency = 0.2,
            Amplitude = 0.5,
            SustainTime = 0.1,
            FadeOutTime = 0.5,
            RotationInfluence = Vector3.new(0.25, 0.25, 0.25),
            PositionInfluence = Vector3.new(3.5, 3.5, 3.5)
        });
        CraterExtension.Ground(v12.Position, 7, Vector3.new(1.5, 1.5, 2), nil, 2, false, 2);
        local v18 = Assets.RushLines:Clone();
        v18.CFrame = v12.CFrame * CFrame.new(0.078369140625, -0.3877224922180176, 1.115966796875) * CFrame.fromEulerAnglesYXZ(-0, 3.1415927410125732, 0);
        v18.Parent = u13;
        vfxUtility.EnableAll(v18, true);
        vfxUtility.WeldConstraint(v12, v18);
        DebrisModule:AddItem(v18, 1.5);
        local v19 = Assets.Finish:Clone();
        v19.CFrame = v12.CFrame * CFrame.new(0, -2.615440607070923, 2.89837646484375) * CFrame.fromEulerAnglesYXZ(-0, 3.1415927410125732, 0);
        v19.Parent = u13;
        vfxUtility.EnableAll(v19, true);
        DebrisModule:AddItem(v19, 1.5);
        vfxUtility.WeldConstraint(v12, v19);
    elseif p10 == "Release" then
        local FireHand = u13:WaitForChild("FireHand", 0.25);
        local RushLines = u13:FindFirstChild("RushLines");
        local Finish = u13:FindFirstChild("Finish");

        if FireHand then
            vfxUtility.EnableAll(FireHand, false);
            DebrisModule:AddItem(FireHand, 2);
        end;

        if RushLines then
            vfxUtility.EnableAll(RushLines, false);
        end;

        if Finish then
            vfxUtility.EnableAll(Finish, false);
        end;

        vfxUtility.PlaySound(Sounds, "Punch", v12, true);
        local v20 = Assets.Impact:Clone();
        v20.CFrame = v12.CFrame * CFrame.new(-0.2056884765625, -0.15644621849060059, -3.944091796875) * CFrame.fromEulerAnglesYXZ(-0, -1.5707963705062866, 1.5707963705062866);
        v20.Parent = u13;
        vfxUtility.EmitAll(v20:GetDescendants());
        DebrisModule:AddItem(v20, 6);
        TweenService:Create(v20.SurfaceLight, TweenInfo.new(0.3), {
            Brightness = 0
        }):Play();
        TweenService:Create(v20.PointLight, TweenInfo.new(1), {
            Brightness = 0
        }):Play();
        Cam_Shaker(v20.Position, {
            FadeInTime = 0,
            Frequency = 0.2,
            Amplitude = 0.75,
            SustainTime = 0.1,
            FadeOutTime = 0.3,
            RotationInfluence = Vector3.new(0.25, 0.25, 0.25),
            PositionInfluence = Vector3.new(3.5, 3.5, 3.5)
        });
        local v21 = Assets.DashnHit:Clone();
        v21.CFrame = v12.CFrame * CFrame.new(-0.1171875, -2.9046151638031006, 0.09063720703125);
        v21.Parent = u13;
        vfxUtility.EmitAll(v21:GetDescendants());
        DebrisModule:AddItem(v21, 6);
    elseif p10 == "Impact2" then
        local v22 = Assets.Impact2:Clone();
        v22:PivotTo(v12.CFrame * CFrame.new(-0.2056884765625, -0.15644621849060059, -3.944091796875) * CFrame.fromEulerAnglesYXZ(-0, -1.5707963705062866, 1.5707963705062866));
        v22.Parent = u13;
        Ouwmit.Emit(v22);
        DebrisModule:AddItem(v22, 6);
        TweenService:Create(v22.Impact2.SurfaceLight, TweenInfo.new(0.3), {
            Brightness = 0
        }):Play();
        TweenService:Create(v22.Impact2.PointLight, TweenInfo.new(1), {
            Brightness = 0
        }):Play();
        Cam_Shaker(v22.Impact2.Position, {
            FadeInTime = 0,
            Frequency = 0.15,
            Amplitude = 0.85,
            SustainTime = 0.1,
            FadeOutTime = 0.3,
            RotationInfluence = Vector3.new(0.25, 0.25, 0.25),
            PositionInfluence = Vector3.new(3.5, 3.5, 3.5)
        });
        local v23 = Assets.DashnHit:Clone();
        v23.CFrame = v12.CFrame * CFrame.new(-0.1171875, -2.9046151638031006, 0.09063720703125);
        v23.Parent = u13;
        vfxUtility.EmitAll(v23:GetDescendants());
        DebrisModule:AddItem(v23, 6);
    elseif p10 == "Victim" then
        local v24 = Assets.VictimHit:Clone();
        v24:PivotTo(p11:GetPivot());
        v24.Parent = u13;
        vfxUtility.EmitAll(v24:GetDescendants());
        DebrisModule:AddItem(v24, 3);
    elseif p10 == "Cancel" then
        u13:Destroy();
    end;
end;