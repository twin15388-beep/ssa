-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
game:GetService("TweenService");
game:GetService("RunService");
local Modules = game:GetService("ReplicatedStorage").CAM.Client.Modules;
local Cam_Shaker = require(Modules.Effects.Cam_Shaker);
require(Modules.Effects.Craters.CraterHandler);
require(Modules.Effects.Craters.CraterEffects);
local _ = Players.LocalPlayer;
local Assets = script:FindFirstChild("Assets");
local workspace_Debree = workspace.Debree;
local Sounds = script:FindFirstChild("Sounds");
local vfxUtility = require(game.ReplicatedStorage.CAM.Client.Modules.Effects.vfxUtility);
local DebrisModule = require(game.ReplicatedStorage.CAM.DebrisModule);
require(Modules.Effects.BoatTween);
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterDescendantsInstances = { workspace.Map };
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Include;
local _ = game.Players.LocalPlayer;
local _ = workspace.CurrentCamera;
local RaycastParams_new_ret2 = RaycastParams.new();
RaycastParams_new_ret2.FilterType = Enum.RaycastFilterType.Include;
RaycastParams_new_ret2.FilterDescendantsInstances = { workspace.Map };

local function SpawnSwordAura(p1) -- Line: 45
    -- upvalues: workspace_Debree (copy), vfxUtility (copy), DebrisModule (copy)
    local Sword_At_A = p1:FindFirstChild("Sword_At_A", true);

    if Sword_At_A ~= nil then
        local Parent = Sword_At_A.Parent;
        local v2 = script.Parent.SwordAura:Clone();
        v2.CFrame = Parent.CFrame;
        v2.Parent = workspace_Debree;
        vfxUtility.EnableAll(v2, true);
        vfxUtility.WeldConstraint(v2, Parent);
        DebrisModule:AddItem(v2, 10);

        return v2;
    end;
end;

local function Random_Number(p3, p4) -- Line: 60
    return Random.new():NextNumber(p3, p4);
end;

