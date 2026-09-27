-- Decompiled with Potassium's decompiler.

local DebrisModule = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("DebrisModule"));
local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Ouwmit = require(ReplicatedStorage.CAM.Client.Modules.Effects.Ouwmit);
local vfxUtility = require(ReplicatedStorage.CAM.Client.Modules.Effects.vfxUtility);
local Cam_Shaker = require(ReplicatedStorage.CAM.Client.Modules.Effects.Cam_Shaker);
local u1 = {
    Dash1 = "PS2scytheBLOODLUSTslash1",
    Dash2 = "PS2scytheBLOODLUSTslash2",
    Dash3 = "PS2scytheBLOODLUSTslashFINALAoE"
};

local function groundDust(p2) -- Line: 21
    -- upvalues: vfxUtility (copy)
    local v3 = vfxUtility.CheckForGround(p2, Vector3.new(0, -20, 0), vfxUtility.RayParams.Map);

    return vfxUtility.GetDustColorSettings(v3);
end;

local function BlurEffect(p4) -- Line: 26
    -- upvalues: DebrisModule (copy)
    local BlurEffect = Instance.new("BlurEffect");
    BlurEffect.Size = 8;
    BlurEffect.Parent = game.Lighting;
    DebrisModule:AddItem(BlurEffect, p4 or 0.08333333333333333);
end;

local function Shake(p5, p6, p7) -- Line: 34
    -- upvalues: Cam_Shaker (copy)
    local v8 = {
        FadeInTime = 0,
        Frequency = 0.175,
        SustainTime = 0.2,
        FadeOutTime = 0.2,
        RotationInfluence = Vector3.new(0.2, 0.2, 0.2),
        PositionInfluence = Vector3.new(2.5, 2.5, 2.5),
        Amplitude = p6
    };

    if p7 then
        for i, v in p7 do
            v8[i] = v;
        end;
    end;

    Cam_Shaker(p5, v8);
end;

local function CloneFX(u9) -- Line: 52
    -- upvalues: DebrisModule (copy), ReplicatedStorage (copy), TweenService (copy)
    task.spawn(function() -- Line: 53
        -- upvalues: DebrisModule (ref), ReplicatedStorage (ref), u9 (copy), TweenService (ref)
        local TweenInfo_new_ret = TweenInfo.new(0.55, Enum.EasingStyle.Linear);
        local Folder = Instance.new("Folder");
        Folder.Name = "BloodLustClones";
        Folder.Parent = workspace.Debree;
        DebrisModule:AddItem(Folder, 1);

        for i = 1, 5 do
            local v10 = ReplicatedStorage.Assets.StarterCharacterCloneable:Clone();
            v10.Name = "Clone";
            local _ = i;

            for _, v in ipairs(v10:GetTags()) do
                v10:RemoveTag(v);
            end;

            for _, child in ipairs(v10:GetChildren()) do
                if child:IsA("BasePart") then
                    local v11 = u9:FindFirstChild(child.Name);

                    if v11 == nil then
                        child:Destroy();
                    else
                        child.CFrame = v11.CFrame;
                        child.Anchored = true;
                        child.CanCollide = false;
                        child.Color = Color3.new(0, 0, 0);
                        child.Material = Enum.Material.SmoothPlastic;
                        child.Transparency = child.Name == "HumanoidRootPart" and 1 or 0;

                        if child.Transparency < 1 then
                            TweenService:Create(child, TweenInfo_new_ret, {
                                Transparency = 1
                            }):Play();
                        end;
                    end;
                else
                    child:Destroy();
                end;
            end;

            v10.Parent = Folder;
            task.wait(0.07);
        end;
    end);
end;

local function emitStrike(p12, p13, p14, p15) -- Line: 97
    -- upvalues: Ouwmit (copy), groundDust (copy), DebrisModule (copy)
    local v16 = script[p13]:Clone();
    v16.Parent = workspace.Debree;
    v16:PivotTo(p12.CFrame * p14);

    if p15 then
        v16:ScaleTo(v16:GetScale() * p15);
    end;

    Ouwmit.Emit(v16, groundDust(p12.Position));
    DebrisModule:AddItem(v16, 5);
end;

