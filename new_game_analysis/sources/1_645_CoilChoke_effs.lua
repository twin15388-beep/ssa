-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("Debris");
game:GetService("Players");
game:GetService("RunService");
require(ReplicatedStorage.CAM.Global.ParticleTween);
local CraterHandler = require(ReplicatedStorage.CAM.Client.Modules.Effects.Craters.CraterHandler);
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
local Cam_Shaker = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Client"):WaitForChild("Modules"):WaitForChild("Effects"):WaitForChild("Cam_Shaker"));
local u2 = {
    FadeInTime = 0,
    Frequency = 0.1,
    Amplitude = 0.25,
    SustainTime = 10,
    FadeOutTime = 0.5,
    RotationInfluence = Vector3.new(0.15, 0.15, 0.15),
    PositionInfluence = Vector3.new(1, 1, 1)
};
local AuraEffects = require(script.Parent.AuraEffects);
game.ReplicatedStorage:WaitForChild("Player_Service"):WaitForChild("Values"):WaitForChild(game.Players.LocalPlayer.Name);

local function folderAlive(p3: userdata?) -- Line: 42
    local v4;

    if p3 == nil or p3.Parent == nil then
        v4 = false;
    else
        v4 = p3:GetAttribute("Cancelled") ~= true;
    end;

    return v4;
end;

