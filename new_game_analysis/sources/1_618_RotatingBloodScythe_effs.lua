-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("Players");
game:GetService("RunService");
require(ReplicatedStorage.CAM.Global.ParticleTween);
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

local function lerp(p2, p3, p4) -- Line: 23
    return p2 + (p3 - p2) * p4;
end;

local function QuadBezier(p5, p6, p7, p8) -- Line: 27
    local v9 = p6 + (p7 - p6) * p5;

    return v9 + (p7 + (p8 - p7) * p5 - v9) * p5;
end;

local Cam_Shaker = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Client"):WaitForChild("Modules"):WaitForChild("Effects"):WaitForChild("Cam_Shaker"));
local u10 = {
    FadeInTime = 0,
    Frequency = 0.125,
    Amplitude = 0.15,
    SustainTime = 10,
    FadeOutTime = 0.5,
    RotationInfluence = Vector3.new(0.15, 0.15, 0.15),
    PositionInfluence = Vector3.new(0.4, 0.4, 0.4)
};
game.ReplicatedStorage:WaitForChild("Player_Service"):WaitForChild("Values"):WaitForChild(game.Players.LocalPlayer.Name);

return function(p11: userdata, p12: any, p13: any) -- Line: 48
    -- upvalues: Assets (copy), vfxUtility (copy), DebrisModule (copy), Sounds (copy), u1 (ref), Cam_Shaker (copy), u10 (copy), TweenService (copy)
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

    local string_format_ret = string.format("%s RotatingBloodScythe", p11.Name);

    if p12 == "Windup" then
        local u14 = Assets:FindFirstChild("ChargeEffect"):Clone();
        u14.Parent = HumanoidRootPart;
        vfxUtility.EnableAll(u14, true);
        u14.CFrame = HumanoidRootPart.CFrame;
        vfxUtility.WeldConstraint(HumanoidRootPart, u14);
        task.delay(0.45, function() -- Line: 62
            -- upvalues: vfxUtility (ref), u14 (copy), DebrisModule (ref)
            vfxUtility.EnableAll(u14, false);
            DebrisModule:AddItem(u14, 2);
        end);
        vfxUtility.PlaySound(Sounds, "Rotatingstart", u14, true);

        return;
    end;

    if p12 ~= "Start" then
        if p12 == "Cancel" then
            if u1:FindFirstChild(string_format_ret) then
                local v15 = u1:FindFirstChild(string_format_ret);
                v15.Name = "_";
                v15:SetAttribute("Active", false);
                DebrisModule:AddItem(v15, 3.5);
                vfxUtility.EnableAll(v15, false);
                local Blood = v15:FindFirstChild("Blood");

                if Blood ~= nil then
                    vfxUtility.EnableAll(Blood.Part, true);
                    task.delay(0.5, function() -- Line: 134
                        -- upvalues: vfxUtility (ref), Blood (copy), DebrisModule (ref)
                        vfxUtility.EnableAll(Blood.Part, false);
                        DebrisModule:AddItem(Blood, 1.25);
                    end);

                    return;
                end;
            end;
        elseif p12 == "End" then
            if u1:FindFirstChild(string_format_ret) then
                local v16 = u1:FindFirstChild(string_format_ret);
                v16.Name = "_";
                v16:SetAttribute("Active", false);
                DebrisModule:AddItem(v16, 3.5);
                vfxUtility.EnableAll(v16, false);
                local Blood = v16:FindFirstChild("Blood");

                if Blood ~= nil then
                    vfxUtility.EnableAll(Blood.Part, true);
                    task.delay(0.5, function() -- Line: 154
                        -- upvalues: vfxUtility (ref), Blood (copy), DebrisModule (ref)
                        vfxUtility.EnableAll(Blood.Part, false);
                        DebrisModule:AddItem(Blood, 1.25);
                    end);
                end;
            end;

            local v17 = Assets.Punch:Clone();
            v17:PivotTo(HumanoidRootPart.CFrame * CFrame.new(0, -3, -2) * CFrame.Angles(-1.5707963267948966, 0, 0));
            v17.Parent = u1;
            vfxUtility.EmitAll(v17);
            DebrisModule:AddItem(v17, 2);
            Cam_Shaker(HumanoidRootPart.Position, "Medium_tiny_shake_preset");
            vfxUtility.PlaySound(Sounds, "Rotatingpunch", v17.PrimaryPart, true);
        end;

        return;
    end;

    local Folder = Instance.new("Folder");
    Folder.Name = string_format_ret;
    Folder.Parent = u1;
    DebrisModule:AddItem(Folder, 7.5);
    local v18 = Assets.Cast:Clone();
    v18.CFrame = HumanoidRootPart.CFrame;
    v18.Parent = Folder;
    vfxUtility.EmitAll(v18);
    DebrisModule:AddItem(v18, 3);
    vfxUtility.PlaySound(Sounds, "Rotatingexplode", HumanoidRootPart, true);
    task.wait(0.125);

    if Folder.Parent == nil or Folder.Name ~= string_format_ret then
        return;
    end;

    local v19 = Assets["Rotating Blood Scythe"]:Clone();
    v19.Name = "Blood";
    v19:PivotTo(HumanoidRootPart.CFrame);
    v19.Parent = Folder;
    vfxUtility.EnableAll(v19, true);
    vfxUtility.WeldConstraint(HumanoidRootPart, v19.PrimaryPart);
    local u20 = vfxUtility.PlaySound(Sounds, "Rotatingloop", v19.PrimaryPart, false);
    local u21 = Cam_Shaker(HumanoidRootPart.Position, u10);
    Folder:SetAttribute("Active", true);
    local u22 = {};

    local function v23() -- Line: 103
        -- upvalues: u22 (copy), u21 (copy), u20 (copy), TweenService (ref), DebrisModule (ref)
        for _, v in u22 do
            v:Disconnect();
        end;

        u21:Stop();
        u21:Destroy();

        if u20 then
            TweenService:Create(u20, TweenInfo.new(0.4), {
                Volume = 0
            }):Play();
            DebrisModule:AddItem(u20, 0.4);
        end;
    end;

    table.insert(u22, Folder.AttributeChanged:Connect(v23));
    table.insert(u22, Folder.Destroying:Connect(v23));
end;