return function(u17: userdata, p18: any) -- Line: 108
    -- upvalues: Ouwmit (copy), groundDust (copy), DebrisModule (copy), u1 (copy), vfxUtility (copy), ReplicatedStorage (copy), TweenService (copy), Cam_Shaker (copy), emitStrike (copy), Shake (copy)
    local HumanoidRootPart = u17.HumanoidRootPart;

    if (HumanoidRootPart.Position - workspace.CurrentCamera.CFrame.Position).Magnitude >= 250 then
        return;
    end;

    if p18 ~= "Dash1" and (p18 ~= "Dash2" and p18 ~= "Dash3") then
        if p18 == "Finisher1" then
            emitStrike(HumanoidRootPart, "Strike1", CFrame.new(0, 0, -8));
            Cam_Shaker(HumanoidRootPart.Position, {
                FadeInTime = 0,
                Frequency = 0.175,
                Amplitude = 0.3,
                SustainTime = 0.2,
                FadeOutTime = 0.2,
                RotationInfluence = Vector3.new(0.2, 0.2, 0.2),
                PositionInfluence = Vector3.new(2.5, 2.5, 2.5)
            });

            return;
        end;

        if p18 ~= "Finisher2" then
            if p18 == "Finisher3b" then
                emitStrike(HumanoidRootPart, "Strike3", CFrame.new(0, -1, -6), 1.6);
                local BlurEffect2 = Instance.new("BlurEffect");
                BlurEffect2.Size = 8;
                BlurEffect2.Parent = game.Lighting;
                DebrisModule:AddItem(BlurEffect2, 0.35);
                Shake(HumanoidRootPart.Position, 0.55, {
                    Frequency = 0.25,
                    SustainTime = 0.6,
                    FadeOutTime = 0.5,
                    Amplitude = 1,
                    RotationInfluence = Vector3.new(0.35, 0.35, 0.35),
                    PositionInfluence = Vector3.new(5, 5, 5)
                });
            end;

            return;
        end;

        emitStrike(HumanoidRootPart, "Strike2", CFrame.new(0, 0, -7));
        Cam_Shaker(HumanoidRootPart.Position, {
            FadeInTime = 0,
            Frequency = 0.175,
            Amplitude = 0.4,
            SustainTime = 0.2,
            FadeOutTime = 0.2,
            RotationInfluence = Vector3.new(0.2, 0.2, 0.2),
            PositionInfluence = Vector3.new(2.5, 2.5, 2.5)
        });

        return;
    end;

    local v19 = script.Teleport:Clone();
    v19.Parent = workspace.Debree;
    v19:PivotTo(HumanoidRootPart.CFrame);
    Ouwmit.Emit(v19, groundDust(HumanoidRootPart.Position));
    DebrisModule:AddItem(v19, 5);
    local v20 = u1[p18];

    if v20 then
        vfxUtility.PlaySound(script.Sounds, v20, HumanoidRootPart, true);
    end;

    task.spawn(function() -- Line: 53
        -- upvalues: DebrisModule (ref), ReplicatedStorage (ref), u17 (copy), TweenService (ref)
        local TweenInfo_new_ret = TweenInfo.new(0.55, Enum.EasingStyle.Linear);
        local Folder = Instance.new("Folder");
        Folder.Name = "BloodLustClones";
        Folder.Parent = workspace.Debree;
        DebrisModule:AddItem(Folder, 1);

        for i = 1, 5 do
            local v21 = ReplicatedStorage.Assets.StarterCharacterCloneable:Clone();
            v21.Name = "Clone";
            local _ = i;

            for _, v in ipairs(v21:GetTags()) do
                v21:RemoveTag(v);
            end;

            for _, child in ipairs(v21:GetChildren()) do
                if child:IsA("BasePart") then
                    local v22 = u17:FindFirstChild(child.Name);

                    if v22 == nil then
                        child:Destroy();
                    else
                        child.CFrame = v22.CFrame;
                        child.Anchored = true;
                        child.CanCollide = false;
                        child.Color = Color3.new(0, 0, 0);
                        child.Material = Enum.Material.SmoothPlastic;
                        child.Transparency = child.Name == "HumanoidRootPart" and 1 or 0;

                        if child.Transparency < 1 then
                            TweenService:Create(child, TweenInfo_new_ret, {
                                Transparency = 1
                            }):Play();
                        end;
                    end;
                else
                    child:Destroy();
                end;
            end;

            v21.Parent = Folder;
            task.wait(0.07);
        end;
    end);
    Cam_Shaker(HumanoidRootPart.Position, {
        FadeInTime = 0,
        Frequency = 0.175,
        SustainTime = 0.2,
        FadeOutTime = 0.2,
        RotationInfluence = Vector3.new(0.2, 0.2, 0.2),
        PositionInfluence = Vector3.new(2.5, 2.5, 2.5),
        Amplitude = p18 == "Dash3" and 0.25 or 0.15
    });
end;