return function(p5: userdata, p6: any, p7: boolean) -- Line: 46
    -- upvalues: AuraEffects (copy), u1 (ref), DebrisModule (copy), Assets (copy), vfxUtility (copy), Sounds (copy), Cam_Shaker (copy), u2 (copy), RaycastParams_new_ret (copy), TweenService (copy), CraterHandler (copy)
    if p5 == nil or p6 == nil then
        return;
    end;

    local HumanoidRootPart = p5:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart == nil then
        return;
    end;

    if (HumanoidRootPart.Position - workspace.CurrentCamera.CFrame.Position).Magnitude >= 250 and p6 ~= "Cancel" then
        return;
    end;

    p5:FindFirstChild("RightHand");
    local LeftHand = p5:FindFirstChild("LeftHand");
    local string_format_ret = string.format("%s CoilChokeEffects", p5.Name);

    if p6 == "Startup" then
        AuraEffects.TurnOnAura(p5);

        return;
    end;

    if p6 ~= "Start" then
        if p6 == "Cancel" then
            AuraEffects.TurnOffAura(p5);

            if u1:FindFirstChild(string_format_ret) then
                local v8 = u1:FindFirstChild(string_format_ret);
                v8.Name = "_";
                v8:SetAttribute("Cancelled", true);
                v8:SetAttribute("Active", false);
                DebrisModule:AddItem(v8, 2.5);

                if v8:FindFirstChild("Slashes") then
                    vfxUtility.EnableAll(v8:FindFirstChild("Slashes"), false);

                    if not p7 then
                        local v9 = next;
                        local Descendants, v10 = v8:FindFirstChild("Slashes"):GetDescendants();

                        for _, v in v9, Descendants, v10 do
                            if v.ClassName == "Sound" and v.IsPlaying then
                                v:Stop();
                            end;
                        end;

                        return;
                    end;
                end;
            end;
        elseif p6 == "Success" then
            AuraEffects.TurnOffAura(p5);

            if u1:FindFirstChild(string_format_ret) then
                local v11 = u1:FindFirstChild(string_format_ret);
                v11.Name = "_";
                v11:SetAttribute("Cancelled", true);
                v11:SetAttribute("Active", false);
                DebrisModule:AddItem(v11, 2.5);

                if v11:FindFirstChild("Slashes") then
                    vfxUtility.EnableAll(v11:FindFirstChild("Slashes"), false);

                    if not p7 then
                        local v12 = next;
                        local Descendants, v13 = v11:FindFirstChild("Slashes"):GetDescendants();

                        for _, v in v12, Descendants, v13 do
                            if v.ClassName == "Sound" and v.IsPlaying then
                                v:Stop();
                            end;
                        end;
                    end;
                end;
            end;

            task.wait(0.28);
            vfxUtility.PlaySound(Sounds, "PS2snakeCCcomboslam", HumanoidRootPart, true);
            local v14 = Assets.Grab:Clone();
            v14.CFrame = LeftHand.CFrame;
            v14.Parent = u1;
            vfxUtility.EmitAll(v14);
            DebrisModule:AddItem(v14, 2);
            task.wait(0.55);
            local v15 = Cam_Shaker(HumanoidRootPart.Position, u2);
            task.wait(0.07);
            local v16 = Assets.HeadCharge:Clone();
            v16.CFrame = LeftHand.CFrame * CFrame.new(0, -1, 0);
            v16.Parent = u1;
            vfxUtility.EnableAll(v16, true);
            DebrisModule:AddItem(v16, 2);
            task.wait(1.1);
            v15:Stop();
            v15:Destroy();
            Cam_Shaker(v16.Position, "Medium_tiny_shake_preset");
            vfxUtility.EnableAll(v16, false);
            local v17 = Assets.Grab:Clone();
            v17.CFrame = LeftHand.CFrame;
            v17.Parent = u1;
            vfxUtility.EmitAll(v17);
            DebrisModule:AddItem(v17, 2);
            task.wait(0.66);
            local v18 = Assets.SwordImpact:Clone();
            v18.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, -2.7, -3);
            v18.Parent = u1;
            local v19 = workspace:Raycast(v18.Position, v18.CFrame.UpVector * -6, RaycastParams_new_ret);
            local Descendants = v18:GetDescendants();

            if v19 == nil then
                for _, v in pairs(Descendants) do
                    if v.Name == "Craters" then
                        table.remove(Descendants, table.find(Descendants, v));
                    end;
                end;
            end;

            vfxUtility.EmitAll(Descendants);
            DebrisModule:AddItem(v18, 3);

            for _, descendant in v18:GetDescendants() do
                if descendant:IsA("Beam") then
                    descendant.Enabled = true;
                    local Width0 = descendant.Width0;
                    local Width1 = descendant.Width1;
                    descendant.Width0 = 0;
                    descendant.Width1 = 0;
                    TweenService:Create(descendant, TweenInfo.new(0.2), {
                        Width0 = Width0,
                        Width1 = Width1
                    }):Play();
                    task.delay(descendant:GetAttribute("EmitDuration"), function() -- Line: 210
                        -- upvalues: TweenService (ref), descendant (copy)
                        TweenService:Create(descendant, TweenInfo.new(0.5), {
                            Width0 = 0,
                            Width1 = 0
                        }):Play();
                    end);
                end;
            end;

            Cam_Shaker(v18.Position, "medium_shake_preset");

            if v19 then
                CraterHandler.new("Crater", HumanoidRootPart.CFrame * CFrame.new(0, 0, -3), {
                    Radius = 10,
                    Range = 50,
                    PartCount = 12,
                    HoldTime = 1,
                    BlockSize = { 2, 4 },
                    Angle = { 45, 90 },
                    Height = { -2, -1.5 },
                    Tilt = { -14, 14 },
                    FlourishTypes = {
                        Exit = "Melt",
                        ExitDivision = "Iterate",
                        ExitSpeed = 2
                    }
                });
                CraterHandler.new("Break", v18.CFrame * CFrame.new(0, 5, 0), {
                    PartCount = 10,
                    Range = 15,
                    Radius = 15,
                    HoldTime = 1.5,
                    BlockSize = { 0.5, 1.5 },
                    Height = { 30, 100 }
                });
            end;

            AuraEffects.TurnOffAura(p5);
        end;

        return;
    end;

    local Folder = Instance.new("Folder");
    Folder.Name = string_format_ret;
    Folder.Parent = u1;
    DebrisModule:AddItem(Folder, 7.5);
    task.wait(0.2);
    local v20;

    if Folder == nil or Folder.Parent == nil then
        v20 = false;
    else
        v20 = Folder:GetAttribute("Cancelled") ~= true;
    end;

    if not v20 then
        return;
    end;

    local v21 = Assets.Slashes:Clone();
    v21.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 0, -6);
    v21.Parent = Folder;
    vfxUtility.EnableAll(v21, true);
    vfxUtility.WeldConstraint(HumanoidRootPart, v21);
    vfxUtility.PlaySound(Sounds, "PS2snakeCCslashbrrg", v21, true);
    local u22 = Cam_Shaker(v21.Position, u2);
    Folder:SetAttribute("Active", true);
    local u23 = {};

    local function v24() -- Line: 79
        -- upvalues: u23 (copy), u22 (ref)
        for _, v in u23 do
            v:Disconnect();
        end;

        if u22 then
            u22:Stop();
            u22:Destroy();
            u22 = nil;
        end;
    end;

    table.insert(u23, Folder.AttributeChanged:Connect(v24));
    table.insert(u23, Folder.Destroying:Connect(v24));
    task.wait(1);
    vfxUtility.EnableAll(v21, false);
    DebrisModule:AddItem(v21, 2);
end;