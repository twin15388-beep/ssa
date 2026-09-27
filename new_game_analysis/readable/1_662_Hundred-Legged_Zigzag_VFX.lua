-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
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

local function SpawnSwordAura(p1) -- Line: 44
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

return function(u5: userdata, p6: any, p7: any) -- Line: 64
    -- upvalues: workspace_Debree (copy), DebrisModule (copy), vfxUtility (copy), SpawnSwordAura (copy), Sounds (copy), Assets (copy), Cam_Shaker (copy), TweenService (copy)
    local HumanoidRootPart = u5:FindFirstChild("HumanoidRootPart");
    local UpperTorso = u5:FindFirstChild("UpperTorso");
    local LeftFoot = u5:FindFirstChild("LeftFoot");
    local RightFoot = u5:FindFirstChild("RightFoot");
    local Humanoid = u5:FindFirstChild("Humanoid");

    if not HumanoidRootPart then
        return;
    end;

    if not UpperTorso then
        return;
    end;

    if not LeftFoot then
        return;
    end;

    if not RightFoot then
        return;
    end;

    if not Humanoid then
        return;
    end;

    local string_format_ret = string.format("%s_%s_Effects", u5.Name, script.Name);

    if p6 ~= "Cancel" and (HumanoidRootPart.Position - workspace.CurrentCamera.CFrame.Position).Magnitude > 250 then
        return;
    end;

    local v8 = workspace_Debree:FindFirstChild(string_format_ret);

    if p6 == "Dashing" then
        if v8 ~= nil then
            v8:Destroy();
        end;

        local Folder = Instance.new("Folder");
        Folder.Name = string_format_ret;
        Folder.Parent = workspace_Debree;
        Folder:SetAttribute("Active", true);
        DebrisModule:AddItem(Folder, 5);
        local v9 = workspace:Raycast(HumanoidRootPart.Position, Vector3.new(0, -20, 0), vfxUtility.RayParams.Map);
        local v10;

        if v9 then
            v10 = v9.Instance;
        else
            v10 = nil;
        end;

        local function SetPartCFrame(p11, p12) -- Line: 105
            -- upvalues: HumanoidRootPart (copy)
            return HumanoidRootPart.CFrame * p11.CFrame:ToObjectSpace(p12.CFrame);
        end;

        SpawnSwordAura(u5).Parent = Folder;
        vfxUtility.PlaySound(Sounds, "PS2insectHLZstart", HumanoidRootPart, true);
        task.wait(0.35);

        if Folder:GetAttribute("Active") ~= true then
            return;
        end;

        local v13 = Assets.Grab.StartSlash:Clone();
        v13:PivotTo(HumanoidRootPart.CFrame * Assets.Grab.Root.CFrame:ToObjectSpace(Assets.Grab.StartSlash.PrimaryPart.CFrame));
        v13.Parent = workspace_Debree;
        vfxUtility.ChangeDustColor(v10, { v13.GroundFX.raycastdust, v13.GroundFX.raycastdust2, v13.GroundFX.raycastdust3 });
        vfxUtility.EmitAll(v13);
        DebrisModule:AddItem(v13, 2);
        Cam_Shaker(UpperTorso, {
            FadeInTime = 0,
            Frequency = 0.05,
            Amplitude = 0.1,
            SustainTime = 0.16,
            FadeOutTime = 0.3,
            RotationInfluence = Vector3.new(0.25, 0.25, 0.25),
            PositionInfluence = Vector3.new(0.15, 0.15, 0.15),
            MinDistance = 6,
            DistanceStretch = 2
        });
        local v14 = Assets.Grab.BeamSlash:Clone();
        v14.CFrame = HumanoidRootPart.CFrame * Assets.Grab.Root.CFrame:ToObjectSpace(Assets.Grab.BeamSlash.CFrame);
        v14.Parent = workspace_Debree;
        DebrisModule:AddItem(v14, 1);
        TweenService:Create(v14.SpinAttachment, TweenInfo.new(0.15, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
            CFrame = v14.SpinAttachment.CFrame * CFrame.Angles(0, 3.12413936106985, 0)
        });

        for _, descendant in v14.SpinAttachment:GetDescendants() do
            if descendant:IsA("Beam") then
                task.delay(0.05, function() -- Line: 147
                    -- upvalues: TweenService (ref), descendant (copy)
                    TweenService:Create(descendant, TweenInfo.new(0.1), {
                        TextureLength = 1
                    }):Play();
                    task.wait(0.03);
                    TweenService:Create(descendant, TweenInfo.new(0.1), {
                        Width0 = 0,
                        Width1 = 0
                    }):Play();
                end);
            end;
        end;

        task.wait(0.4);

        if Folder:GetAttribute("Active") ~= true then
            return;
        end;

        vfxUtility.PlaySound(Sounds, "PS2insectFSland", HumanoidRootPart, true);
        local os_clock_ret = os.clock();
        task.wait(p7 - 0.6);

        if Folder:GetAttribute("Active") ~= true then
            return;
        end;

        vfxUtility.PlaySound(Sounds, "PS2insectHLZdash", HumanoidRootPart, true);

        local function SpawnClone() -- Line: 168
            -- upvalues: u5 (copy), TweenService (ref), workspace_Debree (ref), DebrisModule (ref)
            local v15 = game.ReplicatedStorage.Assets.StarterCharacterCloneable:Clone();
            v15.Name = "Clone";

            for _, v in pairs(v15:GetTags()) do
                v15:RemoveTag(v);
            end;

            for _, descendant in pairs(v15:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    local v16 = u5:FindFirstChild(descendant.Name);

                    if v16 == nil then
                        descendant:Destroy();
                    else
                        descendant.CFrame = v16.CFrame;
                        descendant.Anchored = true;
                        TweenService:Create(descendant, TweenInfo.new(0.45), {
                            Color = Color3.new(0.929412, 0.164706, 1)
                        }):Play();
                        TweenService:Create(descendant, TweenInfo.new(0.85), {
                            Transparency = 1
                        }):Play();
                    end;
                else
                    descendant:Destroy();
                end;
            end;

            v15.Parent = workspace_Debree;
            DebrisModule:AddItem(v15, 0.85);
        end;

        local v17 = script.Sounds.PS2insectCEHloop:Clone();
        v17.Parent = HumanoidRootPart;
        v17:Play();

        while os.clock() - os_clock_ret < 8 and (Folder ~= nil and (Folder.Parent ~= nil and (Folder:GetAttribute("Active") and Folder:GetAttribute("Active")))) do
            local v18 = workspace:Raycast(UpperTorso.Position, Vector3.new(0, -10, 0), vfxUtility.RayParams.Map);
            local v19;

            if v18 then
                v19 = v18.Instance;
            else
                v19 = nil;
            end;

            local v20 = Assets.Jump:Clone();
            v20.CFrame = HumanoidRootPart.CFrame * CFrame.new(-3, -3, 0) * CFrame.Angles(0, 1.5707963267948966, 0);
            v20.Parent = workspace_Debree;
            vfxUtility.ChangeDustColor(v19, { v20.raycastdust, v20.raycastdust2 });
            vfxUtility.EmitAll(v20);
            DebrisModule:AddItem(v20, 2);
            Cam_Shaker(UpperTorso, "punch_shake");
            SpawnClone();
            task.wait(0.15);

            if not Folder:GetAttribute("Active") then
                break;
            end;

            local v21 = workspace:Raycast(UpperTorso.Position, Vector3.new(0, -10, 0), vfxUtility.RayParams.Map);
            local v22;

            if v21 then
                v22 = v21.Instance;
            else
                v22 = nil;
            end;

            local v23 = Assets.Jump:Clone();
            v23.CFrame = HumanoidRootPart.CFrame * CFrame.new(3, -3, 0) * CFrame.Angles(0, 3.141592653589793, 0);
            v23.Parent = workspace_Debree;
            vfxUtility.ChangeDustColor(v22, { v23.raycastdust, v23.raycastdust2 });
            vfxUtility.EmitAll(v23);
            DebrisModule:AddItem(v23, 2);
            Cam_Shaker(UpperTorso, "punch_shake");
            SpawnClone();
            task.wait(0.33);

            if not Folder:GetAttribute("Active") then
                break;
            end;
        end;

        v17:Stop();
        v17:Destroy();
    elseif p6 == "Grab" then
        local u24 = p7 or 0;

        local function waitBeat(p25) -- Line: 245
            -- upvalues: u24 (ref)
            local v26 = p25 - u24;
            u24 = math.max(u24 - p25, 0);

            if v26 > 0 then
                task.wait(v26);
            end;
        end;

        local v27 = vfxUtility.PlaySound(Sounds, "PS2insectHLZcineFULLSTART", HumanoidRootPart, true);

        if v27 then
            v27.TimePosition = u24;
        end;

        local PS2insectHLZstart = HumanoidRootPart:FindFirstChild("PS2insectHLZstart");

        if PS2insectHLZstart then
            PS2insectHLZstart:Destroy();
        end;

        if v8 ~= nil then
            v8:SetAttribute("Active", nil);
            v8:Destroy();
        end;

        local Folder = Instance.new("Folder");
        Folder.Name = string_format_ret;
        Folder.Parent = workspace_Debree;
        Folder:SetAttribute("Active", true);
        DebrisModule:AddItem(Folder, 5);

        local function _(p28, p29) -- Line: 271
            -- upvalues: HumanoidRootPart (copy)
            return HumanoidRootPart.CFrame * p28.CFrame:ToObjectSpace(p29.CFrame);
        end;

        local v30 = workspace:Raycast(HumanoidRootPart.Position, Vector3.new(0, -20, 0), vfxUtility.RayParams.Map);
        local v31;

        if v30 then
            v31 = v30.Instance;
        else
            v31 = nil;
        end;

        local v32 = 0.05 - u24;
        u24 = math.max(u24 - 0.05, 0);

        if v32 > 0 then
            task.wait(v32);
        end;

        if not Folder:GetAttribute("Active") then
            return;
        end;

        local v33 = SpawnSwordAura(u5);
        local v34 = Assets.Grab.Startup:Clone();
        v34.CFrame = HumanoidRootPart.CFrame * Assets.Grab.Root.CFrame:ToObjectSpace(Assets.Grab.Startup.CFrame);
        v34.Parent = workspace_Debree;
        vfxUtility.ChangeDustColor(v31, { v34.raycastdust, v34.raycastdust2 });
        vfxUtility.EmitAll(v34);
        DebrisModule:AddItem(v34, 2);
        local v35 = 0.233 - u24;
        u24 = math.max(u24 - 0.233, 0);

        if v35 > 0 then
            task.wait(v35);
        end;

        if not Folder:GetAttribute("Active") then
            return;
        end;

        local v36 = Assets.Grab.StartSlash:Clone();
        v36:PivotTo(HumanoidRootPart.CFrame * Assets.Grab.Root.CFrame:ToObjectSpace(Assets.Grab.StartSlash.PrimaryPart.CFrame));
        v36.Parent = workspace_Debree;
        vfxUtility.ChangeDustColor(v31, { v36.GroundFX.raycastdust, v36.GroundFX.raycastdust2, v36.GroundFX.raycastdust3 });
        vfxUtility.EmitAll(v36);
        DebrisModule:AddItem(v36, 2);
        Cam_Shaker(UpperTorso, {
            FadeInTime = 0,
            Frequency = 0.05,
            Amplitude = 0.1,
            SustainTime = 0.16,
            FadeOutTime = 0.3,
            RotationInfluence = Vector3.new(0.25, 0.25, 0.25),
            PositionInfluence = Vector3.new(0.15, 0.15, 0.15),
            MinDistance = 6,
            DistanceStretch = 2
        });
        local v37 = 0.084 - u24;
        u24 = math.max(u24 - 0.084, 0);

        if v37 > 0 then
            task.wait(v37);
        end;

        if not Folder:GetAttribute("Active") then
            return;
        end;

        local v38 = Assets.Grab.BeamSlash:Clone();
        v38.CFrame = HumanoidRootPart.CFrame * Assets.Grab.Root.CFrame:ToObjectSpace(Assets.Grab.BeamSlash.CFrame);
        v38.Parent = workspace_Debree;
        DebrisModule:AddItem(v38, 1);
        TweenService:Create(v38.SpinAttachment, TweenInfo.new(0.15, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
            CFrame = v38.SpinAttachment.CFrame * CFrame.Angles(0, 3.12413936106985, 0)
        });

        for _, descendant in v38.SpinAttachment:GetDescendants() do
            if descendant:IsA("Beam") then
                task.delay(0.05, function() -- Line: 336
                    -- upvalues: TweenService (ref), descendant (copy)
                    TweenService:Create(descendant, TweenInfo.new(0.1), {
                        TextureLength = 1
                    }):Play();
                    task.wait(0.03);
                    TweenService:Create(descendant, TweenInfo.new(0.1), {
                        Width0 = 0,
                        Width1 = 0
                    }):Play();
                end);
            end;
        end;

        local v39 = 0.666 - u24;
        u24 = math.max(u24 - 0.666, 0);

        if v39 > 0 then
            task.wait(v39);
        end;

        if not Folder:GetAttribute("Active") then
            return;
        end;

        local v40 = Assets.Grab.RightFootStep:Clone();
        v40.CFrame = HumanoidRootPart.CFrame * Assets.Grab.Root.CFrame:ToObjectSpace(Assets.Grab.RightFootStep.CFrame);
        v40.Parent = workspace_Debree;
        vfxUtility.ChangeDustColor(v31, { v40.raycastdust, v40.raycastdust2 });
        vfxUtility.EmitAll(v40);
        DebrisModule:AddItem(v40, 2);
        Cam_Shaker(UpperTorso, "punch_shake");
        local v41 = 0.184 - u24;
        u24 = math.max(u24 - 0.184, 0);

        if v41 > 0 then
            task.wait(v41);
        end;

        if not Folder:GetAttribute("Active") then
            return;
        end;

        local v42 = Assets.Grab.LeftSideJump:Clone();
        v42.CFrame = HumanoidRootPart.CFrame * Assets.Grab.Root.CFrame:ToObjectSpace(Assets.Grab.LeftSideJump.CFrame);
        v42.Parent = workspace_Debree;
        vfxUtility.ChangeDustColor(v31, { v42.raycastdust, v42.raycastdust2 });
        vfxUtility.EmitAll(v42);
        DebrisModule:AddItem(v42, 2);
        Cam_Shaker(UpperTorso, "punch_shake");
        local v43 = 0.1 - u24;
        u24 = math.max(u24 - 0.1, 0);

        if v43 > 0 then
            task.wait(v43);
        end;

        if not Folder:GetAttribute("Active") then
            return;
        end;

        local v44 = Assets.Grab.RightSideJump:Clone();
        v44.CFrame = HumanoidRootPart.CFrame * Assets.Grab.Root.CFrame:ToObjectSpace(Assets.Grab.RightSideJump.CFrame);
        v44.Parent = workspace_Debree;
        vfxUtility.ChangeDustColor(v31, { v44.raycastdust, v44.raycastdust2 });
        vfxUtility.EmitAll(v44);
        DebrisModule:AddItem(v44, 2);
        Cam_Shaker(UpperTorso, "punch_shake");
        local v45 = 0.15 - u24;
        u24 = math.max(u24 - 0.15, 0);

        if v45 > 0 then
            task.wait(v45);
        end;

        if not Folder:GetAttribute("Active") then
            return;
        end;

        local v46 = Assets.Grab.PoisonThrust1:Clone();
        v46:PivotTo(HumanoidRootPart.CFrame * Assets.Grab.Root.CFrame:ToObjectSpace(Assets.Grab.PoisonThrust1.PrimaryPart.CFrame));
        v46.Parent = workspace_Debree;
        vfxUtility.ChangeDustColor(v31, { v46.GroundFX.raycastdust, v46.GroundFX.raycastdust2 });
        vfxUtility.EmitAll(v46);
        DebrisModule:AddItem(v46, 2);
        Cam_Shaker(UpperTorso, {
            FadeInTime = 0,
            Frequency = 0.05,
            Amplitude = 0.1,
            SustainTime = 0.16,
            FadeOutTime = 0.3,
            RotationInfluence = Vector3.new(0.25, 0.25, 0.25),
            PositionInfluence = Vector3.new(0.15, 0.15, 0.15),
            MinDistance = 6,
            DistanceStretch = 2
        });
        local v47 = 0.55 - u24;
        u24 = math.max(u24 - 0.55, 0);

        if v47 > 0 then
            task.wait(v47);
        end;

        if not Folder:GetAttribute("Active") then
            return;
        end;

        local v48 = Assets.Grab.PoisonExplosion:Clone();
        v48:PivotTo(HumanoidRootPart.CFrame * Assets.Grab.Root.CFrame:ToObjectSpace(Assets.Grab.PoisonExplosion.PrimaryPart.CFrame));
        v48.Parent = workspace_Debree;
        vfxUtility.ChangeDustColor(v31, { v48.GroundFX.raycastdust });
        vfxUtility.EmitAll(v48);
        DebrisModule:AddItem(v48, 2);
        vfxUtility.EnableAll(v33, false);
        DebrisModule:AddItem(v33, 2);
        Cam_Shaker(UpperTorso, {
            FadeInTime = 0,
            Frequency = 0.055,
            Amplitude = 0.5,
            SustainTime = 0.16,
            FadeOutTime = 0.3,
            RotationInfluence = Vector3.new(0.2, 0.2, 0.2),
            PositionInfluence = Vector3.new(3, 3, 3),
            MinDistance = 9,
            DistanceStretch = 1.5
        });
    elseif v8 == nil then
        return;
    end;

    if p6 ~= "Miss Success" then
        local v49 = p6 == "Cancel" and workspace_Debree:FindFirstChild(string_format_ret);

        if v49 then
            v49.Name = "_";
            v49:SetAttribute("Active", nil);
            DebrisModule:AddItem(v49, 2);
            vfxUtility.EnableAll(v49, false);
            vfxUtility.TweenLight(v49, {
                Time = 0.01,
                Off = true
            });
        end;

        return;
    end;

    local v50 = workspace_Debree:FindFirstChild(string_format_ret);

    if v50 then
        v50.Name = "_";
        v50:SetAttribute("Active", nil);
        DebrisModule:AddItem(v50, 2);
        vfxUtility.EnableAll(v50, false);
        vfxUtility.TweenLight(v50, {
            Time = 0.01,
            Off = true
        });
    end;

    task.wait(0.1);
    vfxUtility.PlaySound(Sounds, "PS2insectHLZsuccess", HumanoidRootPart, true);
    local v51 = workspace:Raycast(UpperTorso.Position, Vector3.new(0, -10, 0), vfxUtility.RayParams.Map);
    local v52;

    if v51 then
        v52 = v51.Instance;
    else
        v52 = nil;
    end;

    local function _(p53, p54) -- Line: 460
        -- upvalues: HumanoidRootPart (copy)
        return HumanoidRootPart.CFrame * p53.CFrame:ToObjectSpace(p54.CFrame);
    end;

    local v55 = Assets.Grab.PoisonThrust1:Clone();
    v55:PivotTo(HumanoidRootPart.CFrame * Assets.Grab.Root.CFrame:ToObjectSpace(Assets.Grab.PoisonThrust1.PrimaryPart.CFrame));
    v55.Parent = workspace_Debree;
    vfxUtility.ChangeDustColor(v52, { v55.GroundFX.raycastdust, v55.GroundFX.raycastdust2 });
    vfxUtility.EmitAll(v55);
    DebrisModule:AddItem(v55, 2);
    Cam_Shaker(UpperTorso, {
        FadeInTime = 0,
        Frequency = 0.05,
        Amplitude = 0.1,
        SustainTime = 0.16,
        FadeOutTime = 0.3,
        RotationInfluence = Vector3.new(0.25, 0.25, 0.25),
        PositionInfluence = Vector3.new(0.15, 0.15, 0.15),
        MinDistance = 6,
        DistanceStretch = 2
    });
    task.wait(0.3);
    local v56 = Assets.Grab.PoisonExplosion:Clone();
    v56:PivotTo(HumanoidRootPart.CFrame * Assets.Grab.Root.CFrame:ToObjectSpace(Assets.Grab.PoisonExplosion.PrimaryPart.CFrame));
    v56.Parent = workspace_Debree;
    vfxUtility.ChangeDustColor(v52, { v56.GroundFX.raycastdust });
    vfxUtility.EmitAll(v56);
    DebrisModule:AddItem(v56, 2);
    Cam_Shaker(UpperTorso, {
        FadeInTime = 0,
        Frequency = 0.055,
        Amplitude = 0.5,
        SustainTime = 0.16,
        FadeOutTime = 0.3,
        RotationInfluence = Vector3.new(0.2, 0.2, 0.2),
        PositionInfluence = Vector3.new(3, 3, 3),
        MinDistance = 9,
        DistanceStretch = 1.5
    });
end;