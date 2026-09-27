-- Decompiled with Potassium's decompiler.

game:GetService("Players");
game:GetService("TweenService");
game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local workspace_Debree = workspace.Debree;
local SkillAssets = script:FindFirstChild("SkillAssets");
local Sounds = script:FindFirstChild("Sounds");
script:FindFirstChild("Rigs");
local CAM = ReplicatedStorage.CAM;
local Modules = CAM.Client.Modules;
local DebrisModule = require(CAM.DebrisModule);
local Cam_Shaker = require(Modules.Effects.Cam_Shaker);
require(Modules.Effects.Craters.CraterExtension);
local TokenKit = require(Modules.Effects.Token.TokenKit);
local Ouwmit = require(ReplicatedStorage.CAM.Client.Modules.Effects.Ouwmit);
local vfxUtility = require(game.ReplicatedStorage.CAM.Client.Modules.Effects.vfxUtility);
local RaycastHelper = require(ReplicatedStorage.CAM.Global.RaycastHelper);
local OuwCraters = require(ReplicatedStorage.CAM.Client.Modules.Effects.Craters.OuwCraters);
local _ = game.Players.LocalPlayer;
local workspace_CurrentCamera = workspace.CurrentCamera;
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterDescendantsInstances = { workspace.Map };
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Include;

