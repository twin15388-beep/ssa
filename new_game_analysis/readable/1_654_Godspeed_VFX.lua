-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
game:GetService("RunService");
game:GetService("ReplicatedStorage");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local _ = ReplicatedStorage.CAM.Client.Modules;
local _ = Players.LocalPlayer;
local Assets = script:FindFirstChild("Assets");
local workspace_Debree = workspace.Debree;
local Sounds = script:FindFirstChild("Sounds");
local vfxUtility = require(game.ReplicatedStorage.CAM.Client.Modules.Effects.vfxUtility);
local DebrisModule = require(game.ReplicatedStorage.CAM.DebrisModule);
local Ouwmit = require(ReplicatedStorage.CAM.Client.Modules.Effects.Ouwmit);
local RaycastHelper = require(ReplicatedStorage.CAM.Global.RaycastHelper);
local _ = game.Players.LocalPlayer;
local _ = workspace.CurrentCamera;
local OuwCraters = require(ReplicatedStorage.CAM.Client.Modules.Effects.Craters.OuwCraters);
local Cam_Shaker = require(ReplicatedStorage.CAM.Client.Modules.Effects.Cam_Shaker);

return function(p1: userdata, p2: any, p3: any, p4: any) -- Line: 38
    -- upvalues: workspace_Debree (copy), DebrisModule (copy), Assets (copy), vfxUtility (copy), Sounds (copy), OuwCraters (copy), Cam_Shaker (copy), RaycastHelper (copy), TweenService (copy), Ouwmit (copy)
    local HumanoidRootPart = p1:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local string_format_ret = string.format("%s_%s_Effects", p1.Name, script.Name);

    if p2 ~= "Cancel" and (HumanoidRootPart.Position - workspace.CurrentCamera.CFrame.Position).Magnitude > 250 then
        return;
    end;

    if p2 == "Start" then
        if not workspace_Debree:FindFirstChild(string_format_ret) then
            local Folder = Instance.new("Folder");
            Folder.Name = string_format_ret;
            Folder.Parent = workspace_Debree;
            DebrisModule:AddItem(Folder, 12);
        end;

        local u5 = workspace_Debree:FindFirstChild(string_format_ret);
        u5:SetAttribute("Active", true);
        local v6 = Assets.Startup:Clone();
        v6.CFrame = HumanoidRootPart.CFrame;
        v6.Parent = u5;
        vfxUtility.EmitAll(v6);
        DebrisModule:AddItem(v6, 2);
        vfxUtility.PlaySound(Sounds, "PS2thunderbreathGODSPEEDlaunch", HumanoidRootPart, true);
        local u7 = Assets.GodSpeed_Trail:Clone();
        u7.CFrame = HumanoidRootPart.CFrame;
        u7.Parent = u5;
        vfxUtility.EnableAll(u7, true);
        DebrisModule:AddItem(u7, 8);
        local u8 = vfxUtility.PlaySound(Sounds, "PS2thunderbreathGODSPEEDloopTRUE", HumanoidRootPart);
        u5.AttributeChanged:Connect(function() -- Line: 78
            -- upvalues: u5 (copy), u8 (copy), HumanoidRootPart (copy)
            if u5:GetAttribute("Active") then
                return;
            end;

            if u8.Parent == HumanoidRootPart then
                u8:Destroy();
            end;
        end);
        OuwCraters.Scales({
            Duration = 2,
            Count = 10,
            OffsetMargin = 10,
            Radius = 12,
            Center = HumanoidRootPart.CFrame
        });
        Cam_Shaker(HumanoidRootPart.Position, "Medium_tiny_shake_preset");
        local v9 = Assets.Direction:Clone();
        v9.Parent = u5;
        local v10 = nil;
        local v11 = true;

        while u5 ~= nil and (u5.Parent ~= nil and u5:GetAttribute("Active")) do
            v11 = not v11;
            local CFrame2 = HumanoidRootPart.CFrame;
            local v12 = HumanoidRootPart.CFrame * CFrame.new(v11 and -15 or 15, 0, -10);
            v9.CFrame = CFrame2;
            vfxUtility.EmitAll(v9);

            if (CFrame2.Position - v12.Position).Magnitude < 40 then
                local v13 = workspace:Raycast(CFrame2.Position, (v12.Position - CFrame2.Position).Unit * ((CFrame2.Position - v12.Position).Magnitude + 1), RaycastHelper.Crater);

                if v13 then
                    v12 = CFrame.new(v13.Position);
                end;
            end;

            v10 = TweenService:Create(u7, TweenInfo.new(0.15), {
                Position = v12.Position
            });
            v10:Play();
            task.wait(0.15);
        end;

        if v10 then
            v10:Pause();
            TweenService:Create(u7, TweenInfo.new(0.05), {
                CFrame = HumanoidRootPart.CFrame
            }):Play();
            task.delay(0.05, function() -- Line: 131
                -- upvalues: vfxUtility (ref), u7 (copy)
                vfxUtility.EnableAll(u7, false);
            end);
        end;

        DebrisModule:AddItem(u7, 2);
        DebrisModule:AddItem(v9, 2);

        return;
    end;

    if p2 ~= "Success" then
        if p2 == "Cancel" then
            local v14 = workspace_Debree:FindFirstChild(string_format_ret);

            if v14 then
                v14:SetAttribute("Active", nil);
                v14.Name = "_";
                DebrisModule:AddItem(v14, 3);
            end;

            vfxUtility.PlaySound(Sounds, "PS2thunderbreathGODSPEEDstopmoving", HumanoidRootPart, true);
        end;

        return;
    end;

    local v15 = {};

    for _, v in ipairs(p4) do
        local LowerTorso = v:FindFirstChild("LowerTorso");

        if LowerTorso ~= nil then
            local v16 = script.Assets.StunVFX:Clone();
            v16:PivotTo(LowerTorso.CFrame);
            v16.Parent = LowerTorso;
            v16.WeldConstraint.Part1 = LowerTorso;
            Ouwmit.Enable(v16);
            local v17 = script.Assets.YellowHighlight:Clone();
            v17.Parent = v16;
            v17.Adornee = v;
            table.insert(v15, v17);
            table.insert(v15, v16);
            DebrisModule:AddItem(v16, 4);
        end;
    end;

    local v18 = workspace_Debree:FindFirstChild(string_format_ret);
    local v19 = HumanoidRootPart.CFrame * CFrame.new(0, -1.75, 0) * CFrame.Angles(0, 3.141592653589793, 0);

    if v18 then
        v18:SetAttribute("Active", nil);
        v18.Name = "_";
        DebrisModule:AddItem(v18, 3);
    end;

    local v20 = workspace:Raycast(HumanoidRootPart.Position, HumanoidRootPart.CFrame.upVector * -30, RaycastHelper.Crater);
    local v21, v22;

    if v20 == nil or v20.Instance == nil then
        v21 = nil;
        v22 = nil;
    else
        v21 = CFrame.new(v20.Position, v20.Position + v20.Normal) * CFrame.Angles(-1.5707963267948966, 0, 0) * CFrame.new(0, 1, 0);
        v22 = v20.Instance.Color;
    end;

    local Folder = Instance.new("Folder", workspace.Debree);
    Folder.Name = script.Parent.Name .. " - final";
    DebrisModule:AddItem(Folder, 3.5);
    local v23 = script.Assets.ImpactStartup:Clone();
    v23:PivotTo(v19);

    if v21 ~= nil then
        v23.Startup.CFrame = v21;
    end;

    v23.Parent = Folder;
    Ouwmit.Emit(v23, v22 ~= nil and ({
        Color = v22,
        ColorWhitelist = { "raycastdust", "Rocks", "Dust" }
    } or nil) or nil);
    local v24 = script.Sounds.PS2thunderblitzNEWCONNECT:Clone();
    v24.Parent = HumanoidRootPart;
    v24:Play();
    DebrisModule:AddItem(v24, v24.TimeLength);
    OuwCraters.Scales({
        Duration = 1,
        Count = 7,
        ScaleMult = 0.5,
        Radius = 5,
        Center = HumanoidRootPart.CFrame
    });
    Cam_Shaker(HumanoidRootPart.Position, "Medium_tiny_shake_preset");
    task.wait(1.01);
    local v25 = script.Assets.LightningSlash:Clone();
    v25:PivotTo(v19);
    v25.Parent = Folder;

    if v21 ~= nil then
        v25.SlashVFXEmit.Startup.CFrame = v21;
        v25.SlashVFXEmit.GroundFX.CFrame = v21;
    end;

    OuwCraters.Scales({
        Duration = 1,
        Count = 7,
        ScaleMult = 0.9,
        Radius = 7,
        Center = HumanoidRootPart.CFrame
    });
    Cam_Shaker(HumanoidRootPart.Position, "Medium_tiny_shake_preset");
    Ouwmit.Emit(v25, v22 ~= nil and ({
        Color = v22,
        ColorWhitelist = { "raycastdust", "Rocks", "Dust" }
    } or nil) or nil);
    task.wait(0.3899999999999999);

    for _, v in ipairs(v15) do
        if v:IsA("Highlight") then
            TweenService:Create(v, TweenInfo.new(1), {
                FillTransparency = 1,
                OutlineTransparency = 1
            }):Play();
        else
            Ouwmit.Enable(v, false);
        end;
    end;

    local v26 = script.Assets.SlashEndEmit:Clone();
    v26:PivotTo(v19);
    v26.Parent = Folder;

    if v21 ~= nil then
        v26.SlashVFXEmit.Startup.CFrame = v21;
        v26.SlashVFXEmit.GroundFX.CFrame = v21;
    end;

    OuwCraters.Scales({
        Duration = 2,
        Count = 10,
        Radius = 12,
        Center = HumanoidRootPart.CFrame
    });
    Cam_Shaker(HumanoidRootPart.Position, "Medium_tiny_shake_preset");
    Ouwmit.Emit(v26, v22 ~= nil and ({
        Color = v22,
        ColorWhitelist = { "raycastdust", "Rocks", "Dust" }
    } or nil) or nil);
end;