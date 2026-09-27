-- Decompiled with Potassium's decompiler.

local DebrisModule = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("DebrisModule"));
local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("Debris");
game:GetService("Players");
game:GetService("RunService");
require(ReplicatedStorage.CAM.Global.ParticleTween);
local vfxUtility = require(game.ReplicatedStorage.CAM.Client.Modules.Effects.vfxUtility);
local u1 = workspace.Debree:FindFirstChild(game.Players.LocalPlayer.Name .. "\'s effects debree thing213asdasdasdasd");

if u1 == nil then
    u1 = Instance.new("Folder", workspace.Debree);
    u1.Name = game.Players.LocalPlayer.Name .. "\'s effects debree thing213asdasdasdasd";
end;

local Assets = script:FindFirstChild("Assets");
local Sounds = script:FindFirstChild("Sounds");
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Include;
RaycastParams_new_ret.FilterDescendantsInstances = { workspace.Map };

local function lerp(p2, p3, p4) -- Line: 25
    return p2 + (p3 - p2) * p4;
end;

local function QuadBezier(p5, p6, p7, p8) -- Line: 29
    local v9 = p6 + (p7 - p6) * p5;

    return v9 + (p7 + (p8 - p7) * p5 - v9) * p5;
end;

function Weld(p10, p11)
    local WeldConstraint = Instance.new("WeldConstraint");
    WeldConstraint.Part0 = p10;
    WeldConstraint.Part1 = p11;
    WeldConstraint.Parent = p11;
end;

local Cam_Shaker = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Client"):WaitForChild("Modules"):WaitForChild("Effects"):WaitForChild("Cam_Shaker"));
local u12 = {
    FadeInTime = 0,
    Frequency = 0.125,
    Amplitude = 0.25,
    SustainTime = 10,
    FadeOutTime = 0.5,
    RotationInfluence = Vector3.new(0.15, 0.15, 0.15),
    PositionInfluence = Vector3.new(1, 1, 1)
};
game.ReplicatedStorage:WaitForChild("Player_Service"):WaitForChild("Values"):WaitForChild(game.Players.LocalPlayer.Name);
require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Client"):WaitForChild("Modules"):WaitForChild("Effects"):WaitForChild("vfxUtility"));

