-- Decompiled with Potassium's decompiler.

game:GetService("Players");
local TweenService = game:GetService("TweenService");
game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ReplicatedStorage2 = game:GetService("ReplicatedStorage");
local CAM = ReplicatedStorage.CAM;
local Modules = CAM.Client.Modules;
local workspace_Debree = workspace.Debree;
local Assets = script:FindFirstChild("Assets");
local Sounds = script:FindFirstChild("Sounds");
local Ouwmit = require(CAM.Client.Modules.Effects.Ouwmit);
local Token = Modules.Effects.Token;
local OuwCraters = require(CAM.Client.Modules.Effects.Craters.OuwCraters);
local DebrisModule = require(CAM.DebrisModule);
local Cam_Shaker = require(Modules.Effects.Cam_Shaker);
require(Modules.Effects.Craters.CraterExtension);
local vfxUtility = require(game.ReplicatedStorage.CAM.Client.Modules.Effects.vfxUtility);
require(Modules.Effects.BoatTween);
local BezierCurve = require(Token.BezierCurve);
local TokenUtility = require(Token.TokenUtility);
local TokenKit = require(Token.TokenKit);
local _ = game.Players.LocalPlayer;
local workspace_CurrentCamera = workspace.CurrentCamera;
local RaycastHelper = require(ReplicatedStorage2.CAM.Global.RaycastHelper);
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

local function createBezier(p3: userdata, p4: userdata) -- Line: 68
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

local _ = { CFrame.new(0.3939208984375, 0, -6.660888671875), CFrame.new(0.022705078125, 0, -17.94342041015625), CFrame.new(0.35882568359375, 0, -35.28997802734375) };
local u9 = { CFrame.fromEulerAnglesYXZ(-0, -1.5707963705062866, 0), CFrame.fromEulerAnglesYXZ(-0, -1.5707963705062866, 0), CFrame.fromEulerAnglesYXZ(-0, -1.5707963705062866, 0) };