return function(p1: userdata, p2: string, p3: userdata) -- Line: 48
    -- upvalues: workspace_CurrentCamera (copy), workspace_Debree (copy), DebrisModule (copy), SkillAssets (copy), RaycastHelper (copy), vfxUtility (copy), Ouwmit (copy), Cam_Shaker (copy), Sounds (copy), RaycastParams_new_ret (copy), OuwCraters (copy), TokenKit (copy)
    if p1 == nil then
        return;
    end;

    local u4 = p1:FindFirstChild("HumanoidRootPart") or p1.PrimaryPart;

    if u4 == nil or p2 ~= "Cancel" and (u4.Position - workspace_CurrentCamera.CFrame.Position).Magnitude > 250 then
        return;
    end;

    p1:FindFirstChild("UpperTorso");
    local string_format_ret = string.format("%s Obi_Barrage_Effects", p1.Name);
    local u5 = workspace_Debree:FindFirstChild(string_format_ret);

    if p2 == "Start" then
        if u5 ~= nil then
            u5:Destroy();
        end;

        u5 = Instance.new("Folder");
        u5.Name = string_format_ret;
        u5.Parent = workspace_Debree;
        DebrisModule:AddItem(u5, 12);
        local v6 = SkillAssets.Jump:Clone();
        v6.Parent = u5;
        v6:PivotTo(u4.CFrame);
        DebrisModule:AddItem(v6, 3);
        local v7 = workspace:Raycast(u4.CFrame.Position + Vector3.new(0, 5, 0), Vector3.new(-0, -15, -0), RaycastHelper.Crater);
        local v8 = v7 and vfxUtility.GetDustColorSettings(v7.Instance) or nil;
        Ouwmit.Emit(v6, v8);
        Cam_Shaker(u4.Position, {
            FadeInTime = 0,
            Frequency = 0.1,
            Amplitude = 0.3,
            SustainTime = 0.1,
            FadeOutTime = 0.5,
            RotationInfluence = Vector3.new(0.25, 0.25, 0.25),
            PositionInfluence = Vector3.new(3.5, 3.5, 3.5)
        });
    elseif u5 == nil then
        return;
    end;

    if p2 == "Barrage" then
        local v9 = SkillAssets.initial:Clone();
        v9.Parent = u5;
        v9.CFrame = u4.CFrame * CFrame.new(-0.1961669921875, -0.6954622268676758, -2.12188720703125) * CFrame.fromEulerAnglesYXZ(-0, -1.5707963705062866, 2.755462884902954);
        vfxUtility.EnableAll(v9, true);
        local Weld = Instance.new("Weld");
        Weld.Part0 = u4;
        Weld.Part1 = v9;
        Weld.Parent = u4;
        Weld.C0 = CFrame.new(-0.1961669921875, -0.6954622268676758, -2.12188720703125) * CFrame.fromEulerAnglesYXZ(-0, -1.5707963705062866, 2.755462884902954);
        local u10 = true;
        local u11 = vfxUtility.PlaySound(Sounds, "PS2FleshManiObiBRRGswingloop", u4, false);
        u5:SetAttribute("Active", true);
        v9.AncestryChanged:Connect(function(p12, p13) -- Line: 114
            -- upvalues: u10 (ref), u11 (copy), vfxUtility (ref), Sounds (ref), u4 (copy)
            if not p13 then
                u10 = false;
                u11:Stop();
                vfxUtility.PlaySound(Sounds, "PS2FleshManiObiBRRGbrrgSTOP", u4, true);
            end;
        end);
        task.spawn(function() -- Line: 122
            -- upvalues: u10 (ref), SkillAssets (ref), u5 (ref), u4 (copy), RaycastParams_new_ret (ref), DebrisModule (ref), RaycastHelper (ref), vfxUtility (ref), Ouwmit (ref), Sounds (ref), Cam_Shaker (ref)
            while u10 do
                local v14 = SkillAssets.Mini:Clone();
                v14.Parent = u5;
                v14.CFrame = u4.CFrame * CFrame.new(math.random(-5, 5), -9.596467018127441, math.random(-10, -2)) * CFrame.fromEulerAnglesYXZ(-0, -1.5707963705062866, 0);
                local v15 = workspace:Raycast(v14.Position + Vector3.new(0, 1, 0), Vector3.new(-0, -2, -0), RaycastParams_new_ret);

                if v15 then
                    local v16 = SkillAssets:FindFirstChild("ImpactGround"):Clone();
                    v16.Parent = u5;
                    v16.CFrame = CFrame.new(v15.Position, v15.Position - v15.Normal) * CFrame.Angles(1.5707963267948966, 0, 0);
                    v16.CFrame = v16.CFrame * CFrame.new(0, v16.Size.Y, 0);
                    DebrisModule:AddItem(v16, 6);
                    local v17 = workspace:Raycast(v16.CFrame.Position + Vector3.new(0, 5, 0), Vector3.new(-0, -15, -0), RaycastHelper.Crater);
                    local v18 = v17 and vfxUtility.GetDustColorSettings(v17.Instance) or nil;
                    Ouwmit.Emit(v16, v18);
                    vfxUtility.PlaySound(Sounds, "PS2FleshManiObiBRRGgroundimp" .. tostring(math.random(1, 2)), u4, true);
                end;

                vfxUtility.EmitAll(v14);
                DebrisModule:AddItem(v14, 3.5);
                Cam_Shaker(v14.Position, {
                    FadeInTime = 0,
                    Frequency = 0.05,
                    Amplitude = 0.05,
                    SustainTime = 0.1,
                    FadeOutTime = 0.1,
                    RotationInfluence = Vector3.new(0.25, 0.25, 0.25),
                    PositionInfluence = Vector3.new(3.5, 3.5, 3.5)
                });
                task.wait(0.05);
            end;
        end);
    end;

    if p2 == "Final" then
        u5.Name = "--";
        u5:SetAttribute("Active");
        local initial = u5:FindFirstChild("initial");

        if initial then
            initial:Destroy();
        end;

        local v19 = SkillAssets.Thrust:Clone();
        v19.Parent = u5;
        v19:PivotTo(u4.CFrame);
        DebrisModule:AddItem(v19, 3);
        local v20 = workspace:Raycast(u4.CFrame.Position + Vector3.new(0, 5, 0), Vector3.new(-0, -15, -0), RaycastHelper.Crater);
        local v21 = v20 and vfxUtility.GetDustColorSettings(v20.Instance) or nil;
        Ouwmit.Emit(v19, v21);
        vfxUtility.PlaySound(Sounds, "PS2FleshManiObiBRRGlaunch", u4, true);
        task.wait(0.1);
        local v22 = SkillAssets.Final:Clone();
        v22.Parent = u5;
        v22.CFrame = u4.CFrame * CFrame.new(0.77081298828125, -10.596467018127441, -6.23773193359375) * CFrame.fromEulerAnglesYXZ(-0, -1.5707963705062866, 0);
        vfxUtility.PlaySound(Sounds, "PS2FleshManiObiBRRGfinale", v22, true);
        local v23 = workspace:Raycast(v22.Position + Vector3.new(0, 5, 0), Vector3.new(-0, -10, -0), RaycastParams_new_ret);

        if v23 then
            local v24 = SkillAssets:FindFirstChild("FinalGround"):Clone();
            v24.Parent = u5;
            v24.CFrame = CFrame.new(v23.Position, v23.Position - v23.Normal) * CFrame.Angles(1.5707963267948966, 0, 0);
            v24.CFrame = v24.CFrame * CFrame.new(0, v24.Size.Y, 0);
            DebrisModule:AddItem(v24, 6);
            local v25 = workspace:Raycast(v24.CFrame.Position + Vector3.new(0, 5, 0), Vector3.new(-0, -15, -0), RaycastHelper.Crater);
            local v26 = v25 and vfxUtility.GetDustColorSettings(v25.Instance) or nil;
            Ouwmit.Emit(v24, v26);
        end;

        local v27 = workspace:Raycast(v22.CFrame.Position + Vector3.new(0, 5, 0), Vector3.new(-0, -15, -0), RaycastHelper.Crater);
        local v28 = v27 and vfxUtility.GetDustColorSettings(v27.Instance) or nil;
        Ouwmit.Emit(v22, v28);
        DebrisModule:AddItem(v22, 3);
        OuwCraters.Scales({
            Duration = 2.5,
            Radius = 12,
            ScaleMult = 0.8,
            Center = v22.CFrame
        });
        task.spawn(TokenKit.GroundRocks, {
            InnerRadius = 19,
            OuterRadius = 21,
            CF = v22.CFrame,
            Velocity = {
                Min = 20,
                Max = 40
            },
            Size = {
                Min = 1,
                Max = 3
            }
        });
    end;

    local v29 = p2 == "Cancel" and workspace_Debree:FindFirstChild(string_format_ret);

    if v29 then
        local initial = v29:FindFirstChild("initial");

        if initial then
            initial:Destroy();
        end;

        v29.Name = "_";
        v29:SetAttribute("Active", false);
        DebrisModule:AddItem(v29, 2);
    end;
end;