return function(p5: userdata, p6: any, p7: any) -- Line: 64
    -- upvalues: vfxUtility (copy), Sounds (copy), DebrisModule (copy), workspace_Debree (copy), SpawnSwordAura (copy), Assets (copy), Cam_Shaker (copy)
    local HumanoidRootPart = p5:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local string_format_ret = string.format("%s_%s_Effects", p5.Name, script.Name);
    local Magnitude = (HumanoidRootPart.Position - workspace.CurrentCamera.CFrame.Position).Magnitude;
    local v8 = Magnitude > 250 and p6 == "End" and "Cancel" or p6;

    if v8 ~= "Cancel" and Magnitude > 250 then
        return;
    end;

    local PS2insectCEHbrrgloop = HumanoidRootPart:FindFirstChild("PS2insectCEHbrrgloop");

    if PS2insectCEHbrrgloop ~= nil then
        PS2insectCEHbrrgloop:Destroy();
    end;

    if v8 ~= "Loop" then
        if v8 == "End" then
            local v9 = workspace_Debree:FindFirstChild(string_format_ret);
            vfxUtility.PlaySound(Sounds, "PS2insectCEHbrrgstop", HumanoidRootPart, true);

            if v9 == nil then
                v9 = Instance.new("Folder");
                v9.Name = string_format_ret;
                v9.Parent = workspace_Debree;
                DebrisModule:AddItem(v9, 4);
                v9:SetAttribute("Active", true);
            end;

            if not v9:GetAttribute("Active") then
                return;
            end;

            v9:SetAttribute("BarrageShake", nil);
            local BARRAGE = v9:FindFirstChild("BARRAGE");

            if BARRAGE then
                vfxUtility.EnableAll(BARRAGE, false);
                DebrisModule:AddItem(BARRAGE, 3);
                vfxUtility.TweenLight(BARRAGE, {
                    Time = 0.2,
                    Off = true
                });
            end;

            local v10 = Assets.END_STARTUP:Clone();
            v10.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, -2.5, 0);
            v10.Parent = v9;
            DebrisModule:AddItem(v10, 2);
            local v11 = workspace:Raycast((BARRAGE or p5).PrimaryPart.Position + Vector3.new(0, 1, 0), Vector3.new(0, -10, 0), vfxUtility.RayParams.Map);

            if v11 then
                for _, descendant in v10:GetDescendants() do
                    if descendant:IsA("ParticleEmitter") and (not descendant.Name:match("grass") and descendant.Parent.Name ~= "keep") then
                        descendant.Color = ColorSequence.new(v11.Instance.Color, v11.Instance.Color);
                    end;
                end;
            else
                v10.raycastdust:Destroy();
                v10.raycastdust2:Destroy();
            end;

            vfxUtility.EmitAll(v10);
            task.wait(0.2);

            if not v9:GetAttribute("Active") or HumanoidRootPart == nil then
                return;
            end;

            Cam_Shaker(HumanoidRootPart.Position, "medium_shake_preset");
            vfxUtility.PlaySound(Sounds, "PS2insectCEHthrustdash", HumanoidRootPart, true);
            local v12 = Assets.DASH_EMIT:Clone();
            v12:PivotTo(HumanoidRootPart.CFrame);
            v12.Parent = v9;
            vfxUtility.EmitAll(v12);
            DebrisModule:AddItem(v12, 2);

            if v11 then
                for _, descendant in v12.GroundFX:GetDescendants() do
                    if descendant:IsA("ParticleEmitter") and (not descendant.Name:match("grass") and descendant.Parent.Name ~= "keep") then
                        descendant.Color = ColorSequence.new(v11.Instance.Color, v11.Instance.Color);
                    end;
                end;
            else
                v12.GroundFX.raycastdust:Destroy();
                v12.GroundFX.raycastdust2:Destroy();
            end;

            local v13 = Assets.DASH:Clone();
            v13:PivotTo(HumanoidRootPart.CFrame);
            v13.Parent = v9;
            vfxUtility.TweenLight(v13, {
                Time = 0.2,
                Del = 0.4
            });
            vfxUtility.EnableAll(v13, true);
            vfxUtility.WeldConstraint(v13.PrimaryPart, HumanoidRootPart);
            DebrisModule:AddItem(v13, 10);
            task.wait(0.4);
            local SwordAura = v9:FindFirstChild("SwordAura");

            if SwordAura then
                vfxUtility.EnableAll(SwordAura, false);
                DebrisModule:AddItem(SwordAura, 2);
            end;

            if v9 then
                v9.Name = "_";
                DebrisModule:AddItem(v9, 2);
                v9:SetAttribute("Active", nil);
                vfxUtility.EnableAll(v9, false);

                return;
            end;
        else
            local v14 = v8 == "Cancel" and workspace_Debree:FindFirstChild(string_format_ret);

            if v14 then
                v14.Name = "_";
                DebrisModule:AddItem(v14, 2);
                v14:SetAttribute("Active", nil);
                vfxUtility.EnableAll(v14, false);
                vfxUtility.TweenLight(v14, {
                    Time = 0.01,
                    Off = true
                });
            end;
        end;

        return;
    end;

    vfxUtility.PlaySound(Sounds, "PS2insectCEHbrrg", HumanoidRootPart, true);
    local v15 = script.Sounds.PS2insectCEHbrrgloop:Clone();
    v15.Parent = HumanoidRootPart;
    v15:Play();
    DebrisModule:AddItem(v15, 7);

    if workspace_Debree:FindFirstChild(string_format_ret) then
        local v16 = workspace_Debree:FindFirstChild(string_format_ret);
        v16.Name = "_";
        DebrisModule:AddItem(v16, 2);
        v16:SetAttribute("Active", nil);
        vfxUtility.EnableAll(v16, false);
    end;

    local Folder = Instance.new("Folder");
    Folder.Name = string_format_ret;
    Folder.Parent = workspace_Debree;
    DebrisModule:AddItem(Folder, 12);
    Folder:SetAttribute("Active", true);
    Folder:SetAttribute("BarrageShake", true);
    SpawnSwordAura(p5).Parent = Folder;
    local v17 = Assets.BARRAGE:Clone();
    v17:PivotTo(HumanoidRootPart.CFrame);
    v17.Parent = Folder;
    vfxUtility.TweenLight(v17, {
        Time = 0.2
    });
    vfxUtility.WeldConstraint(v17.PrimaryPart, HumanoidRootPart);
    local v18 = workspace:Raycast(v17.PrimaryPart.Position + Vector3.new(0, 1, 0), Vector3.new(0, -10, 0), vfxUtility.RayParams.Map);

    if v18 then
        for _, descendant in v17.GroundVFX:GetDescendants() do
            if descendant:IsA("ParticleEmitter") and (not descendant.Name:match("grass") and descendant.Parent.Name ~= "keep") then
                descendant.Color = ColorSequence.new(v18.Instance.Color, v18.Instance.Color);
            end;
        end;
    else
        v17.GroundVFX:Destroy();
    end;

    vfxUtility.EnableAll(v17, true);
    local v19 = Cam_Shaker(HumanoidRootPart.Position, {
        FadeInTime = 0,
        Frequency = 0.082,
        Amplitude = 0.12,
        SustainTime = 6,
        FadeOutTime = 0.15,
        RotationInfluence = Vector3.new(0.1, 0.1, 0.1),
        PositionInfluence = Vector3.new(0.4, 0.4, 0.4)
    });

    while HumanoidRootPart:IsDescendantOf(workspace) and (Folder:IsDescendantOf(workspace) and (Folder:GetAttribute("Active") and Folder:GetAttribute("BarrageShake"))) do
        task.wait(0.15);
    end;

    v19:Destroy();
end;