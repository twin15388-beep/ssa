-- Decompiled with Potassium's decompiler.

game:GetService("Players");
local TweenService = game:GetService("TweenService");
game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local workspace_Debree = workspace.Debree;
local Assets = script:FindFirstChild("Assets");
local Sounds = script:FindFirstChild("Sounds");
script:FindFirstChild("Rigs");
local CAM = ReplicatedStorage.CAM;
local Modules = CAM.Client.Modules;
local DebrisModule = require(CAM.DebrisModule);
local Cam_Shaker = require(Modules.Effects.Cam_Shaker);
require(Modules.Effects.Craters.CraterExtension);
local TokenKit = require(Modules.Effects.Token.TokenKit);
local RaycastHelper = require(ReplicatedStorage.CAM.Global.RaycastHelper);
require(ReplicatedStorage.CAM.Client.Modules.Effects.Craters.OuwCraters);
local Ouwmit = require(ReplicatedStorage.CAM.Client.Modules.Effects.Ouwmit);
local vfxUtility = require(game.ReplicatedStorage.CAM.Client.Modules.Effects.vfxUtility);
local _ = game.Players.LocalPlayer;
local workspace_CurrentCamera = workspace.CurrentCamera;
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterDescendantsInstances = { workspace.Map };
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Include;

local function PlaySlash(u1, u2, p3) -- Line: 46
    local u4 = p3 or 60;
    task.spawn(function() -- Line: 48
    end);
    task.spawn(function() -- Line: 51
        -- upvalues: u2 (copy), u1 (copy), u4 (ref)
        for _, v in u2 do
            u1.Decal.Texture = v;
            task.wait(1 / u4);
        end;
    end);
end;

local TweenInfo_new_ret = TweenInfo.new(0.5);