return function(p13: userdata, p14: any, u15) -- Line: 56
    -- upvalues: Cam_Shaker (copy), vfxUtility (copy), DebrisModule (copy), u1 (ref), Assets (copy), Sounds (copy), u12 (copy), RaycastParams_new_ret (copy), TweenService (copy)
    if p13 == nil or p14 == nil then
        return;
    end;

    local HumanoidRootPart = p13:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart == nil then
        return;
    end;

    if (HumanoidRootPart.Position - workspace.CurrentCamera.CFrame.Position).Magnitude >= 250 and (p14 ~= "Cancel" and p14 ~= "End") then
        return;
    end;

    local string_format_ret = string.format("%s OnSlaughtSlashesEffects", p13.Name);
    local string_format_ret2 = string.format("%s OnSlaughtDashEffects", p13.Name);

    if p14 == "Init" then
        Cam_Shaker(HumanoidRootPart.Position, "activate_shake");
        local v16 = script.Assets.Emit:Clone();
        local Weld2 = Instance.new("Weld");
        Weld2.Part0 = HumanoidRootPart;
        Weld2.Part1 = v16;
        Weld2.Parent = v16;
        v16.Parent = workspace.Debree;
        vfxUtility.EmitAll(v16);
        DebrisModule:AddItem(v16, 2.5);
        v16.Sound:Play();

        return;
    end;

    if p14 == "Dash" then
        local Folder = Instance.new("Folder");
        Folder.Name = string_format_ret2;
        Folder.Parent = u1;
        Folder:SetAttribute("Active", true);
        DebrisModule:AddItem(Folder, 7.5);

        for _, child in pairs(Assets.Model:GetChildren()) do
            local v17 = child:Clone();
            v17.Parent = Folder;
            vfxUtility.EnableAll(v17, true);
            v17.Weld.Part0 = HumanoidRootPart;

            if v17.Name == "HumanoidRootPart" then
                vfxUtility.PlaySound(Sounds, "PS2bloodsickOSdash", v17, true);
                vfxUtility.PlaySound(Sounds, "PS2bloodsickONSLAUGHTdashloop", v17, false);
            end;
        end;

        task.spawn(function() -- Line: 96
            -- upvalues: Cam_Shaker (ref), HumanoidRootPart (copy), u12 (ref), Folder (copy)
            local v18 = Cam_Shaker(HumanoidRootPart.Position, u12);

            while Folder ~= nil and (Folder:IsDescendantOf(game.Workspace) and Folder:GetAttribute("Active")) do
                v18.center_pos = HumanoidRootPart.Position;
                task.wait();
            end;

            v18:Stop();
            v18:Destroy();
        end);

        return;
    end;

    if p14 == "Cancel" then
        local v19 = { string_format_ret2, string_format_ret };

        for _, child in pairs(u1:GetChildren()) do
            if table.find(v19, child.Name) then
                child.Name = "_";
                child:SetAttribute("Active", false);
                DebrisModule:AddItem(child, 2.5);
                vfxUtility.EnableAll(child, false);
            end;
        end;

        return;
    end;

    if p14 == "Slashes" then
        local Folder = Instance.new("Folder");
        Folder.Name = string_format_ret;
        Folder.Parent = u1;
        DebrisModule:AddItem(Folder, 7.5);
        vfxUtility.PlaySound(Sounds, "PSbloodNEWbarrage", HumanoidRootPart, true);
        local v20 = Assets.Slashes:Clone();
        v20.CFrame = HumanoidRootPart.CFrame;
        v20.Parent = Folder;
        vfxUtility.EnableAll(v20, true);
        local v21 = workspace:Raycast(v20.Position + Vector3.new(0, 5, 0), -v20.CFrame.UpVector * 10, RaycastParams_new_ret);

        if v21 then
            local v22 = Assets.GroundSTuff:Clone();
            v22.CFrame = CFrame.new(v21.Position, v21.Position + v21.Normal) * CFrame.Angles(1.5707963267948966, 0, 0);
            v22.Parent = Folder;
            vfxUtility.EnableAll(v22, true);
        end;

        local u23 = Cam_Shaker(HumanoidRootPart.Position, u12);
        Folder:SetAttribute("Active", true);
        local u24 = {};

        local function v25() -- Line: 143
            -- upvalues: u24 (copy), u23 (copy)
            for _, v in u24 do
                v:Disconnect();
            end;

            u23:Stop();
            u23:Destroy();
        end;

        table.insert(u24, Folder.AttributeChanged:Connect(v25));
        table.insert(u24, Folder.Destroying:Connect(v25));

        return;
    end;

    if p14 ~= "End" then
        if p14 ~= "Jump" then
            if p14 == "Shoot" then
                vfxUtility.PlaySound(Sounds, "PSbloodNEWburst", HumanoidRootPart, true);
                local v26 = Assets.CastFX:Clone();
                v26.CFrame = HumanoidRootPart.CFrame;
                v26.Parent = u1;
                vfxUtility.EmitAll(v26);
                DebrisModule:AddItem(v26, 1.25);
                Cam_Shaker(v26.Position, "activate_shake");
                local u27 = Assets.Sickles:Clone();
                u27.CFrame = CFrame.new(HumanoidRootPart.Position, u15.Position) * CFrame.Angles(0, 1.5707963267948966, 0);
                u27.Parent = u1;
                vfxUtility.EnableAll(u27, true);
                local v28 = TweenService:Create(u27, TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    CFrame = u15
                });
                v28:Play();
                v28.Completed:Connect(function() -- Line: 249
                    -- upvalues: vfxUtility (ref), Sounds (ref), HumanoidRootPart (copy), u27 (copy), DebrisModule (ref), Assets (ref), u15 (copy), u1 (ref), Cam_Shaker (ref), RaycastParams_new_ret (ref)
                    vfxUtility.PlaySound(Sounds, "PSbloodNEWexplo", HumanoidRootPart, true);
                    vfxUtility.EnableAll(u27, false);
                    DebrisModule:AddItem(u27, 1.25);
                    local v29 = Assets.ExplosionSlashVFX:Clone();
                    v29.CFrame = CFrame.new(u15.Position);
                    v29.Parent = u1;
                    vfxUtility.EmitAll(v29);
                    DebrisModule:AddItem(v29, 3);
                    Cam_Shaker(v29.Position, "Medium_tiny_shake_preset");
                    local v30 = workspace:Raycast(v29.Position + Vector3.new(0, 5, 0), -v29.CFrame.UpVector * 15, RaycastParams_new_ret);

                    if v30 then
                        local v31 = Assets.GroundSTuffExplosion:Clone();
                        v31.CFrame = CFrame.new(v30.Position, v30.Position + v30.Normal) * CFrame.Angles(1.5707963267948966, 0, 0);
                        v31.Parent = u1;
                        vfxUtility.EmitAll(v31);
                        DebrisModule:AddItem(v31, 4);
                    end;
                end);
            end;

            return;
        end;

        local v32 = workspace:Raycast(HumanoidRootPart.Position, -HumanoidRootPart.CFrame.UpVector * 10, RaycastParams_new_ret);

        if v32 then
            local v33 = Assets.JumpFX:Clone();
            v33.CFrame = CFrame.new(v32.Position) * CFrame.new(0, 1, 0);
            v33.Parent = u1;
            vfxUtility.EmitAll(v33);
            DebrisModule:AddItem(v33, 1.75);
        end;

        local v34 = Assets.PartForAnchor:Clone();
        v34.Parent = u1;
        v34.CFrame = HumanoidRootPart.CFrame;
        Weld(HumanoidRootPart, v34);
        DebrisModule:AddItem(v34, 3.2);

        return;
    end;

    vfxUtility.PlaySound(Sounds, "PSbloodNEWslash", HumanoidRootPart, true);
    local v35 = { string_format_ret2, string_format_ret };

    for _, child in pairs(u1:GetChildren()) do
        if table.find(v35, child.Name) then
            child.Name = "_";
            child:SetAttribute("Active", false);
            DebrisModule:AddItem(child, 2.5);
            vfxUtility.EnableAll(child, false);
        end;
    end;

    local v36 = Assets.EndEmit:Clone();
    v36.CFrame = HumanoidRootPart.CFrame;
    v36.Parent = u1;
    vfxUtility.EmitAll(v36);
    DebrisModule:AddItem(v36, 4);
    local v37 = Assets.XSlash:Clone();
    v37.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 0, -5);
    v37.Parent = u1;
    vfxUtility.EmitAll(v37);
    DebrisModule:AddItem(v37, 3);
    local v38 = next;
    local Descendants, v39 = v37:GetDescendants();

    for _, v in v38, Descendants, v39 do
        if v.ClassName == "Beam" then
            local Width0 = v.Width0;
            local Width1 = v.Width1;
            v.Width0 = 0;
            v.Width1 = 0;
            TweenService:Create(v, TweenInfo.new(0.2), {
                Width0 = Width0,
                Width1 = Width1
            }):Play();
            task.delay(0.2, function() -- Line: 192
                -- upvalues: TweenService (ref), v (copy)
                TweenService:Create(v, TweenInfo.new(0.4), {
                    Width0 = 0,
                    Width1 = 0,
                    TextureLength = 0,
                    TextureSpeed = 0
                }):Play();
            end);
        end;
    end;

    local v40 = workspace:Raycast(v37.Position + Vector3.new(0, 5, 0), -CFrame.new(v37.Position).UpVector * 10, RaycastParams_new_ret);

    if v40 then
        local LookVector = HumanoidRootPart.CFrame.LookVector;
        local v41 = Assets.GroundMark:Clone();
        v41.CFrame = CFrame.new(v40.Position, v40.Position + LookVector);
        v41.Parent = u1;
        vfxUtility.EmitAll(v41);
        DebrisModule:AddItem(v41, 1.15);
    end;

    Cam_Shaker(HumanoidRootPart.Position, "activate_shake");
end;