return function(p10: userdata, p11: string, u12: any, u13: any, u14: any) -- Line: 104
    -- upvalues: workspace_Debree (copy), workspace_CurrentCamera (copy), DebrisModule (copy), Assets (copy), vfxUtility (copy), Sounds (copy), createBezier (copy), u9 (copy), Ouwmit (copy), TweenService (copy), Cam_Shaker (copy), OuwCraters (copy), TokenKit (copy), RaycastHelper (copy)
    local v15 = p10:FindFirstChild("HumanoidRootPart") or p10.PrimaryPart;
    p10:FindFirstChild("UpperTorso");
    local string_format_ret = string.format("%s Blood_Tiles_Effects", p10.Name);
    local u16 = workspace_Debree:FindFirstChild(string_format_ret);

    if p11 == "Cancel" or (v15.Position - workspace_CurrentCamera.CFrame.Position).Magnitude <= 250 then
        if (u16 == nil or u16.Parent == nil) and p11 ~= "Start" then
            return;
        end;

        if p11 == "Start" then
            if u16 ~= nil then
                u16:Destroy();
            end;

            local Folder = Instance.new("Folder");
            Folder.Name = string_format_ret;
            Folder.Parent = workspace_Debree;
            DebrisModule:AddItem(Folder, 5);
            local RightHand = p10:FindFirstChild("RightHand");

            if RightHand == nil then
                return;
            end;

            local u17 = Assets.HandInirial:Clone();
            u17.Parent = Folder;
            u17.CFrame = RightHand.CFrame;
            vfxUtility.EmitAll(u17:GetDescendants());
            DebrisModule:AddItem(u17, 2);
            vfxUtility.PlaySound(Sounds, "Start", v15, true);
            task.spawn(function() -- Line: 150
                -- upvalues: Assets (ref), u17 (copy), Folder (ref), createBezier (ref), RightHand (copy)
                for i = 1, 8 do
                    local v18 = Assets.trail:Clone();
                    local Position = u17.Position;
                    local math_random_ret = math.random(-10, 10);
                    local math_random_ret2 = math.random(-10, 10);
                    v18.Position = Position + Vector3.new(math_random_ret, math_random_ret2, math.random(-10, 10));
                    v18.Parent = Folder;
                    createBezier(RightHand, v18);
                    task.wait(0.01);
                    local _ = i;
                end;
            end);
            task.wait(0.1);
            local v19 = Assets.FireHand:Clone();
            v19.Parent = Folder;
            v19:PivotTo(RightHand.CFrame);
            vfxUtility.EnableAll(v19, true);
            local Weld = Instance.new("Weld");
            Weld.Part0 = RightHand;
            Weld.Part1 = v19;
            Weld.Parent = RightHand;

            while v19:IsDescendantOf(Folder) and v19.Name ~= "--" do
                task.wait(0.06666666666666667);
            end;

            vfxUtility.EnableAll(v19, false);
        elseif p11 == "Release" then
            local FireHand = u16:FindFirstChild("FireHand");

            if FireHand then
                FireHand.Name = "--";
                DebrisModule:AddItem(FireHand, 2);
            end;

            if u16 == nil or not u16:IsDescendantOf(workspace_Debree) then
                return;
            end;

            local function createCrater(p20: number) -- Line: 194
                -- upvalues: Assets (ref), u16 (ref), u13 (copy), u9 (ref), u14 (copy), vfxUtility (ref), Sounds (ref), u12 (copy), Ouwmit (ref), DebrisModule (ref), TweenService (ref)
                local v21 = Assets[`NezGroundCrater{p20}`]:Clone();
                v21.Parent = u16;
                v21.CFrame = u13 and CFrame.new(u13.Position, u13.Position + u13.Normal) * u9[p20] * CFrame.Angles(0, 0, 1.5707963267948966) or u14;
                vfxUtility.PlaySound(Sounds, "PS2bloodCHAINEXPLexpl" .. u12, v21, true);
                Ouwmit.Emit(v21);
                DebrisModule:AddItem(v21, 6);
                TweenService:Create(v21.PointLightAtt.PointLight, TweenInfo.new(1), {
                    Brightness = 0
                }):Play();

                return v21;
            end;

            if u12 == 1 then
                local u22 = createCrater(1);
                Cam_Shaker(u22.Position, {
                    FadeInTime = 0,
                    Frequency = 0.1,
                    Amplitude = 0.5,
                    SustainTime = 0.1,
                    FadeOutTime = 0.3,
                    RotationInfluence = Vector3.new(0.25, 0.25, 0.25),
                    PositionInfluence = Vector3.new(3.5, 3.5, 3.5)
                });
                OuwCraters.Scales({
                    Radius = 5,
                    Count = 5,
                    ScaleMult = 0.4,
                    OffsetMargin = 4,
                    Center = u22
                });
                OuwCraters.Scales({
                    Radius = 8,
                    Count = 7,
                    ScaleMult = 0.7,
                    OffsetMargin = 7,
                    Center = u22
                });
                task.spawn(function() -- Line: 239
                    -- upvalues: TokenKit (ref), u22 (copy), RaycastHelper (ref)
                    TokenKit.GroundRocks({
                        InnerRadius = 5,
                        OuterRadius = 10,
                        CF = u22.CFrame,
                        Velocity = {
                            Min = 5,
                            Max = 10
                        },
                        Size = {
                            Min = 0.4,
                            Max = 0.6
                        },
                        RayParams = RaycastHelper.Crater
                    });
                end);
            elseif u12 == 2 then
                if u16 == nil or not u16:IsDescendantOf(workspace_Debree) then
                    return;
                end;

                local u23 = createCrater(2);
                Cam_Shaker(u23.Position, {
                    FadeInTime = 0,
                    Frequency = 0.1,
                    Amplitude = 0.5,
                    SustainTime = 0.1,
                    FadeOutTime = 0.3,
                    RotationInfluence = Vector3.new(0.25, 0.25, 0.25),
                    PositionInfluence = Vector3.new(3.5, 3.5, 3.5)
                });
                OuwCraters.Scales({
                    Radius = 11,
                    Count = 8,
                    ScaleMult = 0.9,
                    OffsetMargin = 4,
                    Center = u23
                });
                OuwCraters.Scales({
                    Radius = 12,
                    Count = 12,
                    ScaleMult = 1.1,
                    OffsetMargin = 7,
                    Center = u23
                });
                TweenService:Create(u23.PointLightAtt.PointLight, TweenInfo.new(1), {
                    Brightness = 0
                }):Play();
                task.spawn(function() -- Line: 283
                    -- upvalues: TokenKit (ref), u23 (copy), RaycastHelper (ref)
                    TokenKit.GroundRocks({
                        InnerRadius = 8,
                        OuterRadius = 13,
                        CF = u23.CFrame,
                        Velocity = {
                            Min = 10,
                            Max = 20
                        },
                        Size = {
                            Min = 1,
                            Max = 2
                        },
                        RayParams = RaycastHelper.Crater
                    });
                end);
            elseif u12 == 3 then
                if u16 == nil or not u16:IsDescendantOf(workspace_Debree) then
                    return;
                end;

                local u24 = createCrater(3);
                Cam_Shaker(u24.Position, {
                    FadeInTime = 0,
                    Frequency = 0.1,
                    Amplitude = 1,
                    SustainTime = 0.2,
                    FadeOutTime = 0.5,
                    RotationInfluence = Vector3.new(0.25, 0.25, 0.25),
                    PositionInfluence = Vector3.new(3.5, 3.5, 3.5)
                });
                OuwCraters.Scales({
                    Radius = 19,
                    Count = 15,
                    ScaleMult = 0.9,
                    OffsetMargin = 4,
                    Center = u24
                });
                OuwCraters.Scales({
                    Radius = 22,
                    Count = 18,
                    ScaleMult = 1.1,
                    OffsetMargin = 7,
                    Center = u24
                });
                TweenService:Create(u24.PointLightAtt.PointLight, TweenInfo.new(1), {
                    Brightness = 0
                }):Play();
                task.spawn(function() -- Line: 327
                    -- upvalues: TokenKit (ref), u24 (copy), RaycastHelper (ref)
                    TokenKit.GroundRocks({
                        InnerRadius = 19,
                        OuterRadius = 21,
                        CF = u24.CFrame,
                        Velocity = {
                            Min = 20,
                            Max = 40
                        },
                        Size = {
                            Min = 1,
                            Max = 3
                        },
                        RayParams = RaycastHelper.Crater
                    });
                end);
            end;
        elseif p11 == "Cancel" then
            local Release = v15:FindFirstChild("Release");

            if Release and Release.ClassName == "Sound" then
                Release:Destroy();
            end;

            u16:Destroy();
        end;

        return;
    end;

    local Release = v15:FindFirstChild("Release");

    if Release and Release.ClassName == "Sound" then
        Release:Destroy();
    end;

    if u16 ~= nil then
        u16:Destroy();
    end;
end;