return function(p5: userdata, p6: string, p7: boolean) -- Line: 61
    -- upvalues: workspace_CurrentCamera (copy), workspace_Debree (copy), DebrisModule (copy), Assets (copy), vfxUtility (copy), Sounds (copy), TweenService (copy), Ouwmit (copy), RaycastHelper (copy), TweenInfo_new_ret (copy), Cam_Shaker (copy), TokenKit (copy)
    if p5 == nil then
        return;
    end;

    local HumanoidRootPart = p5:FindFirstChild("HumanoidRootPart");
    local UpperTorso = p5:FindFirstChild("UpperTorso");

    if HumanoidRootPart == nil or UpperTorso == nil then
        return;
    end;

    if not table.find({ "Cancel" }, p6) and (HumanoidRootPart.Position - workspace_CurrentCamera.CFrame.Position).Magnitude > 250 then
        return;
    end;

    local string_format_ret = string.format("%s Obi_Charge_Effects", p5.Name);
    local u8 = p5:FindFirstChild("Accessories") and p5:FindFirstChild("Accessories"):FindFirstChild("Ribbons");
    local u9 = workspace_Debree:FindFirstChild(string_format_ret);

    if p6 == "Start" then
        if u9 ~= nil then
            u9:Destroy();
        end;

        u9 = Instance.new("Folder");
        u9.Name = string_format_ret;
        u9.Parent = workspace.Debree;
        DebrisModule:AddItem(u9, 12);
        u9:SetAttribute("Active", true);
        local v10 = Assets.SkillInitialFX:Clone();
        v10.Parent = u9;
        v10.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, -1, 0);
        vfxUtility.EmitAll(v10:GetDescendants());
        DebrisModule:AddItem(v10, 6);
        vfxUtility.PlaySound(Sounds, "PS2FLESHMANIspinbombSTART", v10, true);
        task.delay(0.1, function() -- Line: 105
            -- upvalues: u8 (copy), Assets (ref), vfxUtility (ref), DebrisModule (ref), u9 (ref), TweenService (ref)
            if not u8 then
                return;
            end;

            local Descendants = u8:GetDescendants();

            for _, v in ipairs(Descendants) do
                if v:IsA("Bone") then
                    local v11 = Assets.Thingies.ParticleEmitter:Clone();
                    v11.Parent = v;
                    vfxUtility.EnableAll(v11, true);
                    DebrisModule:AddItem(v11, 10);
                end;
            end;

            u9.AttributeChanged:Wait();

            if not (u8 and u8:IsDescendantOf(workspace)) then
                return;
            end;

            local v12 = Assets.Thingies.Highlight:Clone();
            v12.Parent = u8;
            task.wait(0.1);
            TweenService:Create(v12, TweenInfo.new(1), {
                OutlineTransparency = 1
            }):Play();
            DebrisModule:AddItem(v12, 1);
            local Descendants2 = u8:GetDescendants();

            for _, v in ipairs(Descendants2) do
                if v:IsA("ParticleEmitter") then
                    v.Enabled = false;
                    DebrisModule:AddItem(v, 1);
                end;
            end;
        end);
        task.wait(0.35);

        if not u9:GetAttribute("Active") then
            return;
        end;

        local v13 = Assets.Jump:Clone();
        v13.Parent = u9;
        v13.CFrame = HumanoidRootPart.CFrame * CFrame.new(-0.100616455078125, -2.5, 0.5013885498046875);
        vfxUtility.EmitAll(v13);
        DebrisModule:AddItem(v13, 6);
        local v14 = Assets.NewStuff.Jump:Clone();
        v14.Parent = workspace_Debree;
        v14:PivotTo(HumanoidRootPart.CFrame);
        local v15 = Assets.NewStuff["Side Lines Screen FX"]:Clone();
        v15.Parent = workspace_Debree;
        Ouwmit.Emit(v15, {
            Owner = p5
        });
        DebrisModule:AddItem(v15, 3);
        local v16 = workspace:Raycast(HumanoidRootPart.CFrame.Position + Vector3.new(0, 5, 0), Vector3.new(-0, -15, -0), RaycastHelper.Crater);
        local v17 = v16 and vfxUtility.GetDustColorSettings(v16.Instance) or nil;
        Ouwmit.Emit(v14, v17);
        DebrisModule:AddItem(v14, 4);
        task.delay(1, function() -- Line: 165
            -- upvalues: u9 (ref), vfxUtility (ref), Sounds (ref), HumanoidRootPart (copy), Assets (ref), UpperTorso (copy), DebrisModule (ref), workspace_Debree (ref), RaycastHelper (ref), Ouwmit (ref), TweenInfo_new_ret (ref), TweenService (ref)
            if not u9:GetAttribute("Active") then
                return;
            end;

            vfxUtility.PlaySound(Sounds, "PS2FLESHMANIspinbombBOOST", HumanoidRootPart, true);
            local v18 = Assets.InitialSpin.locked:Clone();
            v18.Parent = UpperTorso;
            vfxUtility.EmitAll(v18);
            DebrisModule:AddItem(v18, 1);
            local v19 = Assets.NewStuff.AirDash:Clone();
            v19.Parent = workspace_Debree;
            v19:PivotTo(HumanoidRootPart.CFrame);
            local v20 = workspace:Raycast(HumanoidRootPart.CFrame.Position + Vector3.new(0, 5, 0), Vector3.new(-0, -15, -0), RaycastHelper.Crater);
            local v21 = v20 and vfxUtility.GetDustColorSettings(v20.Instance) or nil;
            Ouwmit.Emit(v19, v21);
            DebrisModule:AddItem(v19, 4);
            task.wait(0.2);

            if not u9:GetAttribute("Active") then
                return;
            end;

            vfxUtility.PlaySound(Sounds, "PS2FLESHMANIspinbombSPINSTART", HumanoidRootPart, true);
            local u22 = Assets.Vfx:Clone();
            u22.Parent = u9;
            u22:PivotTo(HumanoidRootPart.CFrame);
            vfxUtility.EnableAll(u22, true);
            local Weld = Instance.new("Weld");
            Weld.Part0 = HumanoidRootPart;
            Weld.Part1 = u22.PrimaryPart;
            Weld.Parent = HumanoidRootPart;
            DebrisModule:AddItem(u22, 9);
            task.delay(1, function() -- Line: 205
                -- upvalues: u22 (copy), u9 (ref), vfxUtility (ref), Sounds (ref), HumanoidRootPart (ref), DebrisModule (ref), TweenInfo_new_ret (ref), TweenService (ref)
                if not ((u22 or u9) and u9:GetAttribute("Active")) then
                    return;
                end;

                local v23 = vfxUtility.PlaySound(Sounds, "PS2FLESHMANIspinbombLOOP", HumanoidRootPart, false);
                v23.Parent = u22;
                DebrisModule:AddItem(v23, 8);
                u9.AttributeChanged:Wait();
                DebrisModule:AddItem(v23, TweenInfo_new_ret.Time);
                TweenService:Create(v23, TweenInfo_new_ret, {
                    Volume = 0
                }):Play();
            end);
        end);
        Cam_Shaker(HumanoidRootPart.Position, {
            FadeInTime = 0,
            Frequency = 0.1,
            Amplitude = 0.3,
            SustainTime = 0.1,
            FadeOutTime = 0.5,
            RotationInfluence = Vector3.new(0.25, 0.25, 0.25),
            PositionInfluence = Vector3.new(3.5, 3.5, 3.5)
        });
    elseif u9 == nil then
        return;
    end;

    if p6 == "Hit" then
        local v24 = Assets.Hitfx:Clone();
        v24.Parent = u9;
        v24.CFrame = HumanoidRootPart.CFrame;
        vfxUtility.EmitAll(v24:GetDescendants());
        DebrisModule:AddItem(v24, 3);
        Cam_Shaker(HumanoidRootPart.Position, {
            FadeInTime = 0,
            Frequency = 0.05,
            Amplitude = 0.02,
            SustainTime = 0.1,
            FadeOutTime = 0.1,
            RotationInfluence = Vector3.new(0.25, 0.25, 0.25),
            PositionInfluence = Vector3.new(3.5, 3.5, 3.5)
        });
        vfxUtility.PlaySound(Sounds, "Punched5", HumanoidRootPart, true);
    elseif p6 == "Charge" then
        local v25 = Assets.AmpedCharge:Clone();
        v25.Parent = u9;
        v25.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, -2, 0);
        vfxUtility.EmitAll(v25:GetDescendants());
        DebrisModule:AddItem(v25, 3);
    elseif p6 == "Final" then
        if HumanoidRootPart == nil or (HumanoidRootPart.Parent == nil or (u9 == nil or u9.Parent == nil)) then
            return;
        end;

        u9.Name = "_";
        u9:SetAttribute("Active", false);
        vfxUtility.EnableAll(u9, false);
        DebrisModule:AddItem(u9, 5);
        task.wait(0.5);
        local v26 = Assets.AmpedCharge:Clone();
        v26.Parent = u9;
        v26.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, -2, 0);
        vfxUtility.EmitAll(v26:GetDescendants());
        DebrisModule:AddItem(v26, 3);
        local v27 = Assets.NewStuff.Chargeup:Clone();
        v27.Parent = workspace_Debree;
        v27:PivotTo(HumanoidRootPart.CFrame);
        local v28 = Assets.NewStuff["Side Lines Screen FX"]:Clone();
        v28.Parent = workspace_Debree;
        Ouwmit.Emit(v28, {
            Owner = p5
        });
        DebrisModule:AddItem(v28, 3);
        local v29 = workspace:Raycast(HumanoidRootPart.CFrame.Position + Vector3.new(0, 5, 0), Vector3.new(-0, -15, -0), RaycastHelper.Crater);
        local v30 = v29 and vfxUtility.GetDustColorSettings(v29.Instance) or nil;
        Ouwmit.Emit(v27, v30);
        DebrisModule:AddItem(v27, 4);
        task.wait(0.2);

        if HumanoidRootPart == nil or (HumanoidRootPart.Parent == nil or (u9 == nil or u9.Parent == nil)) then
            return;
        end;

        vfxUtility.EnableAll(u8, false);
        local v31 = Assets.Final:Clone();
        v31.Parent = u9;
        v31.CFrame = HumanoidRootPart.CFrame * CFrame.new(0.77081298828125, -2.596467018127441, 0);
        DebrisModule:AddItem(v31, 6.5);
        local v32 = Assets.NewStuff.Explosion:Clone();
        v32.Parent = workspace_Debree;
        v32:PivotTo(HumanoidRootPart.CFrame);
        local v33 = workspace:Raycast(HumanoidRootPart.CFrame.Position + Vector3.new(0, 5, 0), Vector3.new(-0, -15, -0), RaycastHelper.Crater);
        local v34 = v33 and vfxUtility.GetDustColorSettings(v33.Instance) or nil;
        Ouwmit.Emit(v32, v34);
        DebrisModule:AddItem(v32, 4);
        local v35 = Assets.NewStuff["Dagger Slashes Transition"]:Clone();
        v35.Parent = workspace_Debree;
        local v36 = {
            Owner = p5
        };

        if v34 ~= nil then
            for i, v in v34 do
                v36[i] = v;
            end;
        end;

        Ouwmit.Emit(v35, v36);
        DebrisModule:AddItem(v35, 3);
        vfxUtility.PlaySound(Sounds, "PS2FLESHMANIspinbombEXPLODE", v31, true);
        task.spawn(TokenKit.GroundRocks, {
            InnerRadius = 1,
            OuterRadius = 90,
            CF = v31.CFrame,
            Velocity = {
                Min = 20,
                Max = 60
            },
            Size = {
                Min = 1,
                Max = 3
            }
        });
        Cam_Shaker(v31.Position, {
            FadeInTime = 0,
            Frequency = 0.2,
            Amplitude = 0.7,
            SustainTime = 0.5,
            FadeOutTime = 0.8,
            RotationInfluence = Vector3.new(0.25, 0.25, 0.25),
            PositionInfluence = Vector3.new(3.5, 3.5, 3.5)
        });
    elseif p6 == "Cancel" then
        vfxUtility.EnableAll(u8, false);
        local v37 = workspace_Debree:FindFirstChild(string_format_ret);

        if v37 then
            v37.Name = "_";
            v37:SetAttribute("Active", false);
            vfxUtility.EnableAll(v37, false);
            DebrisModule:AddItem(v37, 2);
        end;
    end;
end;