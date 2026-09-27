-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");
game:GetService("ReplicatedStorage");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.CAM.Client.Modules.Effects.Craters.CraterHandler);
script:FindFirstChild("Assets");
local _ = workspace.Debree;
script:FindFirstChild("Sounds");
require(game.ReplicatedStorage.CAM.Client.Modules.Effects.vfxUtility);
local DebrisModule = require(game.ReplicatedStorage.CAM.DebrisModule);
local TweenInfo_new_ret = TweenInfo.new(0.085);

local function Random_Number(p1, p2) -- Line: 27
    return Random.new():NextNumber(p1, p2);
end;

local Ouwmit = require(ReplicatedStorage.CAM.Client.Modules.Effects.Ouwmit);
local RaycastHelper = require(ReplicatedStorage.CAM.Global.RaycastHelper);
local OuwCraters = require(ReplicatedStorage.CAM.Client.Modules.Effects.Craters.OuwCraters);
local Cam_Shaker = require(ReplicatedStorage.CAM.Client.Modules.Effects.Cam_Shaker);
local TweenInfo_new_ret2 = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0);
local TweenInfo_new_ret3 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0);

local function LTN() -- Line: 37
    -- upvalues: TweenService (copy), TweenInfo_new_ret2 (copy), TweenInfo_new_ret3 (copy), DebrisModule (copy)
    local v3 = script.NewAssets.ColorCorrection:Clone();
    v3.Parent = workspace.Camera;
    TweenService:Create(v3, TweenInfo_new_ret2, {
        TintColor = Color3.fromRGB(255, 255, 255)
    }):Play();
    TweenService:Create(v3, TweenInfo_new_ret3, {
        Brightness = 0,
        Contrast = 0,
        Saturation = 0
    }):Play();
    DebrisModule:AddItem(v3, 0.2);
end;

return function(p4: userdata, p5: any, p6: any) -- Line: 44
    -- upvalues: DebrisModule (copy), RaycastHelper (copy), Ouwmit (copy), TweenService (copy), TweenInfo_new_ret (copy), Cam_Shaker (copy), OuwCraters (copy), LTN (copy)
    local HumanoidRootPart = p4:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local v7 = `{script.Name}-{p4.Name}`;

    if p5 ~= "Cancel" and (HumanoidRootPart.Position - workspace.CurrentCamera.CFrame.Position).Magnitude > 250 then
        return;
    end;

    local v8 = workspace.Debree:FindFirstChild(v7);

    if p5 ~= "Dash1" and (p5 ~= "Dash2" and p5 ~= "Dash3") then
        if p5 == "Downslam" then
            if v8 == nil then
                return;
            end;

            local Trail = v8:FindFirstChild("Trail");

            if Trail == nil then
                Trail = script.NewAssets.Trail:Clone();
                Trail.Parent = v8;
            end;

            Trail.CFrame = CFrame.new(Trail.Position, p6.Position);
            TweenService:Create(Trail, TweenInfo_new_ret, {
                CFrame = Trail.CFrame * CFrame.new(0, 0, -vector.magnitude(Trail.Position - p6.Position))
            }):Play();
            local v9 = script.NewAssets.ThunderBolt:Clone();
            v9:PivotTo(CFrame.new(p6.Position, Trail.Position) * CFrame.Angles(0, 3.141592653589793, 0));
            v9.Parent = v8;
            local v10 = workspace:Raycast(HumanoidRootPart.Position, HumanoidRootPart.CFrame.upVector * -30, RaycastHelper.Crater);
            local v11;

            if v10 == nil or v10.Instance == nil then
                v11 = nil;
            else
                local v12 = CFrame.new(v10.Position, v10.Position + v10.Normal) * CFrame.Angles(-1.5707963267948966, 0, 0) * CFrame.new(0, 0, 0);
                v9.SlashVFXEmit.Startup.CFrame = v12;
                v9.SlashVFXEmit.GroundFX.CFrame = v12;
                v11 = v10.Instance.Color;
            end;

            Ouwmit.Emit(v9, v11 ~= nil and ({
                Color = v11,
                ColorWhitelist = { "raycastdust", "Rocks", "Dust" }
            } or nil) or nil);
            OuwCraters.Scales({
                Duration = 1.5,
                Count = 10,
                ScaleMult = 1,
                Radius = 14,
                Center = HumanoidRootPart.CFrame
            });
            OuwCraters.Scales({
                Duration = 2,
                Count = 10,
                ScaleMult = 2,
                Radius = 20,
                Center = HumanoidRootPart.CFrame
            });

            if p4 == game.Players.LocalPlayer.Character or vector.magnitude(workspace.CurrentCamera.CFrame.Position - p6.Position) < 30 then
                LTN();
            end;

            Cam_Shaker(HumanoidRootPart.Position, {
                FadeInTime = 0,
                Frequency = 0.1,
                Amplitude = 0.75,
                SustainTime = 0.14,
                FadeOutTime = 0.5,
                RotationInfluence = Vector3.new(0.25, 0.25, 0.25),
                PositionInfluence = Vector3.new(3.5, 3.5, 3.5)
            });
            local v13 = script.Sounds.PS2thunderbreathTBdownslam:Clone();
            v13.Parent = v9.SlashVFXEmit.Startup;
            v13:Play();
            v8.Name = "--";
        end;

        return;
    end;

    if p5 == "Dash1" then
        if v8 ~= nil then
            v8:Destroy();
        end;

        v8 = Instance.new("Folder");
        v8.Name = v7;
        v8.Parent = workspace.Debree;
        DebrisModule:AddItem(v8, 4);
        local v14 = script.NewAssets.Startup:Clone();
        v14:PivotTo(HumanoidRootPart.CFrame * CFrame.new(0, -1.8, 0));
        v14.Parent = v8;
        local v15 = workspace:Raycast(HumanoidRootPart.Position, HumanoidRootPart.CFrame.upVector * -30, RaycastHelper.Crater);
        local v16;

        if v15 == nil or v15.Instance == nil then
            v16 = nil;
        else
            local v17 = CFrame.new(v15.Position, v15.Position + v15.Normal) * CFrame.Angles(-1.5707963267948966, 0, 0) * CFrame.new(0, 1, 0);
            v14.Startup.CFrame = v17;
            v14.GroundFX.CFrame = v17;
            v16 = v15.Instance.Color;
        end;

        Ouwmit.Emit(v14, v16 ~= nil and ({
            Color = v16,
            ColorWhitelist = { "raycastdust", "Rocks", "Dust" }
        } or nil) or nil);
    end;

    if v8 == nil then
        return;
    end;

    local v18 = p6[1];
    local v19 = p6[2];
    local v20 = p6[3];
    local _ = p6[4];
    local v21 = script.NewAssets[p5]:Clone();
    v21.CFrame = CFrame.new(v19.Position, v18.Position) * CFrame.Angles(3.141592653589793, 0, 0);
    v21.Parent = v8;
    Ouwmit.Emit(v21);
    local v22 = script.Sounds.PS2thunderbreathTBdash:Clone();
    v22.Parent = v21;
    v22:Play();
    local Trail = v8:FindFirstChild("Trail");

    if Trail == nil then
        Trail = script.NewAssets.Trail:Clone();
        Trail.Parent = v8;
    end;

    Trail.CFrame = CFrame.new(v18.Position, v19.Position);
    TweenService:Create(Trail, TweenInfo_new_ret, {
        CFrame = Trail.CFrame * CFrame.new(0, 0, -v20)
    }):Play();
    Cam_Shaker(HumanoidRootPart.Position, "tinyshake_less_aggresive_preset");
end;