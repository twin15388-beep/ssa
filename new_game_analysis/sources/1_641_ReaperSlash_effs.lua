-- Decompiled with Potassium's decompiler.

local DebrisModule = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("DebrisModule"));
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Ouwmit = require(ReplicatedStorage.CAM.Client.Modules.Effects.Ouwmit);
local vfxUtility = require(ReplicatedStorage.CAM.Client.Modules.Effects.vfxUtility);
local Cam_Shaker = require(ReplicatedStorage.CAM.Client.Modules.Effects.Cam_Shaker);

local function folderName(p1: userdata) -- Line: 15
    return `{p1.Name}-ReaperSlash`;
end;

local function BlurEffect(p2) -- Line: 19
    -- upvalues: DebrisModule (copy)
    local BlurEffect = Instance.new("BlurEffect");
    BlurEffect.Size = 8;
    BlurEffect.Parent = game.Lighting;
    DebrisModule:AddItem(BlurEffect, p2 or 0.08333333333333333);
end;

local function detachRig(p3) -- Line: 29
    local HumanoidRootPart = p3:FindFirstChild("HumanoidRootPart");
    local v4 = HumanoidRootPart and HumanoidRootPart:FindFirstChild("RigHumAttach");

    if v4 then
        v4:Destroy();
    end;
end;

local function destroyFolder(p5: userdata) -- Line: 41
    -- upvalues: vfxUtility (copy), DebrisModule (copy)
    local HumanoidRootPart = p5:FindFirstChild("HumanoidRootPart");
    local v6 = HumanoidRootPart and HumanoidRootPart:FindFirstChild("RigHumAttach");

    if v6 then
        v6:Destroy();
    end;

    local v7 = workspace.Debree:FindFirstChild((`{p5.Name}-ReaperSlash`));

    if v7 and v7.Parent then
        vfxUtility.EnableAll(v7, false, nil, true);
        v7.Name = "--";
        DebrisModule:AddItem(v7, 1.3);
    end;
end;

return function(p8: userdata, p9: any, p10) -- Line: 57
    -- upvalues: destroyFolder (copy), DebrisModule (copy), vfxUtility (copy), Ouwmit (copy), Cam_Shaker (copy)
    if p8 == nil then
        return;
    end;

    if p9 == "End" or p9 == "Cancel" then
        destroyFolder(p8);
    end;

    if p9 == "Cancel" then
        return;
    end;

    local HumanoidRootPart = p8:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    if (HumanoidRootPart.Position - workspace.CurrentCamera.CFrame.Position).Magnitude >= 250 then
        return;
    end;

    if p9 ~= "Start" then
        if p9 == "End" then
            local v11 = p10 or HumanoidRootPart.CFrame;
            local v12 = vfxUtility.CheckForGround(v11.Position, Vector3.new(0, -20, 0), vfxUtility.RayParams.Map);
            local v13 = script.End:Clone();
            v13.Parent = workspace.Debree;
            v13:PivotTo(v11);
            Ouwmit.Emit(v13, vfxUtility.GetDustColorSettings(v12));
            DebrisModule:AddItem(v13, 5);
            vfxUtility.PlaySound(script.Sounds, "PS2scytheREAPERSLASHslam", HumanoidRootPart, true);
            Cam_Shaker(HumanoidRootPart.Position, {
                FadeInTime = 0,
                Frequency = 0.1,
                Amplitude = 0.8,
                SustainTime = 0.4,
                FadeOutTime = 0.4,
                RotationInfluence = Vector3.new(0.3, 0.3, 0.3),
                PositionInfluence = Vector3.new(4, 4, 4)
            });
            local BlurEffect2 = Instance.new("BlurEffect");
            BlurEffect2.Size = 8;
            BlurEffect2.Parent = game.Lighting;
            DebrisModule:AddItem(BlurEffect2, 0.3);
        end;

        return;
    end;

    destroyFolder(p8);
    local Folder = Instance.new("Folder");
    Folder.Name = `{p8.Name}-ReaperSlash`;
    Folder.Parent = workspace.Debree;
    DebrisModule:AddItem(Folder, 5);
    local v14 = vfxUtility.CheckForGround(HumanoidRootPart.Position, Vector3.new(0, -20, 0), vfxUtility.RayParams.Map);
    local v15 = script.Jump:Clone();
    v15.Parent = Folder;
    v15:PivotTo(HumanoidRootPart.CFrame);
    Ouwmit.Emit(v15, vfxUtility.GetDustColorSettings(v14));
    DebrisModule:AddItem(v15, 5);
    vfxUtility.PlaySound(script.Sounds, "PS2scytheREAPERSLASHjump", HumanoidRootPart, true);
    local BlurEffect2 = Instance.new("BlurEffect");
    BlurEffect2.Size = 8;
    BlurEffect2.Parent = game.Lighting;
    DebrisModule:AddItem(BlurEffect2, 0.2);
    local v16 = script.Loop:Clone();
    v16.Parent = Folder;
    v16:PivotTo(HumanoidRootPart.CFrame);
    Ouwmit.Emit(v16, vfxUtility.GetDustColorSettings(v14));
    local v17 = vfxUtility.PlaySound(script.Sounds, "PS2scytheREAPERSLASHloop", v16.HumanoidRootPart);

    if v17 then
        v17.Looped = true;
    end;

    local RigidConstraint = v16.HumanoidRootPart.RootRigAttachment.RigidConstraint;
    local RigHumAttach = v16.HumanoidRootPart.RootRigAttachment.RigHumAttach;
    RigHumAttach.Parent = HumanoidRootPart;
    RigidConstraint.Attachment1 = RigHumAttach;
    Cam_Shaker(HumanoidRootPart.Position, {
        FadeInTime = 0,
        Frequency = 0.1,
        Amplitude = 0.4,
        SustainTime = 0.2,
        FadeOutTime = 0.2,
        RotationInfluence = Vector3.new(0.2, 0.2, 0.2),
        PositionInfluence = Vector3.new(2.5, 2.5, 2.5)
    });
end;