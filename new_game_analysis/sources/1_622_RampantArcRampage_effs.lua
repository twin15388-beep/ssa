-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("Players");
game:GetService("RunService");
local ParticleTween = require(ReplicatedStorage.CAM.Global.ParticleTween);
local vfxUtility = require(game.ReplicatedStorage.CAM.Client.Modules.Effects.vfxUtility);
local DebrisModule = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("DebrisModule"));
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

local function lerp(p2, p3, p4) -- Line: 24
    return p2 + (p3 - p2) * p4;
end;

local function QuadBezier(p5, p6, p7, p8) -- Line: 28
    local v9 = p6 + (p7 - p6) * p5;

    return v9 + (p7 + (p8 - p7) * p5 - v9) * p5;
end;

local Cam_Shaker = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Client"):WaitForChild("Modules"):WaitForChild("Effects"):WaitForChild("Cam_Shaker"));
local u10 = {
    FadeInTime = 0,
    Frequency = 0.125,
    Amplitude = 0.25,
    SustainTime = 10,
    FadeOutTime = 0.5,
    RotationInfluence = Vector3.new(0.15, 0.15, 0.15),
    PositionInfluence = Vector3.new(1, 1, 1)
};
game.ReplicatedStorage:WaitForChild("Player_Service"):WaitForChild("Values"):WaitForChild(game.Players.LocalPlayer.Name);

return function(p11: userdata, p12: any, p13: any) -- Line: 48
    -- upvalues: vfxUtility (copy), Sounds (copy), u1 (ref), DebrisModule (copy), Assets (copy), ParticleTween (copy), RaycastParams_new_ret (copy), TweenService (copy), Cam_Shaker (copy), u10 (copy)
    if p11 == nil or p12 == nil then
        return;
    end;

    local HumanoidRootPart = p11:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart == nil then
        return;
    end;

    if (HumanoidRootPart.Position - workspace.CurrentCamera.CFrame.Position).Magnitude >= 250 and (p12 ~= "Cancel" and p12 ~= "End") then
        return;
    end;

    local string_format_ret = string.format("%s RampantArcRampage", p11.Name);

    if p12 == "Windup" then
        vfxUtility.PlaySound(Sounds, "PS2bloodsickRARstart", HumanoidRootPart, true);

        return;
    end;

    if p12 ~= "Start" then
        if p12 == "Cancel" then
            if u1:FindFirstChild(string_format_ret) then
                local v14 = u1:FindFirstChild(string_format_ret);
                v14.Name = "_";
                v14:SetAttribute("Active", false);
                DebrisModule:AddItem(v14, 2.5);
                vfxUtility.EnableAll(v14, false);

                return;
            end;
        elseif p12 == "End" then
            if u1:FindFirstChild(string_format_ret) then
                local v15 = u1:FindFirstChild(string_format_ret);
                v15.Name = "_";
                v15:SetAttribute("Active", false);
                DebrisModule:AddItem(v15, 2.5);
                vfxUtility.EnableAll(v15, false);
            end;

            local v16 = Assets.EndEmit720Slash:Clone();
            ParticleTween:ResizeParticlesNoTween(v16, p13);
            v16.CFrame = HumanoidRootPart.CFrame;
            v16.Parent = u1;
            vfxUtility.EmitAll(v16);
            DebrisModule:AddItem(v16, 4);
            vfxUtility.PlaySound(Sounds, "PS2bloodsickRARend", v16, true);
            local v17 = workspace:Raycast(HumanoidRootPart.Position, -CFrame.new(HumanoidRootPart.Position).UpVector * 10, RaycastParams_new_ret);

            if v17 then
                local LookVector = HumanoidRootPart.CFrame.LookVector;
                local v18 = Assets.GroundMarksEndEmit:Clone();
                ParticleTween:ResizeParticlesNoTween(v18, p13);
                v18.CFrame = CFrame.new(v17.Position, v17.Position + LookVector);
                v18.Parent = u1;
                vfxUtility.EmitAll(v18);
                DebrisModule:AddItem(v18, 2.4);
            end;

            Cam_Shaker(HumanoidRootPart.Position, "Medium_tiny_shake_preset");
        end;

        return;
    end;

    local Folder = Instance.new("Folder");
    Folder.Name = string_format_ret;
    Folder.Parent = u1;
    DebrisModule:AddItem(Folder, 15);
    local v19 = Assets.SlashEnable720:Clone();
    v19.CFrame = HumanoidRootPart.CFrame;
    v19.Parent = Folder;
    vfxUtility.EnableAll(v19, true);
    ParticleTween:ResizeParticles(v19, 5, 3, "Sine", "Out");
    local v20 = workspace:Raycast(v19.Position + Vector3.new(0, 5, 0), -v19.CFrame.UpVector * 10, RaycastParams_new_ret);

    if v20 then
        local v21 = Assets.SlashEnableGroundMarks720:Clone();
        v21.CFrame = CFrame.new(v20.Position, v20.Position + v20.Normal) * CFrame.Angles(1.5707963267948966, 0, 0);
        v21.Parent = Folder;
        vfxUtility.EnableAll(v21, true);
        ParticleTween:ResizeParticles(v21, 4.5, 3, "Sine", "Out");
        TweenService:Create(v21, TweenInfo.new(5), {
            Size = v21.Size * 4
        }):Play();
    end;

    local u22 = Cam_Shaker(HumanoidRootPart.Position, u10);
    local u23 = vfxUtility.PlaySound(Sounds, "PS2bloodsickRARloop", v19, false);
    Folder:SetAttribute("Active", true);
    local u24 = {};

    local function v25() -- Line: 92
        -- upvalues: u24 (copy), u22 (copy), u23 (copy)
        for _, v in u24 do
            v:Disconnect();
        end;

        u22:Stop();
        u22:Destroy();

        if u23 and u23.IsPlaying then
            u23:Stop();
        end;
    end;

    table.insert(u24, Folder.AttributeChanged:Connect(v25));
    table.insert(u24, Folder.Destroying:Connect(v25));
end;