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
local vfxUtility = require(game.ReplicatedStorage.CAM.Client.Modules.Effects.vfxUtility);
local RaycastHelper = require(ReplicatedStorage.CAM.Global.RaycastHelper);
local OuwCraters = require(ReplicatedStorage.CAM.Client.Modules.Effects.Craters.OuwCraters);
local Ouwmit = require(ReplicatedStorage.CAM.Client.Modules.Effects.Ouwmit);
local _ = game.Players.LocalPlayer;
local workspace_CurrentCamera = workspace.CurrentCamera;
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterDescendantsInstances = { workspace.Map };
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Include;
local TweenInfo_new_ret = TweenInfo.new(0.4, Enum.EasingStyle.Linear);
local TweenInfo_new_ret2 = TweenInfo.new(1.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In);

return function(p1: userdata, p2: string, p3: userdata) -- Line: 51
    -- upvalues: workspace_CurrentCamera (copy), workspace_Debree (copy), vfxUtility (copy), Sounds (copy), DebrisModule (copy), Assets (copy), RaycastHelper (copy), Ouwmit (copy), Cam_Shaker (copy), TweenService (copy), TweenInfo_new_ret (copy), OuwCraters (copy), TokenKit (copy), TweenInfo_new_ret2 (copy)
    if p1 == nil then
        return;
    end;

    local v4 = p1:FindFirstChild("HumanoidRootPart") or p1.PrimaryPart;

    if v4 ~= nil and (p2 ~= "Cancel" and (v4.Position - workspace_CurrentCamera.CFrame.Position).Magnitude > 250) then
        return;
    end;

    p1:FindFirstChild("UpperTorso");
    local string_format_ret = string.format("%s Obi_Field_Effects", p1.Name);
    local v5 = workspace_Debree:FindFirstChild(string_format_ret);

    if p2 == "Start" then
        if v5 ~= nil then
            v5:Destroy();
        end;

        vfxUtility.PlaySound(Sounds, "PS2FleshManiOBIFIELDstart", v4, true);
        v5 = Instance.new("Folder");
        v5.Name = string_format_ret;
        v5.Parent = workspace_Debree;
        DebrisModule:AddItem(v5, 12);
        v5:SetAttribute("Active", true);
        task.wait(0.3);

        if not v5:GetAttribute("Active") then
            return;
        end;

        vfxUtility.PlaySound(Sounds, "PS2FleshManiOBIFIELDgroundslam", v4, true);
        local v6 = Assets.StarterHit:Clone();
        v6.Parent = v5;
        v6.CFrame = v4.CFrame * CFrame.new(-0.059, -2.2, 0.047);
        local v7 = workspace:Raycast(v4.CFrame.Position + Vector3.new(0, 5, 0), Vector3.new(-0, -15, -0), RaycastHelper.Crater);
        local v8 = v7 and vfxUtility.GetDustColorSettings(v7.Instance) or nil;
        Ouwmit.Emit(v6, v8);
        DebrisModule:AddItem(v6, 3);
        Cam_Shaker(v6.Position, {
            FadeInTime = 0,
            Frequency = 0.1,
            Amplitude = 0.3,
            SustainTime = 0.1,
            FadeOutTime = 0.5,
            RotationInfluence = Vector3.new(0.25, 0.25, 0.25),
            PositionInfluence = Vector3.new(3.5, 3.5, 3.5)
        });
        local v9 = Assets.DetectorAura:Clone();
        v9.Parent = v5;
        v9.CFrame = v4.CFrame * CFrame.new(-0.059, -2.2, 0.047);
        vfxUtility.EnableAll(v9, true);
        vfxUtility.EmitAll(v9:GetDescendants());
    elseif v5 == nil then
        return;
    end;

    if p2 == "TrapSpawn" then
        task.wait(0.2);
        local PrimaryPart = p3.PrimaryPart;
        vfxUtility.PlaySound(Sounds, "PS2FleshManiOBIFIELDobiappear", PrimaryPart, true);
        local v10 = Assets.Explosion:Clone();
        v10.Parent = v5;
        v10.Position = PrimaryPart.Position;
        Vector3.new(0, -1.45, 0);
        vfxUtility.EmitAll(v10:GetDescendants());
        DebrisModule:AddItem(v10, 3);
        local u11 = Assets.Better:Clone();
        u11.Parent = PrimaryPart;
        u11.CFrame = PrimaryPart.CFrame + Vector3.new(0, -1.45, 0);
        vfxUtility.EnableAll(u11, true);
        task.delay(3, function() -- Line: 134
            -- upvalues: vfxUtility (ref), u11 (copy), DebrisModule (ref)
            vfxUtility.EnableAll(u11, false);
            DebrisModule:AddItem(u11, 3);
        end);
    end;

    if p2 == "TrapMiss" then
        local PrimaryPart = p3.PrimaryPart;
        vfxUtility.PlaySound(Sounds, "PS2FleshManiOBIFIELDregress", PrimaryPart, true);
        local v12 = Assets.Explosion:Clone();
        v12.Parent = v5;
        v12.Position = PrimaryPart.Position;
        Vector3.new(0, -1.45, 0);
        vfxUtility.EmitAll(v12:GetDescendants());
        DebrisModule:AddItem(v12, 3);

        for _, child in pairs(p3:GetChildren()) do
            if child:IsA("MeshPart") then
                TweenService:Create(child, TweenInfo_new_ret, {
                    Transparency = 1
                }):Play();
            end;
        end;

        TweenService:Create(PrimaryPart, TweenInfo_new_ret, {
            CFrame = PrimaryPart.CFrame * CFrame.new(0, 7, 0)
        }):Play();
    end;

    if p2 == "TrapHit" then
        local PrimaryPart = p3.PrimaryPart;
        vfxUtility.PlaySound(Sounds, "PS2FleshManiOBIFIELDexplo", PrimaryPart, true);
        local Better = PrimaryPart:WaitForChild("Better", 0.25);

        if not Better then
            return;
        end;

        local u13 = Assets.Hits:Clone();
        u13.Parent = workspace_Debree;
        u13:PivotTo(CFrame.new(PrimaryPart.Position + Vector3.new(0, -1.45, 0)));
        local v14 = workspace:Raycast(v4.CFrame.Position + Vector3.new(0, 5, 0), Vector3.new(-0, -15, -0), RaycastHelper.Crater);
        local v15 = v14 and vfxUtility.GetDustColorSettings(v14.Instance) or nil;
        Ouwmit.Emit(u13, v15);
        OuwCraters.Scales({
            Duration = 2.5,
            Radius = 9,
            ScaleMult = 0.75,
            Center = u13.PrimaryPart.CFrame
        });
        task.spawn(function() -- Line: 200
            -- upvalues: TokenKit (ref), u13 (copy)
            TokenKit.GroundRocks({
                InnerRadius = 1,
                OuterRadius = 8,
                CF = u13.PrimaryPart.CFrame,
                Velocity = {
                    Min = 20,
                    Max = 70
                },
                Size = {
                    Min = 1,
                    Max = 2
                }
            });
        end);
        Cam_Shaker(u13.PrimaryPart.Position, {
            FadeInTime = 0,
            Frequency = 0.1,
            Amplitude = 0.3,
            SustainTime = 0.1,
            FadeOutTime = 0.5,
            RotationInfluence = Vector3.new(0.25, 0.25, 0.25),
            PositionInfluence = Vector3.new(3.5, 3.5, 3.5)
        });

        for _, child in pairs(p3:GetChildren()) do
            if child:IsA("MeshPart") then
                TweenService:Create(child, TweenInfo_new_ret2, {
                    Transparency = 1
                }):Play();
            end;
        end;

        task.wait(0.5);
        vfxUtility.EnableAll(Better, false);
    end;

    if p2 == "Cancel" and (v5 ~= nil and v5.Parent ~= nil) then
        vfxUtility.EnableAll(v5, false);
        v5.Name = "_";
        v5:SetAttribute("Active", false);
        DebrisModule:AddItem(v5, 4);
    end;
end;